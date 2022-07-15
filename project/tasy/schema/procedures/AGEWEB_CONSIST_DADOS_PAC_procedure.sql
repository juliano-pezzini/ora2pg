-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageweb_consist_dados_pac (nr_matricula_p text, ds_pri_nome_p text, ds_pri_nome_mae_p text, ds_ult_nome_p text, ds_ult_nome_mae_p text, ie_sexo_p text, ie_brasileiro_p text, nr_dia_nascimento_p text, nr_mes_nascimento_p text, nr_ano_nascimento_p text, ds_senha_p text, ds_senha_cripto_p text, ds_acao_p text, ds_email_p text, dt_nascimento_p text, nr_cpf_p text, ie_erro_p INOUT text) AS $body$
DECLARE

 
nm_pri_nome_mae_w	varchar(255);	
nm_pri_nome_w		varchar(255);	
nm_ult_nome_w		varchar(255);	
nm_ult_nome_mae_w	varchar(255);	
nr_dia_nascimento_w	varchar(2);
nr_mes_nascimento_w	varchar(2);
nr_ano_nascimento_w	varchar(4);
ie_sexo_w		varchar(1);
ie_brasileiro_w		varchar(1);
nm_pessoa_fisica_w	varchar(255);
nr_cpf_w		varchar(11);
dt_nascimento_w		timestamp;

ds_email_senha_w	varchar(4000);
ds_remetente_w		varchar(255);
ds_titulo_email_senha_w	varchar(255);
ds_email_matricula_w	varchar(255);

qt_registro_w		bigint;
nr_matricula_w		varchar(10);
ds_erro_w			varchar(255);
ie_utiliza_login_pront_w	varchar(1);
cd_pessoa_fisica_w	pessoa_fisica.cd_pessoa_fisica%type;

				  

BEGIN 
 
/*Consistir a utilização do cód. de prontuário*/
 
SELECT coalesce(max(a.ie_utiliza_login_pront),'N') 
into STRICT	ie_utiliza_login_pront_w 
FROM  	parametro_agenda_web a;
 
if (ie_utiliza_login_pront_w = 'N') then 
	select	max(cd_pessoa_fisica) 
	into STRICT	nr_matricula_w 
	from	pessoa_fisica 
	where	cd_pessoa_fisica = nr_matricula_p;
 
	if (coalesce(nr_matricula_w::text, '') = '') then 
		select	max(cd_pessoa_fisica) 
		into STRICT	nr_matricula_w 
		from	pessoa_fisica 
		where	nr_cpf = nr_matricula_p;
	end if;	
else 
	select	max(nr_prontuario) 
	into STRICT	nr_matricula_w 
	from	pessoa_fisica 
	where	nr_prontuario = nr_matricula_p;
end if;
 
if (ie_utiliza_login_pront_w = 'N') then 
 
	select	max(b.ds_email) 
	into STRICT	ds_email_matricula_w 
	from	pessoa_fisica a, 
			compl_pessoa_fisica b 
	where	a.cd_pessoa_fisica 	= b.cd_pessoa_fisica 
	and		b.ie_tipo_complemento 	= 1 
	and		a.cd_pessoa_fisica	= nr_matricula_w;
 
	select	upper(max(Obter_Primeiro_Nome(nm_contato))), 
			upper(max(Obter_Ultimo_Nome(nm_contato))) 
	into STRICT	nm_pri_nome_mae_w, 
			nm_ult_nome_mae_w 
	from	compl_pessoa_fisica 
	where	cd_pessoa_fisica = nr_matricula_w 
	and		ie_tipo_complemento = 5;	
else 
	select	max(b.ds_email) 
	into STRICT	ds_email_matricula_w 
	from	pessoa_fisica a, 
			compl_pessoa_fisica b 
	where	a.cd_pessoa_fisica 	= b.cd_pessoa_fisica 
	and		b.ie_tipo_complemento 	= 1 
	and		a.nr_prontuario	= nr_matricula_w;
 
	select	upper(max(Obter_Primeiro_Nome(a.nm_contato))), 
			upper(max(Obter_Ultimo_Nome(a.nm_contato))) 
	into STRICT	nm_pri_nome_mae_w, 
			nm_ult_nome_mae_w 
	from	compl_pessoa_fisica a, 
			pessoa_fisica b 
	where	a.cd_pessoa_fisica = b.cd_pessoa_fisica 
	and		b.nr_prontuario = nr_matricula_w 
	and		a.ie_tipo_complemento = 5;	
