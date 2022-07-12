-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Atualizar o status da conta e do lote, para identificar se ficou com inconsistncias



CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.atualizar_status_lote ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


qt_inconsistencia_w 	integer;
qt_registros_w		integer;
nr_seq_processo_w	pls_monitor_tempo_lote.nr_sequencia%type;

C01 CURSOR( nr_seq_lote_pc		pls_monitor_tiss_lote.nr_sequencia%type	) FOR
	SELECT	nr_sequencia
	from	pls_monitor_tiss_cta_val
	where	nr_seq_lote_monitor = nr_seq_lote_pc;

BEGIN
nr_seq_processo_w := pls_gerencia_envio_ans_pck.grava_log_tempo_processo(	nr_seq_lote_p, 'Atualizando status do lote', 'I', nm_usuario_p, nr_seq_processo_w);

--Percorre as contas e atualiza o status

for	r_C01_w in C01( nr_seq_lote_p ) loop

	select	count(1)
	into STRICT	qt_inconsistencia_w
	from	pls_monitor_tiss_inc_val a,
		pls_monitor_tiss_inc b
	where	a.cd_inconsistencia = b.cd_inconsistencia
	and	a.nr_seq_cta_val = r_C01_w.nr_sequencia
	and	b.ie_tipo_inconsistencia <> 'SI'  LIMIT 1;

	if ( qt_inconsistencia_w > 0 ) then
		update 	pls_monitor_tiss_cta_val
		set	ie_status = 'PI',
			dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p
		where	nr_sequencia = r_C01_w.nr_sequencia;
	else
		update 	pls_monitor_tiss_cta_val
		set	ie_status = 'LE',
			dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p
		where	nr_sequencia = r_C01_w.nr_sequencia;
	end if;
end loop;

select	count(1)
into STRICT	qt_inconsistencia_w
from	pls_monitor_tiss_cta_val
where	nr_seq_lote_monitor = nr_seq_lote_p
and	ie_status = 'PI'  LIMIT 1;

--Se existir inconsistncias nas contas do lote, o lote ficar com o Status 'Possui inconsistncia', caso contrrio ficar liberado para gerao do arquivo

if ( qt_inconsistencia_w > 0 ) then
	update 	pls_monitor_tiss_lote
	set	ie_status = 'PI',
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_seq_lote_p;
else
	update 	pls_monitor_tiss_lote
	set	ie_status = 'LE',
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_seq_lote_p;
end if;

--aaschlote 14/04/2015 OS 871474

CALL pls_atualizar_lote_monit_tiss(nr_seq_lote_p);

-- Atualizar os valores totais do lote

CALL pls_gerencia_envio_ans_pck.atualiza_valores_totais_lote(	nr_seq_lote_p, nm_usuario_p, 'A');

commit;

nr_seq_processo_w := pls_gerencia_envio_ans_pck.grava_log_tempo_processo(	null, null, 'F', null, nr_seq_processo_w);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.atualizar_status_lote ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
