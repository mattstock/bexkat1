EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:mstock
LIBS:soc-cache
EELAYER 25 0
EELAYER END
$Descr USLegal 14000 8500
encoding utf-8
Sheet 1 1
Title "Bexkat 1000 Motherboard"
Date "Wed 29 Apr 2015"
Rev "v1.0"
Comp "Bexkat Systems LLC"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L ALTERA_DE1_GPIO P2
U 1 1 55410742
P 6750 3950
F 0 "P2" H 6750 5000 60  0000 C CNN
F 1 "ALTERA_DE1_GPIO" H 6750 2900 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_2x20" H 6750 3950 60  0001 C CNN
F 3 "" H 6750 3950 60  0000 C CNN
	1    6750 3950
	1    0    0    -1  
$EndComp
Wire Wire Line
	8150 3500 8150 4400
Text Label 6250 3000 2    60   ~ 0
Serial1
$Comp
L +3.3V #PWR01
U 1 1 554129BF
P 5550 4400
F 0 "#PWR01" H 5550 4250 50  0001 C CNN
F 1 "+3.3V" H 5550 4540 50  0000 C CNN
F 2 "" H 5550 4400 60  0000 C CNN
F 3 "" H 5550 4400 60  0000 C CNN
	1    5550 4400
	1    0    0    -1  
$EndComp
Wire Wire Line
	5550 4400 6250 4400
Wire Wire Line
	8150 4400 7250 4400
Wire Wire Line
	7250 3500 8150 3500
Connection ~ 8150 4400
$Comp
L +5V #PWR02
U 1 1 55412EAA
P 5900 3500
F 0 "#PWR02" H 5900 3350 50  0001 C CNN
F 1 "+5V" H 5900 3640 50  0000 C CNN
F 2 "" H 5900 3500 60  0000 C CNN
F 3 "" H 5900 3500 60  0000 C CNN
	1    5900 3500
	1    0    0    -1  
$EndComp
Wire Wire Line
	5900 3500 6250 3500
$Comp
L CONN_02X08 P1
U 1 1 554142A0
P 6650 1600
F 0 "P1" H 6650 2050 50  0000 C CNN
F 1 "LED MATRIX" V 6650 1600 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_2x08" H 6650 400 60  0001 C CNN
F 3 "" H 6650 400 60  0000 C CNN
	1    6650 1600
	1    0    0    -1  
$EndComp
Text Label 6400 1250 2    60   ~ 0
R0
Text Label 6900 1250 0    60   ~ 0
G0
Text Label 6400 1350 2    60   ~ 0
B0
Text Label 6400 1450 2    60   ~ 0
R1
Text Label 6900 1450 0    60   ~ 0
G1
Text Label 6400 1550 2    60   ~ 0
B1
Text Label 6400 1650 2    60   ~ 0
A
Text Label 6900 1650 0    60   ~ 0
B
Text Label 6400 1750 2    60   ~ 0
C
Text Label 6400 1850 2    60   ~ 0
CLK
Text Label 6400 1950 2    60   ~ 0
~OE
Text Label 6900 1850 0    60   ~ 0
STB
NoConn ~ 6900 1750
$Comp
L GND #PWR03
U 1 1 554144DC
P 7150 2000
F 0 "#PWR03" H 7150 1750 50  0001 C CNN
F 1 "GND" H 7150 1850 50  0000 C CNN
F 2 "" H 7150 2000 60  0000 C CNN
F 3 "" H 7150 2000 60  0000 C CNN
	1    7150 2000
	1    0    0    -1  
$EndComp
Wire Wire Line
	7150 1950 6900 1950
Wire Wire Line
	7150 1350 7150 2000
Wire Wire Line
	6900 1550 7150 1550
Connection ~ 7150 1950
Wire Wire Line
	6900 1350 7150 1350
