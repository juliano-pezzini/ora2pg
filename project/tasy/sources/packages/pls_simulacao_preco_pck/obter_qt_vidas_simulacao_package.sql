-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_simulacao_preco_pck.obter_qt_vidas_simulacao ( nr_seq_simulacao_p pls_simulacao_preco.nr_sequencia%type, ie_calculo_vidas_p pls_tabela_preco.ie_calculo_vidas%type) RETURNS bigint AS $body$
DECLARE

	
	qt_vidas_simul_indiv_w	bigint;
	
	
BEGIN
	qt_vidas_simul_indiv_w := 0;
	
	if (ie_calculo_vidas_p in ('A','F')) then --Todos e Todos da familia
		select	count(1)
		into STRICT	qt_vidas_simul_indiv_w
		from	pls_simulpreco_individual
		where	nr_seq_simulacao = nr_seq_simulacao_p
		and	ie_tipo_benef <> 'R';
	elsif (ie_calculo_vidas_p = 'T') then --Somente titulares
		select	count(1)
		into STRICT	qt_vidas_simul_indiv_w
		from	pls_simulpreco_individual
		where	nr_seq_simulacao = nr_seq_simulacao_p
		and	ie_tipo_benef = 'T';
	elsif (ie_calculo_vidas_p = 'D') then --Somente dependentes
		select	count(1)
		into STRICT	qt_vidas_simul_indiv_w
		from	pls_simulpreco_individual
		where	nr_seq_simulacao = nr_seq_simulacao_p
		and	ie_tipo_benef = 'D';
	elsif (ie_calculo_vidas_p = 'TD') then --Titular + dependentes legais
		select	count(1)
		into STRICT	qt_vidas_simul_indiv_w
		from	pls_simulpreco_individual a
		where	nr_seq_simulacao = nr_seq_simulacao_p
		and	((ie_tipo_benef = 'T') or ((ie_tipo_benef = 'D') and ((	SELECT	count(1)
										from	grau_parentesco x
										where	x.nr_sequencia = a.nr_seq_parentesco
										and	x.ie_tipo_parentesco = '1') > 0)));
	end if;
	
	return	coalesce(qt_vidas_simul_indiv_w,0);
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_simulacao_preco_pck.obter_qt_vidas_simulacao ( nr_seq_simulacao_p pls_simulacao_preco.nr_sequencia%type, ie_calculo_vidas_p pls_tabela_preco.ie_calculo_vidas%type) FROM PUBLIC;