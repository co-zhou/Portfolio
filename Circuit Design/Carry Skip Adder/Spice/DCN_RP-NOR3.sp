* FILE: DCN_RP-NOR3.sp
*.include '90nm_bulk.txt'
*.param size=90n

*VDD vdd 0 1.2
*VA A 0 PULSE 0 1.2 4ns 5ps 5ps 4ns 8ns
*VA_bar A_bar 0 PULSE 1.2 0 4ns 5ps 5ps 4ns 8ns
*VB B 0 PULSE 0 1.2 2ns 5ps 5ps 2ns 4ns
*VB_bar B_bar 0 PULSE 1.2 0 2ns 5ps 5ps 2ns 4ns
*VC_bar C_bar 0 PULSE 1.2 0 1ns 5ps 5ps 1ns 2ns

.SUBCKT DCN_RP-NOR3 A A_bar B B_bar C_bar GP 
M_1 GP A_bar GND gnd NMOS W='1*size' L=size
M_2 GP B_bar GND gnd NMOS W='1*size' L=size
M_3 GP C_bar GND gnd NMOS W='1*size' L=size
M_4 GP C_bar net_1 vdd PMOS W='4*size' L=size
M_5 net_1 net_3 VDD vdd PMOS W='4*size' L=size
M_6 net_3 B VDD vdd PMOS W='2*size' L=size
M_7 net_3 A VDD vdd PMOS W='2*size' L=size
M_8 net_2 A GND gnd NMOS W='2*size' L=size
M_9 net_3 B net_2 gnd NMOS W='2*size' L=size
.ENDS	$ DCN_RP-NOR3

*.GLOBAL gnd vdd
*.TRAN 5ps 10ns
*.OPTIONS post=2 nomod
.END

