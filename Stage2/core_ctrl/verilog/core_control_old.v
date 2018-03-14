////////////////////////////////////////////////////////////////////////////////////
//Module name: Core Control Module
//File name: core_control.v
//Descreption: Provides control signals for memory controller and proccesing modules
////////////////////////////////////////////////////////////////////////////////////
module core_control(
	ctrl_clk,
	ctrl_reset,
	ctrl_instruction,
	ctrl_valid_inst,
	ctrl_valid_data,
	ctrl_data_in_size,
	ctrl_data_contition,
	mc_done,
	mc_data_length,
	procc_done
);

	input ctrl_clk, ctrl_reset;

	//Instruction input - instruction brakdown [OP_CODE]
	input [2:0] ctrl_instruction;
	
	//Valid data and inst input for module
	input ctrl_valid_data, ctrl_valid_inst;
	input ctrl_data_length;

	input mc_done;

	output reg [5:0] ctrl_data_address_out;
	output reg mc_we;

	/*Valid Data location [Data in input|Data in memory|Data in reg]
		No data at all 000
		Data in input 100
		Data in mem 010
		Data in reg 001*/
	output reg [2:0] ctrl_data_contition;

	reg [1:0] ctrl_state;

	//State definition 
	//Idle state - waiting for input
	parameter IDLE = 2'b00;
	//Store data state - Data has arrived to the Memory controller and it has to store it
	parameter STORE_DATA = 2'b01;
	//Transfer data state - Data is in memory and has to be transfered to the memory comtroller 
	parameter TRANS_DATA = 2'b10;
	//Start Proccesing state - Module has an instruction and data and it is ready to start proccessing 
	parameter PROCCESING = 2'b11;

	always @(posedge ctrl_clk or posedge ctrl_reset) begin
		if (ctrl_reset == 1) begin
			ctrl_data_contition <= 'b0;
			ctrl_state <= IDLE;
		end else begin
			case (ctrl_state)
				/*Waits for valid_input and valid_inst signals from the outside world in order to start 
					the transfer from the data input to the memory module */
				IDLE:	
				begin
					if (ctrl_valid_data && ctrl_valid_inst) begin
						ctrl_data_contition <= 3'b100;
						ctrl_state <= STORE_DATA;
					end
				end
				/*Starts the MC copy-to-mem oporation by sending the ctrl_data_contition 100. 
					When the memory controller sends mc_done flag it means
					it signals the data have been transfered*/
				STORE_DATA:
				begin
					if (mc_done) begin
						ctrl_data_contition <= 3'b010 ;
						ctrl_state <= TRANS_DATA;
					end
				end
				/*Starts the MC mem-to-reg opration by sending the ctrl_data_contition 010.
					when the memory controller sends the mc_done flag it means the data 
					have been transfered*/
				TRANS_DATA:
				begin
					if (mc_done) begin
						ctrl_data_contition <= 3'b001 ;
						ctrl_state <= PROCCESING;
					end
				end
				/*Starts the proccessing unit and sends the data contition as [1111] and waits for a signal that 
					indicates the data proccesing is complete.
					*/
				PROCCESING:
				begin
					if (procc_done && mc_data_done) begin
						ctrl_data_contition <= 3'b000;
						ctrl_state <= IDLE;
					end else begin
						if (procc_done && !mc_data_done) begin
							ctrl_data_contition <= 3'b010;
							ctrl_state <= TRANS_DATA;
						end
					end
				end
				default: 
				begin
					ctrl_data_contition <= 'b0;
					ctrl_state <= IDLE;
				end
			endcase
		end
	end


endmodule // core_control