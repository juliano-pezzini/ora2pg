-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_agenda_paciente ( cd_agenda_p agenda_paciente.cd_agenda%type, dt_agenda_p agenda_paciente.dt_agenda%type, nr_seq_lista_p agenda_lista_espera.nr_sequencia%type, nr_seq_turno_p agenda_turno.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type ) AS $body$
DECLARE


cd_pessoa_fisica_w		agenda_paciente.cd_pessoa_fisica%type;
cd_medico_w				agenda_paciente.cd_medico%type;
nr_seq_parecer_w		agenda_lista_espera.nr_seq_parece%type;
ds_observacao_w			agenda_paciente.ds_observacao%type;
nr_sequencia_w			agenda_paciente.nr_sequencia%type;

  membro RECORD;

BEGIN

	select	cd_pessoa_fisica,
			cd_medico_exec,
			nr_seq_parece,
			ds_observacao
	into STRICT	cd_pessoa_fisica_w,
			cd_medico_w,
			nr_seq_parecer_w,
			ds_observacao_w
	from	agenda_lista_espera
	where	nr_sequencia = nr_seq_lista_p;

	select 	nextval('agenda_paciente_seq')
	into STRICT 	nr_sequencia_w
	;

	-- Insert the schedule for this patient
	begin
	insert into	agenda_paciente(
				nr_sequencia,
				cd_agenda,
				dt_agenda,
				hr_inicio,
				nr_minuto_duracao,
				cd_pessoa_fisica,
				cd_medico,
				nr_atendimento,
				nr_seq_lista,
				ie_equipamento,
				ie_status_agenda,
				ds_observacao,
				nm_usuario,
				dt_atualizacao
	) values (
				nr_sequencia_w,
				cd_agenda_p,
				dt_agenda_p,
				dt_agenda_p, -- We don't need HR_INICIO, so we just use the same schedule date
				0,
				cd_pessoa_fisica_w,
				cd_medico_w,
				obter_atend_parecer_medico(nr_seq_parecer_w),
				nr_seq_lista_p,
				'N',
				'A',
				ds_observacao_w,
				nm_usuario_p,
				clock_timestamp()
	);
	exception
	when unique_violation then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(997709);
	end;

	-- Change the wait list status
	update	agenda_lista_espera
	set		ie_status_espera = 'E'
	where	nr_sequencia = nr_seq_lista_p;

	-- Add the participants not already added
	for membro in (
		select	a.*
		from	cl_equipe_board a
		where	nr_seq_turno = nr_seq_turno_p
				and not exists (
					select	nr_sequencia
					from	cb_participante_board
					where	nr_seq_agenda = cd_agenda_p
							and cd_pessoa_fisica = a.cd_pessoa_fisica
				)
	) loop

		insert into cb_participante_board(
			nr_sequencia,
			nr_seq_agenda,
			cd_pessoa_fisica,
			ie_faltou,
			dt_atualizacao,
			nm_usuario
		) values (
			nextval('cb_participante_board_seq'),
			nr_sequencia_w,
			membro.cd_pessoa_fisica,
			'N',
			clock_timestamp(),
			nm_usuario_p
		);

	end loop membro;

	-- Update the participants with no NR_SEQ_AGENDA attached
	update	cb_participante_board
	set		nr_seq_agenda = nr_sequencia_w
	where	nr_seq_parecer = nr_seq_parecer_w
			and coalesce(nr_seq_agenda::text, '') = '';

	commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_agenda_paciente ( cd_agenda_p agenda_paciente.cd_agenda%type, dt_agenda_p agenda_paciente.dt_agenda%type, nr_seq_lista_p agenda_lista_espera.nr_sequencia%type, nr_seq_turno_p agenda_turno.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type ) FROM PUBLIC;
