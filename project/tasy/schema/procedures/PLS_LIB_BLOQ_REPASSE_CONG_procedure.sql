-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_lib_bloq_repasse_cong ( nr_seq_cong_bloq_p bigint, nm_usuario_p text) AS $body$
DECLARE


DT_INICIO_BLOQUEIO_w	timestamp;


BEGIN

select	max(dt_inicio_bloqueio)
into STRICT	dt_inicio_bloqueio_w
from	pls_regra_bloqueio_repasse
where	nr_sequencia		= nr_seq_cong_bloq_p;

if (coalesce(dt_inicio_bloqueio_w::text, '') = '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(223168);
end if;

update	PLS_REGRA_BLOQUEIO_REPASSE
set	dt_liberacao		= clock_timestamp(),
	nm_usuario_liberacao	= nm_usuario_p,
	dt_atualizacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p
where	nr_sequencia		= nr_seq_cong_bloq_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_lib_bloq_repasse_cong ( nr_seq_cong_bloq_p bigint, nm_usuario_p text) FROM PUBLIC;

