-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_visita_tecnica_prest_pck.encerrar_visita ( nr_seq_visita_p pls_visita_tecnica.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) AS $body$
DECLARE

nr_count_w		integer;
nr_seq_creden_w		pls_creden_prestador.nr_sequencia%type;
nr_seq_classificacao_w	pls_visita_tecnica.nr_seq_classificacao%type;


BEGIN

select	count(*)
into STRICT	nr_count_w
from	pls_visita_tecnica_form
where	nr_seq_visita	= nr_seq_visita_p
and	ie_situacao	= 'A'
and	ie_status	<> 3;

if (nr_count_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1209798); --Ha formulario(s) pendente(s). Favor verificar
end if;

select	count(*)
into STRICT	nr_count_w
from	pls_visita_tecnica_hist
where	nr_seq_visita	= nr_seq_visita_p
and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');

if (nr_count_w = 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1209800); --A visita tecnica nao pode ser finalizada sem historico(s)
end if;

select	count(*)
into STRICT	nr_count_w
from	pls_visita_tecnica_inco
where	nr_seq_visita	= nr_seq_visita_p
and	ie_status not in (4,5);

if (nr_count_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1211346); --Nao e possivel encerrar a visita com inconsistencia(s) pendente(s)
end if;

select	max(nr_seq_classificacao)
into STRICT	nr_seq_classificacao_w
from	pls_visita_tecnica_form
where	nr_seq_visita	= nr_seq_visita_p
and	ie_responsavel	= 'O'
and	ie_situacao	= 'A';

update	pls_visita_tecnica
set	ie_status		= 4,
	dt_encerramento		= clock_timestamp(),
	nr_seq_classificacao	= nr_seq_classificacao_w,
	dt_atualizacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p
where	nr_sequencia		= nr_seq_visita_p;

-- Verifica se a visita esta vinculada a um credenciamento e status igual a 8
begin
select	a.nr_seq_credenciamento
into STRICT	nr_seq_creden_w
from	pls_visita_tecnica a,
	pls_creden_prestador b
where	b.nr_sequencia	= a.nr_seq_credenciamento
and	a.nr_sequencia	= nr_seq_visita_p
and	b.ie_status	= 8;
exception
when others then
	nr_seq_creden_w := null;
end;

if (nr_seq_creden_w IS NOT NULL AND nr_seq_creden_w::text <> '') then
	update	pls_creden_prestador
	set	ie_status	= 2,
		dt_atualizacao	=clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_seq_creden_w;
end if;

CALL CALL pls_visita_tecnica_prest_pck.gravar_log_sistema(	nr_seq_visita_p	=> nr_seq_visita_p,
				ie_tipo_log_p	=> 11,
				ds_log_p	=> wheb_mensagem_pck.get_texto(1210995),
				nm_usuario_p	=> nm_usuario_p,
				ie_commit_p	=> 'N');

CALL CALL pls_visita_tecnica_prest_pck.gerar_alerta_evento(	nr_seq_visita_p		=> nr_seq_visita_p,
			ie_tipo_processo_p	=> 7,
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
-- REVOKE ALL ON PROCEDURE pls_visita_tecnica_prest_pck.encerrar_visita ( nr_seq_visita_p pls_visita_tecnica.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) FROM PUBLIC;
