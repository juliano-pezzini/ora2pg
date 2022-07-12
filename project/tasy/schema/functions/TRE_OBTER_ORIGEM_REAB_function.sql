-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tre_obter_origem_reab (cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE

ds_retorno_w	varchar(80);


BEGIN
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	select	max(ds_origem_paciente)
	into STRICT	ds_retorno_w
	from	rp_origem_paciente a,
		rp_paciente_reabilitacao b
	where	a.nr_sequencia = b.nr_seq_origem_paciente
	and	b.cd_pessoa_fisica = cd_pessoa_fisica_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tre_obter_origem_reab (cd_pessoa_fisica_p text) FROM PUBLIC;
