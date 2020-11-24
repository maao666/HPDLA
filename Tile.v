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
  input  [31:0] io_input,
  output [31:0] io_forwardedInput,
  input  [31:0] io_weight,
  input  [31:0] io_inPartialSum,
  output [31:0] io_outPartialSum,
  input  [1:0]  io_typeSelection
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  wire  uIntBackend_clock; // @[PE.scala 35:29]
  wire [31:0] uIntBackend_io_x1; // @[PE.scala 35:29]
  wire [31:0] uIntBackend_io_x2; // @[PE.scala 35:29]
  wire [31:0] uIntBackend_io_inPartialSum; // @[PE.scala 35:29]
  wire [31:0] uIntBackend_io_outPartialSum; // @[PE.scala 35:29]
  wire  sIntBackend_clock; // @[PE.scala 41:29]
  wire [31:0] sIntBackend_io_x1; // @[PE.scala 41:29]
  wire [31:0] sIntBackend_io_x2; // @[PE.scala 41:29]
  wire [31:0] sIntBackend_io_inPartialSum; // @[PE.scala 41:29]
  wire [31:0] sIntBackend_io_outPartialSum; // @[PE.scala 41:29]
  reg [31:0] _T_3; // @[PE.scala 59:33]
  wire  _T_4 = io_typeSelection == 2'h1; // @[PE.scala 62:27]
  wire  _T_6 = io_typeSelection == 2'h0; // @[PE.scala 65:33]
  wire [31:0] _GEN_0 = _T_6 ? uIntBackend_io_outPartialSum : 32'h0; // @[PE.scala 65:42]
  PEUIntBackend uIntBackend ( // @[PE.scala 35:29]
    .clock(uIntBackend_clock),
    .io_x1(uIntBackend_io_x1),
    .io_x2(uIntBackend_io_x2),
    .io_inPartialSum(uIntBackend_io_inPartialSum),
    .io_outPartialSum(uIntBackend_io_outPartialSum)
  );
  PESIntBackend sIntBackend ( // @[PE.scala 41:29]
    .clock(sIntBackend_clock),
    .io_x1(sIntBackend_io_x1),
    .io_x2(sIntBackend_io_x2),
    .io_inPartialSum(sIntBackend_io_inPartialSum),
    .io_outPartialSum(sIntBackend_io_outPartialSum)
  );
  assign io_forwardedInput = _T_3; // @[PE.scala 59:23]
  assign io_outPartialSum = _T_4 ? sIntBackend_io_outPartialSum : _GEN_0; // @[PE.scala 64:26 PE.scala 67:26 PE.scala 70:42]
  assign uIntBackend_clock = clock;
  assign uIntBackend_io_x1 = io_weight; // @[PE.scala 36:23]
  assign uIntBackend_io_x2 = io_input; // @[PE.scala 37:23]
  assign uIntBackend_io_inPartialSum = io_inPartialSum; // @[PE.scala 38:33]
  assign sIntBackend_clock = clock;
  assign sIntBackend_io_x1 = io_weight; // @[PE.scala 42:23]
  assign sIntBackend_io_x2 = io_input; // @[PE.scala 43:23]
  assign sIntBackend_io_inPartialSum = io_inPartialSum; // @[PE.scala 44:33]
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
module Tile(
  input         clock,
  input         reset,
  input  [31:0] io_inputs_0,
  input  [31:0] io_inputs_1,
  output [31:0] io_outputs_0,
  output [31:0] io_outputs_1,
  input  [31:0] io_weightsFlattened_0,
  input  [31:0] io_weightsFlattened_1,
  input  [31:0] io_weightsFlattened_2,
  input  [31:0] io_weightsFlattened_3,
  input         io_weightEnable,
  input  [1:0]  io_typeSelection
);
  wire  ProcessingElement_clock; // @[tile.scala 18:49]
  wire [31:0] ProcessingElement_io_input; // @[tile.scala 18:49]
  wire [31:0] ProcessingElement_io_forwardedInput; // @[tile.scala 18:49]
  wire [31:0] ProcessingElement_io_weight; // @[tile.scala 18:49]
  wire [31:0] ProcessingElement_io_inPartialSum; // @[tile.scala 18:49]
  wire [31:0] ProcessingElement_io_outPartialSum; // @[tile.scala 18:49]
  wire [1:0] ProcessingElement_io_typeSelection; // @[tile.scala 18:49]
  wire  ProcessingElement_1_clock; // @[tile.scala 18:49]
  wire [31:0] ProcessingElement_1_io_input; // @[tile.scala 18:49]
  wire [31:0] ProcessingElement_1_io_forwardedInput; // @[tile.scala 18:49]
  wire [31:0] ProcessingElement_1_io_weight; // @[tile.scala 18:49]
  wire [31:0] ProcessingElement_1_io_inPartialSum; // @[tile.scala 18:49]
  wire [31:0] ProcessingElement_1_io_outPartialSum; // @[tile.scala 18:49]
  wire [1:0] ProcessingElement_1_io_typeSelection; // @[tile.scala 18:49]
  wire  ProcessingElement_2_clock; // @[tile.scala 18:49]
  wire [31:0] ProcessingElement_2_io_input; // @[tile.scala 18:49]
  wire [31:0] ProcessingElement_2_io_forwardedInput; // @[tile.scala 18:49]
  wire [31:0] ProcessingElement_2_io_weight; // @[tile.scala 18:49]
  wire [31:0] ProcessingElement_2_io_inPartialSum; // @[tile.scala 18:49]
  wire [31:0] ProcessingElement_2_io_outPartialSum; // @[tile.scala 18:49]
  wire [1:0] ProcessingElement_2_io_typeSelection; // @[tile.scala 18:49]
  wire  ProcessingElement_3_clock; // @[tile.scala 18:49]
  wire [31:0] ProcessingElement_3_io_input; // @[tile.scala 18:49]
  wire [31:0] ProcessingElement_3_io_forwardedInput; // @[tile.scala 18:49]
  wire [31:0] ProcessingElement_3_io_weight; // @[tile.scala 18:49]
  wire [31:0] ProcessingElement_3_io_inPartialSum; // @[tile.scala 18:49]
  wire [31:0] ProcessingElement_3_io_outPartialSum; // @[tile.scala 18:49]
  wire [1:0] ProcessingElement_3_io_typeSelection; // @[tile.scala 18:49]
  ProcessingElement ProcessingElement ( // @[tile.scala 18:49]
    .clock(ProcessingElement_clock),
    .io_input(ProcessingElement_io_input),
    .io_forwardedInput(ProcessingElement_io_forwardedInput),
    .io_weight(ProcessingElement_io_weight),
    .io_inPartialSum(ProcessingElement_io_inPartialSum),
    .io_outPartialSum(ProcessingElement_io_outPartialSum),
    .io_typeSelection(ProcessingElement_io_typeSelection)
  );
  ProcessingElement ProcessingElement_1 ( // @[tile.scala 18:49]
    .clock(ProcessingElement_1_clock),
    .io_input(ProcessingElement_1_io_input),
    .io_forwardedInput(ProcessingElement_1_io_forwardedInput),
    .io_weight(ProcessingElement_1_io_weight),
    .io_inPartialSum(ProcessingElement_1_io_inPartialSum),
    .io_outPartialSum(ProcessingElement_1_io_outPartialSum),
    .io_typeSelection(ProcessingElement_1_io_typeSelection)
  );
  ProcessingElement ProcessingElement_2 ( // @[tile.scala 18:49]
    .clock(ProcessingElement_2_clock),
    .io_input(ProcessingElement_2_io_input),
    .io_forwardedInput(ProcessingElement_2_io_forwardedInput),
    .io_weight(ProcessingElement_2_io_weight),
    .io_inPartialSum(ProcessingElement_2_io_inPartialSum),
    .io_outPartialSum(ProcessingElement_2_io_outPartialSum),
    .io_typeSelection(ProcessingElement_2_io_typeSelection)
  );
  ProcessingElement ProcessingElement_3 ( // @[tile.scala 18:49]
    .clock(ProcessingElement_3_clock),
    .io_input(ProcessingElement_3_io_input),
    .io_forwardedInput(ProcessingElement_3_io_forwardedInput),
    .io_weight(ProcessingElement_3_io_weight),
    .io_inPartialSum(ProcessingElement_3_io_inPartialSum),
    .io_outPartialSum(ProcessingElement_3_io_outPartialSum),
    .io_typeSelection(ProcessingElement_3_io_typeSelection)
  );
  assign io_outputs_0 = ProcessingElement_2_io_outPartialSum; // @[tile.scala 46:35]
  assign io_outputs_1 = ProcessingElement_3_io_outPartialSum; // @[tile.scala 46:35]
  assign ProcessingElement_clock = clock;
  assign ProcessingElement_io_input = io_inputs_0; // @[tile.scala 36:21]
  assign ProcessingElement_io_weight = io_weightsFlattened_0; // @[tile.scala 28:26]
  assign ProcessingElement_io_inPartialSum = 32'h0; // @[tile.scala 42:31]
  assign ProcessingElement_io_typeSelection = io_typeSelection; // @[tile.scala 27:33]
  assign ProcessingElement_1_clock = clock;
  assign ProcessingElement_1_io_input = ProcessingElement_io_forwardedInput; // @[tile.scala 54:38]
  assign ProcessingElement_1_io_weight = io_weightsFlattened_1; // @[tile.scala 28:26]
  assign ProcessingElement_1_io_inPartialSum = 32'h0; // @[tile.scala 42:31]
  assign ProcessingElement_1_io_typeSelection = io_typeSelection; // @[tile.scala 27:33]
  assign ProcessingElement_2_clock = clock;
  assign ProcessingElement_2_io_input = io_inputs_1; // @[tile.scala 36:21]
  assign ProcessingElement_2_io_weight = io_weightsFlattened_2; // @[tile.scala 28:26]
  assign ProcessingElement_2_io_inPartialSum = ProcessingElement_io_outPartialSum; // @[tile.scala 63:38]
  assign ProcessingElement_2_io_typeSelection = io_typeSelection; // @[tile.scala 27:33]
  assign ProcessingElement_3_clock = clock;
  assign ProcessingElement_3_io_input = ProcessingElement_2_io_forwardedInput; // @[tile.scala 54:38]
  assign ProcessingElement_3_io_weight = io_weightsFlattened_3; // @[tile.scala 28:26]
  assign ProcessingElement_3_io_inPartialSum = ProcessingElement_1_io_outPartialSum; // @[tile.scala 63:38]
  assign ProcessingElement_3_io_typeSelection = io_typeSelection; // @[tile.scala 27:33]
endmodule
