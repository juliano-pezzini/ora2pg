-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hc_alterar_responsavel ( nr_seq_agenda_p bigint, nr_seq_equipe_p bigint, ds_seq_prof_hc_p text, ie_opcao_p text, nm_usuario_p text, dt_agenda_p timestamp, nr_seq_turno_p bigint) AS $body$
DECLARE


lista_responsaveis_w	dbms_sql.varchar2_table;
nr_seq_prof_hc_w	bigint;
nr_seq_agenda_w		bigint;
ie_controle_w		integer;
nr_seq_equipe_w		bigint;

c01 CURSOR FOR
	SELECT	a.nr_sequencia,
		b.nr_seq_equipe_hc
	from	agenda_hc_paciente a,
		hc_agenda_prof b,
		hc_turno h
	where	b.nr_seq_agenda = a.nr_sequencia
	and	to_char(a.dt_agenda,'hh24:mi:ss')  between to_char(h.hr_inicial,'hh24:mi:ss') and to_char(h.hr_final,'hh24:mi:ss')
	and	a.dt_agenda 	between inicio_dia(dt_agenda_p) and fim_dia(dt_agenda_p)
	and	((b.nr_seq_equipe_hc = nr_seq_equipe_p) or (nr_seq_equipe_p = 0));

BEGIN
if (ds_seq_prof_hc_p IS NOT NULL AND ds_seq_prof_hc_p::text <> '') then
	begin
	lista_responsaveis_w	:= obter_lista_string(ds_seq_prof_hc_p, ',');

	if (ie_opcao_p = 'P') then
		begin
		delete	from hc_agenda_prof
		where	nr_seq_agenda	= nr_seq_agenda_p;
		commit;

		for	i in lista_responsaveis_w.first..lista_responsaveis_w.last loop
			nr_seq_prof_hc_w	:= lista_responsaveis_w(i);

			insert into  hc_agenda_prof(
				nr_sequencia,
				nm_usuario,
				dt_atualizacao,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_agenda,
				nr_seq_prof_hc,
				nr_seq_equipe_hc)
			values (
				nextval('hc_agenda_prof_seq'),
				nm_usuario_p,
				clock_timestamp(),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_agenda_p,
				nr_seq_prof_hc_w,
				CASE WHEN nr_seq_equipe_p=0 THEN null  ELSE nr_seq_equipe_p END );
			commit;
		end loop;
		end;
	end if;

	if (ie_opcao_p = 'E') then
		begin
		ie_controle_w	:= 1;
		for	y in lista_responsaveis_w.first..lista_responsaveis_w.last loop
			nr_seq_prof_hc_w	:= lista_responsaveis_w(y);

			open c01;
			loop
			fetch c01 into
				nr_seq_agenda_w,
				nr_seq_equipe_w;
			EXIT WHEN NOT FOUND; /* apply on c01 */
				begin
				if (ie_controle_w = 1) then
					begin
					delete	from hc_agenda_prof
					where	nr_seq_agenda	in(	SELECT	a.nr_sequencia
									from	agenda_hc_paciente a,
										hc_agenda_prof b
									where	b.nr_seq_agenda = a.nr_sequencia
									and	a.dt_agenda 	between inicio_dia(dt_agenda_p) and fim_dia(dt_agenda_p)
									and	((b.nr_seq_equipe_hc = nr_seq_equipe_p) or (nr_seq_equipe_p = 0)));
					end;
				end if;

				insert into  hc_agenda_prof(
					nr_sequencia,
					nm_usuario,
					dt_atualizacao,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_equipe_hc,
					nr_seq_prof_hc,
					nr_seq_agenda)
				values (
					nextval('hc_agenda_prof_seq'),
					nm_usuario_p,
					clock_timestamp(),
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_equipe_w,
					nr_seq_prof_hc_w,
					nr_seq_agenda_w );

				end;
				ie_controle_w := ie_controle_w + 1;
			end loop;
			close c01;
		end loop;
		end;
	end if;
	end;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hc_alterar_responsavel ( nr_seq_agenda_p bigint, nr_seq_equipe_p bigint, ds_seq_prof_hc_p text, ie_opcao_p text, nm_usuario_p text, dt_agenda_p timestamp, nr_seq_turno_p bigint) FROM PUBLIC;
