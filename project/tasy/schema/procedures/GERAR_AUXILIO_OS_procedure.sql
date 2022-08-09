-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_auxilio_os ( nr_ordem_servico_p bigint, nr_ordem_fazendo_p bigint, nm_usuario_p text, ie_acao_p text, dt_auxilio_p timestamp ) AS $body$
DECLARE


/*ie_acao_p
	'I' = Iniciar o auxilio na OS
	'T' = Terminar auxilio na OS
*/
ds_retorno_w			varchar(2000);
nr_seq_atividade_w		bigint;
nr_seq_proj_cron_etapa_w	proj_cron_etapa.nr_sequencia%type;
nr_seq_realizada_w		bigint;
nr_seq_ativ_aberta_w		bigint;
nr_seq_ativ_w			bigint;
qt_minuto_real_w		bigint;
nr_seq_grupo_des_w		bigint;
nm_usuario_lider_w		varchar(255);
dt_final_ativ_os_atual_w	timestamp;
ie_executor_w			varchar(1);
nr_seq_tipo_exec_w		bigint;


BEGIN

if (ie_acao_p = 'I') then

	select	max(dt_fim_atividade)
	into STRICT	dt_final_ativ_os_atual_w
	from	man_ordem_serv_ativ
	where	nr_sequencia = (	SELECT	max(nr_sequencia)
								from	man_ordem_serv_ativ
								where	nr_seq_ordem_serv = nr_ordem_fazendo_p
								and		nm_usuario_exec = nm_usuario_p
							);
	
	if (coalesce(dt_final_ativ_os_atual_w::text, '') = '') then
		/* Parar temporariamente a OS que esta sendo feita */

		select	min(a.nr_sequencia)
		into STRICT	nr_seq_proj_cron_etapa_w
		from	man_ordem_ativ_etapa_v a,
				man_ordem_servico b
		where	a.nr_seq_ordem = b.nr_sequencia
		and		a.nr_seq_classif <> 14
		and		b.nr_sequencia = nr_ordem_fazendo_p
		and		b.nr_seq_proj_cron_etapa = a.nr_sequencia;
		
		SELECT * FROM man_finalizar_ativ_iniciada(nr_ordem_fazendo_p, null, null, dt_auxilio_p, nm_usuario_p, 0, 50, 'N', ds_retorno_w, nr_seq_atividade_w, nr_seq_proj_cron_etapa_w) INTO STRICT ds_retorno_w, nr_seq_atividade_w, nr_seq_proj_cron_etapa_w;
	end if;
	
	select	max(nr_seq_grupo_des)
	into STRICT	nr_seq_grupo_des_w
	from	man_ordem_servico
	where	nr_sequencia	= nr_ordem_servico_p;

	select	max(b.nm_usuario_grupo)
	into STRICT	nm_usuario_lider_w
	from	grupo_desenvolvimento a,
		usuario_grupo_des b
	where	a.nr_sequencia	= b.nr_seq_grupo
	and	b.ie_funcao_usuario = 'S'
	and 	a.nr_sequencia	= nr_seq_grupo_des_w;
	
	select	max(nr_sequencia)
	into STRICT	nr_seq_tipo_exec_w
	from 	man_tipo_executor
	where	ie_tipo_executor = 2 -- Acompanhamento de OS
	and		ie_situacao = 'A';
		
	select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
	into STRICT	ie_executor_w
	from	man_ordem_servico_exec
	where	nr_seq_ordem = nr_ordem_servico_p
	and		nm_usuario_exec = nm_usuario_p
	and		nr_seq_tipo_exec = nr_seq_tipo_exec_w
	and		coalesce(dt_fim_execucao::text, '') = '';

	if (ie_executor_w = 'N') then

		/*  Inserir  auxiliar como executor previsto */

		insert into man_ordem_servico_exec(
			nr_sequencia,
			nr_seq_ordem,
			dt_atualizacao,
			nm_usuario,
			nm_usuario_exec,
			qt_min_prev,
			dt_ult_visao,
			nr_seq_funcao,
			dt_recebimento,
			nr_seq_tipo_exec,
			dt_fim_execucao,
			dt_atualizacao_nrec,
			nm_usuario_nrec)
		values (
			nextval('man_ordem_servico_exec_seq'),
			nr_ordem_servico_p,
			clock_timestamp(),
			nm_usuario_p,
			nm_usuario_p,
			1,
			null,
			null,
			dt_auxilio_p,
			nr_seq_tipo_exec_w,
			null,
			clock_timestamp(),
			nm_usuario_p);
	end if;		
	
	/* Prever uma atividade na OS de auxilio - Atividade prevista */

	select	nextval('man_ordem_ativ_prev_seq')
	into STRICT	nr_seq_ativ_w
	;

	insert into man_ordem_ativ_prev(nr_sequencia,
		nr_seq_ordem_serv,
		dt_atualizacao,
		nm_usuario,
		qt_atividade,
		dt_prevista,
		qt_min_prev,
		nm_usuario_prev,
		ie_prioridade_desen,
		nr_seq_ativ_exec)
	values (nr_seq_ativ_w,
		nr_ordem_servico_p,
		clock_timestamp(),
		coalesce(nm_usuario_lider_w,nm_usuario_p),
		1,
		dt_auxilio_p,
		1,
		nm_usuario_p,
		10,
		19); --funcao de testes
	commit;
	/* Iniciar a atividade de auxilio na OS - Atividade realizada */

	select	min(a.nr_sequencia)
	into STRICT	nr_seq_proj_cron_etapa_w
	from	man_ordem_ativ_etapa_v a,
			man_ordem_servico b
	where	a.nr_seq_ordem = b.nr_sequencia
	and		a.nr_seq_classif <> 14
	and		b.nr_sequencia = nr_ordem_servico_p
	and		b.nr_seq_proj_cron_etapa = a.nr_sequencia;
	
	select	nextval('man_ordem_serv_ativ_seq')
	into STRICT	nr_seq_realizada_w
	;

	insert into man_ordem_serv_ativ(nr_sequencia,
		nr_seq_ordem_serv,
		dt_atualizacao,
		nm_usuario,
		dt_atividade,
		nr_seq_funcao,
		qt_minuto,
		nm_usuario_exec,
		nr_seq_ativ_prev,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_proj_cron_etapa,
		nr_seq_grupo_des)
	values (nr_seq_realizada_w,
		nr_ordem_servico_p,
		clock_timestamp(),
		nm_usuario_p,
		dt_auxilio_p,
		132,--funcao de testes
		0,
		nm_usuario_p,
		nr_seq_ativ_w,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_proj_cron_etapa_w,
		obter_grupo_usuario_wheb(nm_usuario_p)
		);

	commit;
