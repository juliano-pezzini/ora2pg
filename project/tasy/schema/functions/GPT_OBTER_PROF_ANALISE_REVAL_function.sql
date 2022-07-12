-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gpt_obter_prof_analise_reval (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w				pessoa_fisica.nm_pessoa_fisica%type;


BEGIN

	if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	
		select		obter_nome_pessoa_fisica(max(cd_resp_analise), null) nm_resp_analise
		into STRICT 		ds_retorno_w
		from    	gpt_hist_analise_plano 
		where   	coalesce(dt_fim_analise::text, '') = '' 
		and     	coalesce(ie_tipo_usuario, 'E') = 'F' 
		and     	nr_atendimento = nr_atendimento_p;
	
	end if;
	
return 	ds_retorno_w;
	
end;	
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gpt_obter_prof_analise_reval (nr_atendimento_p bigint) FROM PUBLIC;
