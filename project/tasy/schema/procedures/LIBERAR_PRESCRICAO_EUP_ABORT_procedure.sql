-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_prescricao_eup_abort ( nr_prescricao_p bigint default null, cd_pessoa_fisica_p text DEFAULT NULL, qt_peso_p bigint default null, cd_procedimento_p bigint DEFAULT NULL, nr_seq_interno_p bigint DEFAULT NULL, ie_origem_proced_p text DEFAULT NULL, nr_atendimento_p bigint DEFAULT NULL, nm_pessoa_fisica_p text DEFAULT NULL, cd_estabelecimento_p bigint DEFAULT NULL, cd_setor_atendimento_p bigint DEFAULT NULL, cd_perfil_p bigint DEFAULT NULL, ie_momento_p text DEFAULT NULL, ie_prescricao_alta_p text DEFAULT NULL, dt_prescricao_p timestamp DEFAULT NULL, qt_altura_cm_p bigint DEFAULT NULL, nr_seq_forma_laudo_p bigint DEFAULT NULL, dt_prescr_p INOUT timestamp DEFAULT NULL, ds_mensagem_p INOUT text DEFAULT NULL, ds_mensagem_adic_p INOUT text DEFAULT NULL, ie_acao_p INOUT text DEFAULT NULL, ie_anamnese_p INOUT text DEFAULT NULL, ie_evolucao_p INOUT text DEFAULT NULL, ie_receita_p INOUT text DEFAULT NULL, ie_diagnostico_p INOUT text DEFAULT NULL, ie_escala_indice_p INOUT text DEFAULT NULL, ds_cons_med_corpo_cli_p INOUT text DEFAULT NULL, qt_exame_ult_dose_pend_p INOUT bigint DEFAULT NULL, ds_lista_pend_resposta_p INOUT text DEFAULT NULL, ds_msg_erro_p INOUT text DEFAULT NULL, ds_regra_cad_p INOUT text DEFAULT NULL, ie_diag_atendimento_p INOUT text DEFAULT NULL, ds_diag_atendimento_p INOUT text DEFAULT NULL, ds_liberacao_p INOUT text DEFAULT NULL, ds_msg_aviso_p INOUT text DEFAULT NULL, ie_recomendacao_p INOUT text DEFAULT NULL, cd_protocolo_p INOUT bigint DEFAULT NULL, ie_parecer_p INOUT text DEFAULT NULL, ie_peso_p INOUT text DEFAULT NULL, ie_autorizacao_p INOUT text DEFAULT NULL, ie_laudo_sus_p INOUT text DEFAULT NULL, ie_avaliacao_p INOUT text DEFAULT NULL, ie_item_prontuario_p INOUT text DEFAULT NULL, ie_exige_tempo_jejum_real_p INOUT text DEFAULT NULL, ds_msg_futura_p INOUT text DEFAULT NULL, nm_usuario_p text DEFAULT NULL) AS $body$
DECLARE

										 
 
 
ie_cons_med_corpo_clin_w		varchar(2000);
ie_consistir_w					varchar(3);
qt_exame_ult_dose_pend_w		bigint;
ie_somente_corpo_clin_w			varchar(1);
ie_consiste_guia_senha_w		varchar(1);
ie_desf_alta_atend_def_w		varchar(1);
ie_lib_prescr_sem_inf_campo_w	varchar(1);
ie_cons_peso_lib_prescr_w		varchar(1);
ie_cons_alt_lib_prescr_w		varchar(1);
ie_obrig_info_med_exec_w		varchar(1);
ie_cons_setor_coleta_lib_w		varchar(1);
qt_horas_w						double precision;
qt_proced_w						bigint;
qt_proced_setor_w				bigint;
ie_posicionar_pep_w		varchar(1);


BEGIN 
 
ie_obrig_info_med_exec_w := Obter_param_Usuario(916, 43, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, ie_obrig_info_med_exec_w);
ie_somente_corpo_clin_w := Obter_param_Usuario(916, 147, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, ie_somente_corpo_clin_w);
ie_desf_alta_atend_def_w := Obter_param_Usuario(916, 198, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, ie_desf_alta_atend_def_w);
ie_lib_prescr_sem_inf_campo_w := Obter_param_Usuario(916, 236, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, ie_lib_prescr_sem_inf_campo_w);
ie_cons_setor_coleta_lib_w := Obter_param_Usuario(916, 332, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, ie_cons_setor_coleta_lib_w);
qt_horas_w := Obter_param_Usuario(916, 358, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, qt_horas_w);
ie_consiste_guia_senha_w := Obter_param_Usuario(916, 765, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, ie_consiste_guia_senha_w);
 
