-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_delete_5_tl (nr_seq_indicator_p bigint) AS $body$
DECLARE


pfcs_panel_seq_w				pfcs_panel.nr_sequencia%type;
cd_estabelecimento_w			bigint;
nm_usuario_p	varchar(20);


BEGIN
CALL pfcs_generate_5_tl(nr_seq_indicator_p);
nm_usuario_p := 'asimovbr';
cd_estabelecimento_w	:= pfcs_get_structure_level(cd_establishment_p => 1, ie_level_p => 'O', ie_info_p => 'C');


DELETE FROM pfcs_detail_bed WHERE NR_SEQ_DETAIL = 40003;
DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 40003;
DELETE FROM pfcs_detail_device WHERE NR_SEQ_DETAIL = 40003;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 40003;

DELETE FROM pfcs_detail_bed WHERE NR_SEQ_DETAIL = 40016;
DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 40016;
DELETE FROM pfcs_detail_device WHERE NR_SEQ_DETAIL = 40016;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 40016;

DELETE FROM pfcs_detail_bed WHERE NR_SEQ_DETAIL = 40026;
DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 40026;
DELETE FROM pfcs_detail_device WHERE NR_SEQ_DETAIL = 40026;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 40026;

DELETE FROM pfcs_detail_bed WHERE NR_SEQ_DETAIL = 40027;
DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 40027;
DELETE FROM pfcs_detail_device WHERE NR_SEQ_DETAIL = 40027;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 40027;

UPDATE PFCS_PANEL SET VL_INDICATOR = 27 WHERE NR_SEQ_INDICATOR = nr_seq_indicator_p and nr_seq_operational_level = cd_estabelecimento_w;

cd_estabelecimento_w	:= pfcs_get_structure_level(cd_establishment_p => 39, ie_level_p => 'O', ie_info_p => 'C');

DELETE FROM pfcs_detail_bed WHERE NR_SEQ_DETAIL = 40033;
DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 40033;
DELETE FROM pfcs_detail_device WHERE NR_SEQ_DETAIL = 40033;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 40033;

DELETE FROM pfcs_detail_bed WHERE NR_SEQ_DETAIL = 40037;
DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 40037;
DELETE FROM pfcs_detail_device WHERE NR_SEQ_DETAIL = 40037;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 40037;

DELETE FROM pfcs_detail_bed WHERE NR_SEQ_DETAIL = 40042;
DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 40042;
DELETE FROM pfcs_detail_device WHERE NR_SEQ_DETAIL = 40042;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 40042;

DELETE FROM pfcs_detail_bed WHERE NR_SEQ_DETAIL = 40048;
DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 40048;
DELETE FROM pfcs_detail_device WHERE NR_SEQ_DETAIL = 40048;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 40048;

DELETE FROM pfcs_detail_bed WHERE NR_SEQ_DETAIL = 40049;
DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 40049;
DELETE FROM pfcs_detail_device WHERE NR_SEQ_DETAIL = 40049;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 40049;

UPDATE PFCS_PANEL SET VL_INDICATOR = 26 WHERE NR_SEQ_INDICATOR = nr_seq_indicator_p and nr_seq_operational_level = cd_estabelecimento_w;


cd_estabelecimento_w	:= pfcs_get_structure_level(cd_establishment_p => 11, ie_level_p => 'O', ie_info_p => 'C');

DELETE FROM pfcs_detail_bed WHERE NR_SEQ_DETAIL = 40073;
DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 40073;
DELETE FROM pfcs_detail_device WHERE NR_SEQ_DETAIL = 40073;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 40073;

DELETE FROM pfcs_detail_bed WHERE NR_SEQ_DETAIL = 40088;
DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 40088;
DELETE FROM pfcs_detail_device WHERE NR_SEQ_DETAIL = 40088;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 40088;

UPDATE PFCS_PANEL SET VL_INDICATOR = 28 WHERE NR_SEQ_INDICATOR = nr_seq_indicator_p and nr_seq_operational_level = cd_estabelecimento_w;

commit;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_delete_5_tl (nr_seq_indicator_p bigint) FROM PUBLIC;
