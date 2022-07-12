-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_armazenamento_bolsa_prod (nr_seq_localizacao_p bigint) RETURNS varchar AS $body$
DECLARE

ds_armazenamento_w	varchar(80);

BEGIN
if (nr_seq_localizacao_p IS NOT NULL AND nr_seq_localizacao_p::text <> '') then
	select	x.ds_local
	into STRICT	ds_armazenamento_w
	from	SAN_ARMAZENAMENTO_BOLSA x
	where	nr_sequencia = nr_seq_localizacao_p;

end if;

return	ds_armazenamento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_armazenamento_bolsa_prod (nr_seq_localizacao_p bigint) FROM PUBLIC;