ie_cons_peso_lib_prescr_w := Obter_param_Usuario(924, 871, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, ie_cons_peso_lib_prescr_w);
ie_cons_alt_lib_prescr_w := Obter_param_Usuario(924, 1021, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, ie_cons_alt_lib_prescr_w);
 
if (ie_cons_peso_lib_prescr_w = 'S' and 
	coalesce(qt_peso_p::text, '') = '') then 
	ds_msg_erro_p := wheb_mensagem_pck.get_texto(315678);
end if;
 
if (ie_cons_alt_lib_prescr_w = 'S' and 
	coalesce(qt_altura_cm_p::text, '') = '') then 
	ds_msg_erro_p := wheb_mensagem_pck.get_texto(315678);
end if;
 
if (not ie_lib_prescr_sem_inf_campo_w = 'S' and 
	coalesce(nr_seq_forma_laudo_p::text, '') = '') then 
	ds_msg_erro_p := wheb_mensagem_pck.get_texto(109834);
end if;
 
if (ie_somente_corpo_clin_w = 'S') then 
	begin 
	ie_cons_med_corpo_clin_w := consiste_med_corpo_cli(nr_prescricao_p);
	 
	if (not ie_cons_med_corpo_clin_w = ' ') then 
		ds_cons_med_corpo_cli_p := wheb_mensagem_pck.get_texto(109842);
	end if;
	end;
end if;
 
if (ds_cons_med_corpo_cli_p IS NOT NULL AND ds_cons_med_corpo_cli_p::text <> '') then 
	goto final;
end if;
 
ds_lista_pend_resposta_p := obter_lista_pend_resposta(nr_prescricao_p);
 
qt_exame_ult_dose_pend_p := obter_qt_prescr_exige_dose(nr_prescricao_p);
 
if (qt_exame_ult_dose_pend_p > 0) then 
	ds_msg_erro_p := wheb_mensagem_pck.get_texto(109908);
end if;
 
select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
into STRICT	ie_exige_tempo_jejum_real_p 
from	exame_laboratorio a, 
		prescr_procedimento b 
where	a.nr_seq_exame = b.nr_seq_exame 
and		a.ie_exige_tempo_jejum_real = 'S' 
and		b.nr_prescricao = nr_prescricao_p;
 
if (ie_exige_tempo_jejum_real_p = 'S' 
	and coalesce(ds_msg_erro_p::text, '') = '') then 
	ds_msg_erro_p := wheb_mensagem_pck.get_texto(195641);
end if;
 
if (ie_consiste_guia_senha_w != 'N'	and 
	coalesce(ds_msg_erro_p::text, '') = '') then 
	begin 
		ds_msg_erro_p := consiste_guia_senha_prescr_lib(nr_prescricao_p, ie_consiste_guia_senha_w, ds_msg_erro_p);
	end;
end if;
 
if ((qt_horas_w IS NOT NULL AND qt_horas_w::text <> '') and 
	qt_horas_w > 0 and 
	coalesce(ds_msg_erro_p::text, '') = '' and 
	dt_prescricao_p > clock_timestamp()) then 
	begin 
	select 	clock_timestamp() + (qt_horas_w/24) 
	into STRICT	dt_prescr_p 
	;
 
	if (dt_prescr_p < dt_prescricao_p) then 
	 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(110002, 'ITEM='||qt_horas_w);
		--ds_msg_futura_p := wheb_mensagem_pck.get_texto(110002, dt_prescr_p); 
	end if;
	end;
end if;
 
ds_regra_cad_p := wheb_mensagem_pck.get_texto(110059);
 
select 	count(*) 
into STRICT	qt_proced_w 
from 	prescr_procedimento 
where 	nr_prescricao = nr_prescricao_p 
and 	coalesce(cd_medico_exec::text, '') = '';
 
if (ie_obrig_info_med_exec_w = 'S' and 
	qt_proced_w > 0 and 
	coalesce(ds_msg_erro_p::text, '') = '') then 
	ds_msg_erro_p := wheb_mensagem_pck.get_texto(110065);
end if;
 
select 	count(*) 
into STRICT	qt_proced_setor_w 
from 	prescr_procedimento 
where 	nr_prescricao = nr_prescricao_p 
and 	(nr_seq_exame IS NOT NULL AND nr_seq_exame::text <> '') 
and 	((coalesce(cd_setor_coleta::text, '') = '') or (coalesce(cd_setor_entrega::text, '') = ''));
 
if (ie_cons_setor_coleta_lib_w = 'S' and 
	qt_proced_setor_w > 0 and 
	coalesce(ds_msg_erro_p::text, '') = '') then 
	ds_msg_erro_p := wheb_mensagem_pck.get_texto(110080);
end if;
 
select	coalesce(obter_diagnostico_atendimento(nr_atendimento_p),'N') 
into STRICT	ie_diag_atendimento_p
;
 
