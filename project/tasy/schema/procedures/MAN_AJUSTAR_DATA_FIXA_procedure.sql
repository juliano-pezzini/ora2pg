-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_ajustar_data_fixa (nr_seq_regra_fixa_p bigint, dt_geracao_p timestamp, dt_inicio_desejado_p timestamp, nm_usuario_p text) AS $body$
BEGIN
update	man_regra_data_frequencia
set		dt_geracao			= dt_geracao_p,
		dt_inicio_desejado 	= dt_inicio_desejado_p,
		nm_usuario			= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
where	nr_sequencia		= nr_seq_regra_fixa_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_ajustar_data_fixa (nr_seq_regra_fixa_p bigint, dt_geracao_p timestamp, dt_inicio_desejado_p timestamp, nm_usuario_p text) FROM PUBLIC;
