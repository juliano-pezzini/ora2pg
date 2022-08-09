-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_sus_laudo_paciente ( nr_seq_interno_p bigint, nr_atendimento_p bigint, nm_usuario_p text, nr_seq_novo_p INOUT bigint) AS $body$
DECLARE


nr_laudo_sus_w		smallint;
cd_pessoa_fisica_w	varchar(10);
cd_paciente_w		varchar(10);
dt_inicio_val_apac_w	timestamp;
dt_fim_val_apac_w		timestamp;
dt_mes_atual_w		timestamp;
qt_reg_mes_w		integer	:= 0;
qt_atualiza_mes_w		integer	:= 0;
qt_meses_aut_w		integer	:= 0;
dt_emissao_w		timestamp;
ie_mes_pos_validade_w	varchar(2) := 'N';
ie_mes_autor_w		varchar(2) := 'N';
calcula_meses_w		varchar(2) := 'S';
cd_cid_topografia_w	varchar(10);
ie_data_atual_emis_w	varchar(2) := 'N';
ie_classificacao_w		smallint;
nr_atend_origem_w	numeric(20);
resumo_exame_fis_w      varchar(2) := 'S';


BEGIN

ie_mes_pos_validade_w := obter_param_usuario(1124, 43, obter_perfil_ativo, nm_usuario_p, 0, ie_mes_pos_validade_w);
ie_mes_autor_w := obter_param_usuario(1124, 44, obter_perfil_ativo, nm_usuario_p, 0, ie_mes_autor_w);
ie_data_atual_emis_w := obter_param_usuario(1006, 27, obter_perfil_ativo, nm_usuario_p, 0, ie_data_atual_emis_w);
calcula_meses_w := obter_param_usuario(1124, 108, obter_perfil_ativo, nm_usuario_p, 0, calcula_meses_w);
resumo_exame_fis_w := obter_param_usuario(1006, 75, obter_perfil_ativo, nm_usuario_p, 0, resumo_exame_fis_w);

select	obter_dados_usuario_opcao(nm_usuario_p,'C')
into STRICT	cd_pessoa_fisica_w
;

begin
select	cd_pessoa_fisica
into STRICT	cd_pessoa_fisica_w
from	medico
where	cd_pessoa_fisica	= cd_pessoa_fisica_w;
exception
when others then
	cd_pessoa_fisica_w	:= null;
end;

if (nr_atendimento_p > 0) then
	select	coalesce(max(nr_laudo_sus),0)
	into STRICT	nr_laudo_sus_w
	from	sus_laudo_paciente
	where (nr_atendimento, ie_tipo_laudo_sus) =  (	SELECT	nr_atendimento_p, ie_tipo_laudo_sus
						from	sus_laudo_paciente
						where	nr_seq_interno = nr_seq_interno_p);
else
	select	coalesce(max(nr_laudo_sus),0)
	into STRICT	nr_laudo_sus_w
	from	sus_laudo_paciente
	where (nr_atendimento, ie_tipo_laudo_sus) =  (	SELECT	nr_atendimento, ie_tipo_laudo_sus
						from	sus_laudo_paciente
						where	nr_seq_interno = nr_seq_interno_p);
end if;

select	b.cd_pessoa_fisica,
	a.dt_inicio_val_apac,
	a.dt_fim_val_apac,
	coalesce(qt_meses_autorizado,0),
	a.ie_classificacao,
	a.nr_atendimento
into STRICT	cd_paciente_w,
	dt_inicio_val_apac_w,
	dt_fim_val_apac_w,
	qt_meses_aut_w,
	ie_classificacao_w,
	nr_atend_origem_w
from	atendimento_paciente	b,
	sus_laudo_paciente	a
where	a.nr_atendimento	= b.nr_atendimento
and	a.nr_seq_interno	= nr_seq_interno_p;

dt_mes_atual_w			:= dt_inicio_val_apac_w;

if (coalesce(calcula_meses_w,'S') = 'S') then
	begin
	
	while(trunc(dt_mes_atual_w,'month') <= trunc(dt_fim_val_apac_w,'month')) loop
		begin
		select	count(*)
		into STRICT	qt_reg_mes_w
		from	paciente_atend_medic_adm	c,
			paciente_atendimento		b,
			paciente_setor			a
		where	a.nr_seq_paciente			= b.nr_seq_paciente
		and	b.nr_seq_atendimento		= c.nr_seq_atendimento
		and	a.cd_pessoa_fisica			= cd_paciente_w
		and	trunc(dt_administracao,'month')	= trunc(dt_mes_atual_w,'month');

		if (qt_reg_mes_w	> 0) then
			qt_atualiza_mes_w	:= qt_atualiza_mes_w + 1;
		end if;
		dt_mes_atual_w	:= add_months(dt_mes_atual_w,1);
		end;
	end loop;
	
	end;
