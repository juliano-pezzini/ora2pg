-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_grupo_ou_pergunta ( nr_seq_grupo_p bigint, nr_seq_pergunta_p bigint) RETURNS varchar AS $body$
DECLARE


ds_result_w		varchar(255);


BEGIN

if (nr_seq_grupo_p IS NOT NULL AND nr_seq_grupo_p::text <> '') then

	select	coalesce(max(ds_grupo),'')
	into STRICT	ds_result_w
	from	avf_grupo_pergunta
	where	nr_sequencia	= nr_seq_grupo_p;

elsif (nr_seq_pergunta_p IS NOT NULL AND nr_seq_pergunta_p::text <> '') then

	select	'        ' || ds_pergunta
	into STRICT	ds_result_w
	from	avf_pergunta
	where	nr_sequencia = nr_seq_pergunta_p;
end if;

return	ds_result_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_grupo_ou_pergunta ( nr_seq_grupo_p bigint, nr_seq_pergunta_p bigint) FROM PUBLIC;

