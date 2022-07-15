-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_agenda_pac_semana_per (nr_seq_agenda_p bigint, dt_agenda_p timestamp, ie_frequencia_p text, qt_frequencia_p bigint, ie_final_semana_p text, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE


cd_agenda_w			agenda_paciente.cd_agenda%type;
cd_pessoa_fisica_w		agenda_paciente.cd_pessoa_fisica%type;
dt_agenda_w			agenda_paciente.dt_agenda%type;
hr_inicio_w			agenda_paciente.hr_inicio%type;
nr_minuto_duracao_w		agenda_paciente.nr_minuto_duracao%type;
nm_usuario_w			varchar(15);
dt_atualizacao_w		agenda_paciente.dt_atualizacao%type;
cd_medico_w			agenda_paciente.cd_medico%type;
nm_pessoa_contato_w		agenda_paciente.nm_pessoa_contato%type;
cd_procedimento_w		agenda_paciente.cd_procedimento%type;
ds_observacao_w			agenda_paciente.ds_observacao%type;
cd_convenio_w			agenda_paciente.cd_convenio%type;
nr_cirurgia_w			agenda_paciente.nr_cirurgia%type;
ds_cirurgia_w			agenda_paciente.ds_cirurgia%type;
qt_idade_paciente_w		agenda_paciente.qt_idade_paciente%type;
cd_tipo_anestesia_w		agenda_paciente.cd_tipo_anestesia%type;
ie_origem_proced_w		agenda_paciente.ie_origem_proced%type;
ie_status_agenda_w		agenda_paciente.ie_status_agenda%type;
nm_instrumentador_w		agenda_paciente.nm_instrumentador%type;
nm_circulante_w			agenda_paciente.nm_circulante%type;
ie_ortese_protese_w		agenda_paciente.ie_ortese_protese%type;
ie_cdi_w				agenda_paciente.ie_cdi%type;
ie_uti_w				agenda_paciente.ie_uti%type;
ie_banco_sangue_w		agenda_paciente.ie_banco_sangue%type;
ie_serv_especial_w		agenda_paciente.ie_serv_especial%type;
cd_motivo_cancelamento_w		agenda_paciente.cd_motivo_cancelamento%type;
--nr_sequencia_w		agenda_paciente.nr_sequencia%type;
ds_senha_w			agenda_paciente.ds_senha%type;
cd_turno_w			agenda_paciente.cd_turno%type;
cd_anestesista_w		agenda_paciente.cd_anestesista%type;
cd_pediatra_w			agenda_paciente.cd_pediatra%type;
nm_paciente_w			agenda_paciente.nm_paciente%type;
ie_anestesia_w			agenda_paciente.ie_anestesia%type;
nr_atendimento_w			agenda_paciente.nr_atendimento%type;
ie_carater_cirurgia_w		agenda_paciente.ie_carater_cirurgia%type;
cd_usuario_convenio_w		agenda_paciente.cd_usuario_convenio%type;
nm_usuario_orig_w			agenda_paciente.nm_usuario_orig%type;
qt_idade_mes_w		agenda_paciente.qt_idade_mes%type;
cd_plano_w			agenda_paciente.cd_plano%type;
ie_leito_w			agenda_paciente.ie_leito%type;
nr_telefone_w		agenda_paciente.nr_telefone%type;
dt_agendamento_w		agenda_paciente.dt_agendamento%type;
ie_equipamento_w		agenda_paciente.ie_equipamento%type;
ie_autorizacao_w		agenda_paciente.ie_autorizacao%type;
vl_previsto_w			agenda_paciente.vl_previsto%type;
nr_seq_age_cons_w		agenda_paciente.nr_seq_age_cons%type;
cd_medico_exec_w		agenda_paciente.cd_medico_exec%type;
ie_video_w			agenda_paciente.ie_video%type;
nr_seq_classif_agenda_w		agenda_paciente.nr_seq_classif_agenda%type;
ie_uc_w				agenda_paciente.ie_uc%type;
cd_procedencia_w		agenda_paciente.cd_procedencia%type;
cd_categoria_w			agenda_paciente.cd_categoria%type;
cd_tipo_acomodacao_w	agenda_paciente.cd_tipo_acomodacao%type;
nr_doc_convenio_w		agenda_paciente.nr_doc_convenio%type;
dt_validade_carteira_w		agenda_paciente.dt_validade_carteira%type;
dt_confirmacao_w			agenda_paciente.dt_confirmacao%type;
nr_seq_proc_interno_w		agenda_paciente.nr_seq_proc_interno%type;
nr_seq_status_pac_w		agenda_paciente.nr_seq_status_pac%type;
nm_usuario_confirm_w		agenda_paciente.nm_usuario_confirm%type;
ie_lado_w			agenda_paciente.ie_lado%type;
ie_biopsia_w			agenda_paciente.ie_biopsia%type;
ie_congelacao_w			agenda_paciente.ie_congelacao%type;
ds_laboratorio_w		agenda_paciente.ds_laboratorio%type;
qt_min_padrao_w			agenda_paciente.qt_min_padrao%type;
cd_doenca_cid_w			agenda_paciente.cd_doenca_cid%type;
dt_nascimento_pac_w		agenda_paciente.dt_nascimento_pac%type;
nr_seq_sala_w			agenda_paciente.nr_seq_sala%type;
nm_medico_externo_w		agenda_paciente.nm_medico_externo%type;
ie_tipo_atendimento_w		agenda_paciente.ie_tipo_atendimento%type;
ie_consulta_anestesica_w		agenda_paciente.ie_consulta_anestesica%type;
ie_pre_internacao_w		agenda_paciente.ie_pre_internacao%type;
ie_reserva_leito_w		agenda_paciente.ie_reserva_leito%type;
ie_tipo_anestesia_w		agenda_paciente.ie_tipo_anestesia%type;
dt_chegada_w			agenda_paciente.dt_chegada%type;
cd_medico_req_w			agenda_paciente.cd_medico_req%type;
nr_seq_pq_proc_w		agenda_paciente.nr_seq_pq_proc%type;
qt_diaria_prev_w		agenda_paciente.qt_diaria_prev%type;
dt_chegada_fim_w		agenda_paciente.dt_chegada_fim%type;
ie_arco_c_w			agenda_paciente.ie_arco_c%type;
nr_seq_indicacao_w		agenda_paciente.nr_seq_indicacao%type;
cd_pessoa_indicacao_w		agenda_paciente.cd_pessoa_indicacao%type;
dt_termino_w			timestamp;
dt_atual_w			timestamp;
dt_dia_semana_w			smallint;
ie_feriado_w			varchar(1);
nr_seq_esp_w			agenda_horario_esp.nr_sequencia%type;
ie_hor_adic_w			agenda_horario_esp.ie_horario_adicional%type;
ie_valido_w			varchar(1);
qt_horario_w			bigint;
qt_horario_livre_w			bigint;
nr_sequencia_w			bigint;
ds_erro_w			varchar(1000);
ds_erro_2_w			varchar(1000);
ds_erro_3_w			varchar(1000);
ds_erro_4_w			varchar(1000);
qt_frequencia_w			integer;
ie_final_semana_w			varchar(1);
nr_seq_livre_w			bigint;
qt_bloqueio_periodo_w	bigint;
ie_se_gera_hor_bloq_w	varchar(1);
ds_obs_erro_w		varchar(255);
ie_bloqueado_w		varchar(1);


nr_seq_proced_w			bigint;
cd_procedimento_adic_w		bigint;
ie_origem_proced_adic_w		bigint;
nr_seq_proc_interno_adic_w		bigint;
ie_lado_adic_w			varchar(1);
cd_medico_adic_w		varchar(10);
Ie_gerar_proced_adic_w		varchar(1);
ie_consistir_sobrep_w		varchar(1);
qt_min_tot_agend_w			bigint := 0;
qt_min_dur_tempo_proced_w	bigint := 0;
qt_tot_min_dur_proc_adic_w	bigint := 0;
qt_min_dur_tempo_proc_adic_w	bigint := 0;
cd_procedimento_w_regra		bigint;
ie_origem_proced_regra_w	bigint;
nr_seq_proc_interno_regra_w	bigint;
ie_lado_adic_regra_w		varchar(1);
cd_medico_adic_regra_w		varchar(10);
ie_se_hor_sobreposto_w	varchar(1);

c01 CURSOR FOR
SELECT	cd_procedimento,
		ie_origem_proced,
		nr_seq_proc_interno,
		ie_lado,
		cd_medico
FROM	agenda_paciente_proc
WHERE	nr_sequencia = nr_seq_agenda_p
ORDER BY nr_seq_agenda;


c02 CURSOR FOR
SELECT	cd_procedimento,
		ie_origem_proced,
		nr_seq_proc_interno,
		ie_lado,
		cd_medico
from	agenda_paciente_proc
where	nr_sequencia = nr_seq_agenda_p
order by
		nr_seq_agenda;


BEGIN
ds_erro_w 	:= '';
ds_erro_3_w := '';
ds_erro_4_w := wheb_mensagem_pck.get_texto(794117);				

IF (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') AND (dt_agenda_p IS NOT NULL AND dt_agenda_p::text <> '') AND (ie_frequencia_p IS NOT NULL AND ie_frequencia_p::text <> '') AND (ie_final_semana_p IS NOT NULL AND ie_final_semana_p::text <> '') AND (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') THEN
	/* obter dados agenda */

	SELECT	cd_agenda,
		cd_pessoa_fisica,
		dt_agenda,
		hr_inicio,
		nr_minuto_duracao,
		--nm_usuario,
		dt_atualizacao,
		cd_medico,
		nm_pessoa_contato,
		cd_procedimento,
		ds_observacao,
		cd_convenio,
		nr_cirurgia,
		ds_cirurgia,
		qt_idade_paciente,
		cd_tipo_anestesia,
		ie_origem_proced,
		--ie_status_agenda,
		nm_instrumentador,
		nm_circulante,
		ie_ortese_protese,
		ie_cdi,
		ie_uti,
		ie_banco_sangue,
		ie_serv_especial,
		cd_motivo_cancelamento,
		--nr_sequencia,
		ds_senha,
		cd_turno,
		cd_anestesista,
		cd_pediatra,
		nm_paciente,
		ie_anestesia,
		nr_atendimento,
		ie_carater_cirurgia,
		cd_usuario_convenio,
		--nm_usuario_orig,
		qt_idade_mes,
		cd_plano,
		ie_leito,
		nr_telefone,
		dt_agendamento,
		ie_equipamento,
		ie_autorizacao,
		vl_previsto,
		nr_seq_age_cons,
		cd_medico_exec,
		ie_video,
		nr_seq_classif_agenda,
		ie_uc,
		cd_procedencia,
		cd_categoria,
		cd_tipo_acomodacao,
		nr_doc_convenio,
		dt_validade_carteira,
		dt_confirmacao,
		nr_seq_proc_interno,
		nr_seq_status_pac,
		--nm_usuario_confirm,
		ie_lado,
		ie_biopsia,
		ie_congelacao,
		ds_laboratorio,
		qt_min_padrao,
		cd_doenca_cid,
		dt_nascimento_pac,
		nr_seq_sala,
		nm_medico_externo,
		ie_tipo_atendimento,
		ie_consulta_anestesica,
		ie_pre_internacao,
		ie_reserva_leito,
		ie_tipo_anestesia,
		dt_chegada,
		cd_medico_req,
		nr_seq_pq_proc,
		qt_diaria_prev,
		dt_chegada_fim,
		ie_arco_c,
		nr_seq_indicacao,
		cd_pessoa_indicacao
	INTO STRICT	cd_agenda_w,
		cd_pessoa_fisica_w,
		dt_agenda_w,
		hr_inicio_w,
		nr_minuto_duracao_w,
		--nm_usuario_w,
		dt_atualizacao_w,
		cd_medico_w,
		nm_pessoa_contato_w,
		cd_procedimento_w,
		ds_observacao_w,
		cd_convenio_w,
		nr_cirurgia_w,
		ds_cirurgia_w,
		qt_idade_paciente_w,
		cd_tipo_anestesia_w,
		ie_origem_proced_w,
		--ie_status_agenda_w,
		nm_instrumentador_w,
		nm_circulante_w,
		ie_ortese_protese_w,
		ie_cdi_w,
		ie_uti_w,
		ie_banco_sangue_w,
		ie_serv_especial_w,
		cd_motivo_cancelamento_w,
		--nr_sequencia_w,
		ds_senha_w,
		cd_turno_w,
		cd_anestesista_w,
		cd_pediatra_w,
		nm_paciente_w,
		ie_anestesia_w,
		nr_atendimento_w,
		ie_carater_cirurgia_w,
		cd_usuario_convenio_w,
		--nm_usuario_orig_w,
		qt_idade_mes_w,
		cd_plano_w,
		ie_leito_w,
		nr_telefone_w,
		dt_agendamento_w,
		ie_equipamento_w,
		ie_autorizacao_w,
		vl_previsto_w,
		nr_seq_age_cons_w,
		cd_medico_exec_w,
		ie_video_w,
		nr_seq_classif_agenda_w,
		ie_uc_w,
		cd_procedencia_w,
		cd_categoria_w,
		cd_tipo_acomodacao_w,
		nr_doc_convenio_w,
		dt_validade_carteira_w,
		dt_confirmacao_w,
		nr_seq_proc_interno_w,
		nr_seq_status_pac_w,
		--nm_usuario_confirm_w,
		ie_lado_w,
		ie_biopsia_w,
		ie_congelacao_w,
		ds_laboratorio_w,
		qt_min_padrao_w,
		cd_doenca_cid_w,
		dt_nascimento_pac_w,
		nr_seq_sala_w,
		nm_medico_externo_w,
		ie_tipo_atendimento_w,
		ie_consulta_anestesica_w,
		ie_pre_internacao_w,
		ie_reserva_leito_w,
		ie_tipo_anestesia_w,
		dt_chegada_w,
		cd_medico_req_w,
		nr_seq_pq_proc_w,
		qt_diaria_prev_w,
		dt_chegada_fim_w,
		ie_arco_c_w,
		nr_seq_indicacao_w,
		cd_pessoa_indicacao_w
	FROM	agenda_paciente
	WHERE	nr_sequencia = nr_seq_agenda_p;

	SELECT	coalesce(MAX(obter_valor_param_usuario(820, 159, obter_perfil_ativo, nm_usuario_p, obter_estab_agenda(cd_agenda_w))), 'S')
	INTO STRICT	Ie_gerar_proced_adic_w
	;
	
	select 	coalesce(max(ie_consiste_duracao),'I')
	into STRICT	ie_consistir_sobrep_w	
	from 	parametro_agenda
	where 	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

	/* obter frequencia */

	IF (ie_frequencia_p = 'S') THEN
		qt_frequencia_w := 7;

	ELSIF (ie_frequencia_p = 'D') THEN
		qt_frequencia_w := 1;

	ELSIF (ie_frequencia_p = 'O') THEN
		qt_frequencia_w := coalesce(qt_frequencia_p,0);
	END IF;

	/* validar frequencia */

	IF (qt_frequencia_w <= 0) THEN
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(251139);
	END IF;

	/* obter datas */

	dt_termino_w := TO_DATE(TO_CHAR(dt_agenda_p,'dd/mm/yyyy') || ' ' || TO_CHAR(hr_inicio_w,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');
	dt_atual_w := hr_inicio_w + qt_frequencia_w;

	/* validar data */

	IF (dt_agenda_p < dt_agenda_w) THEN
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(251140);
	END IF;

	IF (ie_frequencia_p = 'S') AND (dt_agenda_p < dt_atual_w) THEN
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(262642);
	END IF;

	/* obter dias semana */

	WHILE(dt_atual_w <= dt_termino_w) LOOP
		BEGIN
		/* obter dia semana */

		SELECT	obter_cod_dia_semana(dt_atual_w)
		INTO STRICT	dt_dia_semana_w
		;

		/* obter se feriado */

		SELECT	CASE WHEN COUNT(*)=0 THEN 'N'  ELSE 'S' END
		INTO STRICT	ie_feriado_w
		FROM 	feriado a,
			agenda b
		WHERE 	a.cd_estabelecimento = obter_estab_agenda(cd_agenda_w)
		AND	a.dt_feriado = TRUNC(dt_atual_w)
		AND 	b.cd_agenda = cd_agenda_w;

		/* obter se horario especial */

		SELECT	coalesce(MAX(nr_sequencia),0),
			coalesce(MAX(ie_horario_adicional),'N')
		INTO STRICT	nr_seq_esp_w,
			ie_hor_adic_w
		FROM	agenda_horario_esp
		WHERE	cd_agenda = cd_agenda_w
		and	((ie_dia_semana = dt_dia_semana_w) or ((ie_dia_semana = 9) and (dt_dia_Semana_w not in (1,7))) or (coalesce(ie_dia_semana::text, '') = ''))
		and dt_agenda_w between pkg_date_utils.start_of(dt_agenda,'DAY') and pkg_date_utils.end_of(coalesce(dt_agenda_fim,dt_agenda),'DAY')
		AND	hr_inicio_w BETWEEN  hr_inicial AND hr_final;

		IF (nr_seq_esp_w > 0) AND (ie_hor_adic_w = 'N') THEN

		   ds_erro_2_w := WHEB_MENSAGEM_PCK.get_texto(277592,null);

		END IF;


		/* obter se final semana */

		IF (dt_dia_semana_w IN (7,1)) THEN
			ie_final_semana_w := 'S';
		ELSE
			ie_final_semana_w := 'N';
		END IF;

		/* validar horario x cadastro */

		SELECT	CASE WHEN COUNT(*)=0 THEN 'N'  ELSE 'S' END
		INTO STRICT	ie_valido_w
		FROM	agenda_horario
		WHERE	cd_agenda = cd_agenda_w
		AND	((dt_dia_semana = dt_dia_semana_w) OR ((dt_dia_semana = 9) AND (dt_dia_semana_w NOT IN (7,1))))
		AND	((nr_seq_esp_w = 0) OR (ie_hor_adic_w = 'S'))
		AND	((coalesce(dt_final_vigencia::text, '') = '') OR (dt_final_vigencia >= TRUNC(dt_atual_w)))
		AND	((coalesce(dt_inicio_vigencia::text, '') = '') OR (dt_inicio_vigencia <= TRUNC(dt_atual_w)))
		AND 	hr_inicial < hr_final
		AND	coalesce(nr_minuto_intervalo,0) > 0
		AND	ie_feriado_w <> 'S';

		/* validar horario gerado */

		SELECT	COUNT(*)
		INTO STRICT	qt_horario_w
		FROM	agenda_paciente
		WHERE	cd_agenda = cd_agenda_w
		AND	hr_inicio = dt_atual_w;

		/* validar horario livre */

		SELECT	COUNT(*)
		INTO STRICT	qt_horario_livre_w
		FROM	agenda_paciente
		WHERE	cd_agenda = cd_agenda_w
		AND		hr_inicio = dt_atual_w
		AND		ie_status_agenda = 'L'
		AND		obter_se_feriado(obter_estab_agenda(cd_agenda_w), dt_atual_w) = 0;

		/*INICIO - validar se existe bloqueio cadastrado para a agenda*/

			SELECT * FROM consistir_bloq_Agenda_obs(cd_agenda_w, dt_atual_w, dt_dia_semana_w, ie_bloqueado_w, ds_obs_erro_w) INTO STRICT ie_bloqueado_w, ds_obs_erro_w;

			IF (ie_bloqueado_w = 'S') THEN
				ie_valido_w := 'N';
			END IF;
			/* Alterado pela ortina acima em 15/11/2013 - Elton

			select	nvl(count(*), 0)
			into	qt_bloqueio_periodo_w
			from	agenda_bloqueio
			where	cd_agenda	= cd_agenda_w
			and		trunc(dt_atual_w)	between	dt_inicial and dt_final
			and		to_date(dt_atual_w,'dd/mm/yyyy hh24:mi:ss') >=
					to_date(to_char(dt_inicial, 'dd/mm/yyyy') ||' '|| to_char(nvl(hr_inicio_bloqueio, to_date('30/12/1899 00:00:00', 'dd/mm/yyyy hh24:mi:ss')),'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss')
			and		to_date(dt_atual_w,'dd/mm/yyyy hh24:mi:ss') <=
					to_date(to_char(dt_final, 'dd/mm/yyyy') ||' '|| to_char(nvl(hr_final_bloqueio, to_date('30/12/1899 23:59:59', 'dd/mm/yyyy hh24:mi:ss')),'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss');

			if	(qt_bloqueio_periodo_w > 0) then
				ie_valido_w	:= 'N';
			end if;

			*/

		/*FIM - validar se existe bloqueio cadastrado para a agenda*/


		
		
		/*Consistir a regra 'Tempo Proced' ao efetuar a copia/transferencia*/

		if (cd_agenda_w IS NOT NULL AND cd_agenda_w::text <> '')then
			begin		
			select	obter_tempo_duracao_proced(	cd_agenda_w,
												cd_medico_exec_w,
												cd_procedimento_w,
												ie_origem_proced_w,
												cd_pessoa_fisica_w,
												nr_seq_proc_interno_w,
												ie_lado_w,
												cd_convenio_w,
												cd_categoria_w,
												cd_plano_w,
												nr_seq_agenda_p,
												null)
			into STRICT	qt_min_dur_tempo_proced_w
			;
			exception
			when others then
				qt_min_dur_tempo_proced_w := 0;	
			end;	
		end if;	
		
		/*Consistir a regra 'Tempo Proced' ao efetuar a copia/transferencia para os procedimentos adicionais*/

		open c02;
		loop
		fetch c02 into	cd_procedimento_w_regra,
						ie_origem_proced_regra_w,
						nr_seq_proc_interno_regra_w,
						ie_lado_adic_regra_w,
						cd_medico_adic_regra_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin						
			if (cd_agenda_w IS NOT NULL AND cd_agenda_w::text <> '')then
				begin		
				select	obter_tempo_duracao_proced(	cd_agenda_w,
													coalesce(cd_medico_adic_regra_w, cd_medico_exec_w),
													cd_procedimento_w_regra,
													ie_origem_proced_regra_w,
													cd_pessoa_fisica_w,
													nr_seq_proc_interno_regra_w,
													ie_lado_adic_regra_w,
													cd_convenio_w,
													cd_categoria_w,
													cd_plano_w,
													nr_seq_agenda_p,
													null)
				into STRICT	qt_min_dur_tempo_proc_adic_w
				;
				exception
				when others then
					qt_min_dur_tempo_proc_adic_w := 0;	
				end;	
				
			qt_tot_min_dur_proc_adic_w	:= qt_tot_min_dur_proc_adic_w + qt_min_dur_tempo_proc_adic_w;
			end if;			
			end;
		end loop;
		close c02;	
		
		qt_min_tot_agend_w	:= qt_min_dur_tempo_proced_w + qt_tot_min_dur_proc_adic_w;
		
		/*Consistir sobreposicao de horarios caso o proximo agendamento nao estiver livre*/
		
		if (ie_consistir_sobrep_w = 'I') then
			
			
			--ie_se_hor_sobreposto_w := obter_se_sobreposicao_horario(cd_agenda_w, dt_atual_w, qt_min_tot_agend_w);
			ie_se_hor_sobreposto_w := obter_se_agenda_sobreposta(cd_agenda_w, dt_atual_w, dt_atual_w, qt_min_tot_agend_w, nr_seq_agenda_p);		
			
			if (ie_se_hor_sobreposto_w = 'S')then
				ie_valido_w	:= 'N';				
				ds_erro_3_w := ds_erro_3_w || ' ' || to_char(dt_atual_w,'dd/mm/yyyy');
			end if;		
		end if;
		
		
		IF	(ie_valido_w = 'S' AND qt_horario_w = 0) OR
			(ie_valido_w = 'S' AND qt_horario_livre_w > 0) THEN

			IF (ie_final_semana_p = 'S') OR (ie_final_semana_w = 'N') THEN

				SELECT	MAX(nr_sequencia)
				INTO STRICT	nr_seq_livre_w
				FROM	agenda_paciente
				WHERE	cd_agenda = cd_agenda_w
				AND	hr_inicio = dt_atual_w
				AND	ie_status_agenda = 'L'
				AND	obter_se_feriado(obter_estab_agenda(cd_agenda_w), dt_atual_w) = 0;

				IF (coalesce(nr_seq_livre_w::text, '') = '') THEN

					/* obter sequencia */

					SELECT	nextval('agenda_paciente_seq')
					INTO STRICT	nr_sequencia_w
					;

					/* gerar agenda */

					INSERT INTO agenda_paciente(
									cd_agenda,
									cd_pessoa_fisica,
									dt_agenda,
									hr_inicio,
									nr_minuto_duracao,
									nm_usuario,
									dt_atualizacao,
									cd_medico,
									nm_pessoa_contato,
									cd_procedimento,
									ds_observacao,
									cd_convenio,
									nr_cirurgia,
									ds_cirurgia,
									qt_idade_paciente,
									cd_tipo_anestesia,
									ie_origem_proced,
									ie_status_agenda,
									nm_instrumentador,
									nm_circulante,
									ie_ortese_protese,
									ie_cdi,
									ie_uti,
									ie_banco_sangue,
									ie_serv_especial,
									cd_motivo_cancelamento,
									nr_sequencia,
									ds_senha,
									cd_turno,
									cd_anestesista,
									cd_pediatra,
									nm_paciente,
									ie_anestesia,
									nr_atendimento,
									ie_carater_cirurgia,
									cd_usuario_convenio,
									nm_usuario_orig,
									qt_idade_mes,
									cd_plano,
									ie_leito,
									nr_telefone,
									dt_agendamento,
									ie_equipamento,
									ie_autorizacao,
									vl_previsto,
									nr_seq_age_cons,
									cd_medico_exec,
									ie_video,
									nr_seq_classif_agenda,
									ie_uc,
									cd_procedencia,
									cd_categoria,
									cd_tipo_acomodacao,
									nr_doc_convenio,
									dt_validade_carteira,
									dt_confirmacao,
									nr_seq_proc_interno,
									nr_seq_status_pac,
									nm_usuario_confirm,
									ie_lado,
									ie_biopsia,
									ie_congelacao,
									ds_laboratorio,
									qt_min_padrao,
									cd_doenca_cid,
									dt_nascimento_pac,
									nr_seq_sala,
									nm_medico_externo,
									ie_tipo_atendimento,
									ie_consulta_anestesica,
									ie_pre_internacao,
									ie_reserva_leito,
									ie_tipo_anestesia,
									dt_chegada,
									cd_medico_req,
									nr_seq_pq_proc,
									qt_diaria_prev,
									dt_chegada_fim,
									ie_arco_c,
									nr_seq_indicacao,
									cd_pessoa_indicacao
									)
								VALUES (
									cd_agenda_w,
									cd_pessoa_fisica_w,
									--dt_agenda_w,
									TRUNC(dt_atual_w),
									--hr_inicio_w,
									dt_atual_w,
									nr_minuto_duracao_w,
									--nm_usuario_w,
									nm_usuario_p,
									dt_atualizacao_w,
									cd_medico_w,
									nm_pessoa_contato_w,
									cd_procedimento_w,
									ds_observacao_w,
									cd_convenio_w,
									nr_cirurgia_w,
									ds_cirurgia_w,
									qt_idade_paciente_w,
									cd_tipo_anestesia_w,
									ie_origem_proced_w,
									--ie_status_agenda_w,
									'N',
									nm_instrumentador_w,
									nm_circulante_w,
									ie_ortese_protese_w,
									ie_cdi_w,
									ie_uti_w,
									ie_banco_sangue_w,
									ie_serv_especial_w,
									cd_motivo_cancelamento_w,
									nr_sequencia_w,
									ds_senha_w,
									cd_turno_w,
									cd_anestesista_w,
									cd_pediatra_w,
									nm_paciente_w,
									ie_anestesia_w,
									nr_atendimento_w,
									ie_carater_cirurgia_w,
									cd_usuario_convenio_w,
									--nm_usuario_orig_w,
									nm_usuario_p,
									qt_idade_mes_w,
									cd_plano_w,
									ie_leito_w,
									nr_telefone_w,
									dt_agendamento_w,
									ie_equipamento_w,
									ie_autorizacao_w,
									vl_previsto_w,
									nr_seq_age_cons_w,
									cd_medico_exec_w,
									ie_video_w,
									nr_seq_classif_agenda_w,
									ie_uc_w,
									cd_procedencia_w,
									cd_categoria_w,
									cd_tipo_acomodacao_w,
									nr_doc_convenio_w,
									dt_validade_carteira_w,
									dt_confirmacao_w,
									nr_seq_proc_interno_w,
									nr_seq_status_pac_w,
									--nm_usuario_confirm_w,
									nm_usuario_p,
									ie_lado_w,
									ie_biopsia_w,
									ie_congelacao_w,
									ds_laboratorio_w,
									qt_min_padrao_w,
									cd_doenca_cid_w,
									dt_nascimento_pac_w,
									nr_seq_sala_w,
									nm_medico_externo_w,
									ie_tipo_atendimento_w,
									ie_consulta_anestesica_w,
									ie_pre_internacao_w,
									ie_reserva_leito_w,
									ie_tipo_anestesia_w,
									dt_chegada_w,
									cd_medico_req_w,
									nr_seq_pq_proc_w,
									qt_diaria_prev_w,
									dt_chegada_fim_w,
									ie_arco_c_w,
									nr_seq_indicacao_w,
									cd_pessoa_indicacao_w
									);
					IF (Ie_gerar_proced_adic_w	= 'S') THEN

						OPEN c01;
						LOOP
						FETCH c01 INTO	cd_procedimento_adic_w,
									ie_origem_proced_adic_w,
									nr_seq_proc_interno_adic_w,
									ie_lado_adic_w,
									cd_medico_adic_w;
						EXIT WHEN NOT FOUND; /* apply on c01 */
							BEGIN
							/* obter sequencia */

							SELECT	coalesce(MAX(nr_seq_agenda),0)+1
							INTO STRICT	nr_seq_proced_w
							FROM	agenda_paciente_proc
							WHERE	nr_sequencia = nr_sequencia_w;

							INSERT INTO agenda_paciente_proc(
												nr_sequencia,
												nr_seq_agenda,
												cd_procedimento,
												ie_origem_proced,
												nr_seq_proc_interno,
												dt_atualizacao,
												nm_usuario,
												ie_lado,
												cd_medico
												)
											VALUES (
												nr_sequencia_w,
												nr_seq_proced_w,
												cd_procedimento_adic_w,
												ie_origem_proced_adic_w,
												nr_seq_proc_interno_adic_w,
												clock_timestamp(),
												nm_usuario_p,
												ie_lado_adic_w,
												cd_medico_adic_w
												);
							END;
						END LOOP;
						CLOSE c01;
					END IF;
				ELSIF (nr_seq_livre_w IS NOT NULL AND nr_seq_livre_w::text <> '') THEN

					/* gerar agenda */

					UPDATE	agenda_paciente
					SET	cd_pessoa_fisica               =                cd_pessoa_fisica_w,
						dt_agenda                      =                TRUNC(dt_atual_w),
						hr_inicio                      =                dt_atual_w,
						nr_minuto_duracao              =                nr_minuto_duracao_w,
						nm_usuario                     =                nm_usuario_p,
						dt_atualizacao                 =                dt_atualizacao_w,
						cd_medico                      =                cd_medico_w,
						nm_pessoa_contato              =                nm_pessoa_contato_w,
						cd_procedimento                =                cd_procedimento_w,
						ds_observacao                  =                ds_observacao_w,
						cd_convenio                    =                cd_convenio_w,
						nr_cirurgia                    =                nr_cirurgia_w,
						ds_cirurgia                    =                ds_cirurgia_w,
						qt_idade_paciente              =                qt_idade_paciente_w,
						cd_tipo_anestesia              =                cd_tipo_anestesia_w,
						ie_origem_proced               =                ie_origem_proced_w,
						ie_status_agenda               =                'N',
						nm_instrumentador              =                nm_instrumentador_w,
						nm_circulante                  =                nm_circulante_w,
						ie_ortese_protese              =                ie_ortese_protese_w,
						ie_cdi                         =                ie_cdi_w,
						ie_uti                         =                ie_uti_w,
						ie_banco_sangue                =                ie_banco_sangue_w,
						ie_serv_especial               =                ie_serv_especial_w,
						cd_motivo_cancelamento         =                cd_motivo_cancelamento_w,
						ds_senha                       =                ds_senha_w,
						cd_turno                       =                cd_turno_w,
						cd_anestesista                 =                cd_anestesista_w,
						cd_pediatra                    =                cd_pediatra_w,
						nm_paciente                    =                nm_paciente_w,
						ie_anestesia                   =                ie_anestesia_w,
						nr_atendimento                 =                nr_atendimento_w,
						ie_carater_cirurgia            =                ie_carater_cirurgia_w,
						cd_usuario_convenio            =                cd_usuario_convenio_w,
						nm_usuario_orig                =                nm_usuario_p,
						qt_idade_mes                   =                qt_idade_mes_w,
						cd_plano                       =                cd_plano_w,
						ie_leito                       =                ie_leito_w,
						nr_telefone                    =                nr_telefone_w,
						dt_agendamento                 =                dt_agendamento_w,
						ie_equipamento                 =                ie_equipamento_w,
						ie_autorizacao                 =                ie_autorizacao_w,
						vl_previsto                    =                vl_previsto_w,
						nr_seq_age_cons                =                nr_seq_age_cons_w,
						cd_medico_exec                 =                cd_medico_exec_w,
						ie_video                       =                ie_video_w,
						nr_seq_classif_agenda          =                nr_seq_classif_agenda_w,
						ie_uc                          =                ie_uc_w,
						cd_procedencia                 =                cd_procedencia_w,
						cd_categoria                   =                cd_categoria_w,
						cd_tipo_acomodacao             =                cd_tipo_acomodacao_w,
						nr_doc_convenio                =                nr_doc_convenio_w,
						dt_validade_carteira           =                dt_validade_carteira_w,
						dt_confirmacao                 =                dt_confirmacao_w,
						nr_seq_proc_interno            =                nr_seq_proc_interno_w,
						nr_seq_status_pac              =                nr_seq_status_pac_w,
						nm_usuario_confirm             =                nm_usuario_p,
						ie_lado                        =                ie_lado_w,
						ie_biopsia                     =                ie_biopsia_w,
						ie_congelacao                  =                ie_congelacao_w,
						ds_laboratorio                 =                ds_laboratorio_w,
						qt_min_padrao                  =                qt_min_padrao_w,
						cd_doenca_cid                  =                cd_doenca_cid_w,
						dt_nascimento_pac              =                dt_nascimento_pac_w,
						nr_seq_sala                    =                nr_seq_sala_w,
						nm_medico_externo              =                nm_medico_externo_w,
						ie_tipo_atendimento            =                ie_tipo_atendimento_w,
						ie_consulta_anestesica         =                ie_consulta_anestesica_w,
						ie_pre_internacao              =                ie_pre_internacao_w,
						ie_reserva_leito               =                ie_reserva_leito_w,
						ie_tipo_anestesia              =                ie_tipo_anestesia_w,
						dt_chegada                     =                dt_chegada_w,
						cd_medico_req                  =                cd_medico_req_w,
						nr_seq_pq_proc                 =                nr_seq_pq_proc_w,
						qt_diaria_prev                 =                qt_diaria_prev_w,
						dt_chegada_fim                 =                dt_chegada_fim_w,
						ie_arco_c                      =                ie_arco_c_w,
						nr_seq_indicacao               =                nr_seq_indicacao_w,
						cd_pessoa_indicacao            =                cd_pessoa_indicacao_w
					WHERE	nr_sequencia 		       = 		nr_seq_livre_w;

					IF (Ie_gerar_proced_adic_w	= 'S') THEN

						OPEN c01;
						LOOP
						FETCH c01 INTO	cd_procedimento_adic_w,
									ie_origem_proced_adic_w,
									nr_seq_proc_interno_adic_w,
									ie_lado_adic_w,
									cd_medico_adic_w;
						EXIT WHEN NOT FOUND; /* apply on c01 */
							BEGIN
							/* obter sequencia */

							SELECT	coalesce(MAX(nr_seq_agenda),0)+1
							INTO STRICT	nr_seq_proced_w
							FROM	agenda_paciente_proc
							WHERE	nr_sequencia = nr_seq_livre_w;

							INSERT INTO agenda_paciente_proc(
												nr_sequencia,
												nr_seq_agenda,
												cd_procedimento,
												ie_origem_proced,
												nr_seq_proc_interno,
												dt_atualizacao,
												nm_usuario,
												ie_lado,
												cd_medico
												)
											VALUES (
												nr_seq_livre_w,
												nr_seq_proced_w,
												cd_procedimento_adic_w,
												ie_origem_proced_adic_w,
												nr_seq_proc_interno_adic_w,
												clock_timestamp(),
												nm_usuario_p,
												ie_lado_adic_w,
												cd_medico_adic_w
												);
							END;
						END LOOP;
						CLOSE c01;
					END IF;

				END IF;

			END IF;
		ELSE
			IF (ie_final_semana_p = 'S') OR (ie_final_semana_w = 'N') THEN
				ds_erro_w := ds_erro_w || TO_CHAR(dt_atual_w,'dd/mm/yyyy hh24:mi:ss') || ', ';
			END IF;
		END IF;
		dt_atual_w := dt_atual_w + qt_frequencia_w;
		END;
	END LOOP;
END IF;

IF (coalesce(LENGTH(ds_erro_w),0) > 0) THEN
	ds_erro_p := SUBSTR(WHEB_MENSAGEM_PCK.get_texto(277593,'DS_ERRO_W='||SUBSTR(ds_erro_w,1,LENGTH(ds_erro_w)-2)),1,255);
END IF;

IF (coalesce(LENGTH(ds_erro_2_w),0) > 0) THEN

	ds_erro_p := SUBSTR(ds_erro_2_w,1,255);
END IF;

IF (coalesce(LENGTH(ds_erro_3_w),0) > 0) THEN

	ds_erro_p := SUBSTR(ds_erro_4_w || ds_erro_3_w,1,255);
END IF;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_agenda_pac_semana_per (nr_seq_agenda_p bigint, dt_agenda_p timestamp, ie_frequencia_p text, qt_frequencia_p bigint, ie_final_semana_p text, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;

