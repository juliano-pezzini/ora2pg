-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_fechar_conta_reap ( nr_seq_conta_reap_p bigint, nm_usuario_p text) AS $body$
BEGIN

CALL TISS_ATUALIZAR_CONTA_REAP(nr_seq_conta_reap_p, nm_usuario_p);

update	tiss_reap_conta
set	ie_status_conta	= 2
where	nr_sequencia	= nr_seq_conta_reap_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_fechar_conta_reap ( nr_seq_conta_reap_p bigint, nm_usuario_p text) FROM PUBLIC;
