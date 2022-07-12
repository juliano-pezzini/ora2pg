-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*---------------------------------------------------------------------------------------------------------------------------------------------
|			SETA_DT_INICIO_FIM					|
*/
CREATE OR REPLACE PROCEDURE cronograma_padrao_npi.seta_dt_inicio_fim ( nr_seq_cron_p bigint, nm_usuario_p text) AS $body$
DECLARE


	min_dt_inicio_w		timestamp;
	max_dt_fim_w		timestamp;
	nr_seq_proj_w		bigint;
	qt_hora_prev_w		proj_cron_etapa.qt_hora_prev%type;

	
BEGIN

	select	max(nr_seq_proj)
	into STRICT	nr_seq_proj_w
	from	proj_cronograma
	where	nr_sequencia = nr_seq_cron_p;

	-- menor data de inicio e maior data fim
	select	min(dt_inicio_prev),
			max(dt_fim_prev),
			sum(qt_hora_prev)
	into STRICT	min_dt_inicio_w,
			max_dt_fim_w,
			qt_hora_prev_w
	from	proj_cron_etapa
	where	nr_seq_cronograma = nr_seq_cron_p
	and		(dt_inicio_prev IS NOT NULL AND dt_inicio_prev::text <> '')
	and		(dt_fim_prev IS NOT NULL AND dt_fim_prev::text <> '');

	--seta no cronograma atual a menor data de inicio das etapas e a maior data de fim
	update	proj_cronograma
	set		dt_inicio = coalesce(min_dt_inicio_w,clock_timestamp()),
			dt_fim = coalesce(max_dt_fim_w,clock_timestamp()),
			nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp(),
			qt_total_horas = qt_hora_prev_w
	where	nr_sequencia = nr_seq_cron_p;

	--busca a menor data de inicio dos cronogramas do projeto e a maior data de fim
	select	min(dt_inicio),
			max(dt_fim)
	into STRICT	min_dt_inicio_w,
			max_dt_fim_w
	from	proj_cronograma
	where	nr_seq_proj = nr_seq_proj_w;

	--atualiza o projeto com as datas conforme as datas dos cronogramas
	update	proj_projeto
	set		dt_inicio_prev = min_dt_inicio_w,
			dt_fim_prev = max_dt_fim_w,
			nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp()
	where	nr_sequencia = nr_seq_proj_w;

	commit;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cronograma_padrao_npi.seta_dt_inicio_fim ( nr_seq_cron_p bigint, nm_usuario_p text) FROM PUBLIC;
