* FILE: DCN_RP-NOR4.sp
*.include '90nm_bulk.txt'
*.param size=90n

*VDD vdd 0 1.2
*VA A 0 PULSE 0 1.2 8ns 5ps 5ps 8ns 16ns
*VA_bar A_bar 0 PULSE 1.2 0 8ns 5ps 5ps 8ns 16ns
*VB B 0 PULSE 0 1.2 4ns 5ps 5ps 4ns 8ns
*VB_bar B_bar 0 PULSE 1.2 0 4ns 5ps 5ps 4ns 8ns
*VC C 0 PULSE 0 1.2 2ns 5ps 5ps 2ns 4ns
*VC_bar C_bar 0 PULSE 1.2 0 2ns 5ps 5ps 2ns 4ns
*VD_bar D_bar 0 PULSE 1.2 0 1ns 5ps 5ps 1ns 2ns

.SUBCKT DCN_RP-NOR4 A A_bar B B_bar C C_bar D_bar GP 
M_1 GP A_bar GND gnd NMOS W='1*size' L=size
M_2 GP B_bar GND gnd NMOS W='1*size' L=size
M_3 GP C_bar GND gnd NMOS W='1*size' L=size
M_4 GP D_bar GND gnd NMOS W='1*size' L=size
M_5 GP D_bar net_3 vdd PMOS W='4*size' L=size
M_6 net_3 net_1 VDD vdd PMOS W='4*size' L=size
M_7 net_1 C net_4 gnd NMOS W='3*size' L=size
M_8 net_4 B net_2 gnd NMOS W='3*size' L=size
M_9 net_2 A GND gnd NMOS W='3*size' L=size
M_10 net_1 C VDD vdd PMOS W='2*size' L=size
M_11 net_1 B VDD vdd PMOS W='2*size' L=size
M_12 net_1 A VDD vdd PMOS W='2*size' L=size
.ENDS	$ DCN_RP-NOR4

*.GLOBAL gnd vdd
*.TRAN 5ps 20ns
*.OPTIONS post=2 nomod
.END

