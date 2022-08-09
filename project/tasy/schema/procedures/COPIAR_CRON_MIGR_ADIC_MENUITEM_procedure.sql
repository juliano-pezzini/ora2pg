-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_cron_migr_adic_menuitem ( cd_funcao_origem_p bigint, cd_funcao_destino_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_cronograma_w		bigint;
nr_seq_atividade_w		bigint;
nr_seq_apresent_w		bigint;
nr_seq_atividade_ww		bigint;
nm_objeto_pai_w			varchar(255);
nm_objeto_w			varchar(255);
qt_tempo_desenv_minutos_w	double precision;
qt_tempo_desenv_horas_w		double precision;
qt_tempo_desenv_dias_trab_w	double precision;
nr_seq_atividade_www		bigint;

c01 CURSOR FOR
SELECT	a.nm_objeto_pai
from	w_analise_migr_proj a
where	(a.nm_objeto_pai IS NOT NULL AND a.nm_objeto_pai::text <> '')
and	a.ie_objeto = 'TMenuItem'
and	a.cd_funcao = cd_funcao_origem_p
group by
	a.nm_objeto_pai
order by
	a.nm_objeto_pai;

c02 CURSOR FOR
SELECT	a.nm_objeto,
	a.qt_tempo_desenv qt_tempo_desenv_minutos,
	round((dividir(a.qt_tempo_desenv,60))::numeric,2) qt_tempo_desenv_horas,
	round((dividir(dividir(a.qt_tempo_desenv,60),8))::numeric,2) qt_tempo_desenv_dias_trab
from (
	SELECT	a.nm_objeto,
		coalesce(sum(a.qt_tempo_desenv),0) qt_tempo_desenv
	from	w_analise_migr_proj a
	where	(a.nm_objeto_pai IS NOT NULL AND a.nm_objeto_pai::text <> '')
	and	a.ie_objeto = 'TMenuItem'
	and	a.cd_funcao = cd_funcao_origem_p
	and	a.nm_objeto_pai = nm_objeto_pai_w
	group by
		a.nm_objeto
	order by
		a.nm_objeto
	) a
order by
	a.nm_objeto,
	a.qt_tempo_desenv desc;


BEGIN
if (cd_funcao_origem_p IS NOT NULL AND cd_funcao_origem_p::text <> '') and (cd_funcao_destino_p IS NOT NULL AND cd_funcao_destino_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	select	coalesce(max(c.nr_sequencia),0)
	into STRICT	nr_seq_cronograma_w
	from	proj_cronograma c,
		proj_projeto p
	where	c.nr_seq_proj = p.nr_sequencia
	and	c.ie_tipo_cronograma = 'E'
	and	p.cd_funcao = cd_funcao_destino_p;

	if (nr_seq_cronograma_w > 0) then
		begin
		select	coalesce(min(a.nr_sequencia),0),
			coalesce(max(a.nr_seq_apres),0)
		into STRICT	nr_seq_atividade_w,
			nr_seq_apresent_w
		from	proj_cron_etapa a
		where	a.nr_seq_cronograma = nr_seq_cronograma_w
		and	a.ie_tipo_obj_proj_migr = 'TMenuItem';

		if (nr_seq_atividade_w > 0) then
			begin
			open c01;
			loop
			fetch c01 into nm_objeto_pai_w;
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
					nr_seq_superior,
					ie_atividade_adicional)
				values (
					nr_seq_cronograma_w,
					nr_seq_atividade_ww,
					nm_objeto_pai_w,
					'S',
					0,
					0,
					nr_seq_apresent_w,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					'N',
					'TMenuItem',
					nr_seq_atividade_w,
					'S');

				open c02;
				loop
				fetch c02 into	nm_objeto_w,
						qt_tempo_desenv_minutos_w,
						qt_tempo_desenv_horas_w,
						qt_tempo_desenv_dias_trab_w;
				EXIT WHEN NOT FOUND; /* apply on c02 */
					begin
					nr_seq_apresent_w := nr_seq_apresent_w + 10;

					select	nextval('proj_cron_etapa_seq')
					into STRICT	nr_seq_atividade_www
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
						nr_seq_superior,
						ie_atividade_adicional)
					values (
						nr_seq_cronograma_w,
						nr_seq_atividade_www,
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
						'TMenuItem',
						nr_seq_atividade_ww,
						'S');
					CALL atualizar_horas_etapa_cron(nr_seq_atividade_www);
					end;
				end loop;
				close c02;
				CALL atualizar_horas_etapa_cron(nr_seq_atividade_ww);
				end;
			end loop;
			close c01;
			CALL atualizar_horas_etapa_cron(nr_seq_atividade_w);
			end;
		end if;
		CALL atualizar_total_horas_cron(nr_seq_cronograma_w);
		CALL gerar_classif_etapa_proj(nr_seq_cronograma_w, nm_usuario_p);
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
-- REVOKE ALL ON PROCEDURE copiar_cron_migr_adic_menuitem ( cd_funcao_origem_p bigint, cd_funcao_destino_p bigint, nm_usuario_p text) FROM PUBLIC;
