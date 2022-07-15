-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_dados_grafico (nr_cirurgia_p bigint, nr_seq_pepo_p bigint) AS $body$
DECLARE

/*
cursor	c01 is
	select  a.dt_sinal_vital x,
			null dt_start,
			null dt_end,
			a.qt_bcf y,
			null y_min,
			null y_max,
			'SV' code_group,
			null nm_tabela,
			null nm_atributo,
			'BC' vl_dominio,
			null ie_bolus,
			a.nr_sequencia nr_seq_superior,
			a.nm_usuario nm_usuario,
			a.nr_sequencia nr_sequencia,
			a.nr_seq_pepo nr_seq_pepo,
			a.nr_cirurgia nr_cirurgia,
			null values_group
	from   atendimento_sinal_vital a
	where  	1 = 1
	and		a.dt_liberacao is not null
	and    	a.dt_inativacao is null
	and		a.qt_bcf is not null
	and		(a.nr_cirurgia = nr_cirurgia_p or nr_cirurgia_p is null)
	and		(a.nr_seq_pepo = nr_seq_pepo_p or nr_seq_pepo_p is null)
	union all
	select  a.dt_monitorizacao x,
			null dt_start,
			null dt_end,
			a.qt_cam y,
			null y_min,
			null y_max,
			'SV' code_group,
			null nm_tabela,
			null nm_atributo,
			'CAM' vl_dominio,
			null ie_bolus,
			a.nr_sequencia nr_seq_superior,
			a.nm_usuario nm_usuario,
			a.nr_sequencia nr_sequencia,
			a.nr_seq_pepo nr_seq_pepo,
			a.nr_cirurgia nr_cirurgia,
			null values_group
	from   atendimento_monit_resp a
	where  	1 = 1
	and		a.dt_liberacao is not null
	and    	a.dt_inativacao is null
	and		a.qt_cam is not null
	and		(a.nr_cirurgia = nr_cirurgia_p or nr_cirurgia_p is null)
	and		(a.nr_seq_pepo = nr_seq_pepo_p or nr_seq_pepo_p is null)
	union all
	select  a.dt_monitorizacao x,
			null dt_start,
			null dt_end,
			a.qt_co2 y,
			null y_min,
			null y_max,
			'SV' code_group,
			null nm_tabela,
			null nm_atributo,
			'E' vl_dominio,
			null ie_bolus,
			a.nr_sequencia nr_seq_superior,
			a.nm_usuario nm_usuario,
			a.nr_sequencia nr_sequencia,
			a.nr_seq_pepo nr_seq_pepo,
			a.nr_cirurgia nr_cirurgia,
			null values_group
	from   atendimento_monit_resp a
	where  	1 = 1
	and		a.dt_liberacao is not null
	and    	a.dt_inativacao is null
	and		a.qt_co2 is not null
	and		(a.nr_cirurgia = nr_cirurgia_p or nr_cirurgia_p is null)
	and		(a.nr_seq_pepo = nr_seq_pepo_p or nr_seq_pepo_p is null)
	union all
	select  a.dt_sinal_vital x,
			null dt_start,
			null dt_end,
			a.qt_freq_cardiaca y,
			null y_min,
			null y_max,
			'SV' code_group,
			null nm_tabela,
			null nm_atributo,
			'FC' vl_dominio,
			null ie_bolus,
			a.nr_sequencia nr_seq_superior,
			a.nm_usuario nm_usuario,
			a.nr_sequencia nr_sequencia,
			a.nr_seq_pepo nr_seq_pepo,
			a.nr_cirurgia nr_cirurgia,
			null values_group
	from   atendimento_sinal_vital a
	where  	1 = 1
	and		a.dt_liberacao is not null
	and    	a.dt_inativacao is null
	and		a.qt_freq_cardiaca is not null
	and		(a.nr_cirurgia = nr_cirurgia_p or nr_cirurgia_p is null)
	and		(a.nr_seq_pepo = nr_seq_pepo_p or nr_seq_pepo_p is null)
	union all
	select  a.dt_sinal_vital x,
			null dt_start,
			null dt_end,
			a.qt_freq_card_monit y,
			null y_min,
			null y_max,
			'SV' code_group,
			null nm_tabela,
			null nm_atributo,
			'FCM' vl_dominio,
			null ie_bolus,
			a.nr_sequencia nr_seq_superior,
			a.nm_usuario nm_usuario,
			a.nr_sequencia nr_sequencia,
			a.nr_seq_pepo nr_seq_pepo,
			a.nr_cirurgia nr_cirurgia,
			null values_group
	from   atendimento_sinal_vital a
	where  	1 = 1
	and		a.dt_liberacao is not null
	and    	a.dt_inativacao is null
	and		a.qt_freq_card_monit is not null
	and		(a.nr_cirurgia = nr_cirurgia_p or nr_cirurgia_p is null)
	and		(a.nr_seq_pepo = nr_seq_pepo_p or nr_seq_pepo_p is null)
	union all
	select  a.dt_sinal_vital x,
			null dt_start,
			null dt_end,
			a.qt_freq_resp y,
			null y_min,
			null y_max,
			'SV' code_group,
			null nm_tabela,
			null nm_atributo,
			'FR' vl_dominio,
			null ie_bolus,
			a.nr_sequencia nr_seq_superior,
			a.nm_usuario nm_usuario,
			a.nr_sequencia nr_sequencia,
			a.nr_seq_pepo nr_seq_pepo,
			a.nr_cirurgia nr_cirurgia,
			null values_group
	from   atendimento_sinal_vital a
	where  	1 = 1
	and		a.dt_liberacao is not null
	and    	a.dt_inativacao is null
	and		a.qt_freq_resp is not null
	and		(a.nr_cirurgia = nr_cirurgia_p or nr_cirurgia_p is null)
	and		(a.nr_seq_pepo = nr_seq_pepo_p or nr_seq_pepo_p is null)
	union all
	select  a.dt_sinal_vital x,
			null dt_start,
			null dt_end,
			a.qt_glicemia_capilar y,
			null y_min,
			null y_max,
			'SV' code_group,
			null nm_tabela,
			null nm_atributo,
			'GC' vl_dominio,
			null ie_bolus,
			a.nr_sequencia nr_seq_superior,
			a.nm_usuario nm_usuario,
			a.nr_sequencia nr_sequencia,
			a.nr_seq_pepo nr_seq_pepo,
			a.nr_cirurgia nr_cirurgia,
			null values_group
	from   atendimento_sinal_vital a
	where  	1 = 1
	and		a.dt_liberacao is not null
	and    	a.dt_inativacao is null
	and		a.qt_glicemia_capilar is not null
	and		(a.nr_cirurgia = nr_cirurgia_p or nr_cirurgia_p is null)
	and		(a.nr_seq_pepo = nr_seq_pepo_p or nr_seq_pepo_p is null)
	union all
	select  a.dt_monitorizacao x,
			null dt_start,
			null dt_end,
			a.qt_halog_exp y,
			null y_min,
			null y_max,
			'SV' code_group,
			null nm_tabela,
			null nm_atributo,
			'HE' vl_dominio,
			null ie_bolus,
			a.nr_sequencia nr_seq_superior,
			a.nm_usuario nm_usuario,
			a.nr_sequencia nr_sequencia,
			a.nr_seq_pepo nr_seq_pepo,
			a.nr_cirurgia nr_cirurgia,
			null values_group
	from   atendimento_monit_resp a
	where  	1 = 1
	and		a.dt_liberacao is not null
	and    	a.dt_inativacao is null
	and		a.qt_halog_exp is not null
	and		(a.nr_cirurgia = nr_cirurgia_p or nr_cirurgia_p is null)
	and		(a.nr_seq_pepo = nr_seq_pepo_p or nr_seq_pepo_p is null)
	union all
	select  a.dt_monitorizacao x,
			null dt_start,
			null dt_end,
			a.qt_halog_ins y,
			null y_min,
			null y_max,
			'SV' code_group,
			null nm_tabela,
			null nm_atributo,
			'HI' vl_dominio,
			null ie_bolus,
			a.nr_sequencia nr_seq_superior,
			a.nm_usuario nm_usuario,
			a.nr_sequencia nr_sequencia,
			a.nr_seq_pepo nr_seq_pepo,
			a.nr_cirurgia nr_cirurgia,
			null values_group
	from   atendimento_monit_resp a
	where  	1 = 1
	and		a.dt_liberacao is not null
	and    	a.dt_inativacao is null
	and		a.qt_halog_ins is not null
	and		(a.nr_cirurgia = nr_cirurgia_p or nr_cirurgia_p is null)
	and		(a.nr_seq_pepo = nr_seq_pepo_p or nr_seq_pepo_p is null)
	union all
	select  a.dt_sinal_vital x,
			null dt_start,
			null dt_end,
			a.qt_pressao_intra_cranio y,
			null y_min,
			null y_max,
			'SV' code_group,
			null nm_tabela,
			null nm_atributo,
			'ICP' vl_dominio,
			null ie_bolus,
			a.nr_sequencia nr_seq_superior,
			a.nm_usuario nm_usuario,
			a.nr_sequencia nr_sequencia,
			a.nr_seq_pepo nr_seq_pepo,
			a.nr_cirurgia nr_cirurgia,
			null values_group
	from   atendimento_sinal_vital a
	where  	1 = 1
	and		a.dt_liberacao is not null
	and    	a.dt_inativacao is null
	and		a.qt_pressao_intra_cranio is not null
	and		(a.nr_cirurgia = nr_cirurgia_p or nr_cirurgia_p is null)
	and		(a.nr_seq_pepo = nr_seq_pepo_p or nr_seq_pepo_p is null)
	union all
	select  a.dt_sinal_vital x,
			null dt_start,
			null dt_end,
			a.qt_maec y,
			null y_min,
			null y_max,
			'SV' code_group,
			null nm_tabela,
			null nm_atributo,
			'M' vl_dominio,
			null ie_bolus,
			a.nr_sequencia nr_seq_superior,
			a.nm_usuario nm_usuario,
			a.nr_sequencia nr_sequencia,
			a.nr_seq_pepo nr_seq_pepo,
			a.nr_cirurgia nr_cirurgia,
			null values_group
	from   atendimento_sinal_vital a
	where  	1 = 1
	and		a.dt_liberacao is not null
	and    	a.dt_inativacao is null
	and		a.qt_maec is not null
	and		(a.nr_cirurgia = nr_cirurgia_p or nr_cirurgia_p is null)
	and		(a.nr_seq_pepo = nr_seq_pepo_p or nr_seq_pepo_p is null)
	union all
	select  a.dt_sinal_vital x,
			null dt_start,
			null dt_end,
			a.qt_pae y,
			null y_min,
			null y_max,
			'SV' code_group,
			null nm_tabela,
			null nm_atributo,
			'PAE' vl_dominio,
			null ie_bolus,
			a.nr_sequencia nr_seq_superior,
			a.nm_usuario nm_usuario,
			a.nr_sequencia nr_sequencia,
			a.nr_seq_pepo nr_seq_pepo,
			a.nr_cirurgia nr_cirurgia,
			null values_group
	from   atendimento_sinal_vital a
	where  	1 = 1
	and		a.dt_liberacao is not null
	and    	a.dt_inativacao is null
	and		a.qt_pae is not null
	and		(a.nr_cirurgia = nr_cirurgia_p or nr_cirurgia_p is null)
	and		(a.nr_seq_pepo = nr_seq_pepo_p or nr_seq_pepo_p is null)
	union all
	select  a.dt_sinal_vital x,
			null dt_start,
			null dt_end,
			a.qt_pam y,
			null y_min,
			null y_max,
			'SV' code_group,
			null nm_tabela,
			null nm_atributo,
			'PAM' vl_dominio,
			null ie_bolus,
			a.nr_sequencia nr_seq_superior,
			a.nm_usuario nm_usuario,
			a.nr_sequencia nr_sequencia,
			a.nr_seq_pepo nr_seq_pepo,
			a.nr_cirurgia nr_cirurgia,
			null values_group
	from   atendimento_sinal_vital a
	where  	1 = 1
	and		a.dt_liberacao is not null
	and    	a.dt_inativacao is null
	and		a.qt_pam is not null
	and		(a.nr_cirurgia = nr_cirurgia_p or nr_cirurgia_p is null)
	and		(a.nr_seq_pepo = nr_seq_pepo_p or nr_seq_pepo_p is null)
	union all
	select  a.dt_sinal_vital x,
			null dt_start,
			null dt_end,
			a.qt_pam y,
			a.qt_pa_diastolica y_min,
			a.qt_pa_sistolica y_max,
			'SV' code_group,
			null nm_tabela,
			null nm_atributo,
			'PA' vl_dominio,
			null ie_bolus,
			a.nr_sequencia nr_seq_superior,
			a.nm_usuario nm_usuario,
			a.nr_sequencia nr_sequencia,
			a.nr_seq_pepo nr_seq_pepo,
			a.nr_cirurgia nr_cirurgia,
			null values_group
	from   atendimento_sinal_vital a
	where  	1 = 1
	and		a.dt_liberacao is not null
	and    	a.dt_inativacao is null
	and		(a.qt_pa_sistolica is not null or qt_pa_diastolica is not null or qt_pam is not null)
	and		(a.nr_cirurgia = nr_cirurgia_p or nr_cirurgia_p is null)
	and		(a.nr_seq_pepo = nr_seq_pepo_p or nr_seq_pepo_p is null)
	union all
	select  a.dt_monitorizacao x,
			null dt_start,
			null dt_end,
			a.qt_peep y,
			null y_min,
			null y_max,
			'SV' code_group,
			null nm_tabela,
			null nm_atributo,
			'PEEP' vl_dominio,
			null ie_bolus,
			a.nr_sequencia nr_seq_superior,
			a.nm_usuario nm_usuario,
			a.nr_sequencia nr_sequencia,
			a.nr_seq_pepo nr_seq_pepo,
			a.nr_cirurgia nr_cirurgia,
			null values_group
	from   atendimento_monit_resp a
	where  	1 = 1
	and		a.dt_liberacao is not null
	and    	a.dt_inativacao is null
	and		a.qt_peep is not null
	and		(a.nr_cirurgia = nr_cirurgia_p or nr_cirurgia_p is null)
	and		(a.nr_seq_pepo = nr_seq_pepo_p or nr_seq_pepo_p is null)
	union all
	select  a.dt_sinal_vital x,
			null dt_start,
			null dt_end,
			a.qt_pvc y,
			null y_min,
			null y_max,
			'SV' code_group,
			null nm_tabela,
			null nm_atributo,
			'PVC' vl_dominio,
			null ie_bolus,
			a.nr_sequencia nr_seq_superior,
			a.nm_usuario nm_usuario,
			a.nr_sequencia nr_sequencia,
			a.nr_seq_pepo nr_seq_pepo,
			a.nr_cirurgia nr_cirurgia,
			null values_group
	from   atendimento_sinal_vital a
	where  	1 = 1
	and		a.dt_liberacao is not null
	and    	a.dt_inativacao is null
	and		a.qt_pvc is not null
	and		(a.nr_cirurgia = nr_cirurgia_p or nr_cirurgia_p is null)
	and		(a.nr_seq_pepo = nr_seq_pepo_p or nr_seq_pepo_p is null)
	union all
	select  a.dt_sinal_vital x,
			null dt_start,
			null dt_end,
			a.qt_saturacao_o2 y,
			null y_min,
			null y_max,
			'SV' code_group,
			null nm_tabela,
			null nm_atributo,
			'S' vl_dominio,
			null ie_bolus,
			a.nr_sequencia nr_seq_superior,
			a.nm_usuario nm_usuario,
			a.nr_sequencia nr_sequencia,
			a.nr_seq_pepo nr_seq_pepo,
			a.nr_cirurgia nr_cirurgia,
			null values_group
	from   atendimento_sinal_vital a
	where  	1 = 1
	and		a.dt_liberacao is not null
	and    	a.dt_inativacao is null
	and		a.qt_saturacao_o2 is not null
	and		(a.nr_cirurgia = nr_cirurgia_p or nr_cirurgia_p is null)
	and		(a.nr_seq_pepo = nr_seq_pepo_p or nr_seq_pepo_p is null)
	union all
	select  a.dt_analise x,
			null dt_start,
			null dt_end,
			a.qt_tca y,
			null y_min,
			null y_max,
			'SV' code_group,
			null nm_tabela,
			null nm_atributo,
			'TCA' vl_dominio,
			null ie_bolus,
			a.nr_sequencia nr_seq_superior,
			a.nm_usuario nm_usuario,
			a.nr_sequencia nr_sequencia,
			a.nr_seq_pepo nr_seq_pepo,
			a.nr_cirurgia nr_cirurgia,
			null values_group
	from   atend_anal_bioq_port a
	where  	1 = 1
	and		a.dt_liberacao is not null
	and    	a.dt_inativacao is null
	and		a.qt_tca is not null
	and		(a.nr_cirurgia = nr_cirurgia_p or nr_cirurgia_p is null)
	and		(a.nr_seq_pepo = nr_seq_pepo_p or nr_seq_pepo_p is null)
	union all
	select  a.dt_sinal_vital x,
			null dt_start,
			null dt_end,
			a.qt_tof_bloq_neuro_musc y,
			null y_min,
			null y_max,
			'SV' code_group,
			null nm_tabela,
			null nm_atributo,
			'TOP' vl_dominio,
			null ie_bolus,
			a.nr_sequencia nr_seq_superior,
			a.nm_usuario nm_usuario,
			a.nr_sequencia nr_sequencia,
			a.nr_seq_pepo nr_seq_pepo,
			a.nr_cirurgia nr_cirurgia,
			null values_group
	from   atendimento_sinal_vital a
	where  	1 = 1
	and		a.dt_liberacao is not null
	and    	a.dt_inativacao is null
	and		a.qt_tof_bloq_neuro_musc is not null
	and		(a.nr_cirurgia = nr_cirurgia_p or nr_cirurgia_p is null)
	and		(a.nr_seq_pepo = nr_seq_pepo_p or nr_seq_pepo_p is null)
	union all
	select  a.dt_sinal_vital x,
			null dt_start,
			null dt_end,
			a.qt_temp y,
			null y_min,
			null y_max,
			'SV' code_group,
			null nm_tabela,
			null nm_atributo,
			'T' vl_dominio,
			null ie_bolus,
			a.nr_sequencia nr_seq_superior,
			a.nm_usuario nm_usuario,
			a.nr_sequencia nr_sequencia,
			a.nr_seq_pepo nr_seq_pepo,
			a.nr_cirurgia nr_cirurgia,
			null values_group
	from   atendimento_sinal_vital a
	where  	1 = 1
	and		a.dt_liberacao is not null
	and    	a.dt_inativacao is null
	and		a.qt_temp is not null
	and		(a.nr_cirurgia = nr_cirurgia_p or nr_cirurgia_p is null)
	and		(a.nr_seq_pepo = nr_seq_pepo_p or nr_seq_pepo_p is null)
	union all
	/* Medications / Agents and Hidroeletric Teraphy  */

		/* Point Start */

		/*
	select	b.dt_inicio_adm x,
			b.dt_inicio_adm dt_start,
			b.dt_final_adm dt_end,
			get_y_surgery_chart(b.qt_dose,b.qt_dose_ataque,b.qt_halog_ins,b.qt_velocidade_inf) y,
			null y_min,
			null y_max,
			'AG' code_group,
			'CIRURGIA_AGENTE_ANESTESICO' nm_tabela,
			--'DS_AGENTE' || '_' || get_type_chart_surgery_agent(b.qt_dose,b.qt_dose_ataque,b.qt_halog_ins,b.qt_velocidade_inf,b.ie_aplic_bolus) nm_atributo,
			'DS_AGENTE'|| '_' || get_type_chart_surgery(b.nr_sequencia,a.nr_sequencia,'style') nm_atributo,
			null vl_dominio,
			b.ie_aplic_bolus ie_bolus,
			a.nr_sequencia nr_seq_superior,
			a.nm_usuario nm_usuario,
			a.nr_sequencia nr_sequencia,
			a.nr_seq_pepo nr_seq_pepo,
			a.nr_cirurgia nr_cirurgia,
			b.nr_sequencia values_group
	from	cirurgia_agente_anest_ocor b,
			cirurgia_agente_anestesico a
	where	a.nr_sequencia = b.nr_seq_cirur_agente
	and	nvl(a.ie_situacao,'A') = 'A'
	and  	nvl(b.ie_situacao,'A') = 'A'
	and	 	a.ie_tipo in (1,2,3)
	and		(a.nr_cirurgia = nr_cirurgia_p or nr_cirurgia_p is null)
	and		(a.nr_seq_pepo = nr_seq_pepo_p or nr_seq_pepo_p is null)
	union all
		/* Point End */

		/*
	select	decode(b.ie_aplic_bolus,'S',b.dt_inicio_adm,nvl(b.dt_final_adm,nvl(obter_data_grafico_pepo('F',a.nr_cirurgia),sysdate))) x,
			b.dt_inicio_adm dt_start,
			b.dt_final_adm dt_end,
			get_y_surgery_chart(b.qt_dose,b.qt_dose_ataque,b.qt_halog_ins,b.qt_velocidade_inf) y,
			null y_min,
			null y_max,
			'AG' code_group,
			'CIRURGIA_AGENTE_ANESTESICO' nm_tabela,
			--'DS_AGENTE'|| '_' || get_type_chart_surgery_agent(b.qt_dose,b.qt_dose_ataque,b.qt_halog_ins,b.qt_velocidade_inf,b.ie_aplic_bolus) nm_atributo,
			'DS_AGENTE'|| '_' || get_type_chart_surgery(b.nr_sequencia,a.nr_sequencia,'style') nm_atributo,
			null vl_dominio,
			b.ie_aplic_bolus ie_bolus,
			a.nr_sequencia nr_seq_superior,
			a.nm_usuario nm_usuario,
			a.nr_sequencia nr_sequencia,
			a.nr_seq_pepo nr_seq_pepo,
			a.nr_cirurgia nr_cirurgia,
			b.nr_sequencia values_group
	from	cirurgia_agente_anest_ocor b,
			cirurgia_agente_anestesico a
	where	a.nr_sequencia = b.nr_seq_cirur_agente
	and	nvl(a.ie_situacao,'A') = 'A'
	and  	nvl(b.ie_situacao,'A') = 'A'
	and	a.ie_tipo in (1,2,3)
	and	nvl(b.qt_dose_ataque,0) = 0
	and		(a.nr_cirurgia = nr_cirurgia_p or nr_cirurgia_p is null)
	and		(a.nr_seq_pepo = nr_seq_pepo_p or nr_seq_pepo_p is null)
	union all
	/* Blood components  */

		/* Point Start */

		/*
	select	b.dt_inicio_adm x,
			b.dt_inicio_adm dt_start,
			b.dt_final_adm dt_end,
			b.qt_dose y,
			null y_min,
			null y_max,
			'SH' code_group,
			'CIRURGIA_AGENTE_ANESTESICO' nm_tabela,
			'DS_AGENTE_HEMO' nm_atributo,
			null vl_dominio,
			b.ie_aplic_bolus ie_bolus,
			a.nr_sequencia nr_seq_superior,
			a.nm_usuario nm_usuario,
			a.nr_sequencia nr_sequencia,
			a.nr_seq_pepo nr_seq_pepo,
			a.nr_cirurgia nr_cirurgia,
			b.nr_sequencia values_group
	from	cirurgia_agente_anest_ocor b,
			cirurgia_agente_anestesico a
	where	a.nr_sequencia = b.nr_seq_cirur_agente
	and		nvl(a.ie_situacao,'A') = 'A'
	and  	nvl(b.ie_situacao,'A') = 'A'
	and	 	a.ie_tipo = 5
	and		(a.nr_cirurgia = nr_cirurgia_p or nr_cirurgia_p is null)
	and		(a.nr_seq_pepo = nr_seq_pepo_p or nr_seq_pepo_p is null)
	union all
		/* Point End */

		/*
	select	nvl(b.dt_final_adm,nvl(obter_data_grafico_pepo('F',a.nr_cirurgia),sysdate)) x,
			b.dt_inicio_adm dt_start,
			b.dt_final_adm dt_end,
			b.qt_dose y,
			null y_min,
			null y_max,
			'SH' code_group,
			'CIRURGIA_AGENTE_ANESTESICO' nm_tabela,
			'DS_AGENTE_HEMO' nm_atributo,
			null vl_dominio,
			b.ie_aplic_bolus ie_bolus,
			a.nr_sequencia nr_seq_superior,
			a.nm_usuario nm_usuario,
			a.nr_sequencia nr_sequencia,
			a.nr_seq_pepo nr_seq_pepo,
			a.nr_cirurgia nr_cirurgia,
			b.nr_sequencia values_group
	from	cirurgia_agente_anest_ocor b,
			cirurgia_agente_anestesico a
	where	a.nr_sequencia = b.nr_seq_cirur_agente
	and		nvl(a.ie_situacao,'A') = 'A'
	and  	nvl(b.ie_situacao,'A') = 'A'
	and	 	a.ie_tipo = 5
	and		(a.nr_cirurgia = nr_cirurgia_p or nr_cirurgia_p is null)
	and		(a.nr_seq_pepo = nr_seq_pepo_p or nr_seq_pepo_p is null)
	union all
	/* Hidro balance - Wins and losses */

	/*
	select	b.dt_medida x,
			b.dt_medida dt_start,
			null dt_end,
			decode(obter_tipo_perda_ganho(b.nr_seq_tipo,'C'),
					'G',decode(nvl(ie_volume_ocorrencia,'V'),'O', qt_ocorrencia, qt_volume),
					'P',decode(nvl(ie_volume_ocorrencia,'V'),'O', qt_ocorrencia, qt_volume) * -1) y,
			null y_min,
			null y_max,
			'BH' code_group,
			'ATENDIMENTO_PERDA_GANHO' nm_tabela,
			'DS_TIPO' nm_atributo,
			null vl_dominio,
			null ie_bolus,
			b.nr_seq_tipo nr_seq_superior,
			b.nm_usuario nm_usuario,
			b.nr_sequencia nr_sequencia,
			b.nr_seq_pepo nr_seq_pepo,
			b.nr_cirurgia nr_cirurgia,
			null values_group
	from 	tipo_perda_ganho c,
			atendimento_perda_ganho b
	where 	b.nr_seq_tipo = c.nr_sequencia
	and		c.ie_exibir_grafico = 'S'
	and 	nvl(b.ie_situacao,'A') = 'A'
	and    	b.dt_inativacao is null
	and		(b.nr_cirurgia = nr_cirurgia_p or nr_cirurgia_p is null)
	and		(b.nr_seq_pepo = nr_seq_pepo_p or nr_seq_pepo_p is null)
	union all
	/* Hidro balance - Summary */

	/*
	select	b.dt_medida x,
			b.dt_medida dt_start,
			null dt_end,
			(select	sum(decode(obter_tipo_perda_ganho(x.nr_seq_tipo,'C'),
					'G',decode(nvl(y.ie_volume_ocorrencia,'V'),'O', qt_ocorrencia, qt_volume),
					'P',decode(nvl(y.ie_volume_ocorrencia,'V'),'O', qt_ocorrencia, qt_volume) * -1))
			from	tipo_perda_ganho y,
					atendimento_perda_ganho x
			where	x.nr_seq_tipo = y.nr_sequencia
			and		(x.nr_cirurgia = b.nr_cirurgia or x.nr_cirurgia is null)
			and		(x.nr_seq_pepo = b.nr_seq_pepo or x.nr_seq_pepo is null)
			and		(x.nr_cirurgia is not null or x.nr_seq_pepo is not null)
			and    		x.dt_inativacao is null
			and		x.dt_medida <= b.dt_medida) y,
			null y_min,
			null y_max,
			'BH' code_group,
			'ATENDIMENTO_PERDA_GANHO' nm_tabela,
			'BALANCO' nm_atributo,
			null vl_dominio,
			null ie_bolus,
			b.nr_seq_tipo nr_seq_superior,
			b.nm_usuario nm_usuario,
			b.nr_sequencia nr_sequencia,
			b.nr_seq_pepo nr_seq_pepo,
			b.nr_cirurgia nr_cirurgia,
			null values_group
	from 	tipo_perda_ganho c,
			atendimento_perda_ganho b
	where 	b.nr_seq_tipo = c.nr_sequencia
	and		c.ie_exibir_grafico = 'S'
	and 	nvl(b.ie_situacao,'A') = 'A'
	and    	b.dt_inativacao is null
	and		(b.nr_cirurgia = nr_cirurgia_p or nr_cirurgia_p is null)
	and		(b.nr_seq_pepo = nr_seq_pepo_p or nr_seq_pepo_p is null)
	union all
	/* Hidro balance - Summary - End calculated */

	/*
	select	nvl(obter_data_grafico_pepo('F',b.nr_cirurgia),sysdate) x,
			null dt_start,
			null dt_end,
			(select	sum(decode(obter_tipo_perda_ganho(x.nr_seq_tipo,'C'),
					'G',decode(nvl(y.ie_volume_ocorrencia,'V'),'O', qt_ocorrencia, qt_volume),
					'P',decode(nvl(y.ie_volume_ocorrencia,'V'),'O', qt_ocorrencia, qt_volume) * -1))
			from	tipo_perda_ganho y,
					atendimento_perda_ganho x
			where	x.nr_seq_tipo = y.nr_sequencia
			and		nvl(x.ie_situacao,'A') = 'A'
			and    		x.dt_inativacao is null
			and		(x.nr_cirurgia = b.nr_cirurgia or x.nr_cirurgia is null)
			and		(x.nr_seq_pepo = b.nr_seq_pepo or x.nr_seq_pepo is null)
			and		(x.nr_cirurgia is not null or x.nr_seq_pepo is not null)
			and		x.dt_medida	<= nvl(obter_data_grafico_pepo('F',b.nr_cirurgia),sysdate)) y,
			null y_min,
			null y_max,
			'BH' code_group,
			'ATENDIMENTO_PERDA_GANHO' nm_tabela,
			'BALANCO' nm_atributo,
			null vl_dominio,
			null ie_bolus,
			null nr_seq_superior,
			b.nm_usuario nm_usuario,
			b.nr_cirurgia nr_sequencia,
			b.nr_seq_pepo nr_seq_pepo,
			b.nr_cirurgia nr_cirurgia,
			null values_group
	from 	cirurgia b
	where	1 = 1
	and		mod((select	count(1)
			from	atendimento_perda_ganho x
			where	nvl(x.ie_situacao,'A') = 'A'
			and		(x.nr_cirurgia = b.nr_cirurgia or x.nr_cirurgia is null)
			and		(x.nr_seq_pepo = b.nr_seq_pepo or x.nr_seq_pepo is null)
			and		x.dt_inativacao is null
			and		(x.nr_cirurgia is not null or x.nr_seq_pepo is not null)),2) = 1 /* Only generate this line if non pair quantity */
			/*
	and		(b.nr_cirurgia = nr_cirurgia_p or nr_cirurgia_p is null)
	and		(b.nr_seq_pepo = nr_seq_pepo_p or nr_seq_pepo_p is null)
	union all
	/* Events */

	/*
	select	a.dt_registro x,
			null dt_start,
			null dt_end,
			0 y,
			null y_min,
			null y_max,
			'NAV' code_group,
			'EVENTO_CIRURGIA_PACIENTE' nm_tabela,
			decode(b.ie_etapa_cirurgia,1,'DS_PACIENTE',6,'DS_PACIENTE',2,'DS_ANESTESIA',5,'DS_ANESTESIA',3,'DS_PROCEDIMENTO',4,'DS_PROCEDIMENTO') nm_atributo,
			null vl_dominio,
			null ie_bolus,
			null nr_seq_superior,
			a.nm_usuario nm_usuario,
			a.nr_sequencia nr_sequencia,
			a.nr_seq_pepo nr_seq_pepo,
			a.nr_cirurgia nr_cirurgia,
			null values_group
	from	evento_cirurgia b,
			evento_cirurgia_paciente a
	where	a.nr_seq_evento = b.nr_sequencia
	and  	a.dt_inativacao is null
	and		(a.nr_cirurgia = nr_cirurgia_p or nr_cirurgia_p is null)
	and		(a.nr_seq_pepo = nr_seq_pepo_p or nr_seq_pepo_p is null);

dt_x_w 					date;
dt_start_w 			date;
dt_end_w				date;
vl_linha_w 			number(15,4);
y_min_w 				number(15,4);
y_max_w 				number(15,4);
code_group_w 			varchar2(15);
nm_tabela_w 			varchar2(50);
nm_atributo_w 		varchar2(50);
vl_dominio_w 			varchar2(15);
ie_bolus_w 			varchar2(15);
nr_seq_superior_w 	number(10);
nm_usuario_w 			varchar2(15);
nr_sequencia_w 		number(10);
nr_seq_pepo_w 		number(10);
nr_cirurgia_w 		number(10);
*/
values_group_w 		bigint;



