-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_fiscal_dados_dmed_pck.deletar_devolucao ( nr_seq_solic_resc_fin_p pls_solic_rescisao_fin.nr_sequencia%type) AS $body$
BEGIN

delete from fis_dados_dmed
where nr_sequencia in (	SELECT	a.nr_sequencia
			from	fis_dados_dmed a,
				pls_solic_resc_fin_item b
			where	b.nr_sequencia = a.nr_seq_resc_fin_item
			and	b.nr_seq_solic_resc_fin = nr_seq_solic_resc_fin_p);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_fiscal_dados_dmed_pck.deletar_devolucao ( nr_seq_solic_resc_fin_p pls_solic_rescisao_fin.nr_sequencia%type) FROM PUBLIC;
