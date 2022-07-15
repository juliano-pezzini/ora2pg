-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE acertar_duplic_compl_pf ( cd_pessoa_origem_p text, cd_pessoa_destino_p text) AS $body$
DECLARE


ie_tipo_complemento_w		smallint;
nm_contato_w			varchar(60);
ds_endereco_w			varchar(200);
cd_cep_w			varchar(15);
nr_endereco_w			integer;
ds_complemento_w		varchar(40);
ds_bairro_w			varchar(80);
ds_municipio_w			varchar(40);
sg_estado_w			compl_pessoa_fisica.sg_estado%type;
nr_telefone_w			varchar(15);
nr_ramal_w			integer;
ds_observacao_w			varchar(2000);
ds_email_w			varchar(255);
cd_empresa_refer_w		bigint;
cd_profissao_w			bigint;
nr_identidade_w			varchar(15);
nr_cpf_w			varchar(11);
cd_municipio_ibge_w		varchar(6);
ds_setor_trabalho_w		varchar(30);
ds_horario_trabalho_w		varchar(30);
nr_matricula_trabalho_w		varchar(20);
nr_seq_parentesco_w		bigint;
ds_fone_adic_w			varchar(80);
ds_fax_w			varchar(80);
nm_usuario_nrec_w		varchar(15);
nr_seq_pais_w			bigint;
qt_reg_w			bigint;
nr_sequencia_w			compl_pessoa_fisica.nr_sequencia%type;
nr_seq_compl_w			compl_pessoa_fisica.nr_sequencia%type;
nm_usuario_w			varchar(15);
dt_atualizacao_w		timestamp;
dt_atualizacao_log_w		timestamp;
cd_tipo_logradouro_w	compl_pessoa_fisica.cd_tipo_logradouro%type;
nr_ddi_telefone_w		compl_pessoa_fisica.nr_ddi_telefone%type;
nr_ddd_telefone_w		compl_pessoa_fisica.nr_ddd_telefone%type;
nr_ddi_fax_w			compl_pessoa_fisica.nr_ddi_fax%type;
nr_ddd_fax_w			compl_pessoa_fisica.nr_ddd_fax%type;
ds_website_w			compl_pessoa_fisica.ds_website%type;

c01 CURSOR FOR
	SELECT	nr_sequencia,
		ie_tipo_complemento,
		nm_contato,
		ds_endereco,
		cd_cep,
		nr_endereco,
		ds_complemento,
		ds_bairro,
		ds_municipio,
		sg_estado,
		nr_telefone,
		nr_ramal,
		ds_observacao,
		ds_email,
		cd_empresa_refer,
		cd_profissao,
		nr_identidade,
		nr_cpf,
		cd_municipio_ibge,
		ds_setor_trabalho,
		ds_horario_trabalho,
		nr_matricula_trabalho,
		nr_seq_parentesco,
		ds_fone_adic,
		ds_fax,
		nr_seq_pais,
		nm_usuario,
		dt_atualizacao,
		cd_tipo_logradouro,
		nr_ddi_telefone,
		nr_ddd_telefone,
		nr_ddi_fax,
		nr_ddd_fax,
		ds_website
	from	compl_pessoa_fisica
	where	cd_pessoa_fisica	= cd_pessoa_origem_p;


