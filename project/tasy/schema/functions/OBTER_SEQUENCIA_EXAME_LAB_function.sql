-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_sequencia_exame_lab ( cd_exame_p text) RETURNS bigint AS $body$
DECLARE


nr_seq_exame_w		bigint;


BEGIN

if (cd_exame_p IS NOT NULL AND cd_exame_p::text <> '') then

	select   max(nr_seq_exame)
	into STRICT	 nr_seq_exame_w
	from     exame_laboratorio
	where    upper(cd_exame)   = upper(cd_exame_p);

end if;

return	nr_seq_exame_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_sequencia_exame_lab ( cd_exame_p text) FROM PUBLIC;

