-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_liberacao_tuss_serv (nr_sequencia_p bigint, ie_acao_p text, nm_usuario_p text) AS $body$
BEGIN

if (ie_acao_p = 'L') then
	update	tuss_servico
	set	dt_liberacao = clock_timestamp(),
		nm_usuario_liberacao = nm_usuario_p
	where 	nr_sequencia = nr_sequencia_p;
else
	update	tuss_servico
	set	dt_liberacao  = NULL,
		nm_usuario_liberacao  = NULL
	where 	nr_sequencia = nr_sequencia_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_liberacao_tuss_serv (nr_sequencia_p bigint, ie_acao_p text, nm_usuario_p text) FROM PUBLIC;
