-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_generate_fr6_pa (nr_seq_indicator_p bigint) AS $body$
DECLARE


pfcs_panel_seq_w			pfcs_panel.nr_sequencia%type;
cd_estabelecimento_w			bigint;
nm_usuario_p 				varchar(20);


BEGIN

nm_usuario_p := 'asimovbr';
cd_estabelecimento_w	:= pfcs_get_structure_level(cd_establishment_p => 1, ie_level_p => 'O', ie_info_p => 'C');

DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL in (5000,5001,5002,5003,5004,5005,5006,5007,5008,5009,5010,5011,5012,5013,5014,5015,5016,5017,5018,5019,5020,5021,5022,5023,5024,5025,5026,5027,5028,5029);
DELETE FROM pfcs_panel_detail WHERE NR_SEQ_INDICATOR = 10;
DELETE FROM pfcs_panel WHERE NR_SEQ_INDICATOR = 10;

/* INSERT QUERY NO: 1 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5000, nm_usuario_p, (clock_timestamp() - (162/24/60)), nm_usuario_p, (clock_timestamp() - (162/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 2 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5001, nm_usuario_p, (clock_timestamp() - (165/24/60)), nm_usuario_p, (clock_timestamp() - (165/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 3 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5002, nm_usuario_p, (clock_timestamp() - (166/24/60)), nm_usuario_p, (clock_timestamp() - (166/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 4 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5003, nm_usuario_p, (clock_timestamp() - (169/24/60)), nm_usuario_p, (clock_timestamp() - (169/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 5 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5004, nm_usuario_p, (clock_timestamp() - (162/24/60)), nm_usuario_p, (clock_timestamp() - (162/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 6 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5005, nm_usuario_p, (clock_timestamp() - (161/24/60)), nm_usuario_p, (clock_timestamp() - (161/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 7 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5006, nm_usuario_p, (clock_timestamp() - (167/24/60)), nm_usuario_p, (clock_timestamp() - (167/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 8 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5007, nm_usuario_p, (clock_timestamp() - (163/24/60)), nm_usuario_p, (clock_timestamp() - (163/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 9 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5008, nm_usuario_p, (clock_timestamp() - (164/24/60)), nm_usuario_p, (clock_timestamp() - (164/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 10 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5009, nm_usuario_p, (clock_timestamp() - (175/24/60)), nm_usuario_p, (clock_timestamp() - (175/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 1 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (162/24/60)), nm_usuario_p, (clock_timestamp() - (162/24/60)), 5000, 3422586, (clock_timestamp() - (162/24/60)), 65108, 'CASTRO, Gabriel', 'Male', 'VIP', to_date('01/01/1980 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 28, 'Emergency Department 02', 'Chair 16', 5, 'N'
);

/* INSERT QUERY NO: 2 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (165/24/60)), nm_usuario_p, (clock_timestamp() - (165/24/60)), 5001, 3422584, (clock_timestamp() - (165/24/60)), 202674, 'GREUEL, Marcos', 'Male', 'VIP', to_date('18/10/1964 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 28, 'Emergency Department 02', 'Chair 17', 15, 'N'
);

/* INSERT QUERY NO: 3 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (166/24/60)), nm_usuario_p, (clock_timestamp() - (166/24/60)), 5002, 3422392, (clock_timestamp() - (166/24/60)), 1445815, 'ABREU, Celio', 'Male', 'VIP', to_date('28/12/1960 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 28, 'Emergency Department 02', 'Chair 18', 18, 'N'
);

/* INSERT QUERY NO: 4 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (169/24/60)), nm_usuario_p, (clock_timestamp() - (169/24/60)), 5003, 3422139, (clock_timestamp() - (169/24/60)), 556055, 'GOMES, Mauri', 'Male', 'VIP', to_date('10/11/2010 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 28, 'Emergency Department 02', 'Chair 19', 7, 'N'
);

/* INSERT QUERY NO: 5 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (162/24/60)), nm_usuario_p, (clock_timestamp() - (162/24/60)), 5004, 3421068, (clock_timestamp() - (162/24/60)), 1020626479, 'BOWIE, David', 'Male', 'VIP', to_date('08/01/1947 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 28, 'Emergency Department 02', 'Chair 20', 162, 'S'
);

/* INSERT QUERY NO: 6 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (161/24/60)), nm_usuario_p, (clock_timestamp() - (161/24/60)), 5005, 3412155, (clock_timestamp() - (161/24/60)), 5211668, 'SANDRES, Analine', 'Female', 'Admitis >8hrs', to_date('17/01/1987 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 28, 'Emergency Department 02', 'Chair 21', 161, 'S'
);

/* INSERT QUERY NO: 7 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (167/24/60)), nm_usuario_p, (clock_timestamp() - (167/24/60)), 5006, 3412647, (clock_timestamp() - (167/24/60)), 1020190353, 'RAMOS, Claudo', 'Male', 'Admitis >8hrs', to_date('01/01/1997 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 28, 'Emergency Department 02', 'Chair 22', 167, 'S'
);

/* INSERT QUERY NO: 8 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (163/24/60)), nm_usuario_p, (clock_timestamp() - (163/24/60)), 5007, 3403861, (clock_timestamp() - (163/24/60)), 540758, 'FONSECA, Guilherme', 'Male', 'Non-Admits >4hrs', to_date('03/12/1998 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 28, 'Emergency Department 02', 'Chair 23', 163, 'S'
);

/* INSERT QUERY NO: 9 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (164/24/60)), nm_usuario_p, (clock_timestamp() - (164/24/60)), 5008, 3420462, (clock_timestamp() - (164/24/60)), 203659, 'NEUMAIER, Roberta', 'Female', 'Non-Admits >4hrs', to_date('17/10/1980 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 28, 'Emergency Department 02', 'Chair 24', 164, 'S'
);

/* INSERT QUERY NO: 10 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (175/24/60)), nm_usuario_p, (clock_timestamp() - (175/24/60)), 5009, 3398443, (clock_timestamp() - (175/24/60)), 4580607, 'FELLER, Luiz Augusto', 'Male', 'Admitis >8hrs', to_date('14/03/1984 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 28, 'Emergency Department 02', 'Chair 25', 175, 'S'
);

 := pfcs_pck.pfcs_generate_results(
	vl_indicator_p => 6, vl_indicator_aux_p => 4, nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => cd_estabelecimento_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => pfcs_panel_seq_w);

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

/* INSERT QUERY NO: 11 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5010, nm_usuario_p, (clock_timestamp() - (171/24/60)), nm_usuario_p, (clock_timestamp() - (171/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 12 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5011, nm_usuario_p, (clock_timestamp() - (169/24/60)), nm_usuario_p, (clock_timestamp() - (169/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 13 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5012, nm_usuario_p, (clock_timestamp() - (174/24/60)), nm_usuario_p, (clock_timestamp() - (174/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 14 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5013, nm_usuario_p, (clock_timestamp() - (178/24/60)), nm_usuario_p, (clock_timestamp() - (178/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 15 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5014, nm_usuario_p, (clock_timestamp() - (172/24/60)), nm_usuario_p, (clock_timestamp() - (172/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 16 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5015, nm_usuario_p, (clock_timestamp() - (179/24/60)), nm_usuario_p, (clock_timestamp() - (179/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 17 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5016, nm_usuario_p, (clock_timestamp() - (185/24/60)), nm_usuario_p, (clock_timestamp() - (185/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 18 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5017, nm_usuario_p, (clock_timestamp() - (181/24/60)), nm_usuario_p, (clock_timestamp() - (181/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 19 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5018, nm_usuario_p, (clock_timestamp() - (189/24/60)), nm_usuario_p, (clock_timestamp() - (189/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 20 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5019, nm_usuario_p, (clock_timestamp() - (192/24/60)), nm_usuario_p, (clock_timestamp() - (192/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 11 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (171/24/60)), nm_usuario_p, (clock_timestamp() - (171/24/60)), 5010, 3420761, (clock_timestamp() - (171/24/60)), 1015782988, 'PIANGERS, Marcus', 'Male', 'Non-Admits >4hrs', to_date('01/01/1980 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 29, 'Emergency Department 03', 'Chair 26', 13, 'N'
);

/* INSERT QUERY NO: 12 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (169/24/60)), nm_usuario_p, (clock_timestamp() - (169/24/60)), 5011, 3420540, (clock_timestamp() - (169/24/60)), 2632618, 'AGOSTINI, Jessica', 'Female', 'Non-Admits >4hrs', to_date('20/07/1997 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 29, 'Emergency Department 03', 'Chair 27', 169, 'S'
);

/* INSERT QUERY NO: 13 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (174/24/60)), nm_usuario_p, (clock_timestamp() - (174/24/60)), 5012, 3420010, (clock_timestamp() - (174/24/60)), 1015803773, 'MANDAL, Jugal', 'Male', 'VIP', to_date('06/02/1967 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 29, 'Emergency Department 03', 'Chair 28', 174, 'S'
);

/* INSERT QUERY NO: 14 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (178/24/60)), nm_usuario_p, (clock_timestamp() - (178/24/60)), 5013, 3419420, (clock_timestamp() - (178/24/60)), 1020620793, 'SHELBY, Shrimp Nome do meio', 'Male', 'VIP', to_date('08/10/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 29, 'Emergency Department 03', 'Chair 29', 178, 'S'
);

/* INSERT QUERY NO: 15 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (172/24/60)), nm_usuario_p, (clock_timestamp() - (172/24/60)), 5014, 3365884, (clock_timestamp() - (172/24/60)), 1015784381, 'ARRUDA, Catarina', 'Female', 'Non-Admits >4hrs', to_date('20/09/2017 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 29, 'Emergency Department 03', 'Chair 30', 172, 'S'
);

/* INSERT QUERY NO: 16 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (179/24/60)), nm_usuario_p, (clock_timestamp() - (179/24/60)), 5015, 3399720, (clock_timestamp() - (179/24/60)), 1015758188, 'FUNES, Juan', 'Male', 'Non-Admits >4hrs', to_date('05/10/1965 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 29, 'Emergency Department 03', 'Chair 31', 179, 'S'
);

/* INSERT QUERY NO: 17 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (185/24/60)), nm_usuario_p, (clock_timestamp() - (185/24/60)), 5016, 3419187, (clock_timestamp() - (185/24/60)), 4580956, 'PEREIRA, Guilherme', 'Male', 'VIP', to_date('09/09/1992 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 29, 'Emergency Department 03', 'Chair 32', 185, 'S'
);

/* INSERT QUERY NO: 18 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (181/24/60)), nm_usuario_p, (clock_timestamp() - (181/24/60)), 5017, 3418081, (clock_timestamp() - (181/24/60)), 505043, 'AGUIAR, Amanda', 'Female', 'Non-Admits >4hrs', to_date('02/12/1996 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 29, 'Emergency Department 03', 'Chair 33', 181, 'S'
);

/* INSERT QUERY NO: 19 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (189/24/60)), nm_usuario_p, (clock_timestamp() - (189/24/60)), 5018, 3423698, (clock_timestamp() - (189/24/60)), 1020627384, 'PERSON, Diverse', 'Male', 'Non-Admits >4hrs', to_date('13/03/1984 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 29, 'Emergency Department 03', 'Chair 34', 189, 'S'
);

/* INSERT QUERY NO: 20 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (192/24/60)), nm_usuario_p, (clock_timestamp() - (192/24/60)), 5019, 3423653, (clock_timestamp() - (192/24/60)), 61010, 'SCHUMMACHER, Reinaldo', 'Male', 'Non-Admits >4hrs', to_date('06/01/1960 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 29, 'Emergency Department 03', 'Chair 35', 192, 'S'
);

 := pfcs_pck.pfcs_generate_results(
	vl_indicator_p => 9, vl_indicator_aux_p => 1, nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => cd_estabelecimento_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => pfcs_panel_seq_w);

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

/* INSERT QUERY NO: 21 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5020, nm_usuario_p, (clock_timestamp() - (185/24/60)), nm_usuario_p, (clock_timestamp() - (185/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 22 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5021, nm_usuario_p, (clock_timestamp() - (194/24/60)), nm_usuario_p, (clock_timestamp() - (194/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 23 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5022, nm_usuario_p, (clock_timestamp() - (187/24/60)), nm_usuario_p, (clock_timestamp() - (187/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 24 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5023, nm_usuario_p, (clock_timestamp() - (183/24/60)), nm_usuario_p, (clock_timestamp() - (183/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 25 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5024, nm_usuario_p, (clock_timestamp() - (196/24/60)), nm_usuario_p, (clock_timestamp() - (196/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 26 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5025, nm_usuario_p, (clock_timestamp() - (197/24/60)), nm_usuario_p, (clock_timestamp() - (197/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 27 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5026, nm_usuario_p, (clock_timestamp() - (198/24/60)), nm_usuario_p, (clock_timestamp() - (198/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 28 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5027, nm_usuario_p, (clock_timestamp() - (193/24/60)), nm_usuario_p, (clock_timestamp() - (193/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 29 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5028, nm_usuario_p, (clock_timestamp() - (191/24/60)), nm_usuario_p, (clock_timestamp() - (191/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 30 */

