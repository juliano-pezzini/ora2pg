-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE Agendas AS (nr_sequencia     agenda_paciente.nr_sequencia%type,

	cd_agenda		agenda_paciente.cd_agenda%type,

	dt_agenda		timestamp,

	hr_inicio		timestamp,

	nr_minuto_duracao	agenda_paciente.nr_minuto_duracao%type,

	ie_status_agenda	agenda_paciente.ie_status_agenda%type,

	cd_pessoa_fisica	agenda_paciente.cd_pessoa_fisica%type,

	ie_alterou_inicio	varchar(2),

	nr_minuto_intervalo	agenda.nr_minuto_intervalo%type);


CREATE OR REPLACE PROCEDURE shift_swapped_patients (cd_agenda_orig_p bigint, cd_agenda_dest_p bigint, dt_agenda_orig_p timestamp, dt_agenda_dest_p timestamp, nm_usuario_p text) AS $body$
DECLARE




ie_ctrl_loop_w      bigint;

ie_array_count_w    bigint;

nr_sequencia_w      agenda_paciente.nr_sequencia%type;

hr_inicio_w         timestamp;



type VetorAgendas is table of Agendas index by integer;

array_agendas_w		VetorAgendas;





c_agenda CURSOR(cd_agenda_p    bigint, dt_agenda_p  timestamp) FOR

  SELECT	a.nr_sequencia,

		a.cd_agenda,

		a.dt_agenda,

		a.hr_inicio,

		a.nr_minuto_duracao,

		a.ie_status_agenda,

		a.cd_pessoa_fisica,

		b.nr_minuto_intervalo,

		case when coalesce(a.cd_pessoa_fisica::text, '') = '' then 1 else 0 end as is_patient_exist

	from	agenda_paciente a,

		agenda b

	where	a.cd_agenda = b.cd_agenda

		and a.cd_agenda  = cd_agenda_p

		and a.dt_agenda = dt_agenda_p

	order by is_patient_exist, hr_inicio;



BEGIN



ie_ctrl_loop_w := 1;



for	r_c_agenda in c_agenda(cd_agenda_orig_p, dt_agenda_orig_p)	loop

	array_agendas_w[ie_ctrl_loop_w].nr_sequencia       := r_c_agenda.nr_sequencia;

	array_agendas_w[ie_ctrl_loop_w].cd_agenda       := r_c_agenda.cd_agenda;

	array_agendas_w[ie_ctrl_loop_w].dt_agenda       := r_c_agenda.dt_agenda;

	array_agendas_w[ie_ctrl_loop_w].hr_inicio       := r_c_agenda.hr_inicio;

	array_agendas_w[ie_ctrl_loop_w].nr_minuto_duracao   := r_c_agenda.nr_minuto_duracao;

	array_agendas_w[ie_ctrl_loop_w].ie_status_agenda    := r_c_agenda.ie_status_agenda;

	array_agendas_w[ie_ctrl_loop_w].cd_pessoa_fisica    := r_c_agenda.cd_pessoa_fisica;

	array_agendas_w[ie_ctrl_loop_w].nr_minuto_intervalo := r_c_agenda.nr_minuto_intervalo;

	array_agendas_w[ie_ctrl_loop_w].ie_alterou_inicio   := 'N';

	ie_ctrl_loop_w := ie_ctrl_loop_w + 1;

end loop;



