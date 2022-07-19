-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atend_sugest_cont_lida (nr_seq_sugerido_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nr_seq_sugerido_p IS NOT NULL AND nr_seq_sugerido_p::text <> '') then

	update	pls_atend_sugestao_contato
	set	dt_aviso = clock_timestamp()
	where	nr_sequencia = nr_seq_sugerido_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atend_sugest_cont_lida (nr_seq_sugerido_p bigint, nm_usuario_p text) FROM PUBLIC;

