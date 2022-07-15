-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_generate_8_gl (nr_seq_indicator_p bigint) AS $body$
DECLARE


pfcs_panel_seq_w			pfcs_panel.nr_sequencia%type;
cd_estabelecimento_w			bigint;
nm_usuario_p				varchar(20);


BEGIN
DELETE FROM pfcs_detail_bed WHERE NR_SEQ_DETAIL in (20000,20001,20002,20003,20004,20005,20006,20007,20008,20009,20010,20011,20012,20013,20014,20015,20016,20017,20018);
DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL in (20000,20001,20002,20003,20004,20005,20006,20007,20008,20009,20010,20011,20012,20013,20014,20015,20016,20017,20018);
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA in (20000,20001,20002,20003,20004,20005,20006,20007,20008,20009,20010,20011,20012,20013,20014,20015,20016,20017,20018);
DELETE FROM pfcs_panel_detail WHERE NR_SEQ_INDICATOR = 25;
DELETE FROM pfcs_panel WHERE NR_SEQ_INDICATOR = 25;
nm_usuario_p := 'asimovbr';

cd_estabelecimento_w	:= pfcs_get_structure_level(cd_establishment_p => 1, ie_level_p => 'O', ie_info_p => 'C');

/* INSERT QUERY NO: 1 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
20000, nm_usuario_p, (clock_timestamp() - (2890/24/60)), nm_usuario_p, (clock_timestamp() - (2890/24/60)), 'T', 25, cd_estabelecimento_w
);

/* INSERT QUERY NO: 2 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
20001, nm_usuario_p, (clock_timestamp() - (2900/24/60)), nm_usuario_p, (clock_timestamp() - (2900/24/60)), 'T', 25, cd_estabelecimento_w
);

/* INSERT QUERY NO: 3 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
20002, nm_usuario_p, (clock_timestamp() - (2954/24/60)), nm_usuario_p, (clock_timestamp() - (2954/24/60)), 'T', 25, cd_estabelecimento_w
);

/* INSERT QUERY NO: 4 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
20003, nm_usuario_p, (clock_timestamp() - (2759/24/60)), nm_usuario_p, (clock_timestamp() - (2759/24/60)), 'T', 25, cd_estabelecimento_w
);

/* INSERT QUERY NO: 5 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
20004, nm_usuario_p, (clock_timestamp() - (2963/24/60)), nm_usuario_p, (clock_timestamp() - (2963/24/60)), 'T', 25, cd_estabelecimento_w
);

/* INSERT QUERY NO: 6 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
20005, nm_usuario_p, (clock_timestamp() - (3196/24/60)), nm_usuario_p, (clock_timestamp() - (3196/24/60)), 'T', 25, cd_estabelecimento_w
);

-------------------------------------------------- pfcs_detail_bed --------------------------------------------------		
/* INSERT QUERY NO: 1 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_DEPARTMENT, DS_DEPARTMENT, NR_SEQ_DETAIL, DT_ENTRY_UNIT)
VALUES
(
nextval('pfcs_detail_bed_seq'), (clock_timestamp() - (2890/24/60)), nm_usuario_p, (clock_timestamp() - (2890/24/60)), nm_usuario_p, 8, 'North Wing', 20000, (clock_timestamp() - (2890/24/60))
);

/* INSERT QUERY NO: 2 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_DEPARTMENT, DS_DEPARTMENT, NR_SEQ_DETAIL, DT_ENTRY_UNIT)
VALUES
(
nextval('pfcs_detail_bed_seq'), (clock_timestamp() - (2900/24/60)), nm_usuario_p, (clock_timestamp() - (2900/24/60)), nm_usuario_p, 8, 'North Wing', 20001, (clock_timestamp() - (2900/24/60))
);

/* INSERT QUERY NO: 3 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_DEPARTMENT, DS_DEPARTMENT, NR_SEQ_DETAIL, DT_ENTRY_UNIT)
VALUES
(
nextval('pfcs_detail_bed_seq'), (clock_timestamp() - (2954/24/60)), nm_usuario_p, (clock_timestamp() - (2954/24/60)), nm_usuario_p, 8, 'North Wing', 20002, (clock_timestamp() - (2954/24/60))
);

/* INSERT QUERY NO: 4 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_DEPARTMENT, DS_DEPARTMENT, NR_SEQ_DETAIL, DT_ENTRY_UNIT)
VALUES
(
nextval('pfcs_detail_bed_seq'), (clock_timestamp() - (2759/24/60)), nm_usuario_p, (clock_timestamp() - (2759/24/60)), nm_usuario_p, 8, 'North Wing', 20003, (clock_timestamp() - (2759/24/60))
);

/* INSERT QUERY NO: 5 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_DEPARTMENT, DS_DEPARTMENT, NR_SEQ_DETAIL, DT_ENTRY_UNIT)
VALUES
(
nextval('pfcs_detail_bed_seq'), (clock_timestamp() - (2963/24/60)), nm_usuario_p, (clock_timestamp() - (2963/24/60)), nm_usuario_p, 8, 'North Wing', 20004, (clock_timestamp() - (2963/24/60))
);

/* INSERT QUERY NO: 6 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_DEPARTMENT, DS_DEPARTMENT, NR_SEQ_DETAIL, DT_ENTRY_UNIT)
VALUES
(
nextval('pfcs_detail_bed_seq'), (clock_timestamp() - (3196/24/60)), nm_usuario_p, (clock_timestamp() - (3196/24/60)), nm_usuario_p, 98791, 'South Wing', 20005, (clock_timestamp() - (3196/24/60))
);

-------------------------------------------------- pfcs_detail_patient --------------------------------------------------		
/* INSERT QUERY NO: 1 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DT_ENTRANCE, QT_TIME_TOTAL_HOSPITALIZATION, NR_SEQ_DETAIL, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE)
VALUES
(
nextval('pfcs_detail_patient_seq'), (clock_timestamp() - (2890/24/60)), nm_usuario_p, (clock_timestamp() - (2890/24/60)), nm_usuario_p, 3378611, 2574880, 'KLINKOSKI, JOÃO', (clock_timestamp() - (2890/24/60)), 2890, 20000, 'Male', 'ACO Groups', TO_DATE('23/11/1947 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

/* INSERT QUERY NO: 2 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DT_ENTRANCE, QT_TIME_TOTAL_HOSPITALIZATION, NR_SEQ_DETAIL, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE)
VALUES
(
nextval('pfcs_detail_patient_seq'), (clock_timestamp() - (2900/24/60)), nm_usuario_p, (clock_timestamp() - (2900/24/60)), nm_usuario_p, 3423758, 5229577, 'GOMES, BRUNA', (clock_timestamp() - (2900/24/60)), 2900, 20001, 'Female', 'VIP', TO_DATE('04/01/1965 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

/* INSERT QUERY NO: 3 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DT_ENTRANCE, QT_TIME_TOTAL_HOSPITALIZATION, NR_SEQ_DETAIL, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE)
VALUES
(
nextval('pfcs_detail_patient_seq'), (clock_timestamp() - (2954/24/60)), nm_usuario_p, (clock_timestamp() - (2954/24/60)), nm_usuario_p, 3397111, 555776, 'ROEDER, Francisco', (clock_timestamp() - (2954/24/60)), 2954, 20002, 'Male', 'VIP', TO_DATE('23/10/1956 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

/* INSERT QUERY NO: 4 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DT_ENTRANCE, QT_TIME_TOTAL_HOSPITALIZATION, NR_SEQ_DETAIL, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE)
VALUES
(
nextval('pfcs_detail_patient_seq'), (clock_timestamp() - (2759/24/60)), nm_usuario_p, (clock_timestamp() - (2759/24/60)), nm_usuario_p, 3397322, 1007661, 'CARDENUTO, CLAUDIO', (clock_timestamp() - (2759/24/60)), 2759, 20003, 'Male', 'ACO Groups', TO_DATE('14/03/1984 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

/* INSERT QUERY NO: 5 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DT_ENTRANCE, QT_TIME_TOTAL_HOSPITALIZATION, NR_SEQ_DETAIL, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE)
VALUES
(
nextval('pfcs_detail_patient_seq'), (clock_timestamp() - (2963/24/60)), nm_usuario_p, (clock_timestamp() - (2963/24/60)), nm_usuario_p, 3397260, 188810, 'FLORIANO, Jeniffer', (clock_timestamp() - (2963/24/60)), 2963, 20004, 'Female', 'ACO Groups', TO_DATE('03/03/1986 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

/* INSERT QUERY NO: 6 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DT_ENTRANCE, QT_TIME_TOTAL_HOSPITALIZATION, NR_SEQ_DETAIL, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE)
VALUES
(
nextval('pfcs_detail_patient_seq'), (clock_timestamp() - (3196/24/60)), nm_usuario_p, (clock_timestamp() - (3196/24/60)), nm_usuario_p, 3422615, 4790298, 'SILVA, ANIBAL', (clock_timestamp() - (3196/24/60)), 3196, 20005, 'Male', 'ACO Groups', TO_DATE('11/01/2010 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

 := pfcs_pck.pfcs_generate_results(
		vl_indicator_p => round(17662/6), nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => cd_estabelecimento_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => pfcs_panel_seq_w);

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

/* INSERT QUERY NO: 7 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
20006, nm_usuario_p, (clock_timestamp() - (2658/24/60)), nm_usuario_p, (clock_timestamp() - (2658/24/60)), 'T', 25, cd_estabelecimento_w
);

/* INSERT QUERY NO: 8 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
20007, nm_usuario_p, (clock_timestamp() - (2658/24/60)), nm_usuario_p, (clock_timestamp() - (2658/24/60)), 'T', 25, cd_estabelecimento_w
);

/* INSERT QUERY NO: 9 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
20008, nm_usuario_p, (clock_timestamp() - (2887/24/60)), nm_usuario_p, (clock_timestamp() - (2887/24/60)), 'T', 25, cd_estabelecimento_w
);

/* INSERT QUERY NO: 10 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
20009, nm_usuario_p, (clock_timestamp() - (2517/24/60)), nm_usuario_p, (clock_timestamp() - (2517/24/60)), 'T', 25, cd_estabelecimento_w
);

/* INSERT QUERY NO: 11 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
20010, nm_usuario_p, (clock_timestamp() - (3098/24/60)), nm_usuario_p, (clock_timestamp() - (3098/24/60)), 'T', 25, cd_estabelecimento_w
);

/* INSERT QUERY NO: 12 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
20011, nm_usuario_p, (clock_timestamp() - (2737/24/60)), nm_usuario_p, (clock_timestamp() - (2737/24/60)), 'T', 25, cd_estabelecimento_w
);

-------------------------------------------------- pfcs_detail_bed --------------------------------------------------	
/* INSERT QUERY NO: 7 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_DEPARTMENT, DS_DEPARTMENT, NR_SEQ_DETAIL, DT_ENTRY_UNIT)
VALUES
(
nextval('pfcs_detail_bed_seq'), (clock_timestamp() - (2658/24/60)), nm_usuario_p, (clock_timestamp() - (2658/24/60)), nm_usuario_p, 98791, 'South Wing', 20006, (clock_timestamp() - (2658/24/60))
);

/* INSERT QUERY NO: 8 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_DEPARTMENT, DS_DEPARTMENT, NR_SEQ_DETAIL, DT_ENTRY_UNIT)
VALUES
(
nextval('pfcs_detail_bed_seq'), (clock_timestamp() - (2658/24/60)), nm_usuario_p, (clock_timestamp() - (2658/24/60)), nm_usuario_p, 98791, 'South Wing', 20007, (clock_timestamp() - (2658/24/60))
);

/* INSERT QUERY NO: 9 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_DEPARTMENT, DS_DEPARTMENT, NR_SEQ_DETAIL, DT_ENTRY_UNIT)
VALUES
(
nextval('pfcs_detail_bed_seq'), (clock_timestamp() - (2887/24/60)), nm_usuario_p, (clock_timestamp() - (2887/24/60)), nm_usuario_p, 98791, 'South Wing', 20008, (clock_timestamp() - (2887/24/60))
);

/* INSERT QUERY NO: 10 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_DEPARTMENT, DS_DEPARTMENT, NR_SEQ_DETAIL, DT_ENTRY_UNIT)
VALUES
(
nextval('pfcs_detail_bed_seq'), (clock_timestamp() - (2517/24/60)), nm_usuario_p, (clock_timestamp() - (2517/24/60)), nm_usuario_p, 98791, 'South Wing', 20009, (clock_timestamp() - (2517/24/60))
);

/* INSERT QUERY NO: 11 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_DEPARTMENT, DS_DEPARTMENT, NR_SEQ_DETAIL, DT_ENTRY_UNIT)
VALUES
(
nextval('pfcs_detail_bed_seq'), (clock_timestamp() - (3098/24/60)), nm_usuario_p, (clock_timestamp() - (3098/24/60)), nm_usuario_p, 123, 'ICU', 20010, (clock_timestamp() - (3098/24/60))
);

/* INSERT QUERY NO: 12 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_DEPARTMENT, DS_DEPARTMENT, NR_SEQ_DETAIL, DT_ENTRY_UNIT)
VALUES
(
nextval('pfcs_detail_bed_seq'), (clock_timestamp() - (2737/24/60)), nm_usuario_p, (clock_timestamp() - (2737/24/60)), nm_usuario_p, 123, 'ICU', 20011, (clock_timestamp() - (2737/24/60))
);

-------------------------------------------------- pfcs_detail_patient --------------------------------------------------
/* INSERT QUERY NO: 7 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DT_ENTRANCE, QT_TIME_TOTAL_HOSPITALIZATION, NR_SEQ_DETAIL, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE)
VALUES
(
nextval('pfcs_detail_patient_seq'), (clock_timestamp() - (2658/24/60)), nm_usuario_p, (clock_timestamp() - (2658/24/60)), nm_usuario_p, 3422654, 58918, 'WELTER, Gertrudes', (clock_timestamp() - (2658/24/60)), 2658, 20006, 'Female', '', TO_DATE('25/11/1979 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

/* INSERT QUERY NO: 8 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DT_ENTRANCE, QT_TIME_TOTAL_HOSPITALIZATION, NR_SEQ_DETAIL, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE)
VALUES
(
nextval('pfcs_detail_patient_seq'), (clock_timestamp() - (2658/24/60)), nm_usuario_p, (clock_timestamp() - (2658/24/60)), nm_usuario_p, 3422604, 5227533, 'DONADONE, ANDREIA', (clock_timestamp() - (2658/24/60)), 2658, 20007, 'Female', '', TO_DATE('08/11/1983 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

/* INSERT QUERY NO: 9 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DT_ENTRANCE, QT_TIME_TOTAL_HOSPITALIZATION, NR_SEQ_DETAIL, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE)
VALUES
(
nextval('pfcs_detail_patient_seq'), (clock_timestamp() - (2887/24/60)), nm_usuario_p, (clock_timestamp() - (2887/24/60)), nm_usuario_p, 3422586, 65108, 'CASTRO, Gabriel', (clock_timestamp() - (2887/24/60)), 2887, 20008, 'Male', '', TO_DATE('03/05/1974 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

/* INSERT QUERY NO: 10 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DT_ENTRANCE, QT_TIME_TOTAL_HOSPITALIZATION, NR_SEQ_DETAIL, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE)
VALUES
(
nextval('pfcs_detail_patient_seq'), (clock_timestamp() - (2517/24/60)), nm_usuario_p, (clock_timestamp() - (2517/24/60)), nm_usuario_p, 3422578, 2475887, 'GERVASIO, JAIR', (clock_timestamp() - (2517/24/60)), 2517, 20009, 'Male', '', TO_DATE('29/09/2011 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

/* INSERT QUERY NO: 11 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DT_ENTRANCE, QT_TIME_TOTAL_HOSPITALIZATION, NR_SEQ_DETAIL, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE)
VALUES
(
nextval('pfcs_detail_patient_seq'), (clock_timestamp() - (3098/24/60)), nm_usuario_p, (clock_timestamp() - (3098/24/60)), nm_usuario_p, 3423652, 61558, 'FRANCENER, Reinaldo', (clock_timestamp() - (3098/24/60)), 3098, 20010, 'Male', '', TO_DATE('12/03/1987 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

/* INSERT QUERY NO: 12 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DT_ENTRANCE, QT_TIME_TOTAL_HOSPITALIZATION, NR_SEQ_DETAIL, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE)
VALUES
(
nextval('pfcs_detail_patient_seq'), (clock_timestamp() - (2737/24/60)), nm_usuario_p, (clock_timestamp() - (2737/24/60)), nm_usuario_p, 3423653, 61010, 'SCHUMMACHER, Reinaldo', (clock_timestamp() - (2737/24/60)), 2737, 20011, 'Male', '', TO_DATE('06/06/1982 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

 := pfcs_pck.pfcs_generate_results(
		vl_indicator_p => round(16555/6), nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => cd_estabelecimento_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => pfcs_panel_seq_w);

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

/* INSERT QUERY NO: 13 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
20012, nm_usuario_p, (clock_timestamp() - (2796/24/60)), nm_usuario_p, (clock_timestamp() - (2796/24/60)), 'T', 25, cd_estabelecimento_w
);

/* INSERT QUERY NO: 14 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
20013, nm_usuario_p, (clock_timestamp() - (2913/24/60)), nm_usuario_p, (clock_timestamp() - (2913/24/60)), 'T', 25, cd_estabelecimento_w
);

/* INSERT QUERY NO: 15 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
20014, nm_usuario_p, (clock_timestamp() - (3396/24/60)), nm_usuario_p, (clock_timestamp() - (3396/24/60)), 'T', 25, cd_estabelecimento_w
);

/* INSERT QUERY NO: 16 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
20015, nm_usuario_p, (clock_timestamp() - (2869/24/60)), nm_usuario_p, (clock_timestamp() - (2869/24/60)), 'T', 25, cd_estabelecimento_w
);

/* INSERT QUERY NO: 17 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
20016, nm_usuario_p, (clock_timestamp() - (2969/24/60)), nm_usuario_p, (clock_timestamp() - (2969/24/60)), 'T', 25, cd_estabelecimento_w
);

/* INSERT QUERY NO: 18 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
20017, nm_usuario_p, (clock_timestamp() - (3117/24/60)), nm_usuario_p, (clock_timestamp() - (3117/24/60)), 'T', 25, cd_estabelecimento_w
);

/* INSERT QUERY NO: 19 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
20018, nm_usuario_p, (clock_timestamp() - (2625/24/60)), nm_usuario_p, (clock_timestamp() - (2625/24/60)), 'T', 25, cd_estabelecimento_w
);

/* INSERT QUERY NO: 20 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
20019, nm_usuario_p, (clock_timestamp() - (2698/24/60)), nm_usuario_p, (clock_timestamp() - (2698/24/60)), 'T', 25, cd_estabelecimento_w
);

-------------------------------------------------- pfcs_detail_bed --------------------------------------------------	
/* INSERT QUERY NO: 13 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_DEPARTMENT, DS_DEPARTMENT, NR_SEQ_DETAIL, DT_ENTRY_UNIT)
VALUES
(
nextval('pfcs_detail_bed_seq'), (clock_timestamp() - (2796/24/60)), nm_usuario_p, (clock_timestamp() - (2796/24/60)), nm_usuario_p, 123, 'ICU', 20012, (clock_timestamp() - (2796/24/60))
);

/* INSERT QUERY NO: 14 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_DEPARTMENT, DS_DEPARTMENT, NR_SEQ_DETAIL, DT_ENTRY_UNIT)
VALUES
(
nextval('pfcs_detail_bed_seq'), (clock_timestamp() - (2913/24/60)), nm_usuario_p, (clock_timestamp() - (2913/24/60)), nm_usuario_p, 123, 'ICU', 20013, (clock_timestamp() - (2913/24/60))
);

/* INSERT QUERY NO: 15 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_DEPARTMENT, DS_DEPARTMENT, NR_SEQ_DETAIL, DT_ENTRY_UNIT)
VALUES
(
nextval('pfcs_detail_bed_seq'), (clock_timestamp() - (3396/24/60)), nm_usuario_p, (clock_timestamp() - (3396/24/60)), nm_usuario_p, 123, 'ICU', 20014, (clock_timestamp() - (3396/24/60))
);

/* INSERT QUERY NO: 16 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_DEPARTMENT, DS_DEPARTMENT, NR_SEQ_DETAIL, DT_ENTRY_UNIT)
VALUES
(
nextval('pfcs_detail_bed_seq'), (clock_timestamp() - (2869/24/60)), nm_usuario_p, (clock_timestamp() - (2869/24/60)), nm_usuario_p, 123, 'ICU', 20015, (clock_timestamp() - (2869/24/60))
);

/* INSERT QUERY NO: 17 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_DEPARTMENT, DS_DEPARTMENT, NR_SEQ_DETAIL, DT_ENTRY_UNIT)
VALUES
(
nextval('pfcs_detail_bed_seq'), (clock_timestamp() - (2969/24/60)), nm_usuario_p, (clock_timestamp() - (2969/24/60)), nm_usuario_p, 123, 'ICU', 20016, (clock_timestamp() - (2969/24/60))
);

/* INSERT QUERY NO: 18 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_DEPARTMENT, DS_DEPARTMENT, NR_SEQ_DETAIL, DT_ENTRY_UNIT)
VALUES
(
nextval('pfcs_detail_bed_seq'), (clock_timestamp() - (3117/24/60)), nm_usuario_p, (clock_timestamp() - (3117/24/60)), nm_usuario_p, 79415, 'East Wing', 20017, (clock_timestamp() - (3117/24/60))
);

/* INSERT QUERY NO: 19 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_DEPARTMENT, DS_DEPARTMENT, NR_SEQ_DETAIL, DT_ENTRY_UNIT)
VALUES
(
nextval('pfcs_detail_bed_seq'), (clock_timestamp() - (2625/24/60)), nm_usuario_p, (clock_timestamp() - (2625/24/60)), nm_usuario_p, 79415, 'East Wing', 20018, (clock_timestamp() - (2625/24/60))
);

/* INSERT QUERY NO: 20 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_DEPARTMENT, DS_DEPARTMENT, NR_SEQ_DETAIL, DT_ENTRY_UNIT)
VALUES
(
nextval('pfcs_detail_bed_seq'), (clock_timestamp() - (2698/24/60)), nm_usuario_p, (clock_timestamp() - (2698/24/60)), nm_usuario_p, 79415, 'East Wing', 20019, (clock_timestamp() - (2698/24/60))
);

-------------------------------------------------- pfcs_detail_patient --------------------------------------------------
/* INSERT QUERY NO: 13 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DT_ENTRANCE, QT_TIME_TOTAL_HOSPITALIZATION, NR_SEQ_DETAIL, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE)
VALUES
(
nextval('pfcs_detail_patient_seq'), (clock_timestamp() - (2796/24/60)), nm_usuario_p, (clock_timestamp() - (2796/24/60)), nm_usuario_p, 3423599, 4975785, 'REZENDE, RERIVALDO', (clock_timestamp() - (2796/24/60)), 2796, 20012, 'Male', '', TO_DATE('08/06/1972 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

/* INSERT QUERY NO: 14 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DT_ENTRANCE, QT_TIME_TOTAL_HOSPITALIZATION, NR_SEQ_DETAIL, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE)
VALUES
(
nextval('pfcs_detail_patient_seq'), (clock_timestamp() - (2913/24/60)), nm_usuario_p, (clock_timestamp() - (2913/24/60)), nm_usuario_p, 3422584, 202674, 'GREUEL, Marcos', (clock_timestamp() - (2913/24/60)), 2913, 20013, 'Male', '', TO_DATE('01/10/1971 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

/* INSERT QUERY NO: 15 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DT_ENTRANCE, QT_TIME_TOTAL_HOSPITALIZATION, NR_SEQ_DETAIL, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE)
VALUES
(
nextval('pfcs_detail_patient_seq'), (clock_timestamp() - (3396/24/60)), nm_usuario_p, (clock_timestamp() - (3396/24/60)), nm_usuario_p, 3422673, 63226, 'BITTENCOURT, Karina', (clock_timestamp() - (3396/24/60)), 3396, 20014, 'Female', '', TO_DATE('06/10/1968 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

/* INSERT QUERY NO: 16 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DT_ENTRANCE, QT_TIME_TOTAL_HOSPITALIZATION, NR_SEQ_DETAIL, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE)
VALUES
(
nextval('pfcs_detail_patient_seq'), (clock_timestamp() - (2869/24/60)), nm_usuario_p, (clock_timestamp() - (2869/24/60)), nm_usuario_p, 3422602, 182940, 'RODRIGUES, Jose', (clock_timestamp() - (2869/24/60)), 2869, 20015, 'Male', '', TO_DATE('05/12/1998 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

/* INSERT QUERY NO: 17 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DT_ENTRANCE, QT_TIME_TOTAL_HOSPITALIZATION, NR_SEQ_DETAIL, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE)
VALUES
(
nextval('pfcs_detail_patient_seq'), (clock_timestamp() - (2969/24/60)), nm_usuario_p, (clock_timestamp() - (2969/24/60)), nm_usuario_p, 3422605, 5621584, 'FEIJÃO, Jefferson', (clock_timestamp() - (2969/24/60)), 2969, 20016, 'Male', '', TO_DATE('12/10/1978 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

/* INSERT QUERY NO: 18 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DT_ENTRANCE, QT_TIME_TOTAL_HOSPITALIZATION, NR_SEQ_DETAIL, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE)
VALUES
(
nextval('pfcs_detail_patient_seq'), (clock_timestamp() - (3117/24/60)), nm_usuario_p, (clock_timestamp() - (3117/24/60)), nm_usuario_p, 3422659, 1627300, 'CARNEIRO, JÚLIO', (clock_timestamp() - (3117/24/60)), 3117, 20017, 'Male', '', TO_DATE('20/05/2001 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

/* INSERT QUERY NO: 19 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DT_ENTRANCE, QT_TIME_TOTAL_HOSPITALIZATION, NR_SEQ_DETAIL, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE)
VALUES
(
nextval('pfcs_detail_patient_seq'), (clock_timestamp() - (2625/24/60)), nm_usuario_p, (clock_timestamp() - (2625/24/60)), nm_usuario_p, 3422648, 4746211, 'MELO, RUBINALDO', (clock_timestamp() - (2625/24/60)), 2625, 20018, 'Male', '', TO_DATE('28/01/1943 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

/* INSERT QUERY NO: 20 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, NR_ENCOUNTER, ID_PATIENT, NM_PATIENT, DT_ENTRANCE, QT_TIME_TOTAL_HOSPITALIZATION, NR_SEQ_DETAIL, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE)
VALUES
(
nextval('pfcs_detail_patient_seq'), (clock_timestamp() - (2698/24/60)), nm_usuario_p, (clock_timestamp() - (2698/24/60)), nm_usuario_p, 3363225, 543164, 'VAZ, Josmar', (clock_timestamp() - (2698/24/60)), 2698, 20019, 'Male', '', TO_DATE('01/06/1989 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

 := pfcs_pck.pfcs_generate_results(
		vl_indicator_p => round(23383/8), nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => cd_estabelecimento_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => pfcs_panel_seq_w);

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
-- REVOKE ALL ON PROCEDURE pfcs_generate_8_gl (nr_seq_indicator_p bigint) FROM PUBLIC;

