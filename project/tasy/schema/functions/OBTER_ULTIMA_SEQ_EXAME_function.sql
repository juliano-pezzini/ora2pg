-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ultima_seq_exame ( cd_exame_p text) RETURNS bigint AS $body$
DECLARE


ds_retorno_w	bigint;


BEGIN
if (cd_exame_p IS NOT NULL AND cd_exame_p::text <> '') then
	select	coalesce(max(nr_seq_exame),0)
	into STRICT	ds_retorno_w
	from 	exame_laboratorio
	where 	upper(cd_exame) = upper(cd_exame_p);
end if;
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ultima_seq_exame ( cd_exame_p text) FROM PUBLIC;
