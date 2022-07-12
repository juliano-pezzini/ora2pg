-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lote_ent_obter_ds_posto (nr_seq_posto_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);


BEGIN

if (nr_seq_posto_p IS NOT NULL AND nr_seq_posto_p::text <> '') then

	select	max(ds_posto)
	into STRICT	ds_retorno_w
	from	LOTE_ENT_INST_POSTO
	where	nr_sequencia = nr_seq_posto_p;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lote_ent_obter_ds_posto (nr_seq_posto_p bigint) FROM PUBLIC;

