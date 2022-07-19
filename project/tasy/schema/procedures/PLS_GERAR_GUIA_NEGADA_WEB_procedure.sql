-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_guia_negada_web (nr_sequencia_autor_p bigint, ds_dir_padrao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_guia_w			varchar(20);
cd_guia_principal_w		varchar(20);
cd_ans_w			varchar(20);
cd_senha_w			varchar(20);
dt_autorizacao_w		timestamp;
dt_solicitacao_w		timestamp;
dt_validade_senha_w		timestamp;
dt_emissao_w			timestamp;
nr_seq_plano_w			bigint;
nr_seq_segurado_w		bigint;
cd_medico_solicitante_w		varchar(10);
nr_seq_prestador_w		bigint;
cd_usuario_plano_w		varchar(30);
dt_validade_carteira_w		timestamp;
cd_pessoa_fisica_w		varchar(10);
ds_plano_w			varchar(255);
ie_carater_internacao_w		varchar(1);
nr_seq_guia_w			bigint;
nr_cartao_nac_sus_w		varchar(60);
nm_pessoa_fisica_w		varchar(255);
sg_conselho_w			varchar(20);
cd_doenca_cid_w			varchar(10);
ds_diagnostico_w		varchar(2000);
cd_tabela_relat_w		varchar(2);
ds_indicacao_w			varchar(255);
ie_tipo_consulta_w		pls_guia_plano.ie_tipo_consulta%type;

cgc_exec_w			varchar(14);
cpf_exec_w			varchar(50);
nm_contratado_exec_w		varchar(255);
ds_logradouro_w			varchar(255);
nm_municipio_w			varchar(255);
sg_estado_w			pessoa_juridica.sg_estado%type;
cd_municipio_ibge_w		varchar(15);
cd_cep_w			varchar(50);
cd_cnes_w			varchar(20);

qt_proc_guia_w 			bigint;
nr_seq_apresentacao_w		bigint;
nr_seq_guia_proc_w		bigint;
cd_procedimento_w		bigint;
ds_procedimento_w		varchar(255);
ie_origem_proced_w		bigint;
qt_solicitada_w			pls_guia_plano_proc.qt_solicitada%type;
qt_autorizada_w			pls_guia_plano_proc.qt_autorizada%type;
nr_cpf_w			varchar(11);
nr_crm_w			varchar(20);
uf_crm_w			medico.uf_crm%type;
cd_cbo_w			varchar(10);
nm_medico_solicitante_w		varchar(255);
ds_observacao_w			varchar(4000);

ie_tipo_compl_prest_w		varchar(4);
ds_endereco_w			varchar(255);
ds_complemento_w		varchar(255);
ds_bairro_w			varchar(255);
ds_email_w			varchar(255);
ds_website_w			varchar(255);
ds_fax_w			varchar(80);
nr_telefone_w			varchar(30);
ds_fone_adic_w			varchar(255);
nr_ddi_telefone_w		varchar(6);
nr_ddd_telefone_w		varchar(6);
nr_endereco_w			varchar(5);
nr_ramal_w			integer;
nr_ddd_fax_w			varchar(3);
ds_municipio_w			varchar(40);
cd_prestador_exec_w		varchar(30);
ie_existe_proc_w		varchar(255)	:= 'N';
nr_seq_apresent_w		bigint;
ie_tipo_atend_tiss_w		varchar(3);
cd_guia_manual_w		varchar(20);
ie_indic_acidente_w		varchar(10);
ie_tipo_doenca_w		varchar(5);
ie_tipo_saida_w			varchar(1);
nr_seq_compl_pf_tel_adic_w	pls_prestador.nr_seq_compl_pf_tel_adic%type;
nr_seq_tipo_compl_adic_w	pls_prestador.nr_seq_tipo_compl_adic%type;
ie_status_w			varchar(2);

c01 CURSOR FOR
	
	SELECT	a.nr_sequencia,
		a.cd_procedimento,
		substr(obter_descricao_procedimento(a.cd_procedimento,a.ie_origem_proced),1,255),
		a.ie_origem_proced,
		a.qt_solicitada,
		a.qt_autorizada,
		b.ie_status
	from	pls_guia_plano_proc a,
		pls_guia_plano b
	where	a.nr_seq_guia  		= b.nr_sequencia
	and	b.nr_sequencia		= nr_sequencia_autor_p
	and	((b.ie_status		= 3)
	or (b.ie_status		= 1
	and	b.ie_estagio		= 10))
	and	coalesce(a.nr_seq_motivo_exc::text, '') = '';


BEGIN

delete	from w_tiss_guia
where	nm_usuario		= nm_usuario_p;

delete	from w_tiss_dados_atendimento
where	nm_usuario		= nm_usuario_p;

delete	from w_tiss_beneficiario
where	nm_usuario		= nm_usuario_p;

delete	from w_tiss_proc_paciente
where	nm_usuario		= nm_usuario_p;

delete	from w_tiss_contratado_exec
where	nm_usuario		= nm_usuario_p;

delete	from w_tiss_totais
where	nm_usuario		= nm_usuario_p;

delete	from w_tiss_proc_solic
where	nm_usuario		= nm_usuario_p;

delete	from w_tiss_solicitacao
where	nm_usuario		= nm_usuario_p;

delete	from w_tiss_contratado_solic
where	nm_usuario		= nm_usuario_p;

delete	from w_tiss_relatorio
where	nm_usuario		= nm_usuario_p;

delete	from w_tiss_opm
where	nm_usuario		= nm_usuario_p;

delete	from w_tiss_opm_exec
where	nm_usuario		= nm_usuario_p;

commit;

if (coalesce(nr_sequencia_autor_p,0) > 0) then

	select	a.cd_guia,
		coalesce(a.cd_senha,a.cd_senha_externa),
		a.dt_autorizacao,
		a.dt_validade_senha,
		a.dt_emissao,
		a.nr_seq_plano,
		a.nr_seq_segurado,
		a.cd_medico_solicitante,
		a.nr_seq_prestador,
		d.cd_usuario_plano,
		d.dt_validade_carteira,
		b.cd_pessoa_fisica,
		c.ds_plano,
		a.ie_carater_internacao,
		a.cd_guia_principal,
		a.ds_observacao,
		substr(a.ds_indicacao_clinica,1,255),
		ie_tipo_atend_tiss,
		a.dt_solicitacao,
		substr(a.cd_guia_manual,1,20),
		ie_tipo_saida,
		a.ie_tipo_consulta
	into STRICT	cd_guia_w,
		cd_senha_w,
		dt_autorizacao_w,
		dt_validade_senha_w,
		dt_emissao_w,
		nr_seq_plano_w,
		nr_seq_segurado_w,
		cd_medico_solicitante_w,
		nr_seq_prestador_w,
		cd_usuario_plano_w,
		dt_validade_carteira_w,
		cd_pessoa_fisica_w,
		ds_plano_w,
		ie_carater_internacao_w,
		cd_guia_principal_w,
		ds_observacao_w,
		ds_indicacao_w,
		ie_tipo_atend_tiss_w,
		dt_solicitacao_w,		
		cd_guia_manual_w,
		ie_tipo_saida_w,
		ie_tipo_consulta_w
	from	pls_segurado_carteira d,
		pls_plano c,
		pls_segurado b,
		pls_guia_plano a
	where	a.nr_sequencia		= nr_sequencia_autor_p
	and	a.nr_seq_segurado	= b.nr_sequencia
	and	a.nr_seq_plano		= c.nr_sequencia
	and	d.nr_seq_segurado	= b.nr_sequencia
	and	b.nr_seq_plano		= c.nr_sequencia;

	/*select	a.cd_ans
	into	cd_ans_w
	from	pls_plano b,
		pls_outorgante a
	where	a.nr_sequencia	= b.nr_seq_outorgante
	and	b.nr_sequencia	= nr_seq_plano_w;*/
	cd_ans_w := pls_obter_dados_outorgante(cd_estabelecimento_p, 'ANS');

	insert	into w_tiss_relatorio(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ds_arquivo_logo)
	values (nextval('w_tiss_relatorio_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		ds_dir_padrao_p || '\pls_logo.jpg');

	qt_proc_guia_w 		:= 0;
	nr_seq_apresentacao_w	:= 0;

	open c01;
	loop
	fetch c01 into	nr_seq_guia_proc_w,
			cd_procedimento_w,
			ds_procedimento_w,
			ie_origem_proced_w,
			qt_solicitada_w,
			qt_autorizada_w,
			ie_status_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

		qt_proc_guia_w		:= qt_proc_guia_w + 1;

		if (qt_proc_guia_w = 1) then
			ie_existe_proc_w	:= 'S';
		
			select	nextval('w_tiss_guia_seq')
			into STRICT	nr_seq_guia_w
			;

			if (ie_status_w	= '3') then
				dt_autorizacao_w	:= null;
			end if;
			
			insert	into w_tiss_guia(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				cd_ans,
				cd_autorizacao,
				dt_autorizacao,
				cd_senha,
				dt_validade_senha,
				dt_emissao_guia,
				nr_sequencia_autor,
				cd_autorizacao_princ,
				ds_observacao,
				ie_tiss_tipo_guia,
				dt_entrada)
			values (nr_seq_guia_w,
				clock_timestamp(),
				nm_usuario_p,
				cd_ans_w,
				cd_guia_w,
				dt_autorizacao_w,
				cd_senha_w,
				dt_validade_senha_w,
				coalesce(dt_emissao_w,clock_timestamp()),
				nr_sequencia_autor_p,
				cd_guia_principal_w,
				ds_observacao_w,
				'2',
				null);

			select	nr_cartao_nac_sus,
				substr(obter_nome_pf(cd_pessoa_fisica),1,255)
			into STRICT	nr_cartao_nac_sus_w,
				nm_pessoa_fisica_w
			from	pessoa_fisica
			where	cd_pessoa_fisica	= cd_pessoa_fisica_w;

			insert	into w_tiss_beneficiario(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_guia,
				cd_pessoa_fisica,
				nm_pessoa_fisica,
				nr_cartao_nac_sus,
				ds_plano,
				dt_validade_carteira,
				cd_usuario_convenio)
			values (nextval('w_tiss_beneficiario_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_guia_w,
				cd_pessoa_fisica_w,
				nm_pessoa_fisica_w,
				nr_cartao_nac_sus_w,
				ds_plano_w,
				dt_validade_carteira_w,
				cd_usuario_plano_w);

			begin
				select	b.nr_cpf,
					substr(obter_nome_pf(a.cd_pessoa_fisica),1,255),
					substr(obter_conselho_profissional(b.nr_seq_conselho,'S'),1,10),
					nr_crm,
					uf_crm,
					substr(obter_descricao_padrao('CBO_SAUDE','CD_CBO',b.nr_seq_cbo_saude),1,10)
				into STRICT	nr_cpf_w,
					nm_medico_solicitante_w,
					sg_conselho_w,
					nr_crm_w,
					uf_crm_w,
					cd_cbo_w
				from	pessoa_fisica b,
					medico a
				where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
				and	a.cd_pessoa_fisica	= cd_medico_solicitante_w;
			exception
			when others then
				nr_cpf_w := null;
				nm_medico_solicitante_w := null;
				sg_conselho_w := null;
				nr_crm_w := null;
				uf_crm_w := null;
				cd_cbo_w := null;
			end;
			
			insert into w_tiss_contratado_solic(nr_sequencia, dt_atualizacao, nm_usuario,
				nr_seq_guia,cd_cgc,cd_interno,
				nr_cpf,nm_contratado,nm_solicitante,
				cd_cnes,sg_conselho,nr_crm,
				uf_crm,	cd_cbo_saude, cd_conselho_prof )
			values (nextval('w_tiss_contratado_solic_seq'), clock_timestamp(), nm_usuario_p,
				nr_seq_guia_w, pls_obter_dados_prestador(nr_seq_prestador_w,'CGC'),	coalesce(cd_prestador_exec_w, pls_obter_dados_prestador(nr_seq_prestador_w,'CGC')),
				obter_compl_pf(cd_medico_solicitante_w,1,'CPF'),pls_obter_dados_prestador(nr_seq_prestador_w,'NF'),	nm_medico_solicitante_w,
				obter_compl_pf(cd_medico_solicitante_w,1,'CNES'),sg_conselho_w,	nr_crm_w,
				uf_crm_w,cd_cbo_w, CASE WHEN sg_conselho_w='CRM' THEN '06' WHEN sg_conselho_w='CRN' THEN '07' WHEN sg_conselho_w='CRO' THEN '08' WHEN sg_conselho_w='CREFITO' THEN '05'  ELSE '10' END );

			select	max(cd_doenca),
				max(ds_diagnostico),
				max(ie_indicacao_acidente),
				max(ie_tipo_doenca)
			into STRICT	cd_doenca_cid_w,
				ds_diagnostico_w,
				ie_indic_acidente_w,
				ie_tipo_doenca_w
			from	pls_diagnostico
			where	nr_seq_guia		= nr_sequencia_autor_p
			and	ie_classificacao	= 'P';
			
			insert into w_tiss_solicitacao(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_guia,
				dt_solicitacao,
				ie_carater_solic,
				cd_cid,
				ds_indicacao)
			values (nextval('w_tiss_solicitacao_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_guia_w,
				dt_solicitacao_w,
				ie_carater_internacao_w,
				cd_doenca_cid_w,
				ds_indicacao_w);
				
			insert into w_tiss_dados_atendimento(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_guia,
				ie_tipo_atendimento,
				ie_tipo_acidente,
				ie_tipo_consulta,
				ie_tipo_saida) -- ie_tipo_doenca
			values (nextval('w_tiss_dados_atendimento_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_guia_w,
				ie_tipo_atend_tiss_w,
				ie_indic_acidente_w,
				ie_tipo_consulta_w,
				ie_tipo_saida_w);
		end if;
		
		nr_seq_apresentacao_w	:= nr_seq_apresentacao_w + 1;

		cd_tabela_relat_w := pls_obter_tabela_proc_guia(nr_sequencia_autor_p, cd_estabelecimento_p, nr_seq_prestador_w, cd_procedimento_w, ie_origem_proced_w, dt_autorizacao_w);
		
		insert into w_tiss_proc_solic(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_seq_guia,
			cd_procedimento,
			cd_edicao_amb,
			ds_procedimento,
			qt_solicitada,
			qt_autorizada,
			nr_seq_apresentacao)
		values (nextval('w_tiss_proc_solic_seq'),
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_guia_w,
			cd_procedimento_w,
			cd_tabela_relat_w,
			ds_procedimento_w,
			qt_solicitada_w,
			qt_autorizada_w,
			nr_seq_apresentacao_w);

		insert into w_tiss_proc_paciente(NR_SEQUENCIA,
			dt_ATUALIZACAO,
			nm_usUARIO,
			nr_seq_GUIA,
			nr_seq_apresentacao)
		values (nextval('w_tiss_proc_paciente_seq'),
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_guia_w,
			nr_seq_apresentacao_w);
			
		if (qt_proc_guia_w = 5) then
			if (nr_seq_prestador_w IS NOT NULL AND nr_seq_prestador_w::text <> '') then
				select	pls_obter_dados_prestador(nr_sequencia,'CGC'),
					pls_obter_dados_prestador(nr_sequencia,'PF'),
					ie_tipo_endereco,
					cd_prestador,
					nr_seq_compl_pf_tel_adic,
					nr_seq_tipo_compl_adic
				into STRICT	cgc_exec_w,
					cpf_exec_w,
					ie_tipo_compl_prest_w,
					cd_prestador_exec_w,
					nr_seq_compl_pf_tel_adic_w,
					nr_seq_tipo_compl_adic_w
				from	pls_prestador
				where	nr_sequencia	= nr_seq_prestador_w;

				nm_contratado_exec_w	:= pls_obter_dados_prestador(nr_seq_prestador_w,'NF');
			end if;
			if	((cpf_exec_w IS NOT NULL AND cpf_exec_w::text <> '') or (cgc_exec_w IS NOT NULL AND cgc_exec_w::text <> '')) then
				SELECT * FROM pls_obter_dados_end_prestador(	cpf_exec_w, cgc_exec_w, ie_tipo_compl_prest_w, 'N', nr_seq_compl_pf_tel_adic_w, nr_seq_tipo_compl_adic_w, ds_endereco_w, nr_endereco_w, ds_complemento_w, ds_bairro_w, cd_cep_w, nr_telefone_w, ds_email_w, ds_website_w, nr_ddi_telefone_w, nr_ddd_telefone_w, nr_ramal_w, cd_municipio_ibge_w, sg_estado_w, ds_fax_w, nr_ddd_fax_w, ds_municipio_w, ds_fone_adic_w) INTO STRICT ds_endereco_w, nr_endereco_w, ds_complemento_w, ds_bairro_w, cd_cep_w, nr_telefone_w, ds_email_w, ds_website_w, nr_ddi_telefone_w, nr_ddd_telefone_w, nr_ramal_w, cd_municipio_ibge_w, sg_estado_w, ds_fax_w, nr_ddd_fax_w, ds_municipio_w, ds_fone_adic_w;

				ds_logradouro_w	:= substr(pls_obter_end_prestador(nr_seq_prestador_w,null, null),1,255);
				if (cd_municipio_ibge_w IS NOT NULL AND cd_municipio_ibge_w::text <> '') then
					nm_municipio_w	:= substr(obter_desc_municipio_ibge(cd_municipio_ibge_w),1,255);
				end if;
				cd_cnes_w		:= obter_dados_pf_pj(cpf_exec_w,cgc_exec_w,'CNES');
			end if;
					
			insert	into w_tiss_contratado_exec(nr_sequencia, 	dt_atualizacao, nm_usuario,
				 nr_seq_guia, cd_cgc, cd_interno,
				 nr_cpf, nm_contratado, ds_tipo_logradouro,
				 ds_logradouro, nm_municipio, sg_estado,
				 cd_municipio_ibge, cd_cep, cd_cnes
				 /*nm_medico_executor, sg_conselho,
				 nr_crm, uf_crm, cd_cbo_sus, 
				 cd_cbo_saude, ds_funcao_medico, nr_endereco, 
				 nr_cpf_prof*/
)
			values (nextval('w_tiss_contratado_exec_seq'),clock_timestamp(),nm_usuario_p,
				 nr_seq_guia_w, cgc_exec_w, substr(cd_prestador_exec_w,1,20),
				 cpf_exec_w, nm_contratado_exec_w,'',
				 substr(ds_logradouro_w,1,53), nm_municipio_w, sg_estado_w,
				 cd_municipio_ibge_w, cd_cep_w, cd_cnes_w);

			insert into w_tiss_proc_paciente(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_guia,
				nr_seq_apresentacao)
			values (nextval('w_tiss_proc_paciente_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_guia_w,
				nr_seq_apresent_w);

			insert	into w_tiss_totais(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_guia)
			values (nextval('w_tiss_totais_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_guia_w);

			qt_proc_guia_w	:= 0;

			--pls_tiss_completar_guia_neg(nr_seq_guia_w, nm_usuario_p);
		end if;

	end loop;
	close c01;

	if (ie_existe_proc_w	= 'N') then
		select	nextval('w_tiss_guia_seq')
		into STRICT	nr_seq_guia_w
		;

		insert	into w_tiss_guia(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			cd_ans,
			cd_autorizacao,
			dt_autorizacao,
			cd_senha,
			dt_validade_senha,
			dt_emissao_guia,
			nr_sequencia_autor,
			cd_autorizacao_princ,
			ds_observacao,
			ie_tiss_tipo_guia,
			dt_entrada)
		values (nr_seq_guia_w,
			clock_timestamp(),
			nm_usuario_p,
			cd_ans_w,
			cd_guia_w,
			dt_autorizacao_w,
			cd_senha_w,
			dt_validade_senha_w,
			coalesce(dt_emissao_w,clock_timestamp()),
			nr_sequencia_autor_p,
			cd_guia_principal_w,
			ds_observacao_w,
			'2',
			null);

		select	nr_cartao_nac_sus,
			substr(obter_nome_pf(cd_pessoa_fisica),1,255)
		into STRICT	nr_cartao_nac_sus_w,
			nm_pessoa_fisica_w
		from	pessoa_fisica
		where	cd_pessoa_fisica	= cd_pessoa_fisica_w;

		insert	into w_tiss_beneficiario(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_seq_guia,
			cd_pessoa_fisica,
			nm_pessoa_fisica,
			nr_cartao_nac_sus,
			ds_plano,
			dt_validade_carteira,
			cd_usuario_convenio)
		values (nextval('w_tiss_beneficiario_seq'),
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_guia_w,
			cd_pessoa_fisica_w,
			nm_pessoa_fisica_w,
			nr_cartao_nac_sus_w,
			ds_plano_w,
			dt_validade_carteira_w,
			cd_usuario_plano_w);

		begin
			select	b.nr_cpf,
				substr(obter_nome_pf(a.cd_pessoa_fisica),1,255),
				substr(obter_conselho_profissional(b.nr_seq_conselho,'S'),1,10),
				nr_crm,
				uf_crm,
				substr(obter_descricao_padrao('CBO_SAUDE','CD_CBO',b.nr_seq_cbo_saude),1,10)
			into STRICT	nr_cpf_w,
				nm_medico_solicitante_w,
				sg_conselho_w,
				nr_crm_w,
				uf_crm_w,
				cd_cbo_w
			from	pessoa_fisica b,
				medico a
			where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
			and	a.cd_pessoa_fisica	= cd_medico_solicitante_w;
		exception
		when others then
			nr_cpf_w := null;
			nm_medico_solicitante_w := null;
			sg_conselho_w := null;
			nr_crm_w := null;
			uf_crm_w := null;
			cd_cbo_w := null;
		end;
		
		insert into w_tiss_contratado_solic(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_seq_guia,
			cd_cgc,
			cd_interno,
			nr_cpf,
			nm_contratado,
			nm_solicitante,
			cd_cnes,
			sg_conselho,
			nr_crm,
			uf_crm,
			cd_cbo_saude)
		values (nextval('w_tiss_contratado_solic_seq'),
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_guia_w,
			'',--pls_obter_dados_prestador(nr_seq_prestador_w,'CGC'),
			'',--nr_seq_prestador_w,
			obter_compl_pf(cd_medico_solicitante_w,1,'CPF'),
			'',--pls_obter_dados_prestador(nr_seq_prestador_w,'NF'),
			nm_medico_solicitante_w,
			'',--obter_compl_pf(cd_medico_solicitante_w,1,'CNES'),
			sg_conselho_w,
			nr_crm_w,
			uf_crm_w,
			cd_cbo_w);

		select	max(cd_doenca),
			max(ds_diagnostico),
			max(ie_indicacao_acidente),
			max(ie_tipo_doenca)
		into STRICT	cd_doenca_cid_w,
			ds_diagnostico_w,
			ie_indic_acidente_w,
			ie_tipo_doenca_w
		from	pls_diagnostico
		where	nr_seq_guia		= nr_sequencia_autor_p
		and	ie_classificacao	= 'P';
		
		insert into w_tiss_solicitacao(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_seq_guia,
			dt_solicitacao,
			ie_carater_solic,
			cd_cid,
			ds_indicacao)
		values (nextval('w_tiss_solicitacao_seq'),
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_guia_w,
			dt_solicitacao_w,
			ie_carater_internacao_w,
			cd_doenca_cid_w,
			ds_indicacao_w);
			
		insert into w_tiss_dados_atendimento(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_seq_guia,
			ie_tipo_atendimento,
			ie_tipo_acidente,
			ie_tipo_consulta) -- ie_tipo_doenca
		values (nextval('w_tiss_dados_atendimento_seq'),
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_guia_w,
			ie_tipo_atend_tiss_w,
			ie_indic_acidente_w,
			ie_tipo_consulta_w);

		if (nr_seq_prestador_w IS NOT NULL AND nr_seq_prestador_w::text <> '') then
			select	pls_obter_dados_prestador(nr_sequencia,'CGC'),
				pls_obter_dados_prestador(nr_sequencia,'PF'),
				ie_tipo_endereco,
				cd_prestador,
				nr_seq_compl_pf_tel_adic,
				nr_seq_tipo_compl_adic
			into STRICT	cgc_exec_w,
				cpf_exec_w,
				ie_tipo_compl_prest_w,
				cd_prestador_exec_w,
				nr_seq_compl_pf_tel_adic_w,
				nr_seq_tipo_compl_adic_w
			from	pls_prestador
			where	nr_sequencia	= nr_seq_prestador_w;

			nm_contratado_exec_w	:= pls_obter_dados_prestador(nr_seq_prestador_w,'NF');
		end if;

		if	((cpf_exec_w IS NOT NULL AND cpf_exec_w::text <> '') or (cgc_exec_w IS NOT NULL AND cgc_exec_w::text <> '')) then
			SELECT * FROM pls_obter_dados_end_prestador(	cpf_exec_w, cgc_exec_w, ie_tipo_compl_prest_w, 'N', nr_seq_compl_pf_tel_adic_w, nr_seq_tipo_compl_adic_w, ds_endereco_w, nr_endereco_w, ds_complemento_w, ds_bairro_w, cd_cep_w, nr_telefone_w, ds_email_w, ds_website_w, nr_ddi_telefone_w, nr_ddd_telefone_w, nr_ramal_w, cd_municipio_ibge_w, sg_estado_w, ds_fax_w, nr_ddd_fax_w, ds_municipio_w, ds_fone_adic_w) INTO STRICT ds_endereco_w, nr_endereco_w, ds_complemento_w, ds_bairro_w, cd_cep_w, nr_telefone_w, ds_email_w, ds_website_w, nr_ddi_telefone_w, nr_ddd_telefone_w, nr_ramal_w, cd_municipio_ibge_w, sg_estado_w, ds_fax_w, nr_ddd_fax_w, ds_municipio_w, ds_fone_adic_w;

			ds_logradouro_w	:= substr(pls_obter_end_prestador(nr_seq_prestador_w,null, null),1,255);
			if (cd_municipio_ibge_w IS NOT NULL AND cd_municipio_ibge_w::text <> '') then
				nm_municipio_w	:= substr(obter_desc_municipio_ibge(cd_municipio_ibge_w),1,255);
			end if;
			cd_cnes_w		:= obter_dados_pf_pj(cpf_exec_w,cgc_exec_w,'CNES');
		end if;
				
		insert	into w_tiss_contratado_exec(nr_sequencia, 	dt_atualizacao, nm_usuario,
			 nr_seq_guia, cd_cgc, cd_interno,
			 nr_cpf, nm_contratado, ds_tipo_logradouro,
			 ds_logradouro, nm_municipio, sg_estado,
			 cd_municipio_ibge, cd_cep, cd_cnes
			 /*nm_medico_executor, sg_conselho,
			 nr_crm, uf_crm, cd_cbo_sus, 
			 cd_cbo_saude, ds_funcao_medico, nr_endereco, 
			 nr_cpf_prof*/
)
		values (nextval('w_tiss_contratado_exec_seq'),clock_timestamp(),nm_usuario_p,
			 nr_seq_guia_w, cgc_exec_w, substr(cd_prestador_exec_w,1,20),
			 cpf_exec_w, nm_contratado_exec_w,'',
			 substr(ds_logradouro_w,1,53), nm_municipio_w, sg_estado_w,
			 cd_municipio_ibge_w, cd_cep_w, cd_cnes_w);

		/*insert into w_tiss_proc_paciente
			(NR_SEQUENCIA,
			dt_ATUALIZACAO,
			nm_usUARIO,
			nr_seq_GUIA)
		values	(w_tiss_proc_paciente_seq.nextval,
			sysdate,
			nm_usuario_p,
			nr_seq_guia_w);*/
		insert	into w_tiss_totais(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_seq_guia)
		values (nextval('w_tiss_totais_seq'),
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_guia_w);
	end if;
	/* */

	
	if (qt_proc_guia_w > 0) and (qt_proc_guia_w < 5) then
		if (nr_seq_prestador_w IS NOT NULL AND nr_seq_prestador_w::text <> '') then
			
			begin
				select	pls_obter_dados_prestador(nr_sequencia,'CGC'),
					pls_obter_dados_prestador(nr_sequencia,'PF'),
					ie_tipo_endereco,
					nr_seq_compl_pf_tel_adic,
					nr_seq_tipo_compl_adic
				into STRICT	cgc_exec_w,
					cpf_exec_w,
					ie_tipo_compl_prest_w,
					nr_seq_compl_pf_tel_adic_w,
					nr_seq_tipo_compl_adic_w
				from	pls_prestador
				where	nr_sequencia	= nr_seq_prestador_w;
			exception
				when others then
					cgc_exec_w := null;
					cpf_exec_w := null;
					ie_tipo_compl_prest_w := null;
			end;

			nm_contratado_exec_w	:= pls_obter_dados_prestador(nr_seq_prestador_w,'NF');
		end if;
		if	((cpf_exec_w IS NOT NULL AND cpf_exec_w::text <> '') or (cgc_exec_w IS NOT NULL AND cgc_exec_w::text <> '')) then
			SELECT * FROM pls_obter_dados_end_prestador(	cpf_exec_w, cgc_exec_w, ie_tipo_compl_prest_w, 'N', nr_seq_compl_pf_tel_adic_w, nr_seq_tipo_compl_adic_w, ds_endereco_w, nr_endereco_w, ds_complemento_w, ds_bairro_w, cd_cep_w, nr_telefone_w, ds_email_w, ds_website_w, nr_ddi_telefone_w, nr_ddd_telefone_w, nr_ramal_w, cd_municipio_ibge_w, sg_estado_w, ds_fax_w, nr_ddd_fax_w, ds_municipio_w, ds_fone_adic_w) INTO STRICT ds_endereco_w, nr_endereco_w, ds_complemento_w, ds_bairro_w, cd_cep_w, nr_telefone_w, ds_email_w, ds_website_w, nr_ddi_telefone_w, nr_ddd_telefone_w, nr_ramal_w, cd_municipio_ibge_w, sg_estado_w, ds_fax_w, nr_ddd_fax_w, ds_municipio_w, ds_fone_adic_w;

			ds_logradouro_w	:=	substr(pls_obter_end_prestador(nr_seq_prestador_w,null, null),1,255);
			if (cd_municipio_ibge_w IS NOT NULL AND cd_municipio_ibge_w::text <> '') then
				nm_municipio_w	:= substr(pls_obter_desc_munic_ibge_web(cd_municipio_ibge_w),1,255);
			end if;
			cd_cnes_w		:= obter_dados_pf_pj(cpf_exec_w,cgc_exec_w,'CNES');
		end if;
	
		insert	into w_tiss_contratado_exec(nr_sequencia, 	dt_atualizacao, nm_usuario,
			 nr_seq_guia, cd_cgc, cd_interno,
			 nr_cpf, nm_contratado, ds_tipo_logradouro,
			 ds_logradouro, nm_municipio, sg_estado,
			 cd_municipio_ibge, cd_cep, cd_cnes
			 /*nm_medico_executor, sg_conselho,
			 nr_crm, uf_crm, cd_cbo_sus, 
			 cd_cbo_saude, ds_funcao_medico, nr_endereco, 
			 nr_cpf_prof*/
)
		values (nextval('w_tiss_contratado_exec_seq'),clock_timestamp(),nm_usuario_p,
			 nr_seq_guia_w, cgc_exec_w, substr(cd_prestador_exec_w,1,20),
			 cpf_exec_w, nm_contratado_exec_w,'',
			 substr(ds_logradouro_w,1,53), nm_municipio_w, sg_estado_w,
			 cd_municipio_ibge_w, cd_cep_w, cd_cnes_w);

		insert into w_tiss_proc_paciente(NR_SEQUENCIA,
			dt_ATUALIZACAO,
			nm_usUARIO,
			nr_seq_GUIA)
		values (nextval('w_tiss_contratado_exec_seq'),
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_guia_w);

		insert	into w_tiss_totais(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_seq_guia)
		values (nextval('w_tiss_totais_seq'),
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_guia_w);
	end if;

	CALL pls_tiss_completar_guia_neg(nr_seq_guia_w, nm_usuario_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_guia_negada_web (nr_sequencia_autor_p bigint, ds_dir_padrao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

