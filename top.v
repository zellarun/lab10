module top(

    input [15:0] sw,
    input btnC,
    output [15:0] led
);
    d_latch part1(
        .D(sw[0]),
        .Q(led[0]),
        .NotQ(led[1]),
        .E(btnC)
    );
    memory_system part2(
        .data(sw[15:8]),
        .addr(sw[7:6]),
        .store(btnC),
        .memory(led)
    );
endmodule


module d_latch(
    input D, En,
    output reg Q,
    output NotQ
);

    always @(En, D) begin
        if(En)
            Q <= D;
     end
     
     assign NotQ = ~Q;
endmodule

module demultiplexer #(bitwiddth=8)(
    input [bitwiddth-1:0] data,
    input [1:0] sel,
    output reg [bitwiddth-1:0] A, B, C, D
);

    always @(*) begin 
        case(sel)
            2'b00: {D, C, B, A} <= {8'b0, 8'b0, 8'b0, data}; 
            2'b01: {D, C, B, A} <= {8'b0, 8'b0, data, 8'b0};
            2'b10: {D, C, B, A} <= {8'b0, data, 8'b0, 8'b0};
            2'b11: {D, C, B, A} <= {data, 8'b0, 8'b0, 8'b0};
        endcase
    end

endmodule

module demultiplexer1(
    input [1:0] data,
    input [1:0] sel,
    output reg [1:0] A, B
);

    always @(*) begin 
        case(sel)
            1'b0: {B, A} <= {1'b0, data}; 
            1'b1: {B, A} <= {data, 1'b0};

        endcase
    end

endmodule

module mux(
    input [7:0] A,B,C,D,
    input En,
    input [1:0] sel,
    output reg [7:0] Y
);

    always @(sel)begin
        if(En) begin
            case(sel)
                2'b00: Y = A;
                2'b01: Y = B;
                2'b10: Y = C;
                2'b11: Y = D;
                default: Y = 0;
             endcase
         end else
            Y= 0;
     end
endmodule
    
module byte_memory(
    input [7:0] data,
    input store,
    output reg [7:0] memory
);

    // Herein, implement D-Latch style memory
    // that stores the input data into memory
    // when store is high
    // Memory should always output the value
    // stored, and it should only change
    // when store is high
    always @(store)begin
        if(store)
            memory <= data;
        end

endmodule

module memory_system(
    input [7:0] data,
    input store,
    input [1:0] addr,
    output [7:0] memory
);

    wire [7:0] arr[3:0];
    
    // This should instantiate 4 instances of
    // byte_memory, and then demultiplex
    // data and store into the one selected by
    // addr
    // It should then multiplex the output of the
    // memory specified by addr into the memory
    // output for display on the LEDs

    // you will need 2 demultiplexers:
    // 1. Demultiplex data -> selected byte
    // 2. Demultiplex store -> selected byte

    // and one multiplexer:
    // 1. Multiplex selected byte -> memory
    genvar i;
    generate
        for( i = 0; i < 4; i = i+1) begin
            byte_memory inst(
                    .data(arr[i]),
                    .store(),
                    .memory()
            );
        end
    endgenerate 
    
    demultiplexer #(.bitwidth(8)) dmux_data(
        .data(data),
        .sel(addr),
        .A(store),//bit memory and store location
        .B(),
        .C(),
        .D()
    );
    demultiplexer #(.bitwidth(1)) dmux_store(
        .data(store),
        .sel(addr),
        .A(data[7]),
        .B(data[6])
    );
    
    mux uno(
        .A()
    );

endmodule
