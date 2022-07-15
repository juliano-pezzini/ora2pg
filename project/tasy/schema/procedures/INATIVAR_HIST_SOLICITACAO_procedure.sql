-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inativar_hist_solicitacao ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
BEGIN

update 	same_solic_pront_hist
set 	dt_inativacao = clock_timestamp(),
	nm_usuario_inativacao = nm_usuario_p,
	ie_situacao = 'I'
where 	nr_sequencia = nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inativar_hist_solicitacao ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

