package pe

import chisel3._

/**
  * This provides an alternate way to run tests, by executing then as a main
  * From sbt (Note: the test: prefix is because this main is under the test package hierarchy):
  * {{{
  * test:runMain pe.PEMain
  * }}}
  * To see all command line options use:
  * {{{
  * test:runMain pe.PEMain --help
  * }}}
  * To run with verilator:
  * {{{
  * test:runMain pe.PEMain --backend-name verilator
  * }}}
  * To run with verilator from your terminal shell use:
  * {{{
  * sbt 'test:runMain pe.PEMain --backend-name verilator'
  * }}}
  */
object PEMain extends App {
  iotesters.Driver.execute(args, () => new ProcessingElement(32, true)) {
    c => new PEModuleTester(c, 40)
  }
}

/**
  * This provides a way to run the firrtl-interpreter REPL (or shell)
  * on the lowered firrtl generated by your circuit. You will be placed
  * in an interactive shell. This can be very helpful as a debugging
  * technique. Type help to see a list of commands.
  *
  * To run from sbt
  * {{{
  * test:runMain gcd.PERepl
  * }}}
  * To run from sbt and see the half a zillion options try
  * {{{
  * test:runMain gcd.PERepl --help
  * }}}
  */
object PERepl extends App {
  iotesters.Driver.executeFirrtlRepl(args, () => new ProcessingElement(32, true))
}