Connection ~ 7150 1550
Text Label 7250 3200 0    60   ~ 0
R0
Text Label 6250 3200 2    60   ~ 0
G0
Text Label 7250 3100 0    60   ~ 0
B0
Text Label 6250 3400 2    60   ~ 0
R1
Text Label 7250 3300 0    60   ~ 0
G1
Text Label 6250 3300 2    60   ~ 0
B1
Text Label 7250 3400 0    60   ~ 0
A
Text Label 6250 3600 2    60   ~ 0
B
Text Label 7250 3600 0    60   ~ 0
C
Text Label 6250 3800 2    60   ~ 0
CLK
Text Label 7250 3700 0    60   ~ 0
STB
Text Label 6250 3700 2    60   ~ 0
~OE
$Comp
L GND #PWR04
U 1 1 56893A48
P 10200 1800
F 0 "#PWR04" H 10200 1550 50  0001 C CNN
F 1 "GND" H 10200 1650 50  0000 C CNN
F 2 "" H 10200 1800 60  0000 C CNN
F 3 "" H 10200 1800 60  0000 C CNN
	1    10200 1800
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR05
U 1 1 56893A7F
P 8650 1400
F 0 "#PWR05" H 8650 1250 50  0001 C CNN
F 1 "+3.3V" H 8650 1540 50  0000 C CNN
F 2 "" H 8650 1400 60  0000 C CNN
F 3 "" H 8650 1400 60  0000 C CNN
	1    8650 1400
	1    0    0    -1  
$EndComp
Text Label 9850 1100 0    60   ~ 0
SCLK_33
Text Label 9850 1200 0    60   ~ 0
MISO_33
Text Label 9850 1400 0    60   ~ 0
MOSI_33
Text Label 8850 1100 2    60   ~ 0
~RTC_SS
NoConn ~ 10050 2950
NoConn ~ 10050 3450
NoConn ~ 10050 3900
NoConn ~ 10050 4400
Text Label 10050 2850 2    60   ~ 0
Kbd_data
Text Label 10050 3350 2    60   ~ 0
Kbd_clk
$Comp
L +5V #PWR06
U 1 1 56893D96
P 9350 2700
F 0 "#PWR06" H 9350 2550 50  0001 C CNN
F 1 "+5V" H 9350 2840 50  0000 C CNN
F 2 "" H 9350 2700 60  0000 C CNN
F 3 "" H 9350 2700 60  0000 C CNN
	1    9350 2700
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR07
U 1 1 56893DBF
P 9400 4300
F 0 "#PWR07" H 9400 4050 50  0001 C CNN
F 1 "GND" H 9400 4150 50  0000 C CNN
F 2 "" H 9400 4300 60  0000 C CNN
F 3 "" H 9400 4300 60  0000 C CNN
	1    9400 4300
	1    0    0    -1  
$EndComp
Wire Wire Line
	9350 2700 9350 4200
Wire Wire Line
	10050 3050 9400 3050
Wire Wire Line
	9400 3050 9400 4300
Wire Wire Line
	10050 4000 9400 4000
Connection ~ 9400 4000
Text Label 7250 3000 0    60   ~ 0
Mouse_clk
Text Label 6250 3100 2    60   ~ 0
Mouse_data
Text Label 10050 4300 2    60   ~ 0
Mouse_clk
Text Label 10050 3800 2    60   ~ 0
Mouse_data
Text Label 6250 3900 2    60   ~ 0
Kbd_data
Text Label 7250 3800 0    60   ~ 0
Kbd_clk
Text Label 6250 4200 2    60   ~ 0
SCLK_33
Text Label 7250 4200 0    60   ~ 0
MISO_33
Text Label 7250 4300 0    60   ~ 0
MOSI_33
Text Label 6250 4300 2    60   ~ 0
~RTC_SS
Text Label 6250 4500 2    60   ~ 0
~RST
$Comp
L CONN_01X16 P9
U 1 1 5695674D
P 5900 6200
F 0 "P9" H 5900 7050 50  0000 C CNN
F 1 "CODEC left" V 6000 6200 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_1x16" H 5900 6200 50  0001 C CNN
F 3 "" H 5900 6200 50  0000 C CNN
	1    5900 6200
	1    0    0    -1  
$EndComp
$Comp
L CONN_01X16 P10
U 1 1 569567A5
P 6750 6200
F 0 "P10" H 6750 7050 50  0000 C CNN
F 1 "CODEC right" V 6850 6200 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_1x16" H 6750 6200 50  0001 C CNN
F 3 "" H 6750 6200 50  0000 C CNN
	1    6750 6200
	1    0    0    -1  
