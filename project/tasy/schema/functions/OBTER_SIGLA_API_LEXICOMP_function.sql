-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_sigla_api_lexicomp ( ds_nome_api_p text ) RETURNS varchar AS $body$
DECLARE


	ds_sigla_w varchar(255) := '';


BEGIN
	if (ds_nome_api_p IS NOT NULL AND ds_nome_api_p::text <> '') then
		case ds_nome_api_p
			when 'DRUG' then
				ds_sigla_w := 'A';
			when 'DISEASE' then
				ds_sigla_w := 'B';
			when 'TC_DUPLICATION' then
				ds_sigla_w := 'C';
			when 'DRUG_DOSE_INTERACTIONS' then
				ds_sigla_w := 'D';
			when 'ROUTE_CONTRAINDICATIONS' then
				ds_sigla_w := 'E';
			when 'AGE_CONTRAINDICATION' then
				ds_sigla_w := 'F';
			when 'GENDER_CONTRAINDICATIONS' then
				ds_sigla_w := 'G';
			when 'PREGNANCY' then
				ds_sigla_w := 'H';
			when 'LACTATION' then
				ds_sigla_w := 'I';
			when 'DRUG_DISEASE_CONTRAINDICATIONS' then
				ds_sigla_w := 'DDC';
			when 'PRECAUTIONS' then
				ds_sigla_w := 'PE';
			else
				ds_sigla_w := '';
		end case;
	end if;

	return ds_sigla_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_sigla_api_lexicomp ( ds_nome_api_p text ) FROM PUBLIC;
