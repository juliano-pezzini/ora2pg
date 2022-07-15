-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cancelar_status_pendencia ( nr_seq_pendencia_p bigint, nm_usuario_p text, nr_seq_ata_p bigint) AS $body$
BEGIN

update 	proj_ata_pendencia
set	ie_status = 'D',
	nm_usuario = nm_usuario_p,
	dt_atualizacao = clock_timestamp(),
	dt_atualizacao_nrec = clock_timestamp()
where	nr_sequencia = nr_seq_pendencia_p
and	nr_seq_ata = nr_seq_ata_p;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancelar_status_pendencia ( nr_seq_pendencia_p bigint, nm_usuario_p text, nr_seq_ata_p bigint) FROM PUBLIC;

