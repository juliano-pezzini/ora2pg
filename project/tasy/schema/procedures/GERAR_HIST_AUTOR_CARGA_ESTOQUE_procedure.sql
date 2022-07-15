-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_hist_autor_carga_estoque ( nr_sequencia_p bigint, ie_origem_p text, ds_titulo_p text, ds_historico_p text, nm_usuario_p text) AS $body$
BEGIN

insert into sup_autor_carga_est_hist(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_autor,
		ie_origem,
		ds_titulo,
		dt_historico,
		ds_historico,
		dt_liberacao,
		nm_usuario_lib)
values (		nextval('sup_autor_carga_est_hist_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_sequencia_p,
		ie_origem_p,
		ds_titulo_p,
		clock_timestamp(),
		ds_historico_p,
		clock_timestamp(),
		nm_usuario_p);


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_hist_autor_carga_estoque ( nr_sequencia_p bigint, ie_origem_p text, ds_titulo_p text, ds_historico_p text, nm_usuario_p text) FROM PUBLIC;

