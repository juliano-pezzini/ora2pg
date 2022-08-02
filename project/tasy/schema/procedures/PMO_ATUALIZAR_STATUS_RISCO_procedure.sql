-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pmo_atualizar_status_risco (nr_sequencia_p bigint, ie_status_encerramento_p text, nm_usuario_p text) AS $body$
BEGIN

CALL encerrar_risco_projeto(nr_sequencia_p,nm_usuario_p);

if (ie_status_encerramento_p IS NOT NULL AND ie_status_encerramento_p::text <> '') then

	update	proj_risco_implantacao
	set	ie_status_encerramento = ie_status_encerramento_p
	where	nr_sequencia = nr_sequencia_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pmo_atualizar_status_risco (nr_sequencia_p bigint, ie_status_encerramento_p text, nm_usuario_p text) FROM PUBLIC;

