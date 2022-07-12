-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_visita_tecnica_prest_pck.cancelar_agendamento ( nr_seq_historico_p pls_visita_tecnica_hist.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

nr_seq_visita_w		pls_visita_tecnica_hist.nr_seq_visita%type;
dt_sugerida_visita_w	pls_visita_tecnica_hist.dt_sugerida_visita%type;
nr_count_w		integer;
ie_status_w		pls_visita_tecnica.ie_status%type;

BEGIN

begin
select	nr_seq_visita,
	dt_sugerida_visita
into STRICT	nr_seq_visita_w,
	dt_sugerida_visita_w
from	pls_visita_tecnica_hist
where	nr_sequencia = nr_seq_historico_p;
exception
when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1207549); --Registro invalido
end;

update	pls_visita_tecnica_hist
set	ie_status_agendamento	= 4,
	dt_atualizacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p
where	nr_sequencia		= nr_seq_historico_p;

-- Verifica se existe algum historico com status = Visita Realizada
select	count(*)
into STRICT	nr_count_w
from	pls_visita_tecnica_hist
where	ie_status_agendamento	= 6
and	nr_seq_visita		= nr_seq_visita_w;

if (nr_count_w > 0) then
	ie_status_w := 7;
else
	ie_status_w := 1;
end if;

update	pls_visita_tecnica
set	ie_status	= ie_status_w,
	dt_visita	 = NULL,
	dt_atualizacao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p
where	nr_sequencia	= nr_seq_visita_w;

CALL CALL pls_visita_tecnica_prest_pck.gravar_log_sistema(	nr_seq_visita_p	=> nr_seq_visita_w,
				ie_tipo_log_p	=> 6,
				ds_log_p	=> wheb_mensagem_pck.get_texto(1207818,'DT_AGENDAMENTO='||to_char(dt_sugerida_visita_w,'dd/mm/yyyy hh24:mi')),
				nm_usuario_p	=> nm_usuario_p,
				ie_commit_p	=> 'N');

CALL CALL pls_visita_tecnica_prest_pck.gerar_alerta_evento(	nr_seq_visita_p		=> nr_seq_visita_w,
			ie_tipo_processo_p	=> 4,
			nm_usuario_p		=> nm_usuario_p,
			ie_commit_p		=> 'N');

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_visita_tecnica_prest_pck.cancelar_agendamento ( nr_seq_historico_p pls_visita_tecnica_hist.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;