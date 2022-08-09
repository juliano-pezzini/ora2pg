-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_atualizar_anexo_email ( nr_sequencia_p bigint, ie_anexar_p text) AS $body$
BEGIN

update	man_ordem_serv_arq
set	ie_anexar_email	= ie_anexar_p
where	nr_seq_ordem	= nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_atualizar_anexo_email ( nr_sequencia_p bigint, ie_anexar_p text) FROM PUBLIC;
