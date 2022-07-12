-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_mens_itens_conta_pck.add_restricao_regra_grupo ( ds_select_p INOUT text, valor_bind_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE

ds_select_w	varchar(32000);
valor_bind_w	sql_pck.t_dado_bind;

BEGIN
ds_select_w	:= ds_select_p;
valor_bind_w	:= valor_bind_p;

if (current_setting('pls_mens_itens_conta_pck.nr_seq_prestador_regra_exec_w')::pls_mensalidade_grupo.nr_seq_prestador%(type IS NOT NULL AND type::text <> '')) then
	ds_select_w	:= ds_select_w || ' and a.nr_seq_prestador_exec = :seq_prestador_regra_exec_pc ';
	valor_bind_w := sql_pck.bind_variable(':seq_prestador_regra_exec_pc', current_setting('pls_mens_itens_conta_pck.nr_seq_prestador_regra_exec_w')::pls_mensalidade_grupo.nr_seq_prestador%type, valor_bind_w);
end if;
if (current_setting('pls_mens_itens_conta_pck.nr_seq_prestador_regra_atend_w')::pls_mensalidade_grupo.nr_seq_prestador_atend%(type IS NOT NULL AND type::text <> '')) then
	ds_select_w	:= ds_select_w || ' and a.nr_seq_prestador_atend = :seq_prestador_regra_atend_pc ';
	valor_bind_w := sql_pck.bind_variable(':seq_prestador_regra_atend_pc', current_setting('pls_mens_itens_conta_pck.nr_seq_prestador_regra_atend_w')::pls_mensalidade_grupo.nr_seq_prestador_atend%type, valor_bind_w);
end if;
if	((current_setting('pls_mens_itens_conta_pck.ie_tipo_prestador_exec_regra_w')::pls_mensalidade_grupo.ie_tipo_prestador_exec%(type IS NOT NULL AND type::text <> '')) and (current_setting('pls_mens_itens_conta_pck.ie_tipo_prestador_exec_regra_w')::pls_mensalidade_grupo.ie_tipo_prestador_exec%type <> 'A')) then
	ds_select_w	:= ds_select_w || ' and a.ie_tipo_prestador_exec = :ie_tipo_prestador_exec_pc ';
	valor_bind_w := sql_pck.bind_variable(':ie_tipo_prestador_exec_pc', current_setting('pls_mens_itens_conta_pck.ie_tipo_prestador_exec_regra_w')::pls_mensalidade_grupo.ie_tipo_prestador_exec%type, valor_bind_w);
end if;
if	((current_setting('pls_mens_itens_conta_pck.ie_tipo_prestador_atend_regr_w')::pls_mensalidade_grupo.ie_tipo_prestador_atend%(type IS NOT NULL AND type::text <> '')) and (current_setting('pls_mens_itens_conta_pck.ie_tipo_prestador_atend_regr_w')::pls_mensalidade_grupo.ie_tipo_prestador_atend%type <> 'A')) then
	ds_select_w	:= ds_select_w || ' and a.ie_tipo_prestador_atend = :ie_tipo_prestador_atend_pc ';
	valor_bind_w := sql_pck.bind_variable(':ie_tipo_prestador_atend_pc', current_setting('pls_mens_itens_conta_pck.ie_tipo_prestador_atend_regr_w')::pls_mensalidade_grupo.ie_tipo_prestador_atend%type, valor_bind_w);
end if;
if (current_setting('pls_mens_itens_conta_pck.ie_tipo_guia_regra_w')::pls_mensalidade_grupo.ie_tipo_guia%(type IS NOT NULL AND type::text <> '')) then
	ds_select_w	:= ds_select_w || ' and a.ie_tipo_guia = :ie_tipo_guia_pc ';
	valor_bind_w := sql_pck.bind_variable(':ie_tipo_guia_pc', current_setting('pls_mens_itens_conta_pck.ie_tipo_guia_regra_w')::pls_mensalidade_grupo.ie_tipo_guia%type, valor_bind_w);
end if;
if (current_setting('pls_mens_itens_conta_pck.ie_tipo_segurado_regra_w')::pls_mensalidade_grupo.ie_tipo_segurado%(type IS NOT NULL AND type::text <> '')) then
	ds_select_w	:= ds_select_w || ' and a.ie_tipo_segurado = :ie_tipo_segurado_pc ';
	valor_bind_w := sql_pck.bind_variable(':ie_tipo_segurado_pc', current_setting('pls_mens_itens_conta_pck.ie_tipo_segurado_regra_w')::pls_mensalidade_grupo.ie_tipo_segurado%type, valor_bind_w);
end if;
if (current_setting('pls_mens_itens_conta_pck.ie_preco_regra_w')::pls_mensalidade_grupo.ie_preco%(type IS NOT NULL AND type::text <> '')) then
	ds_select_w	:= ds_select_w || ' and a.ie_preco = :ie_preco_pc ';
	valor_bind_w := sql_pck.bind_variable(':ie_preco_pc', current_setting('pls_mens_itens_conta_pck.ie_preco_regra_w')::pls_mensalidade_grupo.ie_preco%type, valor_bind_w);
end if;

ds_select_p	:= ds_select_w;
valor_bind_p	:= valor_bind_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mens_itens_conta_pck.add_restricao_regra_grupo ( ds_select_p INOUT text, valor_bind_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;