else
	select	max(NR_SEQ_ATIV_PREV),
		max(Obter_Min_Entre_Datas(dt_atividade,dt_auxilio_p,1))
	into STRICT	nr_seq_ativ_aberta_w,
		qt_minuto_real_w
	from	man_ordem_serv_ativ
	where	nr_seq_ordem_serv	= nr_ordem_servico_p
	and	nm_usuario_exec	= nm_usuario_p
	and	coalesce(dt_fim_atividade::text, '') = '';

	/*Finalizar a atividade de auxilio iniciada */

	update	man_ordem_ativ_prev
	set	qt_min_prev	= qt_minuto_real_w,
		dt_real		= dt_auxilio_p,
		pr_atividade	= 100
	where	nr_sequencia	= nr_seq_ativ_aberta_w;

	update	man_ordem_serv_ativ
	set	qt_minuto		= qt_minuto_real_w,
		dt_fim_atividade	= dt_auxilio_p
	where	nr_seq_ordem_serv	= nr_ordem_servico_p
	and	nm_usuario_exec	= nm_usuario_p
	and	nr_seq_ativ_prev	= nr_seq_ativ_aberta_w;
	
	select	max(nr_sequencia)
	into STRICT	nr_seq_tipo_exec_w
	from 	man_tipo_executor
	where	ie_tipo_executor = 2 -- Acompanhamento de OS
	and		ie_situacao = 'A';

	update	man_ordem_servico_exec
	set		dt_fim_execucao = clock_timestamp()
	where	nr_seq_ordem = nr_ordem_servico_p
	and		nm_usuario_exec = nm_usuario_p
	and		nr_seq_tipo_exec = nr_seq_tipo_exec_w
	and		coalesce(dt_fim_execucao::text, '') = '';

	commit;

	select	max(NR_SEQ_ATIV_PREV)
	into STRICT	nr_seq_ativ_aberta_w
	from	man_ordem_serv_ativ
	where	nr_seq_ordem_serv	= nr_ordem_fazendo_p
	and	nm_usuario_exec	= nm_usuario_p;

	select	min(a.nr_sequencia)
	into STRICT	nr_seq_proj_cron_etapa_w
	from	man_ordem_ativ_etapa_v a,
			man_ordem_servico b
	where	a.nr_seq_ordem = b.nr_sequencia
	and		a.nr_seq_classif <> 14
	and		b.nr_sequencia = nr_ordem_fazendo_p
	and		b.nr_seq_proj_cron_etapa = a.nr_sequencia;
	
	/* Reiniciar a atividade parada anteriormente*/
		
	select	nextval('man_ordem_serv_ativ_seq')
	into STRICT	nr_seq_realizada_w
	;

	insert into man_ordem_serv_ativ(nr_sequencia,
		nr_seq_ordem_serv,
		dt_atualizacao,
		nm_usuario,
		dt_atividade,
		nr_seq_funcao,
		qt_minuto,
		nm_usuario_exec,
		nr_seq_ativ_prev,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_proj_cron_etapa)
	values (nr_seq_realizada_w,
		nr_ordem_fazendo_p,
		clock_timestamp(),
		nm_usuario_p,
		dt_auxilio_p,
		11,--funcao de programacao
		0,
		nm_usuario_p,
		nr_seq_ativ_aberta_w,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_proj_cron_etapa_w);

	commit;
	
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_auxilio_os ( nr_ordem_servico_p bigint, nr_ordem_fazendo_p bigint, nm_usuario_p text, ie_acao_p text, dt_auxilio_p timestamp ) FROM PUBLIC;
