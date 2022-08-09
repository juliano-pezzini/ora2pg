-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_producao_vencida (nr_seq_producao_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, ds_motivo_p text, nm_usuario_p text) AS $body$
BEGIN

insert into san_producao_lib_venc(
	nr_sequencia,
	dt_inicio,
	dt_fim,
	ds_motivo,
	nm_usuario,
	dt_atualizacao,
	nr_seq_producao)
SELECT  nextval('san_producao_lib_venc_seq'),
	dt_inicio_p,
	dt_fim_p,
	substr(ds_motivo_p,1,90),
	nm_usuario_p,
	clock_timestamp(),
	nr_seq_producao_p
;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_producao_vencida (nr_seq_producao_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, ds_motivo_p text, nm_usuario_p text) FROM PUBLIC;
