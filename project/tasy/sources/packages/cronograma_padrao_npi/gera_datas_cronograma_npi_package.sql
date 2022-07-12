-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*---------------------------------------------------------------------------------------------------------------------------------------------
|			GERA_DATAS_CRONOGRAMA_NPI					|
*/
CREATE OR REPLACE PROCEDURE cronograma_padrao_npi.gera_datas_cronograma_npi ( nr_seq_projeto_p bigint, nm_usuario_p text) AS $body$
DECLARE


	nr_seq_etapa_w			proj_cron_etapa.nr_sequencia%type;
	nr_seq_etapa_processo_w	prp_etapa_processo.nr_sequencia%type;
	nr_seq_cronograma_w 	proj_cronograma.nr_sequencia%type;
	nr_seq_cron_etapa_w 	proj_cron_etapa.nr_sequencia%type;
	--qt_hora_prev_w			proj_cron_etapa.qt_hora_prev%type;
	qt_dias_w			proj_cron_etapa.qt_dias%type;
	dt_inicio_w				timestamp;
	dt_fim_prev_w			timestamp;
	nr_seq_tipo_projeto_w	proj_projeto.nr_seq_tipo_projeto%type;

	--Cronogramas do projeto ordenados conforme o mapa do projeto
	C01 CURSOR FOR
		SELECT	nr_sequencia
		from	proj_cronograma
		where	nr_seq_proj = nr_seq_projeto_p
		order by nr_seq_processo_fase;

	--etapas do cronograma que não dependem de nenhuma outra etapa
	C02 CURSOR FOR
		SELECT	a.nr_sequencia
		from	proj_cron_etapa a,
				prp_etapa_processo b
		where	a.nr_seq_etapa_npi = b.nr_sequencia
		and		a.nr_seq_cronograma = nr_seq_cronograma_w
		and	not exists (SELECT	1
						from	prp_etapa_dependencia x,
								proj_cron_etapa y,
								prp_etapa_processo z
						where	x.nr_seq_etapa_principal = b.nr_sequencia
						AND   y.nr_seq_etapa_npi = z.nr_sequencia
						AND x.nr_Seq_etapa_processo = z.nr_sequencia
						and		x.nr_seq_tipo_projeto = nr_seq_tipo_projeto_w
						AND a.nr_seq_cronograma = y.nr_Seq_cronograma);

	
BEGIN

	-- Pega a data inicial prevista do projeto, para o primeiro cronograma/atividades
	select	max(dt_inicio_prev),
			max(nr_seq_tipo_projeto)
	into STRICT	dt_inicio_w,
			nr_seq_tipo_projeto_w
	from	proj_projeto
	where	nr_sequencia = nr_seq_projeto_p;

	open C01;
	loop
	fetch C01 into
		nr_seq_cronograma_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		--Chama as atividades do cronograma
		open C02;
		loop
		fetch C02 into
			nr_seq_cron_etapa_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin

			select	max(qt_dias)
			into STRICT	qt_dias_w
			from	proj_cron_etapa
			where	nr_sequencia = nr_seq_cron_etapa_w;

			dt_fim_prev_w := dt_inicio_w + (qt_dias_w) -1;

			if (pkg_date_utils.get_WeekDay(dt_fim_prev_w) = 7) then
				dt_fim_prev_w := dt_fim_prev_w+2;
			elsif (pkg_date_utils.get_WeekDay(dt_fim_prev_w) = 1) then
				dt_fim_prev_w := dt_fim_prev_w+1;
			end if;

			update	proj_cron_etapa
			set		dt_inicio_prev = dt_inicio_w,
					dt_fim_prev = OBTER_DATA_DIAS_UTEIS(1,dt_inicio_w,(qt_dias_w)-1)
			where	nr_sequencia = nr_seq_cron_etapa_w;

			commit;

			--verifica etapas dependentes
			CALL cronograma_padrao_npi.gerar_datas_etapas_dep(nr_seq_cron_etapa_w,nm_usuario_p);

			end;
		end loop;
		close C02;

		select	max(dt_fim_prev)+1
		into STRICT	dt_inicio_w
		from	proj_cron_etapa
		where	nr_seq_cronograma = nr_seq_cronograma_w;

		CALL cronograma_padrao_npi.seta_dt_inicio_fim(nr_seq_cronograma_w,nm_usuario_p);

		end;
	end loop;
	close C01;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cronograma_padrao_npi.gera_datas_cronograma_npi ( nr_seq_projeto_p bigint, nm_usuario_p text) FROM PUBLIC;