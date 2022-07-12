-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_episodio_paciente ( nr_episodio_filtro_p text, cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE

				
ie_retorno_w		varchar(1) := 'S';


BEGIN

if (nr_episodio_filtro_p IS NOT NULL AND nr_episodio_filtro_p::text <> '') then
	select	coalesce(max('S'),'N')
	into STRICT	ie_retorno_w
	from	episodio_paciente a
	where	a.cd_pessoa_fisica = cd_pessoa_fisica_p
	and		(((a.nr_episodio IS NOT NULL AND a.nr_episodio::text <> '') and a.nr_episodio = nr_episodio_filtro_p) or a.nr_sequencia = nr_episodio_filtro_p);
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_episodio_paciente ( nr_episodio_filtro_p text, cd_pessoa_fisica_p text) FROM PUBLIC;
