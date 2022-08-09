-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_carga_tuss_item (cd_tuss_p bigint, ds_tuss_p text, nr_seq_carga_tuss_p bigint, nm_usuario_p text, ie_status_p text, dt_inicio_vigencia_p timestamp, dt_fim_vigencia_p timestamp, dt_implantacao_p timestamp) AS $body$
BEGIN

insert into w_carga_tuss_item(
		NR_SEQUENCIA,
		NR_SEQ_CARGA_TUSS,
		DT_ATUALIZACAO,
		NM_USUARIO,
		DT_ATUALIZACAO_NREC,
		NM_USUARIO_NREC,
		DS_PROCEDIMENTO,
		CD_PROCEDIMENTO,
		ie_status,
		dt_inicio_vigencia,
		dt_fim_vigencia,
		dt_implantacao)
	values (nextval('w_carga_tuss_item_seq'),
		nr_seq_carga_tuss_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		ds_tuss_p,
		cd_tuss_p,
		ie_status_p,
		dt_inicio_vigencia_p,
		dt_fim_vigencia_p,
		dt_implantacao_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_carga_tuss_item (cd_tuss_p bigint, ds_tuss_p text, nr_seq_carga_tuss_p bigint, nm_usuario_p text, ie_status_p text, dt_inicio_vigencia_p timestamp, dt_fim_vigencia_p timestamp, dt_implantacao_p timestamp) FROM PUBLIC;
