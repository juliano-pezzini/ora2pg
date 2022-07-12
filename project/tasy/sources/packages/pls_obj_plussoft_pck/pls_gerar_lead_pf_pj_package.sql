-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

--Gerar lead para PF e PJ
CREATE OR REPLACE PROCEDURE pls_obj_plussoft_pck.pls_gerar_lead_pf_pj ( cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, cd_cgc_p pessoa_juridica.cd_cgc%type, nr_seq_vendedor_p pls_vendedor.nr_sequencia%type, nr_seq_agente_motivador_p pls_agente_motivador.nr_sequencia%type, nr_seq_origem_agente_p pls_agente_motivador_orig.nr_sequencia%type, nr_seq_segurado_indic_p pls_solicitacao_comercial.nr_seq_segurado_indic%type, cd_pessoa_indicacao_p pls_solicitacao_comercial.cd_pessoa_indicacao%type, nr_celular_p pls_solicitacao_comercial.nr_celular%type, ds_observacao_p pls_solicitacao_comercial.ds_observacao%type, nm_usuario_p text, ie_origem_p text, --Parametros de saida
 ie_retorno_p INOUT bigint, ds_mensagem_erro_p INOUT text ) AS $body$
DECLARE


/* 
ie_origem_p

A - Atualiza dados pessoa
P - Gerar editar proposta

*/
current_setting('pls_obj_plussoft_pck.cd_estabelecimento_w')::smallint		estabelecimento.cd_estabelecimento%type;
nr_seq_origem_agente_w		pls_agente_motivador_orig.nr_sequencia%type;
nr_seq_agente_motivador_w	pls_agente_motivador.nr_sequencia%type;
nr_seq_segurado_indic_w		pls_segurado.nr_sequencia%type;
cd_pessoa_indicacao_w		pessoa_fisica.cd_pessoa_fisica%type;
current_setting('pls_obj_plussoft_pck.nr_seq_vendedor_w')::pls_vendedor.nr_sequencia%type		pls_vendedor.nr_sequencia%type;
nr_seq_solicitacao_w		bigint;
nm_pessoa_fisica_w		varchar(255);
dt_nascimento_w			timestamp;
nr_telefone_w			varchar(40);
ds_email_w			varchar(255);
nr_cpf_w			varchar(14);
nr_ddd_w			varchar(3);
nr_ddi_w			varchar(3);
sg_uf_w				varchar(2);
cd_municipio_ibge_w		varchar(7);
cd_nacionalidade_w		varchar(8);
nr_reg_geral_estrang_w		varchar(30);
nm_contato_w			varchar(50);
nr_telefone_celular_w		varchar(40);
ds_endereco_w			varchar(255);
nr_endereco_w			varchar(10);
ds_complemento_w		varchar(100);
current_setting('pls_obj_plussoft_pck.nr_seq_contrato_w')::bigint		bigint;
qt_idade_w			bigint;
ds_bairro_w			varchar(40);
ds_razao_social_w		pessoa_juridica.ds_razao_social%type;
sg_estado_w			varchar(15);
qt_lead_w			bigint;
cd_cep_w			varchar(10);
nr_seq_tipo_logradouro_w	bigint;
cd_tipo_logradouro_w		varchar(10);


BEGIN
ie_retorno_p := 0;
PERFORM set_config('pls_obj_plussoft_pck.cd_estabelecimento_w', 1, false);

--Agente origem
begin
	select	nr_sequencia
	into STRICT	nr_seq_origem_agente_w
	from	pls_agente_motivador_orig
	where	nr_sequencia = nr_seq_origem_agente_p;
exception
when others then
	nr_seq_origem_agente_w := null;
end;

--Agente motivador
begin
	select	nr_sequencia
	into STRICT	nr_seq_agente_motivador_w
	from	pls_agente_motivador
	where	nr_sequencia = nr_seq_agente_motivador_p;
exception
when others then
	nr_seq_agente_motivador_w := null;
