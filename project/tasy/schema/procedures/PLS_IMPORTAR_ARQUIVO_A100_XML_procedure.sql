-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_importar_arquivo_a100_xml ( nm_arquivo_p text, nm_usuario_p text) AS $body$
DECLARE


ds_conteudo_w		w_importar_xml_a100.ds_conteudo%type;
dt_geracao_w		varchar(255);
cd_uni_destino_w	varchar(255);
cd_uni_origem_w		varchar(255);
dt_ini_mov_w		varchar(255);
dt_fim_mov_w		varchar(255);
nr_versao_transacao_w	varchar(255);
nm_arquivo_w		varchar(255);
cd_unimed_w		varchar(255);
id_benef_w		varchar(255);
cd_cpf_w		varchar(255);
nm_completo_w		varchar(255);
dt_nascimento_w		timestamp;
tp_contr_local_w	varchar(255);
dt_ini_comp_risco_w	timestamp;
dt_fim_comp_risco_w	timestamp;
nr_seq_intercambio_w	ptu_intercambio.nr_sequencia%type;
cd_usuario_plano_w	pls_segurado_carteira.cd_usuario_plano%type;
nr_seq_segurado_w	pls_segurado.nr_sequencia%type;
ds_ptu_w		varchar(4);
qt_registros_w		integer;
ds_info_complemento_w	varchar(4000);
qt_registros_lidos_w	integer;

--Empresa
nr_seq_empresa_w	ptu_intercambio_empresa.nr_sequencia%type;
cd_cnpj_w		ptu_intercambio_empresa.cd_cgc_cpf%type;
cd_caepf_w		ptu_intercambio_empresa.cd_caepf%type;
cd_filial_w		ptu_intercambio_empresa.cd_filial%type;
nm_empr_comp_w		ptu_intercambio_empresa.ds_razao_social%type;
nm_fantasia_empr_w	ptu_intercambio_empresa.nm_fantasia_empr%type;
nm_empr_abre_w		ptu_intercambio_empresa.nm_empr_abrev%type;
cd_insc_est_w		ptu_intercambio_empresa.nr_insc_estadual%type;
ie_contrato_local_w	ptu_intercambio_empresa.ie_contrato_local%type;
dt_inc_unimed_w		ptu_intercambio_empresa.dt_inclusao%type;
dt_exc_unimed_w		ptu_intercambio_empresa.dt_exclusao%type;
cd_empr_ori_w		ptu_intercambio_empresa.cd_empresa_origem%type;
ds_info_endereco_w	varchar(4000);
cd_tipo_logradouro_w	ptu_intercambio_empresa.cd_tipo_logradouro%type;
ds_endereco_w		ptu_intercambio_empresa.ds_endereco%type;
nr_endereco_w		ptu_intercambio_empresa.nr_endereco%type;
ds_complemento_w	ptu_intercambio_empresa.ds_complemento%type;
ds_bairro_w		ptu_intercambio_empresa.ds_bairro%type;
cd_municipio_ibge_w	ptu_intercambio_empresa.cd_municipio_ibge%type;
cd_cep_w		ptu_intercambio_empresa.cd_cep%type;
ds_telefone_w		varchar(4000);
nr_ddd_w		ptu_intercambio_empresa.nr_ddd%type;
nr_telefone_w		ptu_intercambio_empresa.nr_telefone%type;

--Plano
cd_plano_origem_w	ptu_intercambio_plano.cd_plano_origem%type;
ds_plano_origem_w	ptu_intercambio_plano.ds_plano_origem%type;
ie_abrangencia_w	ptu_intercambio_plano.ie_abrangencia%type;
cd_plano_intercambio_w	ptu_intercambio_plano.cd_plano_intercambio%type;
cd_segmentacao_w	ptu_intercambio_plano.cd_segmentacao%type;
nr_ind_reembolso_w	ptu_intercambio_plano.nr_ind_reembolso%type;
ie_tipo_contratacao_w	ptu_intercambio_plano.ie_natureza%type;
ie_regulamentacao_w	ptu_intercambio_plano.ie_plano%type;
cd_ope_ans_w		ptu_intercambio_plano.cd_ope_ans%type;
cd_prod_ans_w		ptu_intercambio_plano.cd_prod_ans%type;
dt_inclusao_w		ptu_intercambio_plano.dt_inclusao%type;
dt_exclusao_w		ptu_intercambio_plano.dt_exclusao%type;

