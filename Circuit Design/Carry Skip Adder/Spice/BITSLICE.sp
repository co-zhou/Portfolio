* FILE: BITSLICE.sp

*.include '90nm_bulk.txt'
.include 'CDL_P.sp'
.include 'CDL_G.sp'
.include 'CDL_K.sp'
.include 'DCN_PGK.sp'
.include 'DCN_XOR.sp'
.include 'SA.sp'

*.param size=90n

*VDD vdd 0 1.2

*VA A 0 PULSE 0 1.2 80ns 5ps 5ps 80ns 160ns
*VA_bar A_bar 0 PULSE 1.2 0 80ns 5ps 5ps 80ns 160ns
*VB B 0 PULSE 0 1.2 40ns 5ps 5ps 40ns 80ns
*VB_bar B_bar 0 PULSE 1.2 0 40ns 5ps 5ps 40ns 80ns
*VCin Cin 0 PULSE 0 1.2 20ns 5ps 5ps 20ns 40ns
*VCin_bar Cin_bar 0 PULSE 1.2 0 20ns 5ps 5ps 20ns 40ns
*VClk Clk 0 PULSE 0 1.2 10ns 5ps 5ps 10ns 20ns

.SUBCKT BITSLICE A A_bar B B_bar Cin Cin_bar Clk Cout Cout_bar P P_bar S S_bar 
XCDL_G A A_bar B B_bar Clk net_2 net_3 CDL_G 
XDCN_XOR Cin Cin_bar P P_bar net_7 net_1 DCN_XOR 
XCDL_P A A_bar B B_bar Clk P P_bar CDL_P 
XCDL_K A A_bar B B_bar Clk net_4 net_6 CDL_K 
XDCN_PGK Cin Cin_bar net_9 net_5 net_2 net_3 net_4 net_6 P DCN_PGK 
XSA net_8 net_7 net_1 S S_bar SA 
M_1 net_8 Clk GND gnd NMOS W='1*size' L=size
M_2 net_8 Clk VDD vdd PMOS W='2*size' L=size
XSA_1 net_8 net_9 net_5 Cout Cout_bar SA 
.ENDS	$ BITSLICE

*.GLOBAL gnd vdd

.END

