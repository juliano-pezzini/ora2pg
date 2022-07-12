-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_lib_cen (nr_seq_cenario_p bigint, cd_perfil_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE



ds_retorno_w	varchar(3);
nr_seq_grupo_w	bigint;
qt_registro_w	bigint;
qt_regra_w		bigint;

C01 CURSOR FOR
	SELECT  count(*)
	into STRICT	qt_registro_w
	from	ctb_orc_cenario_lib
	where	((nr_seq_grupo 	= nr_seq_grupo_w) or (coalesce(nr_seq_grupo::text, '') = ''))
	and		nr_seq_cenario  = nr_seq_cenario_p
	and		coalesce(ie_permite,'S') = 'S'
	and		((nm_usuario_lib	= nm_usuario_p) or (coalesce(nm_usuario_lib::text, '') = ''))
	and		((cd_perfil	= cd_perfil_p) or (coalesce(cd_perfil::text, '') = ''));

BEGIN


ds_retorno_w	:=	'S';

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_grupo_w
from	grupo_usuario
where	nm_usuario = nm_usuario_p;

select count(*)
into STRICT   qt_regra_w
from   ctb_orc_cenario_lib
where  nr_seq_cenario  = nr_seq_cenario_p;


if (qt_regra_w > 0) then
open C01;
loop
fetch C01 into
	qt_registro_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (qt_registro_w > 0) then
		ds_retorno_w := 'S';
		else
		ds_retorno_w := 'N';
	end if;

	end;
end loop;
close C01;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_lib_cen (nr_seq_cenario_p bigint, cd_perfil_p bigint, nm_usuario_p text) FROM PUBLIC;

