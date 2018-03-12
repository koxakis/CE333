////////////////////////////////////////////////////////////////////////////////////
//Module name: Memory Controller Module
//File name: mem_ctrl.v
//Descreption: Provides control signals for memory modules 
////////////////////////////////////////////////////////////////////////////////////
module mem_ctrl(
	mc_clk,
	mc_reset,
	mc_data_address_in,
	mc_address_mem,
	mc_data_in,
	mc_data_out,
	mem_data_in,
	mem_data_out, 
	mc_data_contition,
	mc_err,
	mc_cont_procc,
	mc_we,
	mc_data_done
);


	input mc_clk, mc_reset;
	input [6:0] mc_data_address_in;
	input [31:0] mc_data_in, mem_data_out;
	input [3:0] mc_data_contition;
	input mc_we;

	output reg [31:0] mc_data_out, mem_data_in;
	output reg [6:0] mc_address_mem;
	output reg mc_err, mc_cont_procc, mc_data_done;

	reg [3:0] mc_state;

	//Memory module to be instansiated at top level as per archiecture 

	//State definition 
	//Idle state - waiting for input
	parameter IDLE = 3'b000;
	//Store data state - Data has arrived to the Memory controller and it has to store it
	parameter STORE_DATA = 3'b001;
	//Transfer data state - Data is in memory and has to be transfered to the memory comtroller 
	parameter TRANS_DATA = 3'b010;
	//Start Proccesing state - Module has an instruction and data and it is ready to start proccessing 
	parameter WAIT_PROC = 3'b011;
	//Done proccessing state - Module has finished data proccessing and (by sending a proccessing done signal)
	parameter DONE_PROC = 3'b100;

    //States are mirroed from control unit and are fofilling their roles
    //accoring to the states in there 
	always @(posedge mc_clk or posedge mc_reset) begin
		if (mc_reset) begin
			mc_data_out <= 'b0;
			mem_data_in <= 'b0;
			mc_err <= 1'b0;
			mc_cont_procc <= 1'b0;
			mc_data_done <= 1'b0;
			mc_state <= 1'b0;
		end else begin
			case (mc_state)
				IDLE:
				begin
					if ((mc_data_contition == 4'b0000) && mc_we) begin
						mc_state <= STORE_DATA;  
					end
				end
				STORE_DATA:
				begin
					if ((mc_data_contition == 4'b1100) && !mc_we) begin
						mc_state <= TRANS_DATA;
					end
				end
				TRANS_DATA:
				begin
					if (mc_data_contition == 4'b1111) begin
						mc_state <= WAIT_PROC;
					end
				end
				WAIT_PROC:
				begin
					if (mc_data_contition == 4'b1110) begin
						mc_state <= DONE_PROC;
					end
				end 
				DONE_PROC:
				begin	
					if (mc_cont_procc) begin
						mc_state <= TRANS_DATA;
					end else begin
						mc_
					end
				end
				default: 
			endcase
		end
	end	

	//Transfer data to the reg 
	/*Wait a signal to send 64 bit of data opa and opb to the reg in the fpu
	*/
	always @(posedge mc_clk or posedge mc_reset) begin
		if (mc_reset) begin

		end else begin

		end
	end

	//Store data from input to ram 
	/*Start incrementing addresses in order to get the data from the input to mem
		when reach the max just stop
		*/
	always @(posedge mc_clk or posedge mc_reset) begin
		if (mc_reset) begin
			mc_address_mem <= 'b0;
			mc_err <= 1'b0;
		end else begin
			if (from_out_to_ram) begin

			end else begin

			end			
		end
	end


endmodule // mem_ctrl
