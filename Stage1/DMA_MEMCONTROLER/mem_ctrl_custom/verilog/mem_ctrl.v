////////////////////////////////////////////////////////////////////////////////////
//Module name: Memory Controller Module
//File name: mem_ctrl.v
//Descreption: Provides control signals for memory modules 
////////////////////////////////////////////////////////////////////////////////////
module mem_ctrl(
	mc_clk,
	mc_reset,
	mc_address_mem,
	mc_data_in,
	mc_data_out_opa,
	mc_data_out_opb,
	mem_data_in,
	mem_data_out, 
	mc_data_contition,
	mc_data_length,
	mc_done,
	mc_we,
	mc_data_done
);


	input mc_clk, mc_reset;
	input [6:0] mc_data_address_in;
	input [31:0] mc_data_in, mem_data_out;
	input [2:0] mc_data_contition;
	input mc_we;

	output reg [31:0] mc_data_out, mem_data_in;
	output reg [6:0] mc_address_mem;
	output reg mc_err, mc_cont_procc, mc_data_done;

	reg [2:0] mc_state;

	reg trans_input_to_mem, trans_mem_to_reg;

	//Memory module to be instansiated at top level as per archiecture 

	//State definition 
	//Idle state - waiting for input
	parameter IDLE = 2'b00;
	//Store data state - Data has arrived to the Memory controller and it has to store it
	parameter STORE_DATA = 2'b01;
	//Transfer data state - Data is in memory and has to be transfered to the memory comtroller 
	parameter TRANS_DATA = 2'b10;

	//Assgign the apropriate signal to mc_done 
	assign mc_done = (in_or_mem) ? mc_done_in_to_mem : mc_done_mem_to_reg;

	always @(posedge mc_clk or posedge mc_reset) begin
		if (mc_reset) begin
			mc_data_out <= 'b0;
			mem_data_in <= 'b0;
			trans_input_to_mem <= 1'b0;
			trans_mem_to_reg <= 1'b0;
			in_or_mem <= 1'b0;
			mc_we <= 1'b0;
			mc_state <= IDLE;
		end else begin
			case (mc_state)
				IDLE:
				begin
					if (mc_data_contition == 3'b100) begin
						mc_we <= 1'b1;
						in_or_mem <= 1'b1;
						trans_input_to_mem <= 1'b1;
						mc_state <= STORE_DATA;  
					end
				end
				STORE_DATA:
				begin
					if (mc_data_contition == 3'b010) begin
						mc_we <= 1'b0;
						trans_input_to_mem <= 1'b0;
						trans_mem_to_reg <= 1'b1;
						in_or_mem <= 1'b0;
						mc_state <= TRANS_DATA;
					end
				end
				TRANS_DATA:
				begin
					if (mc_data_contition == 3'b001) begin 
						trans_mem_to_reg <= 1'b0;
						mc_state <= PROSSESING;
					end
				end
				PROSSESING:
				begin
					if (mc_data_contition == 3'b000) begin
						in_or_mem <= 1'b0;
						mc_state <= PROSSESING;
					end else begin
						if (mc_data_contition == 3'b010) begin
							in_or_mem <= 1'b0;
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

	//Transfer data to the reg 
	/*Wait a signal to send 64 bit of data opa and opb to the reg in the fpu*/
	always @(posedge mc_clk or posedge mc_reset) begin
		if (mc_reset) begin
			mc_data_done <= 1'b0;
			mc_done_mem_to_reg <= 1'b0;
			ram_to_reg_address <= 'b0;
		end else begin
			if (!trans_mem_to_reg) begin
				mc_data_done <= 1'b0;
				mc_done_mem_to_reg <= 1'b0;
				ram_to_reg_address <= 'b0;
			end else begin
				if ((ram_to_reg_address == mc_data_length) || (ram_to_reg_address == mem_length)) begin
					mc_done_mem_to_reg <= 1'b1;
					ram_to_reg_address <= 'b0;
				end else begin
					mc_done_mem_to_reg <= 1'b0;
					//Send the operant opa
					mc_address_mem <= ram_to_reg_address;
					mc_data_out_opa <= mem_data_out;
					//Send the operant opb
					ram_to_reg_address <= ram_to_reg_address + 1'b1;
					mc_address_mem <= ram_to_reg_address;
					mc_data_out_opb <= mem_data_out;
				end
			end		
		end
	end

	//Store data from input to ram 
	/*Start incrementing addresses in order to get the data from the input to mem
		when reach the max just stop*/
	always @(posedge mc_clk or posedge mc_reset) begin
		if (mc_reset) begin
			mc_done_in_to_mem <= 1'b0;
			ram_address <= 'b0;
		end else begin
			if (!trans_input_to_mem) begin
				mc_done_in_to_mem <= 1'b0;
				ram_address <= 'b0;
			end else begin
				if ((ram_address == mc_data_length) || (ram_address == mem_length)) begin
					mc_done_in_to_mem <= 1'b1;
					ram_address <= 'b0;
				end else begin
					mc_done_in_to_mem <= 1'b0;
					mc_address_mem <= ram_address;
					mem_data_in <= mc_data_in;
					ram_address <= ram_address + 1'b1;
				end
			end	
		end
	end


endmodule // mem_ctrl
