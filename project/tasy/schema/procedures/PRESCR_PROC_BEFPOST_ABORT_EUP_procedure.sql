-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE prescr_proc_befpost_abort_eup (cd_material_exame_p INOUT text, ds_material_especial_p text, ie_pasta_laboratorio_p text, cd_guia_p text, cd_senha_p text, cd_convenio_p bigint, ie_tipo_atendimento_p bigint, ie_carater_inter_sus_p text, ie_clinica_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_classificacao_p bigint, nr_seq_proc_interno_p bigint, cd_categoria_p text, cd_plano_p text, nr_atendimento_p bigint, nr_prescricao_p bigint, nr_seq_proced_p bigint, dt_prev_execucao_p timestamp, cd_estabelecimento_p bigint, cd_perfil_p bigint, cd_setor_atendimento_p bigint, qt_procedimento_p bigint, ie_opcao_p text, nr_seq_exame_p bigint, cd_setor_entrega_prescr_p bigint, ie_tipo_convenio_p bigint, cd_funcao_p bigint, nr_seq_agenda_p bigint, cd_tipo_acomodacao_p bigint, ie_possui_registros_p text, nr_seq_material_p text, dt_prescr_exame_p timestamp, cd_medico_executor_p text, ds_sexo_paciente_p text, cd_pessoa_fisica_p text, ie_edicao_novo_p text, ie_pendente_amostra_p text, cd_setor_solicitacao_p bigint, dt_coleta_p timestamp, ie_urgencia_p text, cd_setor_origem_p bigint, ie_origem_proced_user_p bigint, ie_exclusao_p text, cd_empresa_p bigint, cd_procedencia_p bigint, nr_seq_cobertura_p bigint, nr_seq_tipo_acidente_p bigint, nr_seq_queixa_p bigint, cd_setor_exclusivo_p INOUT bigint, ds_msg_erro_p INOUT text, ds_msg_aviso_p INOUT text, ds_valor_particular_p INOUT text, ds_msg_alerta_p INOUT text, ie_cancelar_edicao_p INOUT text, dt_prevista_retorno_p INOUT timestamp, cd_setor_atend_p INOUT text, cd_setor_coleta_p INOUT text, cd_setor_entrega_p INOUT text, qt_dia_entrega_p INOUT bigint, ie_emite_mapa_p INOUT text, ds_hora_fixa_p INOUT text, ie_data_resultado_p INOUT text, qt_min_entrega_p INOUT bigint, ie_atualizar_recoleta_p INOUT text, ie_gerar_setor_p INOUT text, ds_msg_info_p INOUT text, ds_valor_partic_p INOUT text, ie_consistir_regra_p INOUT text, ds_texto_1_p INOUT text, ds_texto_2_p INOUT text, ds_texto_3_p INOUT text, ds_texto_4_p INOUT text, ds_texto_5_p INOUT text, ie_acao_regra_p INOUT text, cd_medico_exclusivo_p INOUT text, ds_mensagem_p INOUT text, ie_bloqueia_atendimento_p INOUT text, ie_prescr_liberada_p INOUT text, ie_pergunta_p INOUT text, ds_msg_limite_med_p INOUT text, nm_usuario_p text, ie_forma_atual_dt_result_p INOUT text, qt_min_atraso_p INOUT bigint) AS $body$
DECLARE

 
ie_material_especial_w			varchar(1);
ie_tipo_conv_anterior_w			varchar(1);
ie_exame_regra_lanc_w			varchar(1);
ie_consiste_mat_vinc_exam_w		varchar(1);
nr_seq_queixa_anterior_w		bigint;
qt_idade_w				bigint;
ie_tipo_atendimento_w			smallint;
dt_prescricao_w				timestamp;
nr_seq_grupo_imp_w			bigint;
nr_seq_grupo_w				bigint;
nr_seq_material_w			bigint;
ie_dia_semana_w				smallint;

