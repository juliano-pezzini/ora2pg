-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_cta_gera_hono_cirurgia_pck.gera_conta_abert_conta ( nr_seq_conta_origem_p pls_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_segurado_p pls_conta.nr_seq_segurado%type, cd_guia_proc_p pls_proc_participante.cd_guia%type, nr_seq_prestador_p pls_proc_participante.nr_seq_prestador%type, nr_seq_grau_partic_p pls_proc_participante.nr_seq_grau_partic%type, cd_medico_proc_p pls_proc_participante.cd_medico%type, ie_tipo_guia_p pls_conta.ie_tipo_guia%type, nr_seq_cbo_saude_p pls_proc_participante.nr_seq_cbo_saude%type, nr_seq_exec_p pls_execucao_cirurgica.nr_sequencia%type, nr_seq_exec_cir_guia_p pls_exec_cirurgica_guia.nr_sequencia%type, ie_tipo_faturamento_p pls_conta.ie_tipo_faturamento%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, dados_regra_p dados_regra_abertura_conta, nr_seq_conta_p INOUT pls_conta.nr_sequencia%type, ie_gerou_novo_p INOUT text) AS $body$
DECLARE

					
nr_seq_conta_w		pls_conta.nr_sequencia%type;
cd_medico_w 		pls_conta.cd_medico_executor%type;
nr_crm_exec_w 		pls_conta.nr_crm_exec%type;
nr_seq_conselho_exec_w	pls_conta.nr_seq_conselho_exec%type;
uf_crm_exec_w 		pls_conta.uf_crm_exec%type;
nr_seq_grau_partic_w 	pls_conta.nr_seq_grau_partic%type;
nr_seq_prest_exec_w	pls_prestador.nr_sequencia%type;


BEGIN

-- So alimenta as informacoes do medico executor na conta se nao for pra gerar participante.
if (dados_regra_p.ie_gerar_participante = 'S') then
	nr_seq_prest_exec_w	:= pls_obter_credenciado(cd_medico_proc_p, cd_estabelecimento_p);
else
	if (cd_medico_proc_p IS NOT NULL AND cd_medico_proc_p::text <> '') then
		cd_medico_w 		:= cd_medico_proc_p;
		nr_crm_exec_w 		:= obter_crm_medico(cd_medico_proc_p);
		nr_seq_conselho_exec_w	:= pls_obter_seq_conselho_prof(cd_medico_proc_p);
		uf_crm_exec_w 		:= obter_dados_medico(cd_medico_proc_p, 'UFCRM');
	end if;
	nr_seq_grau_partic_w 	:= nr_seq_grau_partic_p;
	nr_seq_prest_exec_w	:= nr_seq_prestador_p;
end if;

-- se no processo anterior (criacao do protocolo) criou um novo registro, obviamente aqui so deve ser gerada uma nova conta e nem precisa fazer um select para buscar
if (ie_gerou_novo_p = 'N') then
	
	if (dados_regra_p.ie_gerar_participante = 'S') then
		-- verifica se ja existe uma conta
		select	max(nr_sequencia)
		into STRICT	nr_seq_conta_w
		from	pls_conta
		where	nr_seq_protocolo 	= nr_seq_protocolo_p
		and	nr_seq_segurado		= nr_seq_segurado_p
		and	cd_guia 		= coalesce(cd_guia_proc_p,cd_guia)
		and	nr_seq_prestador_exec	= nr_seq_prest_exec_w
		and	nr_seq_conta_referencia	= nr_seq_conta_origem_p
		and	coalesce(cd_medico_executor::text, '') = ''
		and	coalesce(nr_seq_analise::text, '') = ''
		and	ie_status 		!= 'C';
	else
		-- verifica se ja existe uma conta
		select	max(nr_sequencia)
		into STRICT	nr_seq_conta_w
		from	pls_conta
		where	nr_seq_protocolo 	= nr_seq_protocolo_p
		and	nr_seq_segurado		= nr_seq_segurado_p
		and	cd_guia 		= coalesce(cd_guia_proc_p,cd_guia)
		and	nr_seq_prestador_exec	= nr_seq_prest_exec_w
		and	nr_seq_grau_partic 	= nr_seq_grau_partic_p
		and	nr_seq_conta_referencia	= nr_seq_conta_origem_p
		and	((coalesce(cd_medico_executor::text, '') = '') or (cd_medico_executor = cd_medico_proc_p))
		and	coalesce(nr_seq_analise::text, '') = ''
		and	ie_status 		!= 'C';
	end if;
end if;

