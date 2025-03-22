`timescale 1ns/1ps
module serial_adder 
    (   input clk,reset, 
        input a,b,cin,  
        output reg s,cout  
        );

reg c,flag;

always@(posedge clk or posedge reset)
begin
    if(reset == 1) begin
        s = 0;
        cout = c;
        flag = 0;
    end else begin
        if(flag == 0) begin
            c = cin;  
            flag = 1;  
        end 
        cout = 0;
        s = a ^ b ^ c; 
        c = (a & b) | (c & b) | (a & c); 
    end 
end

endmodule 



// test bench


module tb;

reg clk;
reg reset;
reg a;
reg b;
reg cin;

wire s;
wire cout;

reg [8:0] sum_res;
reg [7:0] num1;
reg [7:0] num2;
integer i;

serial_adder uut (.*); // better to give mention proper connection depending on compiler.

always #5 clk = ~clk;

initial begin
    $dumpfile("serial_adder.vcd");
    $dumpvars(0, tb);

    clk = 1;
    reset = 1;
    sum_res = 0;
    a = 0;
    b = 0;
    cin = 0;

    #20 reset = 0;

    num1 = ($random & 8'hFF); // to avoid the negative number(& hFF)
    num2 = ($random & 8'hFF); 
    cin = 0;
    sum_res = 0;
    

    for (i = 0; i < 9; i = i + 1) begin
        a = (num1 >> i) & 1;
        b = (num2 >> i) & 1;
        #10 sum_res = sum_res | (s << i);
    end

    $display("number 1 = %d	number 2 = %d ",num1, num2);
    $display(" Final sum in decimal: %d", sum_res);

    #10 reset = 1;
    #10;
    $finish;
end

endmodule

