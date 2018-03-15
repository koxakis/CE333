////////////////////////////////////////////////////////////////////////////////////
//Module name: Memory Controller Module
//File name: mem_ctrl.v
//Descreption: Provides control signals for memory modules 
////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/10ps
module mem_ctrl(
	mc_clk,
	mc_reset,
	mc_address_mem_opa,
	mc_address_mem_opb,
	mc_data_out_opa,
	mc_data_out_opb,
	mc_data_in_opa,
	mc_data_in_opb,
	mem_data_in_opa,
	mem_data_in_opb,	
	mem_data_out_opa,
	mem_data_out_opb, 
	mc_data_contition,
	mc_data_length,
	mc_done,
	mc_we,
	mc_data_done
);


	input mc_clk, mc_reset;
	input [63:0] mc_data_in_opa, mc_data_in_opb, mem_data_out_opa, mem_data_out_opb;
	input [2:0] mc_data_contition;
	input [5:0] mc_data_length;

	output reg [63:0] mc_data_out_opa, mc_data_out_opb, mem_data_in_opa, mem_data_in_opb;
	output reg [5:0] mc_address_mem_opa, mc_address_mem_opb;
	output reg mc_data_done, mc_we;
	output reg mc_done;

	reg [2:0] mc_state;

	reg trans_input_to_mem, trans_mem_to_reg;
	reg mc_done_in_to_mem, mc_done_mem_to_reg;
	
	reg [5:0] ram_to_reg_address_opa, ram_to_reg_address_opb, ram_address;

	//Memory module to be instansiated at top level as per archiecture 

	//State definition 
	//Idle state - waiting for input
	parameter IDLE = 2'b00;
	//Store data state - Data has arrived to the Memory controller and it has to store it
	parameter STORE_DATA = 2'b01;
	//Transfer data state - Data is in memory and has to be transfered to the memory comtroller 
	parameter TRANS_DATA = 2'b10;
	//Prossessing data state - Memory controller waits for the appropriate signal in oder to send the next data 
	parameter PROCCESING = 2'b11;
	
	parameter REGISTER_LENGTH = 1'b1;
	parameter MEM_LENGTH = 5'b11111;


	always @(posedge mc_clk or posedge mc_reset) begin
		if (mc_reset) begin
			mem_data_in_opa <= 'b0;
			mem_data_in_opb <= 'b0;
			trans_input_to_mem <= 1'b0;
			trans_mem_to_reg <= 1'b0;

			mc_address_mem_opa <= 'b0;
			mc_we <= 1'b0;
			mc_done_in_to_mem <= 1'b0;
			ram_address <= 'b0;
			mc_state <= IDLE;

			mc_address_mem_opa <= 'b0;
			mc_data_done <= 1'b0;
			mc_data_out_opa <= 'b0;
			mc_data_out_opb <= 'b0;
			mc_done_mem_to_reg <= 1'b0;
			ram_to_reg_address_opa <= 'b0;
			ram_to_reg_address_opb <= 'b0;
		end else begin
			case (mc_state)
				/*Waits for the core control to send an appropriate signal that there are 
					data in the MC module input */
				IDLE:
				begin
					if (mc_data_contition == 3'b100) begin
						trans_input_to_mem <= 1'b1;
						mc_state <= STORE_DATA;  
					end
				end
				/*The data are transfered from the input to ram modules. Two inputs are used 
					for operants a and b. When the transfer is complete the memory controller 
					sends a done signal*/
				STORE_DATA:
				begin
					/*Go to the next state when the transfer is compllete. Should the core control unit 
						for any reason want to halt the oporation of the module then it sends the 010 data 
						contition signal*/
					if ((mc_data_contition == 3'b010) || (mc_done)) begin
						mc_done <= 1'b0;
						trans_input_to_mem <= 1'b0;
						trans_mem_to_reg <= 1'b1;
						mc_we <= 1'b0;
						mc_state <= TRANS_DATA;
					end else begin 
						mc_done <= 1'b0;
						mc_we <= 1'b1;
						mc_address_mem_opa <= ram_address;
						mem_data_in_opa <= mc_data_in_opa;
						mem_data_in_opb <= mc_data_in_opb;
						ram_address <= ram_address + 1'b1;
						if ((ram_address == mc_data_length) || (ram_address == MEM_LENGTH)) begin
							mc_done <= 1'b1;
							mc_we <= 1'b0;
							ram_address <= 'b0;
						end
					end
					
				end
				/*In this state we have all the data in ram and we want to start feeding the prosesing units registers,
					this is achived throug the use of two ports for the data , one for operant a and one for operant b.
					different proccesing units data is stored in succetion */
				TRANS_DATA:
				begin
					if (mc_data_contition == 3'b001) begin 
						trans_mem_to_reg <= 1'b0;
						mc_done <= 1'b0;
						mc_state <= PROCCESING;
					end else begin
						if (ram_to_reg_address_opa == MEM_LENGTH) begin
							mc_data_done <= 1'b1;
							mc_done <= 1'b1;
							ram_to_reg_address_opa <= 'b0;
							ram_to_reg_address_opb <= 'b0;
						end else begin
							mc_done <= 1'b0;
							//Send the operant opa
							mc_address_mem_opa <= ram_to_reg_address_opa;
							mc_data_out_opa <= mem_data_out_opa;
							//Send the operant opb
							ram_to_reg_address_opa <= ram_to_reg_address_opa + 1'b1;

							mc_address_mem_opb <= ram_to_reg_address_opb;
							mc_data_out_opb <= mem_data_out_opb;
							ram_to_reg_address_opb <= ram_to_reg_address_opb + 1'b1;
							mc_done <= 1'b1;
						end
					end
				end
				/*Wait for the proccessing to be completed in order to either send the next data by
					going to the TRANS_DATA state or by finishing the prossesing altogether and going to the 
					IDLE state*/
				PROCCESING:
				begin
					if (mc_data_contition == 3'b000) begin
						mc_state <= IDLE;
					end else begin
						if (mc_data_contition == 3'b010) begin
							trans_mem_to_reg <= 1'b1;
							mc_state <= TRANS_DATA;
						end
					end
				end
				default: 
				begin
				end
			endcase
		end
	end	


endmodule // mem_ctrl
