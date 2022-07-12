-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_derivado_envio_retor (nr_seq_producao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);


BEGIN
if (nr_seq_producao_p IS NOT NULL AND nr_seq_producao_p::text <> '') then

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ds_retorno_w
	from	san_envio_derivado_val g,
		san_envio_derivado z
	where	z.nr_sequencia = g.nr_seq_envio
	and	g.nr_seq_producao = nr_seq_producao_p;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_derivado_envio_retor (nr_seq_producao_p bigint) FROM PUBLIC;
