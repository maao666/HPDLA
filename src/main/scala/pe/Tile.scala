package pe

import chisel3._
import chisel3.util._

class Tile(val width: Int, val rows: Int, val columns: Int, val fpSupported: Boolean) extends Module {
    val io = IO(new Bundle{
        val inputs = Input(Vec(rows, Bits(width.W)))
        val outputs = Output(Vec(columns, Bits(width.W)))

        val weightsFlattened = Input(Vec(rows*columns, Bits(width.W)))
        val weightEnable = Input(Bool())

        val typeSelection = Input(if (fpSupported) UInt(2.W) else UInt(1.W))
    })

    //initialize the tile matrix
    val matrix = Array.fill(rows,columns)(Module(new ProcessingElement(width, fpSupported)))

    //val matrix = Array.ofDim[Module](rows, columns)

    //globally
    for (i <- 0 to rows-1) {
        for ( j <- 0 to columns-1) {
            val pe = matrix(i)(j)
            pe.io.unlockWeight <> io.weightEnable
            pe.io.typeSelection <> io.typeSelection
            pe.io.weight <> io.weightsFlattened(i*columns + j)
        }
    }

    //input <> the first column of PE
    for (i <- 0 to rows-1) {
        val pe = matrix(i)(0)
        pe.io.input <> io.inputs(i)
    }

    //0 <> the first row of PE
    for (j <- 0 to columns-1) {
        val topPE = matrix(0)(j)
        topPE.io.inPartialSum := 0.U
        if(fpSupported)
            topPE.io.inCompensation := 0.U
        val bottomPE = matrix(rows-1)(j)
        bottomPE.io.outPartialSum <> io.outputs(j)
    }

    //Horizontal inter-PE connections
    for (i <- 0 to rows-1) {
        for (j <- 0 to columns-2) {
            val leftPE = matrix(i)(j)
            val rightPE = matrix(i)(j+1)
            leftPE.io.forwardedInput <> rightPE.io.input
        }
    }

    //Vertical inter-PE connections
    for (j <- 0 to columns-1) {
        for (i <- 0 to rows-2) {
            val upperPE = matrix(i)(j)
            val lowerPE = matrix(i+1)(j)
            upperPE.io.outPartialSum <> lowerPE.io.inPartialSum
            if(fpSupported)
                upperPE.io.outCompensation <> lowerPE.io.inCompensation
        }
    }

}

object TileDriver extends App {
    chisel3.Driver.execute(args, () => new Tile(32, 2, 2, true))
}
