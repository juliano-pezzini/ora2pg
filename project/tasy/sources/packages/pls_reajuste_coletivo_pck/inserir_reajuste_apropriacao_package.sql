-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_reajuste_coletivo_pck.inserir_reajuste_apropriacao () AS $body$
BEGIN

if (tb_nr_seq_regra_aprop_w.count > 0) then
	forall i in tb_nr_seq_regra_aprop_w.first..tb_nr_seq_regra_aprop_w.last
		insert into	pls_reajuste_apropriacao(	nr_sequencia, dt_atualizacao, dt_atualizacao_nrec,
				nm_usuario, nm_usuario_nrec, nr_seq_reajuste,
				nr_seq_regra_ant)
		values (	nextval('pls_reajuste_apropriacao_seq'), clock_timestamp(), clock_timestamp(),
				nm_usuario_p, nm_usuario_p, tb_nr_seq_reajuste_w(i),
				tb_nr_seq_regra_aprop_w(i));
	commit;
end if;

CALL pls_reajuste_coletivo_pck.limpar_vetor_reaj_aprop();

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_reajuste_coletivo_pck.inserir_reajuste_apropriacao () FROM PUBLIC;