end;
--Segurado indicacao
begin
	select	nr_sequencia
	into STRICT	nr_seq_segurado_indic_w
	from	pls_segurado
	where	nr_sequencia = nr_seq_segurado_indic_p;
exception
when others then
	nr_seq_segurado_indic_w := null;
end;
--Pessoa indicacao
begin
	select	cd_pessoa_fisica
	into STRICT	cd_pessoa_indicacao_w
	from	pessoa_fisica
	where	cd_pessoa_fisica = cd_pessoa_indicacao_p;
exception
when others then
	cd_pessoa_indicacao_w := null;
end;

--Vendedor vinculado
begin
	select	nr_sequencia
	into STRICT	current_setting('pls_obj_plussoft_pck.nr_seq_vendedor_w')::pls_vendedor.nr_sequencia%type
	from	pls_vendedor
	where	nr_sequencia = nr_seq_vendedor_p;
exception
when others then
	PERFORM set_config('pls_obj_plussoft_pck.nr_seq_vendedor_w', null, false);
end;

--PF
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	--Dados PF
	begin
		select	a.nm_pessoa_fisica,
			a.dt_nascimento,
			substr(obter_compl_pf(a.cd_pessoa_fisica,1,'T'),1,40),
			substr(obter_compl_pf(a.cd_pessoa_fisica,1,'M'),1,255),
			substr(a.nr_cpf,1,14),
			coalesce(substr(obter_compl_pf(a.cd_pessoa_fisica,1,'DDT'),1,2),' '),
			coalesce(substr(obter_compl_pf(a.cd_pessoa_fisica,1,'DIT'),1,2),' '),
			substr(obter_compl_pf(a.cd_pessoa_fisica,1,'UF'),1,2),
			substr(obter_compl_pf(a.cd_pessoa_fisica,1,'CDM'),1,7),
			a.cd_nacionalidade,
			a.nr_reg_geral_estrang,
			substr(obter_primeiro_nome(a.nm_pessoa_fisica),1,50),
			a.nr_telefone_celular,
			substr(obter_compl_pf(a.cd_pessoa_fisica,1,'E'),1,40),
			substr(obter_compl_pf(a.cd_pessoa_fisica,1,'NR'),1,10),
			substr(obter_compl_pf(a.cd_pessoa_fisica,1,'CO'),1,100),
			obter_idade(a.dt_nascimento, clock_timestamp(),'A'),
			substr(obter_compl_pf(a.cd_pessoa_fisica,1,'B'),1,40),
			cd_estabelecimento,
			substr(obter_compl_pf(a.cd_pessoa_fisica,1,'CEP'),1,10)
		into STRICT	nm_pessoa_fisica_w,
			dt_nascimento_w,
			nr_telefone_w,
			ds_email_w,
			nr_cpf_w,
			nr_ddd_w,
			nr_ddi_w,
			sg_uf_w,
			cd_municipio_ibge_w,
			cd_nacionalidade_w,
			nr_reg_geral_estrang_w,
			nm_contato_w,
			nr_telefone_celular_w,
			ds_endereco_w,
			nr_endereco_w,
			ds_complemento_w,
			qt_idade_w,
			ds_bairro_w,
			current_setting('pls_obj_plussoft_pck.cd_estabelecimento_w')::smallint,
			cd_cep_w
		from	pessoa_fisica a
		where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p;
		
	exception
	when others then
		--Erro
		ie_retorno_p := 1;
		ds_mensagem_erro_p := substr(wheb_mensagem_pck.get_texto(1110547) || ' ',1,255);
	end;
	
	select 	count(*)
	into STRICT	qt_lead_w
	from 	pls_solicitacao_comercial
	where 	cd_pf_vinculado = cd_pessoa_fisica_p
	and	ie_status = 'PE';
	
	if (qt_lead_w = 0) then
		begin
		--Estabelecimento eh um atributo obrigatorio
		if (current_setting('pls_obj_plussoft_pck.cd_estabelecimento_w')::(smallint IS NOT NULL AND smallint::text <> '')) then
			begin
				select	nextval('pls_solicitacao_comercial_seq')
				into STRICT	nr_seq_solicitacao_w
				;
				insert into pls_solicitacao_comercial(	nr_sequencia, cd_estabelecimento, ie_status, nm_pessoa_fisica, dt_nascimento,
									nr_telefone, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
									ds_email, dt_solicitacao, ie_tipo_contratacao, nr_cpf, ds_observacao, cd_pessoa_indicacao,
									nr_ddi, nr_ddd, sg_uf_municipio, cd_municipio_ibge, cd_nacionalidade,
									nr_reg_geral_estrang, nr_seq_agente_motivador, nm_contato, nr_celular,
									ds_endereco, nr_endereco, ds_complemento, nr_seq_contrato,
									qt_idade, ds_bairro, cd_pf_vinculado, nr_seq_segurado_indic, nr_seq_origem_agente,
									cd_cep)
								values (	nr_seq_solicitacao_w, current_setting('pls_obj_plussoft_pck.cd_estabelecimento_w')::smallint, 'PE', nm_pessoa_fisica_w, dt_nascimento_w,
									coalesce(nr_telefone_w,' '), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p,
									ds_email_w, clock_timestamp(), 'I', nr_cpf_w, ds_observacao_p, cd_pessoa_indicacao_w,
									nr_ddi_w, nr_ddd_w, sg_uf_w, cd_municipio_ibge_w, cd_nacionalidade_w,
									nr_reg_geral_estrang_w, nr_seq_agente_motivador_w, nm_contato_w, nr_telefone_celular_w,
									ds_endereco_w, nr_endereco_w, ds_complemento_w,	current_setting('pls_obj_plussoft_pck.nr_seq_contrato_w')::bigint,
									qt_idade_w, ds_bairro_w, cd_pessoa_fisica_p, nr_seq_segurado_indic_w, nr_seq_origem_agente_w,
									cd_cep_w);
			exception
			when others then
				--Erro
				ie_retorno_p := 1;
				ds_mensagem_erro_p := substr(wheb_mensagem_pck.get_texto(1110341) || ' ' || sqlerrm(SQLSTATE) ,1,255);
			end;
			
			--Precisa ter um vendedor vinculado
			if (current_setting('pls_obj_plussoft_pck.nr_seq_vendedor_w')::pls_vendedor.nr_sequencia%(type IS NOT NULL AND type::text <> '')) then
				insert into pls_solicitacao_vendedor(	nr_sequencia,
									nr_seq_solicitacao,
									nr_seq_vendedor_canal,
									dt_inicio_vigencia,
									dt_atualizacao,
									nm_usuario,
									dt_atualizacao_nrec,
									nm_usuario_nrec,
									cd_estabelecimento)
								values (	nextval('pls_solicitacao_vendedor_seq'),
									nr_seq_solicitacao_w,
									current_setting('pls_obj_plussoft_pck.nr_seq_vendedor_w')::pls_vendedor.nr_sequencia%type,
									clock_timestamp(),
									clock_timestamp(),
									nm_usuario_p,
									clock_timestamp(),
									nm_usuario_p,
									current_setting('pls_obj_plussoft_pck.cd_estabelecimento_w')::smallint);
			end if;
		else
			--Erro
			ie_retorno_p := 1;
			ds_mensagem_erro_p := substr(wheb_mensagem_pck.get_texto(1110342),1,255);
		end if;
		
		--Sucesso
		if (ie_retorno_p = 0) then
			commit;
		end if;
		
		exception
		when others then
			--Erro
			ie_retorno_p := 1;
			ds_mensagem_erro_p := substr(wheb_mensagem_pck.get_texto(1110341) || ' ' || sqlerrm(SQLSTATE) ,1,255);
			--rollback;
		end;
	else
		begin
		--Proposta de adesao
		
		if (ie_origem_p = 'P') then
			begin
			update	pls_solicitacao_comercial
			set	ie_status = 'A'
			where 	cd_pf_vinculado = cd_pessoa_fisica_p
			and	ie_status = 'PE';
			
			--Sucesso
			if (ie_retorno_p = 0) then
				commit;
			end if;
			
			exception
			when others then
				--Erro
				ie_retorno_p := 1;
				ds_mensagem_erro_p := substr(wheb_mensagem_pck.get_texto(1110548, 'DS_ERRO='||sqlerrm(SQLSTATE)) ,1,255);
				--rollback;
			end;
		end if;
		end;
	end if;
