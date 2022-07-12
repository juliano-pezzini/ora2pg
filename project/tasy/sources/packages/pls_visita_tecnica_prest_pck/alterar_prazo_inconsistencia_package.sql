-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_visita_tecnica_prest_pck.alterar_prazo_inconsistencia ( nr_seq_inconsistencia_p pls_visita_tecnica_inco.nr_sequencia%type, dt_novo_prazo_p pls_visita_tecnica_inco.dt_limite%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) AS $body$
DECLARE

nr_seq_visita_w		pls_visita_tecnica_inco.nr_seq_visita%type;
ds_inconsistencia_w	pls_visita_tecnica_inco.ds_inconsistencia%type;
dt_prazo_anterior_w	pls_visita_tecnica_inco.dt_limite%type;

BEGIN

if (coalesce(dt_novo_prazo_p::text, '') = '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1211068); --Novo prazo nao informado
end if;

begin
select	nr_seq_visita,
	ds_inconsistencia,
	dt_limite
into STRICT	nr_seq_visita_w,
	ds_inconsistencia_w,
	dt_prazo_anterior_w
from	pls_visita_tecnica_inco
where	nr_sequencia	= nr_seq_inconsistencia_p;
exception
when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1207549); --Registro invalido
end;

if (trunc(dt_prazo_anterior_w,'dd') = trunc(dt_novo_prazo_p,'dd')) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1211082); --O novo prazo informado deve ser diferente do prazo atual
end if;

update	pls_visita_tecnica_inco
set	dt_limite	= dt_novo_prazo_p,
	dt_atualizacao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p
where	nr_sequencia	= nr_seq_inconsistencia_p;

CALL CALL pls_visita_tecnica_prest_pck.gravar_log_sistema(	nr_seq_visita_p	=> nr_seq_visita_w,
				ie_tipo_log_p	=> 12,
				ds_log_p	=> wheb_mensagem_pck.get_texto(1211069,'DT_PRAZO_ANTERIOR='||to_char(dt_prazo_anterior_w,'dd/mm/yyyy')||';DT_NOVO_PRAZO='||to_char(dt_novo_prazo_p,'dd/mm/yyyy')||';DS_INCONSISTENCIA='||ds_inconsistencia_w),
				nm_usuario_p	=> nm_usuario_p,
				ie_commit_p	=> 'N');

CALL CALL pls_visita_tecnica_prest_pck.gerar_alerta_evento(	nr_seq_visita_p		=> nr_seq_visita_w,
			ie_tipo_processo_p	=> 11,
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
-- REVOKE ALL ON PROCEDURE pls_visita_tecnica_prest_pck.alterar_prazo_inconsistencia ( nr_seq_inconsistencia_p pls_visita_tecnica_inco.nr_sequencia%type, dt_novo_prazo_p pls_visita_tecnica_inco.dt_limite%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) FROM PUBLIC;
