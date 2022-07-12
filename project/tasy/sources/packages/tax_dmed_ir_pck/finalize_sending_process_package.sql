-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE tax_dmed_ir_pck.finalize_sending_process (shipping_batch_code_p tax_dmed_mens.nr_sequencia%type) AS $body$
BEGIN
      update  tax_dmed_mens
      set     dt_fim_geracao = clock_timestamp()
      where   nr_sequencia = shipping_batch_code_p;
      commit;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tax_dmed_ir_pck.finalize_sending_process (shipping_batch_code_p tax_dmed_mens.nr_sequencia%type) FROM PUBLIC;
