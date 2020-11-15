;buildInfoPackage: chisel3, version: 3.3.2, scalaVersion: 2.12.11, sbtVersion: 1.3.10
circuit ProcessingElement : 
  module PEWeightBackend : 
    input clock : Clock
    input reset : Reset
    output io : {flip propagate : UInt<1>, flip weightIn : UInt<32>, weightOut : UInt<32>}
    
    reg weightReg : UInt<32>, clock @[PEWeightBackend.scala 14:24]
    node _T = eq(io.propagate, UInt<1>("h01")) @[PEWeightBackend.scala 17:35]
    node _T_1 = mux(_T, io.weightIn, weightReg) @[PEWeightBackend.scala 17:21]
    weightReg <= _T_1 @[PEWeightBackend.scala 17:15]
    io.weightOut <= weightReg @[PEWeightBackend.scala 18:18]
    
  module PEUIntBackend : 
    input clock : Clock
    input reset : Reset
    output io : {flip x1 : UInt<32>, flip x2 : UInt<32>, flip inPartialSum : UInt<32>, outPartialSum : UInt<32>}
    
    reg resultReg : UInt<32>, clock @[PEUIntBackend.scala 15:24]
    io.outPartialSum <= resultReg @[PEUIntBackend.scala 16:22]
    node _T = mul(io.x1, io.x2) @[PEUIntBackend.scala 17:33]
    node _T_1 = add(_T, io.inPartialSum) @[PEUIntBackend.scala 17:50]
    node _T_2 = tail(_T_1, 1) @[PEUIntBackend.scala 17:50]
    resultReg <= _T_2 @[PEUIntBackend.scala 17:15]
    
  module PESIntBackend : 
    input clock : Clock
    input reset : Reset
    output io : {flip x1 : SInt<32>, flip x2 : SInt<32>, flip inPartialSum : SInt<32>, outPartialSum : SInt<32>}
    
    reg resultReg : SInt<32>, clock @[PESIntBackend.scala 15:24]
    io.outPartialSum <= resultReg @[PESIntBackend.scala 16:22]
    node _T = mul(io.x1, io.x2) @[PESIntBackend.scala 17:34]
    node _T_1 = bits(_T, 31, 0) @[PESIntBackend.scala 17:49]
    node opResult = asSInt(_T_1) @[PESIntBackend.scala 17:67]
    node _T_2 = add(opResult, io.inPartialSum) @[PESIntBackend.scala 20:28]
    node _T_3 = tail(_T_2, 1) @[PESIntBackend.scala 20:28]
    node result = asSInt(_T_3) @[PESIntBackend.scala 20:28]
    wire _T_4 : SInt<32> @[PESIntBackend.scala 21:33]
    node _T_5 = asUInt(result) @[PESIntBackend.scala 21:33]
    node _T_6 = asSInt(_T_5) @[PESIntBackend.scala 21:33]
    _T_4 <= _T_6 @[PESIntBackend.scala 21:33]
    resultReg <= _T_4 @[PESIntBackend.scala 21:15]
    
  module PEFPBackend : 
    input clock : Clock
    input reset : Reset
    output io : {flip x1 : UInt<32>, flip x2 : UInt<32>, flip inPartialSum : UInt<32>, outPartialSum : UInt<32>, flip inCompensation : UInt<32>, outCompensation : UInt<32>}
    
    reg resultReg : UInt<32>, clock @[PEFPBackend.scala 17:24]
    io.outPartialSum <= resultReg @[PEFPBackend.scala 18:22]
    reg compensationReg : UInt<32>, clock @[PEFPBackend.scala 19:30]
    io.outCompensation <= compensationReg @[PEFPBackend.scala 20:24]
    resultReg <= UInt<1>("h00") @[PEFPBackend.scala 22:15]
    
  module ProcessingElement : 
    input clock : Clock
    input reset : UInt<1>
    output io : {flip input : UInt<32>, flip weight : UInt<32>, flip unlockWeight : UInt<1>, flip inPartialSum : UInt<32>, flip typeSelection : UInt<2>, flip inCompensation : UInt<32>, outCompensation : UInt<32>, outPartialSum : UInt<32>, forwardedInput : UInt<32>, forwardedWeight : UInt<32>}
    
    inst WeightBackend of PEWeightBackend @[PE.scala 23:31]
    WeightBackend.clock <= clock
    WeightBackend.reset <= reset
    WeightBackend.io.propagate <= io.unlockWeight @[PE.scala 25:32]
    WeightBackend.io.weightIn <= io.weight @[PE.scala 26:31]
    io.forwardedWeight <= WeightBackend.io.weightOut @[PE.scala 27:24]
    inst uIntBackend of PEUIntBackend @[PE.scala 31:29]
    uIntBackend.clock <= clock
    uIntBackend.reset <= reset
    uIntBackend.io.x1 <= io.weight @[PE.scala 32:23]
    uIntBackend.io.x2 <= io.input @[PE.scala 33:23]
    uIntBackend.io.inPartialSum <= io.inPartialSum @[PE.scala 34:33]
    inst sIntBackend of PESIntBackend @[PE.scala 37:29]
    sIntBackend.clock <= clock
    sIntBackend.reset <= reset
    node _T = asSInt(io.weight) @[PE.scala 38:42]
    sIntBackend.io.x1 <= _T @[PE.scala 38:23]
    node _T_1 = asSInt(io.input) @[PE.scala 39:41]
    sIntBackend.io.x2 <= _T_1 @[PE.scala 39:23]
    node _T_2 = asSInt(io.inPartialSum) @[PE.scala 40:58]
    sIntBackend.io.inPartialSum <= _T_2 @[PE.scala 40:33]
    wire fpResult : UInt<32> @[PE.scala 43:41]
    inst PEFPBackend of PEFPBackend @[PE.scala 45:31]
    PEFPBackend.clock <= clock
    PEFPBackend.reset <= reset
    PEFPBackend.io.x1 <= io.weight @[PE.scala 46:25]
    PEFPBackend.io.x2 <= io.input @[PE.scala 47:25]
    PEFPBackend.io.inPartialSum <= io.inPartialSum @[PE.scala 48:35]
    PEFPBackend.io.inCompensation <= io.inCompensation @[PE.scala 49:37]
    io.outCompensation <= PEFPBackend.io.outCompensation @[PE.scala 50:28]
    fpResult <= PEFPBackend.io.outPartialSum @[PE.scala 51:18]
    reg _T_3 : UInt, clock @[PE.scala 55:33]
    _T_3 <= io.input @[PE.scala 55:33]
    io.forwardedInput <= _T_3 @[PE.scala 55:23]
    node _T_4 = eq(io.typeSelection, UInt<1>("h01")) @[PE.scala 58:27]
    when _T_4 : @[PE.scala 58:36]
      node _T_5 = asUInt(sIntBackend.io.outPartialSum) @[PE.scala 60:64]
      io.outPartialSum <= _T_5 @[PE.scala 60:26]
      skip @[PE.scala 58:36]
    else : @[PE.scala 61:42]
      node _T_6 = eq(io.typeSelection, UInt<1>("h00")) @[PE.scala 61:33]
      when _T_6 : @[PE.scala 61:42]
        io.outPartialSum <= uIntBackend.io.outPartialSum @[PE.scala 63:26]
        skip @[PE.scala 61:42]
      else : @[PE.scala 64:16]
        io.outPartialSum <= fpResult @[PE.scala 66:42]
        skip @[PE.scala 64:16]
    
