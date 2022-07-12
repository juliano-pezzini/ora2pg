-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dias_cronograma (nr_seq_cronograma_p bigint) RETURNS bigint AS $body$
DECLARE


ds_retorno_w	proj_cron_etapa.qt_dias%type;


BEGIN

if (nr_seq_cronograma_p IS NOT NULL AND nr_seq_cronograma_p::text <> '') then

	select	sum(qt_dias)
	into STRICT	ds_retorno_w
	from	proj_cron_etapa
	where	nr_seq_cronograma = nr_seq_cronograma_p;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dias_cronograma (nr_seq_cronograma_p bigint) FROM PUBLIC;

