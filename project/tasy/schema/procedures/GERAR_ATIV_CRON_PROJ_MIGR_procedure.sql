-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_ativ_cron_proj_migr ( nr_seq_cronograma_p bigint, cd_funcao_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_atividade_w	bigint;


BEGIN
if (nr_seq_cronograma_p IS NOT NULL AND nr_seq_cronograma_p::text <> '') and (cd_funcao_p IS NOT NULL AND cd_funcao_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	select	nextval('proj_cron_etapa_seq')
	into STRICT	nr_seq_atividade_w
	;

	insert into proj_cron_etapa(
		nr_seq_cronograma,
		nr_sequencia,
		ds_atividade,
		ie_fase,
		qt_hora_prev,
		pr_etapa,
		nr_seq_apres,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_modulo,
		ie_tipo_obj_proj_migr,
		nr_seq_superior)
	values (
		nr_seq_cronograma_p,
		nr_seq_atividade_w,
		obter_desc_funcao(cd_funcao_p),
		'S',
		0,
		0,
		1000,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		'N',
		null,
		null);

	CALL gerar_menuitem_cron_proj_migr(
		nr_seq_cronograma_p,
		cd_funcao_p,
		nr_seq_atividade_w,
		nm_usuario_p);

	CALL gerar_dbpanel_cron_proj_migr(
		nr_seq_cronograma_p,
		cd_funcao_p,
		nr_seq_atividade_w,
		nm_usuario_p);

	CALL gerar_wcpanel_cron_proj_migr(
		nr_seq_cronograma_p,
		cd_funcao_p,
		nr_seq_atividade_w,
		nm_usuario_p);

	CALL gerar_wdlg_cron_proj_migr(
		nr_seq_cronograma_p,
		cd_funcao_p,
		nr_seq_atividade_w,
		nm_usuario_p);

	CALL gerar_wscb_cron_proj_migr(
		nr_seq_cronograma_p,
		cd_funcao_p,
		nr_seq_atividade_w,
		nm_usuario_p);

	CALL gerar_relat_cron_proj_migr(
		nr_seq_cronograma_p,
		cd_funcao_p,
		nr_seq_atividade_w,
		nm_usuario_p);

	CALL gerar_outros_cron_proj_migr(
		nr_seq_cronograma_p,
		cd_funcao_p,
		nr_seq_atividade_w,
		nm_usuario_p);

	/*gerar_testes_cron_proj_migr(
		nr_seq_cronograma_p,
		cd_funcao_p,
		nr_seq_atividade_w,
		nm_usuario_p);*/
	CALL atualizar_total_horas_cron(nr_seq_cronograma_p);
	CALL gerar_classif_etapa_proj(nr_seq_cronograma_p, nm_usuario_p);
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_ativ_cron_proj_migr ( nr_seq_cronograma_p bigint, cd_funcao_p bigint, nm_usuario_p text) FROM PUBLIC;

