-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_delete_fr11_pa (nr_seq_indicator_p bigint) AS $body$
DECLARE


pfcs_panel_seq_w			pfcs_panel.nr_sequencia%type;
cd_estabelecimento_w			bigint;
nm_usuario_p 				varchar(20);


BEGIN
CALL pfcs_generate_fr11_pa(nr_seq_indicator_p);
nm_usuario_p := 'asimovbr';
cd_estabelecimento_w	:= pfcs_get_structure_level(cd_establishment_p => 1, ie_level_p => 'O', ie_info_p => 'C');

DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 10003;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 10003;

UPDATE PFCS_PANEL SET VL_INDICATOR = 4 WHERE NR_SEQ_INDICATOR = nr_seq_indicator_p and nr_seq_operational_level = cd_estabelecimento_w;
UPDATE PFCS_PANEL SET VL_INDICATOR_AUX = 28 WHERE NR_SEQ_INDICATOR = nr_seq_indicator_p and nr_seq_operational_level = cd_estabelecimento_w;

cd_estabelecimento_w	:= pfcs_get_structure_level(cd_establishment_p => 39, ie_level_p => 'O', ie_info_p => 'C');

DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 10005;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 10005;

UPDATE PFCS_PANEL SET VL_INDICATOR = 4 WHERE NR_SEQ_INDICATOR = nr_seq_indicator_p and nr_seq_operational_level = cd_estabelecimento_w;
UPDATE PFCS_PANEL SET VL_INDICATOR_AUX = 40 WHERE NR_SEQ_INDICATOR = nr_seq_indicator_p and nr_seq_operational_level = cd_estabelecimento_w;

cd_estabelecimento_w	:= pfcs_get_structure_level(cd_establishment_p => 11, ie_level_p => 'O', ie_info_p => 'C');

DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 10010;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 10010;

UPDATE PFCS_PANEL SET VL_INDICATOR = 0 WHERE NR_SEQ_INDICATOR = nr_seq_indicator_p and nr_seq_operational_level = cd_estabelecimento_w;
UPDATE PFCS_PANEL SET VL_INDICATOR_AUX = 5 WHERE NR_SEQ_INDICATOR = nr_seq_indicator_p and nr_seq_operational_level = cd_estabelecimento_w;

commit;	
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_delete_fr11_pa (nr_seq_indicator_p bigint) FROM PUBLIC;

