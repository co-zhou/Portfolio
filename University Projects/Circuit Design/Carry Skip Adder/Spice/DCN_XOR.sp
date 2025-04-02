* FILE: DCN_XOR.sp
*.include '90nm_bulk.txt'
*.param size=90n

*VCin Cin 0 PULSE 0 1.2 1ns 5ps 5ps 5ns 10ns
*VCin_bar Cin_bar 0 PULSE 1.2 0 1ns 5ps 5ps 5ns 10ns
*VP P 0 PULSE 0 1.2 3.5ns 5ps 5ps 5ns 10ns
*VP_bar P_bar 0 PULSE 1.2 0 3.5ns 5ps 5ps 5ns 10ns

.SUBCKT DCN_XOR Cin Cin_bar P P_bar S S_bar 
M_1 S P_bar Cin gnd NMOS W='1*size' L=size
M_2 S_bar P_bar Cin_bar gnd NMOS W='1*size' L=size
M_3 S P Cin_bar gnd NMOS W='1*size' L=size 
M_4 S_bar P Cin gnd NMOS W='1*size' L=size
.ENDS	$ DCN_XOR

*.TRAN 5ps 20ns
*.OPTIONS post=2 nomod
.END

