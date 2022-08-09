-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_email_funcionario ( nm_usuario_p text, ds_email_p text, ds_conta_email_p text, nm_usuario_logado_p text default null, cd_estabelecimento_p text default null) AS $body$
DECLARE


ds_email_w		varchar(255);
ds_conta_email_w	varchar(50);
ie_alterar_cadastro_w	varchar(1);
ie_mensagem_rec_w	varchar(1);
ie_mensagem_envio_w	varchar(1);


BEGIN

if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

	select	ds_email,
		ds_conta_email
	into STRICT	ds_email_w,
		ds_conta_email_w
	from	usuario
	where	nm_usuario = nm_usuario_p;

	ie_alterar_cadastro_w := 'N';

	if (nm_usuario_logado_p IS NOT NULL AND nm_usuario_logado_p::text <> '' AND cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then
		ie_alterar_cadastro_w := obter_param_usuario(230, 52, obter_perfil_ativo, nm_usuario_logado_p, cd_estabelecimento_p, ie_alterar_cadastro_w);
	end if;

	if (ds_email_p <> coalesce(ds_email_w,'X')) then

		update usuario set ds_email = ds_email_p  where nm_usuario = nm_usuario_p;
		commit;

		select	coalesce(ie_mensagem_rec,'X'),
			coalesce(ie_mensagem_envio,'X')
		into STRICT	ie_mensagem_rec_w,
			ie_mensagem_envio_w
		from	usuario
		where	nm_usuario = nm_usuario_p;

		if (((ie_mensagem_rec_w <> 'T') or (ie_mensagem_envio_w <> 'T')) and (ie_alterar_cadastro_w = 'S')) then
			update usuario set ie_mensagem_rec = 'T' , ie_mensagem_envio = 'T' where nm_usuario = nm_usuario_p;
			commit;
		end if;

	end if;

	if (ds_conta_email_p <> coalesce(ds_conta_email_w,'X')) then

		update usuario set ds_conta_email = ds_conta_email_p where nm_usuario = nm_usuario_p;
		commit;

		select	coalesce(ie_mensagem_rec,'X'),
			coalesce(ie_mensagem_envio,'X')
		into STRICT	ie_mensagem_rec_w,
			ie_mensagem_envio_w
		from	usuario
		where	nm_usuario = nm_usuario_p;

		if (((ie_mensagem_rec_w <> 'T') or (ie_mensagem_envio_w <> 'T')) and (ie_alterar_cadastro_w = 'S')) then
			update usuario set ie_mensagem_rec = 'T' , ie_mensagem_envio = 'T' where nm_usuario = nm_usuario_p;
			commit;
		end if;

	end if;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_email_funcionario ( nm_usuario_p text, ds_email_p text, ds_conta_email_p text, nm_usuario_logado_p text default null, cd_estabelecimento_p text default null) FROM PUBLIC;