BEGIN
values_group_w := 0;


/*
open C01;
loop
fetch C01 into
	DT_X_w,
	dt_start_w,
	dt_end_w,
	VL_LINHA_w,
	y_min_w,
	y_max_w,
	code_group_w,
	nm_tabela_w,
	nm_atributo_w,
	vl_dominio_w,
	ie_bolus_w,
	nr_seq_superior_w,
	nm_usuario_w,
	nr_sequencia_w,
	nr_seq_pepo_w,
	nr_cirurgia_w,
	values_group_w;
exit when C01%notfound;
	begin

	insert into W_DADOS_GRAFICO_PEPO (DT_X,
												 DT_START,
												 DT_END,
												 VL_LINHA,
												 Y_MIN,
												 Y_MAX,
												 CODE_GROUP,
												 NM_TABELA,
												 NM_ATRIBUTO,
												 VL_DOMINIO,
												 IE_BOLUS,
												 NR_SEQ_SUPERIOR,
												 NM_USUARIO,
												 NR_SEQUENCIA,
												 NR_SEQ_PEPO,
												 NR_CIRURGIA,
												 VALUES_GROUP)
		values
												 (DT_X_w,
												dt_start_w,
												dt_end_w,
												VL_LINHA_w,
												y_min_w,
												y_max_w,
												code_group_w,
												nm_tabela_w,
												nm_atributo_w,
												vl_dominio_w,
												ie_bolus_w,
												nr_seq_superior_w,
												nm_usuario_w,
												nr_sequencia_w,
												nr_seq_pepo_w,
												nr_cirurgia_w,
												values_group_w);
	commit;

	end;
end loop;
close C01;
*/
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_dados_grafico (nr_cirurgia_p bigint, nr_seq_pepo_p bigint) FROM PUBLIC;