end if;

qt_meses_aut_w	:= qt_meses_aut_w + qt_atualiza_mes_w;

if (ie_mes_autor_w = 'S') then
	begin
	select	coalesce(qt_meses_autorizado,0)
	into STRICT	qt_meses_aut_w
	from	atendimento_paciente	b,
		sus_laudo_paciente	a
	where	a.nr_atendimento	= b.nr_atendimento
	and	a.nr_seq_interno	= nr_seq_interno_p;

	qt_meses_aut_w := qt_meses_aut_w + 3;
	end;
end if;

if (coalesce(ie_data_atual_emis_w,'N') = 'S') then
	dt_emissao_w := clock_timestamp();
elsif (coalesce(ie_mes_pos_validade_w,'N') = 'S') and (dt_fim_val_apac_w IS NOT NULL AND dt_fim_val_apac_w::text <> '') and (ie_classificacao_w not in (1,15)) then
	dt_emissao_w := trunc(add_months(dt_fim_val_apac_w,1),'mm');
else
	dt_emissao_w := trunc(clock_timestamp(),'mm');
end if;

select	nextval('sus_laudo_paciente_seq')
into STRICT	nr_seq_novo_p
;

insert into sus_laudo_paciente(
        nr_atendimento,			ie_tipo_laudo_sus,
        nr_laudo_sus,			dt_emissao,
        cd_procedimento_solic,		ie_origem_proced,
        qt_procedimento_solic,		cd_medico_requisitante,
        cd_medico_responsavel,		dt_atualizacao,
        nm_usuario,			dt_diagnostico,
        ds_motivo_internacao,		ds_motivo_alteracao,
        nr_aih,				ds_sinal_sintoma,
        ds_condicao_justifica,		ds_result_prova,
        cd_cid_principal,		ie_lifonodos_reg_inval,
        ds_localizacao_metastase,	ds_estadio_uicc,
        ds_estadio_outro_sist,		cd_grau_histopat,
        cd_diag_cito_hist,		dt_diag_cito_hist,
        ie_tratamento_ant,		ds_tratamento_ant,
        dt_pri_tratamento,		dt_seg_tratamento,
        dt_ter_tratamento,		ie_continuidade_trat,
        dt_inicio_trat_solic,		ie_via_tratamento,
        ie_finalidade,			ds_sigla_esquema,
        qt_meses_prev,			qt_meses_autorizado,
        cd_tipo_tratamento,		cd_associacao,
        ds_complemento,			nr_seq_equip,
        qt_dose_area_dia,		qt_campo_area_dia,
        qt_total_dia_area,		qt_check_films,
        qt_insercoes,			dt_inicio_trat,
        dt_fim_trat,			ds_marcara,
        qt_total_campo_prev,		qt_campo_pago,
        qt_bloco_pre,			nr_seq_interno,
        qt_prev_mes1,			qt_prev_mes2,
        qt_prev_mes3,			nr_atendimento_origem,
        ie_status_processo,		ie_classificacao,
        nr_interno_conta,		ie_origem_laudo_apac,
        ie_tipo_laudo_apac,		ds_justificativa,
        ds_inconsistencia,		cd_cid_morfologia,
        ie_metastase,			qt_radiacao,
        cd_cid_secundario,		ds_tratamento_ant2,
        ds_tratamento_ant3,		ds_hipotese_diag,
        ds_resumo_exame_fis,		ds_exame_resultado,
        ie_recidivado,			ie_via_it,
        ie_via_iv,     			ie_via_sc,
        ie_via_im,     			ie_via_vo,
        ie_via_ives,   			ie_via_outros,
        ie_diaria_acomp,		qt_altura,
        qt_peso,			ie_gestante,
        ie_transplante,			qt_transplante,
        ie_classif_hemofilia,		ie_inibidor,
        ie_prova_diag,			cd_cid_topografia,
        nr_seq_pri_trat,		nr_seq_seg_trat,
        nr_seq_ter_trat,		ds_outros_trat_ant,
        ds_anamnese,			ds_alteracao_laborat,
        cd_cid_causa_assoc,   		dt_metastase, dt_pri_dialise,
        qt_altura_cm, 			qt_diurese,
        qt_glicose,			pr_albumina,
        pr_hb,				nr_tru,
        ie_acesso_vascular,		ie_hiv,
        ie_hcv,				ie_hb_sangue,
        ie_ultra_abdomen,		ie_inscrito_cncdo,
        cd_cid_prim_trat,		cd_cid_seg_trat,
        cd_cid_terc_trat,		cd_cnpj_executor,	
        dt_transplante,			nr_seq_motivo_nexec_proc,
        ds_observacao,			nr_seq_localizacao_laudo,
        ds_observacao_pri_trat,		ds_observacao_seg_trat,
        ds_observacao_ter_trat,		ie_carater_inter_sus,
        dt_inicio_dialise_cli,		ie_caract_tratamento,
        ie_acesso_vasc_dial,		ie_acomp_nefrol,
        ie_situacao_usu_ini,		ie_situacao_trasp,
        ie_dados_apto,			qt_fosforo,
        qt_ktv_semanal,			qt_pth,
        ie_inter_clinica,		ie_peritonite_diag,
        ie_encaminhado_fav,		ie_encam_imp_cateter,
        ie_situacao_vacina,		ie_anti_hbs,
        ie_influenza,			ie_difteria_tetano,
        ie_pneumococica,		ie_ieca,
        ie_bra,				ie_duplex_previo,
        ie_cateter_outros,		ie_fav_previas,
        ie_flebites,			ie_hematomas,
        ie_veia_visivel,		ie_presenca_pulso,
        qt_diametro_veia,		qt_diametro_arteria,
        ie_fremito_traj_fav,		ie_pulso_fremito,
        nm_pessoa_resp_lme,		dt_atualizacao_nrec, 	
        cd_perfil_ativo,		nm_usuario_nrec,
        nr_seq_morf_desc_adic,      	cd_profis_requisitante,
        nr_seq_proc_interno,            nr_seq_aih,
        nr_apac,			dt_retorno_secr, 
        ie_tipo_tumor,			ie_urgente, 
        qt_meses_canc,			qt_meses_autor_lv, 
        ie_diaria_uti,			cd_cnes, 
        qt_narc_crianca,		qt_sist_imob, 
        nr_ordem_laudo,			nr_seq_int_prot_medic, 
        ie_forma_tratamento,		cd_pessoa_fisica, 
        nr_seq_atend_futuro,		nr_bpa, 
        nr_prescricao,			nr_protocolo_sisreg, 
        ie_status_sisreg,		dt_envio_sisreg, 
        nm_usuario_sisreg,		ie_motivo_solicitacao,
        dt_internacao,			dt_assinatura_laudo, 
        ie_clinica,			nr_seq_status_laudo, 
        ie_tipo_int_psiquiatria, 	ie_tipo_leito, 
        nr_seq_pedido,			dt_pri_avaliacao, 
        qt_imc_pri_avaliacao,		dt_avaliacao_atual, 
        ie_perda_peso_pre_op,		ie_aval_nutricionista, 
        ie_aval_psicologo,		ie_aval_med_clinico, 
        ie_aval_med_psiquiatr,		ie_aval_endocrino, 
        ie_aval_cirur_digesti,		ie_aval_cirur_geral, 
        ie_grupo_multiprofis,		ie_aval_risco_cirurg, 
        ie_real_exam_laborat,		ie_esofagogastroduo, 
        ie_ultr_abdomen_tot,		ie_ecocardio_transt, 
        ie_ultras_doppl_col,		ie_prova_pulmon_bro, 
        ie_apto_proc_cirurg,		dt_envio_webservice, 
        cd_laudo_intern_ws,		tp_situacao, 
        ds_observ_cancel_ws,		nr_seq_mot_troc_ws, 
        nr_seq_mot_canc_ws,		nr_seq_assinatura, 
        dt_assinatura)
