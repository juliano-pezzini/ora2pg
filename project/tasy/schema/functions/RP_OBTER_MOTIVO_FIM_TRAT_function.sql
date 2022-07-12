-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rp_obter_motivo_fim_trat (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w	varchar(80);

BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	select   max(ds_motivo_fim_tratamento)
	into STRICT	ds_retorno_w
	from  	rp_motivo_fim_tratamento
	where    nr_sequencia = nr_sequencia_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rp_obter_motivo_fim_trat (nr_sequencia_p bigint) FROM PUBLIC;

