* FILE: CDL_G.sp
*.include '90nm_bulk.txt'

*.param size=90n

*VDD vdd 0 1.2

*VA A 0 PULSE 0 1.2 1ns 5ps 5ps 5ns 10ns
*VA_bar A_bar 0 PULSE 1.2 0 1ns 5ps 5ps 5ns 10ns
*VB B 0 PULSE 0 1.2 3.5ns 5ps 5ps 5ns 10ns
*VB_bar B_bar 0 PULSE 1.2 0 3.5ns 5ps 5ps 5ns 10ns
*VClk Clk 0 PULSE 0 1.2 0.5ns 5ps 5ps 0.5ns 1ns

.SUBCKT CDL_G A A_bar B B_bar Clk G G_bar 
M_1 net_3 B 0 gnd NMOS W='2*size' L=size
M_2 net_2 A net_3 gnd NMOS W='2*size' L=size
M_3 net_2 Clk VDD vdd PMOS W='2*size' L=size
M_4 G net_2 VDD vdd PMOS W='2*size' L=size
M_5 G net_2 0 gnd NMOS W=size L=size
M_6 net_1 Clk VDD vdd PMOS W='2*size' L=size
M_7 net_1 A_bar 0 gnd NMOS W=size L=size
M_8 net_1 B_bar 0 gnd NMOS W=size L=size
M_9 G_bar net_1 VDD vdd PMOS W='2*size' L=size
M_10 G_bar net_1 0 gnd NMOS W=size L=size
M_11 net_1 net_2 VDD vdd PMOS W=size L=size
M_12 net_2 net_1 VDD vdd PMOS W=size L=size
.ENDS	$ CDL_G

*.GLOBAL 0 vdd
*.TRAN 5ps 20ns
*.OPTIONS post=2 nomod

.END

