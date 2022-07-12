-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION has_component_configuration ( ie_tipo_component_p text, nm_tabela_p text, nr_seq_visao_p bigint, nr_seq_dic_objeto_p bigint, nr_seq_obj_schem_p bigint, cd_funcao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_return_w	varchar(1) := 'N'; --No
BEGIN

if (ie_tipo_component_p = 'WDBP') then
	ds_return_w := has_dbpanel_configuration(nm_tabela_p,  nr_seq_visao_p, null);
elsif (ie_tipo_component_p = 'WCP') then
	ds_return_w := has_wcpanel_configuration(nr_seq_dic_objeto_p, null);
elsif (ie_tipo_component_p = 'WDF') then
	ds_return_w := has_filter_configuration(nr_seq_dic_objeto_p, null);
elsif (ie_tipo_component_p = 'WPOPUP') then
	ds_return_w := has_popup_configuration(nr_seq_dic_objeto_p, null);
elsif (ie_tipo_component_p = 'WF') then
	ds_return_w := has_filter_configuration(nr_seq_dic_objeto_p, null);
elsif (ie_tipo_component_p = 'WAE') then
	ds_return_w := has_extcall_configuration(nr_seq_obj_schem_p);
elsif (ie_tipo_component_p = 'NAVIGATOR') then
	ds_return_w := has_tab_configuration(cd_funcao_p, nr_seq_obj_schem_p);
end if;

return ds_return_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION has_component_configuration ( ie_tipo_component_p text, nm_tabela_p text, nr_seq_visao_p bigint, nr_seq_dic_objeto_p bigint, nr_seq_obj_schem_p bigint, cd_funcao_p bigint) FROM PUBLIC;
