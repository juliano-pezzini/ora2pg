-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consist_regra_arq_atuarial ( nr_seq_regra_p pls_atuarial_arq_regra.nr_sequencia%type, ds_erro_sql_p INOUT text) AS $body$
BEGIN

ds_erro_sql_p := pls_dados_atuariais_pck.consistir_regra_arquivo(nr_seq_regra_p, ds_erro_sql_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consist_regra_arq_atuarial ( nr_seq_regra_p pls_atuarial_arq_regra.nr_sequencia%type, ds_erro_sql_p INOUT text) FROM PUBLIC;