c01 CURSOR FOR 
	SELECT 	--cd_setor_atendimento, 
		--cd_setor_coleta, 
		--cd_setor_entrega, 
		--nvl(qt_dia_entrega,0), 
		--nvl(ie_emite_mapa,'S'), 
		--ds_hora_fixa, 
		--ie_data_resultado, 
		--nvl(qt_min_entrega,0), 
		--nvl(ie_atualizar_recoleta, 'N'), 
		--nvl(ie_dia_semana_final,0), 
		--nvl(ie_atul_data_result, 'S'), 
		coalesce(qt_min_atraso,0) 
	from exame_lab_regra_setor 
	where coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0) 
	 and ((ie_dia_semana = ie_dia_semana_w) or ((ie_dia_semana = 9) and (ie_dia_Semana_w not in (7,1))) or (coalesce(ie_dia_semana::text, '') = '')) 
	 and coalesce(ie_tipo_atendimento, ie_tipo_atendimento_p) = ie_tipo_atendimento_p 
	 and coalesce(cd_setor_solicitacao, coalesce(cd_setor_solicitacao_p,0)) = coalesce(cd_setor_solicitacao_p,0) 
	 and coalesce(nr_seq_grupo, nr_seq_grupo_w) = nr_seq_grupo_w 
	 and coalesce(nr_seq_grupo_imp, nr_seq_grupo_imp_w) = nr_seq_grupo_imp_w 
	 and coalesce(nr_seq_exame, nr_seq_exame_p) = nr_seq_exame_p 
	 and coalesce(nr_seq_material, coalesce(nr_seq_material_w,0)) = coalesce(nr_seq_material_w,0) 
	 and ((coalesce(ie_urgencia,ie_urgencia_p) = ie_urgencia_p) or (coalesce(ie_urgencia,'A') = 'A')) 
	 and dt_prescricao_w	between to_date(to_char(dt_prescricao_w,'dd/mm/yyyy') || ' ' || coalesce(ds_hora_inicio,to_char(dt_prescricao_w,'hh24:mi')) || ':00','dd/mm/yyyy hh24:mi:ss') 
				and to_date(to_char(dt_prescricao_w,'dd/mm/yyyy') || ' ' || coalesce(ds_hora_fim,to_char(dt_prescricao_w,'hh24:mi')) || ':00','dd/mm/yyyy hh24:mi:ss') 
	order by coalesce(nr_seq_prioridade,0), coalesce(nr_seq_material,0), coalesce(nr_seq_exame,9999999999), coalesce(nr_seq_grupo,9999999999), coalesce(ie_dia_semana,0), nr_seq_grupo_imp_w, cd_setor_solicitacao;


BEGIN 
 
ie_pergunta_p := 'N';
ie_consiste_mat_vinc_exam_w := Obter_param_Usuario(916, 843, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_consiste_mat_vinc_exam_w);
 
 
select	max(trunc(a.dt_prescricao,'mi')) 
into STRICT	dt_prescricao_w 
FROM prescr_medica a
LEFT OUTER JOIN atendimento_paciente b ON (a.nr_atendimento = b.nr_atendimento)
WHERE a.nr_prescricao	= nr_prescricao_p;
 
select	obter_cod_dia_semana(dt_prescricao_w) 
into STRICT	ie_dia_semana_w
;
 
select 	max(nr_seq_grupo), 
	max(coalesce(nr_seq_grupo_imp,0)) 
into STRICT 	nr_seq_grupo_w, 
	nr_seq_grupo_imp_w 
from exame_laboratorio 
where nr_seq_exame = nr_seq_exame_p;
 
if (ie_pasta_laboratorio_p = 'S') then 
	begin 
	select	max(ie_material_especial) 
	into STRICT	ie_material_especial_w 
	from	material_exame_lab 
	where	cd_material_exame = cd_material_exame_p;
 
	if (coalesce(ds_material_especial_p::text, '') = '' and 
		ie_material_especial_w = 'S') then 
		ds_msg_erro_p := wheb_mensagem_pck.get_texto(224497);
	end if;
	end;
end if;
 
select 	max(nr_sequencia) 
into STRICT	nr_seq_material_w 
from 	material_exame_lab 
where cd_material_exame = cd_material_exame_p;
 
