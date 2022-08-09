-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gpi_liberar_risco_hist ( nr_seq_risco_hist_p bigint, nm_usuario_p text, ie_operacao_p text) AS $body$
BEGIN

update 	gpi_risco_hist a
set 	a.dt_liberacao 	= CASE WHEN ie_operacao_p='L' THEN clock_timestamp()  ELSE null END ,
	a.dt_atualizacao= clock_timestamp()
where 	a.nr_sequencia 	= nr_seq_risco_hist_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gpi_liberar_risco_hist ( nr_seq_risco_hist_p bigint, nm_usuario_p text, ie_operacao_p text) FROM PUBLIC;
