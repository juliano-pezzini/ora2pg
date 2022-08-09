-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_delete_fr13_pa (nr_seq_indicator_p bigint) AS $body$
DECLARE


pfcs_panel_seq_w			pfcs_panel.nr_sequencia%type;
cd_estabelecimento_w			bigint;
nm_usuario_p 				varchar(20);


BEGIN
CALL pfcs_generate_fr13_pa(nr_seq_indicator_p);
nm_usuario_p := 'asimovbr';
cd_estabelecimento_w	:= pfcs_get_structure_level(cd_establishment_p => 1, ie_level_p => 'O', ie_info_p => 'C');

DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 12001;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 12001;

DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 12003;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 12003;

DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 12013;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 12013;

UPDATE PFCS_PANEL SET VL_INDICATOR = 6 WHERE NR_SEQ_INDICATOR = nr_seq_indicator_p and nr_seq_operational_level = cd_estabelecimento_w and ds_reference_value = 'Surgical';

DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 12004;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 12004;

UPDATE PFCS_PANEL SET VL_INDICATOR = 2 WHERE NR_SEQ_INDICATOR = nr_seq_indicator_p and nr_seq_operational_level = cd_estabelecimento_w and ds_reference_value = 'Pediatrics';

DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 12006;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 12006;

DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 12009;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 12009;

UPDATE PFCS_PANEL SET VL_INDICATOR = 4 WHERE NR_SEQ_INDICATOR = nr_seq_indicator_p and nr_seq_operational_level = cd_estabelecimento_w and ds_reference_value = 'Psychiatrics';

cd_estabelecimento_w	:= pfcs_get_structure_level(cd_establishment_p => 39, ie_level_p => 'O', ie_info_p => 'C');

DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 12015;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 12015;

UPDATE PFCS_PANEL SET VL_INDICATOR = 0 WHERE NR_SEQ_INDICATOR = nr_seq_indicator_p and nr_seq_operational_level = cd_estabelecimento_w and ds_reference_value = 'Surgical';

DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 12016;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 12016;

DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 12026;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 12026;

UPDATE PFCS_PANEL SET VL_INDICATOR = 5 WHERE NR_SEQ_INDICATOR = nr_seq_indicator_p and nr_seq_operational_level = cd_estabelecimento_w and ds_reference_value = 'Psychiatrics';

DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 12018;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 12018;

DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 12019;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 12019;

UPDATE PFCS_PANEL SET VL_INDICATOR = 5 WHERE NR_SEQ_INDICATOR = nr_seq_indicator_p and nr_seq_operational_level = cd_estabelecimento_w and ds_reference_value = 'Pediatrics';

cd_estabelecimento_w	:= pfcs_get_structure_level(cd_establishment_p => 11, ie_level_p => 'O', ie_info_p => 'C');

DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 12031;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 12031;

UPDATE PFCS_PANEL SET VL_INDICATOR = 3 WHERE NR_SEQ_INDICATOR = nr_seq_indicator_p and nr_seq_operational_level = cd_estabelecimento_w and ds_reference_value = 'Pediatrics';

 := pfcs_pck.pfcs_generate_results(
		vl_indicator_p => 3, ds_reference_value_p => 'Pediatrics', nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => cd_estabelecimento_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => pfcs_panel_seq_w);

CALL pfcs_pck.pfcs_update_detail(
		nr_seq_indicator_p => nr_seq_indicator_p,
		nr_seq_panel_p => pfcs_panel_seq_w,
		nr_seq_operational_level_p => cd_estabelecimento_w,
		nm_usuario_p => nm_usuario_p);
		
DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 12034;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 12034;

DELETE FROM pfcs_detail_patient WHERE NR_SEQ_DETAIL = 12035;
DELETE FROM pfcs_panel_detail WHERE NR_SEQUENCIA = 12035;

 := pfcs_pck.pfcs_generate_results(
		vl_indicator_p => 11, ds_reference_value_p => 'Psychiatrics', nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => cd_estabelecimento_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => pfcs_panel_seq_w);

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
-- REVOKE ALL ON PROCEDURE pfcs_delete_fr13_pa (nr_seq_indicator_p bigint) FROM PUBLIC;
