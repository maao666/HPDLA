;buildInfoPackage: chisel3, version: 3.3.2, scalaVersion: 2.12.11, sbtVersion: 1.3.10
circuit Tile : 
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
    input reset : Reset
    output io : {flip input : UInt<32>, forwardedInput : UInt<32>, flip weight : UInt<32>, flip unlockWeight : UInt<1>, forwardedWeight : UInt<32>, flip inPartialSum : UInt<32>, outPartialSum : UInt<32>, flip typeSelection : UInt<2>, flip inCompensation : UInt<32>, outCompensation : UInt<32>}
    
    inst WeightBackend of PEWeightBackend @[PE.scala 27:31]
    WeightBackend.clock <= clock
    WeightBackend.reset <= reset
    WeightBackend.io.propagate <= io.unlockWeight @[PE.scala 29:32]
    WeightBackend.io.weightIn <= io.weight @[PE.scala 30:31]
    io.forwardedWeight <= WeightBackend.io.weightOut @[PE.scala 31:24]
    inst uIntBackend of PEUIntBackend @[PE.scala 35:29]
    uIntBackend.clock <= clock
    uIntBackend.reset <= reset
    uIntBackend.io.x1 <= io.weight @[PE.scala 36:23]
    uIntBackend.io.x2 <= io.input @[PE.scala 37:23]
    uIntBackend.io.inPartialSum <= io.inPartialSum @[PE.scala 38:33]
    inst sIntBackend of PESIntBackend @[PE.scala 41:29]
    sIntBackend.clock <= clock
    sIntBackend.reset <= reset
    node _T = asSInt(io.weight) @[PE.scala 42:42]
    sIntBackend.io.x1 <= _T @[PE.scala 42:23]
    node _T_1 = asSInt(io.input) @[PE.scala 43:41]
    sIntBackend.io.x2 <= _T_1 @[PE.scala 43:23]
    node _T_2 = asSInt(io.inPartialSum) @[PE.scala 44:58]
    sIntBackend.io.inPartialSum <= _T_2 @[PE.scala 44:33]
    wire fpResult : UInt<32> @[PE.scala 47:41]
    inst PEFPBackend of PEFPBackend @[PE.scala 49:31]
    PEFPBackend.clock <= clock
    PEFPBackend.reset <= reset
    PEFPBackend.io.x1 <= io.weight @[PE.scala 50:25]
    PEFPBackend.io.x2 <= io.input @[PE.scala 51:25]
    PEFPBackend.io.inPartialSum <= io.inPartialSum @[PE.scala 52:35]
    PEFPBackend.io.inCompensation <= io.inCompensation @[PE.scala 53:37]
    io.outCompensation <= PEFPBackend.io.outCompensation @[PE.scala 54:28]
    fpResult <= PEFPBackend.io.outPartialSum @[PE.scala 55:18]
    reg _T_3 : UInt, clock @[PE.scala 59:33]
    _T_3 <= io.input @[PE.scala 59:33]
    io.forwardedInput <= _T_3 @[PE.scala 59:23]
    node _T_4 = eq(io.typeSelection, UInt<1>("h01")) @[PE.scala 62:27]
    when _T_4 : @[PE.scala 62:36]
      node _T_5 = asUInt(sIntBackend.io.outPartialSum) @[PE.scala 64:64]
      io.outPartialSum <= _T_5 @[PE.scala 64:26]
      skip @[PE.scala 62:36]
    else : @[PE.scala 65:42]
      node _T_6 = eq(io.typeSelection, UInt<1>("h00")) @[PE.scala 65:33]
      when _T_6 : @[PE.scala 65:42]
        io.outPartialSum <= uIntBackend.io.outPartialSum @[PE.scala 67:26]
        skip @[PE.scala 65:42]
      else : @[PE.scala 68:16]
        io.outPartialSum <= fpResult @[PE.scala 70:42]
        skip @[PE.scala 68:16]
    
  module PEWeightBackend_1 : 
    input clock : Clock
    input reset : Reset
    output io : {flip propagate : UInt<1>, flip weightIn : UInt<32>, weightOut : UInt<32>}
    
    reg weightReg : UInt<32>, clock @[PEWeightBackend.scala 14:24]
    node _T = eq(io.propagate, UInt<1>("h01")) @[PEWeightBackend.scala 17:35]
    node _T_1 = mux(_T, io.weightIn, weightReg) @[PEWeightBackend.scala 17:21]
    weightReg <= _T_1 @[PEWeightBackend.scala 17:15]
    io.weightOut <= weightReg @[PEWeightBackend.scala 18:18]
    
  module PEUIntBackend_1 : 
    input clock : Clock
    input reset : Reset
    output io : {flip x1 : UInt<32>, flip x2 : UInt<32>, flip inPartialSum : UInt<32>, outPartialSum : UInt<32>}
    
    reg resultReg : UInt<32>, clock @[PEUIntBackend.scala 15:24]
    io.outPartialSum <= resultReg @[PEUIntBackend.scala 16:22]
    node _T = mul(io.x1, io.x2) @[PEUIntBackend.scala 17:33]
    node _T_1 = add(_T, io.inPartialSum) @[PEUIntBackend.scala 17:50]
    node _T_2 = tail(_T_1, 1) @[PEUIntBackend.scala 17:50]
    resultReg <= _T_2 @[PEUIntBackend.scala 17:15]
    
  module PESIntBackend_1 : 
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
    
  module PEFPBackend_1 : 
    input clock : Clock
    input reset : Reset
    output io : {flip x1 : UInt<32>, flip x2 : UInt<32>, flip inPartialSum : UInt<32>, outPartialSum : UInt<32>, flip inCompensation : UInt<32>, outCompensation : UInt<32>}
    
    reg resultReg : UInt<32>, clock @[PEFPBackend.scala 17:24]
    io.outPartialSum <= resultReg @[PEFPBackend.scala 18:22]
    reg compensationReg : UInt<32>, clock @[PEFPBackend.scala 19:30]
    io.outCompensation <= compensationReg @[PEFPBackend.scala 20:24]
    resultReg <= UInt<1>("h00") @[PEFPBackend.scala 22:15]
    
  module ProcessingElement_1 : 
    input clock : Clock
    input reset : Reset
    output io : {flip input : UInt<32>, forwardedInput : UInt<32>, flip weight : UInt<32>, flip unlockWeight : UInt<1>, forwardedWeight : UInt<32>, flip inPartialSum : UInt<32>, outPartialSum : UInt<32>, flip typeSelection : UInt<2>, flip inCompensation : UInt<32>, outCompensation : UInt<32>}
    
    inst WeightBackend of PEWeightBackend_1 @[PE.scala 27:31]
    WeightBackend.clock <= clock
    WeightBackend.reset <= reset
    WeightBackend.io.propagate <= io.unlockWeight @[PE.scala 29:32]
    WeightBackend.io.weightIn <= io.weight @[PE.scala 30:31]
    io.forwardedWeight <= WeightBackend.io.weightOut @[PE.scala 31:24]
    inst uIntBackend of PEUIntBackend_1 @[PE.scala 35:29]
    uIntBackend.clock <= clock
    uIntBackend.reset <= reset
    uIntBackend.io.x1 <= io.weight @[PE.scala 36:23]
    uIntBackend.io.x2 <= io.input @[PE.scala 37:23]
    uIntBackend.io.inPartialSum <= io.inPartialSum @[PE.scala 38:33]
    inst sIntBackend of PESIntBackend_1 @[PE.scala 41:29]
    sIntBackend.clock <= clock
    sIntBackend.reset <= reset
    node _T = asSInt(io.weight) @[PE.scala 42:42]
    sIntBackend.io.x1 <= _T @[PE.scala 42:23]
    node _T_1 = asSInt(io.input) @[PE.scala 43:41]
    sIntBackend.io.x2 <= _T_1 @[PE.scala 43:23]
    node _T_2 = asSInt(io.inPartialSum) @[PE.scala 44:58]
    sIntBackend.io.inPartialSum <= _T_2 @[PE.scala 44:33]
    wire fpResult : UInt<32> @[PE.scala 47:41]
    inst PEFPBackend of PEFPBackend_1 @[PE.scala 49:31]
    PEFPBackend.clock <= clock
    PEFPBackend.reset <= reset
    PEFPBackend.io.x1 <= io.weight @[PE.scala 50:25]
    PEFPBackend.io.x2 <= io.input @[PE.scala 51:25]
    PEFPBackend.io.inPartialSum <= io.inPartialSum @[PE.scala 52:35]
    PEFPBackend.io.inCompensation <= io.inCompensation @[PE.scala 53:37]
    io.outCompensation <= PEFPBackend.io.outCompensation @[PE.scala 54:28]
    fpResult <= PEFPBackend.io.outPartialSum @[PE.scala 55:18]
    reg _T_3 : UInt, clock @[PE.scala 59:33]
    _T_3 <= io.input @[PE.scala 59:33]
    io.forwardedInput <= _T_3 @[PE.scala 59:23]
    node _T_4 = eq(io.typeSelection, UInt<1>("h01")) @[PE.scala 62:27]
    when _T_4 : @[PE.scala 62:36]
      node _T_5 = asUInt(sIntBackend.io.outPartialSum) @[PE.scala 64:64]
      io.outPartialSum <= _T_5 @[PE.scala 64:26]
      skip @[PE.scala 62:36]
    else : @[PE.scala 65:42]
      node _T_6 = eq(io.typeSelection, UInt<1>("h00")) @[PE.scala 65:33]
      when _T_6 : @[PE.scala 65:42]
        io.outPartialSum <= uIntBackend.io.outPartialSum @[PE.scala 67:26]
        skip @[PE.scala 65:42]
      else : @[PE.scala 68:16]
        io.outPartialSum <= fpResult @[PE.scala 70:42]
        skip @[PE.scala 68:16]
    
  module PEWeightBackend_2 : 
    input clock : Clock
    input reset : Reset
    output io : {flip propagate : UInt<1>, flip weightIn : UInt<32>, weightOut : UInt<32>}
    
    reg weightReg : UInt<32>, clock @[PEWeightBackend.scala 14:24]
    node _T = eq(io.propagate, UInt<1>("h01")) @[PEWeightBackend.scala 17:35]
    node _T_1 = mux(_T, io.weightIn, weightReg) @[PEWeightBackend.scala 17:21]
    weightReg <= _T_1 @[PEWeightBackend.scala 17:15]
    io.weightOut <= weightReg @[PEWeightBackend.scala 18:18]
    
  module PEUIntBackend_2 : 
    input clock : Clock
    input reset : Reset
    output io : {flip x1 : UInt<32>, flip x2 : UInt<32>, flip inPartialSum : UInt<32>, outPartialSum : UInt<32>}
    
    reg resultReg : UInt<32>, clock @[PEUIntBackend.scala 15:24]
    io.outPartialSum <= resultReg @[PEUIntBackend.scala 16:22]
    node _T = mul(io.x1, io.x2) @[PEUIntBackend.scala 17:33]
    node _T_1 = add(_T, io.inPartialSum) @[PEUIntBackend.scala 17:50]
    node _T_2 = tail(_T_1, 1) @[PEUIntBackend.scala 17:50]
    resultReg <= _T_2 @[PEUIntBackend.scala 17:15]
    
  module PESIntBackend_2 : 
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
    
  module PEFPBackend_2 : 
    input clock : Clock
    input reset : Reset
    output io : {flip x1 : UInt<32>, flip x2 : UInt<32>, flip inPartialSum : UInt<32>, outPartialSum : UInt<32>, flip inCompensation : UInt<32>, outCompensation : UInt<32>}
    
    reg resultReg : UInt<32>, clock @[PEFPBackend.scala 17:24]
    io.outPartialSum <= resultReg @[PEFPBackend.scala 18:22]
    reg compensationReg : UInt<32>, clock @[PEFPBackend.scala 19:30]
    io.outCompensation <= compensationReg @[PEFPBackend.scala 20:24]
    resultReg <= UInt<1>("h00") @[PEFPBackend.scala 22:15]
    
  module ProcessingElement_2 : 
    input clock : Clock
    input reset : Reset
    output io : {flip input : UInt<32>, forwardedInput : UInt<32>, flip weight : UInt<32>, flip unlockWeight : UInt<1>, forwardedWeight : UInt<32>, flip inPartialSum : UInt<32>, outPartialSum : UInt<32>, flip typeSelection : UInt<2>, flip inCompensation : UInt<32>, outCompensation : UInt<32>}
    
    inst WeightBackend of PEWeightBackend_2 @[PE.scala 27:31]
    WeightBackend.clock <= clock
    WeightBackend.reset <= reset
    WeightBackend.io.propagate <= io.unlockWeight @[PE.scala 29:32]
    WeightBackend.io.weightIn <= io.weight @[PE.scala 30:31]
    io.forwardedWeight <= WeightBackend.io.weightOut @[PE.scala 31:24]
    inst uIntBackend of PEUIntBackend_2 @[PE.scala 35:29]
    uIntBackend.clock <= clock
    uIntBackend.reset <= reset
    uIntBackend.io.x1 <= io.weight @[PE.scala 36:23]
    uIntBackend.io.x2 <= io.input @[PE.scala 37:23]
    uIntBackend.io.inPartialSum <= io.inPartialSum @[PE.scala 38:33]
    inst sIntBackend of PESIntBackend_2 @[PE.scala 41:29]
    sIntBackend.clock <= clock
    sIntBackend.reset <= reset
    node _T = asSInt(io.weight) @[PE.scala 42:42]
    sIntBackend.io.x1 <= _T @[PE.scala 42:23]
    node _T_1 = asSInt(io.input) @[PE.scala 43:41]
    sIntBackend.io.x2 <= _T_1 @[PE.scala 43:23]
    node _T_2 = asSInt(io.inPartialSum) @[PE.scala 44:58]
    sIntBackend.io.inPartialSum <= _T_2 @[PE.scala 44:33]
    wire fpResult : UInt<32> @[PE.scala 47:41]
    inst PEFPBackend of PEFPBackend_2 @[PE.scala 49:31]
    PEFPBackend.clock <= clock
    PEFPBackend.reset <= reset
    PEFPBackend.io.x1 <= io.weight @[PE.scala 50:25]
    PEFPBackend.io.x2 <= io.input @[PE.scala 51:25]
    PEFPBackend.io.inPartialSum <= io.inPartialSum @[PE.scala 52:35]
    PEFPBackend.io.inCompensation <= io.inCompensation @[PE.scala 53:37]
    io.outCompensation <= PEFPBackend.io.outCompensation @[PE.scala 54:28]
    fpResult <= PEFPBackend.io.outPartialSum @[PE.scala 55:18]
    reg _T_3 : UInt, clock @[PE.scala 59:33]
    _T_3 <= io.input @[PE.scala 59:33]
    io.forwardedInput <= _T_3 @[PE.scala 59:23]
    node _T_4 = eq(io.typeSelection, UInt<1>("h01")) @[PE.scala 62:27]
    when _T_4 : @[PE.scala 62:36]
      node _T_5 = asUInt(sIntBackend.io.outPartialSum) @[PE.scala 64:64]
      io.outPartialSum <= _T_5 @[PE.scala 64:26]
      skip @[PE.scala 62:36]
    else : @[PE.scala 65:42]
      node _T_6 = eq(io.typeSelection, UInt<1>("h00")) @[PE.scala 65:33]
      when _T_6 : @[PE.scala 65:42]
        io.outPartialSum <= uIntBackend.io.outPartialSum @[PE.scala 67:26]
        skip @[PE.scala 65:42]
      else : @[PE.scala 68:16]
        io.outPartialSum <= fpResult @[PE.scala 70:42]
        skip @[PE.scala 68:16]
    
  module PEWeightBackend_3 : 
    input clock : Clock
    input reset : Reset
    output io : {flip propagate : UInt<1>, flip weightIn : UInt<32>, weightOut : UInt<32>}
    
    reg weightReg : UInt<32>, clock @[PEWeightBackend.scala 14:24]
    node _T = eq(io.propagate, UInt<1>("h01")) @[PEWeightBackend.scala 17:35]
    node _T_1 = mux(_T, io.weightIn, weightReg) @[PEWeightBackend.scala 17:21]
    weightReg <= _T_1 @[PEWeightBackend.scala 17:15]
    io.weightOut <= weightReg @[PEWeightBackend.scala 18:18]
    
  module PEUIntBackend_3 : 
    input clock : Clock
    input reset : Reset
    output io : {flip x1 : UInt<32>, flip x2 : UInt<32>, flip inPartialSum : UInt<32>, outPartialSum : UInt<32>}
    
    reg resultReg : UInt<32>, clock @[PEUIntBackend.scala 15:24]
    io.outPartialSum <= resultReg @[PEUIntBackend.scala 16:22]
    node _T = mul(io.x1, io.x2) @[PEUIntBackend.scala 17:33]
    node _T_1 = add(_T, io.inPartialSum) @[PEUIntBackend.scala 17:50]
    node _T_2 = tail(_T_1, 1) @[PEUIntBackend.scala 17:50]
    resultReg <= _T_2 @[PEUIntBackend.scala 17:15]
    
  module PESIntBackend_3 : 
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
    
  module PEFPBackend_3 : 
    input clock : Clock
    input reset : Reset
    output io : {flip x1 : UInt<32>, flip x2 : UInt<32>, flip inPartialSum : UInt<32>, outPartialSum : UInt<32>, flip inCompensation : UInt<32>, outCompensation : UInt<32>}
    
    reg resultReg : UInt<32>, clock @[PEFPBackend.scala 17:24]
    io.outPartialSum <= resultReg @[PEFPBackend.scala 18:22]
    reg compensationReg : UInt<32>, clock @[PEFPBackend.scala 19:30]
    io.outCompensation <= compensationReg @[PEFPBackend.scala 20:24]
    resultReg <= UInt<1>("h00") @[PEFPBackend.scala 22:15]
    
  module ProcessingElement_3 : 
    input clock : Clock
    input reset : Reset
    output io : {flip input : UInt<32>, forwardedInput : UInt<32>, flip weight : UInt<32>, flip unlockWeight : UInt<1>, forwardedWeight : UInt<32>, flip inPartialSum : UInt<32>, outPartialSum : UInt<32>, flip typeSelection : UInt<2>, flip inCompensation : UInt<32>, outCompensation : UInt<32>}
    
    inst WeightBackend of PEWeightBackend_3 @[PE.scala 27:31]
    WeightBackend.clock <= clock
    WeightBackend.reset <= reset
    WeightBackend.io.propagate <= io.unlockWeight @[PE.scala 29:32]
    WeightBackend.io.weightIn <= io.weight @[PE.scala 30:31]
    io.forwardedWeight <= WeightBackend.io.weightOut @[PE.scala 31:24]
    inst uIntBackend of PEUIntBackend_3 @[PE.scala 35:29]
    uIntBackend.clock <= clock
    uIntBackend.reset <= reset
    uIntBackend.io.x1 <= io.weight @[PE.scala 36:23]
    uIntBackend.io.x2 <= io.input @[PE.scala 37:23]
    uIntBackend.io.inPartialSum <= io.inPartialSum @[PE.scala 38:33]
    inst sIntBackend of PESIntBackend_3 @[PE.scala 41:29]
    sIntBackend.clock <= clock
    sIntBackend.reset <= reset
    node _T = asSInt(io.weight) @[PE.scala 42:42]
    sIntBackend.io.x1 <= _T @[PE.scala 42:23]
    node _T_1 = asSInt(io.input) @[PE.scala 43:41]
    sIntBackend.io.x2 <= _T_1 @[PE.scala 43:23]
    node _T_2 = asSInt(io.inPartialSum) @[PE.scala 44:58]
    sIntBackend.io.inPartialSum <= _T_2 @[PE.scala 44:33]
    wire fpResult : UInt<32> @[PE.scala 47:41]
    inst PEFPBackend of PEFPBackend_3 @[PE.scala 49:31]
    PEFPBackend.clock <= clock
    PEFPBackend.reset <= reset
    PEFPBackend.io.x1 <= io.weight @[PE.scala 50:25]
    PEFPBackend.io.x2 <= io.input @[PE.scala 51:25]
    PEFPBackend.io.inPartialSum <= io.inPartialSum @[PE.scala 52:35]
    PEFPBackend.io.inCompensation <= io.inCompensation @[PE.scala 53:37]
    io.outCompensation <= PEFPBackend.io.outCompensation @[PE.scala 54:28]
    fpResult <= PEFPBackend.io.outPartialSum @[PE.scala 55:18]
    reg _T_3 : UInt, clock @[PE.scala 59:33]
    _T_3 <= io.input @[PE.scala 59:33]
    io.forwardedInput <= _T_3 @[PE.scala 59:23]
    node _T_4 = eq(io.typeSelection, UInt<1>("h01")) @[PE.scala 62:27]
    when _T_4 : @[PE.scala 62:36]
      node _T_5 = asUInt(sIntBackend.io.outPartialSum) @[PE.scala 64:64]
      io.outPartialSum <= _T_5 @[PE.scala 64:26]
      skip @[PE.scala 62:36]
    else : @[PE.scala 65:42]
      node _T_6 = eq(io.typeSelection, UInt<1>("h00")) @[PE.scala 65:33]
      when _T_6 : @[PE.scala 65:42]
        io.outPartialSum <= uIntBackend.io.outPartialSum @[PE.scala 67:26]
        skip @[PE.scala 65:42]
      else : @[PE.scala 68:16]
        io.outPartialSum <= fpResult @[PE.scala 70:42]
        skip @[PE.scala 68:16]
    
  module Tile : 
    input clock : Clock
    input reset : UInt<1>
    output io : {flip inputs : UInt<32>[2], outputs : UInt<32>[2], flip weightsFlattened : UInt<32>[4], flip weightEnable : UInt<1>, flip typeSelection : UInt<2>}
    
    inst ProcessingElement of ProcessingElement @[tile.scala 18:49]
    ProcessingElement.clock <= clock
    ProcessingElement.reset <= reset
    inst ProcessingElement_1 of ProcessingElement_1 @[tile.scala 18:49]
    ProcessingElement_1.clock <= clock
    ProcessingElement_1.reset <= reset
    inst ProcessingElement_2 of ProcessingElement_2 @[tile.scala 18:49]
    ProcessingElement_2.clock <= clock
    ProcessingElement_2.reset <= reset
    inst ProcessingElement_3 of ProcessingElement_3 @[tile.scala 18:49]
    ProcessingElement_3.clock <= clock
    ProcessingElement_3.reset <= reset
    ProcessingElement.io.unlockWeight <= io.weightEnable @[tile.scala 26:32]
    ProcessingElement.io.typeSelection <= io.typeSelection @[tile.scala 27:33]
    ProcessingElement.io.weight <= io.weightsFlattened[0] @[tile.scala 28:26]
    ProcessingElement_1.io.unlockWeight <= io.weightEnable @[tile.scala 26:32]
    ProcessingElement_1.io.typeSelection <= io.typeSelection @[tile.scala 27:33]
    ProcessingElement_1.io.weight <= io.weightsFlattened[1] @[tile.scala 28:26]
    ProcessingElement_2.io.unlockWeight <= io.weightEnable @[tile.scala 26:32]
    ProcessingElement_2.io.typeSelection <= io.typeSelection @[tile.scala 27:33]
    ProcessingElement_2.io.weight <= io.weightsFlattened[2] @[tile.scala 28:26]
    ProcessingElement_3.io.unlockWeight <= io.weightEnable @[tile.scala 26:32]
    ProcessingElement_3.io.typeSelection <= io.typeSelection @[tile.scala 27:33]
    ProcessingElement_3.io.weight <= io.weightsFlattened[3] @[tile.scala 28:26]
    ProcessingElement.io.input <= io.inputs[0] @[tile.scala 36:21]
    ProcessingElement_2.io.input <= io.inputs[1] @[tile.scala 36:21]
    ProcessingElement.io.inPartialSum <= UInt<1>("h00") @[tile.scala 42:31]
    ProcessingElement.io.inCompensation <= UInt<1>("h00") @[tile.scala 44:37]
    io.outputs[0] <= ProcessingElement_2.io.outPartialSum @[tile.scala 46:35]
    ProcessingElement_1.io.inPartialSum <= UInt<1>("h00") @[tile.scala 42:31]
    ProcessingElement_1.io.inCompensation <= UInt<1>("h00") @[tile.scala 44:37]
    io.outputs[1] <= ProcessingElement_3.io.outPartialSum @[tile.scala 46:35]
    ProcessingElement_1.io.input <= ProcessingElement.io.forwardedInput @[tile.scala 54:38]
    ProcessingElement_3.io.input <= ProcessingElement_2.io.forwardedInput @[tile.scala 54:38]
    ProcessingElement_2.io.inPartialSum <= ProcessingElement.io.outPartialSum @[tile.scala 63:38]
    ProcessingElement_2.io.inCompensation <= ProcessingElement.io.outCompensation @[tile.scala 65:44]
    ProcessingElement_3.io.inPartialSum <= ProcessingElement_1.io.outPartialSum @[tile.scala 63:38]
    ProcessingElement_3.io.inCompensation <= ProcessingElement_1.io.outCompensation @[tile.scala 65:44]
    
