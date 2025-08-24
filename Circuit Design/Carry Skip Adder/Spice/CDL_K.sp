* FILE: CDL_K.sp
*.include '90nm_bulk.txt'

*.param size=90n

*VDD vdd 0 1.2
*VA A 0 PULSE 0 1.2 1ns 5ps 5ps 5ns 10ns
*VA_bar A_bar 0 PULSE 1.2 0 1ns 5ps 5ps 5ns 10ns
*VB B 0 PULSE 0 1.2 3.5ns 5ps 5ps 5ns 10ns
*VB_bar B_bar 0 PULSE 1.2 0 3.5ns 5ps 5ps 5ns 10ns
*VClk Clk 0 PULSE 0 1.2 0.5ns 5ps 5ps 0.5ns 1ns

.SUBCKT CDL_K A A_bar B B_bar Clk K K_bar 
M_1 net_3 Clk VDD vdd PMOS W='2*size' L=size
M_2 K net_3 VDD vdd PMOS W='2*size' L=size
M_3 K net_3 GND gnd NMOS W='1*size' L=size
M_4 net_1 Clk VDD vdd PMOS W='2*size' L=size
M_5 net_1 A GND gnd NMOS W='1*size' L=size 
M_6 net_1 B GND gnd NMOS W='1*size' L=size
M_7 K_bar net_1 VDD vdd PMOS W='2*size' L=size
M_8 K_bar net_1 GND gnd NMOS W='1*size' L=size
M_9 net_1 net_3 VDD vdd PMOS W='1*size' L=size
M_10 net_3 net_1 VDD vdd PMOS W='1*size' L=size
M_11 net_3 A_bar net_2 gnd NMOS W='2*size' L=size
M_12 net_2 B_bar GND gnd NMOS W='2*size' L=size
.ENDS	$ CDL_K

*.GLOBAL gnd vdd
*.TRAN 5ps 20ns
*.OPTIONS post=2 nomod
.END

