-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_auditor_grupo ( nr_seq_grupo_membro_p bigint, ie_tipo_p text) RETURNS varchar AS $body$
DECLARE


/*	ie_tipo_p
	A - Para Retornar nome do auditor
	G - para retornar nome do grupo
e
*/
nr_seq_grupo_w		bigint;
ds_retorno_w		varchar(255);



BEGIN

ds_retorno_w  	:= '';

if (nr_seq_grupo_membro_p IS NOT NULL AND nr_seq_grupo_membro_p::text <> '') then

	select	nr_seq_grupo,
		nm_usuario_exec
	into STRICT 	nr_seq_grupo_w,
		ds_retorno_w
	from	pls_membro_grupo_aud
	where	nr_sequencia = nr_seq_grupo_membro_p;

	if (ie_tipo_p = 'G') then
		select 	nm_grupo_auditor
		into STRICT	ds_retorno_w
		from	pls_grupo_auditor
		where	nr_sequencia = nr_seq_grupo_w;
	end if;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_auditor_grupo ( nr_seq_grupo_membro_p bigint, ie_tipo_p text) FROM PUBLIC;

