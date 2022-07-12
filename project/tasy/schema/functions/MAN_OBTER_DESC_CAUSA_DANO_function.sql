-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_desc_causa_dano ( nr_seq_causa_dano_p bigint) RETURNS varchar AS $body$
DECLARE


ds_causa_w					varchar(60);


BEGIN

if (nr_seq_causa_dano_p IS NOT NULL AND nr_seq_causa_dano_p::text <> '') then
	select	coalesce(max(ds_causa),'')
	into STRICT	ds_causa_w
	from	man_causa_dano
	where	nr_sequencia = nr_seq_causa_dano_p;

end if;

return	ds_causa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_desc_causa_dano ( nr_seq_causa_dano_p bigint) FROM PUBLIC;

