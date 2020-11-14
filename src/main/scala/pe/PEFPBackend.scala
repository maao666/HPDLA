package pe

import chisel3._
import chisel3.util._

class PEFPBackend(width: Int) extends Module {
    require(width > 0)
    val io = IO(new Bundle {
        val x1 = Input(Bits(width.W))
        val x2 = Input(Bits(width.W))
        val inPartialSum = Input(Bits(width.W))
        val outPartialSum = Output(Bits(width.W))
        val inCompensation = Input(Bits(width.W))
        val outCompensation = Output(Bits(width.W))
    })

    val resultReg = Reg(Bits(width.W))
    io.outPartialSum := resultReg
    val compensationReg = Reg(Bits(width.W))
    io.outCompensation := compensationReg
    
    resultReg := 0.U

}