--Beneficiário
nr_seq_interc_benef_w	ptu_intercambio_benef.nr_sequencia%type;
cd_familia_w		ptu_intercambio_benef.cd_familia%type;
nm_beneficiario_w	ptu_intercambio_benef.nm_beneficiario%type;
nm_benef_abreviado_w	ptu_intercambio_benef.nm_benef_abreviado%type;
nm_social_w		ptu_intercambio_benef.nm_social%type;
nm_social_abreviado_w	ptu_intercambio_benef.nm_social_abreviado%type;
ie_sexo_w		ptu_intercambio_benef.ie_sexo%type;
ie_tipo_genero_social_w	ptu_intercambio_benef.ie_tipo_genero_social%type;
nr_cpf_w		ptu_intercambio_benef.cd_cgc_cpf%type;
ie_estado_civil_w	ptu_intercambio_benef.ie_estado_civil%type;
nm_mae_benef_w		ptu_intercambio_benef.nm_mae_benef%type;
ie_recem_nascido_w	ptu_intercambio_benef.ie_recem_nascido%type;
cd_dependencia_w	ptu_intercambio_benef.cd_dependencia%type;
cd_titular_plano_w	ptu_intercambio_benef.cd_titular_plano%type;
nr_cartao_nac_sus_w	ptu_intercambio_benef.nr_cartao_nac_sus%type;
nr_pis_pasep_w		ptu_intercambio_benef.nr_pis_pasep%type;
nr_contrato_w		ptu_intercambio_benef.nr_contrato%type;
dt_inclusao_benef_w	ptu_intercambio_benef.dt_inclusao%type;
dt_exclusao_benef_w	ptu_intercambio_benef.dt_exclusao%type;
nr_matricula_w		ptu_intercambio_benef.nr_matricula%type;
dt_validade_carteira_w	ptu_intercambio_benef.dt_validade_carteira%type;
cd_local_atendimento_w	ptu_intercambio_benef.cd_local_atendimento%type;
cd_lotacao_w		ptu_intercambio_benef.cd_lotacao%type;
ds_lotacao_w		ptu_intercambio_benef.ds_lotacao%type;
dt_comp_risco_w		ptu_intercambio_benef.dt_comp_risco%type;
dt_inclusao_plano_dest_w ptu_intercambio_benef.dt_inclusao_plano_dest%type;
nr_vigencia_origem_w	ptu_intercambio_benef.nr_vigencia_origem%type;
ie_exclusao_rn412_w	ptu_intercambio_benef.ie_exclusao_rn412%type;
nr_rg_w			ptu_intercambio_benef.nr_rg%type;
ds_orgao_emissor_ci_w	ptu_intercambio_benef.ds_orgao_emissor_ci%type;
sg_uf_rg_w		ptu_intercambio_benef.sg_uf_rg%type;
ds_rg_w			varchar(2000);

--Carência
ds_carencia_benef_w	varchar(2000);
cd_tipo_cobertura_w	ptu_beneficiario_carencia.cd_tipo_cobertura%type;
dt_fim_carencia_w	ptu_beneficiario_carencia.dt_fim_carencia%type;

--Produtos agregados
ds_produtos_agregados_w	varchar(2000);
cd_tipo_produto_w	ptu_benef_plano_agregado.cd_tipo_produto%type;
ds_produto_w		ptu_benef_plano_agregado.ds_produto%type;

--Endereço
ds_inf_endereco_benef_w	varchar(4000);
ie_tipo_endereco_w	ptu_beneficiario_compl.ie_tipo_endereco%type;
ds_endereco_benef_w	ptu_beneficiario_compl.ds_endereco%type;
nr_endereco_benef_w	ptu_beneficiario_compl.nr_endereco%type;
ds_complemento_benef_w	ptu_beneficiario_compl.ds_complemento%type;
ds_bairro_benef_w	ptu_beneficiario_compl.ds_bairro%type;
cd_municipio_benef_w	ptu_beneficiario_compl.cd_municipio_ibge%type;
cd_cep_benef_w		ptu_beneficiario_compl.cd_cep%type;
nm_municipio_benef_w	ptu_beneficiario_compl.nm_municipio%type;
sg_uf_benef_w		ptu_beneficiario_compl.sg_uf%type;
cd_tipo_lograd_benef_w	ptu_beneficiario_compl.cd_tipo_logradouro%type;

--Contato
ds_inf_telefone_benef_w	varchar(4000);
ie_tipo_telefone_w	ptu_beneficiario_contato.ie_tipo_telefone%type;
nr_ddd_benef_w		ptu_beneficiario_contato.nr_ddd%type;
nr_telefone_benef_w	ptu_beneficiario_contato.nr_telefone%type;
ds_inf_email_benef_w	varchar(4000);
ie_tipo_email_w		ptu_beneficiario_contato.ie_tipo_email%type;
ds_email_benef_w	ptu_beneficiario_contato.ds_email%type;

--Pré-existências
ds_preex_benef_w	varchar(4000);
cd_cid_w		ptu_benef_preexistencia.cd_cid%type;
dt_fim_carencia_cid_w	ptu_benef_preexistencia.dt_fim_carencia%type;

C01 CURSOR FOR
	SELECT	ds_conteudo,
		ie_tipo_registro,
		ie_tipo_compartilhamento,
		ie_tipo_repasse,
		ie_tipo_movimento
	from	w_importar_xml_a100
	where	nm_usuario = nm_usuario_p
	order by 2;

BEGIN

