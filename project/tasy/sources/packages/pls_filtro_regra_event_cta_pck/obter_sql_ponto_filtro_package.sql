-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_filtro_regra_event_cta_pck.obter_sql_ponto_filtro ( ds_tabela_p text) RETURNS varchar AS $body$
BEGIN
-- retorna o sql da tabela passada de parametro

case(ds_tabela_p)
	when 'PLS_PP_CTA_FILTRO_CONTA' then
		return current_setting('pls_filtro_regra_event_cta_pck.ds_sql_fil_conta_w')::varchar(32000);
		
	when 'PLS_PP_CTA_FILTRO_BENEF' then
		return current_setting('pls_filtro_regra_event_cta_pck.ds_sql_fil_beneficiario_w')::varchar(32000);
		
	when 'PLS_PP_CTA_FILTRO_PREST' then
		return current_setting('pls_filtro_regra_event_cta_pck.ds_sql_fil_prestador_w')::varchar(32000);
		
	when 'PLS_PP_CTA_FILTRO_PROC' then
		return current_setting('pls_filtro_regra_event_cta_pck.ds_sql_fil_procedimento_w')::varchar(32000);
		
	when 'PLS_PP_CTA_FILTRO_MAT' then
		return current_setting('pls_filtro_regra_event_cta_pck.ds_sql_fil_material_w')::varchar(32000);
	else
		null;
end case;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_filtro_regra_event_cta_pck.obter_sql_ponto_filtro ( ds_tabela_p text) FROM PUBLIC;
