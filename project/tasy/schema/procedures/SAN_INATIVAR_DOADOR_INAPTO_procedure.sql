-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_inativar_doador_inapto ( nr_seq_doador_inapto_p bigint, ds_justificativa_p text, nm_usuario_p text) AS $body$
BEGIN

if (nr_seq_doador_inapto_p IS NOT NULL AND nr_seq_doador_inapto_p::text <> '') then
	update	san_doador_inapto
	set	nm_usuario_inativacao = nm_usuario_p,
		dt_inativacao = clock_timestamp(),
		ds_justificativa_inativacao = ds_justificativa_p
	where	nr_sequencia = nr_seq_doador_inapto_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_inativar_doador_inapto ( nr_seq_doador_inapto_p bigint, ds_justificativa_p text, nm_usuario_p text) FROM PUBLIC;
