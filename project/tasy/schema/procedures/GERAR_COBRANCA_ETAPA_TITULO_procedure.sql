-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cobranca_etapa_titulo ( nr_seq_cobranca_p bigint, nr_seq_etapa_p bigint, ds_observacao_p text, nm_usuario_p text) AS $body$
BEGIN

insert into cobranca_etapa(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		dt_etapa,
		nr_seq_cobranca,
		nr_seq_etapa,
		ds_observacao)
values (
	nextval('cobranca_etapa_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nr_seq_cobranca_p,
	nr_seq_etapa_p,
	ds_observacao_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cobranca_etapa_titulo ( nr_seq_cobranca_p bigint, nr_seq_etapa_p bigint, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;