$EndComp
Text Label 5700 5450 2    60   ~ 0
~CODEC_XDCS
Text Label 7250 4500 0    60   ~ 0
~CODEC_XDCS
Text Label 5700 5650 2    60   ~ 0
~CODEC_CS
Text Label 6250 4600 2    60   ~ 0
~CODEC_CS
Text Label 5700 6450 2    60   ~ 0
CODEC_DIRQ
Text Label 5700 5750 2    60   ~ 0
~RST
Text Label 7250 4800 0    60   ~ 0
CODEC_SCLK
Text Label 5700 5850 2    60   ~ 0
CODEC_SCLK
Text Label 7250 4900 0    60   ~ 0
CODEC_MISO
Text Label 6250 4900 2    60   ~ 0
CODEC_MOSI
Text Label 7250 4600 0    60   ~ 0
CODEC_DIRQ
Text Label 5700 5950 2    60   ~ 0
CODEC_MOSI
Text Label 5700 6050 2    60   ~ 0
CODEC_MISO
$Comp
L GND #PWR08
U 1 1 56956B97
P 4900 6600
F 0 "#PWR08" H 4900 6350 50  0001 C CNN
F 1 "GND" H 4900 6450 50  0000 C CNN
F 2 "" H 4900 6600 60  0000 C CNN
F 3 "" H 4900 6600 60  0000 C CNN
	1    4900 6600
	1    0    0    -1  
$EndComp
Wire Wire Line
	5700 6150 4900 6150
Wire Wire Line
	4900 6150 4900 6600
NoConn ~ 5700 6250
$Comp
L +5V #PWR09
U 1 1 56956CAA
P 5100 6350
F 0 "#PWR09" H 5100 6200 50  0001 C CNN
F 1 "+5V" H 5100 6490 50  0000 C CNN
F 2 "" H 5100 6350 60  0000 C CNN
F 3 "" H 5100 6350 60  0000 C CNN
	1    5100 6350
	1    0    0    -1  
$EndComp
Wire Wire Line
	5100 6350 5700 6350
Wire Wire Line
	4900 6550 5700 6550
Connection ~ 4900 6550
$Comp
L Mini_DIN-6 J2
U 1 1 5696EEAB
P 10650 3150
F 0 "J2" H 10300 3600 60  0000 C CNN
F 1 "PS/2 Keyboard" H 10800 3600 60  0000 C CNN
F 2 "mstock-pretty:MD-60S" H 10550 4800 60  0001 C CNN
F 3 "" H 10550 4800 60  0000 C CNN
	1    10650 3150
	0    1    1    0   
$EndComp
Wire Wire Line
	10050 3250 9350 3250
Connection ~ 9350 3250
$Comp
L Mini_DIN-6 J3
U 1 1 5696F198
P 10650 4100
F 0 "J3" H 10300 4550 60  0000 C CNN
F 1 "PS/2 Mouse" H 10800 4550 60  0000 C CNN
F 2 "mstock-pretty:MD-60S" H 10550 5750 60  0001 C CNN
F 3 "" H 10550 5750 60  0000 C CNN
	1    10650 4100
	0    1    1    0   
$EndComp
Wire Wire Line
	9350 4200 10050 4200
$Comp
L JACK_TRS_3PINS J1
U 1 1 5696F8D4
P 2950 5150
F 0 "J1" H 2950 5550 50  0000 C CNN
F 1 "Line Out" H 2900 4850 50  0000 C CNN
F 2 "mstock-pretty:SJI-3513N" H 3050 5000 50  0001 C CNN
F 3 "" H 3050 5000 50  0000 C CNN
	1    2950 5150
	-1   0    0    1   
$EndComp
$Comp
L DS3234 U2
U 1 1 56996EC0
P 9350 1500
F 0 "U2" H 9550 2050 60  0000 C CNN
F 1 "DS3234" H 9350 850 60  0000 C CNN
F 2 "Housings_SOIC:SOIC-20_7.5x12.8mm_Pitch1.27mm" H 9450 1650 60  0001 C CNN
F 3 "" H 9450 1650 60  0000 C CNN
	1    9350 1500
	1    0    0    -1  
