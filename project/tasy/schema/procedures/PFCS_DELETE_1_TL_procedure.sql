-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_delete_1_tl (nr_seq_indicator_p bigint) AS $body$
DECLARE


pfcs_panel_seq_w				pfcs_panel.nr_sequencia%type;
cd_estabelecimento_w			bigint;
nm_usuario_p	varchar(20);


BEGIN
CALL pfcs_generate_1_tl(nr_seq_indicator_p);
nm_usuario_p := 'asimovbr';
cd_estabelecimento_w	:= pfcs_get_structure_level(cd_establishment_p => 1, ie_level_p => 'O', ie_info_p => 'C');

DELETE FROM pfcs_detail_bed WHERE NR_SEQ_DETAIL = 30002;
DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 30002;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 30002;

DELETE FROM pfcs_detail_bed WHERE NR_SEQ_DETAIL = 30005;
DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 30005;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 30005;

UPDATE PFCS_PANEL SET VL_INDICATOR = 6 WHERE NR_SEQ_INDICATOR = nr_seq_indicator_p and nr_seq_operational_level = cd_estabelecimento_w;


cd_estabelecimento_w	:= pfcs_get_structure_level(cd_establishment_p => 39, ie_level_p => 'O', ie_info_p => 'C');


DELETE FROM pfcs_detail_bed WHERE NR_SEQ_DETAIL = 30010;
DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 30010;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 30010;

DELETE FROM pfcs_detail_bed WHERE NR_SEQ_DETAIL = 30016;
DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 30016;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 30016;

DELETE FROM pfcs_detail_bed WHERE NR_SEQ_DETAIL = 30014;
DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 30014;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 30014;

UPDATE PFCS_PANEL SET VL_INDICATOR = 6 WHERE NR_SEQ_INDICATOR = nr_seq_indicator_p and nr_seq_operational_level = cd_estabelecimento_w;


cd_estabelecimento_w	:= pfcs_get_structure_level(cd_establishment_p => 11, ie_level_p => 'O', ie_info_p => 'C');

DELETE FROM pfcs_detail_bed WHERE NR_SEQ_DETAIL = 30018;
DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 30018;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 30018;

DELETE FROM pfcs_detail_bed WHERE NR_SEQ_DETAIL = 30020;
DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 30020;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 30020;

DELETE FROM pfcs_detail_bed WHERE NR_SEQ_DETAIL = 30023;
DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 30023;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 30023;

UPDATE PFCS_PANEL SET VL_INDICATOR = 6 WHERE NR_SEQ_INDICATOR = nr_seq_indicator_p and nr_seq_operational_level = cd_estabelecimento_w;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_delete_1_tl (nr_seq_indicator_p bigint) FROM PUBLIC;

