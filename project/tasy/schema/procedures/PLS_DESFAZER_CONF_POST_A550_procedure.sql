-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_conf_post_a550 ( nr_seq_camara_contest_p bigint, nm_usuario_p text) AS $body$
BEGIN
if (nr_seq_camara_contest_p IS NOT NULL AND nr_seq_camara_contest_p::text <> '') then
	update	ptu_camara_contestacao
	set	dt_postagem_arquivo	 = NULL,
		nm_usuario_envio	 = NULL
	where	nr_sequencia		= nr_seq_camara_contest_p;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_conf_post_a550 ( nr_seq_camara_contest_p bigint, nm_usuario_p text) FROM PUBLIC;

