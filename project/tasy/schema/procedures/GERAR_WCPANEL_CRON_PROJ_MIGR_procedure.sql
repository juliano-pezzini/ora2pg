-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_wcpanel_cron_proj_migr ( nr_seq_cronograma_p bigint, cd_funcao_p bigint, nr_seq_atividade_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_atividade_w		bigint;
nm_objeto_w			varchar(255);
qt_tempo_desenv_minutos_w	double precision;
qt_tempo_desenv_horas_w		double precision;
qt_tempo_desenv_dias_trab_w	double precision;
nr_seq_apresent_w		bigint := 5000;
nr_seq_atividade_ww		bigint;

c01 CURSOR FOR
SELECT	a.nm_objeto,
	a.qt_tempo_desenv qt_tempo_desenv_minutos,
	round((dividir(a.qt_tempo_desenv,60))::numeric,2) qt_tempo_desenv_horas,
	round((dividir(dividir(a.qt_tempo_desenv,60),8))::numeric,2) qt_tempo_desenv_dias_trab
from (
	SELECT	a.nm_objeto,
		coalesce(sum(a.qt_tempo_desenv),0) qt_tempo_desenv
	from	w_analise_migr_proj a
	where	a.cd_funcao = cd_funcao_p
	and	a.ie_objeto in ('TWCPanel','TDBGrid')
	group by
		a.nm_objeto
	order by
		a.nm_objeto
	) a
order by
	a.nm_objeto,
	a.qt_tempo_desenv desc;


BEGIN
if (nr_seq_cronograma_p IS NOT NULL AND nr_seq_cronograma_p::text <> '') and (cd_funcao_p IS NOT NULL AND cd_funcao_p::text <> '') and (nr_seq_atividade_p IS NOT NULL AND nr_seq_atividade_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	select	nextval('proj_cron_etapa_seq')
	into STRICT	nr_seq_atividade_w
	;

	insert into proj_cron_etapa(
		nr_seq_cronograma,
		nr_sequencia,
		ds_atividade,
		ie_fase,
		qt_hora_prev,
		pr_etapa,
		nr_seq_apres,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_modulo,
		ie_tipo_obj_proj_migr,
		nr_seq_superior)
	values (
		nr_seq_cronograma_p,
		nr_seq_atividade_w,
		'TWCPanel',
		'S',
		0,
		0,
		nr_seq_apresent_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		'N',
		'TWCPanel',
		nr_seq_atividade_p);

	open c01;
	loop
	fetch c01 into 	nm_objeto_w,
			qt_tempo_desenv_minutos_w,
			qt_tempo_desenv_horas_w,
			qt_tempo_desenv_dias_trab_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		nr_seq_apresent_w := nr_seq_apresent_w + 10;

		select	nextval('proj_cron_etapa_seq')
		into STRICT	nr_seq_atividade_ww
		;

		insert into proj_cron_etapa(
			nr_seq_cronograma,
			nr_sequencia,
			ds_atividade,
			ie_fase,
			qt_hora_prev,
			pr_etapa,
			nr_seq_apres,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ie_modulo,
			ie_tipo_obj_proj_migr,
			nr_seq_superior)
		values (
			nr_seq_cronograma_p,
			nr_seq_atividade_ww,
			nm_objeto_w,
			'N',
			qt_tempo_desenv_horas_w,
			0,
			nr_seq_apresent_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			'N',
			'TWCPanel',
			nr_seq_atividade_w);

		CALL atualizar_horas_etapa_cron(nr_seq_atividade_ww);
		end;
	end loop;
	close c01;
	CALL atualizar_horas_etapa_cron(nr_seq_atividade_w);
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_wcpanel_cron_proj_migr ( nr_seq_cronograma_p bigint, cd_funcao_p bigint, nr_seq_atividade_p bigint, nm_usuario_p text) FROM PUBLIC;