if (ie_diag_atendimento_p = 'N') then 
	ds_diag_atendimento_p := wheb_mensagem_pck.get_texto(110094);
end if;
 
if (ie_desf_alta_atend_def_w = 'S') then 
	ds_liberacao_p := wheb_mensagem_pck.get_texto(262487, 'ITEM='||nm_pessoa_fisica_p);
else 
	ds_liberacao_p := wheb_mensagem_pck.get_texto(110175, 'ITEM='||nm_pessoa_fisica_p);
end if;
 
ds_msg_aviso_p := wheb_mensagem_pck.get_texto(110612);
 
SELECT * FROM consiste_regra_inf_rep(cd_estabelecimento_p, nr_atendimento_p, cd_setor_atendimento_p, cd_perfil_p, ie_momento_p, ie_prescricao_alta_p, dt_prescricao_p, nm_usuario_p, ds_mensagem_p, ds_mensagem_adic_p, ie_acao_p, ie_anamnese_p, ie_evolucao_p, ie_receita_p, ie_diagnostico_p, ie_escala_indice_p, nr_prescricao_p, cd_pessoa_fisica_p, '', ie_recomendacao_p, cd_protocolo_p, ie_parecer_p, ie_peso_p, ie_autorizacao_p, ie_laudo_sus_p, ie_avaliacao_p, ie_item_prontuario_p, ie_posicionar_pep_w) INTO STRICT ds_mensagem_p, ds_mensagem_adic_p, ie_acao_p, ie_anamnese_p, ie_evolucao_p, ie_receita_p, ie_diagnostico_p, ie_escala_indice_p, ie_recomendacao_p, cd_protocolo_p, ie_parecer_p, ie_peso_p, ie_autorizacao_p, ie_laudo_sus_p, ie_avaliacao_p, ie_item_prontuario_p, ie_posicionar_pep_w;
 
<<final>> 
	 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_prescricao_eup_abort ( nr_prescricao_p bigint default null, cd_pessoa_fisica_p text DEFAULT NULL, qt_peso_p bigint default null, cd_procedimento_p bigint DEFAULT NULL, nr_seq_interno_p bigint DEFAULT NULL, ie_origem_proced_p text DEFAULT NULL, nr_atendimento_p bigint DEFAULT NULL, nm_pessoa_fisica_p text DEFAULT NULL, cd_estabelecimento_p bigint DEFAULT NULL, cd_setor_atendimento_p bigint DEFAULT NULL, cd_perfil_p bigint DEFAULT NULL, ie_momento_p text DEFAULT NULL, ie_prescricao_alta_p text DEFAULT NULL, dt_prescricao_p timestamp DEFAULT NULL, qt_altura_cm_p bigint DEFAULT NULL, nr_seq_forma_laudo_p bigint DEFAULT NULL, dt_prescr_p INOUT timestamp DEFAULT NULL, ds_mensagem_p INOUT text DEFAULT NULL, ds_mensagem_adic_p INOUT text DEFAULT NULL, ie_acao_p INOUT text DEFAULT NULL, ie_anamnese_p INOUT text DEFAULT NULL, ie_evolucao_p INOUT text DEFAULT NULL, ie_receita_p INOUT text DEFAULT NULL, ie_diagnostico_p INOUT text DEFAULT NULL, ie_escala_indice_p INOUT text DEFAULT NULL, ds_cons_med_corpo_cli_p INOUT text DEFAULT NULL, qt_exame_ult_dose_pend_p INOUT bigint DEFAULT NULL, ds_lista_pend_resposta_p INOUT text DEFAULT NULL, ds_msg_erro_p INOUT text DEFAULT NULL, ds_regra_cad_p INOUT text DEFAULT NULL, ie_diag_atendimento_p INOUT text DEFAULT NULL, ds_diag_atendimento_p INOUT text DEFAULT NULL, ds_liberacao_p INOUT text DEFAULT NULL, ds_msg_aviso_p INOUT text DEFAULT NULL, ie_recomendacao_p INOUT text DEFAULT NULL, cd_protocolo_p INOUT bigint DEFAULT NULL, ie_parecer_p INOUT text DEFAULT NULL, ie_peso_p INOUT text DEFAULT NULL, ie_autorizacao_p INOUT text DEFAULT NULL, ie_laudo_sus_p INOUT text DEFAULT NULL, ie_avaliacao_p INOUT text DEFAULT NULL, ie_item_prontuario_p INOUT text DEFAULT NULL, ie_exige_tempo_jejum_real_p INOUT text DEFAULT NULL, ds_msg_futura_p INOUT text DEFAULT NULL, nm_usuario_p text DEFAULT NULL) FROM PUBLIC;

