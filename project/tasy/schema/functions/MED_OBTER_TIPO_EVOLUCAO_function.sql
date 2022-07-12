-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION med_obter_tipo_evolucao (nr_seq_tipo_evolucao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(80);


BEGIN

if (nr_seq_tipo_evolucao_p IS NOT NULL AND nr_seq_tipo_evolucao_p::text <> '') then

	select	ds_tipo_evolucao
	into STRICT	ds_retorno_w
	from	med_tipo_evolucao
	where	nr_sequencia = nr_seq_tipo_evolucao_p;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION med_obter_tipo_evolucao (nr_seq_tipo_evolucao_p bigint) FROM PUBLIC;

