module cthulhu_manager(
    input         clk,
    input         rst_n,
    input  [11:0] addr,
    input         write_en,
    input         valid,
    input  [7:0]  data_w,
    output [7:0]  data_r
);

    life_st life; 
    sanity_st sanity;
    status_st status;
	
  	logic [7:0] t_data;
  
  	
    assign data_r = t_data;
    
  
    always_ff@(posedge clk, negedge rst_n) begin
        if(~rst_n) begin
            life   <= 0;
            sanity <= 0;
        end
        else if(write_en & valid) begin
            case(addr)
                12'h100: life   <= data_w;
                12'h200: sanity <= data_w;
                default: life   <= data_w;
            endcase
        end
      	else if (!write_en & valid) begin
        	case(addr)
              12'h300: t_data <= status;
              default: t_data <= 8'b0;
            endcase
      	end
    end

    always_ff@(posedge clk, negedge rst_n) begin
        if(~rst_n) begin
            status <= 0;
        end
        else begin
            if(life.current_health == 'h0) begin
                status.is_dead <= 1'b1;
                status.is_wounded <= 1'b0;
                status.is_healthy <= 1'b0;
            end else if(life.current_health < life.max_health/2) begin
                status.is_dead <= 1'b0;
                status.is_wounded <= 1'b1;
                status.is_healthy <= 1'b0;
            end else begin
                status.is_dead <= 1'b0;
                status.is_wounded <= 1'b0;
                status.is_healthy <= 1'b1;
            end

            if(sanity.current_sanity == 'h0) begin
                status.is_mad <= 1'b1;
                status.is_going_mad <= 1'b0;
                status.is_sane <= 1'b0;
            end else if(sanity.current_sanity <= sanity.max_sanity/2) begin
                status.is_mad <= 1'b0;
                status.is_going_mad <= 1'b1;
                status.is_sane <= 1'b0;
            end else begin
                status.is_mad <= 1'b0;
                status.is_going_mad <= 1'b0;
                status.is_sane <= 1'b1;
            end

        end
    end


endmodule : cthulhu_manager