-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

CREATE OR REPLACE FUNCTION pls_regra_via_acesso_pck.inseriu_proc_regra_vetor ( tb_proc_table_p INOUT dbms_sql.number_table, tb_regra_table_p INOUT dbms_sql.number_table, nr_seq_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_regra_p pls_tipo_via_acesso.nr_sequencia%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Verifica se o proc ja foi inserido no vetor, para a regra informada
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN

if (tb_proc_table_p := pls_regra_via_acesso_pck.exists_valor_number_table(tb_proc_table_p, nr_seq_proc_p)) and (tb_regra_table_p := pls_regra_via_acesso_pck.exists_valor_number_table(tb_regra_table_p, nr_seq_regra_p)) then

	return;
end if;

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_regra_via_acesso_pck.inseriu_proc_regra_vetor ( tb_proc_table_p INOUT dbms_sql.number_table, tb_regra_table_p INOUT dbms_sql.number_table, nr_seq_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_regra_p pls_tipo_via_acesso.nr_sequencia%type) FROM PUBLIC;
