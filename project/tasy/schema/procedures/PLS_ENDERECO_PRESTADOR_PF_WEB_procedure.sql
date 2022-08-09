-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_endereco_prestador_pf_web ( nr_seq_prestador_p bigint, nm_pessoa_fisica INOUT text, ie_estado_civil INOUT text, dt_nascimento INOUT text, nr_cpf INOUT text, nr_identidade INOUT text, dt_emissao_ci INOUT text, sg_emissora_ci INOUT text, nr_seq_pais INOUT text, ds_orgao_emissor_ci INOUT text, ds_email INOUT text, nr_reg_geral_estrang INOUT text, cd_cep INOUT text, nr_endereco INOUT text, ds_endereco INOUT text, ds_complemento INOUT text, ds_bairro INOUT text, cd_municipio_ibge INOUT text, ds_municipio INOUT text, sg_estado INOUT text, nr_ddd_telefone INOUT text, nr_ddi_telefone INOUT text, nr_telefone INOUT text, ds_fone_adic INOUT text, nr_ddi_celular INOUT text, nr_ddd_celular INOUT text, nr_telefone_celular INOUT text, cd_banco INOUT text, cd_agencia_bancaria INOUT text, ie_digito_agencia INOUT text, nr_conta INOUT text, nr_digito_conta INOUT text, ie_tipo_complemento INOUT bigint, nr_seq_compl_pf_tel_adic INOUT bigint ) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Obter o endereço do prestador PF, conforme o tipo de endereço selecionado no cadastro da função OPS - Prestadores

-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  x ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_tipo_endereco_w		pls_prestador.ie_tipo_endereco%type;
ie_tipo_complemento_w		compl_pessoa_fisica.ie_tipo_complemento%type;
nm_pessoa_fisica_w		pessoa_fisica.nm_pessoa_fisica%type;
ie_estado_civil_w		pessoa_fisica.ie_estado_civil%type;
dt_nascimento_w			pessoa_fisica.dt_nascimento%type;
nr_cpf_w			pessoa_fisica.nr_cpf%type;
nr_identidade_w			pessoa_fisica.nr_identidade%type;
dt_emissao_ci_w			pessoa_fisica.dt_emissao_ci%type;
sg_emissora_ci_w 		pessoa_fisica.sg_emissora_ci%type;
nr_seq_pais_w			pessoa_fisica.nr_seq_pais%type;
ds_orgao_emissor_ci_w		pessoa_fisica.ds_orgao_emissor_ci%type;
ds_email_w			compl_pessoa_fisica.ds_email%type;
nr_reg_geral_estrang_w		pessoa_fisica.nr_reg_geral_estrang%type;
cd_cep_w			compl_pessoa_fisica.cd_cep%type;
nr_endereco_w			compl_pessoa_fisica.nr_endereco%type;
ds_endereco_w			compl_pessoa_fisica.ds_endereco%type;
ds_complemento_w		compl_pessoa_fisica.ds_complemento%type;
ds_bairro_w			compl_pessoa_fisica.ds_bairro%type;
cd_municipio_ibge_w		compl_pessoa_fisica.cd_municipio_ibge%type;
ds_municipio_w			compl_pessoa_fisica.ds_municipio%type;
sg_estado_w			compl_pessoa_fisica.sg_estado%type;
nr_ddd_telefone_w		compl_pessoa_fisica.nr_ddd_telefone%type;
nr_ddi_telefone_w		compl_pessoa_fisica.nr_ddi_telefone%type;
nr_telefone_w			compl_pessoa_fisica.nr_telefone%type;
ds_fone_adic_w			compl_pessoa_fisica.ds_fone_adic%type;
nr_ddi_celular_w		pessoa_fisica.nr_ddi_celular%type;
nr_ddd_celular_w		pessoa_fisica.nr_ddd_celular%type;
nr_telefone_celular_w		pessoa_fisica.nr_telefone_celular%type;
cd_banco_w			pessoa_fisica_conta.cd_banco%type;
cd_agencia_bancaria_w		pessoa_fisica_conta.cd_agencia_bancaria%type;
ie_digito_agencia_w		pessoa_fisica_conta.ie_digito_agencia%type;
nr_conta_w			pessoa_fisica_conta.nr_conta%type;
nr_digito_conta_w		pessoa_fisica_conta.nr_digito_conta%type;
nr_seq_tipo_compl_adic_w	pls_prestador.nr_seq_tipo_compl_adic%type;
nr_seq_compl_pf_tel_adic_w	pls_prestador.nr_seq_compl_pf_tel_adic%type;

