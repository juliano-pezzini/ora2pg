-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_faturamento_pck.limpar_tabelas_temporarias (nr_seq_lote_p pls_lote_faturamento.nr_sequencia%type) AS $body$
BEGIN

delete	FROM w_pls_lote_fat_proc
where	nr_seq_lote_fat = nr_seq_lote_p;

delete	FROM w_pls_lote_fat_mat
where	nr_seq_lote_fat = nr_seq_lote_p;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_faturamento_pck.limpar_tabelas_temporarias (nr_seq_lote_p pls_lote_faturamento.nr_sequencia%type) FROM PUBLIC;