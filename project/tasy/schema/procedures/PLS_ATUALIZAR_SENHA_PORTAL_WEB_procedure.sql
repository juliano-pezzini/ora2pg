-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_senha_portal_web ( nr_seq_estipulante_p bigint, ds_senha_p text, ds_tec_p text) AS $body$
BEGIN
if ((nr_seq_estipulante_p IS NOT NULL AND nr_seq_estipulante_p::text <> '') and (ds_senha_p IS NOT NULL AND ds_senha_p::text <> '') and (ds_tec_p IS NOT NULL AND ds_tec_p::text <> '')) then
	update	pls_estipulante_web
	set	ds_senha		= ds_senha_p,
		ds_tec		= ds_tec_p
	where	nr_sequencia = nr_seq_estipulante_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_senha_portal_web ( nr_seq_estipulante_p bigint, ds_senha_p text, ds_tec_p text) FROM PUBLIC;
