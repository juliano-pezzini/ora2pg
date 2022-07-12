-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_se_estrut_orc_lib ( nr_seq_estrut_orc_p bigint, cd_estabelecimento_p bigint, nm_usuario_lib_p text) RETURNS varchar AS $body$
DECLARE


ie_permite_w			varchar(1);

cd_perfil_ativo_w			integer;
cd_perfil_w			integer;
qt_registro_w			bigint;
nm_usuario_lib_w			varchar(15);

c01 CURSOR FOR
SELECT	coalesce(ie_permite, 'N'),
	cd_perfil,
	nm_usuario_lib
from	ctb_tipo_estrut_orc_lib
where	nr_seq_estrut_orc			= nr_seq_estrut_orc_p
and	coalesce(cd_perfil, cd_perfil_ativo_w)	= cd_perfil_ativo_w
and	coalesce(nm_usuario_lib, nm_usuario_lib_p)	= nm_usuario_lib_p
order by	coalesce(nm_usuario_lib, 'A'),
		coalesce(cd_perfil, 0);



BEGIN

cd_perfil_ativo_w			:= coalesce(obter_perfil_ativo, 0);
if (coalesce(cd_perfil_ativo_w, 0) = 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(266454);
end if;

ie_permite_w			:= 'S';

select	count(*)
into STRICT	qt_registro_w
from	ctb_tipo_estrut_orc_lib
where	nr_seq_estrut_orc	= nr_seq_estrut_orc_p;

if (qt_registro_w > 0) then

	ie_permite_w	:= 'N';

	open C01;
	loop
	fetch C01 into
		ie_permite_w,
		cd_perfil_w,
		nm_usuario_lib_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		if (coalesce(nm_usuario_lib_w::text, '') = '') and (cd_perfil_w IS NOT NULL AND cd_perfil_w::text <> '') then

			select	coalesce(max('S'), 'N')
			into STRICT	ie_permite_w
			from	usuario_perfil b
			where	b.cd_perfil	= cd_perfil_w
			and	b.nm_usuario	= nm_usuario_lib_p
			and	ie_permite_w	= 'S';

		end if;
		ie_permite_w	:= ie_permite_w;
		end;
	end loop;
	close C01;

end if;

return	ie_permite_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_se_estrut_orc_lib ( nr_seq_estrut_orc_p bigint, cd_estabelecimento_p bigint, nm_usuario_lib_p text) FROM PUBLIC;
