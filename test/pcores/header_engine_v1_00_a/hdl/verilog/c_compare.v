module c_compare(inp, lower, upper, bol);
input [15:0] inp;
input [15:0] lower;
input [15:0] upper;
output bol;
assign bol = ((lower <= inp)&&(inp <= upper));
endmodule 