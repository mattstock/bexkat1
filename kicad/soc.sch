EESchema Schematic File Version 4
LIBS:soc-cache
EELAYER 26 0
EELAYER END
$Descr USLegal 14000 8500
encoding utf-8
Sheet 1 1
Title "Bexkat 1000 I/O Board"
Date "2017-01-28"
Rev "v2.6"
Comp "Bexkat Systems LLC"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L mstock:ALTERA_DE1_GPIO P2
U 1 1 55410742
P 2250 2150
F 0 "P2" H 2250 3200 60  0000 C CNN
F 1 "ALTERA_DE1_GPIO" H 2250 1100 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_2x20" H 2250 2150 60  0001 C CNN
F 3 "" H 2250 2150 60  0000 C CNN
	1    2250 2150
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR01
U 1 1 554129BF
P 1250 2600
F 0 "#PWR01" H 1250 2450 50  0001 C CNN
F 1 "+3.3V" H 1250 2740 50  0000 C CNN
F 2 "" H 1250 2600 60  0000 C CNN
F 3 "" H 1250 2600 60  0000 C CNN
	1    1250 2600
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR02
U 1 1 55412EAA
P 1400 1700
F 0 "#PWR02" H 1400 1550 50  0001 C CNN
F 1 "+5V" H 1400 1840 50  0000 C CNN
F 2 "" H 1400 1700 60  0000 C CNN
F 3 "" H 1400 1700 60  0000 C CNN
	1    1400 1700
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_02x08_Odd_Even P1
U 1 1 554142A0
P 12400 1450
F 0 "P1" H 12400 1900 50  0000 C CNN
F 1 "LED MATRIX" V 12450 1400 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_2x08" H 12400 250 60  0001 C CNN
F 3 "" H 12400 250 60  0000 C CNN
	1    12400 1450
	1    0    0    -1  
$EndComp
Text Label 12200 1150 2    60   ~ 0
R0
Text Label 12700 1150 0    60   ~ 0
G0
Text Label 12200 1250 2    60   ~ 0
B0
Text Label 12200 1350 2    60   ~ 0
R1
Text Label 12700 1350 0    60   ~ 0
G1
Text Label 12200 1450 2    60   ~ 0
B1
Text Label 12200 1550 2    60   ~ 0
A
Text Label 12700 1550 0    60   ~ 0
B
Text Label 12200 1650 2    60   ~ 0
C
Text Label 12200 1750 2    60   ~ 0
CLK
Text Label 12200 1850 2    60   ~ 0
~OE
Text Label 12700 1750 0    60   ~ 0
STB
NoConn ~ 12700 1650
$Comp
L power:GND #PWR03
U 1 1 554144DC
P 12950 1900
F 0 "#PWR03" H 12950 1650 50  0001 C CNN
F 1 "GND" H 12950 1750 50  0000 C CNN
F 2 "" H 12950 1900 60  0000 C CNN
F 3 "" H 12950 1900 60  0000 C CNN
	1    12950 1900
	1    0    0    -1  
$EndComp
Text Label 2750 1400 0    60   ~ 0
R0
Text Label 1750 1400 2    60   ~ 0
G0
Text Label 2750 1300 0    60   ~ 0
B0
Text Label 1750 1600 2    60   ~ 0
R1
Text Label 2750 1500 0    60   ~ 0
G1
Text Label 1750 1500 2    60   ~ 0
B1
Text Label 2750 1600 0    60   ~ 0
A
Text Label 1750 1800 2    60   ~ 0
B
Text Label 2750 1800 0    60   ~ 0
C
Text Label 1750 2000 2    60   ~ 0
CLK
Text Label 2750 1900 0    60   ~ 0
STB
Text Label 1750 1900 2    60   ~ 0
~OE
$Comp
L power:GND #PWR04
U 1 1 56893A48
P 6350 1750
F 0 "#PWR04" H 6350 1500 50  0001 C CNN
F 1 "GND" H 6350 1600 50  0000 C CNN
F 2 "" H 6350 1750 60  0000 C CNN
F 3 "" H 6350 1750 60  0000 C CNN
	1    6350 1750
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR05
U 1 1 56893A7F
P 4800 1250
F 0 "#PWR05" H 4800 1100 50  0001 C CNN
F 1 "+3.3V" H 4800 1390 50  0000 C CNN
F 2 "" H 4800 1250 60  0000 C CNN
F 3 "" H 4800 1250 60  0000 C CNN
	1    4800 1250
	1    0    0    -1  
$EndComp
Text Label 6000 950  0    60   ~ 0
SCLK_33
Text Label 6000 1050 0    60   ~ 0
MISO_33
Text Label 6000 1250 0    60   ~ 0
MOSI_33
Text Label 5000 950  2    60   ~ 0
~RTC_SS
NoConn ~ 9200 1400
NoConn ~ 9200 1900
Text Label 8200 1300 2    60   ~ 0
Kbd_data
Text Label 8200 1800 2    60   ~ 0
Kbd_clk
$Comp
L power:+5V #PWR06
U 1 1 56893D96
P 8400 950
F 0 "#PWR06" H 8400 800 50  0001 C CNN
F 1 "+5V" H 8400 1090 50  0000 C CNN
F 2 "" H 8400 950 60  0000 C CNN
F 3 "" H 8400 950 60  0000 C CNN
	1    8400 950 
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR07
U 1 1 56893DBF
P 8750 1500
F 0 "#PWR07" H 8750 1250 50  0001 C CNN
F 1 "GND" H 8750 1350 50  0000 C CNN
F 2 "" H 8750 1500 60  0000 C CNN
F 3 "" H 8750 1500 60  0000 C CNN
	1    8750 1500
	1    0    0    -1  
