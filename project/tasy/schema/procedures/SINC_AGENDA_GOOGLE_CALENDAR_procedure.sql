-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sinc_agenda_google_calendar ( nm_usuario_agenda_p text, ie_tipo_acao_p text, nr_seq_tipo_agenda_p bigint, ie_direcao_p text, nr_seq_agenda_p INOUT bigint) AS $body$
DECLARE


/*
ie_direcao_p
TG = Tasy para Google
GT = Google para Tasy
*/
ds_compromisso_w	varchar(255);
ds_local_w		varchar(255);
ds_observacao_w		varchar(2000);
dt_inicio_evento_w	timestamp;
dt_final_evento_w	timestamp;
nr_minuto_w		bigint;
nr_seq_gc_w		bigint;
dt_ult_alteracao_w	timestamp;
ds_id_google_w		varchar(255);

C01 CURSOR FOR
	SELECT  a.nr_sequencia,
		a.ds_agenda,
	        a.dt_agenda,
	        a.dt_agenda + (CASE WHEN a.nr_minuto_duracao=0 THEN  1  ELSE a.nr_minuto_duracao END  / 1440),
	        coalesce(a.ds_local, obter_local_agenda_tasy(a.nr_seq_local)),
	        a.ds_observacao
	from    agenda_tasy a
	where   nm_usuario_agenda = nm_usuario_agenda_p
	and	ie_status <> 'L'
	and     not exists (SELECT  1
	                    from    agenda_google_cal_hist b
	                    where   a.nr_sequencia = b.nr_seq_agenda);

C02 CURSOR FOR
	SELECT  a.nr_sequencia,
	        a.ds_agenda,
		a.dt_agenda,
		a.dt_agenda + (CASE WHEN a.nr_minuto_duracao=0 THEN  1  ELSE a.nr_minuto_duracao END  / 1440),
		a.ds_local,
	        a.ds_observacao,
	        b.ds_id_google
	from    agenda_tasy a,
	        agenda_google_cal_hist b
	where   a.nm_usuario_agenda = nm_usuario_agenda_p
	and     a.nr_sequencia = b.nr_seq_agenda
	and     a.dt_atualizacao > b.dt_ult_alteracao
	and	a.ie_status <> 'L';


BEGIN

if ( ie_direcao_p = 'TG')	then
	open C01;
	loop
	fetch C01 into
		nr_seq_agenda_p,
		ds_compromisso_w,
		dt_inicio_evento_w,
		dt_final_evento_w,
		ds_local_w,
		ds_observacao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		insert into agenda_google_calendar(
			nr_sequencia,
			ds_compromisso,
			ds_local,
			ds_observacao,
			dt_inicio_evento,
			dt_final_evento,
			ie_tipo_acao,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_agenda
		) values (
			nextval('agenda_google_calendar_seq'),
			ds_compromisso_w,
			ds_local_w,
			ds_observacao_w,
			dt_inicio_evento_w,
			dt_final_evento_w,
			'IG',
			clock_timestamp(),
			nm_usuario_agenda_p,
			clock_timestamp(),
			nm_usuario_agenda_p,
			nr_seq_agenda_p
		);

		end;
	end loop;
	close C01;

	open C02;
	loop
	fetch C02 into
		nr_seq_agenda_p,
		ds_compromisso_w,
		dt_inicio_evento_w,
		dt_final_evento_w,
		ds_local_w,
		ds_observacao_w,
		ds_id_google_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		insert into agenda_google_calendar(
			nr_sequencia,
			ds_compromisso,
			ds_local,
			ds_observacao,
			dt_inicio_evento,
			dt_final_evento,
			ie_tipo_acao,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_agenda,
			ds_id_google
		) values (
			nextval('agenda_google_calendar_seq'),
			ds_compromisso_w,
			ds_local_w,
			ds_observacao_w,
			dt_inicio_evento_w,
			dt_final_evento_w,
			'UG',
			clock_timestamp(),
			nm_usuario_agenda_p,
			clock_timestamp(),
			nm_usuario_agenda_p,
			nr_seq_agenda_p,
			ds_id_google_w
		);

		end;
	end loop;
	close C02;

elsif ( ie_direcao_p = 'GT' )	then
	select	ds_compromisso,
		ds_local,
		ds_observacao,
		dt_inicio_evento,
		dt_final_evento,
		nr_sequencia,
		nr_seq_agenda,
		dt_ult_alteracao
	into STRICT	ds_compromisso_w,
		ds_local_w,
		ds_observacao_w,
		dt_inicio_evento_w,
		dt_final_evento_w,
		nr_seq_gc_w,
		nr_seq_agenda_p,
		dt_ult_alteracao_w
	from	agenda_google_calendar
	where	nm_usuario = nm_usuario_agenda_p
	and	ie_tipo_acao = ie_tipo_acao_p;

	nr_minuto_w 	:= (dt_final_evento_w - dt_inicio_evento_w) * 1440;

	if ( ie_tipo_acao_p = 'IT' ) then
		select	nextval('agenda_tasy_seq')
		into STRICT	nr_seq_agenda_p
		;

		insert into agenda_tasy(
			nr_sequencia,
			dt_agenda,
			ds_agenda,
			nr_minuto_duracao,
			nm_usuario_agenda,
			dt_atualizacao,
			nm_usuario,
			ds_observacao,
			ds_local,
			ie_status,
			dt_final,
			nr_seq_tipo
		) values (
			nr_seq_agenda_p,
			dt_inicio_evento_w,
			substr(ds_compromisso_w,0,99),
			nr_minuto_w,
			nm_usuario_agenda_p,
			dt_ult_alteracao_w,
			nm_usuario_agenda_p,
			substr(ds_observacao_w,0,1999),
			substr(ds_local_w,0,49),
			'M',
			dt_final_evento_w,
			nr_seq_tipo_agenda_p
		);

		commit;
	elsif ( ie_tipo_acao_p = 'UT' ) then
		if (coalesce(nr_seq_agenda_p::text, '') = '') then
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(280046);
		end if;

		update	agenda_tasy
		set	dt_agenda = dt_inicio_evento_w,
			dt_final = dt_final_evento_w,
			ds_agenda = substr(ds_compromisso_w,0,99),
			nr_minuto_duracao = nr_minuto_w,
			dt_atualizacao = dt_ult_alteracao_w,
			nm_usuario = nm_usuario_agenda,
			ds_local = substr(ds_local_w,0,49),
			ds_observacao = substr(ds_observacao_w,0,1999)
		where	nr_sequencia = nr_seq_agenda_p;

		commit;
	end if;

	delete
	from 	agenda_google_calendar
	where	nr_sequencia = nr_seq_gc_w;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sinc_agenda_google_calendar ( nm_usuario_agenda_p text, ie_tipo_acao_p text, nr_seq_tipo_agenda_p bigint, ie_direcao_p text, nr_seq_agenda_p INOUT bigint) FROM PUBLIC;

