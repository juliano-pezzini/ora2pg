-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ritual_pepa ( cd_perfil_p bigint, nm_usuario_p text) RETURNS bigint AS $body$
DECLARE


nr_seq_ritual_w		pepa_ritual_lib.nr_seq_ritual%type	:= 0;
cd_estabelecimento_w	pepa_ritual_lib.cd_estabelecimento%type;

c01 CURSOR FOR
	SELECT	nr_seq_ritual
	from	pepa_ritual_lib
	where	((cd_perfil		= cd_perfil_p) or (coalesce(cd_perfil::text, '') = ''))
	and	((nm_usuario_lib	= nm_usuario_p) or (coalesce(nm_usuario_lib::text, '') = ''))
	and	coalesce(cd_estabelecimento,cd_estabelecimento_w) = cd_estabelecimento_w
	order by coalesce(nm_usuario_lib,' '),
		coalesce(cd_perfil,0),
		coalesce(cd_estabelecimento,0);


BEGIN

cd_estabelecimento_w:= coalesce(wheb_usuario_pck.get_cd_estabelecimento,1);

OPEN C01;
LOOP
	FETCH C01 INTO
		nr_seq_ritual_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	nr_seq_ritual_w	:= nr_seq_ritual_w;
END LOOP;
CLOSE C01;


return nr_seq_ritual_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ritual_pepa ( cd_perfil_p bigint, nm_usuario_p text) FROM PUBLIC;
