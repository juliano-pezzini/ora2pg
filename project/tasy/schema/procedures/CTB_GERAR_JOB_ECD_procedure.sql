-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_job_ecd ( nm_usuario_p text, nr_seq_controle_p ctb_sped_controle.nr_sequencia%type ) AS $body$
DECLARE


ie_status_arquivo_w varchar(255);
nr_sid_w varchar(255);
nr_serial_w varchar(255);
job_name_w varchar(255);
enabled_w varchar(255);
state_w varchar(255);
start_date_w timestamp;
qt_registros_w bigint;
ds_action_w  varchar(1000);
comments_w varchar(255);
nr_seq_regra_sped_w	ctb_sped_controle.nr_seq_regra_sped%type;

BEGIN
/* Gerar a job para processar a ECD */

job_name_w := 'ECD_GERAR_'||nr_seq_controle_p;
comments_w := 'Geracao do arquivo ECD sequencia: '||nr_seq_controle_p;
ds_action_w := 'begin CTB_GERAR_ARQUIVO_ECD_JOB('''|| nm_usuario_p ||''', '||nr_seq_controle_p||'); end;';

/*
IE_STATUS_ARQUIVO = X - Nao processado
IE_STATUS_ARQUIVO = C - Criado
IE_STATUS_ARQUIVO = P - Processando
IE_STATUS_ARQUIVO = G - Gerado
IE_STATUS_ARQUIVO = F - Finalizado
IE_STATUS_ARQUIVO = E - Erro
*/
select  coalesce(ie_status_arquivo,'X'),
		nr_sid,
		nr_serial,
		nr_seq_regra_sped
into STRICT    ie_status_arquivo_w,
		nr_sid_w,
		nr_serial_w,
		nr_seq_regra_sped_w
from    ctb_sped_controle a
where   nr_sequencia = nr_seq_controle_p;

/* Limpa as notificacoes da ECD do controle que esta sendo gerado */

delete
from notificacoes
where cd_grupo_notificacao = 'arquivo-ecd'
and ds_conteudo like '%[' || nr_seq_regra_sped_w || '/' || nr_seq_controle_p || ']%';

-- verificar se a job esta em execucao
select  max(enabled), -- se esta ativa ou nao
		max(state), -- o estado atual(agendada, completa)
		max(start_date) -- data para execucao
into STRICT    enabled_w,
		state_w,
		start_date_w
from    user_scheduler_jobs a
where   a.job_name = job_name_w;

if (ie_status_arquivo_w not in ('E','F','X') or (enabled_w IS NOT NULL AND enabled_w::text <> '')) then
	-- se a job nao esta em execucao verificar se a sessao ainda esta ativa
	select  count(1)
	into STRICT    qt_registros_w
	from    v$session a
	where   a.sid = nr_sid_w
	and     a.serial# = nr_serial_w;

	if (qt_registros_w > 0 or (enabled_w IS NOT NULL AND enabled_w::text <> '')) then
		/* Ja existe processo de geracao do arquivo da ECD para o registro de controle: #@NR_SEQ_CONTROLE#@
			Status do job:
			enable: #@DS_ENABLE#@
			state: #@DS_STATE#@
			start_date: #@DS_START_DATE#@ */
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1157341, 'NR_SEQ_CONTROLE=' || nr_seq_controle_p || ';' ||
			'DS_ENABLE=' ||enabled_w || ';' ||
			'DS_STATE=' ||state_w || ';' ||
			'DS_START_DATE=' ||to_char(start_date_w,'dd/mm/yyyy hh24:mi:ss'));
	end if;

end if;

update  ctb_sped_controle a
set     ie_status_arquivo = 'C',
		ds_job_name = job_name_w,
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p,
		ds_informacao  = NULL
where   nr_sequencia = nr_seq_controle_p;

dbms_scheduler.create_job(job_name   => job_name_w,
						 job_type   => 'PLSQL_BLOCK',
						 job_action => ds_action_w,
						 start_date => clock_timestamp() + interval '3 days' / 86400, -- 3 seg depois de sysdate
						 auto_drop  => TRUE,
						 enabled    => TRUE,
						 comments   => comments_w);

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_job_ecd ( nm_usuario_p text, nr_seq_controle_p ctb_sped_controle.nr_sequencia%type ) FROM PUBLIC;
