-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_log_atend_estoque_hist ( nm_usuario_p text, nr_atendimento_p bigint, cd_material_p bigint, ds_mensagem_p text) AS $body$
BEGIN

insert into atend_mat_estoque_hist(
	nr_sequencia,
	nr_atendimento,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	cd_material,
	ds_mensagem)
values (	nextval('atend_mat_estoque_hist_seq'),
	nr_atendimento_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	cd_material_p,
	ds_mensagem_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_log_atend_estoque_hist ( nm_usuario_p text, nr_atendimento_p bigint, cd_material_p bigint, ds_mensagem_p text) FROM PUBLIC;