$EndComp
Text Label 1750 1300 2    60   ~ 0
Kbd_data
Text Label 2750 1200 0    60   ~ 0
Kbd_clk
Text Label 1750 2400 2    60   ~ 0
SCLK_33
Text Label 2750 2400 0    60   ~ 0
MISO_33
Text Label 2750 2500 0    60   ~ 0
MOSI_33
Text Label 1750 2500 2    60   ~ 0
~RTC_SS
$Comp
L mstock:Mini_DIN-6 J2
U 1 1 5696EEAB
P 9800 1600
F 0 "J2" H 9450 2050 60  0000 C CNN
F 1 "PS/2 Keyboard" H 9950 2050 60  0000 C CNN
F 2 "mstock-pretty:MD-60S" H 9700 3250 60  0001 C CNN
F 3 "" H 9700 3250 60  0000 C CNN
	1    9800 1600
	0    1    1    0   
$EndComp
$Comp
L mstock:JACK_TRS_3PINS J1
U 1 1 5696F8D4
P 9650 4300
F 0 "J1" H 9650 4700 50  0000 C CNN
F 1 "Line Out" H 9600 4000 50  0000 C CNN
F 2 "mstock-pretty:SJ-352X-SMT" H 9750 4150 50  0001 C CNN
F 3 "" H 9750 4150 50  0000 C CNN
	1    9650 4300
	-1   0    0    1   
$EndComp
$Comp
L mstock:DS3234 U2
U 1 1 56996EC0
P 5500 1350
F 0 "U2" H 5700 1900 60  0000 C CNN
F 1 "DS3234" H 5500 700 60  0000 C CNN
F 2 "Housings_SOIC:SOIC-20_7.5x12.8mm_Pitch1.27mm" H 5600 1500 60  0001 C CNN
F 3 "" H 5600 1500 60  0000 C CNN
	1    5500 1350
	1    0    0    -1  
$EndComp
Text Label 6000 1150 0    60   ~ 0
SCLK_33
NoConn ~ 5000 1150
NoConn ~ 5000 1350
$Comp
L device:Battery BT1
U 1 1 5699741B
P 6550 1500
F 0 "BT1" H 6650 1450 50  0000 L CNN
F 1 "2025 coin cell" H 6600 1350 50  0000 L CNN
F 2 "mstock-pretty:coincell" V 6550 1540 50  0001 C CNN
F 3 "" V 6550 1540 50  0000 C CNN
	1    6550 1500
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR08
U 1 1 56AE6425
P 3650 2600
F 0 "#PWR08" H 3650 2350 50  0001 C CNN
F 1 "GND" H 3650 2450 50  0000 C CNN
F 2 "" H 3650 2600 60  0000 C CNN
F 3 "" H 3650 2600 60  0000 C CNN
	1    3650 2600
	1    0    0    -1  
$EndComp
$Comp
L mstock:JACK_TRS_3PINS J4
U 1 1 56B54BC1
P 9650 5350
F 0 "J4" H 9650 5750 50  0000 C CNN
F 1 "Line In" H 9600 5050 50  0000 C CNN
F 2 "mstock-pretty:SJ-352X-SMT" H 9750 5200 50  0001 C CNN
F 3 "" H 9750 5200 50  0000 C CNN
	1    9650 5350
	-1   0    0    1   
$EndComp
$Comp
L device:R R1
U 1 1 56B54F2D
P 7750 3600
F 0 "R1" V 7850 3600 50  0000 C CNN
F 1 "47k" V 7750 3600 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 7680 3600 50  0001 C CNN
F 3 "" H 7750 3600 50  0000 C CNN
	1    7750 3600
	-1   0    0    1   
$EndComp
$Comp
L device:R R2
U 1 1 56B54F80
P 8400 4550
F 0 "R2" V 8480 4550 50  0000 C CNN
F 1 "47k" V 8400 4550 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 8330 4550 50  0001 C CNN
F 3 "" H 8400 4550 50  0000 C CNN
	1    8400 4550
	-1   0    0    1   
$EndComp
$Comp
L power:GNDA #PWR09
U 1 1 56B55276
P 8700 5800
F 0 "#PWR09" H 8700 5550 50  0001 C CNN
F 1 "GNDA" H 8700 5650 50  0000 C CNN
F 2 "" H 8700 5800 50  0000 C CNN
F 3 "" H 8700 5800 50  0000 C CNN
	1    8700 5800
	1    0    0    -1  
$EndComp
$Comp
L power:GNDA #PWR010
U 1 1 56B55983
P 8800 4800
F 0 "#PWR010" H 8800 4550 50  0001 C CNN
F 1 "GNDA" H 8800 4650 50  0000 C CNN
F 2 "" H 8800 4800 50  0000 C CNN
F 3 "" H 8800 4800 50  0000 C CNN
	1    8800 4800
	1    0    0    -1  
$EndComp
$Comp
L power:GNDA #PWR011
U 1 1 56B55BB3
P 8300 3800
F 0 "#PWR011" H 8300 3550 50  0001 C CNN
F 1 "GNDA" H 8300 3650 50  0000 C CNN
F 2 "" H 8300 3800 50  0000 C CNN
F 3 "" H 8300 3800 50  0000 C CNN
	1    8300 3800
	1    0    0    -1  
$EndComp
$Comp
L mstock:SSM2603 U1
U 1 1 57F6E33A
P 4950 4350
F 0 "U1" H 4925 5297 60  0000 C CNN
F 1 "SSM2603" H 4925 5191 60  0000 C CNN
F 2 "Housings_DFN_QFN:QFN-28-1EP_5x5mm_Pitch0.5mm" H 5750 4950 60  0001 C CNN
F 3 "" H 5750 4950 60  0001 C CNN
	1    4950 4350
	1    0    0    -1  
$EndComp
$Comp
L device:C C17
U 1 1 57F6E89F
P 8750 3600
F 0 "C17" H 8635 3554 50  0000 R CNN
F 1 "220pF" H 8635 3645 50  0000 R CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 8788 3450 50  0001 C CNN
F 3 "" H 8750 3600 50  0000 C CNN
	1    8750 3600
	-1   0    0    1   
$EndComp
$Comp
L device:CP C14
U 1 1 57F6E97A
P 8100 4100
F 0 "C14" V 7950 4000 50  0000 C CNN
F 1 "1uF" V 7950 4200 50  0000 C CNN
F 2 "mstock:UWXCAP-3mm" H 8138 3950 50  0001 C CNN
F 3 "" H 8100 4100 50  0000 C CNN
	1    8100 4100
	0    -1   -1   0   