if (cd_agenda_orig_p != cd_agenda_dest_p)	then

	for	r_c_agenda in c_agenda(cd_agenda_dest_p, dt_agenda_dest_p)	loop

		array_agendas_w[ie_ctrl_loop_w].nr_sequencia       := r_c_agenda.nr_sequencia;

		array_agendas_w[ie_ctrl_loop_w].cd_agenda       := r_c_agenda.cd_agenda;

		array_agendas_w[ie_ctrl_loop_w].dt_agenda       := r_c_agenda.dt_agenda;

		array_agendas_w[ie_ctrl_loop_w].hr_inicio       := r_c_agenda.hr_inicio;

		array_agendas_w[ie_ctrl_loop_w].nr_minuto_duracao   := r_c_agenda.nr_minuto_duracao;

		array_agendas_w[ie_ctrl_loop_w].ie_status_agenda    := r_c_agenda.ie_status_agenda;

		array_agendas_w[ie_ctrl_loop_w].cd_pessoa_fisica    := r_c_agenda.cd_pessoa_fisica;

		array_agendas_w[ie_ctrl_loop_w].nr_minuto_intervalo := r_c_agenda.nr_minuto_intervalo;

		array_agendas_w[ie_ctrl_loop_w].ie_alterou_inicio   := 'N';

		ie_ctrl_loop_w := ie_ctrl_loop_w + 1;

	end loop;

end if;



ie_array_count_w := array_agendas_w.count;



for	i in 1..ie_array_count_w	loop

	if (i + 1 <= ie_array_count_w and

			array_agendas_w[i].cd_agenda = array_agendas_w[i + 1].cd_agenda)	then

	

		if (array_agendas_w[i](.cd_pessoa_fisica IS NOT NULL AND .cd_pessoa_fisica::text <> '')) then

			if (coalesce(hr_inicio_w::text, '') = '' or array_agendas_w[i].hr_inicio > hr_inicio_w) then

				hr_inicio_w := array_agendas_w[i].hr_inicio;

			end if;

		end if;



		if (array_agendas_w[i + 1]coalesce(.cd_pessoa_fisica::text, '') = '')	then

        if (array_agendas_w[i + 1].hr_inicio <= hr_inicio_w) then

          delete from	agenda_paciente
    
          where	nr_sequencia = array_agendas_w[i + 1].nr_sequencia;

          if (i + 2 <= ie_array_count_w and array_agendas_w[i + 2].hr_inicio > hr_inicio_w) then

              delete from	agenda_paciente

              where	nr_sequencia = array_agendas_w[i + 2].nr_sequencia;

          end if;

          commit;

        end if;

		elsif (coalesce(array_agendas_w[i].cd_pessoa_fisica, 0) > 0

				and coalesce(array_agendas_w[i + 1].cd_pessoa_fisica, 0) > 0

				and array_agendas_w[i].hr_inicio + array_agendas_w[i].nr_minuto_duracao / 1440 > array_agendas_w[i + 1].hr_inicio)	then

			array_agendas_w[i + 1].hr_inicio := trunc(array_agendas_w[i].hr_inicio + array_agendas_w[i].nr_minuto_duracao / 1440, 'MI');

			select	max(nr_sequencia)

				into STRICT nr_sequencia_w

			from	agenda_paciente

			where	cd_agenda = array_agendas_w[i + 1].cd_agenda

			and	dt_agenda = array_agendas_w[i + 1].dt_agenda

			and	hr_inicio = array_agendas_w[i + 1].hr_inicio

			and	ie_status_agenda = array_agendas_w[i + 1].ie_status_agenda;

			if (coalesce(nr_sequencia_w, 0) > 0)	then

				update	agenda_paciente	set	hr_inicio = hr_inicio + 1 / (86400)

				where	nr_sequencia = nr_sequencia_w;

				commit;

			end if;

			update	agenda_paciente	set hr_inicio = array_agendas_w[i + 1].hr_inicio,

				nm_usuario = nm_usuario_p,

				dt_atualizacao = clock_timestamp()

			where	nr_sequencia = array_agendas_w[i + 1].nr_sequencia;

			commit;

		end if;

	end if;

end loop;



end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE shift_swapped_patients (cd_agenda_orig_p bigint, cd_agenda_dest_p bigint, dt_agenda_orig_p timestamp, dt_agenda_dest_p timestamp, nm_usuario_p text) FROM PUBLIC;
