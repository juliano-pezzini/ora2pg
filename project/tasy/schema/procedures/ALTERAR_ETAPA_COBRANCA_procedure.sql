-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_etapa_cobranca (nr_seq_alt_etapa_p bigint, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert into  cobranca_etapa(
		dt_atualizacao,
		nm_usuario,
		nr_seq_cobranca,
		nr_seq_etapa,
		nr_sequencia,
		dt_etapa)
values (clock_timestamp(),
		nm_usuario_p,
		nr_sequencia_p,
		nr_seq_alt_etapa_p,
		nextval('cobranca_etapa_seq'),
		clock_timestamp());

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_etapa_cobranca (nr_seq_alt_etapa_p bigint, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

