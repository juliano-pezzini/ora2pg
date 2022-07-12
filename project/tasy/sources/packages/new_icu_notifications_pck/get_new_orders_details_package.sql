-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION new_icu_notifications_pck.get_new_orders_details (nm_usuario_p text) RETURNS SETOF T_ALERT_DETAILS_TABLE AS $body$
DECLARE


qt_pending_ack_w  	bigint := 0;
cd_pessoa_fisica_w  varchar(10);
ie_medico_w      	varchar(1);
nr_atendimento_w	atendimento_paciente.nr_atendimento%type;
t_alert_details_w	t_alert_details;

cEncounter CURSOR FOR
	SELECT  nr_atendimento,
			obter_nome_paciente(nr_atendimento) as nm_paciente,
			cd_pessoa_fisica
	from	atendimento_paciente
	where   coalesce(dt_alta::text, '') = ''
	and (ie_medico_w = 'S' and (cd_medico_resp = cd_pessoa_fisica_w)
	or (ie_medico_w = 'N' and obter_enfermeiro_resp(nr_atendimento,'C') = cd_pessoa_fisica_w));

cNewItems CURSOR FOR
	SELECT  dt_inicio as dt_evento,
			obter_desc_material(cd_material) as descricao
	from    cpoe_material a
	left 	join cpoe_inf_adic b on a.nr_sequencia = b.nr_seq_mat_cpoe and a.nr_atendimento = b.nr_atendimento
	where  	a.nr_atendimento = nr_atendimento_w
	and    	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and    	((CASE WHEN coalesce(a.dt_lib_suspensao::text, '') = '' THEN  coalesce(a.dt_fim_cih,a.dt_fim)  ELSE coalesce(a.dt_suspensao,a.dt_fim) END  >= clock_timestamp())
	or (CASE WHEN coalesce(a.dt_lib_suspensao::text, '') = '' THEN  coalesce(a.dt_fim_cih,a.dt_fim)  ELSE coalesce(a.dt_suspensao,a.dt_fim) coalesce(END::text, '') = ''))
	and    coalesce(b.nm_user_ack::text, '') = ''
	
union all

	SELECT  dt_inicio as dt_evento,
			cpoe_obter_desc_dieta_simp(a.nr_sequencia) as descricao
	from    cpoe_dieta a
	left 	join cpoe_inf_adic b on a.nr_sequencia = b.nr_seq_diet_cpoe and a.nr_atendimento = b.nr_atendimento
	where  	a.nr_atendimento = nr_atendimento_w
	and    	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and    	((CASE WHEN coalesce(a.dt_lib_suspensao::text, '') = '' THEN  a.dt_fim  ELSE coalesce(a.dt_suspensao,a.dt_fim) END  >= clock_timestamp())
	or (CASE WHEN coalesce(a.dt_lib_suspensao::text, '') = '' THEN  a.dt_fim  ELSE coalesce(a.dt_suspensao,a.dt_fim) coalesce(END::text, '') = ''))
	and    	coalesce(b.nm_user_ack::text, '') = ''
	
