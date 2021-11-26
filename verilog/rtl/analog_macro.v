module analog_macro(

`ifdef USE_POWER_PINS
    inout vdda1,	
    inout vssa1,	
`endif
input vbiasr,
input vinit,
input reset,
output Fvco,
output v9m
);

endmodule
