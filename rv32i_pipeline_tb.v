`timescale 1ns / 1ps

module rv32i_pipeline_tb;

    reg clk;
    reg reset;

    wire [31:0] pc_out;
    wire [31:0] alu_out;
    wire [31:0] mem_rdata_out;

    // instantiate top-level core
    rv32i_pipeline dut (
        .clk(clk),
        .reset(reset),
        .pc_out(pc_out),
        .alu_out(alu_out),
        .mem_rdata_out(mem_rdata_out)
    );

    // clock: 100MHz equivalent
    always #5 clk = ~clk;

    initial begin
        $dumpfile("rv32i_pipeline.vcd");
        $dumpvars(0, rv32i_pipeline_tb);

        clk = 0;
        reset = 1;

        // give time for reset
        #10;

        // Load test program into instruction memory
        // addi x1, x0, 5       -> 0x00500093
        // addi x2, x0, 7       -> 0x00700113
        // add  x3, x1, x2      -> 0x002081b3
        // sw   x3, 0(x0)       -> 0x00302023
        // auipc x4, 0x1        -> 0x00001017
        // jal x0, 0            -> 0x0000006f (infinite loop)
        dut.imem[0] = 32'h00500093;
        dut.imem[1] = 32'h00700113;
        dut.imem[2] = 32'h002081b3;
        dut.imem[3] = 32'h00302023;
        dut.imem[4] = 32'h00001017;
        dut.imem[5] = 32'h0000006f;

		// release reset
		#10 reset = 0;

		// run simulation for some cycles
		#1000;
		$display("\nFinal state before loop stabilizes:");

		// print relevant register and memory contents
		$display("\n--- FINAL CPU STATE ---");
		$display("PC = %h", pc_out);
		$display("x1 = %0d", dut.REGS.regs[1]);
		$display("x2 = %0d", dut.REGS.regs[2]);
		$display("x3 = %0d", dut.REGS.regs[3]);
		$display("x4 = %0d", dut.REGS.regs[4]);

		$display("Memory[0..3] = %02x %02x %02x %02x -> %08x",
			dut.dmem[0], dut.dmem[1], dut.dmem[2], dut.dmem[3],
			{dut.dmem[3], dut.dmem[2], dut.dmem[1], dut.dmem[0]});

		$display("\nALU out (last) = %0d", alu_out);
		$display("Mem read (last) = %0d", mem_rdata_out);
		$display("------------------------\n");

		$finish;

    end

endmodule
