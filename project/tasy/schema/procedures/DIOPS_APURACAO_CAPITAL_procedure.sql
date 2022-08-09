-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE diops_apuracao_capital ( nm_usuario_p text, nr_seq_periodo_p bigint, cd_estabelecimento_p bigint, ie_opcao_p bigint) AS $body$
DECLARE


/* -------------------------------------------------------------------------------------

ie_opcao_p
	1 -> Credito/Debito
	2 -> Detalhamento
*/
BEGIN


if (ie_opcao_p = 1) then
	insert into diops_cred_deb_apur_capit(
		nr_sequencia,
		dt_atualizacao,
		dt_atualizacao_nrec,
		nm_usuario,
		nm_usuario_nrec,
		nr_seq_periodo,
		nr_registro_ans,
		vl_campo_2,
		vl_campo_3,
		vl_campo_4,
		vl_campo_5,
		vl_campo_6,
		vl_campo_7,
		vl_campo_8,
		vl_campo_9,
		vl_campo_10
	) values (
		nextval('diops_cred_deb_apur_capit_seq'),
		clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		nm_usuario_p,
		nr_seq_periodo_p,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0
	);
elsif (ie_opcao_p = 2) then
	insert into diops_apur_capital_det(
		nr_sequencia,
		dt_atualizacao,
		dt_atualizacao_nrec,
		nm_usuario,
		nm_usuario_nrec,
		nr_seq_periodo,
		vl_campo_1,
		vl_campo_2,
		vl_campo_3,
		vl_campo_4,
		vl_campo_5
	) values (
		nextval('diops_apur_capital_det_seq'),
		clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		nm_usuario_p,
		nr_seq_periodo_p,
		0,
		0,
		0,
		0,
		0
	);
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE diops_apuracao_capital ( nm_usuario_p text, nr_seq_periodo_p bigint, cd_estabelecimento_p bigint, ie_opcao_p bigint) FROM PUBLIC;
