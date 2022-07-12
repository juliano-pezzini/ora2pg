-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_perfil_canal (nr_seq_canal_p bigint, cd_perfil_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1)	:= 'S';
cd_perfil_w		integer;
cont_perfil_w		bigint;

c01 CURSOR FOR
SELECT	a.cd_perfil
from	com_canal_perfil a
where	a.nr_seq_canal	= nr_seq_canal_p
and	a.cd_perfil	= cd_perfil_p;


BEGIN

if (nr_seq_canal_p IS NOT NULL AND nr_seq_canal_p::text <> '') and (cd_perfil_p IS NOT NULL AND cd_perfil_p::text <> '') then

	select	count(*)
	into STRICT	cont_perfil_w
	from	com_canal_perfil
	where	cd_perfil	= cd_perfil_p;

	if (cont_perfil_w = 0) then
		ie_retorno_w	:= 'S';
	else
		ie_retorno_w	:= 'N';

		open	c01;
		loop
		fetch 	c01 into
			cd_perfil_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			ie_retorno_w	:= 'S';
		end loop;
		close	c01;
	end if;
end if;

return coalesce(ie_retorno_w,'S');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_perfil_canal (nr_seq_canal_p bigint, cd_perfil_p bigint) FROM PUBLIC;

