-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW funcao_migracao_v (ie_gerencia, cd_funcao, ds_funcao, ds_form) AS select	3 ie_gerencia,
	cd_funcao,
	ds_funcao,
	ds_form
FROM	funcao
where	cd_funcao in (
		-975, -970, 1355, 697, 1134, -1002, 1129, 996, -980,
		3250, 10030, 90, 1136, 1011, 922, 275, 169, 9042,
		1132, 9030, 935, 281, /*7047,*/
 -1004, 9037, 1113, -926,
		1903, -2170, -16, -26, 1801, 9047, 942, 7044, 1119, -924,
		28, -2225, 3111, -209, 44, -315, 9039, 998, -2050, -325,
		950, 924, -40, -995, 9029, -2100, -18, 8030, 8050, 870,
		-25, 874, 7020, 873, 1133, -2009, 995, 123, 91,
		-2150, 871, 8010, 7015, 7010, 900, 3112, 1009, 1700, 7022,
		-9, 3007, 896, 1010, 1580, 3010, 8008, -2222, -1113, 9044,
		872, 1112, 8012, -2040, 821, 820, 865, 866, -1007, 869,
		3032, 944, 909, 970, 723, 9032, 3033, 7008, 1135, 46,
		8014, 61, 1007, 7012, 7011, 4200, 916, 1, 746,
		711, 722, 936, 8051, 1003, 1950, 7005, 7032, 7043, 7009,
		867, 941, 3030, 3031, 7026, 75, 7006, 1002, 868, 450,
		719, 945, 47, -102, 725, 718, 1000, 951, -2070, 912,
		895, 9021, 9048, 991, -2226, 17, 3130, 994,
		1302, 3131, 989, 1137, 9007)

union

select	2 ie_gerencia,
	cd_funcao,
	ds_funcao,
	ds_form
from	funcao
where	cd_funcao in (
		8016, 927, -2015, 7024, 7033, 4, 590, -530, 923, 1200,
		937, 911, 135, 63, 7027, -756, 925, 7050, 7001, 137,
		84, 86, 232, 7048, 79, 1116, 921, 18, 140,
		-14, 7051, 987, 1115, 171, 67, 72, -2003, -1000, 223,
		947, 997, 930, 1001, 24, 1117, 7021, 7042, 256, 3008,
		106, 7028, 25, 170, 85, 905, 1800, 3110, 15, -15,
		48, 13, 3011, 9049, 4003, 298, 1121, 212, -2223, 4000,
		1006, 1126, -298, -297, -299, 297, 1123, 1124, 1125,
		1131, 1130, 1128, 1127, 3050, 858, 3020, 810, 1118,
		724, 3004, 3006, 2000, 855, 809, 5, 230, 1008, 1120,
		32, 5513, 860, 815, 87, 812, 1114, 7500, 854, 859,
		66, 814, 5500, 811, 1199, 1350, 2500, 1300, 907, -814,
		802, 127, 105, 104, 103, 3009, 5511, 5512, 830, 999,
		-821, 908, -80, 988, 5000, 69, 1005,
		3002, -8, -2, -2020, 1901, 801, 857, 290, 290,
		92, 89, 613, 27, 813, 1899, 3400, 851,
		-815, 6001, 292, 3135, 1905, 8020, 992,
		265, 993, 7046, 7041, 215, 7002, 8011, 3140, 291, -2224,
		7049, 7004, 143, 267, 36, 109, 7029, 7007, 53,
		7023, 407, 132, 705, -204, 139, -2012, 130, 903,
		175, 928, 146, 915, 42, 43, 147, 1750, 4100, 406,
		920, 7030, 270, 918, 7505, 954, -6, -124, -110,
		40, 917, 6, 243, 953, 952, -128, 410, 919, 1301,
		929, 913)

union

select	1 ie_gerencia,
	cd_funcao,
	ds_funcao,
	ds_form
from	funcao
where	cd_funcao in (
		1236, 1265, 1201, 1209, 1220, 1243, 1226, 1235, 1234, 1267,
		1215, 1237, 1202, 1225, 1206, 1260, 1216, 1219, 1221, 1228,
		1205, 1242, 1232, 1207, 1244, 1264, 1233, 1214, 100, 1263,
		1204, 1211, 1240, 1210, 1238, 1229, 1261, 1227, 1208, 1230,
		1222, 1266, 110, 1203, 1259, 1231, 1213, 1212, 1239, 1262,
		/*-2030, -2035, 8015, 7040,*/
 1241, 1245)

union

select	4 ie_gerencia,
	cd_funcao,
	ds_funcao,
	ds_form
from	funcao
where	cd_funcao in (
		-991, 250, 933, 3001, -261, 10, 7045, 1111, 6005, -991,
		9, -992)

union

select	5 ie_gerencia,
	cd_funcao,
	ds_funcao,
	ds_form
from	funcao
where	ds_aplicacao = 'TasyMed'
and	coalesce(ie_situacao,'A') = 'A';

