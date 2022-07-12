-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_reajuste_coletivo_pck.inserir_contrato () AS $body$
DECLARE


C01 CURSOR(	nr_mes_reajuste_pc	bigint) FOR
	SELECT	nr_seq_contrato,
		dt_rescisao_contrato,
		nr_contrato
	from (SELECT	nr_seq_contrato,
			dt_rescisao_contrato,
			nr_contrato
		from	pls_contrato_temp
		where	nr_mes_reajuste	= nr_mes_reajuste_pc
		and	(nr_seq_contrato IS NOT NULL AND nr_seq_contrato::text <> '')
		
union all

		select	a.nr_seq_contrato,
			a.dt_rescisao_contrato,
			a.nr_contrato
		from	pls_contrato_temp a,
			pls_segurado b
		where	a.nr_seq_contrato = b.nr_seq_contrato
		and	a.ie_reajuste = 'A' --Buscar os contratos com reajuste por data base do beneficiario

		and	b.nr_mes_reajuste = nr_mes_reajuste_pc
		
union all

		select	a.nr_seq_contrato,
			a.dt_rescisao_contrato,
			a.nr_contrato
		from	pls_contrato_temp a,
			pls_segurado b,
			pls_sca_vinculo c
		where	a.nr_seq_contrato = b.nr_seq_contrato
		and	b.nr_sequencia = c.nr_seq_segurado
		and	c.nr_mes_reajuste = nr_mes_reajuste_pc) alias2
	group by
		nr_seq_contrato,
		dt_rescisao_contrato,
		nr_contrato;

BEGIN

for r_c01_w in C01(	(to_char(current_setting('pls_reajuste_coletivo_pck.pls_reajuste_w')::pls_reajuste%rowtype.dt_reajuste,'mm'))::numeric  ) loop
	begin
	CALL pls_reajuste_coletivo_pck.alimentar_vetor_contratos(r_c01_w.nr_seq_contrato, null, r_c01_w.dt_rescisao_contrato, r_c01_w.nr_contrato);
	CALL CALL pls_reajuste_coletivo_pck.inserir_contratos('N');
	end;
end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_reajuste_coletivo_pck.inserir_contrato () FROM PUBLIC;
