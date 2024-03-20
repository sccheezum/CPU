module s_reg_tb;

	// Inputs
	reg zf;
	reg sf;
	reg of;
    reg uf;
	reg cffw;
	reg cfhl;
    reg cfhh;
	reg df;
	reg hwf;
    reg srf;
	reg mvf;
	reg mcf;
    reg tf;
	reg clk;

	// Instantiate the Unit Under Test (UUT)
	flag_registers uut (
		.zf(zf),
		.sf(sf),
		.of(of),
        .uf(uf),
		.cffw(cffw),
		.cfhl(cfhl),
        .cfhh(cfhh),
		.df(df),
		.hwf(hwf),
        .srf(srf),
		.mvf(mvf),
		.mcf(mcf),
        .tf(tf),
		.clk(clk),
	);

	initial begin
		// Initialize Inputs
		zf = 0;
		sf = 0;
		of = 0;
        uf = 0;
        cffw = 0;
        cfhl = 0;
        cfhh = 0;
        df = 0;
        hwf = 0;
        srf = 0;
        mvf = 0;
        mcf = 0;
        tf = 0;
		clk = 1;
	end

		always #1 clk = !clk;

endmodule
