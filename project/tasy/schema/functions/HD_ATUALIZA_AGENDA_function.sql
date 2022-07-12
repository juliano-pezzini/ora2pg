-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function hd_atualiza_agenda as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE FUNCTION hd_atualiza_agenda ( dt_agenda_p hd_agenda_dialise.dt_agenda%type, cd_pessoa_fisica_p hd_agenda_dialise.cd_pessoa_fisica%type, nr_seq_turno_p hd_agenda_dialise.nr_seq_turno%type, nr_seq_unid_p hd_agenda_dialise.nr_seq_unidade%type, cd_estabelecimento_p hd_agenda_dialise.cd_estabelecimento%type, nr_seq_ponto_acesso_p hd_agenda_dialise.nr_seq_ponto_acesso%type, cd_convenio_p hd_agenda_dialise.cd_convenio%type default null, nr_seq_agenda_p hd_agenda_dialise.nr_seq_agenda%type default null, qt_min_hora_sessao_p hd_agenda_dialise.qt_hora_min_sessao%type default null, qt_duracao_limpeza_p bigint default 0, ie_dia_semana_p bigint default 0, ie_event_p text default 'D') RETURNS varchar AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	varchar;
BEGIN
	v_query := 'SELECT * FROM hd_atualiza_agenda_atx ( ' || quote_nullable(dt_agenda_p) || ',' || quote_nullable(cd_pessoa_fisica_p) || ',' || quote_nullable(nr_seq_turno_p) || ',' || quote_nullable(nr_seq_unid_p) || ',' || quote_nullable(cd_estabelecimento_p) || ',' || quote_nullable(nr_seq_ponto_acesso_p) || ',' || quote_nullable(cd_convenio_p) || ',' || quote_nullable(nr_seq_agenda_p) || ',' || quote_nullable(qt_min_hora_sessao_p) || ',' || quote_nullable(qt_duracao_limpeza_p) || ',' || quote_nullable(ie_dia_semana_p) || ',' || quote_nullable(ie_event_p) || ' )';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret varchar);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE FUNCTION hd_atualiza_agenda_atx ( dt_agenda_p hd_agenda_dialise.dt_agenda%type, cd_pessoa_fisica_p hd_agenda_dialise.cd_pessoa_fisica%type, nr_seq_turno_p hd_agenda_dialise.nr_seq_turno%type, nr_seq_unid_p hd_agenda_dialise.nr_seq_unidade%type, cd_estabelecimento_p hd_agenda_dialise.cd_estabelecimento%type, nr_seq_ponto_acesso_p hd_agenda_dialise.nr_seq_ponto_acesso%type, cd_convenio_p hd_agenda_dialise.cd_convenio%type default null, nr_seq_agenda_p hd_agenda_dialise.nr_seq_agenda%type default null, qt_min_hora_sessao_p hd_agenda_dialise.qt_hora_min_sessao%type default null, qt_duracao_limpeza_p bigint default 0, ie_dia_semana_p bigint default 0, ie_event_p text default 'D') RETURNS varchar AS $body$
DECLARE
nm_usuario_s 		hd_agenda_dialise.nm_usuario%type;
nr_sequencia_w 		hd_agenda_dialise.nr_sequencia%type;
nr_seq_agenda_old_w 	hd_agenda_dialise.nr_seq_agenda%type;
dt_atual_s 		timestamp            := clock_timestamp();
ie_atualiza_s 		varchar(1)         := 'S';
ie_occupied_w 		varchar(1);
qt_hora_prescrita_w 	bigint;
qt_ocupada_w 		bigint;
qt_total_turno_w 	bigint;
qt_saldo_turno_w 	bigint;


BEGIN
nm_usuario_s := coalesce(wheb_usuario_pck.get_nm_usuario, 'TASY');

select  coalesce(sum((select hd_obter_hora_sessao(a.cd_pessoa_fisica, dt_agenda_p) )), 0) qt_hora_prescrita,
	sum(a.qt_hora_min_sessao) qt_ocupada
into STRICT    qt_hora_prescrita_w,
	qt_ocupada_w
from    hd_agenda_dialise a
where   a.ie_situacao           = 'A'
and     a.cd_estabelecimento    = cd_estabelecimento_p
and     a.nr_seq_turno          = nr_seq_turno_p
and     a.nr_seq_ponto_acesso   = nr_seq_ponto_acesso_p
and     a.nr_seq_unidade        = nr_seq_unid_p
and     trunc(a.dt_agenda)      = trunc(dt_agenda_p);

select  max(
		round((to_char(a.dt_fim, 'SSSSS'))::numeric  / 60) -
		round((to_char(a.dt_inicio, 'SSSSS'))::numeric  / 60) -
		qt_duracao_limpeza_p
	)   qt_total_turno
into STRICT    qt_total_turno_w
from    hd_turno a
where   a.nr_sequencia = nr_seq_turno_p;

qt_saldo_turno_w := qt_total_turno_w - (coalesce(qt_ocupada_w, qt_hora_prescrita_w));

