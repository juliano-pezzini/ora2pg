-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_conv_xml_cta_pck.obter_rest_regra_carac_espec ( ds_alias_p text, ds_campo_p pls_xml_regra_campo_esp.ds_campo%type, cd_area_procedimento_p pls_xml_regra_campo_esp.cd_area_procedimento%type, cd_especialidade_p pls_xml_regra_campo_esp.cd_especialidade%type, cd_grupo_proc_p pls_xml_regra_campo_esp.cd_grupo_proc%type, cd_procedimento_p pls_xml_regra_campo_esp.cd_procedimento%type, ie_tipo_guia_p pls_xml_regra_campo_esp.ie_tipo_guia%type, nr_seq_prestador_exec_p pls_xml_regra_campo_esp.nr_seq_prestador_exec%type, cd_prestador_exec_p pls_xml_regra_campo_esp.cd_prestador_exec%type, nr_seq_prestador_prot_p pls_xml_regra_campo_esp.nr_seq_prestador_prot%type, cd_prestador_prot_p pls_xml_regra_campo_esp.cd_prestador_prot%type, bind_sql_valor_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE


ds_restricao_w		varchar(3500);
					

BEGIN
-- verifica se _ uma regra para material ou para procedimento

if (ds_campo_p = 'DS_MATERIAL') then

	ds_restricao_w := 'and ' || ds_alias_p || '.ie_tipo_item_conv = ''M''' || pls_util_pck.enter_w;
elsif (ds_campo_p = 'DS_PROCEDIMENTO') then

	ds_restricao_w := 'and ' || ds_alias_p || '.ie_tipo_item_conv = ''P''' || pls_util_pck.enter_w;
end if;


-- area de procedimento

if (cd_area_procedimento_p IS NOT NULL AND cd_area_procedimento_p::text <> '') then
	
	ds_restricao_w := ' and  exists( select 1 ' || pls_util_pck.enter_w ||
					' from estrutura_procedimento_v v '|| pls_util_pck.enter_w ||
					' where v.cd_procedimento = ' || ds_alias_p || '.cd_procedimento_conv ' || pls_util_pck.enter_w ||
					' and 	v.cd_area_procedimento = :cd_area_procedimento) '|| pls_util_pck.enter_w;
	bind_sql_valor_p := sql_pck.bind_variable(':cd_area_procedimento', cd_area_procedimento_p, bind_sql_valor_p);
end if;

-- especialidade do procedimento

if (cd_especialidade_p IS NOT NULL AND cd_especialidade_p::text <> '') then
	
	ds_restricao_w := ' and  exists( select 1 ' || pls_util_pck.enter_w ||
					' from estrutura_procedimento_v v '|| pls_util_pck.enter_w ||
					' where v.cd_procedimento = ' || ds_alias_p || '.cd_procedimento_conv ' || pls_util_pck.enter_w ||
					' and 	v.cd_especialidade = :cd_especialidade) '|| pls_util_pck.enter_w;
	bind_sql_valor_p := sql_pck.bind_variable(':cd_especialidade', cd_especialidade_p, bind_sql_valor_p);
end if;

-- grupo de procedimento

if (cd_grupo_proc_p IS NOT NULL AND cd_grupo_proc_p::text <> '') then
	
	ds_restricao_w := ' and  exists( select 1 ' || pls_util_pck.enter_w ||
					' from estrutura_procedimento_v v '|| pls_util_pck.enter_w ||
					' where v.cd_procedimento = ' || ds_alias_p || '.cd_procedimento_conv ' || pls_util_pck.enter_w ||
					' and 	v.cd_grupo_proc = :cd_grupo_proc) '|| pls_util_pck.enter_w;
	bind_sql_valor_p := sql_pck.bind_variable(':cd_grupo_proc', cd_grupo_proc_p, bind_sql_valor_p);
end if;	

-- c_digo do procedimento	

if (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') then
	
	ds_restricao_w := ' and  ' || ds_alias_p || '.cd_procedimento_conv = :cd_procedimento ' || pls_util_pck.enter_w;
	bind_sql_valor_p := sql_pck.bind_variable(':cd_procedimento', cd_procedimento_p, bind_sql_valor_p);
end if;

-- tipo de guia

if (ie_tipo_guia_p IS NOT NULL AND ie_tipo_guia_p::text <> '') then
	
	ds_restricao_w := ' and  ' || ds_alias_p || '.ie_tipo_guia = :ie_tipo_guia ' || pls_util_pck.enter_w;
	bind_sql_valor_p := sql_pck.bind_variable(':ie_tipo_guia', ie_tipo_guia_p, bind_sql_valor_p);
end if;

-- sequencia do prestador executor

if (nr_seq_prestador_exec_p IS NOT NULL AND nr_seq_prestador_exec_p::text <> '') then
	
	ds_restricao_w := ' and  ' || ds_alias_p || '.nr_seq_prest_exec_conv = :nr_seq_prestador_exec ' || pls_util_pck.enter_w;
	bind_sql_valor_p := sql_pck.bind_variable(':nr_seq_prestador_exec', nr_seq_prestador_exec_p, bind_sql_valor_p);
end if;

-- c_digo do prestador executor

if (cd_prestador_exec_p IS NOT NULL AND cd_prestador_exec_p::text <> '') then
	
	ds_restricao_w := ' and  ' || ds_alias_p || '.cd_prest_exec_conv = :cd_prestador_exec ' || pls_util_pck.enter_w;
	bind_sql_valor_p := sql_pck.bind_variable(':cd_prestador_exec', cd_prestador_exec_p, bind_sql_valor_p);
end if;

-- sequencia do prestador executor

if (nr_seq_prestador_prot_p IS NOT NULL AND nr_seq_prestador_prot_p::text <> '') then
	
	ds_restricao_w := ' and  ' || ds_alias_p || '.nr_seq_prest_prot_conv = :nr_seq_prestador_prot ' || pls_util_pck.enter_w;
	bind_sql_valor_p := sql_pck.bind_variable(':nr_seq_prestador_prot', nr_seq_prestador_prot_p, bind_sql_valor_p);
end if;

-- c_digo do prestador executor

if (cd_prestador_prot_p IS NOT NULL AND cd_prestador_prot_p::text <> '') then
	
	ds_restricao_w := ' and  ' || ds_alias_p || '.cd_prest_prot_conv = :cd_prestador_prot ' || pls_util_pck.enter_w;
	bind_sql_valor_p := sql_pck.bind_variable(':cd_prestador_prot', cd_prestador_prot_p, bind_sql_valor_p);
end if;

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_conv_xml_cta_pck.obter_rest_regra_carac_espec ( ds_alias_p text, ds_campo_p pls_xml_regra_campo_esp.ds_campo%type, cd_area_procedimento_p pls_xml_regra_campo_esp.cd_area_procedimento%type, cd_especialidade_p pls_xml_regra_campo_esp.cd_especialidade%type, cd_grupo_proc_p pls_xml_regra_campo_esp.cd_grupo_proc%type, cd_procedimento_p pls_xml_regra_campo_esp.cd_procedimento%type, ie_tipo_guia_p pls_xml_regra_campo_esp.ie_tipo_guia%type, nr_seq_prestador_exec_p pls_xml_regra_campo_esp.nr_seq_prestador_exec%type, cd_prestador_exec_p pls_xml_regra_campo_esp.cd_prestador_exec%type, nr_seq_prestador_prot_p pls_xml_regra_campo_esp.nr_seq_prestador_prot%type, cd_prestador_prot_p pls_xml_regra_campo_esp.cd_prestador_prot%type, bind_sql_valor_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;