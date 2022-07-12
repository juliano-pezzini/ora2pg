-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION rep_gerar_resumo_pck.get_tr_html_obs ( ds_observacao_p text) RETURNS varchar AS $body$
DECLARE

	
	ds_retorno_w	varchar(2000);
					
	
BEGIN
	
		ds_retorno_w :=	'<tr valign="topmargin">' || chr(13) ||
				'<td colspan="6" style="font-size:13px">' || current_setting('rep_gerar_resumo_pck.c_nbsp')::varchar(10) || current_setting('rep_gerar_resumo_pck.ds_exp24_w')::varchar(255) || ' ' || ds_observacao_p || '</td>' || chr(13) ||
				'</tr>';
			
	return ds_retorno_w;
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rep_gerar_resumo_pck.get_tr_html_obs ( ds_observacao_p text) FROM PUBLIC;
