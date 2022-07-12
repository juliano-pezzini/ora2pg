-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_reajuste_coletivo_pck.inserir_regra_via_cart () AS $body$
BEGIN

if (tb_nr_seq_lote_reaj_via_cart_w.count > 0) then
	forall i in tb_nr_seq_lote_reaj_via_cart_w.first..tb_nr_seq_lote_reaj_via_cart_w.last
		insert into	pls_reajuste_via_cart(	nr_sequencia, dt_atualizacao, dt_atualizacao_nrec,
				ie_origem_regra, nm_usuario, nm_usuario_nrec,
				nr_seq_lote, nr_seq_regra_ant, vl_base,
				vl_reajustado)
		values (	nextval('pls_reajuste_via_cart_seq'), clock_timestamp(), clock_timestamp(),
				tb_ie_origem_regra_via_cart_w(i), nm_usuario_p, nm_usuario_p,
				tb_nr_seq_lote_reaj_via_cart_w(i), tb_nr_seq_regra_ger_via_cart_w(i), tb_vl_reajustado_via_cart_w(i),
				tb_vl_base_via_cart_w(i));
	commit;
end if;

CALL pls_reajuste_coletivo_pck.limpar_vetor_regra_via_cart();

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_reajuste_coletivo_pck.inserir_regra_via_cart () FROM PUBLIC;
