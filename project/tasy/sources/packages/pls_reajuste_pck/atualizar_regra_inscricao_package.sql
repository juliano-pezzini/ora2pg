-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_reajuste_pck.atualizar_regra_inscricao () AS $body$
BEGIN

if (current_setting('pls_reajuste_pck.tb_nr_seq_regra_inscricao_w')::pls_util_cta_pck.t_number_table.count > 0) then
	forall i in current_setting('pls_reajuste_pck.tb_nr_seq_regra_inscricao_w')::pls_util_cta_pck.t_number_table.first..tb_nr_seq_regra_inscricao_w.last
		update	pls_regra_inscricao
		set	dt_fim_vigencia = fim_dia(dt_reajuste_p - 1)
		where	nr_sequencia	= current_setting('pls_reajuste_pck.tb_nr_seq_regra_inscricao_w')::pls_util_cta_pck.t_number_table(i);
	commit;
end if;

CALL pls_reajuste_pck.limpar_vetor_att_regra_insc();

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_reajuste_pck.atualizar_regra_inscricao () FROM PUBLIC;