$EndComp
Text Label 9850 1300 0    60   ~ 0
SCLK_33
NoConn ~ 8850 1600
NoConn ~ 8850 1300
NoConn ~ 8850 1500
Wire Wire Line
	8650 1400 8850 1400
Wire Wire Line
	9850 1600 10050 1600
$Comp
L Battery BT1
U 1 1 5699741B
P 10300 1650
F 0 "BT1" H 10400 1700 50  0000 L CNN
F 1 "2025 coin cell" H 10400 1600 50  0000 L CNN
F 2 "mstock-pretty:coincell" V 10300 1690 50  0001 C CNN
F 3 "" V 10300 1690 50  0000 C CNN
	1    10300 1650
	1    0    0    -1  
$EndComp
Wire Wire Line
	10050 1800 10300 1800
Wire Wire Line
	10050 1600 10050 1800
Connection ~ 10200 1800
Wire Wire Line
	9850 1500 10300 1500
$Comp
L GND #PWR010
U 1 1 56AE6425
P 8150 4400
F 0 "#PWR010" H 8150 4150 50  0001 C CNN
F 1 "GND" H 8150 4250 50  0000 C CNN
F 2 "" H 8150 4400 60  0000 C CNN
F 3 "" H 8150 4400 60  0000 C CNN
	1    8150 4400
	1    0    0    -1  
$EndComp
NoConn ~ 6550 5450
NoConn ~ 6550 5550
NoConn ~ 6550 5650
NoConn ~ 6550 5750
NoConn ~ 6550 5850
NoConn ~ 6550 5950
NoConn ~ 6550 6050
NoConn ~ 6550 6150
NoConn ~ 6550 6250
NoConn ~ 6550 6750
NoConn ~ 6550 6550
NoConn ~ 6550 6450
$Comp
L JACK_TRS_3PINS J4
U 1 1 56B54BC1
P 2950 6300
F 0 "J4" H 2950 6700 50  0000 C CNN
F 1 "Line In" H 2900 6000 50  0000 C CNN
F 2 "mstock-pretty:SJI-3513N" H 3050 6150 50  0001 C CNN
F 3 "" H 3050 6150 50  0000 C CNN
	1    2950 6300
	-1   0    0    1   
$EndComp
Wire Wire Line
	6100 6650 6550 6650
$Comp
L C C3
U 1 1 56B54DFC
P 2250 6100
F 0 "C3" H 2275 6200 50  0000 L CNN
F 1 "1uF" H 2275 6000 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 2288 5950 50  0001 C CNN
F 3 "" H 2250 6100 50  0000 C CNN
	1    2250 6100
	0    -1   -1   0   
$EndComp
$Comp
L C C4
U 1 1 56B54EF7
P 2250 6300
F 0 "C4" H 2275 6400 50  0000 L CNN
F 1 "1uF" H 2275 6200 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 2288 6150 50  0001 C CNN
F 3 "" H 2250 6300 50  0000 C CNN
	1    2250 6300
	0    -1   -1   0   
$EndComp
$Comp
L R R1
U 1 1 56B54F2D
P 1850 6100
F 0 "R1" V 1930 6100 50  0000 C CNN
F 1 "470" V 1850 6100 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 1780 6100 50  0001 C CNN
F 3 "" H 1850 6100 50  0000 C CNN
	1    1850 6100
	0    1    1    0   
$EndComp
$Comp
L R R2
U 1 1 56B54F80
P 1850 6300
F 0 "R2" V 1930 6300 50  0000 C CNN
F 1 "470" V 1850 6300 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 1780 6300 50  0001 C CNN
F 3 "" H 1850 6300 50  0000 C CNN
	1    1850 6300
	0    1    1    0   
$EndComp
Wire Wire Line
	2000 6100 2100 6100
Wire Wire Line
	2100 6300 2000 6300
Wire Wire Line
	2400 6100 2550 6100
Wire Wire Line
	2550 6300 2400 6300
