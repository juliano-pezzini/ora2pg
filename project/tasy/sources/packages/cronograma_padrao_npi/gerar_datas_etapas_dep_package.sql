-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*---------------------------------------------------------------------------------------------------------------------------------------------
|			GERAR_DATAS_ETAPAS_DEP										|
*/
CREATE OR REPLACE PROCEDURE cronograma_padrao_npi.gerar_datas_etapas_dep ( nr_seq_etapa_cron_p bigint, nm_usuario_p text) AS $body$
DECLARE


	nr_seq_etapa_npi_w	proj_cron_etapa.nr_seq_etapa_npi%type;
	nr_seq_etapa_cron_w	proj_cron_etapa.nr_sequencia%type;
	nr_seq_cronograma_w	proj_cron_etapa.nr_seq_cronograma%type;
	dt_fim_prev_w		timestamp;
	dt_inicio_prev_w	timestamp;
	dt_fim_w			timestamp;
	qt_hora_prev_w		proj_cron_etapa.qt_hora_prev%type;
	qt_dias_w			proj_cron_etapa.qt_dias%type;
	nr_seq_proj_w		proj_projeto.nr_sequencia%type;
	nr_seq_tipo_projeto_w	proj_projeto.nr_seq_tipo_projeto%type;

	C01 CURSOR FOR
		SELECT	a.nr_sequencia
		from	proj_cron_etapa a,
				prp_etapa_processo b
		where	a.nr_seq_etapa_npi = b.nr_sequencia
		and		a.nr_seq_cronograma = nr_seq_cronograma_w
		and	exists (SELECT	1
						from	prp_etapa_dependencia x,
								proj_cron_etapa y,
								prp_etapa_processo z
						where	x.nr_seq_etapa_principal = b.nr_sequencia
						AND		x.nr_Seq_etapa_processo = z.nr_sequencia
						AND		y.nr_seq_etapa_npi = z.nr_sequencia
						and		y.nr_seq_etapa_npi = nr_seq_etapa_npi_w
						and		x.nr_seq_tipo_projeto = nr_seq_tipo_projeto_w
						AND		a.nr_seq_cronograma = y.nr_Seq_cronograma);

	
BEGIN

		select	max(nr_seq_etapa_npi),
				max(dt_fim_prev),
				max(nr_seq_cronograma)
		into STRICT	nr_seq_etapa_npi_w,
				dt_fim_prev_w,
				nr_seq_cronograma_w
		from	proj_cron_etapa
		where	nr_sequencia = nr_seq_etapa_cron_p;

		select	max(a.nr_sequencia),
				max(a.nr_seq_tipo_projeto)
		into STRICT	nr_seq_proj_w,
				nr_seq_tipo_projeto_w
		from	proj_projeto a,
				proj_cronograma b
		where	a.nr_sequencia = b.nr_seq_proj
		and		b.nr_sequencia = nr_seq_cronograma_w;


		open C01;
		loop
		fetch C01 into
			nr_seq_etapa_cron_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin

			select	max(qt_dias)
			into STRICT	qt_dias_w
			from	proj_cron_etapa
			where	nr_sequencia = nr_seq_etapa_cron_w;

			dt_inicio_prev_w := dt_fim_prev_w+1;

			if (pkg_date_utils.get_WeekDay(dt_inicio_prev_w) = 7) then
				dt_inicio_prev_w := dt_inicio_prev_w+2;
			elsif (pkg_date_utils.get_WeekDay(dt_inicio_prev_w) = 1) then
				dt_inicio_prev_w := dt_inicio_prev_w+1;
			end if;

			dt_fim_w := trunc(dt_fim_prev_w + round((qt_dias_w)::numeric,0));

			if (pkg_date_utils.get_WeekDay(dt_fim_w) = 7) then
				dt_fim_w := dt_fim_w+2;
			elsif (pkg_date_utils.get_WeekDay(dt_fim_w) = 1) then
				dt_fim_w := dt_fim_w+1;
			end if;

			update	proj_cron_etapa
			set		dt_inicio_prev = dt_inicio_prev_w,
					dt_fim_prev = OBTER_DATA_DIAS_UTEIS(1,dt_inicio_prev_w,round((qt_dias_w)::numeric,0)-1)
			where	nr_sequencia = nr_seq_etapa_cron_w;

			commit;

			CALL cronograma_padrao_npi.gerar_datas_etapas_dep(nr_seq_etapa_cron_w,nm_usuario_p);

			end;
		end loop;
		close C01;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cronograma_padrao_npi.gerar_datas_etapas_dep ( nr_seq_etapa_cron_p bigint, nm_usuario_p text) FROM PUBLIC;