-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_util_cta_pck.pls_abrir_procedimento ( nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type ) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Esta procedure e responsavel por gerar novos procedimentos a partir da quantidade infomada nos mesmos
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


qt_procedimento_imp_w		pls_conta_proc.qt_procedimento%type;
vl_taxa_co_imp_unit_w		pls_conta_proc.vl_taxa_co_imp%type;
vl_taxa_material_imp_unit_w	pls_conta_proc.vl_taxa_material_imp%type;
vl_taxa_servico_imp_unit_w	pls_conta_proc.vl_taxa_servico_imp%type;
vl_procedimento_ptu_imp_unit_w	pls_conta_proc.vl_procedimento_ptu_imp%type;
vl_material_ptu_imp_unit_w	pls_conta_proc.vl_material_ptu_imp%type;
vl_co_ptu_imp_unit_w		pls_conta_proc.vl_co_ptu_imp%type;
nr_seq_conta_w			pls_conta.nr_sequencia%type;
nr_seq_conta_proc_w		pls_conta_proc.nr_sequencia%type;
ie_glosa_w			pls_conta_proc_v.ie_glosa%type;
ie_tipo_conta_w			pls_conta_proc_v.ie_tipo_conta%type;

C01 CURSOR(nr_seq_conta_proc_pc	pls_conta_proc.nr_sequencia%type) FOR
	SELECT	nr_sequencia
	from	pls_proc_participante_v
	where	nr_seq_conta_proc	= nr_seq_conta_proc_pc;

BEGIN

select	a.qt_procedimento_imp,
	a.vl_taxa_co_imp,
	a.vl_taxa_material_imp,
	a.vl_taxa_servico_imp,
	a.vl_procedimento_ptu_imp,
	a.vl_material_ptu_imp,
	a.vl_co_ptu_imp,
	a.nr_seq_conta,
	a.ie_tipo_conta,
	a.ie_glosa
into STRICT	qt_procedimento_imp_w,
	vl_taxa_co_imp_unit_w,
	vl_taxa_material_imp_unit_w,
	vl_taxa_servico_imp_unit_w,
	vl_procedimento_ptu_imp_unit_w,
	vl_material_ptu_imp_unit_w,
	vl_co_ptu_imp_unit_w,
	nr_seq_conta_w,
	ie_tipo_conta_w,
	ie_glosa_w
from	pls_conta_proc_v	a
where	a.nr_sequencia = nr_seq_conta_proc_p;

