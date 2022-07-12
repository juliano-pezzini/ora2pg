-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION tax_dmed_ir_pck.exists_intermediary (document_p titulo_receber.nr_titulo%type) RETURNS bigint AS $body$
DECLARE

    aux_w bigint;

BEGIN
    select count(nr_sequencia) 
    into STRICT   aux_w
    from   fis_dados_dmed 
    where  nr_titulo_rec = document_p;

    return aux_w;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION tax_dmed_ir_pck.exists_intermediary (document_p titulo_receber.nr_titulo%type) FROM PUBLIC;