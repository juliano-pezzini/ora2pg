-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reg_delete_resul_aval_customer ( nr_seq_aval_customer_p reg_avaliacao_customer.nr_sequencia%TYPE ) AS $body$
BEGIN
	DELETE FROM reg_avaliacao_cust_resul
	WHERE nr_seq_avaliacao = nr_seq_aval_customer_p;
	COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reg_delete_resul_aval_customer ( nr_seq_aval_customer_p reg_avaliacao_customer.nr_sequencia%TYPE ) FROM PUBLIC;