SELECT 		CASE WHEN nr_atendimento_p=0 THEN nr_atendimento  ELSE nr_atendimento_p END , ie_tipo_laudo_sus,
        nr_laudo_sus_w + row_number() OVER () AS rownum,	dt_emissao_w,
        cd_procedimento_solic,	ie_origem_proced,
        qt_procedimento_solic,	coalesce(cd_pessoa_fisica_w, cd_medico_requisitante),
        cd_medico_responsavel,	clock_timestamp(),
        nm_usuario_p,		dt_diagnostico,
        ds_motivo_internacao,	ds_motivo_alteracao,
        null,			ds_sinal_sintoma,
        ds_condicao_justifica,	ds_result_prova,
        cd_cid_principal,		ie_lifonodos_reg_inval,
        ds_localizacao_metastase,	ds_estadio_uicc,
        ds_estadio_outro_sist,	cd_grau_histopat,
        cd_diag_cito_hist,		dt_diag_cito_hist,
        ie_tratamento_ant,		ds_tratamento_ant,
        dt_pri_tratamento,		dt_seg_tratamento,
        dt_ter_tratamento,		'S',
        dt_inicio_trat_solic,		ie_via_tratamento,
        ie_finalidade,		ds_sigla_esquema,
        qt_meses_prev,		qt_meses_aut_w,
        cd_tipo_tratamento,		cd_associacao,
        ds_complemento,		nr_seq_equip,
        qt_dose_area_dia,		qt_campo_area_dia,
        qt_total_dia_area,		qt_check_films,
        qt_insercoes,		dt_inicio_trat,
        dt_fim_trat,		ds_marcara,
        qt_total_campo_prev,	qt_campo_pago,
        qt_bloco_pre,		nr_seq_novo_p,
        qt_prev_mes1,		qt_prev_mes2,
        qt_prev_mes3,		coalesce(nr_atendimento_origem,nr_atend_origem_w),
        ie_status_processo,		ie_classificacao,
        CASE WHEN coalesce(nr_atend_origem_w,0)=coalesce(nr_atendimento_p,0) THEN nr_interno_conta  ELSE null END , ie_origem_laudo_apac,
        ie_tipo_laudo_apac,	ds_justificativa,
        ds_inconsistencia,		cd_cid_morfologia,
        ie_metastase,		qt_radiacao,
        cd_cid_secundario,		ds_tratamento_ant2,
        ds_tratamento_ant3,	ds_hipotese_diag,
        CASE WHEN resumo_exame_fis_w='S' THEN ds_resumo_exame_fis  ELSE null END ,	ds_exame_resultado,
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
        dt_transplante,		nr_seq_motivo_nexec_proc,
        ds_observacao,		nr_seq_localizacao_laudo,
        ds_observacao_pri_trat,		ds_observacao_seg_trat,
        ds_observacao_ter_trat,		ie_carater_inter_sus,
        dt_inicio_dialise_cli,		ie_caract_tratamento,
        ie_acesso_vasc_dial,		ie_acomp_nefrol,
        ie_situacao_usu_ini,		ie_situacao_trasp,
        ie_dados_apto,		qt_fosforo,
        qt_ktv_semanal,		qt_pth,
        ie_inter_clinica,		ie_peritonite_diag,
        ie_encaminhado_fav,		ie_encam_imp_cateter,
        ie_situacao_vacina,		ie_anti_hbs,
        ie_influenza,		ie_difteria_tetano,
        ie_pneumococica,		ie_ieca,
        ie_bra,		ie_duplex_previo,
        ie_cateter_outros,		ie_fav_previas,
        ie_flebites,		ie_hematomas,
        ie_veia_visivel,		ie_presenca_pulso,
        qt_diametro_veia,		qt_diametro_arteria,
        ie_fremito_traj_fav,		ie_pulso_fremito,
        nm_pessoa_resp_lme,		clock_timestamp(),	
        obter_perfil_ativo,		nm_usuario_p, 
        nr_seq_morf_desc_adic,      cd_profis_requisitante,
        nr_seq_proc_interno,
        null, null, 
        null, 
        ie_tipo_tumor,  ie_urgente, 
        qt_meses_canc,    qt_meses_autor_lv, 
        ie_diaria_uti,cd_cnes,
        qt_narc_crianca,    qt_sist_imob, 
        nr_ordem_laudo,    nr_seq_int_prot_medic,
        ie_forma_tratamento,    cd_pessoa_fisica, 
        nr_seq_atend_futuro,    null, 
        nr_prescricao,  null, 
        null,   null, 
        null,  ie_motivo_solicitacao,  
        dt_internacao,  null, 
        ie_clinica, nr_seq_status_laudo, 
        ie_tipo_int_psiquiatria, ie_tipo_leito, 
        nr_seq_pedido,  dt_pri_avaliacao, 
        qt_imc_pri_avaliacao,   dt_avaliacao_atual, 
        ie_perda_peso_pre_op,   ie_aval_nutricionista, 
        ie_aval_psicologo,  ie_aval_med_clinico, 
        ie_aval_med_psiquiatr,  ie_aval_endocrino, 
        ie_aval_cirur_digesti, ie_aval_cirur_geral, 
        ie_grupo_multiprofis,   ie_aval_risco_cirurg, 
        ie_real_exam_laborat,  ie_esofagogastroduo, 
        ie_ultr_abdomen_tot,    ie_ecocardio_transt, 
        ie_ultras_doppl_col,    ie_prova_pulmon_bro, 
        ie_apto_proc_cirurg,    null, 
        cd_laudo_intern_ws, tp_situacao, 
        ds_observ_cancel_ws,    nr_seq_mot_troc_ws, 
        nr_seq_mot_canc_ws, null, 
        null