union all

	select  dt_inicio as dt_evento,
			obter_desc_recomendacao(cd_recomendacao) as descricao
	from  	cpoe_recomendacao a
	left 	join cpoe_inf_adic b on a.nr_sequencia = b.nr_seq_rec_cpoe and a.nr_atendimento = b.nr_atendimento
	where  	a.nr_atendimento = nr_atendimento_w
	and     (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and    	((CASE WHEN coalesce(a.dt_lib_suspensao::text, '') = '' THEN  a.dt_fim  ELSE coalesce(a.dt_suspensao,a.dt_fim) END  >= clock_timestamp())
	or (CASE WHEN coalesce(a.dt_lib_suspensao::text, '') = '' THEN  a.dt_fim  ELSE coalesce(a.dt_suspensao,a.dt_fim) coalesce(END::text, '') = ''))
	and    	coalesce(b.nm_user_ack::text, '') = ''
	
union all

	select  dt_inicio as dt_evento,
			obter_desc_expressao(290567) as descricao
	from    cpoe_gasoterapia a
	left 	join cpoe_inf_adic b on a.nr_sequencia = b.nr_seq_gaso_cpoe and a.nr_atendimento = b.nr_atendimento
	where  	a.nr_atendimento = nr_atendimento_w
	and     (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and    	((CASE WHEN coalesce(a.dt_lib_suspensao::text, '') = '' THEN  a.dt_fim  ELSE coalesce(a.dt_suspensao,a.dt_fim) END  >= clock_timestamp())
	or (CASE WHEN coalesce(a.dt_lib_suspensao::text, '') = '' THEN  a.dt_fim  ELSE coalesce(a.dt_suspensao,a.dt_fim) coalesce(END::text, '') = ''))
	and   	 coalesce(b.nm_user_ack::text, '') = ''
	
union all

	select  dt_inicio as dt_evento,
			cpoe_obter_desc_proc_Interno(a.nr_seq_proc_interno) as descricao
	from    cpoe_procedimento a
	left 	join cpoe_inf_adic b on a.nr_sequencia = b.nr_seq_exam_cpoe and a.nr_atendimento = b.nr_atendimento
	where  	a.nr_atendimento = nr_atendimento_w
	and     (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and    	((CASE WHEN coalesce(a.dt_lib_suspensao::text, '') = '' THEN  a.dt_fim  ELSE coalesce(a.dt_suspensao,a.dt_fim) END  >= clock_timestamp())
	or (CASE WHEN coalesce(a.dt_lib_suspensao::text, '') = '' THEN  a.dt_fim  ELSE coalesce(a.dt_suspensao,a.dt_fim) coalesce(END::text, '') = ''))
	and    	coalesce(b.nm_user_ack::text, '') = ''
	
union all

	select  dt_inicio as dt_evento,
			CPOE_Obter_desc_dialise(a.ie_tipo_dialise, a.nr_seq_protocolo,null,null,null,null,'N',null,null,null,null,null,null,null,null,null,null,null) as descricao
	from    cpoe_dialise a
	left 	join cpoe_inf_adic b on a.nr_sequencia = b.nr_seq_dial_cpoe and a.nr_atendimento = b.nr_atendimento
	where  	a.nr_atendimento = nr_atendimento_w
	and     (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and    	((CASE WHEN coalesce(a.dt_lib_suspensao::text, '') = '' THEN  a.dt_fim  ELSE coalesce(a.dt_suspensao,a.dt_fim) END  >= clock_timestamp())
	or (CASE WHEN coalesce(a.dt_lib_suspensao::text, '') = '' THEN  a.dt_fim  ELSE coalesce(a.dt_suspensao,a.dt_fim) coalesce(END::text, '') = ''))
	and    	coalesce(b.nm_user_ack::text, '') = '';
BEGIN

	cd_pessoa_fisica_w := obter_codigo_usuario(nm_usuario_p);
	ie_medico_w := obter_se_usuario_medico(nm_usuario_p);

	for c_encounter_w in cEncounter
	loop

		nr_atendimento_w := c_encounter_w.nr_atendimento;

		for c_newItem_w in cNewItems
		loop

			t_alert_details_w.nr_atendimento 	:= c_encounter_w.nr_atendimento;
			t_alert_details_w.dt_evento 		:= c_newItem_w.dt_evento;
			t_alert_details_w.nm_paciente 		:= c_encounter_w.nm_paciente;
			t_alert_details_w.ds_evento			:= c_newItem_w.descricao;
			t_alert_details_w.ie_funcao			:= 'ADEP';

			RETURN NEXT t_alert_details_w;

		end loop;
	end loop;

	return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION new_icu_notifications_pck.get_new_orders_details (nm_usuario_p text) FROM PUBLIC;
