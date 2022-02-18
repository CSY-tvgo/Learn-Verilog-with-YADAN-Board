module blink_top(input BUTTON_A,
                 input BUTTON_B,
                 output LED_A,
                 output LED_B);
    
    assign LED_A = ~BUTTON_A;
    assign LED_B = BUTTON_B;
    
endmodule
    
