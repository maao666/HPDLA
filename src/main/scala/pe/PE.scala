package pe

import chisel3._
import chisel3.util._

class ProcessingElement(width: Int, val fpSupported: Boolean) extends Module {
    require(width > 0)
    val io = IO(new Bundle {
        val input = Input(Bits(width.W))
        val forwardedInput = Output(Bits(width.W))

        val weight = Input(Bits(width.W))
        val unlockWeight = Input(Bool())
        val forwardedWeight = Output(Bits(width.W))

        val inPartialSum = Input(Bits(width.W))
        val outPartialSum = Output(Bits(width.W))
        
        val typeSelection = Input(if (fpSupported) UInt(2.W) else UInt(1.W)) //0 for UInt, 1 for SInt, 2 for FP, 3 disabled
        
        val inCompensation = Input(if (fpSupported) Bits(width.W) else Bits(0.W)) //only meaningful for fp
        val outCompensation = Output(if (fpSupported) Bits(width.W) else Bits(0.W)) //only meaningful for fp
    })

    //Backend modules
    //Weight Backend
    val weightBackend = Module(new PEWeightBackend(width))
    weightBackend.suggestName("WeightBackend")
    weightBackend.io.propagate := io.unlockWeight
    weightBackend.io.weightIn := io.weight
    io.forwardedWeight := weightBackend.io.weightOut
    val weight = weightBackend.io.weightOut

    //UInt Backend
    val uIntBackend = Module(new PEUIntBackend(width))
    uIntBackend.io.x1 := io.weight.asUInt()
    uIntBackend.io.x2 := io.input.asUInt()
    uIntBackend.io.inPartialSum := io.inPartialSum.asUInt()

    //SInt Backend
    val sIntBackend = Module(new PESIntBackend(width))
    sIntBackend.io.x1 := io.weight.asSInt()
    sIntBackend.io.x2 := io.input.asSInt()
    sIntBackend.io.inPartialSum := io.inPartialSum.asSInt()

    //FP Backend
    val fpResult = if (fpSupported) Wire(Bits(width.W)) else Wire(Bits(0.W))
    if(fpSupported){
        val fpBackend = Module(new PEFPBackend(width))
        fpBackend.io.x1 := io.weight
        fpBackend.io.x2 := io.input
        fpBackend.io.inPartialSum := io.inPartialSum
        fpBackend.io.inCompensation := io.inCompensation
        io.outCompensation := fpBackend.io.outCompensation
        fpResult <> fpBackend.io.outPartialSum
    }

    //Input propagation
    io.forwardedInput := RegNext(io.input)

    //Partial sum result selection
    when(io.typeSelection === 1.U) {
        //SInt
        io.outPartialSum <> sIntBackend.io.outPartialSum.asUInt()
    }.elsewhen(io.typeSelection === 0.U) {
        //UInt
        io.outPartialSum <> uIntBackend.io.outPartialSum
    }.otherwise{
        //FP
        if(fpSupported) io.outPartialSum <> fpResult
        else {
            //Hopefully never happens
            io.outPartialSum := 0.U
        }
    }
}

object PEDriver extends App {
    chisel3.Driver.execute(args, () => new ProcessingElement(32, true))
}
