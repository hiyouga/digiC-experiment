module Float_8bit_Table(U, F, P);
	input [7:0] U;
	output reg [7:0] F;
	output reg [2:0] P;
	
	always @(U) begin
		case (U)
			8'd0:   begin F <= 8'b00000000; P <= 3'b000; end
			8'd1:   begin F <= 8'b10000000; P <= 3'b000; end
			8'd2:   begin F <= 8'b10000000; P <= 3'b001; end
			8'd3:   begin F <= 8'b11000000; P <= 3'b001; end
			8'd4:   begin F <= 8'b10000000; P <= 3'b010; end
			8'd5:   begin F <= 8'b10100000; P <= 3'b010; end
			8'd6:   begin F <= 8'b11000000; P <= 3'b010; end
			8'd7:   begin F <= 8'b11100000; P <= 3'b010; end
			8'd8:   begin F <= 8'b10000000; P <= 3'b011; end
			8'd9:   begin F <= 8'b10010000; P <= 3'b011; end
			8'd10:  begin F <= 8'b10100000; P <= 3'b011; end
			8'd11:  begin F <= 8'b10110000; P <= 3'b011; end
			8'd12:  begin F <= 8'b11000000; P <= 3'b011; end
			8'd13:  begin F <= 8'b11010000; P <= 3'b011; end
			8'd14:  begin F <= 8'b11100000; P <= 3'b011; end
			8'd15:  begin F <= 8'b11110000; P <= 3'b011; end
			8'd16:  begin F <= 8'b10000000; P <= 3'b100; end
			8'd17:  begin F <= 8'b10001000; P <= 3'b100; end
			8'd18:  begin F <= 8'b10010000; P <= 3'b100; end
			8'd19:  begin F <= 8'b10011000; P <= 3'b100; end
			8'd20:  begin F <= 8'b10100000; P <= 3'b100; end
			8'd21:  begin F <= 8'b10101000; P <= 3'b100; end
			8'd22:  begin F <= 8'b10110000; P <= 3'b100; end
			8'd23:  begin F <= 8'b10111000; P <= 3'b100; end
			8'd24:  begin F <= 8'b11000000; P <= 3'b100; end
			8'd25:  begin F <= 8'b11001000; P <= 3'b100; end
			8'd26:  begin F <= 8'b11010000; P <= 3'b100; end
			8'd27:  begin F <= 8'b11011000; P <= 3'b100; end
			8'd28:  begin F <= 8'b11100000; P <= 3'b100; end
			8'd29:  begin F <= 8'b11101000; P <= 3'b100; end
			8'd30:  begin F <= 8'b11110000; P <= 3'b100; end
			8'd31:  begin F <= 8'b11111000; P <= 3'b100; end
			8'd32:  begin F <= 8'b10000000; P <= 3'b101; end
			8'd33:  begin F <= 8'b10000100; P <= 3'b101; end
			8'd34:  begin F <= 8'b10001000; P <= 3'b101; end
			8'd35:  begin F <= 8'b10001100; P <= 3'b101; end
			8'd36:  begin F <= 8'b10010000; P <= 3'b101; end
			8'd37:  begin F <= 8'b10010100; P <= 3'b101; end
			8'd38:  begin F <= 8'b10011000; P <= 3'b101; end
			8'd39:  begin F <= 8'b10011100; P <= 3'b101; end
			8'd40:  begin F <= 8'b10100000; P <= 3'b101; end
			8'd41:  begin F <= 8'b10100100; P <= 3'b101; end
			8'd42:  begin F <= 8'b10101000; P <= 3'b101; end
			8'd43:  begin F <= 8'b10101100; P <= 3'b101; end
			8'd44:  begin F <= 8'b10110000; P <= 3'b101; end
			8'd45:  begin F <= 8'b10110100; P <= 3'b101; end
			8'd46:  begin F <= 8'b10111000; P <= 3'b101; end
			8'd47:  begin F <= 8'b10111100; P <= 3'b101; end
			8'd48:  begin F <= 8'b11000000; P <= 3'b101; end
			8'd49:  begin F <= 8'b11000100; P <= 3'b101; end
			8'd50:  begin F <= 8'b11001000; P <= 3'b101; end
			8'd51:  begin F <= 8'b11001100; P <= 3'b101; end
			8'd52:  begin F <= 8'b11010000; P <= 3'b101; end
			8'd53:  begin F <= 8'b11010100; P <= 3'b101; end
			8'd54:  begin F <= 8'b11011000; P <= 3'b101; end
			8'd55:  begin F <= 8'b11011100; P <= 3'b101; end
			8'd56:  begin F <= 8'b11100000; P <= 3'b101; end
			8'd57:  begin F <= 8'b11100100; P <= 3'b101; end
			8'd58:  begin F <= 8'b11101000; P <= 3'b101; end
			8'd59:  begin F <= 8'b11101100; P <= 3'b101; end
			8'd60:  begin F <= 8'b11110000; P <= 3'b101; end
			8'd61:  begin F <= 8'b11110100; P <= 3'b101; end
			8'd62:  begin F <= 8'b11111000; P <= 3'b101; end
			8'd63:  begin F <= 8'b11111100; P <= 3'b101; end
			8'd64:  begin F <= 8'b10000000; P <= 3'b110; end
			8'd65:  begin F <= 8'b10000010; P <= 3'b110; end
			8'd66:  begin F <= 8'b10000100; P <= 3'b110; end
			8'd67:  begin F <= 8'b10000110; P <= 3'b110; end
			8'd68:  begin F <= 8'b10001000; P <= 3'b110; end
			8'd69:  begin F <= 8'b10001010; P <= 3'b110; end
			8'd70:  begin F <= 8'b10001100; P <= 3'b110; end
			8'd71:  begin F <= 8'b10001110; P <= 3'b110; end
			8'd72:  begin F <= 8'b10010000; P <= 3'b110; end
			8'd73:  begin F <= 8'b10010010; P <= 3'b110; end
			8'd74:  begin F <= 8'b10010100; P <= 3'b110; end
			8'd75:  begin F <= 8'b10010110; P <= 3'b110; end
			8'd76:  begin F <= 8'b10011000; P <= 3'b110; end
			8'd77:  begin F <= 8'b10011010; P <= 3'b110; end
			8'd78:  begin F <= 8'b10011100; P <= 3'b110; end
			8'd79:  begin F <= 8'b10011110; P <= 3'b110; end
			8'd80:  begin F <= 8'b10100000; P <= 3'b110; end
			8'd81:  begin F <= 8'b10100010; P <= 3'b110; end
			8'd82:  begin F <= 8'b10100100; P <= 3'b110; end
			8'd83:  begin F <= 8'b10100110; P <= 3'b110; end
			8'd84:  begin F <= 8'b10101000; P <= 3'b110; end
			8'd85:  begin F <= 8'b10101010; P <= 3'b110; end
			8'd86:  begin F <= 8'b10101100; P <= 3'b110; end
			8'd87:  begin F <= 8'b10101110; P <= 3'b110; end
			8'd88:  begin F <= 8'b10110000; P <= 3'b110; end
			8'd89:  begin F <= 8'b10110010; P <= 3'b110; end
			8'd90:  begin F <= 8'b10110100; P <= 3'b110; end
			8'd91:  begin F <= 8'b10110110; P <= 3'b110; end
			8'd92:  begin F <= 8'b10111000; P <= 3'b110; end
			8'd93:  begin F <= 8'b10111010; P <= 3'b110; end
			8'd94:  begin F <= 8'b10111100; P <= 3'b110; end
			8'd95:  begin F <= 8'b10111110; P <= 3'b110; end
			8'd96:  begin F <= 8'b11000000; P <= 3'b110; end
			8'd97:  begin F <= 8'b11000010; P <= 3'b110; end
			8'd98:  begin F <= 8'b11000100; P <= 3'b110; end
			8'd99:  begin F <= 8'b11000110; P <= 3'b110; end
			8'd100: begin F <= 8'b11001000; P <= 3'b110; end
			8'd101: begin F <= 8'b11001010; P <= 3'b110; end
			8'd102: begin F <= 8'b11001100; P <= 3'b110; end
			8'd103: begin F <= 8'b11001110; P <= 3'b110; end
			8'd104: begin F <= 8'b11010000; P <= 3'b110; end
			8'd105: begin F <= 8'b11010010; P <= 3'b110; end
			8'd106: begin F <= 8'b11010100; P <= 3'b110; end
			8'd107: begin F <= 8'b11010110; P <= 3'b110; end
			8'd108: begin F <= 8'b11011000; P <= 3'b110; end
			8'd109: begin F <= 8'b11011010; P <= 3'b110; end
			8'd110: begin F <= 8'b11011100; P <= 3'b110; end
			8'd111: begin F <= 8'b11011110; P <= 3'b110; end
			8'd112: begin F <= 8'b11100000; P <= 3'b110; end
			8'd113: begin F <= 8'b11100010; P <= 3'b110; end
			8'd114: begin F <= 8'b11100100; P <= 3'b110; end
			8'd115: begin F <= 8'b11100110; P <= 3'b110; end
			8'd116: begin F <= 8'b11101000; P <= 3'b110; end
			8'd117: begin F <= 8'b11101010; P <= 3'b110; end
			8'd118: begin F <= 8'b11101100; P <= 3'b110; end
			8'd119: begin F <= 8'b11101110; P <= 3'b110; end
			8'd120: begin F <= 8'b11110000; P <= 3'b110; end
			8'd121: begin F <= 8'b11110010; P <= 3'b110; end
			8'd122: begin F <= 8'b11110100; P <= 3'b110; end
			8'd123: begin F <= 8'b11110110; P <= 3'b110; end
			8'd124: begin F <= 8'b11111000; P <= 3'b110; end
			8'd125: begin F <= 8'b11111010; P <= 3'b110; end
			8'd126: begin F <= 8'b11111100; P <= 3'b110; end
			8'd127: begin F <= 8'b11111110; P <= 3'b110; end
			8'd128: begin F <= 8'b10000000; P <= 3'b111; end
			8'd129: begin F <= 8'b10000001; P <= 3'b111; end
			8'd130: begin F <= 8'b10000010; P <= 3'b111; end
			8'd131: begin F <= 8'b10000011; P <= 3'b111; end
			8'd132: begin F <= 8'b10000100; P <= 3'b111; end
			8'd133: begin F <= 8'b10000101; P <= 3'b111; end
			8'd134: begin F <= 8'b10000110; P <= 3'b111; end
			8'd135: begin F <= 8'b10000111; P <= 3'b111; end
			8'd136: begin F <= 8'b10001000; P <= 3'b111; end
			8'd137: begin F <= 8'b10001001; P <= 3'b111; end
			8'd138: begin F <= 8'b10001010; P <= 3'b111; end
			8'd139: begin F <= 8'b10001011; P <= 3'b111; end
			8'd140: begin F <= 8'b10001100; P <= 3'b111; end
			8'd141: begin F <= 8'b10001101; P <= 3'b111; end
			8'd142: begin F <= 8'b10001110; P <= 3'b111; end
			8'd143: begin F <= 8'b10001111; P <= 3'b111; end
			8'd144: begin F <= 8'b10010000; P <= 3'b111; end
			8'd145: begin F <= 8'b10010001; P <= 3'b111; end
			8'd146: begin F <= 8'b10010010; P <= 3'b111; end
			8'd147: begin F <= 8'b10010011; P <= 3'b111; end
			8'd148: begin F <= 8'b10010100; P <= 3'b111; end
			8'd149: begin F <= 8'b10010101; P <= 3'b111; end
			8'd150: begin F <= 8'b10010110; P <= 3'b111; end
			8'd151: begin F <= 8'b10010111; P <= 3'b111; end
			8'd152: begin F <= 8'b10011000; P <= 3'b111; end
			8'd153: begin F <= 8'b10011001; P <= 3'b111; end
			8'd154: begin F <= 8'b10011010; P <= 3'b111; end
			8'd155: begin F <= 8'b10011011; P <= 3'b111; end
			8'd156: begin F <= 8'b10011100; P <= 3'b111; end
			8'd157: begin F <= 8'b10011101; P <= 3'b111; end
			8'd158: begin F <= 8'b10011110; P <= 3'b111; end
			8'd159: begin F <= 8'b10011111; P <= 3'b111; end
			8'd160: begin F <= 8'b10100000; P <= 3'b111; end
			8'd161: begin F <= 8'b10100001; P <= 3'b111; end
			8'd162: begin F <= 8'b10100010; P <= 3'b111; end
			8'd163: begin F <= 8'b10100011; P <= 3'b111; end
			8'd164: begin F <= 8'b10100100; P <= 3'b111; end
			8'd165: begin F <= 8'b10100101; P <= 3'b111; end
			8'd166: begin F <= 8'b10100110; P <= 3'b111; end
			8'd167: begin F <= 8'b10100111; P <= 3'b111; end
			8'd168: begin F <= 8'b10101000; P <= 3'b111; end
			8'd169: begin F <= 8'b10101001; P <= 3'b111; end
			8'd170: begin F <= 8'b10101010; P <= 3'b111; end
			8'd171: begin F <= 8'b10101011; P <= 3'b111; end
			8'd172: begin F <= 8'b10101100; P <= 3'b111; end
			8'd173: begin F <= 8'b10101101; P <= 3'b111; end
			8'd174: begin F <= 8'b10101110; P <= 3'b111; end
			8'd175: begin F <= 8'b10101111; P <= 3'b111; end
			8'd176: begin F <= 8'b10110000; P <= 3'b111; end
			8'd177: begin F <= 8'b10110001; P <= 3'b111; end
			8'd178: begin F <= 8'b10110010; P <= 3'b111; end
			8'd179: begin F <= 8'b10110011; P <= 3'b111; end
			8'd180: begin F <= 8'b10110100; P <= 3'b111; end
			8'd181: begin F <= 8'b10110101; P <= 3'b111; end
			8'd182: begin F <= 8'b10110110; P <= 3'b111; end
			8'd183: begin F <= 8'b10110111; P <= 3'b111; end
			8'd184: begin F <= 8'b10111000; P <= 3'b111; end
			8'd185: begin F <= 8'b10111001; P <= 3'b111; end
			8'd186: begin F <= 8'b10111010; P <= 3'b111; end
			8'd187: begin F <= 8'b10111011; P <= 3'b111; end
			8'd188: begin F <= 8'b10111100; P <= 3'b111; end
			8'd189: begin F <= 8'b10111101; P <= 3'b111; end
			8'd190: begin F <= 8'b10111110; P <= 3'b111; end
			8'd191: begin F <= 8'b10111111; P <= 3'b111; end
			8'd192: begin F <= 8'b11000000; P <= 3'b111; end
			8'd193: begin F <= 8'b11000001; P <= 3'b111; end
			8'd194: begin F <= 8'b11000010; P <= 3'b111; end
			8'd195: begin F <= 8'b11000011; P <= 3'b111; end
			8'd196: begin F <= 8'b11000100; P <= 3'b111; end
			8'd197: begin F <= 8'b11000101; P <= 3'b111; end
			8'd198: begin F <= 8'b11000110; P <= 3'b111; end
			8'd199: begin F <= 8'b11000111; P <= 3'b111; end
			8'd200: begin F <= 8'b11001000; P <= 3'b111; end
			8'd201: begin F <= 8'b11001001; P <= 3'b111; end
			8'd202: begin F <= 8'b11001010; P <= 3'b111; end
			8'd203: begin F <= 8'b11001011; P <= 3'b111; end
			8'd204: begin F <= 8'b11001100; P <= 3'b111; end
			8'd205: begin F <= 8'b11001101; P <= 3'b111; end
			8'd206: begin F <= 8'b11001110; P <= 3'b111; end
			8'd207: begin F <= 8'b11001111; P <= 3'b111; end
			8'd208: begin F <= 8'b11010000; P <= 3'b111; end
			8'd209: begin F <= 8'b11010001; P <= 3'b111; end
			8'd210: begin F <= 8'b11010010; P <= 3'b111; end
			8'd211: begin F <= 8'b11010011; P <= 3'b111; end
			8'd212: begin F <= 8'b11010100; P <= 3'b111; end
			8'd213: begin F <= 8'b11010101; P <= 3'b111; end
			8'd214: begin F <= 8'b11010110; P <= 3'b111; end
			8'd215: begin F <= 8'b11010111; P <= 3'b111; end
			8'd216: begin F <= 8'b11011000; P <= 3'b111; end
			8'd217: begin F <= 8'b11011001; P <= 3'b111; end
			8'd218: begin F <= 8'b11011010; P <= 3'b111; end
			8'd219: begin F <= 8'b11011011; P <= 3'b111; end
			8'd220: begin F <= 8'b11011100; P <= 3'b111; end
			8'd221: begin F <= 8'b11011101; P <= 3'b111; end
			8'd222: begin F <= 8'b11011110; P <= 3'b111; end
			8'd223: begin F <= 8'b11011111; P <= 3'b111; end
			8'd224: begin F <= 8'b11100000; P <= 3'b111; end
			8'd225: begin F <= 8'b11100001; P <= 3'b111; end
			8'd226: begin F <= 8'b11100010; P <= 3'b111; end
			8'd227: begin F <= 8'b11100011; P <= 3'b111; end
			8'd228: begin F <= 8'b11100100; P <= 3'b111; end
			8'd229: begin F <= 8'b11100101; P <= 3'b111; end
			8'd230: begin F <= 8'b11100110; P <= 3'b111; end
			8'd231: begin F <= 8'b11100111; P <= 3'b111; end
			8'd232: begin F <= 8'b11101000; P <= 3'b111; end
			8'd233: begin F <= 8'b11101001; P <= 3'b111; end
			8'd234: begin F <= 8'b11101010; P <= 3'b111; end
			8'd235: begin F <= 8'b11101011; P <= 3'b111; end
			8'd236: begin F <= 8'b11101100; P <= 3'b111; end
			8'd237: begin F <= 8'b11101101; P <= 3'b111; end
			8'd238: begin F <= 8'b11101110; P <= 3'b111; end
			8'd239: begin F <= 8'b11101111; P <= 3'b111; end
			8'd240: begin F <= 8'b11110000; P <= 3'b111; end
			8'd241: begin F <= 8'b11110001; P <= 3'b111; end
			8'd242: begin F <= 8'b11110010; P <= 3'b111; end
			8'd243: begin F <= 8'b11110011; P <= 3'b111; end
			8'd244: begin F <= 8'b11110100; P <= 3'b111; end
			8'd245: begin F <= 8'b11110101; P <= 3'b111; end
			8'd246: begin F <= 8'b11110110; P <= 3'b111; end
			8'd247: begin F <= 8'b11110111; P <= 3'b111; end
			8'd248: begin F <= 8'b11111000; P <= 3'b111; end
			8'd249: begin F <= 8'b11111001; P <= 3'b111; end
			8'd250: begin F <= 8'b11111010; P <= 3'b111; end
			8'd251: begin F <= 8'b11111011; P <= 3'b111; end
			8'd252: begin F <= 8'b11111100; P <= 3'b111; end
			8'd253: begin F <= 8'b11111101; P <= 3'b111; end
			8'd254: begin F <= 8'b11111110; P <= 3'b111; end
			8'd255: begin F <= 8'b11111111; P <= 3'b111; end
		endcase
	end

endmodule
