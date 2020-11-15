package pe

import scala.io.Source
import chisel3._
import chisel3.util._
import chisel3.iotesters
import chisel3.iotesters.{ChiselFlatSpec, Driver, PeekPokeTester}

object TileMain extends App {
    def loadMatrix(filename: String) : Array[Array[Int]] = {
        val rows = scala.io.Source.fromFile(filename).getLines.size
        val cols = scala.io.Source.fromFile(filename).getLines.toArray.flatMap(_.split(" ")).size/rows
        println("Got "+rows+" rows and "+cols+" columns in "+filename)
        return scala.io.Source.fromFile(filename).getLines.map(_.split(" ").map(_.toInt)).toArray
    }

    def loadFlattenedMatrix(filename: String) : Array[Int] = {
        val lines = scala.io.Source.fromFile(filename).getLines
        return lines.toArray.flatMap(_.split(" ")).map(_.toInt)
    }

    val weights = loadFlattenedMatrix("weights.txt")
    val inputs = loadMatrix("inputs.txt")
    

    val m = inputs.size
    val n = weights.size / inputs.size
    println("m and n: "+m+" "+n)
    val width = 32
    iotesters.Driver.execute(args, () => new Tile(width, m, n, true)) {
        c => new TileModuleTester(c, inputs, weights)
    }
}
