-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_comunic_param_web ( cd_funcao_p bigint, nr_seq_parametro_p bigint, nr_seq_funcao_p bigint, ie_tipo_alteracao_p text, vl_parametro_p text, nr_seq_segurado_p pls_web_param_usuario.nr_seq_segurado%type, nr_seq_usu_estip_p pls_web_param_usuario.nr_seq_usu_estipulante%type, nr_seq_usu_prest_p pls_web_param_usuario.nr_seq_usu_prestador%type, nr_seq_usu_gru_cont_p pls_web_param_usuario.nr_seq_usu_grupo_contrato%type, nm_usuario_param_p pls_web_param_usuario.nm_usuario_param%type, ie_tipo_acesso_p pls_web_param_usuario.ie_tipo_acesso%type, nr_seq_perfil_web_p pls_web_param_usuario.nr_seq_perfil_web%type, nr_seq_contrato_p pls_web_param_contrato.nr_seq_contrato%type, ie_tipo_envio_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
/*----------------------------------------- 
ie_tipo_alteracao_p : 
 A = Alteração de parâmetro. 
 E = Exclusão de parâmetro. 
 
ie_tipo_envio_p: 
U = pls_web_param_usuario. 
C = pls_web_param_contrato. 
F = funcao_parametro. 
*/
 
 
ds_comunicado_w		varchar(4000)	:= null;
ds_usuarios_destino_w	varchar(4000)	:= null;
ds_perfis_destino_w	varchar(4000)	:= null;
ds_usuario_email_w	varchar(4000)	:= null;
ds_lista_emails_w	varchar(4000)	:= null;

ds_segurado_w		varchar(255);
ds_usu_estip_w		varchar(255);
ds_usu_prest_w		varchar(255);
ds_usu_grupo_w		varchar(255);
ds_tipo_aces_w		varchar(255);
ds_perfil_web_w		varchar(255);
ds_parametro_w		varchar(255);
vl_anterior_w		varchar(255);
vl_novo_w		varchar(255);
ds_titulo_w		varchar(255);
nr_seq_classif_w	bigint;
tam_lista_w		bigint;
ie_pos_virgula_w	smallint	:= 0;
nm_usuario_w		varchar(15);
ds_email_destino_w	varchar(4000);
ds_nome_segurado_w	varchar(255);
ds_nome_estipulante_w	varchar(255);
ds_nome_prestador_w	varchar(255);
ds_grupo_relac_w	varchar(255);
ds_tipo_acesso_w	varchar(255);
ds_seq_perfil_web_w	varchar(255);
qt_contratos_w		bigint;


BEGIN 
 
if (nr_seq_parametro_p IS NOT NULL AND nr_seq_parametro_p::text <> '') then 
 
	ds_usuarios_destino_w	:= obter_valor_param_usuario(6001,36,null,nm_usuario_p,cd_estabelecimento_p);
	ds_perfis_destino_w	:= obter_valor_param_usuario(6001,37,null,nm_usuario_p,cd_estabelecimento_p);
	ds_usuario_email_w	:= obter_valor_param_usuario(6001,155,null,nm_usuario_p,cd_estabelecimento_p);
 
	if (coalesce(somente_numero(obter_valor_param_usuario(6001,38,null,nm_usuario_p,cd_estabelecimento_p)),0) <> 0) then 
		nr_seq_classif_w	:= somente_numero(obter_valor_param_usuario(6001,38,null,nm_usuario_p,cd_estabelecimento_p));
	end if;
 
	select	substr(obter_desc_expressao(cd_exp_parametro, ds_parametro),1,254) 
	into STRICT	ds_parametro_w 
	from	funcao_parametro 
	where	cd_funcao	= cd_funcao_p 
	and	nr_sequencia	= nr_seq_funcao_p;
 
	if (ie_tipo_alteracao_p = 'A') then 
		ds_titulo_w	:= 'Alteração de parâmetro do sistema';
 
		ds_comunicado_w	:=	'Alterado o parâmetro [' || nr_seq_funcao_p || '] - ' || ds_parametro_w || chr(13);
 
	elsif (ie_tipo_alteracao_p = 'E') then 
		ds_titulo_w	:= 'Exclusão de parâmetro do sistema';
 
		ds_comunicado_w	:=	'Excluído o parâmetro [' || nr_seq_funcao_p || '] - ' || ds_parametro_w || chr(13);
	end if;
 
	begin 
	if (ie_tipo_envio_p = 'U') then 
		select	vl_parametro 
		into STRICT	vl_anterior_w 
		from	pls_web_param_usuario 
		where	cd_funcao	= cd_funcao_p 
		and	nr_sequencia	= nr_seq_parametro_p;
	elsif (ie_tipo_envio_p = 'C') then 
		select	vl_parametro 
		into STRICT	vl_anterior_w 
		from	pls_web_param_contrato 
		where	cd_funcao	= cd_funcao_p 
		and	nr_sequencia	= nr_seq_parametro_p;
	elsif (ie_tipo_envio_p = 'F') then 
		select	vl_parametro 
		into STRICT	vl_anterior_w 
		from	funcao_parametro 
		where	cd_funcao	= cd_funcao_p 
		and	nr_sequencia	= nr_seq_parametro_p;
	end if;
	exception 
	when others then 
		vl_anterior_w := vl_parametro_p;
	end;
 
	if (nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '') then 
		select	substr(pls_obter_dados_segurado(nr_seq_segurado_p,'N'),1,60) 
		into STRICT	ds_nome_segurado_w 
		;
 
		if (ds_nome_segurado_w IS NOT NULL AND ds_nome_segurado_w::text <> '')then 
			ds_segurado_w := nr_seq_segurado_p || ' ' || ds_nome_segurado_w;
		else 
			goto final;
		end if;
	else 
		ds_segurado_w := '';
	end if;
 
	if (nr_seq_usu_estip_p IS NOT NULL AND nr_seq_usu_estip_p::text <> '') then 
		select	substr(pls_obter_nm_estipulante_web(nr_seq_usu_estip_p),1,60) 
		into STRICT	ds_nome_estipulante_w 
		;
 
		if (ds_nome_estipulante_w IS NOT NULL AND ds_nome_estipulante_w::text <> '')then 
			ds_usu_estip_w := nr_seq_usu_estip_p || ' ' || ds_nome_estipulante_w;
		else 
			goto final;
		end if;
	else 
		ds_usu_estip_w := '';
	end if;
 
	if (nr_seq_usu_prest_p IS NOT NULL AND nr_seq_usu_prest_p::text <> '') then 
		select	substr(pls_obter_nm_usuario_web(nr_seq_usu_prest_p),1,60) 
		into STRICT	ds_nome_prestador_w 
		;
 
		if (ds_nome_prestador_w IS NOT NULL AND ds_nome_prestador_w::text <> '')then 
			ds_usu_prest_w := nr_seq_usu_prest_p || ' ' || ds_nome_prestador_w;
		else 
			goto final;
		end if;
	else 
		ds_usu_prest_w := '';
	end if;
 
	if (nr_seq_usu_gru_cont_p IS NOT NULL AND nr_seq_usu_gru_cont_p::text <> '') then 
		select	substr(pls_obter_nm_grupo_relaci_web(nr_seq_usu_gru_cont_p),1,255) 
		into STRICT	ds_grupo_relac_w 
		;
 
		if (ds_grupo_relac_w IS NOT NULL AND ds_grupo_relac_w::text <> '')then 
			ds_usu_grupo_w := nr_seq_usu_gru_cont_p || ' ' || ds_grupo_relac_w;
		else 
			goto final;
		end if;
	else 
		ds_usu_grupo_w := '';
	end if;
 
	if (ie_tipo_acesso_p IS NOT NULL AND ie_tipo_acesso_p::text <> '') then 
		select	substr(obter_valor_dominio(2851,ie_tipo_acesso_p),1,255) 
		into STRICT	ds_tipo_acesso_w 
		;
 
		if (ds_tipo_acesso_w IS NOT NULL AND ds_tipo_acesso_w::text <> '')then 
			ds_tipo_aces_w := ds_tipo_acesso_w;
		else 
			goto final;
		end if;
	else 
		ds_tipo_aces_w := '';
	end if;
 
	if (nr_seq_perfil_web_p IS NOT NULL AND nr_seq_perfil_web_p::text <> '') then 
		select	substr(pls_obter_dados_perfil_web(nr_seq_perfil_web_p, 'N'),1,60) 
		into STRICT	ds_seq_perfil_web_w 
		;
 
		if (ds_seq_perfil_web_w IS NOT NULL AND ds_seq_perfil_web_w::text <> '')then 
			ds_perfil_web_w := nr_seq_perfil_web_p || ' ' || ds_seq_perfil_web_w;
		else 
			goto final;
		end if;
	else 
		ds_perfil_web_w := '';
	end if;
 
	if (nr_seq_contrato_p IS NOT NULL AND nr_seq_contrato_p::text <> '') then 
		select	count(1) 
		into STRICT	qt_contratos_w 
		from	pls_contrato 
		where	nr_sequencia = nr_seq_contrato_p;
 
		if (qt_contratos_w = 0) then 
			goto final;
		end if;
	end if;
 
	ds_comunicado_w	:=	ds_comunicado_w ||chr(13) || chr(10) || 
				'Função: ' || substr(obter_desc_funcao(cd_funcao_p),1,255) || chr(13) || chr(10) || chr(13) || chr(10) || 
				'Dados da alteração: ' || chr(13) || chr(10) || chr(13) || chr(10);
 
	vl_novo_w	:= vl_parametro_p;
 
	if (ie_tipo_alteracao_p = 'A') then 
		if (ie_tipo_envio_p = 'U') then 
			ds_comunicado_w	:= ds_comunicado_w || 
				'Beneficiário: ' 		|| ds_segurado_w || chr(13) || chr(10) || 
				'Usuário estipulante: ' 	|| ds_usu_estip_w || chr(13) || chr(10) || 
				'Usuário prestador: ' 		|| ds_usu_prest_w || chr(13) || chr(10) || 
				'Usuário grupo relac: ' 	|| ds_usu_grupo_w || chr(13) || chr(10) || 
				'Usuário: ' 			|| nm_usuario_param_p || chr(13) || chr(10) || 
				'Tipo de acesso: ' 		|| ds_tipo_aces_w || chr(13) || chr(10) || 
				'Perfil web: ' 			|| ds_perfil_web_w || chr(13) || chr(10) || chr(13) || chr(10);
			if (vl_anterior_w = vl_novo_w) then 
				ds_comunicado_w	:= ds_comunicado_w || 
					'Valor parâmetro: '	|| vl_novo_w || chr(13) || chr(10);
			else 
				ds_comunicado_w	:= ds_comunicado_w || 
					'Valor parâmetro antigo: ' 	|| vl_anterior_w || chr(13) || chr(10) || 
					'Valor parâmetro novo: '	|| vl_novo_w || chr(13) || chr(10);
			end if;
		elsif (ie_tipo_envio_p = 'C') then 
			ds_comunicado_w	:= ds_comunicado_w || 
				'Contrato: '			|| nr_seq_contrato_p || chr(13) || chr(10) || chr(13) || chr(10);
			if (vl_anterior_w = vl_novo_w) then 
				ds_comunicado_w	:= ds_comunicado_w || 
					'Valor parâmetro: '	|| vl_novo_w || chr(13) || chr(10);
			else 
				ds_comunicado_w	:= ds_comunicado_w || 
					'Valor parâmetro antigo: ' 	|| vl_anterior_w || chr(13) || chr(10) || 
					'Valor parâmetro novo: '	|| vl_novo_w || chr(13) || chr(10);
			end if;
		elsif (ie_tipo_envio_p = 'F') then 
			ds_comunicado_w	:= ds_comunicado_w || 
					'Valor parâmetro antigo: ' 	|| vl_anterior_w || chr(13) || chr(10) || 
					'Valor parâmetro novo: '	|| vl_novo_w || chr(13) || chr(10);
		end if;
	end if;
 
	ds_comunicado_w	:= 	ds_comunicado_w || chr(13) || chr(10) || 
				'Usuário alteração: '		|| substr(obter_nome_usuario(nm_usuario_p),1,255);
end if;
 
if (ds_comunicado_w IS NOT NULL AND ds_comunicado_w::text <> '') then 
	CALL gerar_comunic_padrao(	clock_timestamp(), ds_titulo_w, ds_comunicado_w, 
				nm_usuario_p, 'N', ds_usuarios_destino_w, 
				'N', nr_seq_classif_w, ds_perfis_destino_w, 
				null, null, clock_timestamp(), 
				null, null);
 
	if (ds_usuario_email_w IS NOT NULL AND ds_usuario_email_w::text <> '') then 
		begin 
		ds_lista_emails_w := substr(ds_usuario_email_w,1, length(ds_usuario_email_w));	
		while(ds_lista_emails_w IS NOT NULL AND ds_lista_emails_w::text <> '') loop 
			begin 
			tam_lista_w	:= length( ds_lista_emails_w );
			ie_pos_virgula_w 	:= position(',' in ds_lista_emails_w );
 
			if (ie_pos_virgula_w <> 0) then 
				nm_usuario_w		:= substr(ds_lista_emails_w,1,(ie_pos_virgula_w - 1));
				ds_lista_emails_w	:= substr(ds_lista_emails_w,(ie_pos_virgula_w + 1),tam_lista_w);
			else 
				nm_usuario_w		:= ds_lista_emails_w;
				ds_lista_emails_w 	:= null;
			end if;	
 
			select obter_dados_usuario_opcao(nm_usuario_w,'E') ds_email_pf 
			into STRICT	ds_email_destino_w 
			;
 
			CALL enviar_email(ds_titulo_w,ds_comunicado_w,null,ds_email_destino_w,nm_usuario_p,'A');
 
			end;
		end loop;
		end;
	end if;
end if;
 
commit;
 
<<final>> 
ds_segurado_w := ' ';
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_comunic_param_web ( cd_funcao_p bigint, nr_seq_parametro_p bigint, nr_seq_funcao_p bigint, ie_tipo_alteracao_p text, vl_parametro_p text, nr_seq_segurado_p pls_web_param_usuario.nr_seq_segurado%type, nr_seq_usu_estip_p pls_web_param_usuario.nr_seq_usu_estipulante%type, nr_seq_usu_prest_p pls_web_param_usuario.nr_seq_usu_prestador%type, nr_seq_usu_gru_cont_p pls_web_param_usuario.nr_seq_usu_grupo_contrato%type, nm_usuario_param_p pls_web_param_usuario.nm_usuario_param%type, ie_tipo_acesso_p pls_web_param_usuario.ie_tipo_acesso%type, nr_seq_perfil_web_p pls_web_param_usuario.nr_seq_perfil_web%type, nr_seq_contrato_p pls_web_param_contrato.nr_seq_contrato%type, ie_tipo_envio_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
