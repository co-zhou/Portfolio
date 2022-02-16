* FILE: DCN_RP-NOR2.sp

*.include '90nm_bulk.txt'
*.param size=90n

*VDD vdd 0 1.2

*VA_bar A_bar 0 PULSE 1.2 0 2ns 5ps 5ps 2ns 4ns
*VB_bar B_bar 0 PULSE 1.2 0 1ns 5ps 5ps 1ns 2ns

.SUBCKT DCN_RP-NOR2 A_bar B_bar GP 
M_1 GP B_bar GND gnd NMOS W='1*size' L=size
M_2 GP B_bar net_1 vdd PMOS W='4*size' L=size
M_3 net_1 A_bar VDD vdd PMOS W='4*size' L=size 
M_4 GP A_bar GND gnd NMOS W='1*size' L=size
.ENDS	$ DCN_RP-NOR2

*.GLOBAL gnd vdd
*.TRAN 5ps 4ns
*.OPTIONS post=2 nomod

.END

