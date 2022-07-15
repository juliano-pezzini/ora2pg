-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_delete_6_tl ( nr_seq_indicator_p bigint) AS $body$
DECLARE


pfcs_panel_seq_w				pfcs_panel.nr_sequencia%type;
cd_estabelecimento_w			bigint;
nm_usuario_p	varchar(20);


BEGIN

nm_usuario_p := 'asimovbr';
cd_estabelecimento_w	:= pfcs_get_structure_level(cd_establishment_p => 1, ie_level_p => 'O', ie_info_p => 'C');
	
 := pfcs_pck.pfcs_generate_results(
vl_indicator_p => 35, ds_reference_value_p => '', nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => cd_estabelecimento_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => pfcs_panel_seq_w);

CALL pfcs_pck.pfcs_activate_records(
nr_seq_indicator_p => nr_seq_indicator_p,
nr_seq_operational_level_p => cd_estabelecimento_w,
nm_usuario_p => nm_usuario_p);
	
cd_estabelecimento_w	:= pfcs_get_structure_level(cd_establishment_p => 39, ie_level_p => 'O', ie_info_p => 'C');
	
 := pfcs_pck.pfcs_generate_results(
vl_indicator_p => 25, ds_reference_value_p => '', nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => cd_estabelecimento_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => pfcs_panel_seq_w);

CALL pfcs_pck.pfcs_activate_records(
nr_seq_indicator_p => nr_seq_indicator_p,
nr_seq_operational_level_p => cd_estabelecimento_w,
nm_usuario_p => nm_usuario_p);
	
cd_estabelecimento_w	:= pfcs_get_structure_level(cd_establishment_p => 11, ie_level_p => 'O', ie_info_p => 'C');

 := pfcs_pck.pfcs_generate_results(
vl_indicator_p => 7, ds_reference_value_p => '', nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => cd_estabelecimento_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => pfcs_panel_seq_w);

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
-- REVOKE ALL ON PROCEDURE pfcs_delete_6_tl ( nr_seq_indicator_p bigint) FROM PUBLIC;

