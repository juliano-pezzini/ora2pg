-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_generate_11_gl (nr_seq_indicator_p bigint) AS $body$
DECLARE


pfcs_panel_seq_w				pfcs_panel.nr_sequencia%type;
cd_estabelecimento_w			bigint;
nm_usuario_p	varchar(20);


BEGIN

DELETE FROM pfcs_detail_bed WHERE NR_SEQ_DETAIL in (23001,23000,23002,23005,23003,23004);
DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL in (23001,23000,23002,23005,23003,23004);
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA in (23001,23000,23002,23005,23003,23004);
DELETE FROM pfcs_panel WHERE NR_SEQ_INDICATOR = 28;

nm_usuario_p := 'asimovbr';
cd_estabelecimento_w	:= pfcs_get_structure_level(cd_establishment_p => 1, ie_level_p => 'O', ie_info_p => 'C');

/* INSERT QUERY NO: 1 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
23000, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', 28, cd_estabelecimento_w
);

/* INSERT QUERY NO: 2 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
23001, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', 28, cd_estabelecimento_w
);

-------------------------------------------------- pfcs_detail_patient --------------------------------------------------
/* INSERT QUERY NO: 1 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, ID_PATIENT, NR_ENCOUNTER, NM_PATIENT, QT_TIME_AWAIT_AFTER_DISCHARGE, DT_ENTRANCE, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, IE_OVER_THRESHOLD, CD_REASON_DISCHARGE, DS_REASON_DISCHARGE)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 23000, 1015591754, 161071, 'GOMES, LUISA', 75, (clock_timestamp() - (163/24/60)), 'Female', 'VIP', (clock_timestamp() - (178/24/60)), 'S', 2, 'Administrative Discharge'
);

/* INSERT QUERY NO: 2 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, ID_PATIENT, NR_ENCOUNTER, NM_PATIENT, QT_TIME_AWAIT_AFTER_DISCHARGE, DT_ENTRANCE, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, IE_OVER_THRESHOLD, CD_REASON_DISCHARGE, DS_REASON_DISCHARGE)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 23001, 537984, 12402, 'GEUS, Lais', 30, (clock_timestamp() - (164/24/60)), 'Female', 'VIP', (clock_timestamp() - (172/24/60)), 'N', 2, 'Administrative Discharge'
);

-------------------------------------------------- pfcs_detail_bed --------------------------------------------------		
/* INSERT QUERY NO: 1 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_DEPARTMENT, DS_DEPARTMENT, NR_SEQ_DETAIL, DT_ENTRY_UNIT, DS_LOCATION)
VALUES
(
nextval('pfcs_detail_bed_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 8, 'North Wing', 23000, (clock_timestamp() - (2890/24/60)), 'QTO2 101'
);

/* INSERT QUERY NO: 2 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_DEPARTMENT, DS_DEPARTMENT, NR_SEQ_DETAIL, DT_ENTRY_UNIT, DS_LOCATION)
VALUES
(
nextval('pfcs_detail_bed_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 98791, 'South Wing', 23001, (clock_timestamp() - (3196/24/60)), 'QTO3 102'
);

 := pfcs_pck.pfcs_generate_results(
		vl_indicator_p => 2, nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => cd_estabelecimento_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => pfcs_panel_seq_w);

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

/* INSERT QUERY NO: 3 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
23002, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', 28, cd_estabelecimento_w
);

/* INSERT QUERY NO: 4 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
23003, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', 28, cd_estabelecimento_w
);

-------------------------------------------------- pfcs_detail_patient --------------------------------------------------		
/* INSERT QUERY NO: 3 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, ID_PATIENT, NR_ENCOUNTER, NM_PATIENT, QT_TIME_AWAIT_AFTER_DISCHARGE, DT_ENTRANCE, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, IE_OVER_THRESHOLD, CD_REASON_DISCHARGE, DS_REASON_DISCHARGE)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 23002, 875515, 11247, 'ALFACES, Zezinho', 45, (clock_timestamp() - (175/24/60)), 'Male', 'VIP', (clock_timestamp() - (179/24/60)), 'S', 4, 'Medical Discharge'
);

/* INSERT QUERY NO: 4 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, ID_PATIENT, NR_ENCOUNTER, NM_PATIENT, QT_TIME_AWAIT_AFTER_DISCHARGE, DT_ENTRANCE, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, IE_OVER_THRESHOLD, CD_REASON_DISCHARGE, DS_REASON_DISCHARGE)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 23003, 1538289, 11637, 'Rosa Philips', 98, (clock_timestamp() - (171/24/60)), 'Female', 'VIP', (clock_timestamp() - (185/24/60)), 'S', 4, 'Medical Discharge'
);

-------------------------------------------------- pfcs_detail_bed --------------------------------------------------
/* INSERT QUERY NO: 3 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_DEPARTMENT, DS_DEPARTMENT, NR_SEQ_DETAIL, DT_ENTRY_UNIT, DS_LOCATION)
VALUES
(
nextval('pfcs_detail_bed_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 123, 'ICU', 23002, (clock_timestamp() - (3098/24/60)), 'QTO4 103'
);

/* INSERT QUERY NO: 4 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_DEPARTMENT, DS_DEPARTMENT, NR_SEQ_DETAIL, DT_ENTRY_UNIT, DS_LOCATION)
VALUES
(
nextval('pfcs_detail_bed_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 123, 'ICU', 23003, (clock_timestamp() - (2737/24/60)), 'QTO5 104'
);

 := pfcs_pck.pfcs_generate_results(
		vl_indicator_p => 2, nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => cd_estabelecimento_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => pfcs_panel_seq_w);

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

/* INSERT QUERY NO: 5 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
23004, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', 28, cd_estabelecimento_w
);

/* INSERT QUERY NO: 6 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
23005, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', 28, cd_estabelecimento_w
);

-------------------------------------------------- pfcs_detail_patient --------------------------------------------------		
/* INSERT QUERY NO: 5 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, ID_PATIENT, NR_ENCOUNTER, NM_PATIENT, QT_TIME_AWAIT_AFTER_DISCHARGE, DT_ENTRANCE, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, IE_OVER_THRESHOLD, CD_REASON_DISCHARGE, DS_REASON_DISCHARGE)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 23004, 2416283, 9848, 'FILHO, JOÃO', 138, (clock_timestamp() - (169/24/60)), 'Male', 'VIP', (clock_timestamp() - (181/24/60)), 'S', 130, 'Normal Discharge'
);

/* INSERT QUERY NO: 6 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, ID_PATIENT, NR_ENCOUNTER, NM_PATIENT, QT_TIME_AWAIT_AFTER_DISCHARGE, DT_ENTRANCE, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, IE_OVER_THRESHOLD, CD_REASON_DISCHARGE, DS_REASON_DISCHARGE)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 23005, 5398099, 137978, 'GERALDO, ANAI', 68, (clock_timestamp() - (174/24/60)), 'Female', 'VIP', (clock_timestamp() - (189/24/60)), 'S', 130, 'Normal Discharge'
);

-------------------------------------------------- pfcs_detail_bed --------------------------------------------------
/* INSERT QUERY NO: 5 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_DEPARTMENT, DS_DEPARTMENT, NR_SEQ_DETAIL, DT_ENTRY_UNIT, DS_LOCATION)
VALUES
(
nextval('pfcs_detail_bed_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 123, 'ICU', 23004, (clock_timestamp() - (2796/24/60)), '141 B'
);

/* INSERT QUERY NO: 6 */

INSERT INTO pfcs_detail_bed(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_DEPARTMENT, DS_DEPARTMENT, NR_SEQ_DETAIL, DT_ENTRY_UNIT, DS_LOCATION)
VALUES
(
nextval('pfcs_detail_bed_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 79415, 'East Wing', 23005, (clock_timestamp() - (2625/24/60)), '142 B'
);

 := pfcs_pck.pfcs_generate_results(
		vl_indicator_p => 2, nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => cd_estabelecimento_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => pfcs_panel_seq_w);

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
-- REVOKE ALL ON PROCEDURE pfcs_generate_11_gl (nr_seq_indicator_p bigint) FROM PUBLIC;
