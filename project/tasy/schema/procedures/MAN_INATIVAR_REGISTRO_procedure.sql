-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_inativar_registro ( nr_seq_filhas_p bigint, nm_usuario_p text) AS $body$
BEGIN

update 	man_ordem_serv_filha
set 	dt_inativacao = clock_timestamp(),
	ie_situacao = 'I',
	nm_usuario = nm_usuario_p,
	nm_usuario_inativacao = nm_usuario_p
where 	nr_sequencia = nr_seq_filhas_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_inativar_registro ( nr_seq_filhas_p bigint, nm_usuario_p text) FROM PUBLIC;

