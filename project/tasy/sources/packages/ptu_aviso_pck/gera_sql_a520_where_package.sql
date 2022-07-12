-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ptu_aviso_pck.gera_sql_a520_where ( dados_a520_p dados_lote_a520_t, alias_p alias_a520_t, ie_possui_join_proc_p text, ie_possui_join_mat_p text, dados_gerais_a520_p dados_gerais_a520_t, dados_bind_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Gera o SQL, parte do WHERE, para o A520.
		
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

ds_sql_w	varchar(32000);
ds_sql_temp_w	varchar(32000);


BEGIN

ds_sql_w	:= '';
ds_sql_temp_w	:= '';

-- Lote

ds_sql_w := ptu_aviso_pck.add_sql(ds_sql_w, 'and	', dados_bind_p := ptu_aviso_pck.gera_sql_a520_where_lote(dados_a520_p, alias_p, dados_bind_p));

-- Protocolo

ds_sql_w := ptu_aviso_pck.add_sql(ds_sql_w, 'and	', dados_bind_p := ptu_aviso_pck.gera_sql_a520_where_prot(dados_a520_p, alias_p, dados_gerais_a520_p, dados_bind_p));

-- Conta

ds_sql_w := ptu_aviso_pck.add_sql(ds_sql_w, 'and	', dados_bind_p := ptu_aviso_pck.gera_sql_a520_where_cta(dados_a520_p, alias_p, dados_gerais_a520_p, dados_bind_p));

-- Beneficiario

ds_sql_w := ptu_aviso_pck.add_sql(ds_sql_w, 'and	', dados_bind_p := ptu_aviso_pck.gera_sql_a520_where_benef(dados_a520_p, alias_p, dados_gerais_a520_p, dados_bind_p));

-- Procedimento

ds_sql_w := ptu_aviso_pck.add_sql(ds_sql_w, 'and	', dados_bind_p := ptu_aviso_pck.gera_sql_a520_where_proc(dados_a520_p, alias_p, ie_possui_join_proc_p, dados_gerais_a520_p, dados_bind_p));

-- Material

ds_sql_w := ptu_aviso_pck.add_sql(ds_sql_w, 'and	', dados_bind_p := ptu_aviso_pck.gera_sql_a520_where_mat(dados_a520_p, alias_p, ie_possui_join_mat_p, dados_gerais_a520_p, dados_bind_p));

-- restricoes de uso geral

ds_sql_w := ptu_aviso_pck.add_sql(ds_sql_w, 'and	', dados_bind_p := ptu_aviso_pck.gera_sql_a520_where_geral(dados_a520_p, alias_p, ie_possui_join_proc_p, ie_possui_join_mat_p, dados_bind_p));


return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ptu_aviso_pck.gera_sql_a520_where ( dados_a520_p dados_lote_a520_t, alias_p alias_a520_t, ie_possui_join_proc_p text, ie_possui_join_mat_p text, dados_gerais_a520_p dados_gerais_a520_t, dados_bind_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;