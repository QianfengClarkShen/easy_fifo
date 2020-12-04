`define GEN_CLK(CLK,PERIOD,INIT) initial begin \
CLK = INIT;\
forever begin \
    #(PERIOD/2) CLK = ~ CLK; \
end \
end