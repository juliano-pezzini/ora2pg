-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cargo_perfil_setor_html ( cd_cargo_p bigint, cd_pessoa_fisica_p text, ie_opcao_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
C01 CURSOR FOR 
	SELECT	nm_usuario, 
		cd_setor_atendimento 
	from	usuario 
	where	cd_pessoa_fisica = cd_pessoa_fisica_p 
	and	ie_situacao = 'A';

C01_w	C01%rowtype;
	

BEGIN 
 
open C01;
loop 
fetch C01 into	 
	C01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	 
	CALL gerar_cargo_perfil_setor(	cd_cargo_p, 
					cd_pessoa_fisica_p, 
					ie_opcao_p, 
					C01_w.cd_setor_atendimento, 
					nm_usuario_p, 
					C01_w.nm_usuario, 
					cd_estabelecimento_p);
 
end loop;
close C01;
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cargo_perfil_setor_html ( cd_cargo_p bigint, cd_pessoa_fisica_p text, ie_opcao_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

