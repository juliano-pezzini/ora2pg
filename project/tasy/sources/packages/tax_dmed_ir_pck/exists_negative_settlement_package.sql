-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION tax_dmed_ir_pck.exists_negative_settlement (document_sequence_p titulo_receber_liq.nr_titulo%type) RETURNS bigint AS $body$
DECLARE

      response bigint;

BEGIN
      select  count(1)
      into STRICT    response 
      from    pls_titulo_rec_liq_neg
      where   nr_titulo = document_sequence_p;
      return response;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION tax_dmed_ir_pck.exists_negative_settlement (document_sequence_p titulo_receber_liq.nr_titulo%type) FROM PUBLIC;