C01 CURSOR FOR
	SELECT	a.nm_pessoa_fisica,
		a.ie_estado_civil,
		to_char(a.dt_nascimento, 'dd/mm/yyyy') dt_nascimento,
		a.nr_cpf,
		a.nr_identidade,
		to_char(a.dt_emissao_ci, 'dd/mm/yyyy') dt_emissao_ci,
		a.sg_emissora_ci,
		a.nr_seq_pais,
		a.ds_orgao_emissor_ci,
		b.ds_email,
		a.nr_reg_geral_estrang,
		b.cd_cep,
		coalesce(b.nr_endereco, b.ds_compl_end) nr_endereco,
		b.ds_endereco,
		b.ds_complemento,
		b.ds_bairro,
		b.cd_municipio_ibge,
		b.ds_municipio,
		b.sg_estado,
		b.nr_ddd_telefone,
		b.nr_ddi_telefone,
		b.nr_telefone,
		b.ds_fone_adic,
		a.nr_ddi_celular,
		a.nr_ddd_celular,
		a.nr_telefone_celular,
		obter_conta_pessoa(a.cd_pessoa_fisica, 'F','B') cd_banco,
		obter_conta_pessoa(a.cd_pessoa_fisica, 'F','A') cd_agencia_bancaria,
		obter_conta_pessoa(a.cd_pessoa_fisica, 'F','DA') ie_digito_agencia,
		obter_conta_pessoa(a.cd_pessoa_fisica, 'F','C') nr_conta,
		obter_conta_pessoa(a.cd_pessoa_fisica, 'F','DC') nr_digito_conta
	from	pessoa_fisica a,
		compl_pessoa_fisica b
	where	a.cd_pessoa_fisica		= b.cd_pessoa_fisica
	and	a.cd_pessoa_fisica		= pls_obter_dados_prestador(nr_seq_prestador_p,'PF')
	and	b.ie_tipo_complemento		= ie_tipo_complemento_w
	and (b.nr_seq_tipo_compl_adic 	= nr_seq_tipo_compl_adic_w
	or 	coalesce(nr_seq_tipo_compl_adic_w::text, '') = '');

C02 CURSOR FOR
	SELECT	a.nm_pessoa_fisica,
		a.ie_estado_civil,
		to_char(a.dt_nascimento, 'dd/mm/yyyy') dt_nascimento,
		a.nr_cpf,
		a.nr_identidade,
		to_char(a.dt_emissao_ci, 'dd/mm/yyyy') dt_emissao_ci,
		a.sg_emissora_ci,
		a.nr_seq_pais,
		a.ds_orgao_emissor_ci,
		c.ds_email,
		a.nr_reg_geral_estrang,
		c.cd_cep,
		c.nr_endereco,
		c.ds_endereco,
		c.ds_complemento,
		c.ds_bairro,
		c.cd_municipio_ibge,
		c.ds_municipio,
		c.sg_estado,
		c.nr_ddd_telefone,
		c.nr_telefone,
		a.nr_ddi_celular,
		a.nr_ddd_celular,
		a.nr_telefone_celular,
		obter_conta_pessoa(a.cd_pessoa_fisica, 'F','B') cd_banco,
		obter_conta_pessoa(a.cd_pessoa_fisica, 'F','A') cd_agencia_bancaria,
		obter_conta_pessoa(a.cd_pessoa_fisica, 'F','DA') ie_digito_agencia,
		obter_conta_pessoa(a.cd_pessoa_fisica, 'F','C') nr_conta,
		obter_conta_pessoa(a.cd_pessoa_fisica, 'F','DC') nr_digito_conta
	from	pessoa_fisica a,
		compl_pessoa_fisica b,
		compl_pf_tel_adic c
	where	a.cd_pessoa_fisica		= b.cd_pessoa_fisica
	and	b.cd_pessoa_fisica		= c.cd_pessoa_fisica
	and	a.cd_pessoa_fisica		= pls_obter_dados_prestador(nr_seq_prestador_p,'PF')
	and	b.ie_tipo_complemento		= ie_tipo_complemento_w
	and (c.nr_sequencia		 	= nr_seq_compl_pf_tel_adic_w);


