-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cobranca_cheques_venc ( nr_seq_cobranca_p bigint, cd_estabelecimento_p bigint, nr_seq_cheque_p bigint, vl_cheque_p bigint, dt_prev_cobr_p timestamp, cd_tipo_portador_p bigint, nr_seq_cobrador_p bigint, cd_portador_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert   into cobranca(
		nr_sequencia,
		cd_estabelecimento,
		dt_atualizacao,
		nm_usuario,
		nr_seq_cheque,
		ie_status,
		vl_original,
		vl_acobrar,
		dt_previsao_cobranca,
		dt_inclusao,
		nr_seq_cobrador,
		cd_tipo_portador,
		cd_portador)
values (
	nr_seq_cobranca_p,
	cd_estabelecimento_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_cheque_p,
	'P',
	vl_cheque_p,
	vl_cheque_p,
	dt_prev_cobr_p,
	clock_timestamp(),
	nr_seq_cobrador_p,
	cd_tipo_portador_p,
	cd_portador_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cobranca_cheques_venc ( nr_seq_cobranca_p bigint, cd_estabelecimento_p bigint, nr_seq_cheque_p bigint, vl_cheque_p bigint, dt_prev_cobr_p timestamp, cd_tipo_portador_p bigint, nr_seq_cobrador_p bigint, cd_portador_p bigint, nm_usuario_p text) FROM PUBLIC;

