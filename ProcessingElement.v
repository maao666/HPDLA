module PEWeightBackend(
  input         clock,
  input         io_propagate,
  input  [31:0] io_weightIn,
  output [31:0] io_weightOut
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] weightReg; // @[PEWeightBackend.scala 14:24]
  assign io_weightOut = weightReg; // @[PEWeightBackend.scala 18:18]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  weightReg = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (io_propagate) begin
      weightReg <= io_weightIn;
    end
  end
endmodule
module PEUIntBackend(
  input         clock,
  input  [31:0] io_x1,
  input  [31:0] io_x2,
  input  [31:0] io_inPartialSum,
  output [31:0] io_outPartialSum
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] resultReg; // @[PEUIntBackend.scala 15:24]
  wire [63:0] _T = io_x1 * io_x2; // @[PEUIntBackend.scala 17:33]
  wire [63:0] _GEN_0 = {{32'd0}, io_inPartialSum}; // @[PEUIntBackend.scala 17:50]
  wire [63:0] _T_2 = _T + _GEN_0; // @[PEUIntBackend.scala 17:50]
  assign io_outPartialSum = resultReg; // @[PEUIntBackend.scala 16:22]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  resultReg = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge clock) begin
    resultReg <= _T_2[31:0];
  end
endmodule
module PESIntBackend(
  input         clock,
  input  [31:0] io_x1,
  input  [31:0] io_x2,
  input  [31:0] io_inPartialSum,
  output [31:0] io_outPartialSum
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] resultReg; // @[PESIntBackend.scala 15:24]
  wire [63:0] _T = $signed(io_x1) * $signed(io_x2); // @[PESIntBackend.scala 17:34]
  wire [31:0] opResult = _T[31:0]; // @[PESIntBackend.scala 17:67]
  assign io_outPartialSum = resultReg; // @[PESIntBackend.scala 16:22]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  resultReg = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge clock) begin
    resultReg <= $signed(opResult) + $signed(io_inPartialSum);
  end
endmodule
module ProcessingElement(
  input         clock,
  input         reset,
  input  [31:0] io_input,
  input  [31:0] io_weight,
  input         io_unlockWeight,
  input  [31:0] io_inPartialSum,
  input  [1:0]  io_typeSelection,
  input  [31:0] io_inCompensation,
  output [31:0] io_outCompensation,
  output [31:0] io_outPartialSum,
  output [31:0] io_forwardedInput,
  output [31:0] io_forwardedWeight
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  wire  WeightBackend_clock; // @[PE.scala 23:31]
  wire  WeightBackend_io_propagate; // @[PE.scala 23:31]
  wire [31:0] WeightBackend_io_weightIn; // @[PE.scala 23:31]
  wire [31:0] WeightBackend_io_weightOut; // @[PE.scala 23:31]
  wire  uIntBackend_clock; // @[PE.scala 31:29]
  wire [31:0] uIntBackend_io_x1; // @[PE.scala 31:29]
  wire [31:0] uIntBackend_io_x2; // @[PE.scala 31:29]
  wire [31:0] uIntBackend_io_inPartialSum; // @[PE.scala 31:29]
  wire [31:0] uIntBackend_io_outPartialSum; // @[PE.scala 31:29]
  wire  sIntBackend_clock; // @[PE.scala 37:29]
  wire [31:0] sIntBackend_io_x1; // @[PE.scala 37:29]
  wire [31:0] sIntBackend_io_x2; // @[PE.scala 37:29]
  wire [31:0] sIntBackend_io_inPartialSum; // @[PE.scala 37:29]
  wire [31:0] sIntBackend_io_outPartialSum; // @[PE.scala 37:29]
  reg [31:0] _T_3; // @[PE.scala 55:33]
  wire  _T_4 = io_typeSelection == 2'h1; // @[PE.scala 58:27]
  wire  _T_6 = io_typeSelection == 2'h0; // @[PE.scala 61:33]
  wire [31:0] _GEN_0 = _T_6 ? uIntBackend_io_outPartialSum : 32'h0; // @[PE.scala 61:42]
  PEWeightBackend WeightBackend ( // @[PE.scala 23:31]
    .clock(WeightBackend_clock),
    .io_propagate(WeightBackend_io_propagate),
    .io_weightIn(WeightBackend_io_weightIn),
    .io_weightOut(WeightBackend_io_weightOut)
  );
  PEUIntBackend uIntBackend ( // @[PE.scala 31:29]
    .clock(uIntBackend_clock),
    .io_x1(uIntBackend_io_x1),
    .io_x2(uIntBackend_io_x2),
    .io_inPartialSum(uIntBackend_io_inPartialSum),
    .io_outPartialSum(uIntBackend_io_outPartialSum)
  );
  PESIntBackend sIntBackend ( // @[PE.scala 37:29]
    .clock(sIntBackend_clock),
    .io_x1(sIntBackend_io_x1),
    .io_x2(sIntBackend_io_x2),
    .io_inPartialSum(sIntBackend_io_inPartialSum),
    .io_outPartialSum(sIntBackend_io_outPartialSum)
  );
  assign io_outCompensation = 32'h0; // @[PE.scala 50:28]
  assign io_outPartialSum = _T_4 ? sIntBackend_io_outPartialSum : _GEN_0; // @[PE.scala 60:26 PE.scala 63:26 PE.scala 66:42]
  assign io_forwardedInput = _T_3; // @[PE.scala 55:23]
  assign io_forwardedWeight = WeightBackend_io_weightOut; // @[PE.scala 27:24]
  assign WeightBackend_clock = clock;
  assign WeightBackend_io_propagate = io_unlockWeight; // @[PE.scala 25:32]
  assign WeightBackend_io_weightIn = io_weight; // @[PE.scala 26:31]
  assign uIntBackend_clock = clock;
  assign uIntBackend_io_x1 = io_weight; // @[PE.scala 32:23]
  assign uIntBackend_io_x2 = io_input; // @[PE.scala 33:23]
  assign uIntBackend_io_inPartialSum = io_inPartialSum; // @[PE.scala 34:33]
  assign sIntBackend_clock = clock;
  assign sIntBackend_io_x1 = io_weight; // @[PE.scala 38:23]
  assign sIntBackend_io_x2 = io_input; // @[PE.scala 39:23]
  assign sIntBackend_io_inPartialSum = io_inPartialSum; // @[PE.scala 40:33]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  _T_3 = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge clock) begin
    _T_3 <= io_input;
  end
endmodule
