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
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] resultReg; // @[PE.scala 24:22]
  reg [31:0] weightReg; // @[PE.scala 25:22]
  reg [31:0] _T_2; // @[PE.scala 33:31]
  wire [63:0] _T_16 = weightReg * io_input; // @[PE.scala 48:37]
  wire [63:0] _GEN_2 = {{32'd0}, io_inPartialSum}; // @[PE.scala 48:57]
  wire [63:0] _T_18 = _T_16 + _GEN_2; // @[PE.scala 48:57]
  assign io_outCompensation = 32'h0; // @[PE.scala 54:22]
  assign io_outPartialSum = resultReg; // @[PE.scala 51:20]
  assign io_forwardedInput = _T_2; // @[PE.scala 33:21]
  assign io_forwardedWeight = weightReg; // @[PE.scala 30:22]
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
  _RAND_1 = {1{`RANDOM}};
  weightReg = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  _T_2 = _RAND_2[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge clock) begin
    resultReg <= _T_18[31:0];
    if (io_unlockWeight) begin
      weightReg <= io_weight;
    end
    _T_2 <= io_input;
  end
endmodule