$EndComp
$Comp
L device:CP C11
U 1 1 57F6EABF
P 7700 4300
F 0 "C11" V 7550 4200 50  0000 C CNN
F 1 "1uF" V 7550 4400 50  0000 C CNN
F 2 "mstock:UWXCAP-3mm" H 7738 4150 50  0001 C CNN
F 3 "" H 7700 4300 50  0000 C CNN
	1    7700 4300
	0    -1   -1   0   
$EndComp
$Comp
L power:GNDA #PWR012
U 1 1 57F6EEBF
P 5650 5300
F 0 "#PWR012" H 5650 5050 50  0001 C CNN
F 1 "GNDA" H 5650 5150 50  0000 C CNN
F 2 "" H 5650 5300 50  0000 C CNN
F 3 "" H 5650 5300 50  0000 C CNN
	1    5650 5300
	1    0    0    -1  
$EndComp
$Comp
L device:R R6
U 1 1 57F6F39F
P 8900 4100
F 0 "R6" V 8980 4100 50  0000 C CNN
F 1 "100" V 8900 4100 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 8830 4100 50  0001 C CNN
F 3 "" H 8900 4100 50  0000 C CNN
	1    8900 4100
	0    1    1    0   
$EndComp
$Comp
L device:R R7
U 1 1 57F6F40B
P 8900 4300
F 0 "R7" V 8980 4300 50  0000 C CNN
F 1 "100" V 8900 4300 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 8830 4300 50  0001 C CNN
F 3 "" H 8900 4300 50  0000 C CNN
	1    8900 4300
	0    1    1    0   
$EndComp
$Comp
L device:R R5
U 1 1 57F6F597
P 8600 4550
F 0 "R5" V 8680 4550 50  0000 C CNN
F 1 "47k" V 8600 4550 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 8530 4550 50  0001 C CNN
F 3 "" H 8600 4550 50  0000 C CNN
	1    8600 4550
	-1   0    0    1   
$EndComp
$Comp
L device:C C13
U 1 1 57F6FFD8
P 7950 3600
F 0 "C13" H 7835 3554 50  0000 R CNN
F 1 "220pF" H 7835 3645 50  0000 R CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 7988 3450 50  0001 C CNN
F 3 "" H 7950 3600 50  0000 C CNN
	1    7950 3600
	-1   0    0    1   
$EndComp
$Comp
L device:R R4
U 1 1 57F700DB
P 8500 3600
F 0 "R4" V 8600 3600 50  0000 C CNN
F 1 "47k" V 8500 3600 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 8430 3600 50  0001 C CNN
F 3 "" H 8500 3600 50  0000 C CNN
	1    8500 3600
	-1   0    0    1   
$EndComp
$Comp
L device:CP C10
U 1 1 57F70841
P 7300 3400
F 0 "C10" V 7150 3300 50  0000 C CNN
F 1 "220uF" V 7150 3500 50  0000 C CNN
F 2 "mstock:UWXCAP-6.3mm" H 7338 3250 50  0001 C CNN
F 3 "" H 7300 3400 50  0000 C CNN
	1    7300 3400
	0    -1   -1   0   
$EndComp
$Comp
L device:CP C7
U 1 1 57F708C8
P 6800 3200
F 0 "C7" V 6650 3100 50  0000 C CNN
F 1 "220uF" V 6650 3300 50  0000 C CNN
F 2 "mstock:UWXCAP-6.3mm" H 6838 3050 50  0001 C CNN
F 3 "" H 6800 3200 50  0000 C CNN
	1    6800 3200
	0    -1   -1   0   
$EndComp
$Comp
L device:CP C3
U 1 1 57F70C05
P 6550 4700
F 0 "C3" V 6400 4600 50  0000 C CNN
F 1 "10uF" V 6400 4800 50  0000 C CNN
F 2 "mstock:UWXCAP-3mm" H 6588 4550 50  0001 C CNN
F 3 "" H 6550 4700 50  0000 C CNN
	1    6550 4700
	1    0    0    -1  
$EndComp
$Comp
L device:C C5
U 1 1 57F70CC1
P 6800 4700
F 0 "C5" H 6685 4654 50  0000 R CNN
F 1 "0.1uF" H 6685 4745 50  0000 R CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 6838 4550 50  0001 C CNN
F 3 "" H 6800 4700 50  0000 C CNN
	1    6800 4700
	-1   0    0    1   
$EndComp
$Comp
L power:GNDA #PWR013
U 1 1 57F70EBE
P 6700 4900
F 0 "#PWR013" H 6700 4650 50  0001 C CNN
F 1 "GNDA" H 6700 4750 50  0000 C CNN
F 2 "" H 6700 4900 50  0000 C CNN
F 3 "" H 6700 4900 50  0000 C CNN
	1    6700 4900
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR014
U 1 1 57F71231
P 3750 4000
F 0 "#PWR014" H 3750 3750 50  0001 C CNN
F 1 "GND" H 3750 3850 50  0000 C CNN
F 2 "" H 3750 4000 60  0000 C CNN
F 3 "" H 3750 4000 60  0000 C CNN
	1    3750 4000
	1    0    0    -1  
$EndComp
NoConn ~ 4300 3750
NoConn ~ 4300 4150
$Comp
L power:+3.3V #PWR015
U 1 1 57F716CF
P 3950 2450
F 0 "#PWR015" H 3950 2300 50  0001 C CNN
F 1 "+3.3V" H 3950 2590 50  0000 C CNN
F 2 "" H 3950 2450 60  0000 C CNN
F 3 "" H 3950 2450 60  0000 C CNN
	1    3950 2450
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR016
U 1 1 57F719B5
P 4800 5350
F 0 "#PWR016" H 4800 5100 50  0001 C CNN
F 1 "GND" H 4800 5200 50  0000 C CNN
F 2 "" H 4800 5350 60  0000 C CNN
F 3 "" H 4800 5350 60  0000 C CNN
	1    4800 5350
	1    0    0    -1  
