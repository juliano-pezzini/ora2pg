-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE validar_regra_poltrona_agecons (cd_pessoa_fisica_p text, dt_agenda_p timestamp, cd_classif_p text, nr_min_duracao_p bigint, ds_poltronas_p INOUT text, dt_inicial_p INOUT timestamp, dt_final_p INOUT timestamp, ie_possui_ciclo_p INOUT text) AS $body$
DECLARE



nr_seq_pend_agenda_w  	paciente_atendimento.nr_seq_pend_agenda%type;
nr_minuto_duracao_w		bigint;
nr_seq_local_w			agenda_quimio.nr_seq_local%type;
ie_validar_poltrona_w   agenda_classif.ie_validar_poltrona%type;
qt_tempo_agendamento_w   agenda_classif.qt_tempo_agendamento%type;
ds_poltronas_w			varchar(255);
ds_local_w				varchar(255);
nr_duracao_ciclo_w      varchar(255);
ie_status_w				w_agenda_quimio.ie_status%type;
nr_min_livre_w			bigint;

C01 CURSOR FOR
	/*Busca poltronas com horários livres no período da regra*/

	SELECT ds_local,
			sequencia
	From 	(SELECT  distinct(b.ds_local) ds_local,
			b.nr_Sequencia sequencia
	FROM    w_agenda_quimio w,
			qt_local b
	WHERE	w.dt_horario BETWEEN (dt_agenda_p+(nr_min_duracao_p/1440)) AND ((dt_agenda_p+(nr_min_duracao_p/1440))+(qt_tempo_agendamento_w/1440))
	AND		w.nm_usuario   =  obter_usuario_ativo
	AND		w.nr_seq_local = b.nr_Sequencia
	AND		w.ie_status = 'L'
	order   by 1) alias7 LIMIT 10;

C02 CURSOR FOR
	/*Busca status dos horários da poltrona conforme intervalo da regra*/

	SELECT  w.ie_status
	FROM    w_agenda_quimio w,
			qt_local b
	WHERE	w.dt_horario BETWEEN (dt_agenda_p+(nr_min_duracao_p/1440)) AND ((dt_agenda_p+(nr_min_duracao_p/1440))+(qt_tempo_agendamento_w/1440))
	AND		w.nm_usuario   =  obter_usuario_ativo
	AND 	b.nr_Sequencia = nr_seq_local_w
	AND		w.nr_seq_local = b.nr_Sequencia
	AND		w.ie_status = 'L';

BEGIN

	nr_minuto_duracao_w := Obter_param_Usuario(865, 3, obter_perfil_ativo, obter_usuario_ativo, obter_estabelecimento_ativo, nr_minuto_duracao_w);

	/*Buscando ciclo pendente de agendamento*/

	SELECT	max(b.nr_seq_pend_agenda),
			SUBSTR(max(qt_obter_dur_aplicacao_pend(b.ds_dia_ciclo, a.nr_seq_medicacao, a.cd_protocolo, b.nr_seq_atendimento, coalesce(b.dt_real, b.dt_prevista), b.nr_seq_pend_agenda, obter_usuario_ativo, b.cd_estabelecimento)), 1, 255)
	into STRICT    nr_seq_pend_agenda_w,
			nr_duracao_ciclo_w
	FROM	paciente_setor a,
			paciente_atendimento b
	WHERE	a.nr_seq_paciente 	= b.nr_seq_paciente
	AND		a.cd_pessoa_fisica = cd_pessoa_fisica_p
	AND		coalesce(b.dt_suspensao::text, '') = ''
	AND		coalesce(b.dt_cancelamento::text, '') = ''
	AND		TRUNC(coalesce(b.dt_real,b.dt_prevista)) = TRUNC(dt_agenda_p);

	SELECT coalesce(max(ie_validar_poltrona), 'N'),
			coalesce(max(qt_tempo_agendamento), 0)
	into STRICT ie_validar_poltrona_w,
		 qt_tempo_agendamento_w
	FROM AGENDA_CLASSIF
	WHERE ie_agenda IN ('C','A')
	AND ie_situacao = 'A'
	AND cd_classificacao = cd_classif_p;

	if (nr_seq_pend_agenda_w IS NOT NULL AND nr_seq_pend_agenda_w::text <> '') and (ie_validar_poltrona_w = 'S')then

	ie_possui_ciclo_p := 'S';

	CALL Qt_Gerar_Horario(nr_seq_pend_agenda_w,
					null,
					dt_agenda_p,
					obter_usuario_ativo,
					coalesce(nr_minuto_duracao_w, 15),
					cd_pessoa_fisica_p);

	nr_min_livre_w := 0;

	open C01;
	loop
	fetch C01 into
		ds_local_w,
		nr_seq_local_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		open C02;
		loop
		fetch C02 into
			ie_status_w;
		exit when(C02%notfound or nr_min_livre_w >= nr_duracao_ciclo_w);
			begin
			if (ie_status_w = 'L') then
				nr_min_livre_w := nr_min_livre_w + nr_minuto_duracao_w;
			else
				nr_min_livre_w := 0;
			end if;

			end;
		end loop;
		close C02;

		if (nr_min_livre_w >= nr_duracao_ciclo_w) then
			/*Grava as poltronas que têm horários disponíveis com a mesma duração do ciclo para a mensagem*/

			if (coalesce(ds_poltronas_w::text, '') = '') then
			ds_poltronas_w := ds_local_w;
			else
			ds_poltronas_w := ds_poltronas_w ||', '||ds_local_w;
			end if;
			nr_min_livre_w := 0;
		end if;

		end;
	end loop;
	close C01;


	else
	ie_possui_ciclo_p := 'N';
	end if;

ds_poltronas_p 	:= ds_poltronas_w;
dt_inicial_p 	:= (dt_agenda_p+(nr_min_duracao_p/1440));
dt_final_p 		:= ((dt_agenda_p+(nr_min_duracao_p/1440))+(qt_tempo_agendamento_w/1440));

END	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE validar_regra_poltrona_agecons (cd_pessoa_fisica_p text, dt_agenda_p timestamp, cd_classif_p text, nr_min_duracao_p bigint, ds_poltronas_p INOUT text, dt_inicial_p INOUT timestamp, dt_final_p INOUT timestamp, ie_possui_ciclo_p INOUT text) FROM PUBLIC;
