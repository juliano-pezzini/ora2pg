-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_seq_inconsitencia ( cd_inconsistencia_p bigint) RETURNS bigint AS $body$
DECLARE



nr_seq_retorno_w		bigint;


BEGIN

begin
	select	max(nr_sequencia)
	into STRICT	nr_seq_retorno_w
	from	ptu_inconsistencia
	where	cd_inconsistencia = cd_inconsistencia_p;
exception
when others then
	nr_seq_retorno_w := null;
end;

return nr_seq_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_seq_inconsitencia ( cd_inconsistencia_p bigint) FROM PUBLIC;

