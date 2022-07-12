-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION medispan_convert_level_just ( cd_api_p text, ds_severidade_p text ) RETURNS varchar AS $body$
DECLARE


	/*
		Nem todas as APIs da Lexicomp retornam todos os niveis de severidade, 
		entao a gente preenche os niveis que faltam na API para se encaixar no cadastro e assim obrigar a justificativa
		Todos os niveis da API estao documentados na function get_severity_level
		Route - Possui somente 2 niveis que sao major e contraindicado, nao precisa fazer nada pois eles ja retornam os maiores levels
	*/
	ds_severidade_conv_w	varchar(50);


BEGIN
	ds_severidade_conv_w := ds_severidade_p;

	if (cd_api_p IS NOT NULL AND cd_api_p::text <> '' AND ds_severidade_p IS NOT NULL AND ds_severidade_p::text <> '') then
		/* Drug Interaction - Possui somente 3 niveis */

		if (cd_api_p = 'A') then
			if (ds_severidade_p = 'CONTRAINDICATED') then
				ds_severidade_conv_w := 'MAJOR';
			end if;
		end if;
	end if;

	return ds_severidade_conv_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION medispan_convert_level_just ( cd_api_p text, ds_severidade_p text ) FROM PUBLIC;
