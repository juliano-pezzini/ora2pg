-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_log_import_sorologia ( nr_seq_exame_lote_p bigint, cd_exame_p bigint, nr_seq_doacao_p bigint, cd_barras_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_log_w	varchar(255);


BEGIN

ds_log_w := '';
--ds_log_w := 'Importação sorologia - etapa 0.9 - nr_seq_exame_lote: '||nr_seq_exame_lote_p||' nr_seq_exame: '||cd_exame_p ||' Doação: '+nr_seq_doacao_p || ' Barras: '||cd_barras_p;
/*
insert into log_tasy (
	dt_atualizacao,
	nm_usuario,
	cd_log,
	ds_log)
values (sysdate,
	nm_usuario_p,
	9004,
	ds_log_w);
*/
--commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_log_import_sorologia ( nr_seq_exame_lote_p bigint, cd_exame_p bigint, nr_seq_doacao_p bigint, cd_barras_p bigint, nm_usuario_p text) FROM PUBLIC;
