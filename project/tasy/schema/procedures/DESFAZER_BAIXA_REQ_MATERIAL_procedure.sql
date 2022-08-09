-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desfazer_baixa_req_material ( nr_requisicao_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nr_requisicao_p IS NOT NULL AND nr_requisicao_p::text <> '') then

	update	requisicao_material
	set	dt_baixa	 = NULL,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_requisicao	= nr_requisicao_p;

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desfazer_baixa_req_material ( nr_requisicao_p bigint, nm_usuario_p text) FROM PUBLIC;
