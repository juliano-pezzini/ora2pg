-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_replic_agenda_home_care (nr_sequencia_p bigint, dt_parametro_1_p timestamp, dt_parametro_2_p timestamp, dt_parametro_3_p timestamp, dt_parametro_4_p timestamp, dt_parametro_5_p timestamp, dt_inicial_p timestamp, dt_final_p timestamp, ie_opcao_p bigint, dt_referencia_p timestamp, nm_usuario_p text) AS $body$
DECLARE

nr_sequencia_w		bigint;
cd_pessoa_fisica_w	varchar(10);
nr_seq_agenda_w		bigint;
ds_observacao_w		varchar(255);
nr_seq_classificacao_w	bigint;
dt_inicial_w		timestamp;
qt_hora_w		varchar(5);
nr_seq_equipe_hc_w	bigint;
nr_seq_prof_hc_w	bigint;
nr_seq_paciente_hc_w	bigint;
ds_erro_bloqueio_w	varchar(255);

C01 CURSOR FOR
	SELECT	to_date(to_char(dt_inicial,'dd/mm/yyyy')||' '||qt_hora_w,'dd/mm/yyyy hh24:mi:ss')
	from (WITH RECURSIVE cte AS (

	SELECT 	trunc(dt_inicial_p) dt_inicial
	
	
union

	select 	trunc(to_date(dt_inicial_p))+level
	
	where	dt_inicial_p <> dt_final_p
	level <= (trunc(dt_final_p)-trunc(dt_inicial_p))  UNION ALL

	SELECT 	trunc(dt_inicial_p) dt_inicial
	
	
union

	select 	trunc(to_date(dt_inicial_p))+level
	
	where	dt_inicial_p <> dt_final_p
	level <= (trunc(dt_final_p)-trunc(dt_inicial_p)) JOIN cte c ON ()

) SELECT * FROM cte;
) alias8;

C02 CURSOR FOR
	SELECT	nr_seq_equipe_hc,
		nr_seq_prof_hc
	from	hc_agenda_prof a
	where	a.nr_seq_agenda = nr_sequencia_p;



BEGIN
select	to_char(dt_referencia_p,'hh24:mi')
into STRICT	qt_hora_w
;

select	cd_pessoa_fisica,
	nr_seq_agenda,
	nr_seq_classificacao,
	ds_observacao,
	nr_seq_paciente_hc
into STRICT	cd_pessoa_fisica_w,
	nr_seq_agenda_w,
	nr_seq_classificacao_w,
	ds_observacao_w,
	nr_seq_paciente_hc_w