$EndComp
$Comp
L power:GNDA #PWR017
U 1 1 57F71A05
P 5100 5350
F 0 "#PWR017" H 5100 5100 50  0001 C CNN
F 1 "GNDA" H 5100 5200 50  0000 C CNN
F 2 "" H 5100 5350 50  0000 C CNN
F 3 "" H 5100 5350 50  0000 C CNN
	1    5100 5350
	1    0    0    -1  
$EndComp
$Comp
L device:L L2
U 1 1 57F71C90
P 4350 3150
F 0 "L2" V 4566 3150 50  0000 C CNN
F 1 "FB" V 4475 3150 50  0000 C CNN
F 2 "Choke_Axial_ThroughHole:Choke_Horizontal_RM10mm" H 4350 3150 50  0001 C CNN
F 3 "" H 4350 3150 50  0000 C CNN
	1    4350 3150
	0    -1   -1   0   
$EndComp
$Comp
L device:L L1
U 1 1 57F71DDE
P 4350 2750
F 0 "L1" V 4566 2750 50  0000 C CNN
F 1 "FB" V 4475 2750 50  0000 C CNN
F 2 "Choke_Axial_ThroughHole:Choke_Horizontal_RM10mm" H 4350 2750 50  0001 C CNN
F 3 "" H 4350 2750 50  0000 C CNN
	1    4350 2750
	0    -1   -1   0   
$EndComp
$Comp
L device:CP C1
U 1 1 57F72744
P 3350 3800
F 0 "C1" V 3200 3700 50  0000 C CNN
F 1 "10uF" V 3200 3900 50  0000 C CNN
F 2 "mstock:UWXCAP-3mm" H 3388 3650 50  0001 C CNN
F 3 "" H 3350 3800 50  0000 C CNN
	1    3350 3800
	1    0    0    -1  
$EndComp
$Comp
L device:C C2
U 1 1 57F7274A
P 3600 3800
F 0 "C2" H 3485 3754 50  0000 R CNN
F 1 "0.1uF" H 3485 3845 50  0000 R CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 3638 3650 50  0001 C CNN
F 3 "" H 3600 3800 50  0000 C CNN
	1    3600 3800
	-1   0    0    1   
$EndComp
$Comp
L power:+3.3V #PWR018
U 1 1 57F72B34
P 3750 3600
F 0 "#PWR018" H 3750 3450 50  0001 C CNN
F 1 "+3.3V" H 3750 3740 50  0000 C CNN
F 2 "" H 3750 3600 60  0000 C CNN
F 3 "" H 3750 3600 60  0000 C CNN
	1    3750 3600
	1    0    0    -1  
$EndComp
$Comp
L device:CP C8
U 1 1 57F737E1
P 7300 4700
F 0 "C8" V 7150 4600 50  0000 C CNN
F 1 "10uF" V 7150 4800 50  0000 C CNN
F 2 "mstock:UWXCAP-3mm" H 7338 4550 50  0001 C CNN
F 3 "" H 7300 4700 50  0000 C CNN
	1    7300 4700
	1    0    0    -1  
$EndComp
$Comp
L device:C C9
U 1 1 57F737E7
P 7550 4700
F 0 "C9" H 7435 4654 50  0000 R CNN
F 1 "0.1uF" H 7435 4745 50  0000 R CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 7588 4550 50  0001 C CNN
F 3 "" H 7550 4700 50  0000 C CNN
	1    7550 4700
	-1   0    0    1   
$EndComp
$Comp
L device:CP C4
U 1 1 57F73FC6
P 6250 2700
F 0 "C4" V 6100 2600 50  0000 C CNN
F 1 "10uF" V 6100 2800 50  0000 C CNN
F 2 "mstock:UWXCAP-3mm" H 6288 2550 50  0001 C CNN
F 3 "" H 6250 2700 50  0000 C CNN
	1    6250 2700
	1    0    0    -1  
$EndComp
$Comp
L device:C C6
U 1 1 57F73FCC
P 6500 2700
F 0 "C6" H 6385 2654 50  0000 R CNN
F 1 "0.1uF" H 6385 2745 50  0000 R CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 6538 2550 50  0001 C CNN
F 3 "" H 6500 2700 50  0000 C CNN
	1    6500 2700
	-1   0    0    1   
$EndComp
$Comp
L power:GNDA #PWR019
U 1 1 57F740C1
P 6350 2950
F 0 "#PWR019" H 6350 2700 50  0001 C CNN
F 1 "GNDA" H 6350 2800 50  0000 C CNN
F 2 "" H 6350 2950 50  0000 C CNN
F 3 "" H 6350 2950 50  0000 C CNN
	1    6350 2950
	1    0    0    -1  
$EndComp
$Comp
L device:R R3
U 1 1 57F743F5
P 3850 4600
F 0 "R3" V 3643 4600 50  0000 C CNN
F 1 "100K" V 3734 4600 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 3780 4600 50  0001 C CNN
F 3 "" H 3850 4600 50  0000 C CNN
	1    3850 4600
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR020
U 1 1 57F7454D
P 3550 4400
F 0 "#PWR020" H 3550 4250 50  0001 C CNN
F 1 "+3.3V" H 3550 4550 50  0000 C CNN
F 2 "" H 3550 4400 60  0000 C CNN
F 3 "" H 3550 4400 60  0000 C CNN
	1    3550 4400
	1    0    0    -1  
$EndComp
Text Label 4300 4250 2    60   ~ 0
BCLK
Text Label 4300 4350 2    60   ~ 0
PBDAT
Text Label 4300 4450 2    60   ~ 0
PBLRC
Text Label 4300 4550 2    60   ~ 0
RECDAT
Text Label 4300 4650 2    60   ~ 0
RECLRC
Text Label 1750 2300 2    60   ~ 0
RECLRC
Text Label 1750 2100 2    60   ~ 0
RECDAT
Text Label 1750 2200 2    60   ~ 0
PBLRC
Text Label 2750 2300 0    60   ~ 0
PBDAT
Text Label 2750 2000 0    60   ~ 0
BCLK
Text Label 4300 4950 2    60   ~ 0
SDIN
Text Label 4300 5050 2    60   ~ 0
SCLK
Text Label 2750 2200 0    60   ~ 0
SCLK
Text Label 2750 2100 0    60   ~ 0
SDIN
$Comp
L device:C C18
U 1 1 57F751EE
P 8700 5500
F 0 "C18" H 8585 5454 50  0000 R CNN
F 1 "220pF" H 8585 5545 50  0000 R CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 8738 5350 50  0001 C CNN
F 3 "" H 8700 5500 50  0000 C CNN
	1    8700 5500
	-1   0    0    1   
