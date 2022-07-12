-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_analise_cta_pck.atualiza_proc_ref ( vetor_proc_p pls_util_cta_pck.num_table_vazia_w%type, vetor_proc_ref_p pls_util_cta_pck.num_table_vazia_w%type) AS $body$
BEGIN
forall i in vetor_proc_p.first .. vetor_proc_p.last
  update  pls_conta_proc
  set nr_seq_agrup_analise  = vetor_proc_ref_p(i)
  where nr_sequencia    = vetor_proc_p(i);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_analise_cta_pck.atualiza_proc_ref ( vetor_proc_p pls_util_cta_pck.num_table_vazia_w%type, vetor_proc_ref_p pls_util_cta_pck.num_table_vazia_w%type) FROM PUBLIC;