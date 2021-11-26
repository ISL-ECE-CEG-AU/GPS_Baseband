module LVDT(

`ifdef USE_POWER_PINS
    inout vdda1,	
    inout vssa1,	
`endif
input Iin,
input va,
input vb,
input vcap,
inout vout,
input a2,
input a1,
input clk,
input re,
output y0,
output y1,
output y2
);

endmodule