--PJ
else
	begin
	
	begin
	select	ds_razao_social,
		nr_telefone,
		ds_email,
		nr_ddd_telefone,
		nr_ddi_telefone,
		sg_estado,
		cd_municipio_ibge,
		ds_endereco,
		nr_endereco,
		ds_complemento,
		ds_bairro,
		cd_cep,
		nr_seq_tipo_logradouro
	into STRICT	ds_razao_social_w,
		nr_telefone_w,
		ds_email_w,
		nr_ddi_w,
		nr_ddd_w,
		sg_estado_w,
		cd_municipio_ibge_w,
		ds_endereco_w,
		nr_endereco_w,
		ds_complemento_w,
		ds_bairro_w,
		cd_cep_w,
		nr_seq_tipo_logradouro_w
	from	pessoa_juridica
	where	cd_cgc = cd_cgc_p  LIMIT 1;
	exception
	when others then
		ds_razao_social_w   	:= null;
		nr_telefone_w	    	:= null;
		ds_email_w	    	:= null;
		nr_ddi_w	    	:= null;
		nr_ddd_w	    	:= null;
		sg_estado_w	    	:= null;
		cd_municipio_ibge_w 	:= null;
		ds_endereco_w		:= null;
		nr_endereco_w		:= null;
		ds_complemento_w	:= null;
		ds_bairro_w		:= null;
		cd_cep_w		:= null;
		nr_seq_tipo_logradouro_w:= null;
	end;
	
	select  max(b.cd_tipo_logradouro)
	into STRICT  	cd_tipo_logradouro_w
	from 	cns_tipo_logradouro a,
		sus_tipo_logradouro b
	where 	upper(a.ds_tipo_logradouro) = upper(b.ds_tipo_logradouro)
	and 	a.nr_sequencia = nr_seq_tipo_logradouro_w;
	
	select 	count(*)
	into STRICT	qt_lead_w
	from 	pls_solicitacao_comercial
	where 	cd_cgc = cd_cgc_p
	and	ie_status = 'PE';
	
	if (qt_lead_w = 0) then
		--Estabelecimento eh um atributo obrigatorio
		if (current_setting('pls_obj_plussoft_pck.cd_estabelecimento_w')::(smallint IS NOT NULL AND smallint::text <> '')) and (ds_razao_social_w IS NOT NULL AND ds_razao_social_w::text <> '') then
			select	nextval('pls_solicitacao_comercial_seq')
			into STRICT	nr_seq_solicitacao_w
			;
			
			insert into pls_solicitacao_comercial(	nr_sequencia, cd_estabelecimento, ie_status, nm_pessoa_fisica,
								dt_nascimento, nr_telefone, dt_atualizacao, nm_usuario,
								dt_atualizacao_nrec, nm_usuario_nrec, ds_email, dt_solicitacao,
								ie_origem_solicitacao, nr_cpf, cd_cgc, cd_cnpj_vinculado, nr_ddd,
								nr_ddi, sg_uf_municipio, cd_municipio_ibge, ie_etapa_solicitacao,
								nr_seq_segurado_indic, nr_seq_origem_agente, nr_seq_agente_motivador, cd_pessoa_indicacao,
								ds_endereco, nr_endereco, ds_complemento, ds_bairro,
								cd_cep, nr_celular, cd_tipo_logradouro, ds_observacao)
						values (	nr_seq_solicitacao_w, current_setting('pls_obj_plussoft_pck.cd_estabelecimento_w')::smallint, 'PE', ds_razao_social_w,
								null, nr_telefone_w, clock_timestamp(), nm_usuario_p,
								clock_timestamp(), nm_usuario_p, ds_email_w, clock_timestamp(),
								'E', null, cd_cgc_p,cd_cgc_p, nr_ddd_w,
								nr_ddi_w, sg_estado_w, cd_municipio_ibge_w,'T',
								nr_seq_segurado_indic_w, nr_seq_origem_agente_w, nr_seq_agente_motivador_w, cd_pessoa_indicacao_w,
								ds_endereco_w, nr_endereco_w, ds_complemento_w, ds_bairro_w,
								cd_cep_w, nr_celular_p, cd_tipo_logradouro_w, ds_observacao_p);
			
			--Precisa ter um vendedor vinculado
			if (current_setting('pls_obj_plussoft_pck.nr_seq_vendedor_w')::pls_vendedor.nr_sequencia%(type IS NOT NULL AND type::text <> '')) then
				insert into pls_solicitacao_vendedor(	nr_sequencia,
									nr_seq_solicitacao,
									nr_seq_vendedor_canal,
									dt_atualizacao,
									nm_usuario,
									dt_atualizacao_nrec,
									nm_usuario_nrec,
									cd_estabelecimento)
								values (	nextval('pls_solicitacao_vendedor_seq'),
									nr_seq_solicitacao_w,
									current_setting('pls_obj_plussoft_pck.nr_seq_vendedor_w')::pls_vendedor.nr_sequencia%type,
									clock_timestamp(),
									nm_usuario_p,
									clock_timestamp(),
									nm_usuario_p,
									current_setting('pls_obj_plussoft_pck.cd_estabelecimento_w')::smallint);
			end if;
		else
			--Erro
			ie_retorno_p := 1;
			ds_mensagem_erro_p := substr(wheb_mensagem_pck.get_texto(1110343),1,255);
		end if;
	else
		begin
		--Proposta de adesao
		if (ie_origem_p = 'P') then
			begin
			update	pls_solicitacao_comercial
			set	ie_status 	= 'A'
			where 	cd_cgc 		= cd_cgc_p
			and	ie_status 	= 'PE';
			
			--Sucesso
			if (ie_retorno_p = 0) then
				commit;
			end if;
			
			exception
			when others then
				--Erro
				ie_retorno_p := 1;
				ds_mensagem_erro_p := substr(wheb_mensagem_pck.get_texto(1110345) || ' ' || sqlerrm(SQLSTATE) ,1,255);
				--rollback;
			end;
		end if;
		end;
	end if;
	
	--Sucesso
	if (ie_retorno_p = 0) then
		commit;
	end if;
	
	exception
	when others then
		--Erro
		ie_retorno_p := 1;
		ds_mensagem_erro_p := substr(wheb_mensagem_pck.get_texto(1110346) || ' ' || sqlerrm(SQLSTATE) ,1,255);
--		rollback;
	end;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obj_plussoft_pck.pls_gerar_lead_pf_pj ( cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, cd_cgc_p pessoa_juridica.cd_cgc%type, nr_seq_vendedor_p pls_vendedor.nr_sequencia%type, nr_seq_agente_motivador_p pls_agente_motivador.nr_sequencia%type, nr_seq_origem_agente_p pls_agente_motivador_orig.nr_sequencia%type, nr_seq_segurado_indic_p pls_solicitacao_comercial.nr_seq_segurado_indic%type, cd_pessoa_indicacao_p pls_solicitacao_comercial.cd_pessoa_indicacao%type, nr_celular_p pls_solicitacao_comercial.nr_celular%type, ds_observacao_p pls_solicitacao_comercial.ds_observacao%type, nm_usuario_p text, ie_origem_p text,  ie_retorno_p INOUT bigint, ds_mensagem_erro_p INOUT text ) FROM PUBLIC;