BEGIN
open c01;
loop
fetch c01 into
	nr_seq_compl_w,
	ie_tipo_complemento_w,
	nm_contato_w,
	ds_endereco_w,
	cd_cep_w,
	nr_endereco_w,
	ds_complemento_w,
	ds_bairro_w,
	ds_municipio_w,
	sg_estado_w,
	nr_telefone_w,
	nr_ramal_w,
	ds_observacao_w,
	ds_email_w,
	cd_empresa_refer_w,
	cd_profissao_w,
	nr_identidade_w,
	nr_cpf_w,
	cd_municipio_ibge_w,
	ds_setor_trabalho_w,
	ds_horario_trabalho_w,
	nr_matricula_trabalho_w,
	nr_seq_parentesco_w,
	ds_fone_adic_w,
	ds_fax_w,
	nr_seq_pais_w,
	nm_usuario_w,
	dt_atualizacao_w,
	cd_tipo_logradouro_w,
	nr_ddi_telefone_w,	
	nr_ddd_telefone_w,	
	nr_ddi_fax_w,		
	nr_ddd_fax_w,		
	ds_website_w;		
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_sequencia_w
	from	compl_pessoa_fisica
	where	cd_pessoa_fisica	= cd_pessoa_destino_p
	and	ie_tipo_complemento	= ie_tipo_complemento_w;
	
	dt_atualizacao_log_w	:= clock_timestamp();

	if (nr_sequencia_w > 0) then
		begin		
		update	compl_pessoa_fisica
		set	nm_contato		= coalesce(nm_contato,nm_contato_w),
			cd_cep			= coalesce(cd_cep, cd_cep_w),
			ds_endereco		= coalesce(ds_endereco, ds_endereco_w),
			nr_endereco		= coalesce(nr_endereco, nr_endereco_w),
			ds_complemento		= coalesce(ds_complemento, ds_complemento_w),
			cd_profissao		= coalesce(cd_profissao, cd_profissao_w),
			ds_bairro		= coalesce(ds_bairro, ds_bairro_w),
			cd_empresa_refer	= coalesce(cd_empresa_refer, cd_empresa_refer_w),
			ds_municipio		= coalesce(ds_municipio, ds_municipio_w),
			cd_municipio_ibge	= coalesce(cd_municipio_ibge, cd_municipio_ibge_w),
			sg_estado		= coalesce(sg_estado, sg_estado_w),
			nr_seq_pais		= coalesce(nr_seq_pais, nr_seq_pais_w),
			ds_email		= coalesce(ds_email, ds_email_w),
			nr_telefone		= coalesce(nr_telefone, nr_telefone_w),
			nr_ramal		= coalesce(nr_ramal, nr_ramal_w),
			ds_fax			= coalesce(ds_fax, ds_fax_w),
			ds_fone_adic		= coalesce(ds_fone_adic, ds_fone_adic_w),
			ds_observacao		= coalesce(ds_observacao, ds_observacao_w),
			ds_setor_trabalho	= coalesce(ds_setor_trabalho, ds_setor_trabalho_w),
			ds_horario_trabalho	= coalesce(ds_horario_trabalho, ds_horario_trabalho_w),
			nr_matricula_trabalho	= coalesce(nr_matricula_trabalho, nr_matricula_trabalho_w),
			nr_cpf			= coalesce(nr_cpf, nr_cpf_w),
			nr_identidade		= coalesce(nr_identidade, nr_identidade_w),
			nr_seq_parentesco	= coalesce(nr_seq_parentesco, nr_seq_parentesco_w),			
			cd_tipo_logradouro	= coalesce(cd_tipo_logradouro, cd_tipo_logradouro_w),
			nr_ddi_telefone		= coalesce(nr_ddi_telefone, nr_ddi_telefone_w),
			nr_ddd_telefone		= coalesce(nr_ddd_telefone, nr_ddd_telefone_w),
			nr_ddi_fax			= coalesce(nr_ddi_fax, nr_ddi_fax_w),
			nr_ddd_fax			= coalesce(nr_ddd_fax, nr_ddd_fax_w),
			ds_website			= coalesce(ds_website, ds_website_w)			
		where	cd_pessoa_fisica	= cd_pessoa_destino_p
		and	ie_tipo_complemento	= ie_tipo_complemento_w;
		end;
	else
		begin
		select	coalesce(max(nr_sequencia),0) + 1
		into STRICT	nr_sequencia_w
		from	compl_pessoa_fisica
		where	cd_pessoa_fisica	= cd_pessoa_destino_p;

		insert into compl_pessoa_fisica(	nr_sequencia,
				cd_pessoa_fisica,
				ie_tipo_complemento,
				nm_contato,
				ds_endereco,
				cd_cep,
				nr_endereco,
				ds_complemento,
				ds_bairro,
				ds_municipio,
				sg_estado,
				nr_telefone,
				nr_ramal,
				ds_observacao,
				ds_email,
				cd_empresa_refer,
				cd_profissao,
				nr_identidade,
				nr_cpf,
				cd_municipio_ibge,
				ds_setor_trabalho,
				ds_horario_trabalho,
				nr_matricula_trabalho,
				nr_seq_parentesco,
				ds_fone_adic,
				ds_fax,
				nr_seq_pais,
				nm_usuario,
				dt_atualizacao,
				cd_tipo_logradouro,	
				nr_ddi_telefone,		
				nr_ddd_telefone,		
				nr_ddi_fax,			
				nr_ddd_fax,			
				ds_website)
		values (	nr_sequencia_w,
				cd_pessoa_destino_p,
				ie_tipo_complemento_w,
				nm_contato_w,
				ds_endereco_w,
				cd_cep_w,
				nr_endereco_w,
				ds_complemento_w,
				ds_bairro_w,
				ds_municipio_w,
				sg_estado_w,
				nr_telefone_w,
				nr_ramal_w,
				ds_observacao_w,
				ds_email_w,
				cd_empresa_refer_w,
				cd_profissao_w,
				nr_identidade_w,
				nr_cpf_w,
				cd_municipio_ibge_w,
				ds_setor_trabalho_w,
				ds_horario_trabalho_w,
				nr_matricula_trabalho_w,
				nr_seq_parentesco_w,
				ds_fone_adic_w,
				ds_fax_w,
				nr_seq_pais_w,
				nm_usuario_w,
				clock_timestamp(),
				cd_tipo_logradouro_w,	
				nr_ddi_telefone_w,		
				nr_ddd_telefone_w,		
				nr_ddi_fax_w,			
				nr_ddd_fax_w,			
				ds_website_w);
		end;
	end if;
	
	update  tasy_log_alteracao
	set 	ds_descricao		= substr(CASE WHEN ds_descricao = NULL THEN  wheb_mensagem_pck.get_texto(790113) || ' ' || obter_nome_usuario(wheb_usuario_pck.get_nm_usuario)   ELSE wheb_mensagem_pck.get_texto(790113) || ' ' || obter_nome_usuario(wheb_usuario_pck.get_nm_usuario) || ' - ' || ds_descricao END ,1,255),
		    nm_usuario = (wheb_usuario_pck.get_nm_usuario)
	where 	nm_tabela		= 'COMPL_PESSOA_FISICA'
	and 	ds_chave_composta	= 'CD_PESSOA_FISICA=' || cd_pessoa_destino_p || '#@#@NR_SEQUENCIA=' || nr_sequencia_w
	and 	dt_atualizacao	between dt_atualizacao_log_w and clock_timestamp();
	
	select	count(*)
	into STRICT	qt_reg_w
	from	compl_pessoa_fisica
	where	nr_seq_end_ref	= nr_seq_compl_w
	and	cd_pessoa_end_ref	= cd_pessoa_origem_p;

	if (qt_reg_w > 0) then
		begin
		update	compl_pessoa_fisica
		set	cd_pessoa_end_ref	= cd_pessoa_destino_p,
			nr_seq_end_ref		= nr_sequencia_w
		where	nr_seq_end_ref		= nr_seq_compl_w
		and	cd_pessoa_end_ref	= cd_pessoa_origem_p;
		end;
	end if;
	
	
	end;
end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE acertar_duplic_compl_pf ( cd_pessoa_origem_p text, cd_pessoa_destino_p text) FROM PUBLIC;