end if;
 
if (ie_utiliza_login_pront_w = 'N') then 
	 
	select	upper(max(Obter_Primeiro_Nome(substr(obter_nome_pf(cd_pessoa_Fisica),1,255)))), 
		upper(max(Obter_Ultimo_Nome(substr(obter_nome_pf(cd_pessoa_Fisica),1,255)))), 
		max(to_char(dt_nascimento,'dd')), 
		max(to_char(dt_nascimento,'mm')), 
		max(to_char(dt_nascimento,'yyyy')), 
		max(ie_sexo), 
		max(substr(obter_nome_pf(cd_pessoa_Fisica),1,255)), 
		max(nr_cpf), 
		max(dt_nascimento) 
	into STRICT	nm_pri_nome_w, 
		nm_ult_nome_w, 
		nr_dia_nascimento_w, 
		nr_mes_nascimento_w, 
		nr_ano_nascimento_w, 
		ie_sexo_w, 
		nm_pessoa_fisica_w, 
		nr_cpf_w, 
		dt_nascimento_w 
	from	pessoa_fisica 
	where	cd_pessoa_fisica = nr_matricula_w;
	 
	select	max(ie_brasileiro) 
	into STRICT	ie_brasileiro_w 
	from	pessoa_fisica a, 
			nacionalidade b 
	where	a.cd_nacionalidade = b.cd_nacionalidade 
	and		a.cd_pessoa_fisica = nr_matricula_w;
	 
else 
	select	upper(max(Obter_Primeiro_Nome(substr(obter_nome_pf(cd_pessoa_Fisica),1,255)))), 
		upper(max(Obter_Ultimo_Nome(substr(obter_nome_pf(cd_pessoa_Fisica),1,255)))), 
		max(to_char(dt_nascimento,'dd')), 
		max(to_char(dt_nascimento,'mm')), 
		max(to_char(dt_nascimento,'yyyy')), 
		max(ie_sexo), 
		max(substr(obter_nome_pf(cd_pessoa_Fisica),1,255)), 
		max(nr_cpf), 
		max(dt_nascimento) 
	into STRICT	nm_pri_nome_w, 
		nm_ult_nome_w, 
		nr_dia_nascimento_w, 
		nr_mes_nascimento_w, 
		nr_ano_nascimento_w, 
		ie_sexo_w, 
		nm_pessoa_fisica_w, 
		nr_cpf_w, 
		dt_nascimento_w 
	from	pessoa_fisica 
	where	nr_prontuario = nr_matricula_w;
	 
	select	max(ie_brasileiro) 
	into STRICT	ie_brasileiro_w 
	from	pessoa_fisica a, 
			nacionalidade b 
	where	a.cd_nacionalidade = b.cd_nacionalidade 
	and		a.nr_prontuario = nr_matricula_w;		
end if;	
 
if (ds_acao_p = 'CPF') then	 
		 
	if (nr_cpf_w IS NOT NULL AND nr_cpf_w::text <> '') and (nr_cpf_w = elimina_caracteres_especiais(nr_cpf_p)) and (dt_nascimento_w IS NOT NULL AND dt_nascimento_w::text <> '') and (dt_nascimento_w = to_date(dt_nascimento_p,'dd/mm/yyyy hh24:mi:ss')) then		 
		if (coalesce(ds_email_matricula_w::text, '') = '') then 
			ie_erro_p := 'EMAIL';
		else 
			ie_erro_p := 'SENHA';
		end if;
	else 
		ie_erro_p := 'PRI';
	end if;
	 
