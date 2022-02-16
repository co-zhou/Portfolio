* FILE: SA.sp
*.include '90nm_bulk.txt'

*.param size=90n

*VDD vdd 0 1.2

*VIn In 0 PULSE 0 0.5 5ns 5ps 5ps 5ns 10ns
*VIn_bar In_bar 0 PULSE 0.5 0 5ns 5ps 5ps 5ns 10ns
*VClk Clk 0 PULSE 0 1.2 0ns 5ps 5ps 1ns 2ns

.SUBCKT SA Clk In In_bar Out Out_bar 
M_1 net_1 Clk VDD vdd PMOS W='8*size' L=size
M_2 Out In_bar net_1 vdd PMOS W='8*size' L=size
M_3 Out_bar In net_1 vdd PMOS W='8*size' L=size
M_4 Out_bar Out GND gnd NMOS W='1*size' L=size 
M_5 Out Out_bar GND gnd NMOS W='1*size' L=size
.ENDS	$ SA

*.GLOBAL gnd vdd
*.TRAN 5ps 20ns
*.OPTIONS post=2 nomod
.END