$EndComp
$Comp
L device:C C16
U 1 1 57F75353
P 8250 5600
F 0 "C16" H 8135 5554 50  0000 R CNN
F 1 "220pF" H 8135 5645 50  0000 R CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 8288 5450 50  0001 C CNN
F 3 "" H 8250 5600 50  0000 C CNN
	1    8250 5600
	-1   0    0    1   
$EndComp
$Comp
L device:CP C15
U 1 1 57F7597F
P 8050 5150
F 0 "C15" V 7900 5050 50  0000 C CNN
F 1 "1uF" V 7900 5250 50  0000 C CNN
F 2 "mstock:UWXCAP-3mm" H 8088 5000 50  0001 C CNN
F 3 "" H 8050 5150 50  0000 C CNN
	1    8050 5150
	0    -1   -1   0   
$EndComp
$Comp
L device:CP C12
U 1 1 57F75A5C
P 7700 5350
F 0 "C12" V 7550 5250 50  0000 C CNN
F 1 "1uF" V 7550 5450 50  0000 C CNN
F 2 "mstock:UWXCAP-3mm" H 7738 5200 50  0001 C CNN
F 3 "" H 7700 5350 50  0000 C CNN
	1    7700 5350
	0    -1   -1   0   
$EndComp
$Comp
L device:R R9
U 1 1 57F848B6
P 8750 1150
F 0 "R9" H 8820 1196 50  0000 L CNN
F 1 "1k" H 8820 1105 50  0000 L CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 8680 1150 50  0001 C CNN
F 3 "" H 8750 1150 50  0000 C CNN
	1    8750 1150
	1    0    0    -1  
$EndComp
$Comp
L device:R R8
U 1 1 57F849C8
P 8500 1150
F 0 "R8" H 8570 1196 50  0000 L CNN
F 1 "1k" H 8570 1105 50  0000 L CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 8430 1150 50  0001 C CNN
F 3 "" H 8500 1150 50  0000 C CNN
	1    8500 1150
	1    0    0    -1  
$EndComp
Text Label 4300 3650 2    60   ~ 0
MCLK
Text Label 1750 2700 2    60   ~ 0
MCLK
$Comp
L device:R R11
U 1 1 5830728C
P 3450 4600
F 0 "R11" V 3243 4600 50  0000 C CNN
F 1 "100K" V 3334 4600 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 3380 4600 50  0001 C CNN
F 3 "" H 3450 4600 50  0000 C CNN
	1    3450 4600
	1    0    0    -1  
$EndComp
$Comp
L device:R R10
U 1 1 5830740A
P 3150 4600
F 0 "R10" V 2943 4600 50  0000 C CNN
F 1 "100K" V 3034 4600 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 3080 4600 50  0001 C CNN
F 3 "" H 3150 4600 50  0000 C CNN
	1    3150 4600
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_02x06_Odd_Even P3
U 1 1 58308B84
P 5450 7050
F 0 "P3" H 5450 7400 50  0000 C CNN
F 1 "IO" V 5500 7000 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_2x06" H 5450 5850 50  0001 C CNN
F 3 "" H 5450 5850 50  0000 C CNN
	1    5450 7050
	1    0    0    -1  
$EndComp
Text Label 5250 7050 2    60   ~ 0
SDIN
Text Label 5250 6950 2    60   ~ 0
SCLK
Text Label 5750 6850 0    60   ~ 0
MOSI_33
Text Label 5750 6950 0    60   ~ 0
MISO_33
Text Label 5750 7050 0    60   ~ 0
SCLK_33
Text Label 5750 7150 0    60   ~ 0
~RTC_SS
$Comp
L power:+3.3V #PWR021
U 1 1 583094AC
P 5250 6750
F 0 "#PWR021" H 5250 6600 50  0001 C CNN
F 1 "+3.3V" H 5250 6890 50  0000 C CNN
F 2 "" H 5250 6750 60  0000 C CNN
F 3 "" H 5250 6750 60  0000 C CNN
	1    5250 6750
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR022
U 1 1 58309716
P 5250 7450
F 0 "#PWR022" H 5250 7200 50  0001 C CNN
F 1 "GND" H 5250 7300 50  0000 C CNN
F 2 "" H 5250 7450 60  0000 C CNN
F 3 "" H 5250 7450 60  0000 C CNN
	1    5250 7450
	1    0    0    -1  
$EndComp
$Comp
L device:LED_Small D1
U 1 1 58309858
P 8150 7250
F 0 "D1" H 8150 7485 50  0000 C CNN
F 1 "PWR" H 8150 7394 50  0000 C CNN
F 2 "mstock:SM1206POL" V 8150 7250 50  0001 C CNN
F 3 "" V 8150 7250 50  0000 C CNN
	1    8150 7250
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR023
U 1 1 58309B06
P 8600 7150
F 0 "#PWR023" H 8600 7000 50  0001 C CNN
F 1 "+3.3V" H 8600 7290 50  0000 C CNN
F 2 "" H 8600 7150 60  0000 C CNN
F 3 "" H 8600 7150 60  0000 C CNN
	1    8600 7150
	1    0    0    -1  
$EndComp
$Comp
L device:R R15
U 1 1 58309C0D
P 8450 7250
F 0 "R15" V 8530 7250 50  0000 C CNN
F 1 "330" V 8450 7250 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 8380 7250 50  0001 C CNN
F 3 "" H 8450 7250 50  0000 C CNN
	1    8450 7250
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR024
U 1 1 58309F9E
P 8050 7300
F 0 "#PWR024" H 8050 7050 50  0001 C CNN
F 1 "GND" H 8050 7150 50  0000 C CNN
F 2 "" H 8050 7300 60  0000 C CNN
F 3 "" H 8050 7300 60  0000 C CNN
	1    8050 7300
	1    0    0    -1  