elsif (ds_acao_p = 'PRI') then 
		 
	if (nm_pri_nome_mae_w IS NOT NULL AND nm_pri_nome_mae_w::text <> '') and (nm_pri_nome_mae_w = upper(ds_pri_nome_mae_p)) and (nm_pri_nome_w IS NOT NULL AND nm_pri_nome_w::text <> '') and (nm_pri_nome_w = upper(ds_pri_nome_p)) and (nr_dia_nascimento_w IS NOT NULL AND nr_dia_nascimento_w::text <> '') and (nr_dia_nascimento_w = nr_dia_nascimento_p) then 
		if (coalesce(ds_email_matricula_w::text, '') = '') then 
			ie_erro_p := 'EMAIL';
		else 
			ie_erro_p := 'SENHA';
		end if;
	else 
		ie_erro_p := 'SEG';
	end if;
 
elsif (ds_acao_p = 'SEG') then 
 
	if (nm_pri_nome_mae_w IS NOT NULL AND nm_pri_nome_mae_w::text <> '') and (nm_pri_nome_mae_w = upper(ds_pri_nome_mae_p)) and (nm_pri_nome_w IS NOT NULL AND nm_pri_nome_w::text <> '') and (nm_pri_nome_w = upper(ds_pri_nome_p)) and (nr_mes_nascimento_w IS NOT NULL AND nr_mes_nascimento_w::text <> '') and (nr_mes_nascimento_w = nr_mes_nascimento_p) then 
		if (coalesce(ds_email_matricula_w::text, '') = '') then 
			ie_erro_p := 'EMAIL';
		else 
			ie_erro_p := 'SENHA';
		end if;
	else 
		ie_erro_p := 'TER';
	end if;
	 
elsif (ds_acao_p = 'TER')	 then 
	 
	if (nr_dia_nascimento_w IS NOT NULL AND nr_dia_nascimento_w::text <> '') and (nr_dia_nascimento_w = nr_dia_nascimento_p) and (nr_mes_nascimento_w IS NOT NULL AND nr_mes_nascimento_w::text <> '') and (nr_mes_nascimento_w = nr_mes_nascimento_p) and (nr_ano_nascimento_w IS NOT NULL AND nr_ano_nascimento_w::text <> '') and (nr_ano_nascimento_w = nr_ano_nascimento_p) then 
		if (coalesce(ds_email_matricula_w::text, '') = '') then 
			ie_erro_p := 'EMAIL';
		else 
			ie_erro_p := 'SENHA';
		end if;
	else 
		ie_erro_p := 'QUA';
	end if;
	 
elsif (ds_acao_p = 'QUA') then 
	 
	if (nm_pri_nome_mae_w IS NOT NULL AND nm_pri_nome_mae_w::text <> '') and (nm_pri_nome_mae_w = upper(ds_pri_nome_mae_p)) and (nr_ano_nascimento_w IS NOT NULL AND nr_ano_nascimento_w::text <> '') and (nr_ano_nascimento_w = nr_ano_nascimento_p) and (ie_sexo_w IS NOT NULL AND ie_sexo_w::text <> '') and (ie_sexo_w = upper(ie_sexo_p)) then 
		if (coalesce(ds_email_matricula_w::text, '') = '') then 
			ie_erro_p := 'EMAIL';
		else 
			ie_erro_p := 'SENHA';
		end if;
	else 
		ie_erro_p := 'QUI';
	end if;	
 
elsif (ds_acao_p = 'QUI') then 
 
	if (nr_ano_nascimento_w IS NOT NULL AND nr_ano_nascimento_w::text <> '') and (nr_ano_nascimento_w = nr_ano_nascimento_p) and (ie_brasileiro_w IS NOT NULL AND ie_brasileiro_w::text <> '') and (ie_brasileiro_w = upper(ie_brasileiro_p)) and (nr_dia_nascimento_w IS NOT NULL AND nr_dia_nascimento_w::text <> '') and (nr_dia_nascimento_w = nr_dia_nascimento_p) then 
		if (coalesce(ds_email_matricula_w::text, '') = '') then 
			ie_erro_p := 'EMAIL';
		else 
			ie_erro_p := 'SENHA';
		end if;
	else 
		ie_erro_p := 'SEX';
	end if;
 