$Comp
L GNDA #PWR011
U 1 1 56B55276
P 2350 6500
F 0 "#PWR011" H 2350 6250 50  0001 C CNN
F 1 "GNDA" H 2350 6350 50  0000 C CNN
F 2 "" H 2350 6500 50  0000 C CNN
F 3 "" H 2350 6500 50  0000 C CNN
	1    2350 6500
	1    0    0    -1  
$EndComp
Wire Wire Line
	2350 6500 2550 6500
$Comp
L GNDA #PWR012
U 1 1 56B55302
P 6100 7100
F 0 "#PWR012" H 6100 6850 50  0001 C CNN
F 1 "GNDA" H 6100 6950 50  0000 C CNN
F 2 "" H 6100 7100 50  0000 C CNN
F 3 "" H 6100 7100 50  0000 C CNN
	1    6100 7100
	1    0    0    -1  
$EndComp
Wire Wire Line
	6100 6650 6100 7100
Text Label 6550 6950 2    60   ~ 0
R_IN
Text Label 6550 6850 2    60   ~ 0
L_IN
Text Label 5700 6950 2    60   ~ 0
R_OUT
Text Label 5700 6850 2    60   ~ 0
L_OUT
$Comp
L GNDA #PWR013
U 1 1 56B558A8
P 5250 6900
F 0 "#PWR013" H 5250 6650 50  0001 C CNN
F 1 "GNDA" H 5250 6750 50  0000 C CNN
F 2 "" H 5250 6900 50  0000 C CNN
F 3 "" H 5250 6900 50  0000 C CNN
	1    5250 6900
	1    0    0    -1  
$EndComp
Wire Wire Line
	5700 6650 5250 6650
Wire Wire Line
	5250 6650 5250 6900
Wire Wire Line
	5700 6750 5250 6750
Connection ~ 5250 6750
$Comp
L GNDA #PWR014
U 1 1 56B55983
P 2350 5350
F 0 "#PWR014" H 2350 5100 50  0001 C CNN
F 1 "GNDA" H 2350 5200 50  0000 C CNN
F 2 "" H 2350 5350 50  0000 C CNN
F 3 "" H 2350 5350 50  0000 C CNN
	1    2350 5350
	1    0    0    -1  
$EndComp
Wire Wire Line
	2350 5350 2550 5350
Text Label 2550 5150 2    60   ~ 0
L_OUT
Text Label 2550 4950 2    60   ~ 0
R_OUT
$Comp
L C C2
U 1 1 56B55A58
P 1450 6450
F 0 "C2" H 1475 6550 50  0000 L CNN
F 1 "10nF" H 1475 6350 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 1488 6300 50  0001 C CNN
F 3 "" H 1450 6450 50  0000 C CNN
	1    1450 6450
	1    0    0    -1  
$EndComp
$Comp
L C C1
U 1 1 56B55A9F
P 1200 6250
F 0 "C1" H 1225 6350 50  0000 L CNN
F 1 "10nF" H 1225 6150 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 1238 6100 50  0001 C CNN
F 3 "" H 1200 6250 50  0000 C CNN
	1    1200 6250
	1    0    0    -1  
$EndComp
Wire Wire Line
	1000 6100 1700 6100
Wire Wire Line
	1700 6300 1450 6300
Wire Wire Line
	1200 6400 1200 6700
Wire Wire Line
	1200 6700 1450 6700
Wire Wire Line
	1450 6600 1450 6750
$Comp
L GNDA #PWR015
U 1 1 56B55BB3
P 1450 6750
F 0 "#PWR015" H 1450 6500 50  0001 C CNN
F 1 "GNDA" H 1450 6600 50  0000 C CNN
F 2 "" H 1450 6750 50  0000 C CNN
F 3 "" H 1450 6750 50  0000 C CNN
	1    1450 6750
	1    0    0    -1  
$EndComp
Connection ~ 1450 6700
Connection ~ 1200 6100
Wire Wire Line
	1450 6300 1450 5950
Wire Wire Line
	1450 5950 1000 5950