$EndComp
$Comp
L device:R R12
U 1 1 5830A3C4
P 11900 1700
F 0 "R12" V 11693 1700 50  0000 C CNN
F 1 "100K" V 11784 1700 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 11830 1700 50  0001 C CNN
F 3 "" H 11900 1700 50  0000 C CNN
	1    11900 1700
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR025
U 1 1 5830A737
P 11900 1450
F 0 "#PWR025" H 11900 1300 50  0001 C CNN
F 1 "+3.3V" H 11900 1590 50  0000 C CNN
F 2 "" H 11900 1450 60  0000 C CNN
F 3 "" H 11900 1450 60  0000 C CNN
	1    11900 1450
	1    0    0    -1  
$EndComp
Wire Wire Line
	3650 1700 3650 2600
Wire Wire Line
	3650 2600 2750 2600
Wire Wire Line
	2750 1700 3650 1700
Wire Wire Line
	1400 1700 1750 1700
Wire Wire Line
	12950 1850 12700 1850
Wire Wire Line
	12950 1250 12950 1450
Wire Wire Line
	12700 1450 12950 1450
Connection ~ 12950 1850
Wire Wire Line
	12700 1250 12950 1250
Connection ~ 12950 1450
Wire Wire Line
	4800 1250 5000 1250
Wire Wire Line
	6000 1450 6200 1450
Wire Wire Line
	6200 1450 6200 1650
Wire Wire Line
	6000 1350 6450 1350
Wire Wire Line
	8200 5150 8250 5150
Wire Wire Line
	8800 4500 9250 4500
Wire Wire Line
	5550 4050 5650 4050
Wire Wire Line
	5650 4050 5650 4450
Wire Wire Line
	5550 4450 5650 4450
Connection ~ 5650 4450
Wire Wire Line
	9050 4100 9250 4100
Wire Wire Line
	9250 4300 9050 4300
Wire Wire Line
	8800 4500 8800 4700
Connection ~ 8800 4700
Wire Wire Line
	7850 4300 8600 4300
Wire Wire Line
	8600 4300 8600 4400
Wire Wire Line
	8250 4100 8400 4100
Wire Wire Line
	8400 4100 8400 4400
Connection ~ 8400 4100
Connection ~ 8600 4300
Wire Wire Line
	6450 4250 5550 4250
Wire Wire Line
	8300 3750 8300 3800
Connection ~ 8300 3750
Wire Wire Line
	8750 3400 8750 3450
Wire Wire Line
	8500 3400 8500 3450
Connection ~ 8750 3400
Wire Wire Line
	7950 3200 7950 3450
Wire Wire Line
	7750 3200 7750 3450
Connection ~ 7950 3200
Connection ~ 8500 3400
Connection ~ 7750 3200
Wire Wire Line
	6650 3200 5950 3200
Wire Wire Line
	5950 3200 5950 3850
Wire Wire Line
	5950 3850 5550 3850
Wire Wire Line
	7150 3400 6050 3400
Wire Wire Line
	6050 3400 6050 3950
Wire Wire Line
	6050 3950 5550 3950
Wire Wire Line
	6550 4850 6700 4850
Wire Wire Line
	6700 4850 6700 4900
Connection ~ 6700 4850
Wire Wire Line
	3750 3950 3750 4000
Wire Wire Line
	4950 5300 4950 5350
Wire Wire Line
	4800 5350 4950 5350
Connection ~ 4950 5350
Wire Wire Line
	3950 4050 4300 4050
Wire Wire Line
	3950 2450 3950 2750
Connection ~ 3950 2750
Connection ~ 3950 3150
Connection ~ 3750 3950
Wire Wire Line
	4000 3850 4300 3850
Wire Wire Line
	3750 3600 3750 3650
Connection ~ 3750 3650
Wire Wire Line
	7550 4550 7450 4550
Wire Wire Line
	5550 4350 5750 4350
Wire Wire Line
	7450 4350 7450 4550
Connection ~ 7450 4550
Wire Wire Line
	5750 4350 5750 3150
Connection ~ 5750 4350
Wire Wire Line
	6500 2850 6350 2850
Wire Wire Line
	6350 2850 6350 2950
Connection ~ 6350 2850
Wire Wire Line
	5550 2550 5550 2750
Connection ~ 5550 2750
Wire Wire Line
	8250 5750 8700 5750
Wire Wire Line
	8700 5650 8700 5750
Wire Wire Line
	9250 5750 9250 5550
Connection ~ 8700 5750
Wire Wire Line
	8250 5450 8250 5150
Connection ~ 8250 5150
Wire Wire Line
	5750 5350 7550 5350
Wire Wire Line
	1750 2600 1250 2600
Wire Wire Line
	8400 1700 9200 1700
Wire Wire Line
	8400 950  8400 1000
Connection ~ 8400 1000
Wire Wire Line
	8500 1300 8500 1800
Connection ~ 8500 1800
Wire Wire Line
	8200 1800 8500 1800
Wire Wire Line
	8750 1500 9200 1500
Wire Wire Line
	4000 3650 4000 3850
Wire Wire Line
	3850 4750 4300 4750
Wire Wire Line
	3550 4400 3550 4450
Wire Wire Line
	3550 4850 4300 4850
Connection ~ 3550 4450
Wire Wire Line
	4300 4950 3450 4950
Wire Wire Line
	3450 4950 3450 4750
Wire Wire Line
	4300 5050 3150 5050
Wire Wire Line
	3150 5050 3150 4750
Wire Wire Line
	5250 6750 5250 6850
Wire Wire Line
	8600 7150 8600 7250
Wire Wire Line
	8300 7250 8250 7250
Wire Wire Line
	8050 7250 8050 7300
Wire Wire Line
	11900 1850 12200 1850
