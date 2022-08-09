-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alt_status_lib_fat_conta (nr_seq_lib_fat_conta_p bigint, ie_status_p text, nm_usuario_p text) AS $body$
BEGIN

insert	into PLS_LIB_FAT_CONTA_LOG(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_lib_fat_conta,
	ds_log)
SELECT	nextval('pls_lib_fat_conta_log_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_lib_fat_conta_p,
	'Alterado status de "' || obter_valor_dominio(6186, ie_status) || '" para "' || obter_valor_dominio(6186, ie_status_p) || '".'
from	pls_lib_fat_conta
where	nr_sequencia	= nr_seq_lib_fat_conta_p;

update	pls_lib_fat_conta
set	ie_status		= ie_status_p,
	dt_atualizacao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p
where	nr_sequencia	= nr_seq_lib_fat_conta_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alt_status_lib_fat_conta (nr_seq_lib_fat_conta_p bigint, ie_status_p text, nm_usuario_p text) FROM PUBLIC;
