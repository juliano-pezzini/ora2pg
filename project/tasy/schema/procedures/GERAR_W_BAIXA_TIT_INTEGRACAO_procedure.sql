-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_baixa_tit_integracao ( cd_tipo_baixa_p bigint, vl_devolucao_p bigint, cd_moeda_p bigint, dt_baixa_p timestamp, ie_acao_p text, vl_multa_p bigint, vl_juros_p bigint, nr_titulo_p bigint, vl_descontos_p bigint, vl_baixa_p bigint, nm_usuario_p text) AS $body$
BEGIN

delete	from w_baixa_tit_integracao
where	nm_usuario = nm_usuario_p;


insert	into w_baixa_tit_integracao(
	nr_sequencia,
	cd_tipo_baixa,
	vl_devolucao,
	cd_moeda,
	dt_baixa,
	ie_acao,
	vl_multa,
	vl_juros,
	nr_titulo,
	vl_descontos,
	vl_baixa,
	nm_usuario,
	nm_usuario_nrec,
	dt_atualizacao,
	dt_atualizacao_nrec)
values (	nextval('w_baixa_tit_integracao_seq'),
	cd_tipo_baixa_p,
	vl_devolucao_p,
	cd_moeda_p,
	dt_baixa_p,
	ie_acao_p,
	vl_multa_p,
	vl_juros_p,
	nr_titulo_p,
	vl_descontos_p,
	vl_baixa_p,
	nm_usuario_p,
	nm_usuario_p,
	clock_timestamp(),
	clock_timestamp());

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_baixa_tit_integracao ( cd_tipo_baixa_p bigint, vl_devolucao_p bigint, cd_moeda_p bigint, dt_baixa_p timestamp, ie_acao_p text, vl_multa_p bigint, vl_juros_p bigint, nr_titulo_p bigint, vl_descontos_p bigint, vl_baixa_p bigint, nm_usuario_p text) FROM PUBLIC;
