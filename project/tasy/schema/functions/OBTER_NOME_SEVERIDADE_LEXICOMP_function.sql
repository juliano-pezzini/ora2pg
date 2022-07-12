-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_severidade_lexicomp ( nr_gravidade_p alerta_api.nr_gravidade%type ) RETURNS varchar AS $body$
DECLARE


	ds_severity varchar(255) := '';


BEGIN
	if (nr_gravidade_p IS NOT NULL AND nr_gravidade_p::text <> '') then
		CASE nr_gravidade_p
			WHEN 0 THEN
				ds_severity := 'MINOR';
			WHEN 1 THEN
				ds_severity := 'CONTRAINDICATED';
			WHEN 2 THEN
				ds_severity := 'MAJOR';
			WHEN 3 THEN
				ds_severity := 'MODERATE';
			WHEN 4 THEN
				ds_severity := 'MODERATE';
			WHEN 5 THEN
				ds_severity := 'INFO';
			ELSE
				ds_severity := '';
		END CASE;
	end if;

	return ds_severity;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_severidade_lexicomp ( nr_gravidade_p alerta_api.nr_gravidade%type ) FROM PUBLIC;