if (coalesce(qt_procedimento_imp_w,0) > 1) and (ie_glosa_w	= 'N')	then

	vl_taxa_co_imp_unit_w	  	:= dividir(vl_taxa_co_imp_unit_w,		qt_procedimento_imp_w);
	vl_taxa_material_imp_unit_w     := dividir(vl_taxa_material_imp_unit_w,		qt_procedimento_imp_w);
	vl_taxa_servico_imp_unit_w      := dividir(vl_taxa_servico_imp_unit_w,		qt_procedimento_imp_w);
	vl_procedimento_ptu_imp_unit_w  := dividir(vl_procedimento_ptu_imp_unit_w,	qt_procedimento_imp_w);
	vl_material_ptu_imp_unit_w      := dividir(vl_material_ptu_imp_unit_w,		qt_procedimento_imp_w);
	vl_co_ptu_imp_unit_w		:= dividir(vl_co_ptu_imp_unit_w,		qt_procedimento_imp_w);

	update	pls_conta_proc
	set	qt_procedimento_imp	= 1,
		vl_procedimento_imp	= vl_procedimento_imp - vl_unitario_imp,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp(),
		vl_taxa_co_imp		= vl_taxa_co_imp_unit_w,
		vl_taxa_material_imp    = vl_taxa_material_imp_unit_w,
		vl_taxa_servico_imp     = vl_taxa_servico_imp_unit_w,
		vl_procedimento_ptu_imp	= vl_procedimento_ptu_imp_unit_w,
		vl_material_ptu_imp	= vl_material_ptu_imp_unit_w,
		vl_co_ptu_imp		= vl_co_ptu_imp_unit_w
	where	nr_sequencia		= nr_seq_conta_proc_p;

	-- Somente serao gerados novos procedimentos se a quantidade informada no procedimento for maior que 1

	for i in 1..(qt_procedimento_imp_w - 1) loop
		begin

		select	nextval('pls_conta_proc_seq')
		into STRICT	nr_seq_conta_proc_w
		;

		insert into pls_conta_proc(	nr_sequencia, dt_atualizacao, nm_usuario,
				dt_atualizacao_nrec, nm_usuario_nrec, dt_procedimento,
				cd_procedimento, ie_origem_proced, qt_procedimento,
				vl_unitario, vl_procedimento, ie_via_acesso,
				nr_seq_conta, dt_procedimento_imp, cd_procedimento_imp,
				qt_procedimento_imp, vl_unitario_imp, vl_procedimento_imp,
				ie_via_acesso_imp, dt_inicio_proc, dt_fim_proc,
				dt_inicio_proc_imp, dt_fim_proc_imp, tx_participacao,
				vl_participacao, ds_procedimento_imp, cd_tipo_tabela_imp,
				tx_reducao_acrescimo_imp, ie_tipo_despesa_imp, ie_tecnica_utilizada,
				vl_liberado, vl_glosa, vl_saldo,
				nr_seq_regra, ie_tipo_despesa, ie_situacao,
				ie_status, dt_liberacao, nm_usuario_liberacao,
				tx_item, nr_seq_tiss_tabela, nr_seq_regra_horario,
				vl_custo_operacional, vl_anestesista, vl_materiais,
				vl_medico, vl_auxiliares, nr_seq_regra_liberacao,
				ds_log, cd_conta_cred, cd_conta_deb,
				cd_historico, cd_conta_glosa_cred, cd_conta_glosa_deb,
				cd_historico_glosa, nr_seq_regra_ctb_deb, nr_seq_regra_ctb_cred,
				nr_seq_grupo_ans, nr_seq_honorario_crit, nr_seq_dados_proc,
				nr_seq_pacote, vl_beneficiario, nr_seq_regra_pos_estab,
				ie_cobranca_prevista, ds_justificativa, nr_seq_grupo_ans_sup,
				nr_lote_provisao, nr_lote_contabil, vl_coparticipacao,
				vl_liquido, cd_conta_copartic_cred, cd_conta_copartic_deb,
				cd_historico_copartic, ie_valor_informado, ie_sca,
				nr_seq_mensalidade_item, nr_seq_tabela_sca, nr_seq_cobertura,
				nr_seq_item_sip, nr_seq_regra_vinculo, ie_tipo_cobertura,
				nr_seq_sca_cobertura, nr_seq_tipo_limitacao, nr_seq_conta_medica, vl_proc_copartic,
				nr_seq_regra_copartic, ie_tipo_contratacao, ie_segmentacao_sip,
				cd_item_sip, sg_uf_sip, cd_classificacao_sip,
				cd_porte_anestesico, nr_seq_setor_atend,
				ie_autogerado, dt_item_sip, ie_ato_cooperado, nr_seq_regra_cooperado,
				cd_medico_solicitante, tx_intercambio, vl_intercambio,
				tx_pcmso, vl_pcmso, cd_classif_cred,
				cd_classif_deb, nr_seq_regra_valor, ie_estagio_complemento,
				nr_seq_proc_princ, nr_seq_proc_ref, ie_via_obrigatoria,
				ie_glosa, nr_seq_participante_hi, vl_taxa_co_imp,
				vl_taxa_material_imp, vl_taxa_servico_imp, vl_procedimento_ptu_imp,
				vl_material_ptu_imp, vl_co_ptu_imp, nr_seq_regra_qtde_exec,
				tx_intercambio_imp, ie_regra_qtde_execucao )
			(SELECT	nr_seq_conta_proc_w, clock_timestamp(), nm_usuario_p,
				clock_timestamp(), nm_usuario_p, dt_procedimento,
				cd_procedimento, ie_origem_proced, 1,
				vl_unitario, vl_procedimento, ie_via_acesso,
				nr_seq_conta, dt_procedimento_imp, cd_procedimento_imp,
				1, vl_unitario_imp, vl_unitario_imp,
				ie_via_acesso_imp, dt_inicio_proc, dt_fim_proc,
				dt_inicio_proc_imp, dt_fim_proc_imp, tx_participacao,
				vl_participacao, ds_procedimento_imp, cd_tipo_tabela_imp,
				tx_reducao_acrescimo_imp, ie_tipo_despesa_imp, ie_tecnica_utilizada,
				vl_liberado, vl_glosa, vl_saldo,
				nr_seq_regra, ie_tipo_despesa, ie_situacao,
				ie_status, dt_liberacao, nm_usuario_liberacao,
				tx_item, nr_seq_tiss_tabela, nr_seq_regra_horario,
				vl_custo_operacional, vl_anestesista, vl_materiais,
				vl_medico, vl_auxiliares, nr_seq_regra_liberacao,
				ds_log, cd_conta_cred, cd_conta_deb,
				cd_historico, cd_conta_glosa_cred, cd_conta_glosa_deb,
				cd_historico_glosa, nr_seq_regra_ctb_deb, nr_seq_regra_ctb_cred,
				nr_seq_grupo_ans, nr_seq_honorario_crit, nr_seq_dados_proc,
				nr_seq_pacote, vl_beneficiario, nr_seq_regra_pos_estab,
				ie_cobranca_prevista, ds_justificativa, nr_seq_grupo_ans_sup,
				nr_lote_provisao, nr_lote_contabil, vl_coparticipacao,
				vl_liquido, cd_conta_copartic_cred, cd_conta_copartic_deb,
				cd_historico_copartic, ie_valor_informado, ie_sca,
				nr_seq_mensalidade_item, nr_seq_tabela_sca, nr_seq_cobertura,
				nr_seq_item_sip, nr_seq_regra_vinculo, ie_tipo_cobertura,
				nr_seq_sca_cobertura, nr_seq_tipo_limitacao, nr_seq_conta_medica, vl_proc_copartic,
				nr_seq_regra_copartic, ie_tipo_contratacao, ie_segmentacao_sip,
				cd_item_sip, sg_uf_sip, cd_classificacao_sip,
				cd_porte_anestesico, nr_seq_setor_atend,
				ie_autogerado, dt_item_sip, ie_ato_cooperado, nr_seq_regra_cooperado,
				cd_medico_solicitante, tx_intercambio, vl_intercambio,
				tx_pcmso, vl_pcmso, cd_classif_cred,
				cd_classif_deb, nr_seq_regra_valor, ie_estagio_complemento,
				nr_seq_conta_proc_p, nr_seq_proc_ref, ie_via_obrigatoria,
				ie_glosa, nr_seq_participante_hi, vl_taxa_co_imp_unit_w,
				vl_taxa_material_imp_unit_w, vl_taxa_servico_imp_unit_w, vl_procedimento_ptu_imp_unit_w,
				vl_material_ptu_imp_unit_w, vl_co_ptu_imp_unit_w, nr_seq_regra_qtde_exec,
				tx_intercambio_imp, ie_regra_qtde_execucao
			from	pls_conta_proc
			where	nr_sequencia	= nr_seq_conta_proc_p);

			insert into pls_conta_proc_regra(cd_edicao_amb, ds_item_ptu, dt_atualizacao,
						dt_atualizacao_nrec, dt_valorizacao,
								nm_usuario, nm_usuario_nrec, nr_seq_cp_comb_filtro,
								nr_seq_cp_comb_filtro_cop , nr_seq_cp_comb_proc_cop_entao, nr_seq_cp_comb_proc_entao,
								nr_seq_cp_comb_serv_cop_entao, nr_seq_cp_comb_serv_entao, nr_seq_regra_tx_adm,
								nr_seq_regra_via_obrig, nr_sequencia, tp_rede_min,
								tx_item, vl_anestesista, vl_anestesista_cop,
								vl_auxiliares, vl_auxiliares_cop, vl_custo_operacional ,
								vl_custo_operacional_cop, vl_filme_cop, vl_materiais,
								vl_medico, vl_medico_cop, vl_procedimento_base,
								vl_procedimento_cop, vl_recalculo, nr_seq_item_tiss,
								nr_seq_item_tiss_vinculo
								)
				(SELECT 	cd_edicao_amb, ds_item_ptu, dt_atualizacao,
							dt_atualizacao_nrec, dt_valorizacao, 
							nm_usuario, nm_usuario_nrec, nr_seq_cp_comb_filtro,
							nr_seq_cp_comb_filtro_cop , nr_seq_cp_comb_proc_cop_entao, nr_seq_cp_comb_proc_entao,
							nr_seq_cp_comb_serv_cop_entao, nr_seq_cp_comb_serv_entao, nr_seq_regra_tx_adm,
							nr_seq_regra_via_obrig, nr_seq_conta_proc_w, tp_rede_min,
							tx_item, vl_anestesista, vl_anestesista_cop,
							vl_auxiliares, vl_auxiliares_cop, vl_custo_operacional ,
							vl_custo_operacional_cop, vl_filme_cop, vl_materiais,
							vl_medico, vl_medico_cop, vl_procedimento_base,
							vl_procedimento_cop, vl_recalculo, nr_seq_item_tiss,
							nr_seq_item_tiss_vinculo
			from	pls_conta_proc_regra where nr_sequencia = nr_seq_conta_proc_p);

			CALL pls_gravar_log_conta(	nr_seq_conta_w, nr_seq_conta_proc_w, null,
						'Procedimento '||nr_seq_conta_proc_w||' gerado pelo sistema quantidade de execucao/via acesso! ', nm_usuario_p);

		CALL pls_util_cta_pck.pls_abrir_proc_participante(nr_seq_conta_proc_p, nr_seq_conta_proc_w, nm_usuario_p, cd_estabelecimento_p);
		end;
	end loop;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_util_cta_pck.pls_abrir_procedimento ( nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type ) FROM PUBLIC;