from	agenda_hc_paciente
where	nr_sequencia = nr_sequencia_p;
if (ie_opcao_p = 0) then

	SELECT	hc_consulta_bloqueio(nr_seq_agenda_w, dt_parametro_1_p, 'M')
	into STRICT	ds_erro_bloqueio_w
	;

	If (dt_parametro_1_p IS NOT NULL AND dt_parametro_1_p::text <> '') and (coalesce(ds_erro_bloqueio_w,'x') = 'x') then
		begin
		select	nextval('agenda_hc_paciente_seq')
		into STRICT	nr_sequencia_w
		;

		insert into agenda_hc_paciente(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			cd_pessoa_fisica,
			dt_agenda,
			ie_status_agenda,
			nr_seq_agenda,
			nr_seq_classificacao,
			ds_observacao,
			nr_seq_paciente_hc)
		values (
			nr_sequencia_w,
			clock_timestamp(),
			nm_usuario_p,
			cd_pessoa_fisica_w,
			dt_parametro_1_p,
			'A',
			nr_seq_agenda_w,
			nr_seq_classificacao_w,
			ds_observacao_w,
			nr_seq_paciente_hc_w);

		open C02;
		loop
		fetch C02 into
			nr_seq_equipe_hc_w,
			nr_seq_prof_hc_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			insert into hc_agenda_prof(
				nr_sequencia,
				dt_atualizacao,
				dt_atualizacao_nrec,
				nm_usuario,
				nm_usuario_nrec,
				nr_seq_agenda,
				nr_seq_equipe_hc,
				nr_seq_prof_hc)
			values (	nextval('hc_agenda_prof_seq'),
				clock_timestamp(),
				clock_timestamp(),
				nm_usuario_p,
				nm_usuario_p,
				nr_sequencia_w,
				nr_seq_equipe_hc_w,
				nr_seq_prof_hc_w);
			end;
		end loop;
		close C02;
		end;
	end if;

	SELECT	hc_consulta_bloqueio(nr_seq_agenda_w, dt_parametro_2_p, 'M')
	into STRICT	ds_erro_bloqueio_w
	;

	If (dt_parametro_2_p IS NOT NULL AND dt_parametro_2_p::text <> '') and (coalesce(ds_erro_bloqueio_w,'x') = 'x') then
		begin

		select	nextval('agenda_hc_paciente_seq')
		into STRICT	nr_sequencia_w
		;

		insert into agenda_hc_paciente(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			cd_pessoa_fisica,
			dt_agenda,
			ie_status_agenda,
			nr_seq_agenda,
			nr_seq_classificacao,
			ds_observacao,
			nr_seq_paciente_hc)
		values (
			nr_sequencia_w,
			clock_timestamp(),
			nm_usuario_p,
			cd_pessoa_fisica_w,
			dt_parametro_2_p,
			'A',
			nr_seq_agenda_w,
			nr_seq_classificacao_w,
			ds_observacao_w,
			nr_seq_paciente_hc_w);

		open C02;
		loop
		fetch C02 into
			nr_seq_equipe_hc_w,
			nr_seq_prof_hc_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			insert into hc_agenda_prof(
				nr_sequencia,
				dt_atualizacao,
				dt_atualizacao_nrec,
				nm_usuario,
				nm_usuario_nrec,
				nr_seq_agenda,
				nr_seq_equipe_hc,
				nr_seq_prof_hc)
			values (	nextval('hc_agenda_prof_seq'),
				clock_timestamp(),
				clock_timestamp(),
				nm_usuario_p,
				nm_usuario_p,
				nr_sequencia_w,
				nr_seq_equipe_hc_w,
				nr_seq_prof_hc_w);
			end;
		end loop;
		close C02;

		end;
	end if;

	SELECT	hc_consulta_bloqueio(nr_seq_agenda_w, dt_parametro_3_p, 'M')
	into STRICT	ds_erro_bloqueio_w
	;

	If (dt_parametro_3_p IS NOT NULL AND dt_parametro_3_p::text <> '') and (coalesce(ds_erro_bloqueio_w,'x') = 'x') then
		begin

		select	nextval('agenda_hc_paciente_seq')
		into STRICT	nr_sequencia_w
		;

		insert into agenda_hc_paciente(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			cd_pessoa_fisica,
			dt_agenda,
			ie_status_agenda,
			nr_seq_agenda,
			nr_seq_classificacao,
			ds_observacao,
			nr_seq_paciente_hc)
		values (
			nr_sequencia_w,
			clock_timestamp(),
			nm_usuario_p,
			cd_pessoa_fisica_w,
			dt_parametro_3_p,
			'A',
			nr_seq_agenda_w,
			nr_seq_classificacao_w,
			ds_observacao_w,
			nr_seq_paciente_hc_w);

		open C02;
		loop
		fetch C02 into
			nr_seq_equipe_hc_w,
			nr_seq_prof_hc_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			insert into hc_agenda_prof(
				nr_sequencia,
				dt_atualizacao,
				dt_atualizacao_nrec,
				nm_usuario,
				nm_usuario_nrec,
				nr_seq_agenda,
				nr_seq_equipe_hc,
				nr_seq_prof_hc)
			values (	nextval('hc_agenda_prof_seq'),
				clock_timestamp(),
				clock_timestamp(),
				nm_usuario_p,
				nm_usuario_p,
				nr_sequencia_w,
				nr_seq_equipe_hc_w,
				nr_seq_prof_hc_w);
			end;
		end loop;
		close C02;
		end;
	end if;

	SELECT	hc_consulta_bloqueio(nr_seq_agenda_w, dt_parametro_4_p, 'M')
	into STRICT	ds_erro_bloqueio_w
	;

	If (dt_parametro_4_p IS NOT NULL AND dt_parametro_4_p::text <> '') and (coalesce(ds_erro_bloqueio_w,'x') = 'x') then
		begin
		select	nextval('agenda_hc_paciente_seq')
		into STRICT	nr_sequencia_w
		;

		insert into agenda_hc_paciente(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			cd_pessoa_fisica,
			dt_agenda,
			ie_status_agenda,
			nr_seq_agenda,
			nr_seq_classificacao,
			ds_observacao,
			nr_seq_paciente_hc)
		values (
			nr_sequencia_w,
			clock_timestamp(),
			nm_usuario_p,
			cd_pessoa_fisica_w,
			dt_parametro_4_p,
			'A',
			nr_seq_agenda_w,
			nr_seq_classificacao_w,
			ds_observacao_w,
			nr_seq_paciente_hc_w);

		open C02;
		loop
		fetch C02 into
			nr_seq_equipe_hc_w,
			nr_seq_prof_hc_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			insert into hc_agenda_prof(
				nr_sequencia,
				dt_atualizacao,
				dt_atualizacao_nrec,
				nm_usuario,
				nm_usuario_nrec,
				nr_seq_agenda,
				nr_seq_equipe_hc,
				nr_seq_prof_hc)
			values (	nextval('hc_agenda_prof_seq'),
				clock_timestamp(),
				clock_timestamp(),
				nm_usuario_p,
				nm_usuario_p,
				nr_sequencia_w,
				nr_seq_equipe_hc_w,
				nr_seq_prof_hc_w);
			end;
		end loop;
		close C02;

		end;
	end if;

	SELECT	hc_consulta_bloqueio(nr_seq_agenda_w, dt_parametro_5_p, 'M')
	into STRICT	ds_erro_bloqueio_w
	;

	If (dt_parametro_5_p IS NOT NULL AND dt_parametro_5_p::text <> '') and (coalesce(ds_erro_bloqueio_w,'x') = 'x') then
		begin

		select	nextval('agenda_hc_paciente_seq')
		into STRICT	nr_sequencia_w
		;

		insert into agenda_hc_paciente(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			cd_pessoa_fisica,
			dt_agenda,
			ie_status_agenda,
			nr_seq_agenda,
			nr_seq_classificacao,
			ds_observacao,
			nr_seq_paciente_hc)
		values (
			nr_sequencia_w,
			clock_timestamp(),
			nm_usuario_p,
			cd_pessoa_fisica_w,
			dt_parametro_5_p,
			'A',
			nr_seq_agenda_w,
			nr_seq_classificacao_w,
			ds_observacao_w,
			nr_seq_paciente_hc_w);

		open C02;
		loop
		fetch C02 into
			nr_seq_equipe_hc_w,
			nr_seq_prof_hc_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			insert into hc_agenda_prof(
				nr_sequencia,
				dt_atualizacao,
				dt_atualizacao_nrec,
				nm_usuario,
				nm_usuario_nrec,
				nr_seq_agenda,
				nr_seq_equipe_hc,
				nr_seq_prof_hc)
			values (	nextval('hc_agenda_prof_seq'),
				clock_timestamp(),
				clock_timestamp(),
				nm_usuario_p,
				nm_usuario_p,
				nr_sequencia_w,
				nr_seq_equipe_hc_w,
				nr_seq_prof_hc_w);
			end;
		end loop;
		close C02;

		end;
	end if;
