package pe

import chisel3._
import chisel3.util._

class PEWeightBackend(width: Int) extends Module {
    require(width > 0)
    val io = IO(new Bundle {
        val propagate = Input(Bool())
        val weightIn = Input(Bits(width.W))
        val weightOut = Output(Bits(width.W))
    })

    val weightReg = Reg(Bits(width.W))

    //weight propagation
    weightReg := Mux(io.propagate === true.B, io.weightIn, weightReg)
    io.weightOut := weightReg

}
