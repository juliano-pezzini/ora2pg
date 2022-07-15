-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_delete_fr12_pa (nr_seq_indicator_p bigint) AS $body$
DECLARE


pfcs_panel_seq_w			pfcs_panel.nr_sequencia%type;
cd_estabelecimento_w			bigint;
nm_usuario_p 				varchar(20);


BEGIN
CALL pfcs_generate_fr12_pa(nr_seq_indicator_p);
nm_usuario_p := 'asimovbr';
cd_estabelecimento_w	:= pfcs_get_structure_level(cd_establishment_p => 1, ie_level_p => 'O', ie_info_p => 'C');

DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 11001;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 11001;

DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 11003;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 11003;

DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 11008;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 11008;

DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 11016;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 11016;

UPDATE PFCS_PANEL SET VL_INDICATOR = 16 WHERE NR_SEQ_INDICATOR = nr_seq_indicator_p and nr_seq_operational_level = cd_estabelecimento_w;
UPDATE PFCS_PANEL SET VL_INDICATOR_AUX = 36 WHERE NR_SEQ_INDICATOR = nr_seq_indicator_p and nr_seq_operational_level = cd_estabelecimento_w;

cd_estabelecimento_w	:= pfcs_get_structure_level(cd_establishment_p => 39, ie_level_p => 'O', ie_info_p => 'C');

DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 11027;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 11027;

DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 11028;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 11028;

DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 11034;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 11034;

DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 11035;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 11035;

DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 11038;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 11038;

UPDATE PFCS_PANEL SET VL_INDICATOR = 16 WHERE NR_SEQ_INDICATOR = nr_seq_indicator_p and nr_seq_operational_level = cd_estabelecimento_w;
UPDATE PFCS_PANEL SET VL_INDICATOR_AUX = 29 WHERE NR_SEQ_INDICATOR = nr_seq_indicator_p and nr_seq_operational_level = cd_estabelecimento_w;

cd_estabelecimento_w	:= pfcs_get_structure_level(cd_establishment_p => 11, ie_level_p => 'O', ie_info_p => 'C');

DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 11040;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 11040;

DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 11043;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 11043;

UPDATE PFCS_PANEL SET VL_INDICATOR = 2 WHERE NR_SEQ_INDICATOR = nr_seq_indicator_p and nr_seq_operational_level = cd_estabelecimento_w;
UPDATE PFCS_PANEL SET VL_INDICATOR_AUX = 5 WHERE NR_SEQ_INDICATOR = nr_seq_indicator_p and nr_seq_operational_level = cd_estabelecimento_w;
		
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_delete_fr12_pa (nr_seq_indicator_p bigint) FROM PUBLIC;

