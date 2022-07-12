-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Realiza update de valores da conta utilizando forall



CREATE OR REPLACE PROCEDURE pls_cta_consistir_pck.atualiza_registros ( dados_atualizacao_p table_atualiza_valores_conta) AS $body$
BEGIN

if (dados_atualizacao_p.nr_sequencia.count > 0) then
	forall i in dados_atualizacao_p.nr_sequencia.first..dados_atualizacao_p.nr_sequencia.last
		update	pls_conta
		set	nr_sequencia		= dados_atualizacao_p.nr_sequencia(i),
			vl_procedimentos	= dados_atualizacao_p.vl_procedimentos(i),
			vl_diarias		= dados_atualizacao_p.vl_diarias(i),
			vl_pacotes		= dados_atualizacao_p.vl_pacotes(i),
			vl_taxas		= dados_atualizacao_p.vl_taxas(i),
			vl_materiais		= dados_atualizacao_p.vl_materiais(i),
			vl_medicamentos		= dados_atualizacao_p.vl_medicamentos(i),
			vl_gases		= dados_atualizacao_p.vl_gases(i),
			vl_opm			= dados_atualizacao_p.vl_opm(i),
			vl_cobrado		= dados_atualizacao_p.vl_cobrado(i),
			vl_total		= dados_atualizacao_p.vl_total(i),
			vl_glosa		= dados_atualizacao_p.vl_glosa(i),
			vl_saldo		= dados_atualizacao_p.vl_saldo(i),
			vl_total_beneficiario	= dados_atualizacao_p.vl_total_beneficiario(i),
			vl_adic_procedimento	= dados_atualizacao_p.vl_adic_procedimento(i),
			vl_adic_co		= dados_atualizacao_p.vl_adic_co(i),
			vl_adic_materiais	= dados_atualizacao_p.vl_adic_materiais(i),
			vl_liberado_ptu		= dados_atualizacao_p.vl_liberado_ptu(i)
		where	nr_sequencia		= dados_atualizacao_p.nr_sequencia(i);
	commit;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_consistir_pck.atualiza_registros ( dados_atualizacao_p table_atualiza_valores_conta) FROM PUBLIC;