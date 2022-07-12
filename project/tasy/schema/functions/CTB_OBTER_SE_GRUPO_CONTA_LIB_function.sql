-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_se_grupo_conta_lib ( cd_empresa_p bigint, nr_sequencia_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


nm_usuario_lib_w			varchar(15);
ie_permite_w			varchar(1)	:= 'S';
qt_regra_w			bigint;

c01 CURSOR FOR
SELECT	a.nm_usuario_lib,
	a.ie_permite
from	ctb_cen_grupo_conta_lib a
where	a.cd_empresa			= cd_empresa_p
and	coalesce(a.nm_usuario_lib, nm_usuario_p)	= nm_usuario_p
and	a.nr_seq_grupo_conta		= nr_sequencia_p
order by coalesce(a.nm_usuario_lib, 'A');


BEGIN

select	count(*)
into STRICT	qt_regra_w
from	ctb_cen_grupo_conta_lib
where	nr_seq_grupo_conta		= nr_sequencia_p;

if (qt_regra_w > 0) then
	begin
	ie_permite_w	:= 'N';

	open C01;
	loop
	fetch C01 into
		nm_usuario_lib_w,
		ie_permite_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		ie_permite_w	:= ie_permite_w;

		end;
	end loop;
	close C01;

	end;
end if;

return	ie_permite_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_se_grupo_conta_lib ( cd_empresa_p bigint, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