Connection ~ 1450 6300
Text Label 1000 5950 2    60   ~ 0
L_IN
Text Label 1000 6100 2    60   ~ 0
R_IN
$Comp
L CONN_01X09 P3
U 1 1 56B568B7
P 4400 2250
F 0 "P3" H 4400 2750 50  0000 C CNN
F 1 "Bluetooth" V 4500 2250 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_1x09" H 4400 2250 50  0001 C CNN
F 3 "" H 4400 2250 50  0000 C CNN
	1    4400 2250
	1    0    0    -1  
$EndComp
Text Label 4200 1850 2    60   ~ 0
SCLK_33
Text Label 4200 1950 2    60   ~ 0
MISO_33
Text Label 4200 2050 2    60   ~ 0
MOSI_33
Text Label 4200 2150 2    60   ~ 0
~BLE_CS
Text Label 6250 4000 2    60   ~ 0
~BLE_CS
Text Label 4200 2350 2    60   ~ 0
BLE_DEV
Text Label 4200 2450 2    60   ~ 0
~RST
Text Label 4200 2250 2    60   ~ 0
BLE_IRQ
Text Label 7250 4100 0    60   ~ 0
BLE_IRQ
$Comp
L GND #PWR016
U 1 1 56B56E0E
P 3900 2550
F 0 "#PWR016" H 3900 2300 50  0001 C CNN
F 1 "GND" H 3900 2400 50  0000 C CNN
F 2 "" H 3900 2550 60  0000 C CNN
F 3 "" H 3900 2550 60  0000 C CNN
	1    3900 2550
	0    1    1    0   
$EndComp
$Comp
L +5V #PWR017
U 1 1 56B56E4C
P 3450 2600
F 0 "#PWR017" H 3450 2450 50  0001 C CNN
F 1 "+5V" H 3450 2740 50  0000 C CNN
F 2 "" H 3450 2600 60  0000 C CNN
F 3 "" H 3450 2600 60  0000 C CNN
	1    3450 2600
	1    0    0    -1  
$EndComp
Wire Wire Line
	3900 2550 4200 2550
Wire Wire Line
	3450 2600 3450 2650
Wire Wire Line
	3450 2650 4200 2650
Text Label 7250 3900 0    60   ~ 0
IO_17
Text Label 7250 4000 0    60   ~ 0
IO_19
Text Label 6250 4100 2    60   ~ 0
IO_20
Text Label 6250 4700 2    60   ~ 0
IO_30
Text Label 6250 4800 2    60   ~ 0
IO_32
Text Label 7250 4700 0    60   ~ 0
IO_31
Text Label 8700 5350 2    60   ~ 0
IO_17
Text Label 8700 5450 2    60   ~ 0
IO_19
Text Label 8700 5550 2    60   ~ 0
IO_20
Text Label 8700 5650 2    60   ~ 0
IO_30
Text Label 8700 5750 2    60   ~ 0
IO_31
Text Label 8700 5850 2    60   ~ 0
IO_32
$Comp
L CONN_01X08 P4
U 1 1 56B6108F
P 8900 5700
F 0 "P4" H 8900 6150 50  0000 C CNN
F 1 "CONN_01X08" V 9000 5700 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_2x04" H 8900 5700 50  0001 C CNN
F 3 "" H 8900 5700 50  0000 C CNN
	1    8900 5700
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR018
U 1 1 56B610FD
P 8300 5950
F 0 "#PWR018" H 8300 5800 50  0001 C CNN
F 1 "+3.3V" H 8300 6090 50  0000 C CNN
F 2 "" H 8300 5950 60  0000 C CNN
F 3 "" H 8300 5950 60  0000 C CNN
	1    8300 5950
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR019
U 1 1 56B6113E
P 8600 6050
F 0 "#PWR019" H 8600 5800 50  0001 C CNN
F 1 "GND" H 8600 5900 50  0000 C CNN
F 2 "" H 8600 6050 60  0000 C CNN
F 3 "" H 8600 6050 60  0000 C CNN
	1    8600 6050
	1    0    0    -1  
$EndComp
Wire Wire Line
	8600 6050 8700 6050
Wire Wire Line
	8700 5950 8300 5950
$EndSCHEMATC
