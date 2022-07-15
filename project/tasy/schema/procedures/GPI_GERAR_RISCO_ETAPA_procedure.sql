-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gpi_gerar_risco_etapa (nr_seq_risco_p bigint, nr_seq_etapa_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert into gpi_risco_etapa(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_risco,
		nr_seq_etapa)
values (		nextval('gpi_risco_etapa_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_risco_p,
		nr_seq_etapa_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gpi_gerar_risco_etapa (nr_seq_risco_p bigint, nr_seq_etapa_p bigint, nm_usuario_p text) FROM PUBLIC;

