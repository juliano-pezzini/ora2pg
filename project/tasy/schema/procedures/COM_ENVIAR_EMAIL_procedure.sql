-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE com_enviar_email ( ds_email_dest_p text, ds_email_origem_p text, ds_email_cc_p text, cd_cnpj_p bigint, ds_titulo_p text, ds_observacao_p text, ie_historico_p text, nr_sequencia_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text) AS $body$
DECLARE

		
ds_conteudo_w		varchar(4000);
ds_email_destino_w	varchar(2000);
nm_pessoa_fisica_w	varchar(60);
nr_seq_historico_w	bigint;
ds_titulo_w		varchar(255);
ds_tipo_w		varchar(40);
ds_razao_social_w	pessoa_juridica.ds_razao_social%type;
ds_endereco_w		varchar(100);
ds_cidade_w		varchar(40);
sg_estado_w		pessoa_juridica.sg_estado%type;
cd_cep_w		varchar(15);
ds_telefone_w		varchar(15);
ds_natureza_w		varchar(254);
ds_fase_venda_w		varchar(254);
ie_tipo_w		varchar(254);
ie_status_w		varchar(254);
ds_classificacao_w	varchar(254);
ds_historico_w		text;


BEGIN
if (ds_email_dest_p IS NOT NULL AND ds_email_dest_p::text <> '') and (ds_email_origem_p IS NOT NULL AND ds_email_origem_p::text <> '') and (cd_cnpj_p IS NOT NULL AND cd_cnpj_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	
	ds_email_destino_w := ds_email_dest_p;
	
	if (ds_email_cc_p IS NOT NULL AND ds_email_cc_p::text <> '') then
		begin
		ds_email_destino_w := ds_email_destino_w || ',' || ds_email_cc_p;
		end;
	end if;
	
	select	c.ds_tipo_pessoa,
		a.ds_razao_social,
		a.ds_endereco,
		a.ds_municipio,
		a.sg_estado,
		a.cd_cep,
		a.nr_telefone,
		obter_valor_dominio(1082, b.ie_natureza),
		obter_valor_dominio(1314,b.ie_fase_venda),
		obter_valor_dominio(1316,b.ie_tipo),
		obter_valor_dominio(1264,b.ie_status_neg),
		obter_valor_dominio(1315,b.ie_classificacao)
	into STRICT	ds_tipo_w,
		ds_razao_social_w,
		ds_endereco_w,
		ds_cidade_w,
		sg_estado_w,
		cd_cep_w,
		ds_telefone_w,
		ds_natureza_w,
		ds_fase_venda_w,
		ie_tipo_w,
		ie_status_w,
		ds_classificacao_w
	from	pessoa_juridica a,
		com_cliente b,
		tipo_pessoa_juridica c
	where	a.cd_cgc = b.cd_cnpj
	and	a.cd_tipo_pessoa = c.cd_tipo_pessoa
	and	b.cd_cnpj = cd_cnpj_p
	and	b.nr_sequencia = nr_sequencia_p;

	ds_conteudo_w	:=	Wheb_mensagem_pck.get_texto(306246, 'DS_TIPO_W=' || ds_tipo_w || ';' ||
															'CD_CNPJ_P=' || cd_cnpj_p || ';' ||
															'DS_RAZAO_SOCIAL_W=' || ds_razao_social_w || ';' ||
															'DS_ENDERECO_W=' || ds_endereco_w || ';' ||
															'DS_CIDADE_W=' || ds_cidade_w || ';' ||
															'SG_ESTADO_W=' || sg_estado_w || ';' ||
															'CD_CEP_W=' || cd_cep_w || ';' ||
															'DS_TELEFONE_W=' || ds_telefone_w || ';' ||
															'DS_NATUREZA_W=' || ds_natureza_w || ';' ||
															'DS_FASE_VENDA_W=' || ds_fase_venda_w || ';' ||
															'IE_TIPO_W=' || ie_tipo_w || ';' ||
															'IE_STATUS_W=' || ie_status_w || ';' ||
															'DS_CLASSIFICACAO_W=' || ds_classificacao_w);

	if (ds_observacao_p <> '') then
		begin
		ds_conteudo_w	:= ds_conteudo_w || Wheb_mensagem_pck.get_texto(306184, null) || ds_observacao_p; -- Observacao adicional
		end;
	end if;
	
	if (ds_titulo_p IS NOT NULL AND ds_titulo_p::text <> '') then
		begin
		ds_titulo_w	:= ds_titulo_p;
		end;
	else	
		begin
		ds_titulo_w	:= Wheb_mensagem_pck.get_texto(306181, null); -- Dados Comercial Wheb
		end;
	end if;
	
	if (ie_historico_p = 'S') then
		begin
		
		select 	nr_sequencia
		into STRICT	nr_seq_historico_w
		from (
			SELECT	nr_sequencia
			from	com_cliente_hist
			where	nr_seq_cliente = nr_sequencia_p
			order by dt_historico desc) alias1 LIMIT 1;
		
		nr_seq_historico_w := com_obter_historico_email(nr_seq_historico_w, nm_usuario_p);
		
		select	ds_texto
		into STRICT	ds_historico_w
		from	tasy_conversao_rtf
		where	nr_sequencia = nr_seq_historico_w;
		
		CALL enviar_email(
			ds_titulo_w,
			ds_conteudo_w || chr(13) || chr(10) || Wheb_mensagem_pck.get_texto(184007 , null) || ' ' || chr(13) || chr(10) || ds_historico_w, -- Ultimo historico: 
			ds_email_origem_p,
			ds_email_destino_w,
			nm_usuario_p,
			'A');
		end;
	else
		begin
		CALL enviar_email(
			ds_titulo_w,
			ds_conteudo_w,
			ds_email_origem_p,
			ds_email_destino_w,
			nm_usuario_p,
			'A');
		end;	
	end if;	
	
	ds_email_destino_w := ds_email_dest_p;
	
	if (ds_email_cc_p IS NOT NULL AND ds_email_cc_p::text <> '') then
		begin
		ds_email_destino_w := ds_email_destino_w || '; CC: ' || ds_email_cc_p;
		end;
	end if;
	
	select	substr(obter_nome_pf(cd_pessoa_fisica),1,255)
	into STRICT	nm_pessoa_fisica_w
	from	pessoa_fisica
	where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	
	ds_conteudo_w	:= Wheb_mensagem_pck.get_texto(306185, 'NM_PESSOA_FISICA=' || nm_pessoa_fisica_w || ';' || 'DS_RAZAO_SOCIAL=' || ds_razao_social_w); -- Origem - (#@NM_PESSOA_FISIC#@ - #@DS_RAZAO_SOCIAL#@)
	ds_conteudo_w	:= ds_conteudo_w || chr(13) || chr(10) || ds_observacao_p;	
	
	insert into com_cliente_envio(
			nr_sequencia,
			nr_seq_cliente,
			dt_atualizacao,
			nm_usuario,
			dt_envio,
			ie_tipo_envio,
			ds_destino,
			ds_observacao,
			dt_atualizacao_nrec,
			nm_usuario_nrec)
	values (
			nextval('com_cliente_envio_seq'),
			nr_sequencia_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			'E',
			substr(ds_email_destino_w,1,60),
			substr(ds_conteudo_w,1,255),
			clock_timestamp(),
			nm_usuario_p);
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE com_enviar_email ( ds_email_dest_p text, ds_email_origem_p text, ds_email_cc_p text, cd_cnpj_p bigint, ds_titulo_p text, ds_observacao_p text, ie_historico_p text, nr_sequencia_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text) FROM PUBLIC;

