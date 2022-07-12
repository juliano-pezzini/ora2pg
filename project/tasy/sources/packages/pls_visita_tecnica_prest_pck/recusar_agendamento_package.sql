-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_visita_tecnica_prest_pck.recusar_agendamento ( nr_seq_historico_p pls_visita_tecnica_hist.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ds_observacao_recusa_p pls_visita_tecnica_hist.ds_observacao_recusa%type) AS $body$
DECLARE

nr_seq_visita_w		pls_visita_tecnica_hist.nr_seq_visita%type;
dt_sugerida_visita_w	pls_visita_tecnica_hist.dt_sugerida_visita%type;

BEGIN

begin
select	nr_seq_visita,
	dt_sugerida_visita
into STRICT	nr_seq_visita_w,
	dt_sugerida_visita_w
from	pls_visita_tecnica_hist
where	nr_sequencia	= nr_seq_historico_p;
exception
when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1207549); --Registro invalido
end;

update	pls_visita_tecnica_hist
set	ie_status_agendamento	= 3,
	dt_atualizacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p,
	ds_observacao_recusa	= ds_observacao_recusa_p
where	nr_sequencia		= nr_seq_historico_p;

update	pls_visita_tecnica
set	ie_status	= 1,
	dt_visita	 = NULL,
	dt_atualizacao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p
where	nr_sequencia	= nr_seq_visita_w;

CALL CALL pls_visita_tecnica_prest_pck.gravar_log_sistema(	nr_seq_visita_p	=> nr_seq_visita_w,
				ie_tipo_log_p	=> 5,
				ds_log_p	=> wheb_mensagem_pck.get_texto(1207817,'DT_AGENDAMENTO='||to_char(dt_sugerida_visita_w,'dd/mm/yyyy hh24:mi')),
				nm_usuario_p	=> nm_usuario_p,
				ie_commit_p	=> 'N');

CALL CALL pls_visita_tecnica_prest_pck.gerar_alerta_evento(	nr_seq_visita_p		=> nr_seq_visita_w,
			ie_tipo_processo_p	=> 3,
			nm_usuario_p		=> nm_usuario_p,
			ie_commit_p		=> 'N');

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_visita_tecnica_prest_pck.recusar_agendamento ( nr_seq_historico_p pls_visita_tecnica_hist.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ds_observacao_recusa_p pls_visita_tecnica_hist.ds_observacao_recusa%type) FROM PUBLIC;