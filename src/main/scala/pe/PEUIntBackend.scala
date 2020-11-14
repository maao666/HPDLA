package pe

import chisel3._
import chisel3.util._

class PEUIntBackend(width: Int) extends Module {
    require(width > 0)
    val io = IO(new Bundle {
        val x1 = Input(UInt(width.W))
        val x2 = Input(UInt(width.W))
        val inPartialSum = Input(UInt(width.W))
        val outPartialSum = Output(UInt(width.W))
    })

    val resultReg = Reg(UInt(width.W))
    io.outPartialSum := resultReg
    resultReg := io.x1.asUInt() * io.x2.asUInt() + io.inPartialSum.asUInt()

}