Wire Wire Line
	11900 1450 11900 1550
Text Label 2750 2800 0    60   ~ 0
~RESET
Text Label 5000 1450 2    60   ~ 0
~RESET
Wire Wire Line
	6450 4100 6450 4250
Wire Wire Line
	5250 7350 5250 7450
Text Label 1750 2800 2    60   ~ 0
GPIO1
Text Label 1750 2900 2    60   ~ 0
GPIO2
NoConn ~ 2750 3100
Wire Wire Line
	5550 4850 5850 4850
Wire Wire Line
	5550 4950 5750 4950
Wire Wire Line
	5750 4950 5750 5350
$Comp
L device:R R17
U 1 1 5851AF95
P 7600 7350
F 0 "R17" V 7680 7350 50  0000 C CNN
F 1 "330" V 7600 7350 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 7530 7350 50  0001 C CNN
F 3 "" H 7600 7350 50  0000 C CNN
	1    7600 7350
	0    1    1    0   
$EndComp
$Comp
L device:LED_Small D3
U 1 1 5851B066
P 7300 7350
F 0 "D3" H 7400 7250 50  0000 C CNN
F 1 "RX2" H 7200 7300 50  0000 C CNN
F 2 "mstock:SM1206POL" V 7300 7350 50  0001 C CNN
F 3 "" V 7300 7350 50  0000 C CNN
	1    7300 7350
	1    0    0    -1  
$EndComp
Wire Wire Line
	7400 7350 7450 7350
$Comp
L device:R R16
U 1 1 5851BB75
P 7600 7150
F 0 "R16" V 7680 7150 50  0000 C CNN
F 1 "330" V 7600 7150 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 7530 7150 50  0001 C CNN
F 3 "" H 7600 7150 50  0000 C CNN
	1    7600 7150
	0    1    1    0   
$EndComp
$Comp
L device:LED_Small D2
U 1 1 5851BB7B
P 7300 7150
F 0 "D2" H 7400 7050 50  0000 C CNN
F 1 "TX1" H 7200 7100 50  0000 C CNN
F 2 "mstock:SM1206POL" V 7300 7150 50  0001 C CNN
F 3 "" V 7300 7150 50  0000 C CNN
	1    7300 7150
	1    0    0    -1  
$EndComp
Wire Wire Line
	7400 7150 7450 7150
$Comp
L device:R R18
U 1 1 5851BCAE
P 7600 7550
F 0 "R18" V 7680 7550 50  0000 C CNN
F 1 "330" V 7600 7550 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 7530 7550 50  0001 C CNN
F 3 "" H 7600 7550 50  0000 C CNN
	1    7600 7550
	0    1    1    0   
$EndComp
$Comp
L device:LED_Small D4
U 1 1 5851BCB4
P 7300 7550
F 0 "D4" H 7400 7450 50  0000 C CNN
F 1 "TX2" H 7200 7500 50  0000 C CNN
F 2 "mstock:SM1206POL" V 7300 7550 50  0001 C CNN
F 3 "" V 7300 7550 50  0000 C CNN
	1    7300 7550
	1    0    0    -1  
$EndComp
Wire Wire Line
	7400 7550 7450 7550
$Comp
L power:+3.3V #PWR031
U 1 1 5851BD8F
P 7750 7100
F 0 "#PWR031" H 7750 6950 50  0001 C CNN
F 1 "+3.3V" H 7750 7240 50  0000 C CNN
F 2 "" H 7750 7100 60  0000 C CNN
F 3 "" H 7750 7100 60  0000 C CNN
	1    7750 7100
	1    0    0    -1  
$EndComp
Text Label 7200 7150 2    60   ~ 0
Serial1_TX
Text Label 7200 7350 2    60   ~ 0
Serial0_RX
Text Label 7200 7550 2    60   ~ 0
Serial0_TX
$Comp
L mstock:JACK_TRRS_4PINS J5
U 1 1 5851DA94
P 9650 3400
F 0 "J5" H 9650 3800 50  0000 R CNN
F 1 "Headphone" H 9800 3100 50  0000 R CNN
F 2 "mstock-pretty:SJ-4351X-SMT" H 9750 3250 50  0001 C CNN
F 3 "" H 9750 3250 50  0000 C CNN
	1    9650 3400
	-1   0    0    1   
$EndComp
Wire Wire Line
	9050 3200 7950 3200
Wire Wire Line
	9150 3400 8750 3400
Wire Wire Line
	9150 3200 9150 3400
Wire Wire Line
	9150 3200 9250 3200
Wire Wire Line
	9050 3250 9200 3250
Wire Wire Line
	9200 3250 9200 3400
Wire Wire Line
	9050 3200 9050 3250
Wire Wire Line
	9200 3400 9250 3400
Wire Wire Line
	9250 3550 9150 3550
Wire Wire Line
	9150 3550 9150 3750
Wire Wire Line
	5850 4850 5850 5150
Wire Wire Line
	5850 5150 7900 5150
Wire Wire Line
	5550 4150 6100 4150
Wire Wire Line
	6100 4150 6100 4300
Wire Wire Line
	6100 4300 7550 4300
$Comp
L device:R R19
U 1 1 58574391
P 6100 5700
F 0 "R19" V 6180 5700 50  0000 C CNN
F 1 "47k" V 6100 5700 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 6030 5700 50  0001 C CNN
F 3 "" H 6100 5700 50  0000 C CNN
	1    6100 5700
	-1   0    0    1   
$EndComp
$Comp
L power:GNDA #PWR032
U 1 1 58574496
P 6200 5850
F 0 "#PWR032" H 6200 5600 50  0001 C CNN
F 1 "GNDA" H 6200 5700 50  0000 C CNN
F 2 "" H 6200 5850 50  0000 C CNN
F 3 "" H 6200 5850 50  0000 C CNN
	1    6200 5850
	1    0    0    -1  
$EndComp
$Comp
L device:C C25
U 1 1 58574558
P 6300 5700
F 0 "C25" H 6185 5654 50  0000 R CNN
F 1 "220pF" H 6185 5745 50  0000 R CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 6338 5550 50  0001 C CNN
F 3 "" H 6300 5700 50  0000 C CNN
	1    6300 5700
	-1   0    0    1   
