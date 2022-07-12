-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ordem_apres_subgrupo ( nr_seq_subgrupo_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_ordem_w	smallint := 999;


BEGIN

if (coalesce(nr_seq_subgrupo_p,0) > 0) then
	select	coalesce(max(nr_seq_apres),999)
	into STRICT	nr_seq_ordem_w
	from	subgrupo_exame_rotina
	where	nr_sequencia = nr_seq_subgrupo_p;
end if;

return	nr_seq_ordem_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ordem_apres_subgrupo ( nr_seq_subgrupo_p bigint) FROM PUBLIC;