INSERT INTO pfcs_panel_detail(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, IE_SITUATION, NR_SEQ_INDICATOR, NR_SEQ_OPERATIONAL_LEVEL)
VALUES
(
5029, nm_usuario_p, (clock_timestamp() - (197/24/60)), nm_usuario_p, (clock_timestamp() - (197/24/60)), 'T', 10, cd_estabelecimento_w
);

/* INSERT QUERY NO: 21 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (185/24/60)), nm_usuario_p, (clock_timestamp() - (185/24/60)), 5020, 3423652, (clock_timestamp() - (185/24/60)), 61558, 'FRANCENER, Reinaldo', 'Male', 'Non-Admits >4hrs', to_date('03/10/1950 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 29, 'Emergency Department 03', 'Chair 36', 185, 'S'
);

/* INSERT QUERY NO: 22 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (194/24/60)), nm_usuario_p, (clock_timestamp() - (194/24/60)), 5021, 3423626, (clock_timestamp() - (194/24/60)), 1015838559, 'TECH, Teste', 'Male', 'Non-Admits >4hrs', to_date('15/01/1999 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 29, 'Emergency Department 03', 'Chair 37', 194, 'S'
);

/* INSERT QUERY NO: 23 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (187/24/60)), nm_usuario_p, (clock_timestamp() - (187/24/60)), 5022, 3365884, (clock_timestamp() - (187/24/60)), 1015784381, 'ARRUDA, Catarina', 'Female', 'Non-Admits >4hrs', to_date('20/09/2017 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 29, 'Emergency Department 03', 'Chair 38', 187, 'S'
);

/* INSERT QUERY NO: 24 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (183/24/60)), nm_usuario_p, (clock_timestamp() - (183/24/60)), 5023, 3423599, (clock_timestamp() - (183/24/60)), 4975785, 'REXENDE, Rerivaldo', 'Male', 'VIP', to_date('12/08/1950 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 29, 'Emergency Department 03', 'Chair 39', 183, 'S'
);

/* INSERT QUERY NO: 25 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (196/24/60)), nm_usuario_p, (clock_timestamp() - (196/24/60)), 5024, 3423492, (clock_timestamp() - (196/24/60)), 1020101093, 'MALINOWSKI, Anna Teresa', 'Female', 'VIP', to_date('06/10/1991 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 29, 'Emergency Department 03', 'Chair 40', 196, 'S'
);

/* INSERT QUERY NO: 26 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (197/24/60)), nm_usuario_p, (clock_timestamp() - (197/24/60)), 5025, 3423491, (clock_timestamp() - (197/24/60)), 5501147, 'GOERTMANN, Felipe Souza', 'Male', 'VIP', to_date('27/08/1989 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 29, 'Emergency Department 03', 'Chair 41', 197, 'S'
);

/* INSERT QUERY NO: 27 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (198/24/60)), nm_usuario_p, (clock_timestamp() - (198/24/60)), 5026, 3423387, (clock_timestamp() - (198/24/60)), 1015771254, 'LUIZA, Fernanda', 'Female', 'VIP', to_date('05/12/1993 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 29, 'Emergency Department 03', 'Chair 42', 198, 'S'
);

/* INSERT QUERY NO: 28 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (193/24/60)), nm_usuario_p, (clock_timestamp() - (193/24/60)), 5027, 3423259, (clock_timestamp() - (193/24/60)), 1020190610, 'HALE, Elizabeth Meredith', 'Female', 'VIP', to_date('12/05/1998 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 29, 'Emergency Department 03', 'Chair 43', 193, 'S'
);

/* INSERT QUERY NO: 29 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (191/24/60)), nm_usuario_p, (clock_timestamp() - (191/24/60)), 5028, 3422605, (clock_timestamp() - (191/24/60)), 5621584, 'FEIJÃO, Jefferson', 'Male', 'VIP', to_date('01/06/1993 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 29, 'Emergency Department 03', 'Chair 44', 191, 'S'
);

/* INSERT QUERY NO: 30 */