$EndComp
Wire Wire Line
	6100 5550 6300 5550
Wire Wire Line
	9250 3650 9250 5000
Wire Wire Line
	9250 5000 6950 5000
Wire Wire Line
	6950 5000 6950 5550
Connection ~ 6300 5550
$Comp
L device:C C24
U 1 1 58574C73
P 6000 4950
F 0 "C24" H 5950 4850 50  0000 R CNN
F 1 "1uF" H 5950 5050 50  0000 R CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 6038 4800 50  0001 C CNN
F 3 "" H 6000 4950 50  0000 C CNN
	1    6000 4950
	-1   0    0    1   
$EndComp
$Comp
L device:R R20
U 1 1 5857505E
P 6300 4950
F 0 "R20" V 6380 4950 50  0000 C CNN
F 1 "100" V 6300 4950 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 6230 4950 50  0001 C CNN
F 3 "" H 6300 4950 50  0000 C CNN
	1    6300 4950
	-1   0    0    1   
$EndComp
Wire Wire Line
	5550 4650 6300 4650
Wire Wire Line
	6300 4650 6300 4800
Wire Wire Line
	5550 4750 6000 4750
Wire Wire Line
	6000 4750 6000 4800
Wire Wire Line
	6000 5100 6300 5100
Wire Wire Line
	6300 5100 6300 5550
Text Label 2750 2900 0    60   ~ 0
Serial0_RX
Text Label 1750 3100 2    60   ~ 0
Serial0_CTS
Text Label 1750 3000 2    60   ~ 0
Serial0_TX
Text Label 2750 3000 0    60   ~ 0
Serial0_RTS
Wire Wire Line
	12950 1850 12950 1900
Wire Wire Line
	12950 1450 12950 1850
Wire Wire Line
	5650 4450 5650 5300
Wire Wire Line
	8800 4700 8800 4800
Wire Wire Line
	8400 4100 8750 4100
Wire Wire Line
	8600 4300 8750 4300
Wire Wire Line
	8750 3400 8500 3400
Wire Wire Line
	7950 3200 7750 3200
Wire Wire Line
	8500 3400 7450 3400
Wire Wire Line
	7750 3200 6950 3200
Wire Wire Line
	4950 5350 5100 5350
Wire Wire Line
	3950 2750 3950 3150
Wire Wire Line
	3950 3150 3950 4050
Wire Wire Line
	3750 3950 4300 3950
Wire Wire Line
	3750 3650 4000 3650
Wire Wire Line
	7450 4550 7300 4550
Wire Wire Line
	5750 4350 7450 4350
Wire Wire Line
	6350 2850 6250 2850
Wire Wire Line
	5550 2750 5550 3750
Wire Wire Line
	8700 5750 9250 5750
Wire Wire Line
	8700 5750 8700 5800
Wire Wire Line
	8250 5150 9250 5150
Wire Wire Line
	8400 1000 8400 1700
Wire Wire Line
	8500 1800 9200 1800
Wire Wire Line
	3550 4450 3550 4850
Wire Wire Line
	3550 4450 3850 4450
Wire Wire Line
	6300 5550 6950 5550
Wire Wire Line
	6200 1650 6350 1650
Wire Wire Line
	6100 5850 6200 5850
Wire Wire Line
	6450 1350 6450 1300
Wire Wire Line
	6450 1300 6550 1300
Wire Wire Line
	6450 1650 6450 1700
Wire Wire Line
	6450 1700 6550 1700
Wire Wire Line
	3950 2750 4200 2750
Wire Wire Line
	4500 2750 5550 2750
Wire Wire Line
	4500 3150 5750 3150
Wire Wire Line
	3950 3150 4200 3150
Connection ~ 6200 5850
Wire Wire Line
	6200 5850 6300 5850
Connection ~ 3650 2600
Connection ~ 6350 1650
Wire Wire Line
	6350 1650 6450 1650
Wire Wire Line
	6350 1650 6350 1750
Wire Wire Line
	7850 5350 9250 5350
Wire Wire Line
	8400 4700 8600 4700
Wire Wire Line
	7750 3750 7950 3750
Wire Wire Line
	5550 4550 6550 4550
Wire Wire Line
	3350 3950 3600 3950
Wire Wire Line
	5550 2550 6500 2550
Wire Wire Line
	8400 1000 8500 1000
Wire Wire Line
	8200 1300 8750 1300
Wire Wire Line
	3350 3650 3600 3650
Wire Wire Line
	3150 4450 3450 4450
Wire Wire Line
	7750 7100 7750 7150
Wire Wire Line
	8300 3750 8500 3750
Wire Wire Line
	6700 4850 6800 4850
Connection ~ 7750 7150
Wire Wire Line
	7750 7150 7750 7350
Connection ~ 7750 7350
Wire Wire Line
	7750 7350 7750 7550
Connection ~ 3450 4450
Wire Wire Line
	3450 4450 3550 4450
Connection ~ 3600 3650
Wire Wire Line
	3600 3650 3750 3650
Connection ~ 3600 3950
Wire Wire Line
	3600 3950 3750 3950
Connection ~ 8500 1000
Wire Wire Line
	8500 1000 8750 1000
Connection ~ 8750 1300
Connection ~ 8500 3750
Wire Wire Line
	8500 3750 8750 3750
Connection ~ 8750 3750
Wire Wire Line
	8750 3750 9150 3750
Connection ~ 7950 3750
Wire Wire Line
	7950 3750 8300 3750
Connection ~ 8600 4700
Wire Wire Line
	8600 4700 8800 4700
Connection ~ 7300 4850
Wire Wire Line
	7300 4850 7550 4850
Connection ~ 6800 4850
Wire Wire Line
	6800 4850 7300 4850
Connection ~ 6550 4550
Wire Wire Line
	6550 4550 6800 4550
Wire Wire Line
	6450 4100 7950 4100
Wire Wire Line
	8750 1300 9200 1300
$EndSCHEMATC
