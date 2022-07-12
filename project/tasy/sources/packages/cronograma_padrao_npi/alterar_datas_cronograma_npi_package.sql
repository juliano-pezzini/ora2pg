-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*---------------------------------------------------------------------------------------------------------------------------------------------
|			ALTERA DATA DE INICIO DO CRONOGRAMA NPI						|
*/
CREATE OR REPLACE PROCEDURE cronograma_padrao_npi.alterar_datas_cronograma_npi ( nr_seq_cronograma_p bigint, dt_inicio_p timestamp, ds_justificativa_p text, nm_usuario_p text) AS $body$
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
nr_seq_cliente_w		proj_projeto.nr_seq_cliente%type;
nr_seq_projeto_w		proj_projeto.nr_sequencia%type;

--Cronogramas do projeto ordenados conforme o mapa do projeto
C01 CURSOR FOR
	SELECT	nr_sequencia
	from	proj_cronograma
	where	nr_seq_proj = nr_seq_projeto_w
	and		nr_sequencia >= nr_seq_cronograma_p
	and		(nr_seq_processo_fase IS NOT NULL AND nr_seq_processo_fase::text <> '')
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

if (coalesce(ds_justificativa_p::text, '') = '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(310927);
end if;

-- Pega a data inicial prevista do projeto, para o primeiro cronograma/atividades
select	max(a.nr_seq_tipo_projeto),
		max(a.nr_seq_cliente),
		max(a.nr_sequencia)
into STRICT	nr_seq_tipo_projeto_w,
		nr_seq_cliente_w,
		nr_seq_projeto_w
from	proj_projeto a,
		proj_cronograma b
where	a.nr_sequencia = b.nr_seq_proj
and		b.nr_sequencia = nr_seq_cronograma_p;


insert into com_cliente_hist(
		nr_sequencia,
		nr_seq_cliente,
		dt_atualizacao,
		nm_usuario,
		nr_seq_tipo,
		dt_historico,
		ds_historico,
		nr_seq_projeto,
		ds_titulo,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		dt_liberacao)
values (nextval('com_cliente_hist_seq'),
		nr_seq_cliente_w,
		clock_timestamp(),
		nm_usuario_p,
		38,
		clock_timestamp(),
		substr('Realizada a alteração da data de início do cronograma '|| nr_seq_cronograma_p ||' para '||to_char(dt_inicio_p,'dd/mm/yyyy')||chr(13)||chr(10)||
		'Justificativa: '||ds_justificativa_p,1,2000),
		nr_seq_projeto_w,
		'Alteração de data do cronograma',
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp());
commit;

dt_inicio_w := dt_inicio_p;

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
-- REVOKE ALL ON PROCEDURE cronograma_padrao_npi.alterar_datas_cronograma_npi ( nr_seq_cronograma_p bigint, dt_inicio_p timestamp, ds_justificativa_p text, nm_usuario_p text) FROM PUBLIC;
