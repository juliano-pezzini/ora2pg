-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_gerar_aih_retorno_72h ( nr_aih_p bigint, nr_sequencia_p bigint, nr_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE



nr_seq_aih_w		bigint;
nr_seq_interno_w	bigint;
nr_seq_interno_novo_w	bigint;


BEGIN

select	coalesce(max(nr_sequencia),0) + 1
into STRICT	nr_seq_aih_w
from	sus_aih_unif
where	nr_aih 		= nr_aih_p
and	nr_sequencia	= nr_sequencia_p;

insert into sus_aih_unif(
		nr_aih, nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
		nm_usuario_nrec, cd_estabelecimento, ie_identificacao_aih, nr_proxima_aih, nr_anterior_aih,
		dt_emissao, ie_mudanca_proc, cd_procedimento_solic, ie_origem_proc_solic, cd_procedimento_real,
		ie_origem_proc_real, cd_medico_solic, cd_cid_principal, cd_cid_secundario, cd_cid_causa_compl,
		cd_cid_causa_morte, nr_interno_conta, nr_atendimento, cd_medico_responsavel, cd_modalidade,
		cd_carater_internacao, cd_motivo_cobranca, cd_especialidade_aih, ie_codigo_autorizacao, qt_nascido_vivo,
		qt_nascido_morto, qt_saida_alta, qt_saida_transferencia, qt_saida_obito, nr_gestante_prenatal,
		cd_orgao_emissor_aih)
SELECT		nr_aih, nr_seq_aih_w, clock_timestamp(), nm_usuario_p, clock_timestamp(),
		nm_usuario_p, cd_estabelecimento, '01', nr_proxima_aih, nr_anterior_aih,
		dt_emissao, ie_mudanca_proc, cd_procedimento_solic, ie_origem_proc_solic, cd_procedimento_real,
		ie_origem_proc_real, cd_medico_solic, cd_cid_principal, cd_cid_secundario, cd_cid_causa_compl,
		cd_cid_causa_morte, null, nr_atendimento_p, cd_medico_responsavel, cd_modalidade,
		cd_carater_internacao, cd_motivo_cobranca, cd_especialidade_aih, ie_codigo_autorizacao, qt_nascido_vivo,
		qt_nascido_morto, qt_saida_alta, qt_saida_transferencia, qt_saida_obito, nr_gestante_prenatal,
		cd_orgao_emissor_aih
from		sus_aih_unif
where		nr_aih			= nr_aih_p
and 		nr_sequencia		= nr_sequencia_p;

select	coalesce(max(nr_seq_interno),0)
into STRICT	nr_seq_interno_w
from	sus_laudo_paciente
where	nr_aih 		= nr_aih_p
and	nr_seq_aih	= nr_sequencia_p;

if (nr_seq_interno_w <> 0) then
	begin
	
	select	nextval('sus_laudo_paciente_seq')
	into STRICT	nr_seq_interno_novo_w
	;

	insert into sus_laudo_paciente(
		nr_atendimento, 		nr_seq_interno,
		nr_laudo_sus,		dt_emissao,
		cd_procedimento_solic,	ie_origem_proced,
		qt_procedimento_solic,	cd_medico_requisitante,
		cd_medico_responsavel,	dt_atualizacao,
		nm_usuario,		dt_diagnostico,
		ds_motivo_internacao,	ds_motivo_alteracao,
		nr_aih,			ds_sinal_sintoma,
		ds_condicao_justifica,	ds_result_prova,
		cd_cid_principal,		ie_lifonodos_reg_inval,
		ds_localizacao_metastase,	ds_estadio_uicc,
		ds_estadio_outro_sist,	cd_grau_histopat,
		cd_diag_cito_hist,		dt_diag_cito_hist,
		ie_tratamento_ant,		ds_tratamento_ant,
		dt_pri_tratamento,		dt_seg_tratamento,
		dt_ter_tratamento,		ie_continuidade_trat,
		dt_inicio_trat_solic,		ie_via_tratamento,
		ie_finalidade,		ds_sigla_esquema,
		qt_meses_prev,		qt_meses_autorizado,
		cd_tipo_tratamento,		cd_associacao,
		ds_complemento,		nr_seq_equip,
		qt_dose_area_dia,		qt_campo_area_dia,
		qt_total_dia_area,		qt_check_films,
		qt_insercoes,		dt_inicio_trat,
		dt_fim_trat,		ds_marcara,
		qt_total_campo_prev,	qt_campo_pago,
		qt_bloco_pre,		ie_tipo_laudo_sus,
		qt_prev_mes1,		qt_prev_mes2,
		qt_prev_mes3,		nr_atendimento_origem,
		ie_status_processo,		ie_classificacao,
		nr_interno_conta,		ie_origem_laudo_apac,
		ie_tipo_laudo_apac,	ds_justificativa,
		ds_inconsistencia,		cd_cid_morfologia,
		ie_metastase,		qt_radiacao,
		cd_cid_secundario,		ds_tratamento_ant2,
		ds_tratamento_ant3,	ds_hipotese_diag,
		ds_resumo_exame_fis,	ds_exame_resultado,
		ie_recidivado,		ie_via_it,
		ie_via_iv,     		ie_via_sc,
		ie_via_im,     		ie_via_vo,
		ie_via_ives,   		ie_via_outros,
		ie_diaria_acomp,		qt_altura,
		qt_peso,			ie_gestante,
		ie_transplante,		qt_transplante,
		ie_classif_hemofilia,		ie_inibidor,
		ie_prova_diag,		cd_cid_topografia,
		nr_seq_pri_trat,		nr_seq_seg_trat,
		nr_seq_ter_trat,		ds_outros_trat_ant,
		ds_anamnese,		ds_alteracao_laborat,
		cd_cid_causa_assoc,   	dt_metastase, dt_pri_dialise,
		qt_altura_cm, 		qt_diurese,
		qt_glicose,		pr_albumina,
		pr_hb,			nr_tru,
		ie_acesso_vascular,	ie_hiv,
		ie_hcv,			ie_hb_sangue,
		ie_ultra_abdomen,	ie_inscrito_cncdo,
		cd_cid_prim_trat,	cd_cid_seg_trat,
		cd_cid_terc_trat,	cd_cnpj_executor,	
		dt_transplante,		nr_seq_aih, NR_SEQ_MORF_DESC_ADIC)
	SELECT	nr_atendimento_p, 	nr_seq_interno_novo_w,
		nr_laudo_sus + 1,	dt_emissao,
		cd_procedimento_solic,	ie_origem_proced,
		qt_procedimento_solic,	cd_medico_requisitante,
		cd_medico_responsavel,	clock_timestamp(),
		nm_usuario_p,		dt_diagnostico,
		ds_motivo_internacao,	ds_motivo_alteracao,
		nr_aih,			ds_sinal_sintoma,
		ds_condicao_justifica,	ds_result_prova,
		cd_cid_principal,		ie_lifonodos_reg_inval,
		ds_localizacao_metastase,	ds_estadio_uicc,
		ds_estadio_outro_sist,	cd_grau_histopat,
		cd_diag_cito_hist,		dt_diag_cito_hist,
		ie_tratamento_ant,		ds_tratamento_ant,
		dt_pri_tratamento,		dt_seg_tratamento,
		dt_ter_tratamento,		ie_continuidade_trat,
		dt_inicio_trat_solic,		ie_via_tratamento,
		ie_finalidade,		ds_sigla_esquema,
		qt_meses_prev,		qt_meses_autorizado,
		cd_tipo_tratamento,		cd_associacao,
		ds_complemento,		nr_seq_equip,
		qt_dose_area_dia,		qt_campo_area_dia,
		qt_total_dia_area,		qt_check_films,
		qt_insercoes,		dt_inicio_trat,
		dt_fim_trat,		ds_marcara,
		qt_total_campo_prev,	qt_campo_pago,
		qt_bloco_pre,		ie_tipo_laudo_sus,
		qt_prev_mes1,		qt_prev_mes2,
		qt_prev_mes3,		nr_atendimento_origem,
		ie_status_processo,		ie_classificacao,
		nr_interno_conta,		ie_origem_laudo_apac,
		ie_tipo_laudo_apac,	ds_justificativa,
		ds_inconsistencia,		cd_cid_morfologia,
		ie_metastase,		qt_radiacao,
		cd_cid_secundario,		ds_tratamento_ant2,
		ds_tratamento_ant3,	ds_hipotese_diag,
		ds_resumo_exame_fis,	ds_exame_resultado,
		ie_recidivado, 		ie_via_it,
		ie_via_iv,     		ie_via_sc,
		ie_via_im,     		ie_via_vo,
		ie_via_ives,   		ie_via_outros,
		coalesce(ie_diaria_acomp,'N'),	qt_altura,
		qt_peso,			ie_gestante,
		ie_transplante,		qt_transplante,
		ie_classif_hemofilia,		ie_inibidor,
		ie_prova_diag,		null,
		nr_seq_pri_trat,		nr_seq_seg_trat,
		nr_seq_ter_trat,		ds_outros_trat_ant,
		ds_anamnese,		ds_alteracao_laborat,
		cd_cid_causa_assoc,   	dt_metastase, dt_pri_dialise,
		qt_altura_cm,		qt_diurese,
		qt_glicose,		pr_albumina,
		pr_hb,			nr_tru,
		ie_acesso_vascular,	ie_hiv,
		ie_hcv,			ie_hb_sangue,
		ie_ultra_abdomen,	ie_inscrito_cncdo,
		cd_cid_prim_trat,	cd_cid_seg_trat,
		cd_cid_terc_trat,	cd_cnpj_executor,
		dt_transplante,		nr_seq_aih_w, NR_SEQ_MORF_DESC_ADIC
	from	sus_laudo_paciente
	where	nr_seq_interno = nr_seq_interno_w;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_gerar_aih_retorno_72h ( nr_aih_p bigint, nr_sequencia_p bigint, nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

