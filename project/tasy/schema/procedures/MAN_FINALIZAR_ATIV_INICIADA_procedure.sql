-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_finalizar_ativ_iniciada ( nr_seq_ordem_p bigint, ds_atividade_p text, ds_observacao_p text, dt_fim_atividade_p timestamp, nm_usuario_p text, pr_realizacao_migr_p bigint, pr_realizacao_os_p bigint, ie_finalizar_ativ_prev_p text, ds_retorno_p INOUT text, nr_seq_atividade_p INOUT bigint, nr_seq_proj_cron_etapa_p INOUT bigint) AS $body$
DECLARE


nr_seq_atividade_w			bigint;
nr_seq_proj_cron_etapa_w		bigint;
ds_inicio_atividade_w		varchar(30);
nr_seq_ativ_prev_w		bigint;
dt_atividade_w			timestamp;
dt_inicio_atividade_w		timestamp;


BEGIN
ds_retorno_p	:= null;
if (nr_seq_ordem_p IS NOT NULL AND nr_seq_ordem_p::text <> '') and (dt_fim_atividade_p IS NOT NULL AND dt_fim_atividade_p::text <> '') then

	select	max(nr_sequencia),
		MAX(dt_atividade)
	into STRICT	nr_seq_atividade_w,
		dt_inicio_atividade_w
	from	man_ordem_serv_ativ
	where	nr_seq_ordem_serv	= nr_seq_ordem_p
	and	nm_usuario_exec		= nm_usuario_p;


	if (dt_inicio_atividade_w > dt_fim_atividade_p) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(294560);
	end if;

	if (nr_seq_atividade_w IS NOT NULL AND nr_seq_atividade_w::text <> '') then
		select	max(nr_seq_proj_cron_etapa),
			to_char(max(dt_atividade),'dd/mm/yyyy hh24:mi:ss'),
			max(dt_atividade)
		into STRICT	nr_seq_proj_cron_etapa_w,
			ds_inicio_atividade_w,
			dt_atividade_w
		from	man_ordem_serv_ativ a
		where	nr_sequencia	= nr_seq_atividade_w;

		if (trunc(dt_atividade_w,'dd') <> trunc(dt_fim_atividade_p,'dd')) then
			begin
			CALL wheb_mensagem_pck.exibir_mensagem_abort(249386,'DT_ATIVIDADE_W=' || to_char(dt_atividade_w,'dd/mm/yyyy') || ';' || 'DT_FIM_ATIVIDADE_P=' || to_char(dt_fim_atividade_p,'dd/mm/yyyy'));
			end;
		end if;

		update	man_ordem_serv_ativ
		set	dt_fim_atividade	= dt_fim_atividade_p,
			qt_minuto		= obter_min_entre_datas(dt_atividade,dt_fim_atividade_p,null),
			qt_minuto_cobr		= obter_min_entre_datas(dt_atividade,dt_fim_atividade_p,null),
			ds_atividade		= substr(CASE WHEN ds_atividade = NULL THEN ds_atividade_p  ELSE ds_atividade ||								chr(13) || chr(10) || ds_atividade_p END ,1,2000),
			ds_observacao		= substr(CASE WHEN ds_observacao = NULL THEN ds_observacao_p  ELSE substr(ds_observacao || ds_observacao_p,1,4000) END ,1,4000),
			dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p
		where	nr_sequencia		= nr_seq_atividade_w;

		select	max(a.nr_seq_ativ_prev)
		into STRICT	nr_seq_ativ_prev_w
		from	man_ordem_serv_ativ a
		where	a.nr_sequencia	= nr_seq_atividade_w;

		if (nr_seq_ativ_prev_w IS NOT NULL AND nr_seq_ativ_prev_w::text <> '') then

			if (coalesce(pr_realizacao_os_p,0) = 0) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(252505);
			end if;


			update	man_ordem_ativ_prev
			set	PR_ATIVIDADE	= pr_realizacao_os_p
			where	nr_sequencia	= nr_seq_ativ_prev_w;
		end if;


		if (nr_seq_proj_cron_etapa_w IS NOT NULL AND nr_seq_proj_cron_etapa_w::text <> '') then
			CALL man_ordem_atual_horas_cron(nr_seq_atividade_w,nr_seq_proj_cron_etapa_w,nm_usuario_p);

			if (pr_realizacao_migr_p IS NOT NULL AND pr_realizacao_migr_p::text <> '') then
				CALL atualizar_realizacao_ativ_proj(nr_seq_proj_cron_etapa_w, pr_realizacao_migr_p, nm_usuario_p);
			end if;
		end if;

		if (ie_finalizar_ativ_prev_p = 'S') then


			if (nr_seq_ativ_prev_w IS NOT NULL AND nr_seq_ativ_prev_w::text <> '') then
				update	man_ordem_ativ_prev
				set	dt_real	= clock_timestamp(),
					nm_usuario = nm_usuario_p,
					dt_atualizacao = clock_timestamp(),
					PR_ATIVIDADE	= pr_realizacao_os_p
				where	nr_sequencia	= nr_seq_ativ_prev_w;
			end if;
		end if;

		ds_retorno_p	:= wheb_mensagem_pck.get_texto(326293, 'DS_INICIO_ATIV=' || ds_inicio_atividade_w);

		commit;
	end if;
end if;

nr_seq_atividade_p		:=	nr_seq_atividade_w;
nr_seq_proj_cron_etapa_p	:=	nr_seq_proj_cron_etapa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_finalizar_ativ_iniciada ( nr_seq_ordem_p bigint, ds_atividade_p text, ds_observacao_p text, dt_fim_atividade_p timestamp, nm_usuario_p text, pr_realizacao_migr_p bigint, pr_realizacao_os_p bigint, ie_finalizar_ativ_prev_p text, ds_retorno_p INOUT text, nr_seq_atividade_p INOUT bigint, nr_seq_proj_cron_etapa_p INOUT bigint) FROM PUBLIC;
