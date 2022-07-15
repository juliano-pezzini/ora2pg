-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_generate_10_tl (nr_seq_indicator_p bigint) AS $body$
DECLARE


pfcs_panel_seq_w				pfcs_panel.nr_sequencia%type;
cd_estabelecimento_w			bigint;
nm_usuario_p	varchar(20);


BEGIN
DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL in (60000,60001,60002,60003,60004,60005,60006,60007,60008,60009,60010,60011,60012,60013);
DELETE FROM pfcs_detail_bed WHERE NR_SEQ_DETAIL in (60000,60001,60002,60003,60004,60005,60006,60007,60008,60009,60010,60011,60012,60013);
DELETE FROM pfcs_detail_device WHERE NR_SEQ_DETAIL in (60000,60001,60002,60003,60004,60005,60006,60007,60008,60009,60010,60011,60012,60013);
DELETE FROM pfcs_panel_detail WHERE NR_SEQ_INDICATOR = 51;
DELETE FROM pfcs_panel WHERE NR_SEQ_INDICATOR = 51;
nm_usuario_p := 'asimovbr';
cd_estabelecimento_w	:= pfcs_get_structure_level(cd_establishment_p => 1, ie_level_p => 'O', ie_info_p => 'C');


/* INSERT QUERY NO: 1 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
60000, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', nr_seq_indicator_p, cd_estabelecimento_w
);

/* INSERT QUERY NO: 2 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
60001, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', nr_seq_indicator_p, cd_estabelecimento_w
);

/* INSERT QUERY NO: 3 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
60002, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', nr_seq_indicator_p, cd_estabelecimento_w
);

/* INSERT QUERY NO: 4 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
60003, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', nr_seq_indicator_p, cd_estabelecimento_w
);

/* INSERT QUERY NO: 5 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
60004, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', nr_seq_indicator_p, cd_estabelecimento_w
);

-------------------------------------------------- pfcs_detail_patient --------------------------------------------------
/* INSERT QUERY NO: 1 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DS_GENDER, DT_BIRTHDATE, DS_PRIMARY_DIAGNOSIS, QT_TIME_TELEMETRY, DS_DNR_STATUS, DS_CURRENT_LOCATION, DT_ENTRANCE, CD_CLASSIFICATION, DS_CLASSIFICATION, DS_SERVICE_LINE, QT_YELLOW_ALARMS, QT_RED_ALARMS)
VALUES (
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 60000, 991359, 624611, 'LITTLE, Petúnia Genoveva Abigail Stuart', 'Female', to_date('24/06/1982 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), '', 11499, '', '', (clock_timestamp() - interval '10 days'), 2, 'Risco de queda', '', 2, 4
);

/* INSERT QUERY NO: 2 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DS_GENDER, DT_BIRTHDATE, DS_PRIMARY_DIAGNOSIS, QT_TIME_TELEMETRY, DS_DNR_STATUS, DS_CURRENT_LOCATION, DT_ENTRANCE, CD_CLASSIFICATION, DS_CLASSIFICATION, DS_SERVICE_LINE, QT_YELLOW_ALARMS, QT_RED_ALARMS)
VALUES (
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 60001, 3423710, 1020627599, 'Katherine, L.', 'Female', to_date('18/10/1964 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), '', 11495, '', 'Cloc-Testwtasy', (clock_timestamp() - interval '3 days'), 1, 'VIP', 'Bittencourt, O.', 0, 0
);

/* INSERT QUERY NO: 3 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DS_GENDER, DT_BIRTHDATE, DS_PRIMARY_DIAGNOSIS, QT_TIME_TELEMETRY, DS_DNR_STATUS, DS_CURRENT_LOCATION, DT_ENTRANCE, CD_CLASSIFICATION, DS_CLASSIFICATION, DS_SERVICE_LINE, QT_YELLOW_ALARMS, QT_RED_ALARMS)
VALUES (
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 60002, 3423717, 1020627601, 'Water, C.', 'Indefinido', to_date('28/12/1960 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), '', 11438, '', 'Pronto Socorro Cardíaco', (clock_timestamp() - interval '7 days'), 1, 'VIP', 'Bittencourt, O.', 0, 0
);

/* INSERT QUERY NO: 4 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DS_GENDER, DT_BIRTHDATE, DS_PRIMARY_DIAGNOSIS, QT_TIME_TELEMETRY, DS_DNR_STATUS, DS_CURRENT_LOCATION, DT_ENTRANCE, CD_CLASSIFICATION, DS_CLASSIFICATION, DS_SERVICE_LINE, QT_YELLOW_ALARMS, QT_RED_ALARMS)
VALUES (
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 60003, 3423700, 1020627591, 'Pitchwell, J.', 'Male', to_date('10/11/2010 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 'Severe right wrist pain', 11499, 'DNR', 'Cloc-Testwtasy', (clock_timestamp() - interval '6 days'), 1, 'VIP', 'Veillonella, J.', 0, 0
);

/* INSERT QUERY NO: 5 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DS_GENDER, DT_BIRTHDATE, DS_PRIMARY_DIAGNOSIS, QT_TIME_TELEMETRY, DS_DNR_STATUS, DS_CURRENT_LOCATION, DT_ENTRANCE, CD_CLASSIFICATION, DS_CLASSIFICATION, DS_SERVICE_LINE, QT_YELLOW_ALARMS, QT_RED_ALARMS)
VALUES (
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 60004, 3423721, 1020627604, 'Marquez, S.', 'Indefinido', to_date('08/01/1947 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), '', 11433, '', 'Berçário Atenção Primária', (clock_timestamp() - interval '6 days'), 1, 'VIP', 'Cassia, R.', 0, 0
);

-------------------------------------------------- pfcs_detail_bed --------------------------------------------------
/* INSERT QUERY NO: 1 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, CD_DEPARTMENT, DS_DEPARTMENT, DS_LOCATION)
VALUES (
nextval('pfcs_detail_bed_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 60000, 20, 'Bloco Executivo', 'ALF01'
);

/* INSERT QUERY NO: 2 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, CD_DEPARTMENT, DS_DEPARTMENT, DS_LOCATION)
VALUES (
nextval('pfcs_detail_bed_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 60001, 21, 'Surgical', 'ALF02'
);

/* INSERT QUERY NO: 3 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, CD_DEPARTMENT, DS_DEPARTMENT, DS_LOCATION)
VALUES (
nextval('pfcs_detail_bed_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 60002, 22, 'Surgical', 'ALF03'
);

/* INSERT QUERY NO: 4 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, CD_DEPARTMENT, DS_DEPARTMENT, DS_LOCATION)
VALUES (
nextval('pfcs_detail_bed_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 60003, 23, 'Intensive Care', 'ALF04'
);

/* INSERT QUERY NO: 5 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, CD_DEPARTMENT, DS_DEPARTMENT, DS_LOCATION)
VALUES (
nextval('pfcs_detail_bed_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 60004, 24, 'Pediatrics', 'ALF05'
);




-------------------------------------------------- pfcs_detail_device -----------------------------------------------
/* INSERT QUERY NO: 1 */

