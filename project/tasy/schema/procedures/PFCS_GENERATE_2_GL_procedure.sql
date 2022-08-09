-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_generate_2_gl (nr_seq_indicator_p bigint) AS $body$
DECLARE


pfcs_panel_seq_w		pfcs_panel.nr_sequencia%type;
cd_estabelecimento_w		bigint;
nm_usuario_p			varchar(20);


BEGIN
DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL in (14000,14001,14002,14003,14004,14005);
DELETE FROM pfcs_detail_bed_request WHERE NR_SEQ_DETAIL in (14000,14001,14002,14003,14004,14005);
DELETE FROM pfcs_panel_detail WHERE NR_SEQ_INDICATOR = 19;
DELETE FROM pfcs_panel WHERE NR_SEQ_INDICATOR = 19;
nm_usuario_p := 'asimovbr';

cd_estabelecimento_w	:= pfcs_get_structure_level(cd_establishment_p => 1, ie_level_p => 'O', ie_info_p => 'C');

-------------------------------------------------- pfcs_panel_detail --------------------------------------------------
/* INSERT QUERY NO: 1 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
14000, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', 19, cd_estabelecimento_w
);

/* INSERT QUERY NO: 2 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
14001, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', 19, cd_estabelecimento_w
);

-------------------------------------------------- pfcs_detail_patient ------------------------------------------------		
/* INSERT QUERY NO: 1 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, ID_PATIENT, NM_PATIENT,CD_CLASSIFICATION, DS_CLASSIFICATION, DS_GENDER, DT_BIRTHDATE)
VALUES (
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 14000, 625741, 'CLAYMORE, Priscila', 1, 'ACO Groups', 'Female', TO_DATE('01/01/2020 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

/* INSERT QUERY NO: 2 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, ID_PATIENT, NM_PATIENT,CD_CLASSIFICATION, DS_CLASSIFICATION, DS_GENDER, DT_BIRTHDATE)
VALUES (
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 14001, 624611, 'STUART LITTLE, Petúnia Genoveva Abigail', 1, 'ACO Groups', 'Female', TO_DATE('26/06/1982 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

-------------------------------------------------- pfcs_detail_bed_request --------------------------------------------
/* INSERT QUERY NO: 1 */

