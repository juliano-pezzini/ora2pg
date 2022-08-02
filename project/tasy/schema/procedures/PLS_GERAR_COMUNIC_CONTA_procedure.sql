-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_comunic_conta ( ie_tipo_regra_p bigint, ds_conteudo_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE



nm_usuario_comunic_w		varchar(150);
cd_perfil_w			bigint;
ds_comunicado_w			varchar(4000);
ds_titulo_w			varchar(300);
ds_perfil_w			varchar(20) := null;

C01 CURSOR FOR
	SELECT	nm_usuario_comunic,
		cd_perfil,
		ds_comunicado,
		ds_titulo
	from	pls_conta_comunic_interna
	where	ie_tipo_regra	= ie_tipo_regra_p
	and	ie_situacao	= 'A'
	order by 1;


BEGIN

open C01;
loop
fetch C01 into
	nm_usuario_comunic_w,
	cd_perfil_w,
	ds_comunicado_w,
	ds_titulo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (cd_perfil_w IS NOT NULL AND cd_perfil_w::text <> '') then
		ds_perfil_w := To_char(cd_perfil_w) || ',';
	end if;

	CALL gerar_comunic_padrao(clock_timestamp(), ds_titulo_w, ds_comunicado_w || chr(13) || chr(10) || ' ' || ds_conteudo_p,
		nm_usuario_p, 'N', nm_usuario_comunic_w,
		'N', null, ds_perfil_w,	cd_estabelecimento_p,
		null, clock_timestamp(), null,
		null);
	end;
end loop;
close C01;

--commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_comunic_conta ( ie_tipo_regra_p bigint, ds_conteudo_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