BEGIN
	begin
		select	coalesce(ie_tipo_endereco, 'PFR')
		into STRICT	ie_tipo_endereco_w
		from	pls_prestador
		where 	nr_sequencia	= nr_seq_prestador_p;
	exception
	when others then
		ie_tipo_endereco_w 	:= null;
	end;

if (ie_tipo_endereco_w IS NOT NULL AND ie_tipo_endereco_w::text <> '') then
	begin
		--Adicional
		if (ie_tipo_endereco_w = 'PFA') then

			ie_tipo_complemento_w	:= 9;

			select 	max(nr_seq_tipo_compl_adic)
			into STRICT	nr_seq_tipo_compl_adic_w
			from	pls_prestador
			where 	nr_sequencia = nr_seq_prestador_p;

			open C01;
			loop
				fetch C01 into
					nm_pessoa_fisica_w,
					ie_estado_civil_w,
					dt_nascimento_w,
					nr_cpf_w,
					nr_identidade_w,
					dt_emissao_ci_w,
					sg_emissora_ci_w,
					nr_seq_pais_w,
					ds_orgao_emissor_ci_w,
					ds_email_w,
					nr_reg_geral_estrang_w,
					cd_cep_w,
					nr_endereco_w,
					ds_endereco_w,
					ds_complemento_w,
					ds_bairro_w,
					cd_municipio_ibge_w,
					ds_municipio_w,
					sg_estado_w,
					nr_ddd_telefone_w,
					nr_ddi_telefone_w,
					nr_telefone_w,
					ds_fone_adic_w,
					nr_ddi_celular_w,
					nr_ddd_celular_w,
					nr_telefone_celular_w,
					cd_banco_w,
					cd_agencia_bancaria_w,
					ie_digito_agencia_w,
					nr_conta_w,
					nr_digito_conta_w;
				EXIT WHEN NOT FOUND; /* apply on C01 */
			end loop;
			close C01;
		end if;

		-- Comercial
		if (ie_tipo_endereco_w = 'PFC') then
			ie_tipo_complemento_w	:= 2;

			select	max(nr_seq_compl_pf_tel_adic)
			into STRICT	nr_seq_compl_pf_tel_adic_w
			from	pls_prestador
			where 	nr_sequencia = 	nr_seq_prestador_p;

			if (nr_seq_compl_pf_tel_adic_w IS NOT NULL AND nr_seq_compl_pf_tel_adic_w::text <> '') then
				open C02;
				loop
					fetch C02 into
						nm_pessoa_fisica_w,
						ie_estado_civil_w,
						dt_nascimento_w,
						nr_cpf_w,
						nr_identidade_w,
						dt_emissao_ci_w,
						sg_emissora_ci_w,
						nr_seq_pais_w,
						ds_orgao_emissor_ci_w,
						ds_email_w,
						nr_reg_geral_estrang_w,
						cd_cep_w,
						nr_endereco_w,
						ds_endereco_w,
						ds_complemento_w,
						ds_bairro_w,
						cd_municipio_ibge_w,
						ds_municipio_w,
						sg_estado_w,
						nr_ddd_telefone_w,
						nr_telefone_w,
						nr_ddi_celular_w,
						nr_ddd_celular_w,
						nr_telefone_celular_w,
						cd_banco_w,
						cd_agencia_bancaria_w,
						ie_digito_agencia_w,
						nr_conta_w,
						nr_digito_conta_w;
					EXIT WHEN NOT FOUND; /* apply on C02 */
				end loop;
				close C02;
			else
				open C01;
				loop
					fetch C01 into
						nm_pessoa_fisica_w,
						ie_estado_civil_w,
						dt_nascimento_w,
						nr_cpf_w,
						nr_identidade_w,
						dt_emissao_ci_w,
						sg_emissora_ci_w,
						nr_seq_pais_w,
						ds_orgao_emissor_ci_w,
						ds_email_w,
						nr_reg_geral_estrang_w,
						cd_cep_w,
						nr_endereco_w,
						ds_endereco_w,
						ds_complemento_w,
						ds_bairro_w,
						cd_municipio_ibge_w,
						ds_municipio_w,
						sg_estado_w,
						nr_ddd_telefone_w,
						nr_ddi_telefone_w,
						nr_telefone_w,
						ds_fone_adic_w,
						nr_ddi_celular_w,
						nr_ddd_celular_w,
						nr_telefone_celular_w,
						cd_banco_w,
						cd_agencia_bancaria_w,
						ie_digito_agencia_w,
						nr_conta_w,
						nr_digito_conta_w;
					EXIT WHEN NOT FOUND; /* apply on C01 */
				end loop;
				close C01;
			end if;
		end if;

		-- Residencial
		if (ie_tipo_endereco_w = 'PFR') then
			ie_tipo_complemento_w	:= 1;
			open C01;
			loop
				fetch C01 into
					nm_pessoa_fisica_w,
					ie_estado_civil_w,
					dt_nascimento_w,
					nr_cpf_w,
					nr_identidade_w,
					dt_emissao_ci_w,
					sg_emissora_ci_w,
					nr_seq_pais_w,
					ds_orgao_emissor_ci_w,
					ds_email_w,
					nr_reg_geral_estrang_w,
					cd_cep_w,
					nr_endereco_w,
					ds_endereco_w,
					ds_complemento_w,
					ds_bairro_w,
					cd_municipio_ibge_w,
					ds_municipio_w,
					sg_estado_w,
					nr_ddd_telefone_w,
					nr_ddi_telefone_w,
					Nr_Telefone_w,
					ds_fone_adic_w,
					nr_ddi_celular_w,
					nr_ddd_celular_w,
					nr_telefone_celular_w,
					cd_banco_w,
					cd_agencia_bancaria_w,
					ie_digito_agencia_w,
					nr_conta_w,
					nr_digito_conta_w;
				EXIT WHEN NOT FOUND; /* apply on C01 */
			end loop;
			close C01;
		end if;
	exception
	when others then
		nm_pessoa_fisica_w		:= null;
		ie_estado_civil_w		:= null;
		dt_nascimento_w			:= null;
		nr_cpf_w			:= null;
		nr_identidade_w			:= null;
		dt_emissao_ci_w			:= null;
		sg_emissora_ci_w		:= null;
		nr_seq_pais_w			:= null;
		ds_orgao_emissor_ci_w		:= null;
		ds_email_w			:= null;
		nr_reg_geral_estrang_w		:= null;
		cd_cep_w			:= null;
		nr_endereco_w			:= null;
		ds_endereco_w			:= null;
		ds_complemento_w		:= null;
		ds_bairro_w			:= null;
		cd_municipio_ibge_w		:= null;
		ds_municipio_w			:= null;
		sg_estado_w			:= null;
		nr_ddd_telefone_w		:= null;
		nr_ddi_telefone_w		:= null;
		nr_telefone_w			:= null;
		ds_fone_adic_w			:= null;
		nr_ddi_celular_w		:= null;
		nr_ddd_celular_w		:= null;
		nr_telefone_celular_w		:= null;
		cd_banco_w			:= null;
		cd_agencia_bancaria_w		:= null;
		ie_digito_agencia_w		:= null;
		nr_conta_w			:= null;
		nr_digito_conta_w		:= null;
		nr_seq_compl_pf_tel_adic_w	:= null;
	end;

	nm_pessoa_fisica		:= nm_pessoa_fisica_w;
	ie_estado_civil			:= ie_estado_civil_w;
	dt_nascimento			:= to_char(dt_nascimento_w, 'dd/mm/yyyy');
	nr_cpf				:= nr_cpf_w;
	nr_identidade 			:= nr_identidade_w;
	dt_emissao_ci 			:= dt_emissao_ci_w;
	sg_emissora_ci 			:= sg_emissora_ci_w;
	nr_seq_pais 			:= nr_seq_pais_w;
	ds_orgao_emissor_ci		:= ds_orgao_emissor_ci_w;
	ds_email			:= ds_email_w;
	nr_reg_geral_estrang		:= nr_reg_geral_estrang_w;
	cd_cep				:= cd_cep_w;
	nr_endereco			:= nr_endereco_w;
	ds_endereco			:= ds_endereco_w;
	ds_complemento			:= ds_complemento_w;
	ds_bairro 			:= ds_bairro_w;
	cd_municipio_ibge 		:= cd_municipio_ibge_w;
	ds_municipio 			:= ds_municipio_w;
	sg_estado 			:= sg_estado_w;
	nr_ddd_telefone			:= nr_ddd_telefone_w;
	nr_ddi_telefone			:= nr_ddi_telefone_w;
	nr_telefone			:= nr_telefone_w;
	ds_fone_adic			:= ds_fone_adic_w;
	nr_ddi_celular			:= nr_ddi_celular_w;
	nr_ddd_celular			:= nr_ddd_celular_w;
	nr_telefone_celular		:= nr_telefone_celular_w;
	cd_banco			:= cd_banco_w;
	cd_agencia_bancaria		:= cd_agencia_bancaria_w;
	ie_digito_agencia		:= ie_digito_agencia_w;
	nr_conta			:= nr_conta_w;
	nr_digito_conta			:= nr_digito_conta_w;
	ie_tipo_complemento		:= ie_tipo_complemento_w;
	nr_seq_compl_pf_tel_adic	:= coalesce(nr_seq_compl_pf_tel_adic_w,0);

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_endereco_prestador_pf_web ( nr_seq_prestador_p bigint, nm_pessoa_fisica INOUT text, ie_estado_civil INOUT text, dt_nascimento INOUT text, nr_cpf INOUT text, nr_identidade INOUT text, dt_emissao_ci INOUT text, sg_emissora_ci INOUT text, nr_seq_pais INOUT text, ds_orgao_emissor_ci INOUT text, ds_email INOUT text, nr_reg_geral_estrang INOUT text, cd_cep INOUT text, nr_endereco INOUT text, ds_endereco INOUT text, ds_complemento INOUT text, ds_bairro INOUT text, cd_municipio_ibge INOUT text, ds_municipio INOUT text, sg_estado INOUT text, nr_ddd_telefone INOUT text, nr_ddi_telefone INOUT text, nr_telefone INOUT text, ds_fone_adic INOUT text, nr_ddi_celular INOUT text, nr_ddd_celular INOUT text, nr_telefone_celular INOUT text, cd_banco INOUT text, cd_agencia_bancaria INOUT text, ie_digito_agencia INOUT text, nr_conta INOUT text, nr_digito_conta INOUT text, ie_tipo_complemento INOUT bigint, nr_seq_compl_pf_tel_adic INOUT bigint ) FROM PUBLIC;