--Se nao existe a conta ou se foi gerado um novo protocolo, cria uma nova conta
if (coalesce(nr_seq_conta_w::text, '') = '' or ie_gerou_novo_p = 'S') then
	select	nextval('pls_conta_seq')
	into STRICT	nr_seq_conta_w
	;
	ie_gerou_novo_p := 'S';
	
	insert into pls_conta(nr_seq_protocolo, cd_guia, cd_guia_referencia,
		cd_guia_prestador, dt_emissao, cd_senha,                
		ie_tipo_guia, nr_seq_segurado, nr_seq_prestador_exec,   
		cd_cnes, cd_medico_executor, nr_seq_grau_partic,      
		nr_seq_cbo_saude, nr_seq_tipo_acomodacao,  
		ie_status, cd_usuario_plano_imp, dt_atualizacao, 
		nm_usuario, cd_estabelecimento, nr_seq_conta_referencia, 
		nr_sequencia, cd_cooperativa, nr_crm_exec, 
		nr_seq_conselho_exec, uf_crm_exec, ie_carater_internacao,
		nr_seq_tipo_atendimento, nr_seq_saida_spsadt, cd_medico_solicitante,
		nr_seq_prestador,ie_origem_conta, nr_seq_regra_conta_auto,
		dt_atendimento, nr_seq_analise, cd_guia_ans,ie_indicacao_acidente, ie_tipo_consulta,
		dt_inicio_faturamento, dt_fim_faturamento,cd_guia_prestador_ans,
		dt_atualizacao_nrec, ds_indicacao_clinica, nm_recem_nascido,
		ie_recem_nascido, ie_tipo_faturamento, ie_tipo_doenca, ds_observacao,
		ie_cobertura_especial, ie_regime_atendimento, ie_saude_ocupacional)  
	SELECT	nr_seq_protocolo_p, coalesce(cd_guia_proc_p, coalesce(cd_guia_ref,cd_guia)), coalesce(cd_guia_ref,cd_guia),
		cd_guia_prestador, dt_emissao, cd_senha,                
		ie_tipo_guia_p, nr_seq_segurado, nr_seq_prest_exec_w,   
		cd_cnes, cd_medico_w, nr_seq_grau_partic_w,      
		nr_seq_cbo_saude_p, nr_seq_tipo_acomodacao,  
		'U', cd_usuario_plano_imp, clock_timestamp(), 
		nm_usuario_p, cd_estabelecimento, nr_seq_conta_origem_p, 
		nr_seq_conta_w, cd_cooperativa, nr_crm_exec_w, 
		nr_seq_conselho_exec_w, uf_crm_exec_w, ie_carater_internacao,
		nr_seq_tipo_atendimento, nr_seq_saida_spsadt, cd_medico_solicitante,
		nr_seq_prestador, ie_origem_conta, dados_regra_p.nr_sequencia,
		dt_atendimento, nr_seq_analise, to_char(nr_seq_conta_w),ie_indicacao_acidente, ie_tipo_consulta,
		dt_inicio_faturamento, dt_fim_faturamento,to_char(nr_seq_conta_w),
		clock_timestamp(), ds_indicacao_clinica, nm_recem_nascido,
		ie_recem_nascido, ie_tipo_faturamento, ie_tipo_doenca, ds_observacao,
		ie_cobertura_especial, ie_regime_atendimento, ie_saude_ocupacional
	from	pls_conta_v
	where	nr_sequencia	= nr_seq_conta_origem_p;
	
	CALL pls_cta_gera_hono_cirurgia_pck.seta_execucao_aberta(nr_seq_exec_p, ie_tipo_faturamento_p, nr_seq_exec_cir_guia_p);
	
	CALL pls_conta_tiss_pck.cria_copia_registro(nr_seq_conta_origem_p, nr_seq_conta_w, nm_usuario_p);
	
	CALL pls_cta_gera_hono_cirurgia_pck.gera_log_exec_cirurgica( nr_seq_exec_p, nr_seq_conta_origem_p, nr_seq_conta_w,
				nr_seq_exec_cir_guia_p,  nm_usuario_p, cd_estabelecimento_p );
	
	pls_util_pck.get_ie_conta_criada_w	:= 'S';
else
	ie_gerou_novo_p := 'N';
end if;

nr_seq_conta_p := nr_seq_conta_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_gera_hono_cirurgia_pck.gera_conta_abert_conta ( nr_seq_conta_origem_p pls_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_segurado_p pls_conta.nr_seq_segurado%type, cd_guia_proc_p pls_proc_participante.cd_guia%type, nr_seq_prestador_p pls_proc_participante.nr_seq_prestador%type, nr_seq_grau_partic_p pls_proc_participante.nr_seq_grau_partic%type, cd_medico_proc_p pls_proc_participante.cd_medico%type, ie_tipo_guia_p pls_conta.ie_tipo_guia%type, nr_seq_cbo_saude_p pls_proc_participante.nr_seq_cbo_saude%type, nr_seq_exec_p pls_execucao_cirurgica.nr_sequencia%type, nr_seq_exec_cir_guia_p pls_exec_cirurgica_guia.nr_sequencia%type, ie_tipo_faturamento_p pls_conta.ie_tipo_faturamento%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, dados_regra_p dados_regra_abertura_conta, nr_seq_conta_p INOUT pls_conta.nr_sequencia%type, ie_gerou_novo_p INOUT text) FROM PUBLIC;