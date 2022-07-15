-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_reproc_hor_dieta_enteral ( nr_sequencia_p cpoe_dieta.nr_sequencia%type, nr_atendimento_p atendimento_paciente.nr_atendimento%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_perfil_p perfil.cd_perfil%type, nm_usuario_p usuario.nm_usuario%type ) AS $body$
DECLARE


	param_CPOE_24_w		varchar(1);
	ie_operacao_w		intervalo_prescricao.ie_operacao%type;
	ie_administracao_w  cpoe_dieta.ie_administracao%type;
	ie_tipo_dieta_w		cpoe_dieta.ie_tipo_dieta%type;
	ie_continuo_w		cpoe_dieta.ie_continuo%type;
	cd_intervalo_w		cpoe_dieta.cd_intervalo%type;
	qt_hora_fase_w		cpoe_dieta.qt_hora_fase%type;
	qt_tempo_pausa_w	cpoe_dieta.qt_tempo_pausa%type;
	ie_duracao_w		cpoe_dieta.ie_duracao%type;
	nr_ocorrencia_w		cpoe_dieta.nr_ocorrencia%type;
	dt_inicio_w			cpoe_dieta.dt_inicio%type;
	dt_fim_w			cpoe_dieta.dt_fim%type;
	hr_prim_horario_w	cpoe_dieta.hr_prim_horario%type;
	ds_horarios_w		cpoe_dieta.ds_horarios%type;
	ds_horarios_calc_w	cpoe_dieta.ds_horarios%type;
	qt_tempo_aplic_w	cpoe_dieta.qt_tempo_aplic%type;
	qt_tempo_calc_w		double precision;
	dt_referencia_w		timestamp;


BEGIN

	param_CPOE_24_w := obter_param_usuario(2314, 24, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, param_CPOE_24_w);
	if (param_CPOE_24_w = 'S') then

		select max(a.cd_intervalo),
			   CASE WHEN max(a.ie_continuo)='C' THEN 'S'  ELSE 'N' END ,
			   max(a.qt_hora_fase),
			   max(a.qt_tempo_pausa),
			   max(a.ie_duracao),
			   max(a.dt_inicio),
			   max(a.dt_fim),
			   max(a.hr_prim_horario),
			   max(a.ie_tipo_dieta),
			   0,
			   max(a.qt_tempo_aplic),
			   max(a.ie_administracao),
			   max(a.ds_horarios)
		  into STRICT cd_intervalo_w,
			   ie_continuo_w,
			   qt_hora_fase_w,
			   qt_tempo_pausa_w,
			   ie_duracao_w,
			   dt_inicio_w,
			   dt_fim_w,
			   hr_prim_horario_w,
			   ie_tipo_dieta_w,
			   nr_ocorrencia_w,
			   qt_tempo_aplic_w,
			   ie_administracao_w,
			   ds_horarios_w
		  from cpoe_dieta a
		 where nr_sequencia = nr_sequencia_p;

		 if ((ie_tipo_dieta_w = 'E') and (ie_continuo_w = 'S') and (ie_administracao_w = 'P')) then

			select max(ie_operacao)
			  into STRICT ie_operacao_w
			  from intervalo_prescricao 
			 where cd_intervalo = cd_intervalo_w;
			
			if (ie_operacao_w <> 'F') then

				qt_tempo_calc_w := dividir(obter_minutos_hora(coalesce(qt_tempo_aplic_w, '24:00')), 60);
				ds_horarios_calc_w := ds_horarios_w;
				if (hr_prim_horario_w IS NOT NULL AND hr_prim_horario_w::text <> '') then
					dt_referencia_w := to_date(to_char(dt_inicio_w,'dd/mm/yyyy') || ' ' || hr_prim_horario_w,'dd/mm/yyyy hh24:mi:ss');
				else
					dt_referencia_w := dt_inicio_w;
				end if;

				SELECT * FROM CPOE_Calcula_horarios_enteral(
					nm_usuario_p, dt_referencia_w, ie_continuo_w, nr_ocorrencia_w, cd_intervalo_w, qt_tempo_calc_w, coalesce(obter_minutos_hora(qt_hora_fase_w),0)/60, qt_tempo_pausa_w, 'N', ie_duracao_w, dt_fim_w, 'S', nr_atendimento_p, cd_estabelecimento_p, cd_perfil_p) INTO STRICT nr_ocorrencia_w, ds_horarios_calc_w;

				if (ds_horarios_w <> ds_horarios_calc_w) then
					update cpoe_dieta
					   set ds_horarios = ds_horarios_calc_w
					 where nr_sequencia = nr_sequencia_p;
				end if;

			end if;
		 end if;
	end if;

exception when others then

	CALL gravar_log_cpoe(substr('CPOE_REPROC_HOR_DIETA_ENTERAL EXCEPTION -'
			|| ' - nr_sequencia_p: ' || nr_sequencia_p
			|| ' - nr_atendimento_p: ' || nr_atendimento_p
			|| ' - cd_estabelecimento_p: ' || cd_estabelecimento_p
			|| ' - cd_perfil_p: ' || cd_perfil_p
			|| ' - nm_usuario_p: ' || nm_usuario_p
			|| obter_desc_expressao(504115) || to_char(sqlerrm), 1, 2000),
		nr_atendimento_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_reproc_hor_dieta_enteral ( nr_sequencia_p cpoe_dieta.nr_sequencia%type, nr_atendimento_p atendimento_paciente.nr_atendimento%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_perfil_p perfil.cd_perfil%type, nm_usuario_p usuario.nm_usuario%type ) FROM PUBLIC;

