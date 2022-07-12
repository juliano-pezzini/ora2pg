-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_fiscal_dados_dmed_pck.obter_parcela_negociacao ( dt_vencimento_p negociacao_cr_parcela.dt_vencimento%type, nr_seq_negociacao_p negociacao_cr.nr_sequencia%type) RETURNS bigint AS $body$
DECLARE

	
nr_seq_parcela_w	negociacao_cr_parcela.nr_sequencia%type;
	

BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_parcela_w
from	negociacao_cr_parcela
where	dt_vencimento between trunc(dt_vencimento_p,'mm') and fim_mes(dt_vencimento_p)
and	nr_seq_negociacao = nr_seq_negociacao_p;

return nr_seq_parcela_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_fiscal_dados_dmed_pck.obter_parcela_negociacao ( dt_vencimento_p negociacao_cr_parcela.dt_vencimento%type, nr_seq_negociacao_p negociacao_cr.nr_sequencia%type) FROM PUBLIC;