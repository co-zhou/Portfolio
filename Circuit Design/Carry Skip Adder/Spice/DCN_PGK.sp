* FILE: DCN_PGK.sp
*.include '90nm_bulk.txt'
*.param size=90n

*VDD vdd 0 1.2
*VCin Cin 0 PULSE 0 1.2 8ns 5ps 5ps 8ns 16ns
*VCin_bar Cin_bar 0 PULSE 1.2 0 8ns 5ps 5ps 8ns 16ns
*VP P 0 PULSE 0 1.2 4ns 5ps 5ps 4ns 8ns
*VK K 0 PULSE 0 1.2 2ns 5ps 5ps 2ns 4ns
*VK_bar K_bar 0 PULSE 1.2 0 2ns 5ps 5ps 2ns 4ns
*VG G 0 PULSE 0 1.2 1ns 5ps 5ps 1ns 2ns
*VG_bar G_bar 0 PULSE 1.2 0 1ns 5ps 5ps 1ns 2ns

.SUBCKT DCN_PGK Cin Cin_bar Cout Cout_bar G G_bar K K_bar P 
M_1 Cout K GND gnd NMOS W='1*size' L=size
M_2 Cout P Cin gnd NMOS W='1*size' L=size
M_3 Cout_bar P Cin_bar gnd NMOS W='1*size' L=size
M_4 Cout_bar G GND gnd NMOS W='1*size' L=size
M_5 Cout G_bar VDD vdd PMOS W='2*size' L=size
M_6 Cout_bar K_bar VDD vdd PMOS W='2*size' L=size
.ENDS	$ DCN_PGK

*.GLOBAL gnd vdd
*.TRAN 5ps 20ns
*.OPTIONS post=2 nomod
.END

