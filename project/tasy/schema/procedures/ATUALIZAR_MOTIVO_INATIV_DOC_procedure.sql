-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_motivo_inativ_doc ( nr_seq_motivo_p bigint, nr_seq_doc_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nr_seq_motivo_p IS NOT NULL AND nr_seq_motivo_p::text <> '') and (nr_seq_doc_p IS NOT NULL AND nr_seq_doc_p::text <> '') then

	update	qua_documento
	set	nr_seq_motivo_inativacao	= nr_seq_motivo_p
	where	nr_sequencia			= nr_seq_doc_p;

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_motivo_inativ_doc ( nr_seq_motivo_p bigint, nr_seq_doc_p bigint, nm_usuario_p text) FROM PUBLIC;
