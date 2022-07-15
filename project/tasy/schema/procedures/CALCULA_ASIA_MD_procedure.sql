-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcula_asia_md (IE_MOTOR_C5_R_P bigint, IE_MOTOR_C6_R_P bigint, IE_MOTOR_C7_R_P bigint, IE_MOTOR_C8_R_P bigint, IE_MOTOR_T1_R_P bigint, IE_MOTOR_C5_L_P bigint, IE_MOTOR_C6_L_P bigint, IE_MOTOR_C7_L_P bigint, IE_MOTOR_C8_L_P bigint, IE_MOTOR_T1_L_P bigint, IE_MOTOR_L2_R_P bigint, IE_MOTOR_L3_R_P bigint, IE_MOTOR_L4_R_P bigint, IE_MOTOR_L5_R_P bigint, IE_MOTOR_S1_R_P bigint, IE_MOTOR_L2_L_P bigint, IE_MOTOR_L3_L_P bigint, IE_MOTOR_L4_L_P bigint, IE_MOTOR_L5_L_P bigint, IE_MOTOR_S1_L_P bigint, IE_SENS_AGU_C2_R_P bigint, IE_SENS_AGU_C3_R_P bigint, IE_SENS_AGU_C4_R_P bigint, IE_SENS_AGU_C5_R_P bigint, IE_SENS_AGU_C6_R_P bigint, IE_SENS_AGU_C7_R_P bigint, IE_SENS_AGU_C8_R_P bigint, IE_SENS_AGU_T1_R_P bigint, IE_SENS_AGU_T2_R_P bigint, IE_SENS_AGU_T3_R_P bigint, IE_SENS_AGU_T4_R_P bigint, IE_SENS_AGU_T5_R_P bigint, IE_SENS_AGU_T6_R_P bigint, IE_SENS_AGU_T7_R_P bigint, IE_SENS_AGU_T8_R_P bigint, IE_SENS_AGU_T9_R_P bigint, IE_SENS_AGU_T10_R_P bigint, IE_SENS_AGU_T11_R_P bigint, IE_SENS_AGU_T12_R_P bigint, IE_SENS_AGU_L1_R_P bigint, IE_SENS_AGU_L2_R_P bigint, IE_SENS_AGU_L3_R_P bigint, IE_SENS_AGU_L4_R_P bigint, IE_SENS_AGU_L5_R_P bigint, IE_SENS_AGU_S1_R_P bigint, IE_SENS_AGU_S2_R_P bigint, IE_SENS_AGU_S3_R_P bigint, IE_SENS_AGU_S4_5_R_P bigint, IE_SENS_AGU_C2_L_P bigint, IE_SENS_AGU_C3_L_P bigint, IE_SENS_AGU_C4_L_P bigint, IE_SENS_AGU_C5_L_P bigint, IE_SENS_AGU_C6_L_P bigint, IE_SENS_AGU_C7_L_P bigint, IE_SENS_AGU_C8_L_P bigint, IE_SENS_AGU_T1_L_P bigint, IE_SENS_AGU_T2_L_P bigint, IE_SENS_AGU_T3_L_P bigint, IE_SENS_AGU_T4_L_P bigint, IE_SENS_AGU_T5_L_P bigint, IE_SENS_AGU_T6_L_P bigint, IE_SENS_AGU_T7_L_P bigint, IE_SENS_AGU_T8_L_P bigint, IE_SENS_AGU_T9_L_P bigint, IE_SENS_AGU_T10_L_P bigint, IE_SENS_AGU_T11_L_P bigint, IE_SENS_AGU_T12_L_P bigint, IE_SENS_AGU_L1_L_P bigint, IE_SENS_AGU_L2_L_P bigint, IE_SENS_AGU_L3_L_P bigint, IE_SENS_AGU_L4_L_P bigint, IE_SENS_AGU_L5_L_P bigint, IE_SENS_AGU_S1_L_P bigint, IE_SENS_AGU_S2_L_P bigint, IE_SENS_AGU_S3_L_P bigint, IE_SENS_AGU_S4_5_L_P bigint, IE_SENS_TOQ_C2_R_P bigint, IE_SENS_TOQ_C3_R_P bigint, IE_SENS_TOQ_C4_R_P bigint, IE_SENS_TOQ_C5_R_P bigint, IE_SENS_TOQ_C6_R_P bigint, IE_SENS_TOQ_C7_R_P bigint, IE_SENS_TOQ_C8_R_P bigint, IE_SENS_TOQ_T1_R_P bigint, IE_SENS_TOQ_T2_R_P bigint, IE_SENS_TOQ_T3_R_P bigint, IE_SENS_TOQ_T4_R_P bigint, IE_SENS_TOQ_T5_R_P bigint, IE_SENS_TOQ_T6_R_P bigint, IE_SENS_TOQ_T7_R_P bigint, IE_SENS_TOQ_T8_R_P bigint, IE_SENS_TOQ_T9_R_P bigint, IE_SENS_TOQ_T10_R_P bigint, IE_SENS_TOQ_T11_R_P bigint, IE_SENS_TOQ_T12_R_P bigint, IE_SENS_TOQ_L1_R_P bigint, IE_SENS_TOQ_L2_R_P bigint, IE_SENS_TOQ_L3_R_P bigint, IE_SENS_TOQ_L4_R_P bigint, IE_SENS_TOQ_L5_R_P bigint, IE_SENS_TOQ_S1_R_P bigint, IE_SENS_TOQ_S2_R_P bigint, IE_SENS_TOQ_S3_R_P bigint, IE_SENS_TOQ_S4_5_R_P bigint, IE_SENS_TOQ_C2_L_P bigint, IE_SENS_TOQ_C3_L_P bigint, IE_SENS_TOQ_C4_L_P bigint, IE_SENS_TOQ_C5_L_P bigint, IE_SENS_TOQ_C6_L_P bigint, IE_SENS_TOQ_C7_L_P bigint, IE_SENS_TOQ_C8_L_P bigint, IE_SENS_TOQ_T1_L_P bigint, IE_SENS_TOQ_T2_L_P bigint, IE_SENS_TOQ_T3_L_P bigint, IE_SENS_TOQ_T4_L_P bigint, IE_SENS_TOQ_T5_L_P bigint, IE_SENS_TOQ_T6_L_P bigint, IE_SENS_TOQ_T7_L_P bigint, IE_SENS_TOQ_T8_L_P bigint, IE_SENS_TOQ_T9_L_P bigint, IE_SENS_TOQ_T10_L_P bigint, IE_SENS_TOQ_T11_L_P bigint, IE_SENS_TOQ_T12_L_P bigint, IE_SENS_TOQ_L1_L_P bigint, IE_SENS_TOQ_L2_L_P bigint, IE_SENS_TOQ_L3_L_P bigint, IE_SENS_TOQ_L4_L_P bigint, IE_SENS_TOQ_L5_L_P bigint, IE_SENS_TOQ_S1_L_P bigint, IE_SENS_TOQ_S2_L_P bigint, IE_SENS_TOQ_S3_L_P bigint, IE_SENS_TOQ_S4_5_L_P bigint, QT_PONT_MOTOR_SUP_R_P INOUT bigint, QT_PONT_MOTOR_SUP_L_P INOUT bigint, QT_PONT_MOTOR_SUP_P INOUT bigint, QT_PONT_MOTOR_INF_R_P INOUT bigint, QT_PONT_MOTOR_INF_L_P INOUT bigint, QT_PONT_MOTOR_INF_P INOUT bigint, QT_PONT_AGU_TOQ_R_P INOUT bigint, QT_PONT_AGU_TOQ_L_P INOUT bigint, QT_PONT_AGU_TOQ_P INOUT bigint, QT_PONT_SENS_TOQ_R_P INOUT bigint, QT_PONT_SENS_TOQ_L_P INOUT bigint, QT_PONT_SENS_TOQ_P INOUT bigint ) AS $body$
BEGIN
	QT_PONT_MOTOR_SUP_R_P	:= somente_numero(IE_MOTOR_C5_R_P) +
                           somente_numero(IE_MOTOR_C6_R_P) +
                           somente_numero(IE_MOTOR_C7_R_P) +
                           somente_numero(IE_MOTOR_C8_R_P) +
                           somente_numero(IE_MOTOR_T1_R_P);

	QT_PONT_MOTOR_SUP_L_P	:=	somente_numero(IE_MOTOR_C5_L_P) +
								somente_numero(IE_MOTOR_C6_L_P) +
								somente_numero(IE_MOTOR_C7_L_P) +
								somente_numero(IE_MOTOR_C8_L_P) +
								somente_numero(IE_MOTOR_T1_L_P);

	QT_PONT_MOTOR_SUP_P		:=	coalesce(QT_PONT_MOTOR_SUP_R_P,0) + coalesce(QT_PONT_MOTOR_SUP_L_P,0);

	QT_PONT_MOTOR_INF_R_P	:=	somente_numero(IE_MOTOR_L2_R_P) +
								somente_numero(IE_MOTOR_L3_R_P) +
								somente_numero(IE_MOTOR_L4_R_P) +
								somente_numero(IE_MOTOR_L5_R_P) +
								somente_numero(IE_MOTOR_S1_R_P);

	QT_PONT_MOTOR_INF_L_P := somente_numero(IE_MOTOR_L2_L_P) +
								somente_numero(IE_MOTOR_L3_L_P) +
								somente_numero(IE_MOTOR_L4_L_P) +
								somente_numero(IE_MOTOR_L5_L_P) +
								somente_numero(IE_MOTOR_S1_L_P);

	QT_PONT_MOTOR_INF_P := coalesce(QT_PONT_MOTOR_INF_R_P,0) + coalesce(QT_PONT_MOTOR_INF_L_P,0);

	QT_PONT_AGU_TOQ_R_P := somente_numero(IE_SENS_AGU_C2_R_P) +
								somente_numero(IE_SENS_AGU_C3_R_P) +
								somente_numero(IE_SENS_AGU_C4_R_P) +
								somente_numero(IE_SENS_AGU_C5_R_P) +
								somente_numero(IE_SENS_AGU_C6_R_P) +
								somente_numero(IE_SENS_AGU_C7_R_P) +
								somente_numero(IE_SENS_AGU_C8_R_P) +
								somente_numero(IE_SENS_AGU_T1_R_P) +
								somente_numero(IE_SENS_AGU_T2_R_P) +
								somente_numero(IE_SENS_AGU_T3_R_P) +
								somente_numero(IE_SENS_AGU_T4_R_P) +
								somente_numero(IE_SENS_AGU_T5_R_P) +
								somente_numero(IE_SENS_AGU_T6_R_P) +
								somente_numero(IE_SENS_AGU_T7_R_P) +
								somente_numero(IE_SENS_AGU_T8_R_P) +
								somente_numero(IE_SENS_AGU_T9_R_P) +
								somente_numero(IE_SENS_AGU_T10_R_P) +
								somente_numero(IE_SENS_AGU_T11_R_P) +
								somente_numero(IE_SENS_AGU_T12_R_P) +
								somente_numero(IE_SENS_AGU_L1_R_P) +
								somente_numero(IE_SENS_AGU_L2_R_P) +
								somente_numero(IE_SENS_AGU_L3_R_P) +
								somente_numero(IE_SENS_AGU_L4_R_P) +
								somente_numero(IE_SENS_AGU_L5_R_P) +
								somente_numero(IE_SENS_AGU_S1_R_P) +
								somente_numero(IE_SENS_AGU_S2_R_P) +
								somente_numero(IE_SENS_AGU_S3_R_P) +
								somente_numero(IE_SENS_AGU_S4_5_R_P);

	QT_PONT_AGU_TOQ_L_P := somente_numero(IE_SENS_AGU_C2_L_P) +
								somente_numero(IE_SENS_AGU_C3_L_P) +
								somente_numero(IE_SENS_AGU_C4_L_P) +
								somente_numero(IE_SENS_AGU_C5_L_P) +
								somente_numero(IE_SENS_AGU_C6_L_P) +
								somente_numero(IE_SENS_AGU_C7_L_P) +
								somente_numero(IE_SENS_AGU_C8_L_P) +
								somente_numero(IE_SENS_AGU_T1_L_P) +
								somente_numero(IE_SENS_AGU_T2_L_P) +
								somente_numero(IE_SENS_AGU_T3_L_P) +
								somente_numero(IE_SENS_AGU_T4_L_P) +
								somente_numero(IE_SENS_AGU_T5_L_P) +
								somente_numero(IE_SENS_AGU_T6_L_P) +
								somente_numero(IE_SENS_AGU_T7_L_P) +
								somente_numero(IE_SENS_AGU_T8_L_P) +
								somente_numero(IE_SENS_AGU_T9_L_P) +
								somente_numero(IE_SENS_AGU_T10_L_P) +
								somente_numero(IE_SENS_AGU_T11_L_P) +
								somente_numero(IE_SENS_AGU_T12_L_P) +
								somente_numero(IE_SENS_AGU_L1_L_P) +
								somente_numero(IE_SENS_AGU_L2_L_P) +
								somente_numero(IE_SENS_AGU_L3_L_P) +
								somente_numero(IE_SENS_AGU_L4_L_P) +
								somente_numero(IE_SENS_AGU_L5_L_P) +
								somente_numero(IE_SENS_AGU_S1_L_P) +
								somente_numero(IE_SENS_AGU_S2_L_P) +
								somente_numero(IE_SENS_AGU_S3_L_P) +
								somente_numero(IE_SENS_AGU_S4_5_L_P);

	QT_PONT_AGU_TOQ_P		:=	coalesce(QT_PONT_AGU_TOQ_R_P,0) + coalesce(QT_PONT_AGU_TOQ_L_P,0);

	QT_PONT_SENS_TOQ_R_P		:=	somente_numero(IE_SENS_TOQ_C2_R_P) +
									somente_numero(IE_SENS_TOQ_C3_R_P) +
									somente_numero(IE_SENS_TOQ_C4_R_P) +
									somente_numero(IE_SENS_TOQ_C5_R_P) +
									somente_numero(IE_SENS_TOQ_C6_R_P) +
									somente_numero(IE_SENS_TOQ_C7_R_P) +
									somente_numero(IE_SENS_TOQ_C8_R_P) +
									somente_numero(IE_SENS_TOQ_T1_R_P) +
									somente_numero(IE_SENS_TOQ_T2_R_P) +
									somente_numero(IE_SENS_TOQ_T3_R_P) +
									somente_numero(IE_SENS_TOQ_T4_R_P) +
									somente_numero(IE_SENS_TOQ_T5_R_P) +
									somente_numero(IE_SENS_TOQ_T6_R_P) +
									somente_numero(IE_SENS_TOQ_T7_R_P) +
									somente_numero(IE_SENS_TOQ_T8_R_P) +
									somente_numero(IE_SENS_TOQ_T9_R_P) +
									somente_numero(IE_SENS_TOQ_T10_R_P) +
									somente_numero(IE_SENS_TOQ_T11_R_P) +
									somente_numero(IE_SENS_TOQ_T12_R_P) +
									somente_numero(IE_SENS_TOQ_L1_R_P) +
									somente_numero(IE_SENS_TOQ_L2_R_P) +
									somente_numero(IE_SENS_TOQ_L3_R_P) +
									somente_numero(IE_SENS_TOQ_L4_R_P) +
									somente_numero(IE_SENS_TOQ_L5_R_P) +
									somente_numero(IE_SENS_TOQ_S1_R_P) +
									somente_numero(IE_SENS_TOQ_S2_R_P) +
									somente_numero(IE_SENS_TOQ_S3_R_P) +
									somente_numero(IE_SENS_TOQ_S4_5_R_P);

	QT_PONT_SENS_TOQ_L_P		:=	somente_numero(IE_SENS_TOQ_C2_L_P) +
									somente_numero(IE_SENS_TOQ_C3_L_P) +
									somente_numero(IE_SENS_TOQ_C4_L_P) +
									somente_numero(IE_SENS_TOQ_C5_L_P) +
									somente_numero(IE_SENS_TOQ_C6_L_P) +
									somente_numero(IE_SENS_TOQ_C7_L_P) +
									somente_numero(IE_SENS_TOQ_C8_L_P) +
									somente_numero(IE_SENS_TOQ_T1_L_P) +
									somente_numero(IE_SENS_TOQ_T2_L_P) +
									somente_numero(IE_SENS_TOQ_T3_L_P) +
									somente_numero(IE_SENS_TOQ_T4_L_P) +
									somente_numero(IE_SENS_TOQ_T5_L_P) +
									somente_numero(IE_SENS_TOQ_T6_L_P) +
									somente_numero(IE_SENS_TOQ_T7_L_P) +
									somente_numero(IE_SENS_TOQ_T8_L_P) +
									somente_numero(IE_SENS_TOQ_T9_L_P) +
									somente_numero(IE_SENS_TOQ_T10_L_P) +
									somente_numero(IE_SENS_TOQ_T11_L_P) +
									somente_numero(IE_SENS_TOQ_T12_L_P) +
									somente_numero(IE_SENS_TOQ_L1_L_P) +
									somente_numero(IE_SENS_TOQ_L2_L_P) +
									somente_numero(IE_SENS_TOQ_L3_L_P) +
									somente_numero(IE_SENS_TOQ_L4_L_P) +
									somente_numero(IE_SENS_TOQ_L5_L_P) +
									somente_numero(IE_SENS_TOQ_S1_L_P) +
									somente_numero(IE_SENS_TOQ_S2_L_P) +
									somente_numero(IE_SENS_TOQ_S3_L_P) +
									somente_numero(IE_SENS_TOQ_S4_5_L_P);

	QT_PONT_SENS_TOQ_P		:=	coalesce(QT_PONT_SENS_TOQ_R_P,0) + coalesce(QT_PONT_SENS_TOQ_L_P,0);
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcula_asia_md (IE_MOTOR_C5_R_P bigint, IE_MOTOR_C6_R_P bigint, IE_MOTOR_C7_R_P bigint, IE_MOTOR_C8_R_P bigint, IE_MOTOR_T1_R_P bigint, IE_MOTOR_C5_L_P bigint, IE_MOTOR_C6_L_P bigint, IE_MOTOR_C7_L_P bigint, IE_MOTOR_C8_L_P bigint, IE_MOTOR_T1_L_P bigint, IE_MOTOR_L2_R_P bigint, IE_MOTOR_L3_R_P bigint, IE_MOTOR_L4_R_P bigint, IE_MOTOR_L5_R_P bigint, IE_MOTOR_S1_R_P bigint, IE_MOTOR_L2_L_P bigint, IE_MOTOR_L3_L_P bigint, IE_MOTOR_L4_L_P bigint, IE_MOTOR_L5_L_P bigint, IE_MOTOR_S1_L_P bigint, IE_SENS_AGU_C2_R_P bigint, IE_SENS_AGU_C3_R_P bigint, IE_SENS_AGU_C4_R_P bigint, IE_SENS_AGU_C5_R_P bigint, IE_SENS_AGU_C6_R_P bigint, IE_SENS_AGU_C7_R_P bigint, IE_SENS_AGU_C8_R_P bigint, IE_SENS_AGU_T1_R_P bigint, IE_SENS_AGU_T2_R_P bigint, IE_SENS_AGU_T3_R_P bigint, IE_SENS_AGU_T4_R_P bigint, IE_SENS_AGU_T5_R_P bigint, IE_SENS_AGU_T6_R_P bigint, IE_SENS_AGU_T7_R_P bigint, IE_SENS_AGU_T8_R_P bigint, IE_SENS_AGU_T9_R_P bigint, IE_SENS_AGU_T10_R_P bigint, IE_SENS_AGU_T11_R_P bigint, IE_SENS_AGU_T12_R_P bigint, IE_SENS_AGU_L1_R_P bigint, IE_SENS_AGU_L2_R_P bigint, IE_SENS_AGU_L3_R_P bigint, IE_SENS_AGU_L4_R_P bigint, IE_SENS_AGU_L5_R_P bigint, IE_SENS_AGU_S1_R_P bigint, IE_SENS_AGU_S2_R_P bigint, IE_SENS_AGU_S3_R_P bigint, IE_SENS_AGU_S4_5_R_P bigint, IE_SENS_AGU_C2_L_P bigint, IE_SENS_AGU_C3_L_P bigint, IE_SENS_AGU_C4_L_P bigint, IE_SENS_AGU_C5_L_P bigint, IE_SENS_AGU_C6_L_P bigint, IE_SENS_AGU_C7_L_P bigint, IE_SENS_AGU_C8_L_P bigint, IE_SENS_AGU_T1_L_P bigint, IE_SENS_AGU_T2_L_P bigint, IE_SENS_AGU_T3_L_P bigint, IE_SENS_AGU_T4_L_P bigint, IE_SENS_AGU_T5_L_P bigint, IE_SENS_AGU_T6_L_P bigint, IE_SENS_AGU_T7_L_P bigint, IE_SENS_AGU_T8_L_P bigint, IE_SENS_AGU_T9_L_P bigint, IE_SENS_AGU_T10_L_P bigint, IE_SENS_AGU_T11_L_P bigint, IE_SENS_AGU_T12_L_P bigint, IE_SENS_AGU_L1_L_P bigint, IE_SENS_AGU_L2_L_P bigint, IE_SENS_AGU_L3_L_P bigint, IE_SENS_AGU_L4_L_P bigint, IE_SENS_AGU_L5_L_P bigint, IE_SENS_AGU_S1_L_P bigint, IE_SENS_AGU_S2_L_P bigint, IE_SENS_AGU_S3_L_P bigint, IE_SENS_AGU_S4_5_L_P bigint, IE_SENS_TOQ_C2_R_P bigint, IE_SENS_TOQ_C3_R_P bigint, IE_SENS_TOQ_C4_R_P bigint, IE_SENS_TOQ_C5_R_P bigint, IE_SENS_TOQ_C6_R_P bigint, IE_SENS_TOQ_C7_R_P bigint, IE_SENS_TOQ_C8_R_P bigint, IE_SENS_TOQ_T1_R_P bigint, IE_SENS_TOQ_T2_R_P bigint, IE_SENS_TOQ_T3_R_P bigint, IE_SENS_TOQ_T4_R_P bigint, IE_SENS_TOQ_T5_R_P bigint, IE_SENS_TOQ_T6_R_P bigint, IE_SENS_TOQ_T7_R_P bigint, IE_SENS_TOQ_T8_R_P bigint, IE_SENS_TOQ_T9_R_P bigint, IE_SENS_TOQ_T10_R_P bigint, IE_SENS_TOQ_T11_R_P bigint, IE_SENS_TOQ_T12_R_P bigint, IE_SENS_TOQ_L1_R_P bigint, IE_SENS_TOQ_L2_R_P bigint, IE_SENS_TOQ_L3_R_P bigint, IE_SENS_TOQ_L4_R_P bigint, IE_SENS_TOQ_L5_R_P bigint, IE_SENS_TOQ_S1_R_P bigint, IE_SENS_TOQ_S2_R_P bigint, IE_SENS_TOQ_S3_R_P bigint, IE_SENS_TOQ_S4_5_R_P bigint, IE_SENS_TOQ_C2_L_P bigint, IE_SENS_TOQ_C3_L_P bigint, IE_SENS_TOQ_C4_L_P bigint, IE_SENS_TOQ_C5_L_P bigint, IE_SENS_TOQ_C6_L_P bigint, IE_SENS_TOQ_C7_L_P bigint, IE_SENS_TOQ_C8_L_P bigint, IE_SENS_TOQ_T1_L_P bigint, IE_SENS_TOQ_T2_L_P bigint, IE_SENS_TOQ_T3_L_P bigint, IE_SENS_TOQ_T4_L_P bigint, IE_SENS_TOQ_T5_L_P bigint, IE_SENS_TOQ_T6_L_P bigint, IE_SENS_TOQ_T7_L_P bigint, IE_SENS_TOQ_T8_L_P bigint, IE_SENS_TOQ_T9_L_P bigint, IE_SENS_TOQ_T10_L_P bigint, IE_SENS_TOQ_T11_L_P bigint, IE_SENS_TOQ_T12_L_P bigint, IE_SENS_TOQ_L1_L_P bigint, IE_SENS_TOQ_L2_L_P bigint, IE_SENS_TOQ_L3_L_P bigint, IE_SENS_TOQ_L4_L_P bigint, IE_SENS_TOQ_L5_L_P bigint, IE_SENS_TOQ_S1_L_P bigint, IE_SENS_TOQ_S2_L_P bigint, IE_SENS_TOQ_S3_L_P bigint, IE_SENS_TOQ_S4_5_L_P bigint, QT_PONT_MOTOR_SUP_R_P INOUT bigint, QT_PONT_MOTOR_SUP_L_P INOUT bigint, QT_PONT_MOTOR_SUP_P INOUT bigint, QT_PONT_MOTOR_INF_R_P INOUT bigint, QT_PONT_MOTOR_INF_L_P INOUT bigint, QT_PONT_MOTOR_INF_P INOUT bigint, QT_PONT_AGU_TOQ_R_P INOUT bigint, QT_PONT_AGU_TOQ_L_P INOUT bigint, QT_PONT_AGU_TOQ_P INOUT bigint, QT_PONT_SENS_TOQ_R_P INOUT bigint, QT_PONT_SENS_TOQ_L_P INOUT bigint, QT_PONT_SENS_TOQ_P INOUT bigint ) FROM PUBLIC;