elsif (ds_acao_p = 'SEX') then 
 
	if (ie_sexo_w IS NOT NULL AND ie_sexo_w::text <> '') and (ie_sexo_w = upper(ie_sexo_p)) and (ie_brasileiro_w IS NOT NULL AND ie_brasileiro_w::text <> '') and (ie_brasileiro_w = upper(ie_brasileiro_p)) and (nr_ano_nascimento_w IS NOT NULL AND nr_ano_nascimento_w::text <> '') and (nr_ano_nascimento_w = nr_ano_nascimento_p) then 
		if (coalesce(ds_email_matricula_w::text, '') = '') then 
			ie_erro_p := 'EMAIL';
		else 
			ie_erro_p := 'SENHA';
		end if;
	else 
		ie_erro_p := 'SET';
	end if;	
 
elsif (ds_acao_p = 'SET') then 
 
	if (ie_sexo_w IS NOT NULL AND ie_sexo_w::text <> '') and (ie_sexo_w = upper(ie_sexo_p)) and (nm_ult_nome_w IS NOT NULL AND nm_ult_nome_w::text <> '') and (nm_ult_nome_w = upper(ds_ult_nome_p)) and (nr_dia_nascimento_w IS NOT NULL AND nr_dia_nascimento_w::text <> '') and (nr_dia_nascimento_w = nr_dia_nascimento_p) then 
		if (coalesce(ds_email_matricula_w::text, '') = '') then 
			ie_erro_p := 'EMAIL';
		else 
			ie_erro_p := 'SENHA';
		end if;
	else 
		ie_erro_p := 'OIT';
	end if;
 
elsif (ds_acao_p = 'OIT') then 
 
	if (nm_pri_nome_w IS NOT NULL AND nm_pri_nome_w::text <> '') and (nm_pri_nome_w = upper(ds_pri_nome_p)) and (nm_ult_nome_mae_w IS NOT NULL AND nm_ult_nome_mae_w::text <> '') and (nm_ult_nome_mae_w = upper(ds_ult_nome_mae_p)) and (nr_dia_nascimento_w IS NOT NULL AND nr_dia_nascimento_w::text <> '') and (nr_dia_nascimento_w = nr_dia_nascimento_p) then 
		if (coalesce(ds_email_matricula_w::text, '') = '') then 
			ie_erro_p := 'EMAIL';
		else 
			ie_erro_p := 'SENHA';
		end if;
	else 
		ie_erro_p := '';
	end if;
	 
elsif (ds_acao_p = 'EMAIL') then 
	if (ds_email_p IS NOT NULL AND ds_email_p::text <> '') then	 
		if (ie_utiliza_login_pront_w = 'N') then 
			update	compl_pessoa_fisica 
			set	ds_email = ds_email_p 
			where	cd_pessoa_fisica = nr_matricula_w 
			and	ie_tipo_complemento = 1;
		else 
			select	max(cd_pessoa_fisica) 
			into STRICT	cd_pessoa_fisica_w 
			from	pessoa_fisica 
			where	nr_prontuario = nr_matricula_w;
			 
			if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then 
				update	compl_pessoa_fisica 
				set		ds_email = ds_email_p 
				where	cd_pessoa_fisica = cd_pessoa_fisica_w 
				and		ie_tipo_complemento = 1;		
			end if;
		end if;
	 
		ie_erro_p := 'SENHA';
	else 
		ie_erro_p := '';
	end if;
	 
