* FILE: CDL_P.sp
*.include '90nm_bulk.txt'

*.param size=90n

*VDD vdd 0 1.2
*VA A 0 PULSE 0 1.2 1ns 5ps 5ps 5ns 10ns
*VA_bar A_bar 0 PULSE 1.2 0 1ns 5ps 5ps 5ns 10ns
*VB B 0 PULSE 0 1.2 3.5ns 5ps 5ps 5ns 10ns
*VB_bar B_bar 0 PULSE 1.2 0 3.5ns 5ps 5ps 5ns 10ns
*VClk Clk 0 PULSE 0 1.2 0.5ns 5ps 5ps 0.5ns 1ns

.SUBCKT CDL_P A A_bar B B_bar Clk P P_bar 
M_1 net_2 Clk VDD vdd PMOS W='2*size' L=size  
M_2 P net_2 VDD vdd PMOS W='2*size' L=size  
M_3 P net_2 GND gnd NMOS W='1*size' L=size 
M_4 net_3 Clk VDD vdd PMOS W='2*size' L=size  
M_5 P_bar net_3 VDD vdd PMOS W='2*size' L=size  
M_6 P_bar net_3 GND gnd NMOS W='1*size' L=size
M_7 net_3 net_2 VDD vdd PMOS W='1*size' L=size
M_8 net_2 net_3 VDD vdd PMOS W='1*size' L=size
M_9 net_2 A net_1 gnd NMOS W='2*size' L=size
M_10 net_1 B_bar GND gnd NMOS W='2*size' L=size
M_11 net_5 B GND gnd NMOS W='2*size' L=size
M_12 net_2 A_bar net_5 gnd NMOS W='2*size' L=size
M_13 net_3 A net_4 gnd NMOS W='2*size' L=size
M_14 net_4 B GND gnd NMOS W='2*size' L=size
M_15 net_6 B_bar GND gnd NMOS W='2*size' L=size
M_16 net_3 A_bar net_6 gnd NMOS W='2*size' L=size
.ENDS	$ CDL_P

*.GLOBAL gnd vdd
*.TRAN 5ps 20ns

*.OPTIONS post=2 nomod
.END

