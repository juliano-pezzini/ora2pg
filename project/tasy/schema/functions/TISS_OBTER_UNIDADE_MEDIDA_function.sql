-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tiss_obter_unidade_medida (cd_unidade_medida_p text) RETURNS varchar AS $body$
DECLARE


cd_unidade_medida_tiss_w	varchar(20) := '';


BEGIN

if (cd_unidade_medida_p IS NOT NULL AND cd_unidade_medida_p::text <> '') then

	select	max(a.cd_unidade_medida)
	into STRICT	cd_unidade_medida_tiss_w
	from	tiss_unidade_medida a,
		unidade_medida b
	where	b.nr_seq_medida_tiss		= a.nr_sequencia
	and	lower(b.cd_unidade_medida)	= lower(cd_unidade_medida_p);

end if;

if (coalesce(cd_unidade_medida_tiss_w::text, '') = '') then /*Se não possui unidade de medida TISS, retorna 036 - Unidade*/
	cd_unidade_medida_tiss_w	:= '036';
end if;

return	cd_unidade_medida_tiss_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_obter_unidade_medida (cd_unidade_medida_p text) FROM PUBLIC;