if (coalesce(ds_msg_erro_p::text, '') = '') then 
	SELECT * FROM consistir_dados_guia_eup_js(nr_seq_exame_p, ie_pasta_laboratorio_p, cd_guia_p, cd_senha_p, cd_convenio_p, ie_tipo_atendimento_p, ie_carater_inter_sus_p, ie_clinica_p, cd_procedimento_p, ie_origem_proced_p, nr_seq_classificacao_p, nr_seq_proc_interno_p, cd_categoria_p, cd_plano_p, nr_atendimento_p, nr_prescricao_p, nr_seq_proced_p, cd_material_exame_p, dt_prev_execucao_p, cd_estabelecimento_p, cd_perfil_p, nm_usuario_p, ds_msg_erro_p, ds_msg_aviso_p) INTO STRICT ds_msg_erro_p, ds_msg_aviso_p;
		if (ds_msg_aviso_p IS NOT NULL AND ds_msg_aviso_p::text <> '') then 
			ie_pergunta_p := 'S';
		end if;
end if;
 
if (coalesce(ds_msg_erro_p::text, '') = '') then 
	SELECT * FROM validar_proc_paciente_eup_js(ie_possui_registros_p, ie_pasta_laboratorio_p, nr_seq_exame_p, nr_seq_material_p, dt_prescr_exame_p, ie_origem_proced_p, cd_convenio_p, nr_atendimento_p, cd_procedimento_p, cd_setor_atendimento_p, cd_medico_executor_p, ie_tipo_atendimento_p, nr_seq_exame_p, ds_sexo_paciente_p, qt_procedimento_p, cd_pessoa_fisica_p, nr_seq_proc_interno_p, ie_edicao_novo_p, nm_usuario_p, cd_estabelecimento_p, cd_perfil_p, ds_msg_erro_p, ds_msg_alerta_p, ie_cancelar_edicao_p, ds_msg_info_p) INTO STRICT ds_msg_erro_p, ds_msg_alerta_p, ie_cancelar_edicao_p, ds_msg_info_p;
end if;
 
if (coalesce(ds_msg_erro_p::text, '') = '') then 
	SELECT * FROM consistir_setor_proc_eup_js(cd_setor_atendimento_p, dt_prev_execucao_p, cd_procedimento_p, ie_origem_proced_p, qt_procedimento_p, nr_atendimento_p, ie_tipo_atendimento_p, ie_opcao_p, nr_atendimento_p, cd_convenio_p, cd_plano_p, nr_seq_exame_p, nr_seq_proc_interno_p, cd_categoria_p, cd_setor_entrega_prescr_p, cd_medico_executor_p, ie_tipo_convenio_p, nm_usuario_p, cd_funcao_p, cd_estabelecimento_p, cd_perfil_p, ds_msg_erro_p, ds_msg_aviso_p) INTO STRICT ds_msg_erro_p, ds_msg_aviso_p;
end if;
 
if (coalesce(ds_msg_erro_p::text, '') = '') then 
	SELECT * FROM consistir_proc_glosa_eup_js(nr_seq_agenda_p, nr_prescricao_p, nr_seq_proced_p, nr_atendimento_p, cd_procedimento_p, ie_origem_proced_p, qt_procedimento_p, cd_tipo_acomodacao_p, ie_tipo_atendimento_p, nr_seq_exame_p, nr_seq_proc_interno_p, cd_medico_executor_p, ie_clinica_p, nm_usuario_p, cd_funcao_p, cd_estabelecimento_p, cd_perfil_p, cd_convenio_p, ds_msg_erro_p, ds_msg_aviso_p, ds_valor_particular_p) INTO STRICT ds_msg_erro_p, ds_msg_aviso_p, ds_valor_particular_p;
end if;
 
if (coalesce(ds_msg_erro_p::text, '') = '' 
	and ie_consiste_mat_vinc_exam_w = 'S' 
	and coalesce(cd_material_exame_p::text, '') = '') then 
	SELECT * FROM consistir_atualiza_exame_js(cd_material_exame_p, nr_seq_exame_p, ie_pendente_amostra_p, nr_prescricao_p, dt_prev_execucao_p, cd_setor_solicitacao_p, dt_coleta_p, ie_urgencia_p, cd_setor_exclusivo_p, cd_procedimento_p, cd_setor_origem_p, nr_atendimento_p, nr_seq_proc_interno_p, ie_origem_proced_p, nm_usuario_p, cd_estabelecimento_p, ie_origem_proced_user_p, dt_prevista_retorno_p, cd_setor_atend_p, cd_setor_coleta_p, cd_setor_entrega_p, qt_dia_entrega_p, ie_emite_mapa_p, ds_hora_fixa_p, ie_data_resultado_p, qt_min_entrega_p, ie_atualizar_recoleta_p, ie_gerar_setor_p, ds_msg_info_p, ie_exclusao_p, ie_forma_atual_dt_result_p, qt_min_atraso_p) INTO STRICT cd_material_exame_p, cd_setor_exclusivo_p, dt_prevista_retorno_p, cd_setor_atend_p, cd_setor_coleta_p, cd_setor_entrega_p, qt_dia_entrega_p, ie_emite_mapa_p, ds_hora_fixa_p, ie_data_resultado_p, qt_min_entrega_p, ie_atualizar_recoleta_p, ie_gerar_setor_p, ds_msg_info_p, ie_forma_atual_dt_result_p, qt_min_atraso_p;
