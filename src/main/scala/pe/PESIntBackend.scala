package pe

import chisel3._
import chisel3.util._

class PESIntBackend(width: Int) extends Module {
    require(width > 0)
    val io = IO(new Bundle {
        val x1 = Input(SInt(width.W))
        val x2 = Input(SInt(width.W))
        val inPartialSum = Input(SInt(width.W))
        val outPartialSum = Output(SInt(width.W))
    })

    val resultReg = Reg(SInt(width.W))
    io.outPartialSum := resultReg
    val opResult = (io.x1.asSInt * io.x2.asSInt)(width-1,0).asSInt()
    //println(io.inPartialSum.getWidth)
    //println(chiselTypeOf(opResult))
    val result = (opResult + io.inPartialSum.asSInt())
    resultReg := result.asTypeOf(resultReg)

}
