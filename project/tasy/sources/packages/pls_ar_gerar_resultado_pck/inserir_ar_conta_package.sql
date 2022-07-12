-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_ar_gerar_resultado_pck.inserir_ar_conta (ie_fim_p text) AS $body$
BEGIN

if	((nr_indice_w >= pls_util_pck.qt_registro_transacao_w) or (ie_fim_p = 'S')) then
	if (tb_nr_seq_conta_w.count > 0) then
		forall i in tb_nr_seq_conta_w.first..tb_nr_seq_conta_w.last
			insert into pls_ar_conta(nr_sequencia, nr_seq_lote, cd_estabelecimento,
					nm_usuario, nm_usuario_nrec, dt_atualizacao,
					dt_atualizacao_nrec, vl_total, nr_seq_segurado,
					nr_seq_conta, ie_tipo_protocolo, nr_seq_plano,
					ie_tipo_segurado, ie_tipo_vinculo_operadora, nr_seq_contrato,
					nr_seq_pagador, nr_seq_intercambio, ie_preco,
					ie_regulamentacao, ie_tipo_contratacao, nr_seq_faixa_etaria,
					ie_situacao_trabalhista, nr_seq_congenere_repasse, ie_tipo_contrato,
					nr_seq_grupo_intercambio, ie_tipo_valor)
			values (	nextval('pls_ar_conta_seq'), nr_seq_lote_p, cd_estabelecimento_p,
					nm_usuario_p, nm_usuario_p, clock_timestamp(),
					clock_timestamp(), tb_vl_total_w(i), tb_nr_seq_segurado_w(i),
					tb_nr_seq_conta_w(i), tb_ie_tipo_protocolo_w(i), tb_nr_seq_plano_w(i),
					tb_ie_tipo_segurado_w(i), tb_ie_tipo_vinculo_operadora_w(i), tb_nr_seq_contrato_w(i),
					tb_nr_seq_pagador_w(i), tb_nr_seq_intercambio_w(i), tb_ie_preco_w(i),
					tb_ie_regulamentacao_w(i), tb_ie_tipo_contratacao_w(i), tb_nr_seq_faixa_etaria_w(i),
					tb_ie_situacao_trabalhista_w(i), tb_nr_seq_congenere_repasse_w(i), tb_ie_tipo_contrato_w(i),
					tb_nr_seq_grupo_intercambio_w(i), tb_ie_tipo_valor_w(i));
		commit;
	end if;
	
	CALL pls_ar_gerar_resultado_pck.limpar_vetor_conta_medica();
else
	nr_indice_w	:= nr_indice_w + 1;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ar_gerar_resultado_pck.inserir_ar_conta (ie_fim_p text) FROM PUBLIC;
