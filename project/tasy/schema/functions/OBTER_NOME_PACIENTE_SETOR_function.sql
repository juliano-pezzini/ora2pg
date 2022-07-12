-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_paciente_setor ( nr_seq_paciente_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(60);
cd_pessoa_fisica_w	varchar(10);


BEGIN
if (nr_seq_paciente_p IS NOT NULL AND nr_seq_paciente_p::text <> '') then
	select	cd_pessoa_fisica
	into STRICT	cd_pessoa_fisica_w
	from	paciente_setor
	where	nr_seq_paciente	= nr_seq_paciente_p;

	select	substr(obter_nome_pessoa_fisica(cd_pessoa_fisica_w,null), 1, 60)
	into STRICT	ds_retorno_w
	;
end if;

return	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_paciente_setor ( nr_seq_paciente_p bigint) FROM PUBLIC;

