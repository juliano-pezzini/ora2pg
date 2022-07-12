-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_timeline_pmo ( nr_sequencia_p bigint, ie_opcao_p text) RETURNS timestamp AS $body$
DECLARE

dt_retorno_w	timestamp;

BEGIN

if (ie_opcao_p	= 'I') then

	SELECT	trunc(min(dt_referencia))
	into STRICT	dt_retorno_w
	FROM	pmo_timeline_html_v a
	WHERE	a.nr_sequencia = nr_sequencia_p;
elsif (ie_opcao_p	= 'F') then
	SELECT	trunc(max(dt_referencia))
	into STRICT	dt_retorno_w
	FROM	pmo_timeline_html_v a
	WHERE	a.nr_sequencia = nr_sequencia_p;
end if;

return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_timeline_pmo ( nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;

