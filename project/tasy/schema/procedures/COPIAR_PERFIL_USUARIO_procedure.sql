-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_perfil_usuario ( nm_usuario_origem_p text, nm_usuario_destino_p text, ie_limpa_reg_p text, nm_usuario_p text, ds_observacao_p text) AS $body$
DECLARE


cd_perfil_w			integer;
vl_parametro_w			varchar(1);
ie_estrategico_w 		perfil.ie_estrategico%type;

c01 CURSOR FOR
	SELECT	a.cd_perfil,
		coalesce(b.ie_estrategico, 'N')
	from	usuario_perfil a,
		perfil b
	where	a.nm_usuario = nm_usuario_origem_p
	and	a.cd_perfil = b.cd_perfil
	and	not exists (SELECT	b.cd_perfil
				from	usuario_perfil b
				where	b.cd_perfil = a.cd_perfil
				and	b.nm_usuario = nm_usuario_destino_p);


BEGIN
if (ie_limpa_reg_p	= 'S') then
	delete	from usuario_perfil
	where	nm_usuario	= nm_usuario_destino_p;
end if;

vl_parametro_w := obter_param_usuario(6001, 137, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, vl_parametro_w);

open c01;
loop
fetch c01 into
	cd_perfil_w,
	ie_estrategico_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	if	((ie_estrategico_w = 'N') or (vl_parametro_w = 'S')) then
		insert into usuario_perfil(nm_usuario,
			cd_perfil,
			dt_atualizacao,
			nm_usuario_atual,
			ds_observacao)
		values (nm_usuario_destino_p,
			cd_perfil_w,
			clock_timestamp(),
			nm_usuario_p,
			CASE WHEN coalesce(ds_observacao_p::text, '') = '' THEN  wheb_mensagem_pck.get_texto(800328)||' '||nm_usuario_origem_p  ELSE substr(ds_observacao_p,1,4000) END );
	end if;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_perfil_usuario ( nm_usuario_origem_p text, nm_usuario_destino_p text, ie_limpa_reg_p text, nm_usuario_p text, ds_observacao_p text) FROM PUBLIC;
