-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_entao_regra_preco_cta_pck.atualiza_servico ( ie_destino_regra_p text, nr_contador_p INOUT integer, tb_nr_seq_conta_proc_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_regra_entao_p INOUT pls_util_cta_pck.t_number_table, tb_vl_servico_p INOUT pls_util_cta_pck.t_number_table, tb_vl_ch_honorario_p INOUT pls_util_cta_pck.t_number_table) AS $body$
BEGIN

-- se tem algo manda pro banco
if (tb_nr_seq_conta_proc_p.count > 0) then
		
	if (ie_destino_regra_p = 'C') then

		forall i in tb_nr_seq_conta_proc_p.first..tb_nr_seq_conta_proc_p.last
			update	pls_conta_proc_regra
			set	nr_seq_cp_comb_serv_cop_entao = tb_nr_seq_regra_entao_p(i),
				vl_procedimento_cop = tb_vl_servico_p(i)
			where	nr_sequencia = tb_nr_seq_conta_proc_p(i);
		commit;
	else
		forall i in tb_nr_seq_conta_proc_p.first..tb_nr_seq_conta_proc_p.last
			update 	pls_conta_proc
			set	vl_ch_honorario = tb_vl_ch_honorario_p(i)
			where	nr_sequencia = tb_nr_seq_conta_proc_p(i);
		commit;
	
		forall i in tb_nr_seq_conta_proc_p.first..tb_nr_seq_conta_proc_p.last
			update	pls_conta_proc_regra
			set	vl_procedimento_base = tb_vl_servico_p(i),
				nr_seq_cp_comb_serv_entao = tb_nr_seq_regra_entao_p(i)
			where	nr_sequencia = tb_nr_seq_conta_proc_p(i);
		commit;
	end if;
end if;

--limpa as variáveis
tb_nr_seq_conta_proc_p.delete;
tb_nr_seq_regra_entao_p.delete;
tb_vl_servico_p.delete;
tb_vl_ch_honorario_p.delete;

nr_contador_p := 0;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_entao_regra_preco_cta_pck.atualiza_servico ( ie_destino_regra_p text, nr_contador_p INOUT integer, tb_nr_seq_conta_proc_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_regra_entao_p INOUT pls_util_cta_pck.t_number_table, tb_vl_servico_p INOUT pls_util_cta_pck.t_number_table, tb_vl_ch_honorario_p INOUT pls_util_cta_pck.t_number_table) FROM PUBLIC;