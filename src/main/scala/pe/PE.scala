package pe

import chisel3._
import chisel3.util._
import chisel3.iotesters.{ChiselFlatSpec, Driver, PeekPokeTester}


class ProcessingElement(width: Int, val fpSupported: Boolean) extends Module {
  require(width > 0)
  val io = IO(new Bundle {
    val input = Input(Bits(width.W))
    val weight = Input(Bits(width.W))
    val unlockWeight = Input(Bool())
    val inPartialSum = Input(Bits(width.W))
    val typeSelection = Input(if (fpSupported) UInt(2.W) else UInt(1.W)) //00 for UInt, 01 for SInt, 10 for FP, 11 reserved
    val inCompensation = Input(if (fpSupported) Bits(width.W) else Bits(0.W)) //only meaningful for fp
    val outCompensation = Output(if (fpSupported) Bits(width.W) else Bits(0.W)) //only meaningful for fp
    val outPartialSum = Output(Bits(width.W))
    val forwardedInput = Output(UInt(width.W))
    val forwardedWeight = Output(UInt(width.W))
  })

  //registers
  val resultReg = Reg(Bits(width.W))
  val weightReg = Reg(Bits(width.W))
  val compensationReg = if (fpSupported) Reg(Bits(width.W)) else Reg(Bits(0.W))

  //weight propagation
  weightReg := Mux(io.unlockWeight === true.B, io.weight, weightReg)
  io.forwardedWeight := weightReg

  //input propagation
  io.forwardedInput := RegNext(io.input)

  //partial sum
  when(io.typeSelection === 1.U) {
    //SInt
    val opResult = (weightReg.asSInt * io.input.asSInt)(width-1,0).asSInt()
    //println(io.inPartialSum.getWidth)
    //println(chiselTypeOf(opResult))
    val result = (opResult + io.inPartialSum.asSInt())
    resultReg := result.asTypeOf(resultReg)
  }.elsewhen(io.typeSelection === 2.U) {
    //TODO: FP
    resultReg := 0.U
  }.otherwise {
    //UInt
    resultReg := weightReg.asUInt() * io.input.asUInt() + io.inPartialSum.asUInt()
  }
  resultReg := weightReg * io.input + io.inPartialSum
  io.outPartialSum := resultReg

  //TODO: compensationReg is always 0
  io.outCompensation := compensationReg
}

object PEDriver extends App {
  chisel3.Driver.execute(args, () => new ProcessingElement(32, true))
}
