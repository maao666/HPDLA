package pe

import scala.collection.mutable.ListBuffer
import scala.math.pow
import chisel3._
import chisel3.util._
import chisel3.iotesters
import chisel3.iotesters.{ChiselFlatSpec, Driver, PeekPokeTester}


class TileModuleTester(c: Tile, input_arr: Array[Array[Int]], weight_arr: Array[Int]) extends PeekPokeTester(c) {
    def printVec[T <: BigInt](v: Seq[T]) = {
        for(i <- 0 until v.length){
            print(" " + v(i).toInt)
        }
        print("\n")
    }

    def pokeVec[T <: Bits](v: Vec[T], s: Seq[T]) = {
        for(i <- 0 until s.size){
            poke(v(i), s(i))
        }
    }

    def generateInputs(cycle: Int, input_arr: Array[Array[Int]]):Seq[UInt] = {
        val cycleOffset = 0
        val m = input_arr.size
        val n = input_arr(0).size
        var results = new ListBuffer[UInt]()

        for(j <- 0 until input_arr(0).size){
            var currentRow = cycle + cycleOffset - j
            //println("Current Row: " + currentRow)
            if (currentRow < 0 || currentRow >= m)
                results += 0.U
            else
                results += input_arr(currentRow)(j).U
        }
        val result = results.toSeq
        /*for debugging purpose
        println("Generated inputs:")
        for(element<-result){  
            print(element.toInt+" ")
        }
        */
        return result
    }

    def mapToUint(arr: Array[Int]): Seq[UInt] = {
        val s: Seq[UInt] = arr.map(x => x.U)
        return s
    }

    val rows = input_arr.size
    val cols = weight_arr.size / input_arr.size
    var resultMatrix = Array.ofDim[Int](rows, cols)

    poke(c.io.weightEnable, true.B)
    poke(c.io.typeSelection, 0.U)
    pokeVec(c.io.weightsFlattened, mapToUint(weight_arr))
    var cycleCount = 0

    for(i <- 0 until 3*rows-2){
        pokeVec(c.io.inputs, generateInputs(cycleCount, input_arr))
        cycleCount += 1

        step(1)
        print("Cycle Count "+ cycleCount + ": ")
        printVec(peek(c.io.outputs))

        for(j <- 0 until cols){
            if(rows+j<=cycleCount && cycleCount<rows*2+j)
                resultMatrix(cycleCount-rows-j)(j) = peek(c.io.outputs)(j).toInt
        }
    }

    println("=== Result matrix ===")
    resultMatrix.foreach(row => {
        row.foreach(e => print(f"$e%4d "))
        print("\n")
        }
    )
}

// Executor
/*
class TileFlatSpec extends ChiselFlatSpec {
    chisel3.iotesters.Driver.execute(
        Array("--backend-name", "verilator", "--is-verbose"),
        () => new Tile(32, 2, 2, true)
    ) { c =>new TileModuleTester(c)
    } should be(true)
}
*/