elsif (ds_acao_p = 'SENHA') then 
 
	if (ds_senha_p IS NOT NULL AND ds_senha_p::text <> '') then 
	 
		select	count(*) 
		into STRICT	qt_registro_w 
		from	ageweb_login 
		where	ds_login = nr_matricula_w;
		 
		if (qt_registro_w > 0) then 
			 
			update	ageweb_login 
			set	ds_senha = ds_senha_cripto_p 
			where	ds_login = nr_matricula_w;
			 
			if (ie_utiliza_login_pront_w = 'N') then 
			 
				update	pessoa_fisica 
				set	ds_senha = ds_senha_p 
				where	cd_pessoa_fisica = nr_matricula_w;
			else 
			 
				select	max(cd_pessoa_fisica) 
				into STRICT	cd_pessoa_fisica_w 
				from	pessoa_fisica 
				where	nr_prontuario = nr_matricula_w;
				 
				if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then 
					update	pessoa_fisica 
					set		ds_senha = ds_senha_p 
					where	cd_pessoa_fisica = cd_pessoa_fisica_w;
				end if;
			 
			end if;
			 
		else 
			if (ie_utiliza_login_pront_w = 'S') then 
				select	max(cd_pessoa_fisica) 
				into STRICT	cd_pessoa_fisica_w 
				from	pessoa_fisica 
				where	nr_prontuario = nr_matricula_w;
			end if;
			 
			insert into ageweb_login(nr_sequencia,    
				dt_atualizacao,     
				nm_usuario,       
				dt_atualizacao_nrec, 
				nm_usuario_nrec,     
				cd_pessoa_fisica,    
				ds_login,        
				ds_senha) 
			values (	nextval('ageweb_login_seq'), 
				clock_timestamp(), 
				'Tasy', 
				clock_timestamp(), 
				'Tasy', 
				CASE WHEN ie_utiliza_login_pront_w='N' THEN  nr_matricula_w  ELSE cd_pessoa_fisica_w END , 
				nr_matricula_w, 
				ds_senha_cripto_p);
			 
			if (ie_utiliza_login_pront_w = 'N') then 
			 
				update	pessoa_fisica 
				set		ds_senha = ds_senha_p 
				where	cd_pessoa_fisica = nr_matricula_w;
			else 
			 
				select	max(cd_pessoa_fisica) 
				into STRICT	cd_pessoa_fisica_w 
				from	pessoa_fisica 
				where	nr_prontuario = nr_matricula_w;
				 
				if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then 
					update	pessoa_fisica 
					set		ds_senha = ds_senha_p 
					where	cd_pessoa_fisica = cd_pessoa_fisica_w;
				end if;			
			end if;		
			 
		end if;		
		ie_erro_p := 'GERADA';
		 
	select	max(ds_titulo), 
		max(ds_remetente), 
		max(ds_mensagem) 
	into STRICT	ds_titulo_email_senha_w, 
		ds_remetente_w, 
		ds_email_senha_w 
	from	ageweb_cadastro_email 
	where	ie_tipo_email = 'S';
		 
	if (ds_email_senha_w IS NOT NULL AND ds_email_senha_w::text <> '') and (ds_remetente_w IS NOT NULL AND ds_remetente_w::text <> '') and (ds_titulo_email_senha_w IS NOT NULL AND ds_titulo_email_senha_w::text <> '') and (ds_email_matricula_w IS NOT NULL AND ds_email_matricula_w::text <> '') then 
		 
		ds_email_senha_w	:= substr(replace_macro(ds_email_senha_w, '@paciente', nm_pessoa_fisica_w),1,4000);
		ds_email_senha_w	:= substr(replace_macro(ds_email_senha_w, '@matricula', nr_matricula_w),1,4000);
		ds_email_senha_w	:= substr(replace_macro(ds_email_senha_w, '@senha', ds_senha_p),1,4000);
		 
		CALL enviar_email(ds_titulo_email_senha_w, ds_email_senha_w, ds_remetente_w, ds_email_matricula_w, 'Tasy', 'A');
	end if;
				 
	else 
		ie_erro_p := 'SENHA';
	end if;		
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageweb_consist_dados_pac (nr_matricula_p text, ds_pri_nome_p text, ds_pri_nome_mae_p text, ds_ult_nome_p text, ds_ult_nome_mae_p text, ie_sexo_p text, ie_brasileiro_p text, nr_dia_nascimento_p text, nr_mes_nascimento_p text, nr_ano_nascimento_p text, ds_senha_p text, ds_senha_cripto_p text, ds_acao_p text, ds_email_p text, dt_nascimento_p text, nr_cpf_p text, ie_erro_p INOUT text) FROM PUBLIC;

