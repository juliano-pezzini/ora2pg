-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION philips_contabil_pck.get_nr_seq_trans_fin () RETURNS TITULO_PAGAR_BAIXA.NR_SEQ_TRANS_FIN%TYPE AS $body$
BEGIN
    	return current_setting('philips_contabil_pck.nr_seq_trans_fin_w')::titulo_pagar_baixa.nr_seq_trans_fin%type;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION philips_contabil_pck.get_nr_seq_trans_fin () FROM PUBLIC;