from	sus_laudo_paciente
where	nr_seq_interno = nr_seq_interno_p;

select	max(a.cd_cid_topografia)
into STRICT	cd_cid_topografia_w
from	sus_laudo_paciente a
where	a.nr_seq_interno = nr_seq_interno_p
and	exists (	SELECT  1
		from	cid_doenca b
		where	b.cd_doenca_cid = cd_cid_topografia);

update	sus_laudo_paciente
set	cd_cid_topografia = coalesce(cd_cid_topografia_w,null)
where	nr_seq_interno	= nr_seq_novo_p;

insert into sus_laudo_proced_adic(
        nr_sequencia,
        dt_atualizacao,
        nm_usuario,
        nr_seq_laudo,
        cd_procedimento,
        ie_origem_proced,
        qt_procedimento,
        ie_via_tratamento,
        dt_atualizacao_nrec,
        nm_usuario_nrec,
        ds_justificativa,
        nr_seq_proc_interno)
SELECT	nextval('sus_laudo_proced_adic_seq'),
        clock_timestamp(),
        nm_usuario_p,
        nr_seq_novo_p,
        cd_procedimento,
        ie_origem_proced,
        qt_procedimento,
        ie_via_tratamento,
        clock_timestamp(),
        nm_usuario_p,
        ds_justificativa,
        nr_seq_proc_interno
