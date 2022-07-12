-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_visita_tecnica_prest_pck.iniciar_visita ( nr_seq_visita_p pls_visita_tecnica.nr_sequencia%type, dt_inicio_visita_p pls_visita_tecnica_hist.dt_inicio_visita%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) AS $body$
DECLARE


nr_seq_historico_w	pls_visita_tecnica_hist.nr_sequencia%type;
dt_sugerida_visita_w	pls_visita_tecnica_hist.dt_sugerida_visita%type;


BEGIN

begin
select	nr_sequencia,
	dt_sugerida_visita
into STRICT	nr_seq_historico_w,
	dt_sugerida_visita_w
from	pls_visita_tecnica_hist
where	nr_seq_visita		= nr_seq_visita_p
and	ie_status_agendamento	= 2;
exception
when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1209927);
end;

update	pls_visita_tecnica_hist
set	ie_status_agendamento	= 5,
	dt_inicio_visita	= dt_inicio_visita_p,
	dt_atualizacao		=clock_timestamp(),
	nm_usuario		= nm_usuario_p
where	nr_sequencia		= nr_seq_historico_w;

update	pls_visita_tecnica
set	ie_status		= 6,
	dt_atualizacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p
where	nr_sequencia		= nr_seq_visita_p;

CALL CALL pls_visita_tecnica_prest_pck.gravar_log_sistema(	nr_seq_visita_p	=> nr_seq_visita_p,
				ie_tipo_log_p	=> 7,
				ds_log_p	=> wheb_mensagem_pck.get_texto(1209938,'DT_AGENDAMENTO='||to_char(dt_sugerida_visita_w,'dd/mm/yyyy hh24:mi')),
				nm_usuario_p	=> nm_usuario_p,
				ie_commit_p	=> 'N');

CALL CALL pls_visita_tecnica_prest_pck.gerar_alerta_evento(	nr_seq_visita_p		=> nr_seq_visita_p,
			ie_tipo_processo_p	=> 5,
			nm_usuario_p		=> nm_usuario_p,
			ie_commit_p		=> 'N');

if (ie_commit_p = 'S') then
	commit;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_visita_tecnica_prest_pck.iniciar_visita ( nr_seq_visita_p pls_visita_tecnica.nr_sequencia%type, dt_inicio_visita_p pls_visita_tecnica_hist.dt_inicio_visita%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) FROM PUBLIC;
