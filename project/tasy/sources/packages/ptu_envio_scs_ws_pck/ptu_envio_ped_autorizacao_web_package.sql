-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- Enviar 00600 - Pedido de Autorização pelo portal
CREATE OR REPLACE PROCEDURE ptu_envio_scs_ws_pck.ptu_envio_ped_autorizacao_web ( nr_seq_requisicao_p pls_requisicao_proc.nr_seq_requisicao%type, nr_seq_guia_p pls_guia_plano_proc.nr_seq_guia%type, nr_versao_ptu_p ptu_pedido_autorizacao.nr_versao%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_pedido_p INOUT ptu_pedido_autorizacao.nr_sequencia%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar a transação de pedido de autorização do PTU, via SCS
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
dt_execucao_w				ptu_pedido_autorizacao.dt_atendimento%type;
cd_carteirinha_w			pls_segurado_carteira.cd_usuario_plano%type;
nr_seq_prestador_w			pls_requisicao.nr_seq_prestador%type;
cd_especialidade_w			especialidade_medica.cd_especialidade%type;
cd_doenca_w				ptu_pedido_autorizacao.cd_doenca_cid%type;
cd_cooperativa_w			ptu_pedido_autorizacao.cd_unimed_executora%type;
cd_cooperativa_ww			ptu_pedido_autorizacao.cd_unimed_beneficiario%type;
nr_seq_segurado_w			pls_requisicao.nr_seq_segurado%type;
nr_via_cartao_w				ptu_pedido_autorizacao.nr_via_cartao%type;
cd_procedimento_w			pls_guia_plano_proc.cd_procedimento%type;
ie_origem_proced_w			pls_guia_plano_proc.ie_origem_proced%type;
qt_procedimento_w			ptu_pedido_aut_servico.qt_servico%type;
qt_proc_solicitada_w			pls_guia_plano_proc.qt_solicitada%type;
qt_proc_autorizada_w			pls_guia_plano_proc.qt_autorizada%type;
nr_seq_material_w			pls_pacote_material.nr_seq_material%type;
qt_material_w				ptu_pedido_aut_servico.qt_servico%type;
qt_mat_solicitada_w			pls_guia_plano_mat.qt_solicitada%type;
qt_mat_autorizada_w			pls_guia_plano_mat.qt_autorizada%type;
cd_pessoa_fisica_w			pls_segurado.cd_pessoa_fisica%type;
qt_registros_w				integer;
cd_usuario_plano_w			ptu_pedido_autorizacao.cd_usuario_plano%type;
ds_indic_clicnica_w			ptu_pedido_autorizacao.ds_ind_clinica%type;
ds_observacao_w				ptu_pedido_autorizacao.ds_observacao%type;
ie_tipo_processo_w			pls_requisicao.ie_tipo_processo%type;
ie_tipo_cliente_w			ptu_pedido_autorizacao.ie_tipo_cliente%type;
nr_seq_prest_alto_custo_w		ptu_pedido_autorizacao.nr_seq_prest_alto_custo%type;
cd_uni_prest_alto_custo_w		ptu_pedido_autorizacao.cd_unimed_prestador%type;
ie_alto_custo_w				varchar(2);
ie_classificacao_w			procedimento.ie_classificacao%type;
ie_tipo_tabela_w			ptu_pedido_aut_servico.ie_tipo_tabela%type;
ie_tipo_despesa_w			pls_material.ie_tipo_despesa%type;
ie_carater_atend_w			pls_requisicao.ie_carater_atendimento%type;
ie_urg_emerg_w				ptu_pedido_autorizacao.ie_urg_emerg%type;
vl_procedimento_w			pls_guia_plano_proc.vl_procedimento%type;
vl_material_w				pls_guia_plano_mat.vl_material%type;
nm_prest_alto_custo_w			ptu_pedido_autorizacao.nm_prestador_alto_custo%type;
cd_material_w				varchar(255);
cd_servico_w				ptu_pedido_aut_servico.cd_servico%type;
nr_seq_pacote_w				pls_guia_plano_proc.nr_seq_pacote%type;
nr_seq_controle_exec_w			ptu_controle_execucao.nr_sequencia%type;
ie_tipo_pacote_w			varchar(2);
cd_proc_pacote_w			pls_pacote_procedimento.cd_procedimento%type;
ie_origem_proced_pcte_w			bigint;
ds_proc_pacote_w			procedimento.ds_procedimento%type;
cd_unimed_w				ptu_pedido_autorizacao.cd_unimed%type;
nr_seq_congenere_w			pls_segurado.nr_seq_congenere%type;
nr_seq_prestador_exec_w			pls_requisicao.nr_seq_prestador_exec%type;
nr_seq_pedido_aut_serv_w		ptu_pedido_aut_servico.nr_sequencia%type;
nr_seq_req_guia_proc_w			pls_guia_plano_proc.nr_sequencia%type;
nr_seq_req_guia_mat_w			pls_guia_plano_mat.nr_sequencia%type;
cd_espec_ptu_w				especialidade_medica.cd_ptu%type;
ie_permite_pacote_w			pls_param_intercambio_scs.ie_permite_pacote%type;
ie_tipo_segurado_w			pls_segurado.ie_tipo_segurado%type;
vl_total_w				ptu_pedido_aut_servico.vl_servico%type	:= 0;
cd_procedimento_ptu_w			pls_guia_plano_proc.cd_procedimento_ptu%type;
ds_procedimento_ptu_w			pls_guia_plano_proc.ds_procedimento_ptu%type;
cd_material_ptu_w			pls_guia_plano_mat.cd_material_ptu%type;
ds_material_ptu_w			pls_guia_plano_mat.ds_material_ptu%type;
ie_tipo_envio_via_w			pls_regra_limite_envio_scs.ie_tipo_envio_via%type;
qt_reg_generico_w			integer;
cd_cgc_outorgante_w			pls_outorgante.cd_cgc_outorgante%type;
nr_seq_guia_princ_w			pls_requisicao.nr_seq_guia_principal%type;
ie_recem_nascido_w			pls_requisicao.ie_recem_nascido%type;
nr_seq_clinica_w			pls_clinica.nr_sequencia%type;
ie_indicacao_acidente_w			pls_requisicao_diagnostico.ie_indicacao_acidente%type;
cd_medico_solicitante_w			pessoa_fisica.cd_pessoa_fisica%type;
nm_medico_solicitante_w			pessoa_fisica.nm_pessoa_fisica%type;
nr_telefone_med_solic_w			ptu_pedido_autorizacao.nr_fone_prof_solic%type;
ds_email_med_solic_w			compl_pessoa_fisica.ds_email%type;
ie_sexo_w				ptu_pedido_autorizacao.ie_sexo%type;
dt_nascimento_benef_w			pessoa_fisica.dt_nascimento%type;
nr_seq_uni_exec_w			pls_congenere.nr_sequencia%type;
nr_seq_guia_diagnostico_w		pls_diagnostico.nr_sequencia%type;
nr_seq_req_diagnostico_w		pls_requisicao_diagnostico.nr_sequencia%type;
cd_unimed_exec_w			pls_congenere.cd_cooperativa%type;
nr_registro_anvisa_w			pls_material.nr_registro_anvisa%type;
ie_tipo_guia_w				pls_guia_plano.ie_tipo_guia%type;
dt_admissao_hosp_w			pls_guia_plano.dt_admissao_hosp%type;
nr_idade_w				ptu_pedido_autorizacao.nr_idade%type;
cd_versao_tiss_w			pls_versao_tiss.cd_versao_tiss%type;
ie_tipo_anexo_w				pls_guia_plano_proc.ie_tipo_anexo%type;
ie_anexo_guia_w				pls_guia_plano.ie_anexo_guia%type;
cd_ref_fabricante_imp_w			pls_lote_anexo_mat_aut.cd_ref_fabricante_imp%type;
ie_via_administracao_w			pls_lote_anexo_mat_aut.ie_via_administracao%type;
ie_frequencia_dose_w			pls_lote_anexo_mat_aut.ie_frequencia_dose%type;
nr_transacao_solicitante_w		ptu_requisicao_ordem_serv.nr_transacao_solicitante%type;
dt_prev_realizacao_w			pls_lote_anexo_proc_aut.dt_prev_realizacao%type;
dt_provavel_w				pls_lote_anexo_mat_aut.dt_prevista%type;
ie_opcao_fabricante_w			pls_lote_anexo_mat_aut.ie_opcao_fabricante%type;
ie_pacote_ptu_w				pls_guia_plano_proc.ie_pacote_ptu%type;
ie_pacote_w				ptu_pedido_aut_servico.ie_pacote%type;
nr_seq_clinica_ptu_w			ptu_pedido_autorizacao.ie_tipo_internacao%type;
ie_req_web_finalizada_w			pls_requisicao.ie_req_web_finalizada%type;
ie_origem_solic_w			pls_requisicao.ie_origem_solic%Type;
ie_bloq_req_interc_web_w		pls_param_requisicao.ie_bloq_req_interc_web%type;
ds_opme_w				varchar(255);
nr_seq_composicao_w			pls_pacote_tipo_acomodacao.nr_seq_composicao%type;
nr_seq_preco_pacote_w			pls_guia_plano_proc.nr_seq_preco_pacote%type;
sg_estado_congenere_w			pessoa_juridica.sg_estado%type;
sg_estado_exec_w			pessoa_juridica.sg_estado%type;

c01 CURSOR FOR
	SELECT	nr_sequencia,
		cd_procedimento,
		ie_origem_proced,
		qt_solicitada,
		qt_autorizada,
		vl_procedimento,
		nr_seq_pacote,
		nr_seq_preco_pacote,
		cd_procedimento_ptu,
		ds_procedimento_ptu,
		ie_pacote_ptu
	from	pls_guia_plano_proc
	where	nr_seq_guia		= nr_seq_guia_p
	and	ie_status		= 'I'
	
union

	SELECT	nr_sequencia,
		cd_procedimento,
		ie_origem_proced,
		qt_solicitado,
		qt_procedimento,
		vl_procedimento,
		nr_seq_pacote,
		nr_seq_preco_pacote,
		cd_procedimento_ptu,
		ds_procedimento_ptu,
		ie_pacote_ptu
	from	pls_requisicao_proc
	where	nr_seq_requisicao	= nr_seq_requisicao_p
	and	ie_status		= 'I';

c02 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_material,
		qt_solicitada,
		qt_autorizada,
		vl_material,
		cd_material_ptu,
		ds_material_ptu
	from	pls_guia_plano_mat
	where	nr_seq_guia		= nr_seq_guia_p
	and	ie_status		= 'I'
	
union

	SELECT	nr_sequencia,
		nr_seq_material,
		qt_solicitado,
		qt_material,
		vl_material,
		cd_material_ptu,
		ds_material_ptu
	from	pls_requisicao_mat
	where	nr_seq_requisicao	= nr_seq_requisicao_p
	and	ie_status		= 'I';

c03 CURSOR FOR
	SELECT	a.cd_procedimento,
		a.ie_origem_proced
	from	pls_pacote_composicao	b,
		pls_pacote_procedimento	a
	where	a.nr_seq_composicao 	= b.nr_sequencia
	and	a.nr_seq_composicao	= nr_seq_composicao_w;

c04 CURSOR FOR
	SELECT	a.nr_seq_material
	from	pls_pacote_composicao	b,
		pls_pacote_material	a
	where	a.nr_seq_composicao 	= b.nr_sequencia
	and	a.nr_seq_composicao	= nr_seq_composicao_w;


BEGIN

select	max(ie_bloq_req_interc_web)
into STRICT	ie_bloq_req_interc_web_w
from	pls_param_requisicao;

if (coalesce(ie_bloq_req_interc_web_w, 'N')	= 'S') then
	if (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then
		begin
			select	ie_req_web_finalizada,
				ie_origem_solic
			into STRICT	ie_req_web_finalizada_w,
				ie_origem_solic_w
			from	pls_requisicao
			where	nr_sequencia = nr_seq_requisicao_p;
		exception
		when others then
			ie_req_web_finalizada_w	:= null;
			ie_origem_solic_w	:= null;
		end;

		if	((ie_origem_solic_w	= 'P') and ((coalesce(ie_req_web_finalizada_w::text, '') = '') or (ie_req_web_finalizada_w <> 'S'))) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(356549);
		end if;
	end if;
end if;

select	max(cd_cgc_outorgante)
into STRICT	cd_cgc_outorgante_w
from	pls_outorgante;

select	max(cd_cooperativa)
into STRICT	cd_cooperativa_w
from	pls_congenere
where	cd_cgc			= cd_cgc_outorgante_w
and	(cd_cooperativa IS NOT NULL AND cd_cooperativa::text <> '');

if (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then
	select	count(1)
	into STRICT	qt_registros_w
	from	ptu_pedido_autorizacao
	where	nr_seq_requisicao	= nr_seq_requisicao_p;

	if (qt_registros_w	<> 0) then
		goto final;
	end if;

	select	dt_requisicao,
		pls_obter_dados_segurado(nr_seq_segurado, 'C'),
		nr_seq_segurado,
		nr_seq_prestador,
		nr_seq_prestador_exec,
		ie_tipo_processo,
		substr(ds_indicacao_clinica,1,999),
		ie_carater_atendimento,
		substr(ds_observacao,1,999),
		cd_especialidade,
		nr_seq_guia_principal,
		ie_recem_nascido,
		cd_medico_solicitante,
		nr_seq_clinica,
		nr_seq_uni_exec,
		dt_entrada_hospital,
		ie_tipo_guia,
		ie_anexo_guia
	into STRICT	dt_execucao_w,
		cd_carteirinha_w,
		nr_seq_segurado_w,
		nr_seq_prestador_w,
		nr_seq_prestador_exec_w,
		ie_tipo_processo_w,
		ds_indic_clicnica_w,
		ie_carater_atend_w,
		ds_observacao_w,
		cd_especialidade_w,
		nr_seq_guia_princ_w,
		ie_recem_nascido_w,
		cd_medico_solicitante_w,
		nr_seq_clinica_w,
		nr_seq_uni_exec_w,
		dt_admissao_hosp_w,
		ie_tipo_guia_w,
		ie_anexo_guia_w
	from	pls_requisicao
	where	nr_sequencia		= nr_seq_requisicao_p;

	if (coalesce(nr_seq_guia_princ_w,0)	> 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(253366);
	end if;
	select	max(nr_sequencia)
	into STRICT	nr_seq_req_diagnostico_w
	from	pls_requisicao_diagnostico
	where	nr_seq_requisicao	= nr_seq_requisicao_p;

	begin
		select	cd_doenca,
			ie_indicacao_acidente
		into STRICT	cd_doenca_w,
			ie_indicacao_acidente_w
		from	pls_requisicao_diagnostico
		where	nr_sequencia	= nr_seq_req_diagnostico_w;
	exception
	when others then
		cd_doenca_w		:= null;
		ie_indicacao_acidente_w	:= 9;
	end;

	begin
		select	ie_tipo_segurado,
			cd_pessoa_fisica
		into STRICT	ie_tipo_segurado_w,
			cd_pessoa_fisica_w
		from	pls_segurado
		where	nr_sequencia	= nr_seq_segurado_w;
	exception
	when others then
		ie_tipo_segurado_w	:= 'X';
	end;

	if (ie_tipo_segurado_w IS NOT NULL AND ie_tipo_segurado_w::text <> '') then
		begin
			select	coalesce(nr_cartao_intercambio,cd_usuario_plano)
			into STRICT	cd_carteirinha_w
			from	pls_segurado_carteira
			where	nr_seq_segurado	= nr_seq_segurado_w;
		exception
		when others then
			cd_carteirinha_w	:= null;
		end;

		if (coalesce(cd_carteirinha_w::text, '') = '') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(191728);
		end if;
	end if;

	if (ie_carater_atend_w	= 'U') then
		ie_urg_emerg_w	:= 'S';
	else
		ie_urg_emerg_w	:= 'N';
	end if;

	begin
		select	cd_ptu
		into STRICT	cd_espec_ptu_w
		from	especialidade_medica
		where	cd_especialidade	= cd_especialidade_w;
	exception
	when others then
		cd_espec_ptu_w	:= cd_especialidade_w;
	end;

	begin
		select	substr(nm_profissional_solic,1,70),
			substr(nr_telef_prof_solic,1,11),
			substr(ds_email_prof_solic,1,60)
		into STRICT	nm_medico_solicitante_w,
			nr_telefone_med_solic_w,
			ds_email_med_solic_w
		from	pls_lote_anexo_guias_aut
		where	nr_seq_requisicao	= nr_seq_requisicao_p
		and	ie_tipo_anexo		= 	'OP';
	exception
	when others then
		nm_medico_solicitante_w	:= null;
		nr_telefone_med_solic_w	:= null;
		ds_email_med_solic_w	:= null;
	end;

	begin
		select	CASE WHEN ie_sexo='M' THEN 1 WHEN ie_sexo='I' THEN 2 WHEN ie_sexo='F' THEN 3 END ,
			dt_nascimento
		into STRICT	ie_sexo_w,
			dt_nascimento_benef_w
		from	pessoa_fisica
		where	cd_pessoa_fisica	= cd_pessoa_fisica_w;
	exception
	when others then
		ie_sexo_w		:= null;
		dt_nascimento_benef_w	:= null;
	end;

	if ((pls_obter_unimed_benef(nr_seq_segurado_w) IS NOT NULL AND (pls_obter_unimed_benef(nr_seq_segurado_w))::text <> '')) then
		cd_cooperativa_ww	:= adiciona_zeros_esquerda(pls_obter_unimed_benef(nr_seq_segurado_w),4);
		CALL pls_requisicao_gravar_hist(nr_seq_requisicao_p,'L','Enviado pedido de autorização para a Unimed '||cd_cooperativa_ww,null,nm_usuario_p);
	else
		CALL wheb_mensagem_pck.exibir_mensagem_abort(246588);
	end if;

	begin
		select 	nr_transacao_solicitante
		into STRICT	nr_transacao_solicitante_w
		from	ptu_requisicao_ordem_serv
		where	nr_seq_requisicao	= nr_seq_requisicao_p;
	exception
	when others then
		nr_transacao_solicitante_w	:= 0;
	end;
elsif (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then
	select	count(1)
	into STRICT	qt_registros_w
	from	ptu_pedido_autorizacao
	where	nr_seq_guia	= nr_seq_guia_p;

	if (qt_registros_w	<> 0) then
		goto final;
	end if;

	select	dt_solicitacao,
		pls_obter_dados_segurado(nr_seq_segurado, 'C'),
		nr_seq_segurado,
		nr_seq_prestador,
		ie_tipo_processo,
		substr(ds_indicacao_clinica,1,999),
		ie_carater_internacao,
		substr(ds_observacao,1,999),
		cd_especialidade,
		nr_seq_guia_principal,
		ie_recem_nascido,
		cd_medico_solicitante,
		nr_seq_clinica,
		nr_seq_uni_exec,
		dt_admissao_hosp,
		ie_tipo_guia,
		ie_anexo_guia
	into STRICT	dt_execucao_w,
		cd_carteirinha_w,
		nr_seq_segurado_w,
		nr_seq_prestador_w,
		ie_tipo_processo_w,
		ds_indic_clicnica_w,
		ie_carater_atend_w,
		ds_observacao_w,
		cd_especialidade_w,
		nr_seq_guia_princ_w,
		ie_recem_nascido_w,
		cd_medico_solicitante_w,
		nr_seq_clinica_w,
		nr_seq_uni_exec_w,
		dt_admissao_hosp_w,
		ie_tipo_guia_w,
		ie_anexo_guia_w
	from	pls_guia_plano
	where	nr_sequencia	= nr_seq_guia_p;


	if (coalesce(nr_seq_guia_princ_w,0)	> 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(253366);
	end if;

	select	max(nr_sequencia)
	into STRICT	nr_seq_guia_diagnostico_w
	from	pls_diagnostico
	where	ie_classificacao	= 'P'
	and	nr_seq_guia		= nr_seq_guia_p;

	begin
		select	cd_doenca,
			ie_indicacao_acidente
		into STRICT	cd_doenca_w,
			ie_indicacao_acidente_w
		from	pls_diagnostico
		where	nr_sequencia	= nr_seq_guia_diagnostico_w;
	exception
	when others then
		cd_doenca_w		:= null;
		ie_indicacao_acidente_w	:= 9;
	end;

	begin
		select	ie_tipo_segurado,
			cd_pessoa_fisica
		into STRICT	ie_tipo_segurado_w,
			cd_pessoa_fisica_w
		from	pls_segurado
		where	nr_sequencia	= nr_seq_segurado_w;
	exception
	when others then
		ie_tipo_segurado_w	:= 'X';
	end;

	if (ie_tipo_segurado_w IS NOT NULL AND ie_tipo_segurado_w::text <> '') then
		begin
			select	coalesce(nr_cartao_intercambio,cd_usuario_plano)
			into STRICT	cd_carteirinha_w
			from	pls_segurado_carteira
			where	nr_seq_segurado	= nr_seq_segurado_w;
		exception
		when others then
			cd_carteirinha_w	:= null;
		end;

		if (coalesce(cd_carteirinha_w::text, '') = '') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(191728);
		end if;
	end if;

	if (ie_carater_atend_w	= 'U') then
		ie_urg_emerg_w	:= 'S';
	else
		ie_urg_emerg_w	:= 'N';
	end if;

	begin
		select	cd_ptu
		into STRICT	cd_espec_ptu_w
		from	especialidade_medica
		where	cd_especialidade	= cd_especialidade_w;
	exception
	when others then
		cd_espec_ptu_w	:= cd_especialidade_w;
	end;

	begin
		select	substr(nm_profissional_solic,1,70),
			substr(nr_telef_prof_solic,1,11),
			substr(ds_email_prof_solic,1,60)
		into STRICT	nm_medico_solicitante_w,
			nr_telefone_med_solic_w,
			ds_email_med_solic_w
		from	pls_lote_anexo_guias_aut
		where	nr_seq_guia	= nr_seq_guia_p
		and	ie_tipo_anexo	= 	'OP';
	exception
	when others then
		nm_medico_solicitante_w	:= null;
		nr_telefone_med_solic_w	:= null;
		ds_email_med_solic_w	:= null;
	end;

	begin
		select	CASE WHEN ie_sexo='M' THEN 1 WHEN ie_sexo='I' THEN 2 WHEN ie_sexo='F' THEN 3 END ,
			dt_nascimento
		into STRICT	ie_sexo_w,
			dt_nascimento_benef_w
		from	pessoa_fisica
		where	cd_pessoa_fisica	= cd_pessoa_fisica_w;
	exception
	when others then
		ie_sexo_w		:= null;
		dt_nascimento_benef_w	:= null;
	end;

	if ((pls_obter_unimed_benef(nr_seq_segurado_w) IS NOT NULL AND (pls_obter_unimed_benef(nr_seq_segurado_w))::text <> '')) then
		cd_cooperativa_ww	:= adiciona_zeros_esquerda(pls_obter_unimed_benef(nr_seq_segurado_w),4);
		CALL pls_guia_gravar_historico(nr_seq_guia_p,2,'Enviado pedido de autorização para a Unimed '||cd_cooperativa_ww,'',nm_usuario_p);
	else
		CALL wheb_mensagem_pck.exibir_mensagem_abort(246588);
	end if;

	begin
		select 	nr_transacao_solicitante
		into STRICT	nr_transacao_solicitante_w
		from	ptu_requisicao_ordem_serv
		where	nr_seq_guia	= nr_seq_guia_p;
	exception
	when others then
		nr_transacao_solicitante_w := 0;
	end;
end if;

if (length(cd_carteirinha_w) >= 17) then
	select	nr_seq_congenere
	into STRICT	nr_seq_congenere_w
	from	pls_segurado
	where	nr_sequencia	= nr_seq_segurado_w;

	if (nr_seq_congenere_w IS NOT NULL AND nr_seq_congenere_w::text <> '') then
		cd_unimed_w		:= adiciona_zeros_esquerda(pls_obter_unimed_benef(nr_seq_segurado_w),4);
		cd_usuario_plano_w	:= Elimina_Caracteres_Especiais(substr(cd_carteirinha_w,5,17));
	else
		CALL wheb_mensagem_pck.exibir_mensagem_abort(131177);
	end if;
else
	CALL wheb_mensagem_pck.exibir_mensagem_abort(179717);
end if;

select	coalesce(max(a.sg_estado),'X')
into STRICT	sg_estado_congenere_w
from	pessoa_juridica	a,
	pls_congenere	b
where	a.cd_cgc	= b.cd_cgc
and	b.nr_sequencia	= nr_seq_congenere_w;

select	coalesce(max(a.sg_estado),'X')
into STRICT	sg_estado_exec_w
from	pessoa_juridica	a,
	pls_congenere	b
where	a.cd_cgc	= b.cd_cgc
and	b.nr_sequencia	= nr_seq_uni_exec_w;

select	max(coalesce(nr_via_solicitacao,1))
into STRICT	nr_via_cartao_w
from	pls_segurado_carteira
where	nr_seq_segurado	= nr_seq_segurado_w;

if (ie_tipo_processo_w	= 'I') then
	ie_tipo_cliente_w	:= 'U';
elsif (ie_tipo_processo_w	in ('P', 'W')) then
	ie_tipo_cliente_w	:= 'P';
end if;

begin
	select	CASE WHEN coalesce(ie_tipo_rede_min_ptu,3)=3 THEN 1 WHEN coalesce(ie_tipo_rede_min_ptu,3)=1 THEN 3  ELSE 2 END
	into STRICT	ie_alto_custo_w
	from	pls_prestador
	where	nr_sequencia	= coalesce(nr_seq_prestador_exec_w, nr_seq_prestador_w);
exception
when others then
	ie_alto_custo_w	:= '3';
end;

if (ie_alto_custo_w	in ('1','2')) or (ie_tipo_guia_w	= 1)then
	begin
		select	substr((coalesce(cd_prestador,nr_sequencia))::numeric ,1,8)
		into STRICT	nr_seq_prest_alto_custo_w
		from	pls_prestador
		where	nr_sequencia	= coalesce(nr_seq_prestador_exec_w, nr_seq_prestador_w);
	exception
	when others then
		nr_seq_prest_alto_custo_w	:= 0;
	end;

	cd_uni_prest_alto_custo_w	:= cd_cooperativa_w;
	nm_prest_alto_custo_w		:= substr(pls_obter_dados_prestador(coalesce(nr_seq_prestador_exec_w, nr_seq_prestador_w),'N'),1,25);
else
	nr_seq_prest_alto_custo_w	:= 0;
	cd_uni_prest_alto_custo_w	:= 0;
	nm_prest_alto_custo_w		:= '';
end if;

begin
	select	ie_permite_pacote
	into STRICT	ie_permite_pacote_w
	from	pls_param_intercambio_scs;
exception
when others then
	ie_permite_pacote_w	:= 'N';
end;

select	max(ie_tipo_envio_via)
into STRICT	ie_tipo_envio_via_w
from	pls_regra_limite_envio_scs
where (coalesce(nr_seq_congenere::text, '') = ''
or	nr_seq_congenere	= nr_seq_congenere_w);

if (ie_tipo_envio_via_w	= 2) then
	nr_via_cartao_w	:= 0;
end if;

cd_unimed_exec_w	:= substr(pls_obter_dados_cooperativa(nr_seq_uni_exec_w,'C'),1,4);

if (ie_tipo_guia_w		= 1) then
	if (nr_seq_clinica_w IS NOT NULL AND nr_seq_clinica_w::text <> '') then
		begin
			select	(cd_ptu)::numeric
			into STRICT	nr_seq_clinica_ptu_w
			from	pls_clinica
			where	nr_sequencia	= nr_seq_clinica_w;
		exception
		when others then
			nr_seq_clinica_ptu_w	:= null;
		end;
	end if;
else
	nr_seq_clinica_ptu_w	:= null;
end if;

select	(obter_idade(dt_nascimento_benef_w, clock_timestamp(), 'A'))::numeric
into STRICT	nr_idade_w
;

select	pls_obter_versao_tiss
into STRICT	cd_versao_tiss_w
;

insert	into ptu_pedido_autorizacao(nr_sequencia, dt_atendimento, ie_tipo_cliente,
	 cd_doenca_cid, ie_alto_custo, cd_unimed_prestador_req,
	 nr_seq_prestador_req, cd_especialidade, ie_urg_emerg,
	 cd_unimed_executora, cd_unimed_beneficiario, cd_unimed,
	 nr_via_cartao, nr_seq_execucao, nm_usuario,
	 dt_atualizacao, cd_usuario_plano, nr_seq_guia,
	 cd_transacao, nr_seq_requisicao, ds_ind_clinica,
	 ds_observacao, nr_seq_prest_alto_custo, cd_unimed_prestador,
	 nm_prestador_alto_custo, nr_versao, ie_recem_nascido,
	 ie_tipo_internacao, ie_tipo_acidente, nm_prof_solicitante,
	 nr_fone_prof_solic, ds_email_prof_solic, cd_unimed_atendimento,
	 ie_anexo, ie_sexo, nm_usuario_nrec,
	 dt_atualizacao_nrec, nr_idade, dt_sug_internacao,
	 ie_ordem_servico, nr_seq_ordem, nr_versao_tiss)
values (nextval('ptu_pedido_autorizacao_seq'), dt_execucao_w, ie_tipo_cliente_w,
	 cd_doenca_w, coalesce(ie_alto_custo_w,'3'), CASE WHEN coalesce(nr_seq_prestador_w::text, '') = '' THEN null  ELSE cd_cooperativa_w END ,
	 nr_seq_prestador_w, cd_espec_ptu_w, ie_urg_emerg_w,
	 cd_cooperativa_w, cd_cooperativa_ww, cd_unimed_w,
	 nr_via_cartao_w, nextval('ptu_controle_execucao_seq'), nm_usuario_p,
	 clock_timestamp(), cd_usuario_plano_w, nr_seq_guia_p,
	 '00600', nr_seq_requisicao_p, ds_indic_clicnica_w,
	 ds_observacao_w, nr_seq_prest_alto_custo_w, cd_uni_prest_alto_custo_w,
	 nm_prest_alto_custo_w, nr_versao_ptu_p, coalesce(ie_recem_nascido_w,'N'),
	 nr_seq_clinica_ptu_w, CASE WHEN ie_indicacao_acidente_w='0' THEN '1' WHEN ie_indicacao_acidente_w='1' THEN '2' WHEN ie_indicacao_acidente_w='2' THEN '3'  ELSE '9' END , nm_medico_solicitante_w,
	 nr_telefone_med_solic_w, ds_email_med_solic_w, cd_unimed_exec_w,
	 coalesce(ie_anexo_guia_w,'N'), ie_sexo_w, nm_usuario_p,
	 clock_timestamp(), nr_idade_w, dt_admissao_hosp_w,
	 CASE WHEN nr_transacao_solicitante_w=0 THEN 'N'  ELSE 'S' END , nr_transacao_solicitante_w, cd_versao_tiss_w) returning nr_sequencia, nr_seq_execucao into nr_seq_pedido_p, nr_seq_controle_exec_w;

insert	into ptu_controle_execucao(nr_sequencia, dt_atualizacao, nm_usuario,
	 nr_seq_pedido_compl, nr_seq_pedido_aut, nm_usuario_nrec,
	 dt_atualizacao_nrec)
values (nr_seq_controle_exec_w, clock_timestamp(), nm_usuario_p,
	 null, nr_seq_pedido_p, nm_usuario_p,
	 clock_timestamp());


if (ie_anexo_guia_w	= 'S') then
	CALL ptu_inserir_dados_anexo_pedido(nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_pedido_p, null, nm_usuario_p);
end if;

open c01;
loop
fetch c01 into
	nr_seq_req_guia_proc_w,
	cd_procedimento_w,
	ie_origem_proced_w,
	qt_proc_solicitada_w,
	qt_proc_autorizada_w,
	vl_procedimento_w,
	nr_seq_pacote_w,
	nr_seq_preco_pacote_w,
	cd_procedimento_ptu_w,
	ds_procedimento_ptu_w,
	ie_pacote_ptu_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	vl_total_w	:= 0;

	select	max(ie_classificacao)
	into STRICT	ie_classificacao_w
	from	procedimento
	where	cd_procedimento		= cd_procedimento_w
	and	ie_origem_proced	= ie_origem_proced_w;

	if (ie_classificacao_w	= 1) then
		ie_tipo_tabela_w	:= '0';
	elsif (ie_classificacao_w	= 2) then
		ie_tipo_tabela_w	:= '1';
	elsif (ie_classificacao_w	= 3) then
		ie_tipo_tabela_w	:= '1';
	else
		ie_tipo_tabela_w	:= '0';
	end if;

	if (nr_seq_pacote_w IS NOT NULL AND nr_seq_pacote_w::text <> '') and (coalesce(ie_permite_pacote_w,'N')	= 'S') then
		ie_tipo_pacote_w	:= ptu_obter_modo_envio_pacote(cd_cooperativa_w, cd_cooperativa_ww, nm_usuario_p);

		if (ie_tipo_pacote_w	= 'A') then
			begin
				select	nr_seq_composicao
				into STRICT	nr_seq_composicao_w
				from	pls_pacote_tipo_acomodacao
				where	nr_sequencia	= nr_seq_preco_pacote_w;
			exception
			when others then
				nr_seq_composicao_w	:= null;
			end;

			open c03;
			loop
			fetch c03 into
				cd_proc_pacote_w,
				ie_origem_proced_w;
			EXIT WHEN NOT FOUND; /* apply on c03 */
				begin

				ds_proc_pacote_w	:= substr(obter_descricao_procedimento(cd_proc_pacote_w,ie_origem_proced_pcte_w),1,100);

				update	ptu_pedido_autorizacao
				set	ds_observacao	= ds_observacao||cd_proc_pacote_w||' - '||ds_proc_pacote_w||','
				where	nr_sequencia	= nr_seq_pedido_p;

				end;
			end loop;
			close c03;

			if (sg_estado_congenere_w <> 'X') and (sg_estado_exec_w <> 'X') and (sg_estado_congenere_w <> sg_estado_exec_w) then
				open c04;
				loop
				fetch c04 into
					nr_seq_material_w;
				EXIT WHEN NOT FOUND; /* apply on c04 */
					begin

					select	ie_tipo_despesa
					into STRICT	ie_tipo_despesa_w
					from	pls_material
					where	nr_sequencia	= nr_seq_material_w;

					if (ie_tipo_despesa_w = '7') then
						cd_material_w	:= substr(pls_obter_seq_codigo_material(nr_seq_material_w,''),1,8);
						ds_opme_w	:= substr(pls_obter_desc_material(nr_seq_material_w),1,255);

						update	ptu_pedido_autorizacao
						set	ds_observacao	= ds_observacao||cd_material_w||' - '||ds_opme_w||','
						where	nr_sequencia	= nr_seq_pedido_p;
					end if;
					end;
				end loop;
				close c04;
			end if;
		end if;

		ie_tipo_tabela_w	:= '4';
	end if;

	if (coalesce(ie_pacote_ptu_w,'N')	= 'S') or (nr_seq_pacote_w IS NOT NULL AND nr_seq_pacote_w::text <> '') then
		ie_pacote_w	:= 'S';
	else
		ie_pacote_w	:= 'N';
	end if;

	if (qt_proc_autorizada_w IS NOT NULL AND qt_proc_autorizada_w::text <> '') and (qt_proc_autorizada_w > 0) then
		qt_procedimento_w	:= qt_proc_autorizada_w;
	else
		qt_procedimento_w	:= qt_proc_solicitada_w;
	end if;

	if (coalesce(vl_procedimento_w, 0) > 0) then
		vl_total_w	:= vl_procedimento_w * qt_procedimento_w;
	end if;

	if (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then
		begin
			select	dt_prev_realizacao
			into STRICT	dt_prev_realizacao_w
			from	pls_lote_anexo_proc_aut
			where	nr_seq_req_proc	= nr_seq_req_guia_proc_w;
		exception
		when others then
			dt_prev_realizacao_w	:= null;
		end;

		begin
			select	ie_tipo_anexo
			into STRICT	ie_tipo_anexo_w
			from	pls_requisicao_proc
			where	nr_sequencia	= nr_seq_req_guia_proc_w;
		exception
		when others then
			ie_tipo_anexo_w	:= null;
		end;

		if (cd_procedimento_ptu_w	<> 99999919) then
			ds_procedimento_ptu_w	:= '';
		end if;

		insert	into ptu_pedido_aut_servico(nr_sequencia,cd_servico, ds_opme,
			 ie_tipo_tabela, nm_usuario, nr_seq_pedido,
			 dt_atualizacao, qt_servico, vl_servico,
			 ie_origem_servico, cd_servico_consersao, nr_seq_req_proc,
			 vl_uni_servico, cd_anvisa, cd_referencia_fab,
			 ie_tipo_anexo, dt_provavel, cd_via_administracao,
			 qt_frequencia_adm, ie_pacote, ie_tipo_ordem,
			 nm_usuario_nrec, dt_atualizacao_nrec)
		values (nextval('ptu_pedido_aut_servico_seq'), cd_procedimento_w, ds_procedimento_ptu_w,
			 ie_tipo_tabela_w, nm_usuario_p, nr_seq_pedido_p,
			 clock_timestamp(), qt_procedimento_w, vl_total_w,
			 ie_origem_proced_w, cd_procedimento_ptu_w, nr_seq_req_guia_proc_w,
			 vl_procedimento_w, null, null,
			 CASE WHEN ie_tipo_anexo_w='OP' THEN 3 WHEN ie_tipo_anexo_w='QU' THEN 1 WHEN ie_tipo_anexo_w='RA' THEN 2  ELSE 9 END , dt_prev_realizacao_w, null,
			 null, ie_pacote_w, null,
			 nm_usuario_p, clock_timestamp()) returning nr_sequencia into nr_seq_pedido_aut_serv_w;
	elsif (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then

		begin
			select	dt_prev_realizacao
			into STRICT	dt_prev_realizacao_w
			from	pls_lote_anexo_proc_aut
			where	nr_seq_plano_proc	= nr_seq_req_guia_proc_w;
		exception
		when others then
			dt_prev_realizacao_w	:= null;
		end;

		begin
			select	ie_tipo_anexo
			into STRICT	ie_tipo_anexo_w
			from	pls_guia_plano_proc
			where	nr_sequencia	= nr_seq_req_guia_proc_w;
		exception
		when others then
			ie_tipo_anexo_w	:= null;
		end;

		if (cd_procedimento_ptu_w	<> 99999919) then
			ds_procedimento_ptu_w	:= '';
		end if;

		--Não pode ser no mesmo insert da Requisição, pois quando é guia, tenho valor para dt_provavel
		insert	into ptu_pedido_aut_servico(nr_sequencia,cd_servico, ds_opme,
			 ie_tipo_tabela, nm_usuario, nr_seq_pedido,
			 dt_atualizacao, qt_servico, vl_servico,
			 ie_origem_servico, cd_servico_consersao, nr_seq_guia_proc,
			 vl_uni_servico, cd_anvisa, cd_referencia_fab,
			 ie_tipo_anexo, dt_provavel, cd_via_administracao,
			 qt_frequencia_adm, ie_pacote, ie_tipo_ordem,
			 nm_usuario_nrec, dt_atualizacao_nrec)
		values (nextval('ptu_pedido_aut_servico_seq'), cd_procedimento_w, ds_procedimento_ptu_w,
			 ie_tipo_tabela_w, nm_usuario_p, nr_seq_pedido_p,
			 clock_timestamp(), qt_procedimento_w, vl_total_w,
			 ie_origem_proced_w, cd_procedimento_ptu_w, nr_seq_req_guia_proc_w,
			 vl_procedimento_w, null, null,
			 CASE WHEN ie_tipo_anexo_w='OP' THEN 3 WHEN ie_tipo_anexo_w='QU' THEN 1 WHEN ie_tipo_anexo_w='RA' THEN 2  ELSE 9 END , dt_prev_realizacao_w, null,
			 null, ie_pacote_w, null,
			 nm_usuario_p, clock_timestamp()) returning nr_sequencia into nr_seq_pedido_aut_serv_w;

	end if;

	if (coalesce(cd_procedimento_ptu_w,0)	<> 0) then
		if (coalesce(vl_procedimento_w,0)	= 0) and ((coalesce(ds_procedimento_ptu_w,'X')	<> 'X') or (ie_pacote_w	= 'S')) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(196741);
		end if;

		select	count(1)
		into STRICT	qt_reg_generico_w
		from	pls_regra_generico_ptu
		where	cd_proc_mat_generico	= cd_procedimento_ptu_w
		and	ie_situacao		= 'A';

		if (qt_reg_generico_w	> 0) and (coalesce(ds_procedimento_ptu_w,'X')	= 'X') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(216706);
		end if;
	end if;
	end;
end loop;
close c01;

open c02;
loop
fetch c02 into
	nr_seq_req_guia_mat_w,
	nr_seq_material_w,
	qt_mat_solicitada_w,
	qt_mat_autorizada_w,
	vl_material_w,
	cd_material_ptu_w,
	ds_material_ptu_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	begin
	vl_total_w	:= 0;

	select	ie_tipo_despesa,
		nr_registro_anvisa
	into STRICT	ie_tipo_despesa_w,
		nr_registro_anvisa_w
	from	pls_material
	where	nr_sequencia	= nr_seq_material_w;

	cd_material_w	:= substr(pls_obter_seq_codigo_material(nr_seq_material_w,''),1,8);

	if (cd_material_w IS NOT NULL AND cd_material_w::text <> '') then
		cd_servico_w		:= cd_material_w;

		if (ie_tipo_despesa_w	= 2) then
			ie_tipo_tabela_w	:= '3';
		elsif (ie_tipo_despesa_w	= 3) then
			ie_tipo_tabela_w	:= '2';
		else
			ie_tipo_tabela_w	:= '2';
		end if;

		if (qt_mat_autorizada_w IS NOT NULL AND qt_mat_autorizada_w::text <> '') and (qt_mat_autorizada_w > 0) then
			qt_material_w	:= qt_mat_autorizada_w;
		else
			qt_material_w	:= qt_mat_solicitada_w;
		end if;

		if (coalesce(vl_material_w,0)	> 0) then
			vl_total_w	:= vl_material_w * qt_material_w;
		end if;

		if (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then
			begin
				select	ie_tipo_anexo
				into STRICT	ie_tipo_anexo_w
				from	pls_requisicao_mat
				where	nr_sequencia	= nr_seq_req_guia_mat_w;
			exception
			when others then
				ie_tipo_anexo_w	:= null;
			end;

			begin
				select	nr_registro_anvisa,
					cd_ref_fabricante_imp,
					ie_via_administracao,
					ie_frequencia_dose,
					dt_prevista,
					ie_opcao_fabricante
				into STRICT	nr_registro_anvisa_w,
					cd_ref_fabricante_imp_w,
					ie_via_administracao_w,
					ie_frequencia_dose_w,
					dt_provavel_w,
					ie_opcao_fabricante_w
				from	pls_lote_anexo_mat_aut
				where	nr_seq_req_mat	= nr_seq_req_guia_mat_w;
			exception
			when others then
				nr_registro_anvisa_w		:= null;
				cd_ref_fabricante_imp_w		:= null;
				ie_via_administracao_w		:= null;
				ie_opcao_fabricante_w		:= null;
			end;

			if	((ie_tipo_despesa_w = '7') or ((trim(both cd_material_ptu_w) IS NOT NULL AND (trim(both cd_material_ptu_w))::text <> ''))) then
				ds_material_ptu_w	:= substr(pls_obter_desc_material(nr_seq_material_w),1,80);
			else
				ds_material_ptu_w	:= '';
			end if;

			insert	into ptu_pedido_aut_servico(nr_sequencia, cd_servico, ds_opme,
				 ie_tipo_tabela, nm_usuario, nr_seq_pedido,
				 dt_atualizacao, qt_servico, vl_servico,
				 cd_servico_consersao, nr_seq_req_mat, vl_uni_servico,
				 cd_anvisa, cd_referencia_fab, ie_tipo_anexo,
				 dt_provavel, cd_via_administracao, qt_frequencia_adm,
				 ie_pacote, ie_tipo_ordem, nm_usuario_nrec,
				 dt_atualizacao_nrec)
			values (nextval('ptu_pedido_aut_servico_seq'), cd_servico_w, ds_material_ptu_w,
				 ie_tipo_tabela_w, nm_usuario_p, nr_seq_pedido_p,
				 clock_timestamp(), qt_material_w, vl_total_w,
				 cd_material_ptu_w, nr_seq_req_guia_mat_w, vl_material_w,
				 nr_registro_anvisa_w, cd_ref_fabricante_imp_w, CASE WHEN ie_tipo_anexo_w='OP' THEN 3 WHEN ie_tipo_anexo_w='QU' THEN 1 WHEN ie_tipo_anexo_w='RA' THEN 2  ELSE 9 END ,
				 dt_provavel_w, ie_via_administracao_w, ie_frequencia_dose_w,
				 'N', CASE WHEN ie_tipo_anexo_w='OP' THEN ie_opcao_fabricante_w  ELSE null END , nm_usuario_p,
				 clock_timestamp()) returning nr_sequencia into nr_seq_pedido_aut_serv_w;
		elsif (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then

			begin
				select	ie_tipo_anexo
				into STRICT	ie_tipo_anexo_w
				from	pls_guia_plano_mat
				where	nr_sequencia	= nr_seq_req_guia_mat_w;
			exception
			when others then
				ie_tipo_anexo_w	:= null;
			end;

			begin
				select	nr_registro_anvisa,
					cd_ref_fabricante_imp,
					ie_via_administracao,
					ie_frequencia_dose,
					dt_prevista,
					ie_opcao_fabricante
				into STRICT	nr_registro_anvisa_w,
					cd_ref_fabricante_imp_w,
					ie_via_administracao_w,
					ie_frequencia_dose_w,
					dt_provavel_w,
					ie_opcao_fabricante_w
				from	pls_lote_anexo_mat_aut
				where	nr_seq_plano_mat	= nr_seq_req_guia_mat_w;
			exception
			when others then
				nr_registro_anvisa_w		:= null;
				cd_ref_fabricante_imp_w		:= null;
				ie_via_administracao_w		:= null;
				ie_opcao_fabricante_w		:= null;
			end;

			if (ie_tipo_despesa_w = '7') or ((trim(both cd_material_ptu_w) IS NOT NULL AND (trim(both cd_material_ptu_w))::text <> '')) then
				ds_material_ptu_w	:= substr(pls_obter_desc_material(nr_seq_material_w),1,80);
			else
				ds_material_ptu_w	:= '';
			end if;

			insert	into ptu_pedido_aut_servico(nr_sequencia, cd_servico, ds_opme,
				 ie_tipo_tabela, nm_usuario, nr_seq_pedido,
				 dt_atualizacao, qt_servico, vl_servico,
				 cd_servico_consersao, nr_seq_guia_mat, vl_uni_servico,
				 cd_anvisa, cd_referencia_fab, ie_tipo_anexo,
				 dt_provavel, cd_via_administracao, qt_frequencia_adm,
				 ie_pacote, ie_tipo_ordem, nm_usuario_nrec,
				 dt_atualizacao_nrec)
			values (nextval('ptu_pedido_aut_servico_seq'), cd_servico_w, ds_material_ptu_w,
				 ie_tipo_tabela_w, nm_usuario_p, nr_seq_pedido_p,
				 clock_timestamp(), qt_material_w, vl_total_w,
				 cd_material_ptu_w, nr_seq_req_guia_mat_w, vl_material_w,
				 nr_registro_anvisa_w, cd_ref_fabricante_imp_w, CASE WHEN ie_tipo_anexo_w='OP' THEN 3 WHEN ie_tipo_anexo_w='QU' THEN 1 WHEN ie_tipo_anexo_w='RA' THEN 2  ELSE 9 END ,
				 dt_provavel_w, ie_via_administracao_w, ie_frequencia_dose_w,
				 'N', CASE WHEN ie_tipo_anexo_w='OP' THEN ie_opcao_fabricante_w  ELSE null END , nm_usuario_p,
				 clock_timestamp()) returning nr_sequencia into nr_seq_pedido_aut_serv_w;
		end if;

		if (coalesce(cd_material_ptu_w,0)	<> 0) then
			if (coalesce(vl_material_w,0)	= 0) and (coalesce(ds_material_ptu_w,'X')	<> 'X') then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(196741);
			end if;

			select	count(1)
			into STRICT	qt_reg_generico_w
			from	pls_regra_generico_ptu
			where	cd_proc_mat_generico	= cd_material_ptu_w
			and	ie_situacao		= 'A';

			if (qt_reg_generico_w	> 0) and (coalesce(ds_material_ptu_w,'X')	= 'X') then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(216706);
			end if;
		end if;
	end if;
	end;
end loop;
close c02;

<<final>>
qt_registros_w	:= 0;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_envio_scs_ws_pck.ptu_envio_ped_autorizacao_web ( nr_seq_requisicao_p pls_requisicao_proc.nr_seq_requisicao%type, nr_seq_guia_p pls_guia_plano_proc.nr_seq_guia%type, nr_versao_ptu_p ptu_pedido_autorizacao.nr_versao%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_pedido_p INOUT ptu_pedido_autorizacao.nr_sequencia%type) FROM PUBLIC;