INSERT INTO pfcs_detail_bed_request(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, DS_TYPE, DS_STATUS, DT_TIME_REQUEST, NR_SEQ_DETAIL)
VALUES (
nextval('pfcs_detail_bed_request_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 'Surgical', 'Waiting', clock_timestamp(), 14000
);

/* INSERT QUERY NO: 2 */

INSERT INTO pfcs_detail_bed_request(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, DS_TYPE, DS_STATUS, DT_TIME_REQUEST, NR_SEQ_DETAIL)
VALUES (
nextval('pfcs_detail_bed_request_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 'Oncology', 'Waiting', clock_timestamp(), 14001
);

 := pfcs_pck.pfcs_generate_results(
		vl_indicator_p => 2, ds_reference_value_p => 'ACO Groups', cd_reference_value_p => 1, nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => cd_estabelecimento_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => pfcs_panel_seq_w);

CALL pfcs_pck.pfcs_update_detail(
		nr_seq_indicator_p => nr_seq_indicator_p,
		nr_seq_panel_p => pfcs_panel_seq_w,
		nr_seq_operational_level_p => cd_estabelecimento_w,
		nm_usuario_p => nm_usuario_p);

-------------------------------------------------- pfcs_panel_detail --------------------------------------------------
/* INSERT QUERY NO: 3 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
14002, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', 19, cd_estabelecimento_w
);

-------------------------------------------------- pfcs_detail_patient ------------------------------------------------		
/* INSERT QUERY NO: 3 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, ID_PATIENT, NM_PATIENT,CD_CLASSIFICATION, DS_CLASSIFICATION, DS_GENDER, DT_BIRTHDATE)
VALUES (
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 14002, 2567995, 'BECKER, LOLITA', 2, 'VIP', 'Female',TO_DATE('23/10/1956 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

-------------------------------------------------- pfcs_detail_bed_request --------------------------------------------
/* INSERT QUERY NO: 3 */

INSERT INTO pfcs_detail_bed_request(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, DS_TYPE, DS_STATUS, DT_TIME_REQUEST, NR_SEQ_DETAIL)
VALUES (
nextval('pfcs_detail_bed_request_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 'Oncology', 'Waiting', clock_timestamp(), 14002
);
		
 := pfcs_pck.pfcs_generate_results(
		vl_indicator_p => 1, ds_reference_value_p => 'VIP', cd_reference_value_p => 2, nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => cd_estabelecimento_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => pfcs_panel_seq_w);

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

-------------------------------------------------- pfcs_panel_detail --------------------------------------------------
/* INSERT QUERY NO: 4 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
14003, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', 19, cd_estabelecimento_w
);

-------------------------------------------------- pfcs_detail_patient ------------------------------------------------		
/* INSERT QUERY NO: 4 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, ID_PATIENT, NM_PATIENT,CD_CLASSIFICATION, DS_CLASSIFICATION, DS_GENDER, DT_BIRTHDATE)
VALUES (
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 14003, 4580607, 'FELLER, Luiz', 2, 'VIP', 'Male',TO_DATE('14/03/1984 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

-------------------------------------------------- pfcs_detail_bed_request --------------------------------------------	
/* INSERT QUERY NO: 4 */

INSERT INTO pfcs_detail_bed_request(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, DS_TYPE, DS_STATUS, DT_TIME_REQUEST, NR_SEQ_DETAIL)
VALUES (
nextval('pfcs_detail_bed_request_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 'Oncology', 'Waiting', clock_timestamp(), 14003
);

 := pfcs_pck.pfcs_generate_results(
		vl_indicator_p => 1, ds_reference_value_p => 'VIP', cd_reference_value_p => 2, nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => cd_estabelecimento_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => pfcs_panel_seq_w);

CALL pfcs_pck.pfcs_update_detail(
		nr_seq_indicator_p => nr_seq_indicator_p,
		nr_seq_panel_p => pfcs_panel_seq_w,
		nr_seq_operational_level_p => cd_estabelecimento_w,
		nm_usuario_p => nm_usuario_p);
		
-------------------------------------------------- pfcs_panel_detail --------------------------------------------------
/* INSERT QUERY NO: 5 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
14004, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', 19, cd_estabelecimento_w
);

-------------------------------------------------- pfcs_detail_patient ------------------------------------------------		
/* INSERT QUERY NO: 5 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, ID_PATIENT, NM_PATIENT,CD_CLASSIFICATION, DS_CLASSIFICATION, DS_GENDER, DT_BIRTHDATE)
VALUES (
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 14004, 4770375, 'SOUZA, ASHLEY', 1, 'ACO Groups', 'Female', TO_DATE('03/03/1986 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

-------------------------------------------------- pfcs_detail_bed_request --------------------------------------------	
/* INSERT QUERY NO: 5 */

INSERT INTO pfcs_detail_bed_request(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, DS_TYPE, DS_STATUS, DT_TIME_REQUEST, NR_SEQ_DETAIL)
VALUES (
nextval('pfcs_detail_bed_request_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 'Oncology', 'Waiting', clock_timestamp(), 14004
);

 := pfcs_pck.pfcs_generate_results(
		vl_indicator_p => 1, ds_reference_value_p => 'ACO Groups', cd_reference_value_p => 1, nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => cd_estabelecimento_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => pfcs_panel_seq_w);

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

-------------------------------------------------- pfcs_panel_detail --------------------------------------------------
/* INSERT QUERY NO: 6 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
14005, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', 19, cd_estabelecimento_w
);

-------------------------------------------------- pfcs_detail_patient ------------------------------------------------		
/* INSERT QUERY NO: 6 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, ID_PATIENT, NM_PATIENT,CD_CLASSIFICATION, DS_CLASSIFICATION, DS_GENDER, DT_BIRTHDATE)
VALUES (
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 14005, 4836353, 'ALMEIDA, SHEILA', 1, 'ACO Groups', 'Female',TO_DATE('11/01/2010 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

-------------------------------------------------- pfcs_detail_bed_request --------------------------------------------		
/* INSERT QUERY NO: 6 */

INSERT INTO pfcs_detail_bed_request(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, DS_TYPE, DS_STATUS, DT_TIME_REQUEST, NR_SEQ_DETAIL)
VALUES (
nextval('pfcs_detail_bed_request_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 'Oncology', 'Waiting', clock_timestamp(), 14005
);

 := pfcs_pck.pfcs_generate_results(
		vl_indicator_p => 1, ds_reference_value_p => 'ACO Groups', cd_reference_value_p => 1, nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => cd_estabelecimento_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => pfcs_panel_seq_w);

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
-- REVOKE ALL ON PROCEDURE pfcs_generate_2_gl (nr_seq_indicator_p bigint) FROM PUBLIC;