for c_01 in C01 loop
	begin
	ds_conteudo_w	:= c_01.ds_conteudo;
	if (position('ptu:'  c_01.ds_conteudo) > 0 ) then
		ds_ptu_w := 'ptu:';
	else
		ds_ptu_w := '';
	end if;
	
	if (c_01.ie_tipo_registro = '1') then --Cabeçalho
		dt_geracao_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'dt_geracao>');
		cd_uni_destino_w	:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'cd_Uni_Destino>');
		cd_uni_origem_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'cd_Uni_Origem>');
		dt_ini_mov_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'dt_Ini_Mov>');
		dt_fim_mov_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'dt_Fim_Mov>');
		nr_versao_transacao_w	:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'nrVerTra_PTU>');
		nm_arquivo_w		:= obter_nome_arquivo(nm_arquivo_p, 'N');
		
		select	nextval('ptu_intercambio_seq')
		into STRICT	nr_seq_intercambio_w
		;
		
		insert	into	ptu_intercambio(	nr_sequencia, dt_geracao, dt_atualizacao,
				nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
				ie_tipo_mov, dt_mov_inicio, dt_mov_fim,
				ie_operacao, nr_versao_transacao, nr_seq_envio,
				nr_seq_lote_envio, qt_registros_lidos, cd_unimed_destino,
				cd_unimed_origem, nm_arquivo, dt_importacao,
				dt_geracao_contrato, dt_geracao_arquivo, ie_tipo_contrato,
				dt_importacao_retorno, ds_hash_a100)
			values (nr_seq_intercambio_w, to_date(dt_geracao_w,'YYYYmmdd'), clock_timestamp(),
				nm_usuario_p, clock_timestamp(), nm_usuario_p,
				'P', to_date(dt_ini_mov_w,'YYYYmmdd'), to_date(dt_fim_mov_w,'YYYYmmdd'),
				'R', nr_versao_transacao_w, null,
				null, 0, cd_uni_destino_w,
				cd_uni_origem_w, nm_arquivo_w, clock_timestamp(),
				null, null, null,
				null, '');
	elsif (c_01.ie_tipo_registro = '4') and (c_01.ie_tipo_compartilhamento = '2') then --Beneficiário Habitual
		cd_unimed_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'cd_Unimed>');
		id_benef_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'id_Benef>');
		cd_cpf_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'cd_cpf>');
		nm_completo_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'nm_compl_benef>');
		dt_nascimento_w		:= to_date(pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'dt_Nasc>'),'YYYYmmdd');
		tp_contr_local_w	:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'tp_contr_local>');
		dt_ini_comp_risco_w	:= to_date(pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'dt_ini_comp_risco>'),'YYYYmmdd');
		dt_fim_comp_risco_w	:= to_date(pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'dt_fim_comp_risco>'),'YYYYmmdd');
		
		cd_usuario_plano_w	:= lpad(cd_unimed_w,4,'0') || lpad(id_benef_w,13,'0');
		
		select	max(a.nr_sequencia)
		into STRICT	nr_seq_segurado_w
		from	pls_segurado		a,
			pls_segurado_carteira	b
		where	a.nr_sequencia		= b.nr_seq_segurado
		and	b.cd_usuario_plano	= cd_usuario_plano_w;
		
		insert	into	ptu_intercambio_benef_simp(	nr_sequencia, cd_beneficiario, cd_cpf,
				cd_unimed, dt_atualizacao, dt_atualizacao_nrec,
				dt_compartilhamento, dt_fim_compartilhamento, dt_nascimento,
				ie_tipo_contrato_local, nm_completo, nm_usuario,
				nm_usuario_nrec, nr_seq_intercambio, nr_seq_segurado,
				cd_usuario_plano, ie_status)
			values (nextval('ptu_intercambio_benef_simp_seq'), id_benef_w, cd_cpf_w,
				cd_unimed_w, clock_timestamp(), clock_timestamp(),
				dt_ini_comp_risco_w, dt_fim_comp_risco_w, dt_nascimento_w,
				tp_contr_local_w, nm_completo_w, nm_usuario_p,
				nm_usuario_p, nr_seq_intercambio_w, nr_seq_segurado_w,
				cd_usuario_plano_w, 'I');
	elsif (c_01.ie_tipo_registro = '2') then --Empresa
		cd_cnpj_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'cd_cnpj>');
		cd_caepf_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'cd_caepf>');
		cd_filial_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'cd_filial>');
		nm_empr_comp_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'nm_empr_comp>');
		nm_fantasia_empr_w	:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'nm_fantasia_empr>');
		nm_empr_abre_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'nm_empr_abre>');
		cd_insc_est_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'cd_insc_est>');
		ie_contrato_local_w	:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'tp_contr_local>');
		dt_inc_unimed_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'dt_inc_unimed>');
		dt_exc_unimed_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'dt_exc_unimed>');
		cd_empr_ori_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'cd_empr_ori>');
		
		ds_telefone_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'telefone>'); --Pode ter mais de um registro
		nr_ddd_w		:= pls_extrair_dado_tag_xml(ds_telefone_w,'<'||ds_ptu_w||'nr_ddd>');
		nr_telefone_w		:= pls_extrair_dado_tag_xml(ds_telefone_w,'<'||ds_ptu_w||'nr_fone>');
		
		ds_info_endereco_w	:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'info_endereco>'); --Pode ter mais de um registro
		cd_tipo_logradouro_w	:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'tp_logradouro>');
		ds_endereco_w		:= pls_extrair_dado_tag_xml(ds_info_endereco_w,'<'||ds_ptu_w||'ds_lograd>');
		nr_endereco_w		:= pls_extrair_dado_tag_xml(ds_info_endereco_w,'<'||ds_ptu_w||'nr_lograd>');
		ds_complemento_w	:= pls_extrair_dado_tag_xml(ds_info_endereco_w,'<'||ds_ptu_w||'compl_lograd>');
		ds_bairro_w		:= pls_extrair_dado_tag_xml(ds_info_endereco_w,'<'||ds_ptu_w||'ds_bairro>');
		cd_municipio_ibge_w	:= pls_extrair_dado_tag_xml(ds_info_endereco_w,'<'||ds_ptu_w||'cd_munic>');
		cd_cep_w		:= pls_extrair_dado_tag_xml(ds_info_endereco_w,'<'||ds_ptu_w||'nr_cep>');
		
		if (cd_cnpj_w IS NOT NULL AND cd_cnpj_w::text <> '') then
			select	count(1)
			into STRICT	qt_registros_w
			from	ptu_intercambio_empresa
			where	nr_seq_intercambio = nr_seq_intercambio_w
			and	cd_cgc_cpf = cd_cnpj_w;
		elsif (cd_caepf_w IS NOT NULL AND cd_caepf_w::text <> '') then
			select	count(1)
			into STRICT	qt_registros_w
			from	ptu_intercambio_empresa
			where	nr_seq_intercambio = nr_seq_intercambio_w
			and	cd_caepf = cd_caepf_w;
		end if;
		
		if (qt_registros_w = 0) then
			insert	into	ptu_intercambio_empresa(	nr_sequencia, nr_seq_intercambio, dt_atualizacao,
					nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
					cd_cgc_cpf, cd_caepf, cd_filial,
					ds_razao_social, nm_empr_abrev, nr_insc_estadual,
					dt_inclusao, dt_exclusao, cd_empresa_origem,
					ie_tipo_pessoa, ds_endereco, nr_endereco,
					ds_complemento, ds_bairro, cd_municipio_ibge,
					cd_cep, nr_ddd, nr_telefone,
					cd_tipo_logradouro, nm_fantasia_empr, ie_contrato_local )
				values (	nextval('ptu_intercambio_empresa_seq'), nr_seq_intercambio_w, clock_timestamp(),
					nm_usuario_p, clock_timestamp(), nm_usuario_p,
					cd_cnpj_w, cd_caepf_w, cd_filial_w,
					nm_empr_comp_w, nm_empr_abre_w, cd_insc_est_w,
					dt_inc_unimed_w, dt_exc_unimed_w, cd_empr_ori_w,
					'1', ds_endereco_w, nr_endereco_w,
					ds_complemento_w, ds_bairro_w, cd_municipio_ibge_w,
					cd_cep_w, nr_ddd_w, nr_telefone_w,
					cd_tipo_logradouro_w, nm_fantasia_empr_w, ie_contrato_local_w );
		end if;
	elsif (c_01.ie_tipo_registro = '3') then --Plano
		cd_plano_origem_w	:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'cd_plano_origem>');
		ds_plano_origem_w	:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'ds_plano_origem>');
		cd_cnpj_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'cd_cnpj>');
		cd_caepf_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'cd_caepf>');
		ie_abrangencia_w	:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'tp_abrangencia>');
		cd_plano_intercambio_w	:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'cd_plano_inter>');
		cd_segmentacao_w	:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'seg_plano>');
		nr_ind_reembolso_w	:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'nr_ind_reembolso>');
		ie_tipo_contratacao_w	:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'tp_contratacao>');
		ie_regulamentacao_w	:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'id_reg_plano_ans>');
		cd_ope_ans_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'cd_ope_ans>');
		cd_prod_ans_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'cd_prod_ans>');
		dt_inclusao_w		:= to_date(pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'dt_inc_unimed>'),'YYYYmmdd');
		dt_exclusao_w		:= to_date(pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'dt_exc_unimed>'),'YYYYmmdd');
		
		if (cd_cnpj_w IS NOT NULL AND cd_cnpj_w::text <> '') then
			select	max(nr_sequencia)
			into STRICT	nr_seq_empresa_w
			from	ptu_intercambio_empresa
			where	nr_seq_intercambio = nr_seq_intercambio_w
			and	cd_cgc_cpf = cd_cnpj_w;
		elsif (cd_caepf_w IS NOT NULL AND cd_caepf_w::text <> '') then
			select	max(nr_sequencia)
			into STRICT	nr_seq_empresa_w
			from	ptu_intercambio_empresa
			where	nr_seq_intercambio = nr_seq_intercambio_w
			and	cd_caepf = cd_caepf_w;
		end if;
		
		if (nr_seq_empresa_w IS NOT NULL AND nr_seq_empresa_w::text <> '') then
			select	count(1)
			into STRICT	qt_registros_w
			from	ptu_intercambio_plano
			where	nr_seq_empresa	= nr_seq_empresa_w
			and	cd_plano_intercambio = cd_plano_intercambio_w
			and	ie_natureza	= ie_tipo_contratacao_w
			and	ie_abrangencia	= ie_abrangencia_w
			and	ie_plano	= ie_regulamentacao_w
			and	cd_ope_ans	= cd_ope_ans_w
			and	cd_prod_ans	= cd_prod_ans_w
			and	cd_plano_origem	= cd_plano_origem_w;
			
			if (qt_registros_w = 0) then
				insert	into	ptu_intercambio_plano(	nr_sequencia, nr_seq_empresa, dt_atualizacao,
						nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
						cd_plano_origem, ds_plano_origem, cd_plano_intercambio,
						dt_inclusao, dt_exclusao, nr_ind_reembolso,
						ie_natureza, ie_abrangencia, ie_plano,
						cd_ope_ans, cd_prod_ans, cd_segmentacao )
					values (	nextval('ptu_intercambio_plano_seq'), nr_seq_empresa_w, clock_timestamp(),
						nm_usuario_p, clock_timestamp(), nm_usuario_p,
						cd_plano_origem_w, ds_plano_origem_w, cd_plano_intercambio_w,
						dt_inclusao_w, dt_exclusao_w, nr_ind_reembolso_w,
						ie_tipo_contratacao_w, ie_abrangencia_w, ie_regulamentacao_w,
						cd_ope_ans_w, cd_prod_ans_w, cd_segmentacao_w );
			end if;
		end if;
	elsif (c_01.ie_tipo_registro = '4') and (c_01.ie_tipo_compartilhamento = '1') then --Beneficiário repasse
		cd_unimed_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'cd_Unimed>');
		id_benef_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'id_Benef>');
		cd_cnpj_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'cd_cnpj>');
		cd_caepf_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'cd_caepf>');
		cd_plano_origem_w	:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'cd_plano_origem>');
		cd_familia_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'cd_fami>');
		nm_beneficiario_w	:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'nm_compl_benef>');
		nm_benef_abreviado_w	:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'nm_benef>');
		nm_social_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'nm_social>');
		nm_social_abreviado_w	:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'nm_social_cartao>');
		dt_nascimento_w		:= to_date(pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'dt_Nasc>'),'YYYYmmdd');
		ie_sexo_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'tp_Sexo>');
		ie_tipo_genero_social_w	:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'genero_social>');
		nr_cpf_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'cd_cpf>');
		ie_estado_civil_w	:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'cd_est_civil>');
		nm_mae_benef_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'nm_mae>');
		ie_recem_nascido_w	:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'id_nato>');
		cd_dependencia_w	:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'cd_depe>');
		cd_titular_plano_w	:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'id_benef_tit>');
		nr_cartao_nac_sus_w	:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'cd_cns>');
		nr_pis_pasep_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'pis_pasep>');
		nr_contrato_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'nr_contrato>');
		dt_inclusao_benef_w	:= to_date(pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'dt_inc_unimed>'),'YYYYmmdd');
		dt_exclusao_benef_w	:= to_date(pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'dt_exc_unimed>'),'YYYYmmdd');
		nr_matricula_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'nr_matricula>');
		dt_validade_carteira_w	:= to_date(pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'dt_val_carteira>'),'YYYYmmdd');
		cd_local_atendimento_w	:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'cd_lcat>');
		cd_lotacao_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'cd_lotacao>');
		ds_lotacao_w		:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'ds_lotacao>');
		dt_comp_risco_w		:= to_date(pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'dt_comp_risco>'),'YYYYmmdd');
		dt_fim_comp_risco_w	:= to_date(pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'dt_fim_com_risco>'),'YYYYmmdd');
		dt_inclusao_plano_dest_w:= to_date(pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'dt_incl_plano>'),'YYYYmmdd');
		nr_vigencia_origem_w	:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'nr_vig_origem>');
		ie_exclusao_rn412_w	:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'id_excl_RN412>');
		
		ds_rg_w			:= pls_extrair_dado_tag_xml(c_01.ds_conteudo,'<'||ds_ptu_w||'cd_rg>');
		nr_rg_w			:= pls_extrair_dado_tag_xml(ds_rg_w,'<'||ds_ptu_w||'cd_ident>');
		ds_orgao_emissor_ci_w	:= pls_extrair_dado_tag_xml(ds_rg_w,'<'||ds_ptu_w||'orgao_emissor>');
		sg_uf_rg_w		:= pls_extrair_dado_tag_xml(ds_rg_w,'<'||ds_ptu_w||'cd_uf>');
		
		cd_plano_intercambio_w	:= 0; --Revisar - Não tem o campo no manual do PTU
		
		
		if (cd_cnpj_w IS NOT NULL AND cd_cnpj_w::text <> '') then
			select	max(nr_sequencia)
			into STRICT	nr_seq_empresa_w
			from	ptu_intercambio_empresa
			where	nr_seq_intercambio = nr_seq_intercambio_w
			and	cd_cgc_cpf = cd_cnpj_w;
		elsif (cd_caepf_w IS NOT NULL AND cd_caepf_w::text <> '') then
			select	max(nr_sequencia)
			into STRICT	nr_seq_empresa_w
			from	ptu_intercambio_empresa
			where	nr_seq_intercambio = nr_seq_intercambio_w
			and	cd_caepf = cd_caepf_w;
		end if;
		
		if (nr_seq_empresa_w IS NOT NULL AND nr_seq_empresa_w::text <> '') then
			insert	into	ptu_intercambio_benef(	nr_sequencia, nr_seq_empresa, dt_atualizacao,
					nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
					cd_unimed, cd_usuario_plano, cd_plano_origem,
					cd_familia, nm_beneficiario, nm_benef_abreviado,
					nm_social, nm_social_abreviado, dt_nascimento,
					ie_sexo, ie_tipo_genero_social, cd_cgc_cpf,
					ie_estado_civil, nm_mae_benef, ie_recem_nascido,
					cd_dependencia, cd_titular_plano, nr_cartao_nac_sus,
					nr_pis_pasep, dt_inclusao, dt_exclusao,
					nr_matricula, dt_validade_carteira, cd_local_atendimento,
					cd_lotacao, ds_lotacao, dt_comp_risco,
					dt_fim_repasse, dt_inclusao_plano_dest, nr_vigencia_origem,
					ie_exclusao_rn412, cd_plano_intercambio, dt_repasse,
					ie_repasse, ie_tipo_registro, ie_tipo_compartilhamento,
					ie_status, nr_rg, ds_orgao_emissor_ci, sg_uf_rg,
					nr_contrato )
				values (	nextval('ptu_intercambio_benef_seq'), nr_seq_empresa_w, clock_timestamp(),
					nm_usuario_p, clock_timestamp(), nm_usuario_p,
					cd_unimed_w, id_benef_w, cd_plano_origem_w,
					cd_familia_w, nm_beneficiario_w, nm_benef_abreviado_w,
					nm_social_w, nm_social_abreviado_w, dt_nascimento_w,
					ie_sexo_w, ie_tipo_genero_social_w, nr_cpf_w,
					ie_estado_civil_w, nm_mae_benef_w, ie_recem_nascido_w,
					cd_dependencia_w, cd_titular_plano_w, nr_cartao_nac_sus_w,
					nr_pis_pasep_w, dt_inclusao_benef_w, dt_exclusao_benef_w,
					nr_matricula_w, dt_validade_carteira_w, cd_local_atendimento_w,
					cd_lotacao_w, ds_lotacao_w, dt_comp_risco_w,
					dt_fim_comp_risco_w, dt_inclusao_plano_dest_w, nr_vigencia_origem_w,
					ie_exclusao_rn412_w, cd_plano_intercambio_w, dt_comp_risco_w,
					c_01.ie_tipo_repasse, c_01.ie_tipo_movimento, c_01.ie_tipo_compartilhamento,
					'I', nr_rg_w, ds_orgao_emissor_ci_w, sg_uf_rg_w,
					nr_contrato_w )
				returning nr_sequencia into nr_seq_interc_benef_w;
			
			--Carências
			ds_carencia_benef_w	:= pls_extrair_dado_tag_xml(ds_conteudo_w,'<'||ds_ptu_w||'carenciadobeneficiario>');
			ds_conteudo_w		:= replace(replace(ds_conteudo_w,ds_carencia_benef_w,null),'<carenciadobeneficiario></carenciadobeneficiario>',null);
			while(ds_carencia_benef_w IS NOT NULL AND ds_carencia_benef_w::text <> '') loop
				begin
				cd_tipo_cobertura_w	:= pls_extrair_dado_tag_xml(ds_carencia_benef_w,'<'||ds_ptu_w||'tp_cobertura>');
				dt_fim_carencia_w	:= to_date(pls_extrair_dado_tag_xml(ds_carencia_benef_w,'<'||ds_ptu_w||'dt_fim_carencia>'),'YYYYmmdd');
				
				insert	into	ptu_beneficiario_carencia(	nr_sequencia, nr_seq_beneficiario, dt_atualizacao,
						nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
						cd_tipo_cobertura, dt_fim_carencia)
					values (	nextval('ptu_beneficiario_carencia_seq'), nr_seq_interc_benef_w, clock_timestamp(),
						nm_usuario_p, clock_timestamp(), nm_usuario_p,
						cd_tipo_cobertura_w, dt_fim_carencia_w);
				
				ds_carencia_benef_w	:= pls_extrair_dado_tag_xml(ds_conteudo_w,'<'||ds_ptu_w||'carenciadobeneficiario>');
				ds_conteudo_w		:= replace(replace(ds_conteudo_w,ds_carencia_benef_w,null),'<carenciadobeneficiario></carenciadobeneficiario>',null);
				end;
			end loop;
			
			--Produtos agregados
			ds_produtos_agregados_w	:= pls_extrair_dado_tag_xml(ds_conteudo_w,'<'||ds_ptu_w||'moduloopbenef>');
			ds_conteudo_w		:= replace(replace(ds_conteudo_w,ds_produtos_agregados_w,null),'<moduloopbenef></moduloopbenef>',null);
			while(ds_produtos_agregados_w IS NOT NULL AND ds_produtos_agregados_w::text <> '') loop
				begin
				cd_tipo_produto_w	:= pls_extrair_dado_tag_xml(ds_produtos_agregados_w,'<'||ds_ptu_w||'tp_produto>');
				ds_produto_w		:= pls_extrair_dado_tag_xml(ds_produtos_agregados_w,'<'||ds_ptu_w||'ds_produto>');
				
				insert	into	ptu_benef_plano_agregado(	nr_sequencia, nr_seq_beneficiario, dt_atualizacao,
						nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
						cd_tipo_produto, ds_produto)
					values (	nextval('ptu_benef_plano_agregado_seq'), nr_seq_interc_benef_w, clock_timestamp(),
						nm_usuario_p, clock_timestamp(), nm_usuario_p,
						cd_tipo_produto_w, ds_produto_w);
				
				ds_produtos_agregados_w	:= pls_extrair_dado_tag_xml(ds_conteudo_w,'<'||ds_ptu_w||'moduloopbenef>');
				ds_conteudo_w		:= replace(replace(ds_conteudo_w,ds_produtos_agregados_w,null),'<moduloopbenef></moduloopbenef>',null);
				end;
			end loop;
			
			--Complemento
			ds_info_complemento_w	:= pls_extrair_dado_tag_xml(ds_conteudo_w,'<'||ds_ptu_w||'complementoscadastrais>');
			
			--Endereço
			ds_inf_endereco_benef_w	:= pls_extrair_dado_tag_xml(ds_info_complemento_w,'<'||ds_ptu_w||'endereco>');
			ds_info_complemento_w	:= replace(replace(ds_info_complemento_w,ds_inf_endereco_benef_w,null),'<endereco></endereco>',null);
			while(ds_inf_endereco_benef_w IS NOT NULL AND ds_inf_endereco_benef_w::text <> '') loop
				begin
				ie_tipo_endereco_w	:= pls_extrair_dado_tag_xml(ds_inf_endereco_benef_w,'<'||ds_ptu_w||'tp_end>');
				cd_tipo_lograd_benef_w	:= pls_extrair_dado_tag_xml(ds_inf_endereco_benef_w,'<'||ds_ptu_w||'tp_logradouro>');
				ds_endereco_benef_w	:= pls_extrair_dado_tag_xml(ds_inf_endereco_benef_w,'<'||ds_ptu_w||'ds_lograd>');
				nr_endereco_benef_w	:= pls_extrair_dado_tag_xml(ds_inf_endereco_benef_w,'<'||ds_ptu_w||'nr_lograd>');
				ds_complemento_benef_w	:= pls_extrair_dado_tag_xml(ds_inf_endereco_benef_w,'<'||ds_ptu_w||'compl_lograd>');
				ds_bairro_benef_w	:= pls_extrair_dado_tag_xml(ds_inf_endereco_benef_w,'<'||ds_ptu_w||'ds_bairro>');
				cd_municipio_benef_w	:= pls_extrair_dado_tag_xml(ds_inf_endereco_benef_w,'<'||ds_ptu_w||'cd_munic>');
				cd_cep_benef_w		:= pls_extrair_dado_tag_xml(ds_inf_endereco_benef_w,'<'||ds_ptu_w||'nr_cep>');
				
				select	max(ds_municipio),
					max(ds_unidade_federacao)
				into STRICT	nm_municipio_benef_w,
					sg_uf_benef_w
				from	sus_municipio
				where	cd_municipio_ibge = cd_municipio_benef_w;
				
				insert	into	ptu_beneficiario_compl(	nr_sequencia, nr_seq_beneficiario, dt_atualizacao,
						nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
						cd_cep, ds_endereco, nr_endereco,
						ds_bairro, ds_complemento, cd_municipio_ibge,
						nm_municipio, sg_uf, ie_tipo_endereco,
						cd_tipo_logradouro )
					values (	nextval('ptu_beneficiario_compl_seq'), nr_seq_interc_benef_w, clock_timestamp(),
						nm_usuario_p, clock_timestamp(), nm_usuario_p,
						cd_cep_benef_w, ds_endereco_benef_w, nr_endereco_benef_w,
						ds_bairro_benef_w, ds_complemento_benef_w, cd_municipio_benef_w,
						nm_municipio_benef_w, sg_uf_benef_w, ie_tipo_endereco_w,
						cd_tipo_lograd_benef_w );
				
				ds_inf_endereco_benef_w	:= pls_extrair_dado_tag_xml(ds_info_complemento_w,'<'||ds_ptu_w||'endereco>');
				ds_info_complemento_w	:= replace(replace(ds_info_complemento_w,ds_inf_endereco_benef_w,null),'<endereco></endereco>',null);
				end;
			end loop;
			
			--Telefone
			ds_inf_telefone_benef_w	:= pls_extrair_dado_tag_xml(ds_info_complemento_w,'<'||ds_ptu_w||'telefone>');
			ds_info_complemento_w	:= replace(replace(ds_info_complemento_w,ds_inf_telefone_benef_w,null),'<telefone></telefone>',null);
			while(ds_inf_telefone_benef_w IS NOT NULL AND ds_inf_telefone_benef_w::text <> '') loop
				begin
				ie_tipo_telefone_w	:= pls_extrair_dado_tag_xml(ds_inf_telefone_benef_w,'<'||ds_ptu_w||'tp_fone>');
				nr_ddd_benef_w		:= pls_extrair_dado_tag_xml(ds_inf_telefone_benef_w,'<'||ds_ptu_w||'nr_ddd>');
				nr_telefone_benef_w	:= pls_extrair_dado_tag_xml(ds_inf_telefone_benef_w,'<'||ds_ptu_w||'nr_fone>');
				
				insert	into	ptu_beneficiario_contato(	nr_sequencia, nr_seq_beneficiario, dt_atualizacao,
						nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
						ie_tipo_contato, ie_tipo_telefone, nr_ddd,
						nr_telefone )
					values (	nextval('ptu_beneficiario_contato_seq'), nr_seq_interc_benef_w, clock_timestamp(),
						nm_usuario_p, clock_timestamp(), nm_usuario_p,
						'T', ie_tipo_telefone_w, nr_ddd_benef_w,
						nr_telefone_benef_w );
				
				ds_inf_telefone_benef_w	:= pls_extrair_dado_tag_xml(ds_info_complemento_w,'<'||ds_ptu_w||'telefone>');
				ds_info_complemento_w	:= replace(replace(ds_info_complemento_w,ds_inf_telefone_benef_w,null),'<telefone></telefone>',null);
				end;
			end loop;
			
			--E-mail
			ds_inf_email_benef_w	:= pls_extrair_dado_tag_xml(ds_info_complemento_w,'<'||ds_ptu_w||'email>');
			ds_info_complemento_w	:= replace(replace(ds_info_complemento_w,ds_inf_email_benef_w,null),'<email></email>',null);
			while(ds_inf_email_benef_w IS NOT NULL AND ds_inf_email_benef_w::text <> '') loop
				begin
				ie_tipo_email_w		:= pls_extrair_dado_tag_xml(ds_inf_email_benef_w,'<'||ds_ptu_w||'tp_email>');
				ds_email_benef_w	:= pls_extrair_dado_tag_xml(ds_inf_email_benef_w,'<'||ds_ptu_w||'end_email>');
				
				insert	into	ptu_beneficiario_contato(	nr_sequencia, nr_seq_beneficiario, dt_atualizacao,
						nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
						ie_tipo_contato, ie_tipo_email, ds_email )
					values (	nextval('ptu_beneficiario_contato_seq'), nr_seq_interc_benef_w, clock_timestamp(),
						nm_usuario_p, clock_timestamp(), nm_usuario_p,
						'E', ie_tipo_email_w, ds_email_benef_w );
				
				ds_inf_email_benef_w	:= pls_extrair_dado_tag_xml(ds_info_complemento_w,'<'||ds_ptu_w||'email>');
				ds_info_complemento_w	:= replace(replace(ds_info_complemento_w,ds_inf_email_benef_w,null),'<email></email>',null);
				end;
			end loop;
			
			--Pré-existências
			ds_preex_benef_w	:= pls_extrair_dado_tag_xml(ds_conteudo_w,'<'||ds_ptu_w||'preex_benef>');
			ds_conteudo_w		:= replace(replace(ds_conteudo_w,ds_preex_benef_w,null),'<preex_benef></preex_benef>',null);
			while(ds_preex_benef_w IS NOT NULL AND ds_preex_benef_w::text <> '') loop
				begin
				cd_cid_w		:= pls_extrair_dado_tag_xml(ds_preex_benef_w,'<'||ds_ptu_w||'cd_CID>');
				dt_fim_carencia_cid_w	:= to_date(pls_extrair_dado_tag_xml(ds_preex_benef_w,'<'||ds_ptu_w||'dt_fim_carencia>'),'YYYYmmdd');
				
				insert	into	ptu_benef_preexistencia(	nr_sequencia, nr_seq_beneficiario, dt_atualizacao,
						nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
						cd_cid, dt_fim_carencia )
					values (	nextval('ptu_benef_preexistencia_seq'), nr_seq_interc_benef_w, clock_timestamp(),
						nm_usuario_p, clock_timestamp(), nm_usuario_p,
						cd_cid_w, dt_fim_carencia_cid_w );
				
				ds_preex_benef_w	:= pls_extrair_dado_tag_xml(ds_conteudo_w,'<'||ds_ptu_w||'preex_benef>');
				ds_conteudo_w		:= replace(replace(ds_conteudo_w,ds_preex_benef_w,null),'<preex_benef></preex_benef>',null);
				end;
			end loop;
		end if;
	end if;
	
	end;
end loop;

CALL ptu_definir_tipo_benef(nr_seq_intercambio_w, null, wheb_usuario_pck.get_cd_estabelecimento, nm_usuario_p);

select	sum(1)
into STRICT	qt_registros_lidos_w
from	w_importar_xml_a100
where	nm_usuario = nm_usuario_p
and	ie_tipo_registro = '4';

update	ptu_intercambio
set	qt_registros_lidos	= qt_registros_lidos_w
where	nr_sequencia		= nr_seq_intercambio_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_importar_arquivo_a100_xml ( nm_arquivo_p text, nm_usuario_p text) FROM PUBLIC;