INSERT INTO pfcs_detail_patient(NR_SEQUENCIA, NM_USUARIO, DT_ATUALIZACAO, NM_USUARIO_NREC, DT_ATUALIZACAO_NREC, NR_SEQ_DETAIL, NR_ENCOUNTER, DT_ENTRANCE, ID_PATIENT, NM_PATIENT, DS_GENDER, DS_CLASSIFICATION, DT_BIRTHDATE, CD_GROUP_PA, DS_GROUP_PA, DS_UNIT_PA, QT_TIME_BOX_PA, IE_OVER_THRESHOLD)
VALUES
(
nextval('pfcs_detail_patient_seq'), nm_usuario_p, (clock_timestamp() - (197/24/60)), nm_usuario_p, (clock_timestamp() - (197/24/60)), 5029, 3422604, (clock_timestamp() - (197/24/60)), 5227533, 'DONADONE, Andreia', 'Female', 'VIP', to_date('25/02/1976 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 29, 'Emergency Department 03', 'Chair 45', 197, 'S'
);

 := pfcs_pck.pfcs_generate_results(
	vl_indicator_p => 10, vl_indicator_aux_p => 0, nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => cd_estabelecimento_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => pfcs_panel_seq_w);

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
-- REVOKE ALL ON PROCEDURE pfcs_generate_fr6_pa (nr_seq_indicator_p bigint) FROM PUBLIC;
