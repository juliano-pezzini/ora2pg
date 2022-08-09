-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_liberar_reuniao ( nr_seq_proj_reuniao_p bigint, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE


/* ie_opcao_p
L - Liberar Reunião
D - Desfazer Liberação da reunião
*/
BEGIN
update	proj_reuniao
set	nm_usuario = nm_usuario_p,
	dt_atualizacao = clock_timestamp(),
	dt_liberacao = CASE WHEN ie_opcao_p='D' THEN null  ELSE clock_timestamp() END
where	nr_sequencia = nr_seq_proj_reuniao_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_liberar_reuniao ( nr_seq_proj_reuniao_p bigint, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;
