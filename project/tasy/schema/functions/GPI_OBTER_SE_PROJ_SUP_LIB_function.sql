-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gpi_obter_se_proj_sup_lib ( nr_seq_estrutura_p bigint, nr_seq_proj_gpi_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


cd_perfil_ativo_w		bigint;
cd_perfil_w			bigint;
ie_permite_w			varchar(1)	:= 'S';
nm_usuario_lib_w		varchar(15);
nr_seq_proj_gpi_w		bigint	:= nr_seq_proj_gpi_p;
qt_regra_w			bigint;

c01 CURSOR FOR
SELECT	coalesce(ie_permite,'N') ie_permite,
	a.cd_perfil,
	a.nm_usuario_lib
from	gpi_estrut_proj_lib a
where	coalesce(a.nr_seq_estrutura, nr_seq_estrutura_p)	= nr_seq_estrutura_p
and	coalesce(a.nr_seq_proj_gpi, nr_seq_proj_gpi_w) 	= nr_seq_proj_gpi_w
and	coalesce(cd_perfil, cd_perfil_ativo_w)		= cd_perfil_ativo_w
and	coalesce(nm_usuario_lib, nm_usuario_p)		= nm_usuario_p
order by	coalesce(nm_usuario_lib,'A'),
	coalesce(cd_perfil,0),
	coalesce(nr_seq_proj_gpi,0),
	coalesce(nr_seq_estrutura,0);


BEGIN

nr_seq_proj_gpi_w	:= coalesce(nr_seq_proj_gpi_p,0);


	begin
	select	wheb_usuario_pck.get_cd_perfil
	into STRICT	cd_perfil_ativo_w
	;
	exception when others then
		cd_perfil_ativo_w	:= 0;
	end;

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

			select	coalesce(max('S'),'N')
			into STRICT	ie_permite_w
			from	usuario_perfil b
			where	b.cd_perfil	= cd_perfil_w
			and	b.nm_usuario	= nm_usuario_p;

		end if;
		ie_permite_w	:= ie_permite_w;
		end;
	end loop;
	close C01;


return	ie_permite_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gpi_obter_se_proj_sup_lib ( nr_seq_estrutura_p bigint, nr_seq_proj_gpi_p bigint, nm_usuario_p text) FROM PUBLIC;

