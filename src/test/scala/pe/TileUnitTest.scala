package pe

import chisel3._
import chisel3.util._
import chisel3.iotesters
import chisel3.iotesters.{ChiselFlatSpec, Driver, PeekPokeTester}


class TileModuleTester(c: Tile) extends PeekPokeTester(c) {
    def printVec[T <: BigInt](v: Seq[T]) = {
        for(i <- 0 until v.length){
            print(v(i).toInt + " ")
        }
        println("")
    }

    def pokeVec[T <: Bits](v: Vec[T], s: Seq[T]) = {
        for(i <- 0 until s.size){
            poke(v(i), s(i))
        }
    }

    poke(c.io.weightEnable, true.B)
    poke(c.io.typeSelection, 0.U)
    pokeVec(c.io.weightsFlattened, Seq(5.U, 2.U, 1.U, 2.U))

    private var inputs = Seq(4.U, 0.U)
    for (i <- 0 until inputs.size) {
        poke(c.io.inputs(i), inputs(i))
    }

    step(1)
    printVec(peek(c.io.outputs))
    pokeVec(c.io.inputs, Seq(3.U, 2.U))

    step(1)
    printVec(peek(c.io.outputs))
    pokeVec(c.io.inputs, Seq(0.U, 1.U))

    step(1)
    printVec(peek(c.io.outputs))
    pokeVec(c.io.inputs, Seq(0.U, 0.U))
    step(1)

    printVec(peek(c.io.outputs))
}

// Executor
class TileFlatSpec extends ChiselFlatSpec {
    chisel3.iotesters.Driver.execute(
        Array("--backend-name", "verilator", "--is-verbose"),
        () => new Tile(32, 2, 2, true)
    ) { c =>new TileModuleTester(c)
    } should be(true)
}

object TileMain extends App {
    iotesters.Driver.execute(args, () => new Tile(32, 2, 2, true)) {
        c => new TileModuleTester(c)
    }
}
