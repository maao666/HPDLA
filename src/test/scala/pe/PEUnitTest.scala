package pe

import chisel3._
import chisel3.util._
import chisel3.iotesters
import chisel3.iotesters.{ChiselFlatSpec, Driver, PeekPokeTester}

class PEModuleTester(c: ProcessingElement, maxIterations: Int) extends PeekPokeTester(c) {
  val weight = 5;
  var partialSum = 3;
  for (types <- 0 until 2) {
    //init
    poke(c.io.typeSelection, types)
    //test unlocking the weight
    poke(c.io.weight, weight)
    poke(c.io.unlockWeight, true.B)
    step(1)

    //test locking the weight
    poke(c.io.unlockWeight, false.B)
    poke(c.io.weight, weight + 1)
    expect(c.io.forwardedWeight, weight)

    //test forwarding the weight to the next PE
    poke(c.io.unlockWeight, true.B)
    for (i <- 0 until weight) {
      poke(c.io.weight, i)
      if (i > 1) {
        expect(c.io.forwardedWeight, i - 1)
      }
      step(1)
      expect(c.io.forwardedWeight, i)
    }

    //test locking the weight (stop flowing)
    poke(c.io.weight, weight)
    step(1)
    poke(c.io.unlockWeight, false.B)
    for (i <- 0 until weight) {
      poke(c.io.weight, i)
      step(1)
      expect(c.io.forwardedWeight, weight)
    }

    //test generating partial sum
    poke(c.io.weight, weight)
    for (i <- 0 until maxIterations) {
      poke(c.io.input, i)
      poke(c.io.inPartialSum, partialSum)
      if (i > 1) {
        expect(c.io.forwardedInput, i - 1)
      }
      step(1)
      expect(c.io.forwardedInput, i)
      expect(c.io.outPartialSum, weight * i + partialSum)
      partialSum = peek(c.io.outPartialSum).toInt
      println("  **Current Partial Sum of PE: " + partialSum)
    }
    types match {
      case 0 => println("*** Unsigned Integer tests PASS")
      case 1 => println("*** Signed Integer tests PASS")
      case _ => println("*** Unexpected/Undefined type mode!")
    }
  }
  println("\n*** WOW The PE passed all test cases! ***")
}

// Executor
class PEFlatSpec extends ChiselFlatSpec {
  chisel3.iotesters.Driver.execute(
    Array("--backend-name", "verilator", "--is-verbose"),
    () => new ProcessingElement(16, true)
  ) { c =>new PEModuleTester(c, 10)
  } should be(true)
}