elsif (ie_opcao_p = 1) then
	if (dt_inicial_p IS NOT NULL AND dt_inicial_p::text <> '') and (dt_final_p IS NOT NULL AND dt_final_p::text <> '') then
	open C01;
	loop
	fetch C01 into
		dt_inicial_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		SELECT	hc_consulta_bloqueio(nr_seq_agenda_w, dt_inicial_w, 'M')
		into STRICT	ds_erro_bloqueio_w
		;

		If (coalesce(ds_erro_bloqueio_w,'x') = 'x') then

			select	nextval('agenda_hc_paciente_seq')
			into STRICT	nr_sequencia_w
			;

			insert into agenda_hc_paciente(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				cd_pessoa_fisica,
				dt_agenda,
				ie_status_agenda,
				nr_seq_agenda,
				nr_seq_classificacao,
				ds_observacao,
				nr_seq_paciente_hc)
			values (
				nr_sequencia_w,
				clock_timestamp(),
				nm_usuario_p,
				cd_pessoa_fisica_w,
				dt_inicial_w,
				'A',
				nr_seq_agenda_w,
				nr_seq_classificacao_w,
				ds_observacao_w,
				nr_seq_paciente_hc_w);


			open C02;
			loop
			fetch C02 into
				nr_seq_equipe_hc_w,
				nr_seq_prof_hc_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin
				insert into hc_agenda_prof(
					nr_sequencia,
					dt_atualizacao,
					dt_atualizacao_nrec,
					nm_usuario,
					nm_usuario_nrec,
					nr_seq_agenda,
					nr_seq_equipe_hc,
					nr_seq_prof_hc)
				values (	nextval('hc_agenda_prof_seq'),
					clock_timestamp(),
					clock_timestamp(),
					nm_usuario_p,
					nm_usuario_p,
					nr_sequencia_w,
					nr_seq_equipe_hc_w,
					nr_seq_prof_hc_w);
				end;
			end loop;
			close C02;

		end if;

		end;
	end loop;
	close C01;

	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_replic_agenda_home_care (nr_sequencia_p bigint, dt_parametro_1_p timestamp, dt_parametro_2_p timestamp, dt_parametro_3_p timestamp, dt_parametro_4_p timestamp, dt_parametro_5_p timestamp, dt_inicial_p timestamp, dt_final_p timestamp, ie_opcao_p bigint, dt_referencia_p timestamp, nm_usuario_p text) FROM PUBLIC;
