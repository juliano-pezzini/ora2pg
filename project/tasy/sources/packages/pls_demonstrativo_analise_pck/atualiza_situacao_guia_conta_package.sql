-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_demonstrativo_analise_pck.atualiza_situacao_guia_conta ( nr_seq_versao_rel_p pls_rel_an_versao.nr_sequencia%type, nr_seq_prestador_p pls_rel_an_versao.nr_seq_prestador%type, ie_tipo_prestador_p pls_relatorio_analise.ie_tipo_prestador%type) AS $body$
DECLARE


current_setting('pls_demonstrativo_analise_pck.c01')::CURSOR( CURSOR(	nr_seq_versao_rel_pc		pls_rel_an_versao.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_conta
	from	pls_rel_an_conta	a
	where	a.nr_seq_versao	= nr_seq_versao_rel_pc;			
				
BEGIN

for r_c01_w in current_setting('pls_demonstrativo_analise_pck.c01')::CURSOR( (nr_seq_versao_rel_p) loop
	
	if (pls_demonstrativo_analise_pck.obter_se_conta_paga(ie_tipo_prestador_p,nr_seq_prestador_p,r_c01_w.nr_seq_conta) = 'S') then
		update	pls_rel_an_conta
		set	cd_situacao_guia	= '6'
		where	nr_sequencia		= r_c01_w.nr_sequencia;
	end if;
end loop;

end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_demonstrativo_analise_pck.atualiza_situacao_guia_conta ( nr_seq_versao_rel_p pls_rel_an_versao.nr_sequencia%type, nr_seq_prestador_p pls_rel_an_versao.nr_seq_prestador%type, ie_tipo_prestador_p pls_relatorio_analise.ie_tipo_prestador%type) FROM PUBLIC;
