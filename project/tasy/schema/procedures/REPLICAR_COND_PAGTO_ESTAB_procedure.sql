-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE replicar_cond_pagto_estab ( cd_estab_dest_p bigint, cd_cgc_p text, nm_usuario_p text) AS $body$
DECLARE


cd_cond_pagto_w		bigint;
qt_registro_w		smallint;
cd_estabelecimento_w	smallint := wheb_usuario_pck.get_cd_estabelecimento;

BEGIN

if	((coalesce(cd_cgc_p,'0') <> '0') and (coalesce(cd_estabelecimento_w,0) <> 0)) then
	begin
	select 	coalesce(cd_cond_pagto,0)
	into STRICT	cd_cond_pagto_w
	from	pessoa_juridica_estab
	where	cd_cgc 		= cd_cgc_p
	and	cd_estabelecimento	= cd_estabelecimento_w;
	exception
	when others then
		cd_cond_pagto_w := 0;
	end;

	if 	((cd_cond_pagto_w <> 0) and (coalesce(cd_estab_dest_p,0) <> 0 )) then
		select 	count(*)
		into STRICT	qt_registro_w
		from	pessoa_juridica_estab
		where	cd_estabelecimento = cd_estab_dest_p
		and	cd_cgc = cd_cgc_p;

		if (qt_registro_w > 0) then
			update	pessoa_juridica_estab
			set	cd_cond_pagto 	= cd_cond_pagto_w,
				nm_usuario 	= nm_usuario_p,
				dt_atualizacao 	= clock_timestamp()
			where	cd_cgc 		= cd_cgc_p
			and	cd_estabelecimento = cd_estab_dest_p;
		end if;

	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE replicar_cond_pagto_estab ( cd_estab_dest_p bigint, cd_cgc_p text, nm_usuario_p text) FROM PUBLIC;

