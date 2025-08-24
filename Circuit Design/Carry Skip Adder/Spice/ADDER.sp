* FILE: ADDER.sp

*.include '45nm_bulk.txt'
*.include '65nm_bulk.txt'
.include '90nm_bulk.txt'

.include 'BITSLICE.sp'
.include 'DCN_SKIP.sp'
.include 'DCN_RP-NOR4.sp'
.include 'DCN_RP-NOR3.sp'
.include 'DCN_RP-NOR2.sp'

.VEC ‘input.vec’

*.param size=45n vddp=0.7
*.param size=65n vddp=1.0
.param size=90n vddp=1.2

*.TEMP 27 30 40 50

VDD vdd 0 vddp
VClk Clk 0 PULSE 0 1.2 100ns 5ps 5ps 100ns 200ns

* .SUBCKT ADDER A0 A1 A10 A11 A12 A13 A14 A15 A2 A3 A4 A5 A6 A7 A8 A9 
*+ A_bar0 A_bar1 A_bar10 A_bar11 A_bar12 A_bar13 A_bar14 A_bar15 A_bar2 
*+ A_bar3 A_bar4 A_bar5 A_bar6 A_bar7 A_bar8 A_bar9 B0 B1 B10 B11 B12 
*+ B13 B14 B15 B2 B3 B4 B5 B6 B7 B8 B9 B_bar0 B_bar1 B_bar10 B_bar11 
*+ B_bar12 B_bar13 B_bar14 B_bar15 B_bar2 B_bar3 B_bar4 B_bar5 B_bar6 
*+ B_bar7 B_bar8 B_bar9 Cin Cin_bar Clk Cout Cout_bar S0 S1 S10 S11 S12 
*+ S13 S14 S15 S2 S3 S4 S5 S6 S7 S8 S9 S_bar0 S_bar1 S_bar10 S_bar11 
*+ S_bar12 S_bar13 S_bar14 S_bar15 S_bar2 S_bar3 S_bar4 S_bar5 S_bar6 
*+ S_bar7 S_bar8 S_bar9 
XDCN_SKIP Cin Cin_bar net_7 net_5 net_67 DCN_SKIP 
XBITSLICE A1 A_bar1 B1 B_bar1 net_25 net_41 Clk net_57 net_61 net_39 
+ net_11 S1 S_bar1 BITSLICE 
XBITSLICE_1 A0 A_bar0 B0 B_bar0 Cin Cin_bar Clk net_25 net_41 net_6 
+ net_35 S0 S_bar0 BITSLICE 
XBITSLICE_2 A3 A_bar3 B3 B_bar3 net_7 net_5 Clk net_63 net_66 net_18 
+ net_13 S3 S_bar3 BITSLICE 
XBITSLICE_3 A2 A_bar2 B2 B_bar2 net_57 net_61 Clk net_7 net_5 uc_net_68 
+ net_27 S2 S_bar2 BITSLICE 
XBITSLICE_4 A5 A_bar5 B5 B_bar5 net_9 net_30 Clk net_72 net_20 net_17 
+ net_37 S5 S_bar5 BITSLICE 
XBITSLICE_5 A4 A_bar4 B4 B_bar4 net_63 net_66 Clk net_9 net_30 net_3 
+ net_8 S4 S_bar4 BITSLICE 
XBITSLICE_6 A7 A_bar7 B7 B_bar7 net_36 net_4 Clk net_33 net_50 net_45 
+ net_48 S7 S_bar7 BITSLICE 
XBITSLICE_7 A6 A_bar6 B6 B_bar6 net_72 net_20 Clk net_36 net_4 uc_net_52 
+ net_10 S6 S_bar6 BITSLICE 
XBITSLICE_8 A9 A_bar9 B9 B_bar9 net_34 net_14 Clk net_31 net_44 net_58 
+ net_51 S9 S_bar9 BITSLICE 
XBITSLICE_9 A8 A_bar8 B8 B_bar8 net_33 net_50 Clk net_34 net_14 net_15 
+ net_28 S8 S_bar8 BITSLICE 
XBITSLICE_10 A11 A_bar11 B11 B_bar11 net_43 net_29 Clk net_53 net_56 
+ net_32 net_23 S11 S_bar11 BITSLICE 
XBITSLICE_11 A10 A_bar10 B10 B_bar10 net_31 net_44 Clk net_43 net_29 
+ uc_net_69 net_1 S10 S_bar10 BITSLICE 
XBITSLICE_12 A13 A_bar13 B13 B_bar13 net_60 net_22 Clk net_19 net_12 
+ net_46 net_42 S13 S_bar13 BITSLICE 
XBITSLICE_13 A12 A_bar12 B12 B_bar12 net_53 net_56 Clk net_60 net_22 
+ net_26 net_49 S12 S_bar12 BITSLICE 
XBITSLICE_14 A15 A_bar15 B15 B_bar15 net_16 net_21 Clk Cout Cout_bar 
+ uc_net_62 uc_net_59 S15 S_bar15 BITSLICE 
XBITSLICE_15 A14 A_bar14 B14 B_bar14 net_19 net_12 Clk net_16 net_21 
+ uc_net_54 net_38 S14 S_bar14 BITSLICE 
XDCN_RP-NOR2 net_11 net_27 net_70 DCN_RP-NOR2 
XDCN_SKIP_1 net_25 net_41 net_7 net_5 net_70 DCN_SKIP 
XDCN_RP-NOR3 net_6 net_35 net_39 net_11 net_27 net_67 DCN_RP-NOR3 
XDCN_RP-NOR2_1 net_37 net_10 net_24 DCN_RP-NOR2 
XDCN_SKIP_2 net_9 net_30 net_36 net_4 net_24 DCN_SKIP 
XDCN_RP-NOR4 net_18 net_13 net_3 net_8 net_17 net_37 net_10 net_64 
+ DCN_RP-NOR4 
XDCN_SKIP_3 net_7 net_5 net_36 net_4 net_64 DCN_SKIP 
XDCN_RP-NOR2_2 net_48 net_28 net_65 DCN_RP-NOR2 
XDCN_SKIP_4 net_36 net_4 net_34 net_14 net_65 DCN_SKIP 
XDCN_RP-NOR2_3 net_51 net_1 net_2 DCN_RP-NOR2 
XDCN_SKIP_5 net_34 net_14 net_43 net_29 net_2 DCN_SKIP 
XDCN_RP-NOR4_1 net_45 net_48 net_15 net_28 net_58 net_51 net_1 net_47 
+ DCN_RP-NOR4 
XDCN_SKIP_6 net_36 net_4 net_43 net_29 net_47 DCN_SKIP 
XDCN_RP-NOR2_4 net_23 net_49 net_40 DCN_RP-NOR2 
XDCN_SKIP_7 net_43 net_29 net_60 net_22 net_40 DCN_SKIP 
XDCN_SKIP_8 net_43 net_29 net_19 net_12 net_55 DCN_SKIP 
XDCN_RP-NOR3_1 net_32 net_23 net_26 net_49 net_42 net_55 DCN_RP-NOR3 
XDCN_RP-NOR4_2 net_32 net_23 net_26 net_49 net_46 net_42 net_38 net_71 
+ DCN_RP-NOR4 
XDCN_SKIP_9 net_43 net_29 net_16 net_21 net_71 DCN_SKIP 
* .ENDS	$ ADDER

.GLOBAL gnd vdd
.TRAN 5ps 1000ns
.MEAS TRAN worst TRIG V(Cin) VAL='vddp/2' RISE=1 TARG V(Cout) VAL='vddp/2' RISE=1
.MEAS TRAN best TRIG V(B15) VAL='vddp/2' FALL=1 TARG V(Cout) VAL='vddp/2' FALL=2
.MEAS TRAN I_avg AVG I(VDD) FROM=0ns TO=1000ns
.OPTIONS post=2 nomod

.END