if (qt_saldo_turno_w <= 0 or qt_saldo_turno_w < coalesce(qt_min_hora_sessao_p, qt_total_turno_w)) then
	select  CASE WHEN coalesce(max(a.nr_sequencia)::text, '') = '' THEN  'N'  ELSE 'S' END  ie_occupied
	into STRICT    ie_occupied_w
	from    hd_agenda_dialise a
	where   a.ie_situacao 		= 'A'
	and     a.cd_estabelecimento 	= cd_estabelecimento_p
	and     a.nr_seq_unidade 	= nr_seq_unid_p
	and     a.nr_seq_ponto_acesso 	= nr_seq_ponto_acesso_p
	and     a.nr_seq_turno 		= nr_seq_turno_p + 1
	and     trunc(a.dt_agenda) 	= trunc(dt_agenda_p);

	if  (
		(ie_occupied_w = 'S' and ie_event_p = 'D') or (ie_occupied_w = 'S' and ie_event_p = 'C' and qt_total_turno_w < qt_min_hora_sessao_p)
	) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1212586);
	end if;
end if;

IF coalesce(nr_seq_agenda_p::text, '') = '' THEN
	SELECT  nextval('hd_agenda_dialise_seq')
	INTO STRICT    nr_sequencia_w
	;

	INSERT INTO hd_agenda_dialise(
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_sequencia,
		dt_agenda,
		cd_convenio,
		cd_pessoa_fisica,
		cd_estabelecimento,
		nr_seq_unidade,
		nr_seq_ponto_acesso,
		nr_seq_turno,
		ie_situacao,
		ie_tipo_marcacao,
		qt_hora_min_sessao,
		hr_inicio
	) VALUES (
		dt_atual_s,
		nm_usuario_s,
		dt_atual_s,
		nm_usuario_s,
		nr_sequencia_w,
		trunc(dt_agenda_p),
		cd_convenio_p,
		cd_pessoa_fisica_p,
		cd_estabelecimento_p,
		nr_seq_unid_p,
		nr_seq_ponto_acesso_p,
		nr_seq_turno_p,
		'A',
		'M',
		coalesce(qt_min_hora_sessao_p, qt_total_turno_w),
		dt_agenda_p
	);

	CALL hd_gerar_agendamento_servico(nr_seq_agenda_dialise_p => nr_sequencia_w);
ELSE
	SELECT  a.nr_seq_agenda
	INTO STRICT    nr_seq_agenda_old_w
	FROM    hd_agenda_dialise a
	WHERE   nr_sequencia = nr_seq_agenda_p;

	UPDATE  hd_agenda_dialise a
	SET     dt_atualizacao 		= dt_atual_s,
		nm_usuario 		= nm_usuario_s,
		nr_seq_unidade 		= nr_seq_unid_p,
		nr_seq_ponto_acesso 	= nr_seq_ponto_acesso_p,
		nr_seq_turno 		= nr_seq_turno_p,
		ie_tipo_marcacao 	= 'M',
		dt_agenda 		= trunc(dt_agenda_p),
		nr_seq_agenda 		 = NULL,
		qt_hora_min_sessao 	= qt_min_hora_sessao_p,
		hr_inicio 		= dt_agenda_p
	WHERE   nr_sequencia = nr_seq_agenda_p;

	CALL hd_gerar_agendamento_servico(
		nr_seq_agenda_dialise_p => nr_seq_agenda_p,
		nr_seq_agenda_serv_old_p => nr_seq_agenda_old_w
	);
END IF;


RETURN ie_atualiza_s;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION hd_atualiza_agenda ( dt_agenda_p hd_agenda_dialise.dt_agenda%type, cd_pessoa_fisica_p hd_agenda_dialise.cd_pessoa_fisica%type, nr_seq_turno_p hd_agenda_dialise.nr_seq_turno%type, nr_seq_unid_p hd_agenda_dialise.nr_seq_unidade%type, cd_estabelecimento_p hd_agenda_dialise.cd_estabelecimento%type, nr_seq_ponto_acesso_p hd_agenda_dialise.nr_seq_ponto_acesso%type, cd_convenio_p hd_agenda_dialise.cd_convenio%type default null, nr_seq_agenda_p hd_agenda_dialise.nr_seq_agenda%type default null, qt_min_hora_sessao_p hd_agenda_dialise.qt_hora_min_sessao%type default null, qt_duracao_limpeza_p bigint default 0, ie_dia_semana_p bigint default 0, ie_event_p text default 'D') FROM PUBLIC; -- REVOKE ALL ON FUNCTION hd_atualiza_agenda_atx ( dt_agenda_p hd_agenda_dialise.dt_agenda%type, cd_pessoa_fisica_p hd_agenda_dialise.cd_pessoa_fisica%type, nr_seq_turno_p hd_agenda_dialise.nr_seq_turno%type, nr_seq_unid_p hd_agenda_dialise.nr_seq_unidade%type, cd_estabelecimento_p hd_agenda_dialise.cd_estabelecimento%type, nr_seq_ponto_acesso_p hd_agenda_dialise.nr_seq_ponto_acesso%type, cd_convenio_p hd_agenda_dialise.cd_convenio%type default null, nr_seq_agenda_p hd_agenda_dialise.nr_seq_agenda%type default null, qt_min_hora_sessao_p hd_agenda_dialise.qt_hora_min_sessao%type default null, qt_duracao_limpeza_p bigint default 0, ie_dia_semana_p bigint default 0, ie_event_p text default 'D') FROM PUBLIC;