INSERT INTO pfcs_detail_device(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_EQUIPAMENTO, DS_DEVICE, NR_SEQ_DETAIL, IE_BATTERY_STATUS)
VALUES (
nextval('pfcs_detail_device_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 1501541292, 'Cloc-Tele_Test#1', 60000, 'empty'
);

/* INSERT QUERY NO: 2 */

INSERT INTO pfcs_detail_device(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_EQUIPAMENTO, DS_DEVICE, NR_SEQ_DETAIL, IE_BATTERY_STATUS)
VALUES (
nextval('pfcs_detail_device_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 1501541292, 'Cloc-Tele_Test#1', 60001, 'low'
);

/* INSERT QUERY NO: 3 */

INSERT INTO pfcs_detail_device(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_EQUIPAMENTO, DS_DEVICE, NR_SEQ_DETAIL, IE_BATTERY_STATUS)
VALUES (
nextval('pfcs_detail_device_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 1501541293, 'CLoc-Tele test#7', 60002, 'empty'
);

/* INSERT QUERY NO: 4 */

INSERT INTO pfcs_detail_device(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_EQUIPAMENTO, DS_DEVICE, NR_SEQ_DETAIL, IE_BATTERY_STATUS)
VALUES (
nextval('pfcs_detail_device_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 1501541292, 'Cloc-Tele_Test#1', 60003, 'empty'
);

/* INSERT QUERY NO: 5 */

INSERT INTO pfcs_detail_device(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_EQUIPAMENTO, DS_DEVICE, NR_SEQ_DETAIL, IE_BATTERY_STATUS)
VALUES (
nextval('pfcs_detail_device_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 1501541297, 'Telemetry Device 12', 60004, 'empty'
);

 := pfcs_pck.pfcs_generate_results(
		vl_indicator_p => 5, nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => cd_estabelecimento_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => pfcs_panel_seq_w);

CALL pfcs_pck.pfcs_update_detail(
		nr_seq_indicator_p => nr_seq_indicator_p,
		nr_seq_panel_p => pfcs_panel_seq_w,
		nr_seq_operational_level_p => cd_estabelecimento_w,
		nm_usuario_p => nm_usuario_p);

CALL pfcs_pck.pfcs_activate_records(
            nr_seq_indicator_p => nr_seq_indicator_p,
            nr_seq_operational_level_p => cd_estabelecimento_w,
            nm_usuario_p => nm_usuario_p);

cd_estabelecimento_w	:= pfcs_get_structure_level(cd_establishment_p => 39, ie_level_p => 'O', ie_info_p => 'C');

/* INSERT QUERY NO: 6 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
60005, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', 51, cd_estabelecimento_w
);

/* INSERT QUERY NO: 7 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
60006, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', 51, cd_estabelecimento_w
);

/* INSERT QUERY NO: 8 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
60007, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', 51, cd_estabelecimento_w
);

/* INSERT QUERY NO: 9 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
60008, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', 51, cd_estabelecimento_w
);

/* INSERT QUERY NO: 10 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
60009, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', 51, cd_estabelecimento_w
);

-------------------------------------------------- pfcs_detail_patient --------------------------------------------------		
/* INSERT QUERY NO: 6 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DS_GENDER, DT_BIRTHDATE, DS_PRIMARY_DIAGNOSIS, QT_TIME_TELEMETRY, DS_DNR_STATUS, DS_CURRENT_LOCATION, DT_ENTRANCE, CD_CLASSIFICATION, DS_CLASSIFICATION, DS_SERVICE_LINE, QT_YELLOW_ALARMS, QT_RED_ALARMS)
VALUES (
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 60005, 3423705, 1020627597, 'Packard, M.', 'Female', to_date('17/01/1987 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 'Frozen left arm', 11497, '', '', to_date('28/10/1990 19:00:00', 'DD/MM/YYYY HH24:MI:SS'), 2, 'Risco de queda', 'Cassia, R.', 0, 2
);

/* INSERT QUERY NO: 7 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DS_GENDER, DT_BIRTHDATE, DS_PRIMARY_DIAGNOSIS, QT_TIME_TELEMETRY, DS_DNR_STATUS, DS_CURRENT_LOCATION, DT_ENTRANCE, CD_CLASSIFICATION, DS_CLASSIFICATION, DS_SERVICE_LINE, QT_YELLOW_ALARMS, QT_RED_ALARMS)
VALUES (
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 60006, 3423709, 1020627598, 'Buffay, J.', 'Male', to_date('01/01/1997 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 'High Palpitation', 11497, '', '', to_date('13/10/1960 13:10:00', 'DD/MM/YYYY HH24:MI:SS'), 1, 'VIP', 'Cassia, R.', 1, 3
);

/* INSERT QUERY NO: 8 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DS_GENDER, DT_BIRTHDATE, DS_PRIMARY_DIAGNOSIS, QT_TIME_TELEMETRY, DS_DNR_STATUS, DS_CURRENT_LOCATION, DT_ENTRANCE, CD_CLASSIFICATION, DS_CLASSIFICATION, DS_SERVICE_LINE, QT_YELLOW_ALARMS, QT_RED_ALARMS)
VALUES (
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 60007, 21865, 1724108, 'DONHINI, Valdemar', 'Male', to_date('03/12/1998 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), '', 11495, '', '', to_date('16/07/1983 10:20:00', 'DD/MM/YYYY HH24:MI:SS'), 1, 'VIP', '', 0, 2
);

/* INSERT QUERY NO: 9 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DS_GENDER, DT_BIRTHDATE, DS_PRIMARY_DIAGNOSIS, QT_TIME_TELEMETRY, DS_DNR_STATUS, DS_CURRENT_LOCATION, DT_ENTRANCE, CD_CLASSIFICATION, DS_CLASSIFICATION, DS_SERVICE_LINE, QT_YELLOW_ALARMS, QT_RED_ALARMS)
VALUES (
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 60008, 3384621, 1015760350, 'CATARINA, Amanda', 'Female', to_date('06/06/2006 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), '', 11433, '', 'Cloc-Testwtasy', to_date('16/07/1983 13:20:00', 'DD/MM/YYYY HH24:MI:SS'), 2, 'Risco de queda', '', 0, 0
);

/* INSERT QUERY NO: 10 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DS_GENDER, DT_BIRTHDATE, DS_PRIMARY_DIAGNOSIS, QT_TIME_TELEMETRY, DS_DNR_STATUS, DS_CURRENT_LOCATION, DT_ENTRANCE, CD_CLASSIFICATION, DS_CLASSIFICATION, DS_SERVICE_LINE, QT_YELLOW_ALARMS, QT_RED_ALARMS)
VALUES (
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 60009, 48635, 863564, 'CHISTOPHER, MEGAN', 'Female', to_date('30/10/1985 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), '', 11433, '', 'Berçário Atenção Primária', to_date('23/05/2013 17:28:00', 'DD/MM/YYYY HH24:MI:SS'), 1, 'VIP', 'Bittencourt, O.', 0, 0
);

-------------------------------------------------- pfcs_detail_bed --------------------------------------------------
/* INSERT QUERY NO: 6 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, CD_DEPARTMENT, DS_DEPARTMENT, DS_LOCATION)
VALUES (
nextval('pfcs_detail_bed_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 60005, 25, 'PACU', 'ALF06'
);

/* INSERT QUERY NO: 7 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, CD_DEPARTMENT, DS_DEPARTMENT, DS_LOCATION)
VALUES (
nextval('pfcs_detail_bed_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 60006, 26, 'ED', 'ALF07'
);

/* INSERT QUERY NO: 8 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, CD_DEPARTMENT, DS_DEPARTMENT, DS_LOCATION)
VALUES (
nextval('pfcs_detail_bed_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 60007, 27, 'Stepdown', 'ALF08'
);

/* INSERT QUERY NO: 9 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, CD_DEPARTMENT, DS_DEPARTMENT, DS_LOCATION)
VALUES (
nextval('pfcs_detail_bed_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 60008, 28, 'Surgical', 'ALF09'
);

/* INSERT QUERY NO: 10 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, CD_DEPARTMENT, DS_DEPARTMENT, DS_LOCATION)
VALUES (
nextval('pfcs_detail_bed_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 60009, 29, 'ED', 'ALF10'
);





-------------------------------------------------- pfcs_detail_device -----------------------------------------------
/* INSERT QUERY NO: 6 */

INSERT INTO pfcs_detail_device(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_EQUIPAMENTO, DS_DEVICE, NR_SEQ_DETAIL, IE_BATTERY_STATUS)
VALUES (
nextval('pfcs_detail_device_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 1501541292, 'Cloc-Tele_Test#1', 60005, 'empty'
);

/* INSERT QUERY NO: 7 */

INSERT INTO pfcs_detail_device(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_EQUIPAMENTO, DS_DEVICE, NR_SEQ_DETAIL, IE_BATTERY_STATUS)
VALUES (
nextval('pfcs_detail_device_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 1501541299, 'Teledevice#35', 60006, 'low'
);

/* INSERT QUERY NO: 8 */

INSERT INTO pfcs_detail_device(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_EQUIPAMENTO, DS_DEVICE, NR_SEQ_DETAIL, IE_BATTERY_STATUS)
VALUES (
nextval('pfcs_detail_device_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 1501541288, 'Teledevice#3', 60007, 'low'
);

/* INSERT QUERY NO: 9 */

INSERT INTO pfcs_detail_device(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_EQUIPAMENTO, DS_DEVICE, NR_SEQ_DETAIL, IE_BATTERY_STATUS)
VALUES (
nextval('pfcs_detail_device_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 1501541297, 'Telemetry Device 12', 60008, 'empty'
);

/* INSERT QUERY NO: 10 */

INSERT INTO pfcs_detail_device(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_EQUIPAMENTO, DS_DEVICE, NR_SEQ_DETAIL, IE_BATTERY_STATUS)
VALUES (
nextval('pfcs_detail_device_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 1501541292, 'Cloc-Tele_Test#1', 60009, 'empty'
);

 := pfcs_pck.pfcs_generate_results(
		vl_indicator_p => 5, nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => cd_estabelecimento_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => pfcs_panel_seq_w);

CALL pfcs_pck.pfcs_update_detail(
		nr_seq_indicator_p => nr_seq_indicator_p,
		nr_seq_panel_p => pfcs_panel_seq_w,
		nr_seq_operational_level_p => cd_estabelecimento_w,
		nm_usuario_p => nm_usuario_p);

CALL pfcs_pck.pfcs_activate_records(
            nr_seq_indicator_p => nr_seq_indicator_p,
            nr_seq_operational_level_p => cd_estabelecimento_w,
            nm_usuario_p => nm_usuario_p);


cd_estabelecimento_w	:= pfcs_get_structure_level(cd_establishment_p => 11, ie_level_p => 'O', ie_info_p => 'C');

/* INSERT QUERY NO: 11 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
60010, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', 51, cd_estabelecimento_w
);

/* INSERT QUERY NO: 12 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
60011, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', 51, cd_estabelecimento_w
);

/* INSERT QUERY NO: 13 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
60012, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', 51, cd_estabelecimento_w
);

/* INSERT QUERY NO: 14 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
60013, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', 51, cd_estabelecimento_w
);

-------------------------------------------------- pfcs_detail_patient --------------------------------------------------		
/* INSERT QUERY NO: 11 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DS_GENDER, DT_BIRTHDATE, DS_PRIMARY_DIAGNOSIS, QT_TIME_TELEMETRY, DS_DNR_STATUS, DS_CURRENT_LOCATION, DT_ENTRANCE, CD_CLASSIFICATION, DS_CLASSIFICATION, DS_SERVICE_LINE, QT_YELLOW_ALARMS, QT_RED_ALARMS)
VALUES (
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 60010, 3393724, 1015837423, 'DA CUNHA, Tania', 'Female', to_date('03/02/1989 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), '', 11499, '', 'Berçário Atenção Primária', to_date('04/01/2019 19:02:00', 'DD/MM/YYYY HH24:MI:SS'), 1, 'VIP', 'Veillonella, J.', 0, 0
);

/* INSERT QUERY NO: 12 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DS_GENDER, DT_BIRTHDATE, DS_PRIMARY_DIAGNOSIS, QT_TIME_TELEMETRY, DS_DNR_STATUS, DS_CURRENT_LOCATION, DT_ENTRANCE, CD_CLASSIFICATION, DS_CLASSIFICATION, DS_SERVICE_LINE, QT_YELLOW_ALARMS, QT_RED_ALARMS)
VALUES (
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 60011, 19924, 1724108, 'DONHINI, Valdemar', 'Male', to_date('06/02/1967 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), '', 11497, '', 'Cloc-Testwtasy', to_date('13/10/1960 19:39:00', 'DD/MM/YYYY HH24:MI:SS'), 1, 'VIP', '', 0, 0
);

/* INSERT QUERY NO: 13 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DS_GENDER, DT_BIRTHDATE, DS_PRIMARY_DIAGNOSIS, QT_TIME_TELEMETRY, DS_DNR_STATUS, DS_CURRENT_LOCATION, DT_ENTRANCE, CD_CLASSIFICATION, DS_CLASSIFICATION, DS_SERVICE_LINE, QT_YELLOW_ALARMS, QT_RED_ALARMS)
VALUES (
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 60012, 3382914, 5616267, 'ESTRELA, Patrick', 'Male', to_date('15/10/1964 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), '', 11495, '', '', to_date('13/03/2018 10:52:00', 'DD/MM/YYYY HH24:MI:SS'), 1, 'VIP', 'Cassia, R.', 2, 4
);

/* INSERT QUERY NO: 14 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DS_GENDER, DT_BIRTHDATE, DS_PRIMARY_DIAGNOSIS, QT_TIME_TELEMETRY, DS_DNR_STATUS, DS_CURRENT_LOCATION, DT_ENTRANCE, CD_CLASSIFICATION, DS_CLASSIFICATION, DS_SERVICE_LINE, QT_YELLOW_ALARMS, QT_RED_ALARMS)
VALUES (
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 60013, 3398169, 1015791861, 'FABRIS, Tamiris', 'Female', to_date('29/11/1989 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), '', 11433, '', 'Cloc-Testwtasy', to_date('16/04/2019 13:20:00', 'DD/MM/YYYY HH24:MI:SS'), 1, 'VIP', 'Cassia, R.', 0, 0
);

-------------------------------------------------- pfcs_detail_bed --------------------------------------------------
/* INSERT QUERY NO: 11 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, CD_DEPARTMENT, DS_DEPARTMENT, DS_LOCATION)
VALUES (
nextval('pfcs_detail_bed_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 60010, 30, 'Pediatrics', 'ALF11'
);

/* INSERT QUERY NO: 12 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, CD_DEPARTMENT, DS_DEPARTMENT, DS_LOCATION)
VALUES (
nextval('pfcs_detail_bed_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 60011, 31, 'PACU', 'ALF12'
);

/* INSERT QUERY NO: 13 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, CD_DEPARTMENT, DS_DEPARTMENT, DS_LOCATION)
VALUES (
nextval('pfcs_detail_bed_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 60012, 32, 'Medical', 'ALF13'
);

/* INSERT QUERY NO: 14 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, CD_DEPARTMENT, DS_DEPARTMENT, DS_LOCATION)
VALUES (
nextval('pfcs_detail_bed_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 60013, 33, 'Medical', 'ALF14'
);






-------------------------------------------------- pfcs_detail_device -----------------------------------------------
/* INSERT QUERY NO: 11 */

INSERT INTO pfcs_detail_device(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_EQUIPAMENTO, DS_DEVICE, NR_SEQ_DETAIL, IE_BATTERY_STATUS)
VALUES (
nextval('pfcs_detail_device_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 1501541294, 'tele-device#9', 60010, 'low'
);

/* INSERT QUERY NO: 12 */

INSERT INTO pfcs_detail_device(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_EQUIPAMENTO, DS_DEVICE, NR_SEQ_DETAIL, IE_BATTERY_STATUS)
VALUES (
nextval('pfcs_detail_device_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 1501541297, 'Telemetry Device 12', 60011, 'empty'
);

/* INSERT QUERY NO: 13 */

INSERT INTO pfcs_detail_device(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_EQUIPAMENTO, DS_DEVICE, NR_SEQ_DETAIL, IE_BATTERY_STATUS)
VALUES (
nextval('pfcs_detail_device_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 1501541297, 'Telemetry Device 12', 60012, 'empty'
);

/* INSERT QUERY NO: 14 */

INSERT INTO pfcs_detail_device(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_EQUIPAMENTO, DS_DEVICE, NR_SEQ_DETAIL, IE_BATTERY_STATUS)
VALUES (
nextval('pfcs_detail_device_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 1501541293, 'CLoc-Tele test#7', 60013, 'low'
);

 := pfcs_pck.pfcs_generate_results(
		vl_indicator_p => 4, nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => cd_estabelecimento_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => pfcs_panel_seq_w);

CALL pfcs_pck.pfcs_update_detail(
		nr_seq_indicator_p => nr_seq_indicator_p,
		nr_seq_panel_p => pfcs_panel_seq_w,
		nr_seq_operational_level_p => cd_estabelecimento_w,
		nm_usuario_p => nm_usuario_p);

CALL pfcs_pck.pfcs_activate_records(
            nr_seq_indicator_p => nr_seq_indicator_p,
            nr_seq_operational_level_p => cd_estabelecimento_w,
            nm_usuario_p => nm_usuario_p);
commit;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_generate_10_tl (nr_seq_indicator_p bigint) FROM PUBLIC;

