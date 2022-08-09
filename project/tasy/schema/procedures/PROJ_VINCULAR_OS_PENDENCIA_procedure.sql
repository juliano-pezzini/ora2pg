-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_vincular_os_pendencia ( nr_seq_ordem_p bigint, nr_seq_pendencia_p bigint, ie_acao_p text, ie_atual_status_pend_p text, nm_usuario_p text) AS $body$
BEGIN

if (ie_acao_p = 'V') then
	insert into proj_ata_pendencia_os(
		nr_sequencia,
		nr_seq_pendencia,
		nr_seq_ordem,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_acordo)
	values (	nextval('proj_ata_pendencia_os_seq'),
		nr_seq_pendencia_p,
		nr_seq_ordem_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		'N');

	if (coalesce(ie_atual_status_pend_p, 'N') = 'S') then

		update	proj_ata_pendencia
		set	ie_status = 'O'
		where	nr_sequencia	= nr_seq_pendencia_p;

	end if;

elsif (ie_acao_p = 'D') then
	delete	FROM proj_ata_pendencia_os
	where	nr_seq_ordem	= nr_seq_ordem_p
	and	nr_seq_pendencia	= nr_seq_pendencia_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_vincular_os_pendencia ( nr_seq_ordem_p bigint, nr_seq_pendencia_p bigint, ie_acao_p text, ie_atual_status_pend_p text, nm_usuario_p text) FROM PUBLIC;
