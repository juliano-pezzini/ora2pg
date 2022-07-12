-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ptu_aviso_pck.gera_sql_a520_where_lote ( dados_a520_p dados_lote_a520_t, alias_p alias_a520_t, dados_bind_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Gera o SQL, parte do WHERE relacionada ao lote.
		
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


ds_sql_w	varchar(32000);

-- variaveis para facilitar a leitura do sql dinamico

prot_w		alias_t%type;
cta_w		alias_t%type;

BEGIN

prot_w	:= alias_p.protocolo;
cta_w	:= alias_p.conta;

ds_sql_w := 	case 	dados_a520_p.ie_tipo_data
			when 'PC' then prot_w||'.dt_mes_competencia between trunc(:dt_referencia_inicio, ''dd'') and fim_dia(:dt_referencia_fim) '
			when 'PR' then prot_w||'.dt_recebimento between trunc(:dt_referencia_inicio, ''dd'') and fim_dia(:dt_referencia_fim) '
			when 'PD' then prot_w||'.dt_protocolo between trunc(:dt_referencia_inicio, ''dd'') and fim_dia(:dt_referencia_fim) '
			when 'CF' then cta_w||'.dt_fechamento_conta between trunc(:dt_referencia_inicio, ''dd'') and fim_dia(:dt_referencia_fim) '
		end || pls_util_pck.enter_w;
		
dados_bind_p := sql_pck.bind_variable(':dt_referencia_inicio', dados_a520_p.dt_referencia_inicio, dados_bind_p);
dados_bind_p := sql_pck.bind_variable(':dt_referencia_fim', dados_a520_p.dt_referencia_fim, dados_bind_p);

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ptu_aviso_pck.gera_sql_a520_where_lote ( dados_a520_p dados_lote_a520_t, alias_p alias_a520_t, dados_bind_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;
