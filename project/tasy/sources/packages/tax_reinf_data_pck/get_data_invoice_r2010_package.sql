-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION tax_reinf_data_pck.get_data_invoice_r2010 (batch_code_p text, supplier_registration_p fis_reinf_notas_r2010.cd_cnpj%type, national_works_code_p fis_reinf_notas_r2010.cd_cno%type) RETURNS SETOF R2010_INVOICE_TABLE_W AS $body$
DECLARE

    r2010_invoice_data_w    r2010_invoice_record_w;

    c_r2010_invoice CURSOR FOR
      SELECT  distinct n.cd_serie_nf series,
              n.nr_nota_fiscal code,
              to_char(n.dt_emissao, 'rrrr-mm-dd') issue,
              r.vl_bruto_nf amount,
              coalesce(substr(elimina_caractere_especial(obter_texto_sem_quebras(n.ds_observacao)), 1, 250), 'Sem nenhuma observacao') note,
              n.nr_sequencia invoice_sequence
      from 	  fis_reinf_notas_r2010 r,
              nota_fiscal n
      where   r.nr_seq_nota = n.nr_sequencia
      and 	  r.nr_seq_superior = batch_code_p
      and 	  n.cd_cgc = supplier_registration_p
      and     coalesce(r.cd_cno, 'X') = coalesce(national_works_code_p, 'X');

BEGIN
    for r2010_invoice_row in c_r2010_invoice loop
      begin
        r2010_invoice_data_w.series           := r2010_invoice_row.series;
        r2010_invoice_data_w.code             := r2010_invoice_row.code;
        r2010_invoice_data_w.issue            := r2010_invoice_row.issue;
        r2010_invoice_data_w.amount           := r2010_invoice_row.amount;
        r2010_invoice_data_w.note             := r2010_invoice_row.note;
        r2010_invoice_data_w.invoice_sequence := r2010_invoice_row.invoice_sequence;
        RETURN NEXT r2010_invoice_data_w;
      end;
    end loop;
    return;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION tax_reinf_data_pck.get_data_invoice_r2010 (batch_code_p text, supplier_registration_p fis_reinf_notas_r2010.cd_cnpj%type, national_works_code_p fis_reinf_notas_r2010.cd_cno%type) FROM PUBLIC;