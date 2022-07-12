-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_reajuste_coletivo_pck.inserir_tabela_orig_contrato ( nr_seq_reajuste_p pls_reajuste.nr_sequencia%type, nr_seq_contrato_p pls_reajuste.nr_seq_contrato%type) AS $body$
DECLARE


C01 CURSOR(	nr_seq_contrato_pc	pls_reajuste.nr_seq_contrato%type,
		nr_mes_reajuste_pc	bigint) FOR
	SELECT	c.nr_sequencia nr_seq_tabela,
		c.nr_seq_plano,
		a.nr_seq_contrato,
		a.dt_contrato,
		c.dt_inicio_vigencia
	from	pls_contrato_temp	a,
		pls_contrato_plano	b,
		pls_tabela_preco	c,
		pls_plano		d
	where	a.nr_seq_contrato	= b.nr_seq_contrato
	and	c.nr_sequencia		= b.nr_seq_tabela
	and	d.nr_sequencia		= c.nr_seq_plano
	and	a.nr_seq_contrato	= nr_seq_contrato_pc
	and	a.nr_mes_reajuste	= nr_mes_reajuste_pc
	
union

	SELECT	b.nr_sequencia nr_seq_tabela,
		c.nr_sequencia nr_seq_plano,
		a.nr_seq_contrato,
		a.dt_contrato,
		b.dt_inicio_vigencia
	from	pls_contrato_temp	a,
		pls_tabela_preco	b,
		pls_plano		c
	where	a.nr_seq_contrato	= b.nr_contrato
	and	c.nr_sequencia		= b.nr_seq_plano
	and	a.nr_mes_reajuste	= nr_mes_reajuste_pc
	and	a.nr_seq_contrato	= nr_seq_contrato_pc
	and	coalesce(b.nr_segurado::text, '') = ''
	and	c.ie_tipo_operacao = 'B';

BEGIN

for r_c01_w in c01(nr_seq_contrato_p, (to_char(current_setting('pls_reajuste_coletivo_pck.pls_reajuste_w')::pls_reajuste%rowtype.dt_reajuste, 'mm'))::numeric ) loop
	begin
	CALL pls_reajuste_coletivo_pck.alimentar_vetor_reaj_tabela(	r_c01_w.nr_seq_tabela, nr_seq_reajuste_p, r_c01_w.nr_seq_contrato,
					null, r_c01_w.nr_seq_plano, r_c01_w.dt_contrato, 
					null, null, null);
	CALL CALL pls_reajuste_coletivo_pck.inserir_reajuste_tabela('N');
	end;
end loop; --C01

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_reajuste_coletivo_pck.inserir_tabela_orig_contrato ( nr_seq_reajuste_p pls_reajuste.nr_sequencia%type, nr_seq_contrato_p pls_reajuste.nr_seq_contrato%type) FROM PUBLIC;
