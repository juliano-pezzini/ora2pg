-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gpi_atual_anexo_doc_email ( nr_sequencia_p bigint, ie_anexar_p text, nm_usuario_p text) AS $body$
BEGIN

update	gpi_projeto_doc
set	ie_anexar_email	= ie_anexar_p,
	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp()
where	nr_seq_projeto	= nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gpi_atual_anexo_doc_email ( nr_sequencia_p bigint, ie_anexar_p text, nm_usuario_p text) FROM PUBLIC;
