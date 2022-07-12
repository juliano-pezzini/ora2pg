-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_tabela_descendente ( nm_tabela_ref_p text, nm_tabela_p text, ie_nivel_p bigint default 1, ie_nivel_maximo_p bigint default 3) RETURNS varchar AS $body$
DECLARE


C01 CURSOR FOR
	SELECT	nm_tabela_referencia
	from	integridade_referencial a
	where	nm_tabela = nm_tabela_p;

c01_w	c01%rowtype;

ie_existe_w	varchar(3) := 'N';
ie_parar_w	smallint;


BEGIN

if (ie_nivel_p < ie_nivel_maximo_p) then

	begin
		select	'S'
		into STRICT	ie_existe_w
		from	integridade_referencial a
		where	nm_tabela = nm_tabela_p
		and	nm_tabela_referencia = nm_tabela_ref_p
		and	coalesce(ie_situacao, 'A') = 'A'  LIMIT 1;
	exception
		when	others then
			ie_existe_w := 'N';
	end;

	if (ie_existe_w = 'N') then

		open C01;
		loop
		fetch C01 into
			c01_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */

			if (obter_se_tabela_descendente(nm_tabela_ref_p, c01_w.nm_tabela_referencia, ie_nivel_p + 1, ie_nivel_maximo_p) = 'S') then
				ie_existe_w := 'S';
			end if;

		end loop;
		close C01;

	end if;
end if;

/* A tabela PERSON_NAME não possui integridade com a pessoa física mas existe ligação entre elas. */

if (nm_tabela_ref_p = 'PESSOA_FISICA' and nm_tabela_p = 'PERSON_NAME') then
	ie_existe_w := 'S';
end if;

return	ie_existe_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_tabela_descendente ( nm_tabela_ref_p text, nm_tabela_p text, ie_nivel_p bigint default 1, ie_nivel_maximo_p bigint default 3) FROM PUBLIC;
