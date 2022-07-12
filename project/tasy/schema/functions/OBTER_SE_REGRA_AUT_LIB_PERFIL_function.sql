-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_regra_aut_lib_perfil (nr_seq_regra_autor_p bigint) RETURNS varchar AS $body$
DECLARE


ie_permite_w	varchar(15) 	:= 'S';
qt_regra_w	bigint 	:= 0;
cd_perfil_w	integer 	:= obter_perfil_ativo;

BEGIN

begin
select	1
into STRICT	qt_regra_w
from	regra_gerar_autor_perfil a
where	a.nr_seq_regra_autor = nr_seq_regra_autor_p  LIMIT 1;
exception
when others then
	qt_regra_w	:= 0;
end;

if (qt_regra_w > 0) then

	begin
	select	'S'
	into STRICT	ie_permite_w
	from	regra_gerar_autor_perfil a
	where	nr_seq_regra_autor 	= nr_seq_regra_autor_p
	and	a.cd_perfil		= cd_perfil_w  LIMIT 1;
	exception
	when others then
		ie_permite_w := 'N';
	end;

end if;

return	ie_permite_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_regra_aut_lib_perfil (nr_seq_regra_autor_p bigint) FROM PUBLIC;