from	sus_laudo_proced_adic
where	nr_seq_laudo	= nr_seq_interno_p;

insert into sus_laudo_area_irradiada(
        nr_sequencia,
        dt_atualizacao,
        nm_usuario,
        nr_seq_laudo,
        cd_doenca_cid,
        qt_insercoes_area,
        ds_local_irradiacao,
        dt_inicio,
        dt_termino,
        cd_topografia,
        dt_atualizacao_nrec,
        nm_usuario_nrec)
SELECT	nextval('sus_laudo_area_irradiada_seq'),
        clock_timestamp(),
        nm_usuario_p,
        nr_seq_novo_p,
        cd_doenca_cid,
        qt_insercoes_area,
        ds_local_irradiacao,
        dt_inicio,
        dt_termino,
        cd_topografia,
        clock_timestamp(),
        nm_usuario_p
from	sus_laudo_area_irradiada
where	nr_seq_laudo	= nr_seq_interno_p;

insert into sus_laudo_medicamento(
        nr_sequencia,
        dt_atualizacao,
        nm_usuario,
        dt_atualizacao_nrec,
        nm_usuario_nrec,
        nr_seq_laudo_sus,
        cd_procedimento,
        ie_origem_proced,
        qt_proced_1_mes,
        qt_proced_2_mes,
        qt_proced_3_mes,
        cd_cid_principal,
        cd_cid_secundario,
        ds_posologia,
        ie_via_aplicacao,
        qt_proced_4_mes,
        qt_proced_5_mes,
        qt_proced_6_mes)
SELECT	nextval('sus_laudo_medicamento_seq'),
        clock_timestamp(),
        nm_usuario_p,
        clock_timestamp(),
        nm_usuario_p,
        nr_seq_novo_p,
        cd_procedimento,
        ie_origem_proced,
        qt_proced_1_mes,
        qt_proced_2_mes,
        qt_proced_3_mes,
        cd_cid_principal,
        cd_cid_secundario,
        ds_posologia,
        ie_via_aplicacao,
        qt_proced_4_mes,
        qt_proced_5_mes,
        qt_proced_6_mes
from	sus_laudo_medicamento
where	nr_seq_laudo_sus	= nr_seq_interno_p;

insert into sus_laudo_enucleacao(
        nr_sequencia,
        dt_atualizacao,
        nm_usuario,
        dt_atualizacao_nrec,
        nm_usuario_nrec,
        nr_seq_laudo,
        ds_endereco_loc_cap,
        ds_local_captacao,
        dt_entrada_banco,
        dt_enucleacao,
        dt_obito,
        ie_globo)
SELECT	nextval('sus_laudo_enucleacao_seq'),
        clock_timestamp(),
        nm_usuario_p,
        clock_timestamp(),
        nm_usuario_p,
        nr_seq_novo_p,
        ds_endereco_loc_cap,
        ds_local_captacao,
        dt_entrada_banco,
        dt_enucleacao,
        dt_obito,
        ie_globo
from	sus_laudo_enucleacao
where	nr_seq_laudo = nr_seq_interno_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_sus_laudo_paciente ( nr_seq_interno_p bigint, nr_atendimento_p bigint, nm_usuario_p text, nr_seq_novo_p INOUT bigint) FROM PUBLIC;
