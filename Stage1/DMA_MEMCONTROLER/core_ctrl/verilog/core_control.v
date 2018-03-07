////////////////////////////////////////////////////////////////////////////////////
//Module name: Core Control Module
//File name: core_control.h
//Descreption: Provides control signals for memory controller and proccesing modules
////////////////////////////////////////////////////////////////////////////////////
module core_control(
	ctrl_clk,
	ctrl_reset,
	ctrl_instruction,
	ctrl_data_address_in,
	mc_data_address_out,
	ctrl_valid_inst,
	ctrl_valid_data,
	ctrl_last_data,
	ctrl_data_contition,
	mc_err,
	mc_cont_procc,
	mc_we,
	procc_done,
	mc_data_done
);

	input ctrl_clk, ctrl_reset;

	//Instruction input - instruction brakdown [FPU_OP|ROUND_MODE]
	input [4:0] ctrl_instruction;

	//Data address to data
	input [5:0] ctrl_data_address_in;
	
	//Valid data and inst input for module
	input ctrl_valid_data, ctrl_valid_inst, ctrl_last_data;

	input mc_err, mc_cont_procc, procc_done, mc_data_done;

	output reg [5:0] mc_data_address_out;
	output reg mc_we;

	//Data validity and existance in memory [HAS_DATA|VALID_DATA|HAS_DATA_R|VALID_DATA_R]
	//HAS_DATA indicates the existance of data in memory
	//VALID_DATA indicates the relevance of said data to current instruction 
	//HAS_DATA_R indicates the existance of data in proccessing unit registers
	//VALID_DATA_R indicates the relevance of said data to current instruction
	output reg [3:0] ctrl_data_contition;

	reg [2:0] ctrl_state;

	//State definition 
	//Idle state - waiting for input
	parameter IDLE = 3'b000;
	//Store data state - Data has arrived to the Memory controller and it has to store it
	parameter STORE_DATA = 3'b001;
	//Transfer data state - Data is in memory and has to be transfered to the memory comtroller 
	parameter TRANS_DATA = 3'b010;
	//Start Proccesing state - Module has an instruction and data and it is ready to start proccessing 
	parameter START_PROC = 3'b011;
	//Done proccessing state - Module has finished data proccessing and (by sending a proccessing done signal)
	parameter DONE_PROC = 3'b100;

	always @(posedge ctrl_clk or posedge ctrl_reset) begin
		if (ctrl_reset == 1) begin
			ctrl_data_contition <= 'b0;
			mc_we <= 1'b0;
			ctrl_state <= IDLE;
			mc_data_address_out <= 'b0;
		end else begin
			case (ctrl_state)
				/*Waits for valid_input and valid_inst signals from the outside world in order to start 
					the transfer from the data input to the memory module */
				IDLE:	
				begin
					mc_we <= 1'b0;
					if (ctrl_valid_data && ctrl_valid_inst) begin
						mc_we = 1'b1;
						mc_data_address_out <= ctrl_data_address_in;
						ctrl_state <= STORE_DATA;
					end
				end
				/*Starts the MC copy-to-mem oporation with a starting address. Sends the data contition as [0000]
					and enables writes in order to get the data from the input to the memory modules. If the MC module sends
					the mc_err signal it means the mem is full and the data is incomplete*/
				STORE_DATA:
				begin
					if (ctrl_last_data) begin
						mc_we = 1'b0;
						ctrl_data_contition <= 4'b1100 ;
						ctrl_state <= TRANS_DATA;
					end
				end
				/*Starts the MC mem-to-reg opration by sending the data contition as [1100] and disables the write enable signal.
					The MC sends a mc_cont_procc flag to signal that the proccessing unit can start the proccesing. When this 
					comoleted the signal resets and starts counding for the next transfer when that happens 
					*/
				TRANS_DATA:
				begin
					if (mc_cont_procc) begin
						ctrl_data_contition <= 4'b1111 ;
						ctrl_state <= START_PROC;
					end
				end
				/*Starts the proccessing unit and sends the data contition as [1111] and waits for a signal that 
					indicates the data proccesing is complete.
					*/
				START_PROC:
				begin
					if (procc_done) begin
						ctrl_data_contition <= 4'b1110;
						ctrl_state <= DONE_PROC;
					end
				end
				/*The proccesing is done and if the mc_data_done is not 1 that means there are still data to be proccessed in mem
					and the next state should be the TRANS_DATA again with the internal data counter countding towrds the mem size and 
					raise the mc_data_done flag else return to idle
					*/
				DONE_PROC:
				begin
					if (mc_cont_procc && !mc_data_done) begin
						ctrl_state <= TRANS_DATA;
					end else begin
						ctrl_state <= IDLE;
					end
				end
				default: 
				begin
					ctrl_data_contition <= 'b0;
					mc_we <= 1'b0;
					ctrl_state <= IDLE;
					mc_data_address_out <= 'b0;
				end
			endcase
		end
	end


endmodule // core_control