end if;
	 
select wheb_mensagem_pck.get_texto(795782, 
		'CD_PROCEDIMENTO='||substr(cd_procedimento_p,1,15)|| 
		';DS_PROCEDIMENTO='||substr(obter_descricao_procedimento(cd_procedimento_p, ie_origem_proced_p),1,40)|| 
		';VL_PROCEDIMENTO='||substr(obter_valor_proc_particular(cd_estabelecimento_p,cd_procedimento_p, ie_origem_proced_p, ie_tipo_atendimento_p, cd_medico_executor_p, ie_clinica_p, nr_seq_proc_interno_p),1,20)),	 
	obter_texto_tasy(76423, wheb_usuario_pck.get_nr_seq_idioma), 
	substr(consistir_regra_proc_medico(cd_procedimento_p, nr_seq_proc_interno_p, ie_origem_proced_p),1,5), 
	obter_texto_tasy(82611, wheb_usuario_pck.get_nr_seq_idioma), 
	obter_texto_tasy(82620, wheb_usuario_pck.get_nr_seq_idioma), 
	obter_texto_tasy(82625, wheb_usuario_pck.get_nr_seq_idioma), 
	obter_texto_tasy(82629, wheb_usuario_pck.get_nr_seq_idioma) 
into STRICT 	ds_valor_partic_p, 
		ds_texto_1_p, 
		ie_consistir_regra_p, 
		ds_texto_2_p, 
		ds_texto_3_p, 
		ds_texto_4_p, 
		ds_texto_5_p
;
 
if (coalesce(ds_msg_erro_p::text, '') = '') then 
	SELECT * FROM consistir_limite_proced_medico(cd_procedimento_p, nr_seq_proc_interno_p, cd_convenio_p, cd_medico_executor_p, ie_acao_regra_p, ds_msg_limite_med_p, cd_medico_exclusivo_p) INTO STRICT ie_acao_regra_p, ds_msg_limite_med_p, cd_medico_exclusivo_p;
end if;
 
if (coalesce(ds_msg_erro_p::text, '') = '') then 
	ds_msg_erro_p := consistir_medico_procedimento(cd_medico_executor_p, nr_seq_proc_interno_p, ds_msg_erro_p);
end if;
 
select	(select	a.ie_tipo_convenio 
		from	atendimento_paciente a 
		where	a.nr_atendimento = (select	max(b.nr_atendimento) 
									from	atendimento_paciente b 
									where	nr_atendimento < nr_atendimento_p)), 
		(select	a.nr_seq_queixa 
		from	atendimento_paciente a 
		where	a.nr_atendimento = (select	max(b.nr_atendimento) 
									from	atendimento_paciente b 
									where	nr_atendimento < nr_atendimento_p)), 
		substr(obter_idade_pf(cd_pessoa_fisica_p, clock_timestamp(), 'A'), 1, 3) 
into STRICT	ie_tipo_conv_anterior_w, 
		nr_seq_queixa_anterior_w, 
		qt_idade_w
;
 
SELECT * FROM Obter_Se_Lib_Setor_Conv(cd_estabelecimento_p, cd_convenio_p, cd_categoria_p, ie_tipo_atendimento_p, cd_setor_atendimento_p, cd_plano_p, nr_seq_classificacao_p, ds_mensagem_p, ie_bloqueia_atendimento_p, ie_clinica_p, cd_empresa_p, cd_procedencia_p, nr_seq_cobertura_p, nr_seq_tipo_acidente_p, cd_tipo_acomodacao_p, cd_medico_executor_p, qt_idade_w, ie_tipo_conv_anterior_w, nr_seq_queixa_p, nr_seq_queixa_anterior_w, null, cd_pessoa_fisica_p) INTO STRICT ds_mensagem_p, ie_bloqueia_atendimento_p;
	 
 
select	coalesce(max('S'),'N') 
into STRICT	ie_prescr_liberada_p 
from	prescr_medica 
where	nr_prescricao	= nr_prescricao_p 
and	(coalesce(dt_liberacao,dt_liberacao_medico) IS NOT NULL AND (coalesce(dt_liberacao,dt_liberacao_medico))::text <> '');
 
