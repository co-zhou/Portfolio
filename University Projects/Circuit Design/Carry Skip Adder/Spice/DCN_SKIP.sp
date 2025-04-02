* FILE: DCN_SKIP.sp
*.include '90nm_bulk.txt'
*.param size=90n

*VCin Cin 0 PULSE 0 1.2 1ns 5ps 5ps 5ns 10ns
*VCin_bar Cin_bar 0 PULSE 1.2 0 1ns 5ps 5ps 5ns 10ns
*VGP GP 0 PULSE 0 1.2 3.5ns 5ps 5ps 5ns 10ns

.SUBCKT DCN_SKIP Cin Cin_bar Cout Cout_bar GP 
M_1 Cout GP Cin gnd NMOS W='1*size' L=size
M_2 Cout_bar GP Cin_bar gnd NMOS W='1*size' L=size
.ENDS	$ DCN_SKIP

*.TRAN 5ps 20ns
*.OPTIONS post=2 nomod
.END

