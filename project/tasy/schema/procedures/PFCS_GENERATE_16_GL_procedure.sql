-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_generate_16_gl (nr_seq_indicator_p bigint) AS $body$
DECLARE


pfcs_panel_seq_w    		pfcs_panel.nr_sequencia%type;
cd_estabelecimento_w    	bigint;
nm_usuario_p  			varchar(20);


BEGIN

DELETE FROM pfcs_detail_bed_request WHERE NR_SEQ_DETAIL in (28000,28001,28002,28003,28004,28005,28006);
DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL in (28000,28001,28002,28003,28004,28005,28006);
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA in (28000,28001,28002,28003,28004,28005,28006);
DELETE FROM PFCS_PANEL WHERE NR_SEQ_INDICATOR = 54;

nm_usuario_p := 'asimovbr';
cd_estabelecimento_w	:= pfcs_get_structure_level(cd_establishment_p => 1, ie_level_p => 'O', ie_info_p => 'C');

-------------------------------------------------- pfcs_panel_detail --------------------------------------------------
/* INSERT QUERY NO: 1 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
28000, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', 54, cd_estabelecimento_w
);

/* INSERT QUERY NO: 2 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
28001, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', 54, cd_estabelecimento_w
);

/* INSERT QUERY NO: 3 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
28002, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', 54, cd_estabelecimento_w
);

/* INSERT QUERY NO: 4 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
28003, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', 54, cd_estabelecimento_w
);

-------------------------------------------------- pfcs_detail_patient ------------------------------------------------
/* INSERT QUERY NO: 1 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE)
VALUES (
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 28000, 3392914, 'DEICHMANN, Jussara', 'Female', 'ACO Groups', TO_DATE('23/11/1947 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

/* INSERT QUERY NO: 2 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE)
VALUES (
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 28001, 3352682, 'TORRES, Carlos', 'Male', 'VIP', TO_DATE('04/01/1965 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

/* INSERT QUERY NO: 3 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE)
VALUES (
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 28002, 3379297, 'LATERZA, Henry', 'Female', 'VIP', TO_DATE('23/10/1956 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

/* INSERT QUERY NO: 4 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE)
VALUES (
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 28003, 3419214, 'PREREIRA, Guilherme', 'Male', 'VIP', TO_DATE('14/03/1984 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

-------------------------------------------------- pfcs_detail_bed_request --------------------------------------------
/* INSERT QUERY NO: 1 */

INSERT INTO pfcs_detail_bed_request(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, DT_TIME_REQUEST, DS_STATUS, DS_TYPE, CD_STATUS, CD_TYPE)
VALUES
(
nextval('pfcs_detail_bed_request_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 28000, (clock_timestamp() - (162/24/60)), 'Waiting ', 'Clinic', 'A', 'C'
);

/* INSERT QUERY NO: 2 */

INSERT INTO pfcs_detail_bed_request(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, DT_TIME_REQUEST, DS_STATUS, DS_TYPE, CD_STATUS, CD_TYPE)
VALUES
(
nextval('pfcs_detail_bed_request_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 28001, (clock_timestamp() - (192/24/60)), 'Waiting ', 'Obstetrics', 'A', 'O'
);

/* INSERT QUERY NO: 3 */

INSERT INTO pfcs_detail_bed_request(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, DT_TIME_REQUEST, DS_STATUS, DS_TYPE, CD_STATUS, CD_TYPE)
VALUES
(
nextval('pfcs_detail_bed_request_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 28002, (clock_timestamp() - (300/24/60)), 'Waiting ', 'Obstetrics', 'A', 'O'
);

/* INSERT QUERY NO: 4 */

INSERT INTO pfcs_detail_bed_request(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, DT_TIME_REQUEST, DS_STATUS, DS_TYPE, CD_STATUS, CD_TYPE)
VALUES
(
nextval('pfcs_detail_bed_request_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 28003, (clock_timestamp() - (264/24/60)), 'Waiting ', 'Obstetrics', 'A', 'O'
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

cd_estabelecimento_w	:= pfcs_get_structure_level(cd_establishment_p => 39, ie_level_p => 'O', ie_info_p => 'C');

-------------------------------------------------- pfcs_panel_detail --------------------------------------------------
/* INSERT QUERY NO: 5 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
28004, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', 54, cd_estabelecimento_w
);

/* INSERT QUERY NO: 6 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
28005, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', 54, cd_estabelecimento_w
);

-------------------------------------------------- pfcs_detail_patient ------------------------------------------------
/* INSERT QUERY NO: 5 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE)
VALUES (
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 28004, 4770375, 'PHILIPS, Rosa', 'Female', 'ACO Groups', TO_DATE('22/07/2003 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

/* INSERT QUERY NO: 6 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE)
VALUES (
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 28005, 4836353, 'ESPINDOLA, Laura', 'Female', 'ACO Groups', TO_DATE('03/03/1986 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);

-------------------------------------------------- pfcs_detail_bed_request --------------------------------------------
/* INSERT QUERY NO: 5 */

INSERT INTO pfcs_detail_bed_request(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, DT_TIME_REQUEST, DS_STATUS, DS_TYPE, CD_STATUS, CD_TYPE)
VALUES
(
nextval('pfcs_detail_bed_request_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 28004, (clock_timestamp() - (120/24/60)), 'Awaiting Analysis ', 'Clinic', 'A', 'C'
);

/* INSERT QUERY NO: 6 */

INSERT INTO pfcs_detail_bed_request(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, DT_TIME_REQUEST, DS_STATUS, DS_TYPE, CD_STATUS, CD_TYPE)
VALUES
(
nextval('pfcs_detail_bed_request_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 28005, (clock_timestamp() - (329/24/60)), 'Waiting ', 'Surgical', 'A', 'CG'
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

-------------------------------------------------- pfcs_panel_detail --------------------------------------------------
/* INSERT QUERY NO: 7 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES (
28006, nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 'T', 54, cd_estabelecimento_w
);

-------------------------------------------------- pfcs_detail_patient ------------------------------------------------
/* INSERT QUERY NO: 7 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE)
VALUES (
nextval('pfcs_detail_patient_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 28006, 4976756, 'SEGUNDO, Fabio Vitorino', 'Male', 'ACO Groups', TO_DATE('11/01/2010 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
);


-------------------------------------------------- pfcs_detail_bed_request --------------------------------------------
/* INSERT QUERY NO: 7 */

INSERT INTO pfcs_detail_bed_request(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, DT_TIME_REQUEST, DS_STATUS, DS_TYPE, CD_STATUS, CD_TYPE)
VALUES
(
nextval('pfcs_detail_bed_request_seq'), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 28006, (clock_timestamp() - (401/24/60)), 'Waiting ', 'Surgical', 'A', 'CG'
);

 := pfcs_pck.pfcs_generate_results(
    vl_indicator_p => 1, nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => cd_estabelecimento_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => pfcs_panel_seq_w);

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
-- REVOKE ALL ON PROCEDURE pfcs_generate_16_gl (nr_seq_indicator_p bigint) FROM PUBLIC;