if (ie_pasta_laboratorio_p = 'S') then 
	begin 
	ie_exame_regra_lanc_w := obter_se_exame_regra_lanc(nr_seq_exame_p, nr_prescricao_p, cd_estabelecimento_p);
	if (ie_exame_regra_lanc_w = 'S') then 
		ds_msg_erro_p := wheb_mensagem_pck.get_texto(212313);
	end if;
	end;
end if;
 
open c01;
loop 
	fetch c01 into 
		qt_min_atraso_p;
	EXIT WHEN NOT FOUND; /* apply on c01 */
end loop;
close c01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE prescr_proc_befpost_abort_eup (cd_material_exame_p INOUT text, ds_material_especial_p text, ie_pasta_laboratorio_p text, cd_guia_p text, cd_senha_p text, cd_convenio_p bigint, ie_tipo_atendimento_p bigint, ie_carater_inter_sus_p text, ie_clinica_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_classificacao_p bigint, nr_seq_proc_interno_p bigint, cd_categoria_p text, cd_plano_p text, nr_atendimento_p bigint, nr_prescricao_p bigint, nr_seq_proced_p bigint, dt_prev_execucao_p timestamp, cd_estabelecimento_p bigint, cd_perfil_p bigint, cd_setor_atendimento_p bigint, qt_procedimento_p bigint, ie_opcao_p text, nr_seq_exame_p bigint, cd_setor_entrega_prescr_p bigint, ie_tipo_convenio_p bigint, cd_funcao_p bigint, nr_seq_agenda_p bigint, cd_tipo_acomodacao_p bigint, ie_possui_registros_p text, nr_seq_material_p text, dt_prescr_exame_p timestamp, cd_medico_executor_p text, ds_sexo_paciente_p text, cd_pessoa_fisica_p text, ie_edicao_novo_p text, ie_pendente_amostra_p text, cd_setor_solicitacao_p bigint, dt_coleta_p timestamp, ie_urgencia_p text, cd_setor_origem_p bigint, ie_origem_proced_user_p bigint, ie_exclusao_p text, cd_empresa_p bigint, cd_procedencia_p bigint, nr_seq_cobertura_p bigint, nr_seq_tipo_acidente_p bigint, nr_seq_queixa_p bigint, cd_setor_exclusivo_p INOUT bigint, ds_msg_erro_p INOUT text, ds_msg_aviso_p INOUT text, ds_valor_particular_p INOUT text, ds_msg_alerta_p INOUT text, ie_cancelar_edicao_p INOUT text, dt_prevista_retorno_p INOUT timestamp, cd_setor_atend_p INOUT text, cd_setor_coleta_p INOUT text, cd_setor_entrega_p INOUT text, qt_dia_entrega_p INOUT bigint, ie_emite_mapa_p INOUT text, ds_hora_fixa_p INOUT text, ie_data_resultado_p INOUT text, qt_min_entrega_p INOUT bigint, ie_atualizar_recoleta_p INOUT text, ie_gerar_setor_p INOUT text, ds_msg_info_p INOUT text, ds_valor_partic_p INOUT text, ie_consistir_regra_p INOUT text, ds_texto_1_p INOUT text, ds_texto_2_p INOUT text, ds_texto_3_p INOUT text, ds_texto_4_p INOUT text, ds_texto_5_p INOUT text, ie_acao_regra_p INOUT text, cd_medico_exclusivo_p INOUT text, ds_mensagem_p INOUT text, ie_bloqueia_atendimento_p INOUT text, ie_prescr_liberada_p INOUT text, ie_pergunta_p INOUT text, ds_msg_limite_med_p INOUT text, nm_usuario_p text, ie_forma_atual_dt_result_p INOUT text, qt_min_atraso_p INOUT bigint) FROM PUBLIC;

