-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gpi_liberar_cronograma ( nr_seq_cronograma_p bigint, ie_operacao_p text, nm_usuario_p text) AS $body$
BEGIN

if (ie_operacao_p = 'L') then
	update	gpi_cronograma
	set	dt_liberacao 		= clock_timestamp(),
		nm_usuario_lib		= nm_usuario_p
	where	nr_sequencia		= nr_seq_cronograma_p;
else
	update	gpi_cronograma
	set	dt_liberacao 		 = NULL,
		nm_usuario_lib		 = NULL,
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p
	where	nr_sequencia		= nr_seq_cronograma_p;
end if;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gpi_liberar_cronograma ( nr_seq_cronograma_p bigint, ie_operacao_p text, nm_usuario_p text) FROM PUBLIC;
