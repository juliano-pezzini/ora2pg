-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_titulo_pagar_baixa ( cd_tipo_baixa_p bigint, vl_baixa_p bigint, vl_pago_p bigint, vl_devolucao_p bigint, vl_juros_p bigint, vl_multa_p bigint, vl_descontos_p bigint, vl_outras_deducoes_p bigint, vl_outros_acrescimos_p bigint, vl_ir_p bigint, dt_baixa_p timestamp, cd_moeda_p bigint, nr_seq_conta_banco_p bigint, nr_bordero_p bigint, nr_seq_escrit_p bigint, nr_seq_trans_fin_p bigint, cd_conta_contabil_p text, ie_baixa_bloqueto_p text, vl_cotacao_moeda_p bigint, nr_sequencia_p INOUT bigint, nr_titulo_p INOUT bigint, nm_usuario_p text) AS $body$
DECLARE



nr_sequencia_w 		titulo_pagar_baixa.nr_sequencia%type;


BEGIN

select coalesce(max(a.nr_sequencia),0) +1
into STRICT nr_sequencia_w
from titulo_pagar_baixa a
where a.nr_titulo = nr_titulo_p;

	insert into TITULO_PAGAR_BAIXA(nr_titulo,
		cd_tipo_baixa,
		vl_baixa,
		vl_pago,
		vl_devolucao,
		vl_juros,
		vl_multa,
		vl_descontos,
		vl_outras_deducoes,
		vl_outros_acrescimos,
		vl_ir,
		dt_baixa,
		cd_moeda,
		nr_seq_conta_banco,
		nr_bordero,
		nr_seq_escrit,
		nr_seq_trans_fin,
		cd_conta_contabil,
		ie_baixa_bloqueto,
		vl_cotacao_moeda,
		nm_usuario,
		nr_sequencia,
		DT_ATUALIZACAO,
		IE_ACAO)
	values (nr_titulo_p,
		cd_tipo_baixa_p,
		vl_baixa_p,
		vl_pago_p,
		vl_devolucao_p,
		vl_juros_p,
		vl_multa_p,
		vl_descontos_p,
		vl_outras_deducoes_p,
		vl_outros_acrescimos_p,
		vl_ir_p,
		dt_baixa_p,
		cd_moeda_p,
		nr_seq_conta_banco_p,
		nr_bordero_p,
		nr_seq_escrit_p,
		nr_seq_trans_fin_p,
		cd_conta_contabil_p,
		ie_baixa_bloqueto_p,
		vl_cotacao_moeda_p,
		nm_usuario_p,
		nr_sequencia_w,
		clock_timestamp(),
		'I');
nr_sequencia_p := nr_sequencia_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_titulo_pagar_baixa ( cd_tipo_baixa_p bigint, vl_baixa_p bigint, vl_pago_p bigint, vl_devolucao_p bigint, vl_juros_p bigint, vl_multa_p bigint, vl_descontos_p bigint, vl_outras_deducoes_p bigint, vl_outros_acrescimos_p bigint, vl_ir_p bigint, dt_baixa_p timestamp, cd_moeda_p bigint, nr_seq_conta_banco_p bigint, nr_bordero_p bigint, nr_seq_escrit_p bigint, nr_seq_trans_fin_p bigint, cd_conta_contabil_p text, ie_baixa_bloqueto_p text, vl_cotacao_moeda_p bigint, nr_sequencia_p INOUT bigint, nr_titulo_p INOUT bigint, nm_usuario_p text) FROM PUBLIC;

