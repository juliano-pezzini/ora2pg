-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE labweb_recupera_senha ( ds_email_p text, dt_nascimento_p text, ie_tipo_login_p text, nm_usuario_p text, cd_estabelecimento_p text, ds_mensagem_p INOUT text ) AS $body$
DECLARE

 
cd_pessoa_fisica_w	varchar(255);
nm_usuario_email_w	varchar(255);
nr_atendimento_w	varchar(25);
ds_senha_w		varchar(20);
nr_crm_w		varchar(20);
uf_crm_w		varchar(2);
ds_email_origem_w	usuario.ds_email%type;
	

BEGIN	 
 
nm_usuario_email_w := obter_param_usuario(80, 29, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, nm_usuario_email_w);
	 
if (ds_email_p IS NOT NULL AND ds_email_p::text <> '') and (dt_nascimento_p IS NOT NULL AND dt_nascimento_p::text <> '') then 
	 
	select MAX(a.cd_pessoa_fisica) 
	into STRICT 	cd_pessoa_fisica_w 
	from 	pessoa_fisica a, 
		compl_pessoa_fisica b 
	where 	a.cd_pessoa_fisica = b.cd_pessoa_fisica 
	and	b.ie_tipo_complemento = 1 
	and	(b.ds_email IS NOT NULL AND b.ds_email::text <> '') 
	and	a.dt_nascimento = to_date(dt_nascimento_p,'dd/mm/yyyy') 
	and	upper(trim(both b.ds_email)) = upper(trim(both ds_email_p));
	 
	 
	if (coalesce(cd_pessoa_fisica_w::text, '') = '') then 
	 
		select MAX(a.cd_pessoa_fisica) 
		into STRICT 	cd_pessoa_fisica_w 
		from 	pessoa_fisica a, 
			compl_pessoa_fisica b 
		where 	a.cd_pessoa_fisica = b.cd_pessoa_fisica 
		and	b.ie_tipo_complemento = 3 
		and	(b.ds_email IS NOT NULL AND b.ds_email::text <> '') 
		and	a.dt_nascimento = to_date(dt_nascimento_p,'dd/mm/yyyy') 
		and	upper(trim(both b.ds_email)) = upper(trim(both ds_email_p));
	end if;
	 
	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then 
	 
		select 	coalesce(MAX(ds_email),ds_email_p) 
		into STRICT	ds_email_origem_w 
		from	usuario 
		where 	nm_usuario = nm_usuario_email_w;
		 
		 
		if (ie_tipo_login_p = 'A') then 
			select 	MAX(nr_atendimento) 
			into STRICT 	nr_atendimento_w 
			from 	atendimento_paciente 
			where 	cd_pessoa_fisica = cd_pessoa_fisica_w;
			 
			select 	MAX(ds_senha) 
			into STRICT 	ds_senha_w 
			from 	atendimento_paciente 
			where 	nr_atendimento = nr_atendimento_w;
			 
			if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') and (ds_senha_w IS NOT NULL AND ds_senha_w::text <> '') then 
				CALL enviar_email('Laboratório Web - Recuperação de senhas', '=========================================='||CHR(10)|| 
				CHR(13)||'Recuperação de senha do laboratório web'||CHR(10)||CHR(13)||'=========================================='||CHR(10)|| 
				CHR(13)||'Senha recuperada com sucesso!'||CHR(10)|| 
				CHR(13)||'O seu atendimento atual é: '||nr_atendimento_w||' e senha: '||ds_senha_w, ds_email_origem_w, ds_email_p, nm_usuario_email_w, 'A');
				ds_mensagem_p := 'E-mail enviado!';
			end if;
			 
			 
		elsif (ie_tipo_login_p = 'P') then 
			select 	MAX(ds_senha)				 
			into STRICT	ds_senha_w 
			from	pessoa_fisica 
			where	cd_pessoa_fisica = cd_pessoa_fisica_w;
			 
			if (ds_senha_w IS NOT NULL AND ds_senha_w::text <> '') then 
				CALL enviar_email('Laboratório Web - Recuperação de senhas', '=========================================='||CHR(10)|| 
				CHR(13)||'Recuperação de senha do laboratório web'||CHR(10)||CHR(13)||'=========================================='||CHR(10)|| 
				CHR(13)||'Senha recuperada com sucesso!'||CHR(10)|| 
				CHR(13)||'O seu código é: '||cd_pessoa_fisica_w||' e senha: '||ds_senha_w, ds_email_origem_w, ds_email_p, nm_usuario_email_w, 'A');
				ds_mensagem_p := 'E-mail enviado!';
			end if;
			 
		elsif (ie_tipo_login_p = 'M') then 
			select 	MAX(ds_senha), 
				MAX(nr_crm), 
				MAX(uf_crm) 
			into STRICT	ds_senha_w, 
				nr_crm_w, 
				uf_crm_w 
			from	medico 
			where	cd_pessoa_fisica = cd_pessoa_fisica_w;
			 
			if (ds_senha_w IS NOT NULL AND ds_senha_w::text <> '') then 
				CALL enviar_email('Laboratório Web - Recuperação de senhas', '=========================================='||CHR(10)|| 
				CHR(13)||'Recuperação de senha do laboratório web'||CHR(10)||CHR(13)||'=========================================='||CHR(10)|| 
				CHR(13)||'Senha recuperada com sucesso!'||CHR(10)|| 
				CHR(13)||'O seu código CRM-UF é: '||nr_crm_w||'-'||uf_crm_w||' e senha: '||ds_senha_w, ds_email_origem_w, ds_email_p, nm_usuario_email_w, 'A');
				ds_mensagem_p := 'E-mail enviado!';
			end if;
		end if;
			 
	else 
		ds_mensagem_p := 'E-mail e/ou data de nascimento incorreta!';
	end if;
		 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE labweb_recupera_senha ( ds_email_p text, dt_nascimento_p text, ie_tipo_login_p text, nm_usuario_p text, cd_estabelecimento_p text, ds_mensagem_p INOUT text ) FROM PUBLIC;
