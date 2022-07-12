-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION tax_reinf_data_pck.get_data_title_r2040 (batch_code_p text) RETURNS SETOF R2040_TITLE_TABLE_W AS $body$
DECLARE

    r2040_title_data_w    r2040_title_record_w;

    c_2040 CURSOR FOR
      SELECT  t.cd_cgc subscription,
              sum(r.vl_titulo) total_value,
              sum(r.vl_retencao) total_retained
      from    titulo_pagar t,
              fis_reinf_tit_r2040 r	
      where   r.nr_titulo = t.nr_titulo
      and     r.nr_seq_superior = batch_code_p
      group by t.cd_cgc;

BEGIN
    for r2040_row in c_2040 loop
      begin
        r2040_title_data_w.subscription               := r2040_row.subscription;
        r2040_title_data_w.total_value                := r2040_row.total_value;
        r2040_title_data_w.total_retained             := r2040_row.total_retained;
        RETURN NEXT r2040_title_data_w;
      end;
    end loop;
    return;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION tax_reinf_data_pck.get_data_title_r2040 (batch_code_p text) FROM PUBLIC;
