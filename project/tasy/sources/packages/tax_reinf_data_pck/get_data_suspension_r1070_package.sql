-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION tax_reinf_data_pck.get_data_suspension_r1070 (batch_code_p text) RETURNS SETOF R1070_SUSPENSION_TABLE_W AS $body$
DECLARE

    r1070_suspension_data_w    r1070_suspension_record_w;

    c_r1070_suspension CURSOR FOR
      SELECT  substr(b.cd_ind_suspensao, 1, 14) process_code,
              coalesce(substr(b.cd_ind_exigibilidade, 1, 2), 01) process_indicator,
              to_char(b.dt_decisao, 'yyyy-mm-dd') process_decision,
              coalesce(b.ie_ind_deposito, 'S') full_amount
      from 	  fis_reinf_r1070 a,
              fis_reinf_exib_trib b
      where 	a.nr_sequencia = b.nr_seq_superior
      and	    a.nr_sequencia = batch_code_p;

BEGIN
    for r1070_suspension_row in c_r1070_suspension loop
      begin
        r1070_suspension_data_w.process_code          :=  r1070_suspension_row.process_code;
        r1070_suspension_data_w.process_indicator     :=  r1070_suspension_row.process_indicator;
        r1070_suspension_data_w.process_decision      :=  r1070_suspension_row.process_decision;
        r1070_suspension_data_w.full_amount           :=  r1070_suspension_row.full_amount;
        RETURN NEXT r1070_suspension_data_w;
      end;
    end loop;
    return;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION tax_reinf_data_pck.get_data_suspension_r1070 (batch_code_p text) FROM PUBLIC;
