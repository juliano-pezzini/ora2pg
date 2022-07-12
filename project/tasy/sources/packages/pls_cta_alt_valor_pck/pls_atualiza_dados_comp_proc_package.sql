-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- atualiza dados complementares para procedimento
-- #Poss?velMelhoria
CREATE OR REPLACE PROCEDURE pls_cta_alt_valor_pck.pls_atualiza_dados_comp_proc ( nr_seq_conta_proc_p pls_conta_proc_v.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


C01 CURSOR(  nr_seq_conta_proc_p    pls_conta_proc_v.nr_sequencia%type) FOR
  SELECT  a.nr_sequencia,
    a.vl_liberado,
    a.vl_procedimento,
    a.vl_medico_original
  from  pls_conta_proc_v a
  where  a.nr_sequencia  = nr_seq_conta_proc_p;
BEGIN

for r_C01_w in C01(nr_seq_conta_proc_p) loop

  update  pls_conta_proc set
    vl_prestador    = r_C01_w.vl_liberado,
    vl_pag_medico_conta  = (dividir_sem_round(r_C01_w.vl_liberado, r_C01_w.vl_procedimento) * r_C01_w.vl_medico_original),
    nm_usuario    = nm_usuario_p,
    dt_atualizacao    = clock_timestamp()
  where  nr_sequencia    = r_C01_w.nr_sequencia;

end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_alt_valor_pck.pls_atualiza_dados_comp_proc ( nr_seq_conta_proc_p pls_conta_proc_v.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
