module s_reg(zf,sf,of,uf,cffw,cfhl,cfhh,df,hwf,srf,mvf,mcf,tf,clk,dzf,dsf,dof,duf,dcffw,dcfhl,dcfhh,ddf,dhwf,dsrf,dmvf,dmcf,dtf);
    input zf,sf,of,uf,cffw,cfhl,cfhh,df,hwf,srf,mvf,mcf,tf;                            // flag registers
    input clk;                                 // clock, reset
    
	 output dzf,dsf,dof,duf,dcffw,dcfhl,dcfhh,ddf,dhwf,dsrf,dmvf,dmcf,dtf;                       // flag registers
    
	wire [19:0] e = 20'b1;
    wire  register[12:0];

	//dffe1 (d,clk,e,q);
	dffe1 reg01  (zf,clk,e,register[0]);    // zero flag
    dffe1 reg02  (sf,clk,e,register[1]);    // sign flag
    dffe1 reg03  (of,clk,e,register[2]);    // overflow flag
    dffe1 reg04  (uf,clk,e,register[3]);    // underflow flag
    dffe1 reg05  (cffw,clk,e,register[4]);  // carry flag forward
    dffe1 reg06  (cfhl,clk,e,register[5]);  // carry flag half word low
    dffe1 reg07  (cfhh,clk,e,register[6]);  // carry flag half word high
    dffe1 reg08  (df,clk,e,register[7]);    // division by zero flag
    dffe1 reg09  (hwf,clk,e,register[8]);   // half word flag
    dffe1 reg10  (srf,clk,e,register[9]);   // same register flag
    dffe1 reg11  (mvf,clk,e,register[10]);  // memory violation flag
    dffe1 reg12  (mcf,clk,e,register[11]);  // memory corruption flag
    dffe1 reg13  (tf,clk,e,register[12]);   // trap flag
        
    assign dzf = register[0];
	assign dsf = register[1];
	assign dof = register[2];
    assign duf = register[3];
	assign dcffw = register[4];
	assign dcfhl = register[5];
    assign dcfhh = register[6];
	assign ddf = register[7];
	assign dhwf = register[8];
    assign dsrf = register[9];
	assign dmvf = register[10];
	assign dmcf = register[11];
    assign dtf = register[12];

endmodule
