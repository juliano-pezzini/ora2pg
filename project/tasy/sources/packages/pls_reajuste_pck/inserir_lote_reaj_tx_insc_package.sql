-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_reajuste_pck.inserir_lote_reaj_tx_insc ( ie_descarregar_p text) AS $body$
BEGIN

if	((nr_indice_reaj_tx_insc_w >= pls_util_pck.qt_registro_transacao_w) or (ie_descarregar_p = 'S')) then
	if (tb_nr_seq_reajuste_tx_insc_w.count > 0) then
		forall i in tb_nr_seq_reajuste_tx_insc_w.first..tb_nr_seq_reajuste_tx_insc_w.last
			insert	into	pls_lote_reaj_inscricao(	nr_sequencia, nr_seq_contrato, cd_estabelecimento,
					dt_referencia, dt_atualizacao, nm_usuario,
					dt_atualizacao_nrec, nm_usuario_nrec, tx_reajuste,
					nr_seq_reajuste, nr_seq_intercambio)
				values (	nextval('pls_lote_reaj_inscricao_seq'), tb_nr_seq_contrato_tx_insc_w(i), cd_estabelecimento_p,
					current_setting('pls_reajuste_pck.pls_reajuste_w')::pls_reajuste%rowtype.dt_reajuste, clock_timestamp(), nm_usuario_p,
					clock_timestamp(), nm_usuario_p, coalesce(current_setting('pls_reajuste_pck.pls_reajuste_w')::pls_reajuste%rowtype.tx_reajuste_inscricao, current_setting('pls_reajuste_pck.pls_reajuste_w')::pls_reajuste%rowtype.tx_reajuste),
					tb_nr_seq_reajuste_tx_insc_w(i), tb_nr_seq_interc_tx_insc_w(i));
		commit;
	end if;
	
	CALL CALL pls_reajuste_pck.limpar_vetor_lote_inscricao();
else
	nr_indice_reaj_tx_insc_w	:= nr_indice_reaj_tx_insc_w + 1;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_reajuste_pck.inserir_lote_reaj_tx_insc ( ie_descarregar_p text) FROM PUBLIC;