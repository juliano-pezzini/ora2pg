-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_etapa_proj ( NR_SEQUENCIA_P bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);


BEGIN
if (NR_SEQUENCIA_P IS NOT NULL AND NR_SEQUENCIA_P::text <> '') then
	begin
	select	substr(obter_desc_etapa_cronograma(nr_seq_etapa),1,100) ds_etapa
	into STRICT	ds_retorno_w
	from	proj_cron_etapa
	where	nr_sequencia	= nr_sequencia_p;
	end;
end if;

RETURN ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_etapa_proj ( NR_SEQUENCIA_P bigint) FROM PUBLIC;

