-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_fechar_lote_reap ( nr_seq_lote_reap_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_conta_w		bigint;

c01 CURSOR FOR
SELECT	a.nr_sequencia
from	tiss_reap_conta a
where	a.ie_status_conta	= 1
and	a.nr_seq_lote	= nr_seq_lote_reap_p;


BEGIN

open c01;
loop
fetch c01 into
	nr_seq_conta_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	CALL TISS_FECHAR_CONTA_REAP(nr_seq_conta_w, nm_usuario_p);

end loop;
close c01;

CALL TISS_ATUALIZAR_LOTE_REAP(nr_seq_lote_reap_p, nm_usuario_p);

update	tiss_reap_lote
set	ie_status_acerto	= 2,
	dt_fechamento	= clock_timestamp()
where	nr_sequencia	= nr_seq_lote_reap_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_fechar_lote_reap ( nr_seq_lote_reap_p bigint, nm_usuario_p text) FROM PUBLIC;

