`timescale 1ns/1ps

module regfile (
    input wire clk,
    input wire we,
    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [4:0] rd,
    input wire [31:0] wdata,
    output wire [31:0] rdata1,
    output wire [31:0] rdata2
);

    reg [31:0] regs [0:31];

    // Asynchronous read
	assign rdata1 = (rs1 == rd && we && rd != 0) ? wdata : (rs1 != 0) ? regs[rs1] : 0;
	assign rdata2 = (rs2 == rd && we && rd != 0) ? wdata : (rs2 != 0) ? regs[rs2] : 0;

    // Synchronous write
    always @(posedge clk) begin
        if (we && rd != 0)
            regs[rd] <= wdata;
    end

    // For simulation: initialize or show registers
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            regs[i] = 0;
    end

endmodule
