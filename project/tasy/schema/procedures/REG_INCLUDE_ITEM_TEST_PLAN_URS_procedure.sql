-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reg_include_item_test_plan_urs (nm_usuario_p text, nr_seq_intencao_uso_p bigint, nr_seq_customer_p bigint, nr_seq_caso_teste_p bigint) AS $body$
BEGIN

  insert into w_test_plan_pending_urs(
    dt_atualizacao,
    dt_atualizacao_nrec,
    nm_usuario,
    nm_usuario_nrec,
    nr_seq_customer,
    nr_seq_caso_teste,
    nr_seq_intencao_uso,
    nr_sequencia)
  values (
    clock_timestamp(),
    clock_timestamp(),
    nm_usuario_p,
    nm_usuario_p,
    nr_seq_customer_p,
    nr_seq_caso_teste_p,
    nr_seq_intencao_uso_p,
    nextval('w_test_plan_pending_urs_seq'));

    commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reg_include_item_test_plan_urs (nm_usuario_p text, nr_seq_intencao_uso_p bigint, nr_seq_customer_p bigint, nr_seq_caso_teste_p bigint) FROM PUBLIC;
