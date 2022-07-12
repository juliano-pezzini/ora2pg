-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_valores_conta_comp ( nr_seq_competencia_p bigint, ie_tipo_movimentacao_p text) RETURNS bigint AS $body$
DECLARE

				
vl_retorno_w			double precision	:= 0;
vl_identificado_w		double precision 	:= 0;
vl_cobrado_w			double precision	:= 0;
vl_deferido_w			double precision	:= 0;
vl_debitos_pendentes_w		double precision	:= 0;
vl_divida_ativa_w		double precision	:= 0;
vl_final_w			double precision	:= 0;
pr_historico_w			pls_processo_competencia.pr_historico%type;


BEGIN

/* Tipos de movimentação padrão, utilizados na ativação dos WCPanel
	I = Identificadas
	C = Cobradas
	D = Deferedias
	P = Pendentes
	DP = Débitos pendentes
	DA = Divida ativa */
if (ie_tipo_movimentacao_p in ('I', 'C', 'D', 'P', 'DP', 'DA')) then
	select	coalesce(sum(pls_conta_processo_obter_valor(a.nr_seq_conta)), 0)
	into STRICT 	vl_retorno_w
	from	pls_processo_contas_comp a
	where	a.nr_seq_competencia 	= nr_seq_competencia_p
	and	a.ie_tipo_movimentacao 	= ie_tipo_movimentacao_p;
/* Tipos de movimentação utilizados no WCPanel de resumo
	FI = Valor final (ABIs identificadas - ABIs Cobradas - ABIs Deferidas)
	HC = Valor final * Percentual histórico
	TO = Total (HC + Débitos pendentes + Dívida ativa) */
elsif (ie_tipo_movimentacao_p in ('FI', 'HC')) then
	select	coalesce(sum(pls_conta_processo_obter_valor(a.nr_seq_conta)), 0)
	into STRICT 	vl_identificado_w
	from	pls_processo_contas_comp a
	where	a.nr_seq_competencia 	= nr_seq_competencia_p
	and	a.ie_tipo_movimentacao 	= 'I';
	
	select	coalesce(sum(pls_conta_processo_obter_valor(a.nr_seq_conta)), 0)
	into STRICT 	vl_cobrado_w
	from	pls_processo_contas_comp a
	where	a.nr_seq_competencia 	= nr_seq_competencia_p
	and	a.ie_tipo_movimentacao 	= 'C';

	select	coalesce(sum(pls_conta_processo_obter_valor(a.nr_seq_conta)), 0)
	into STRICT 	vl_deferido_w
	from	pls_processo_contas_comp a
	where	a.nr_seq_competencia 	= nr_seq_competencia_p
	and	a.ie_tipo_movimentacao 	= 'D';

	vl_retorno_w := vl_identificado_w - vl_cobrado_w - vl_deferido_w;

	if (ie_tipo_movimentacao_p = 'HC') then
		select	pr_historico
		into STRICT	pr_historico_w
		from	pls_processo_competencia
		where	nr_sequencia = nr_seq_competencia_p;

		vl_retorno_w := dividir(vl_retorno_w * pr_historico_w, 100);
	end if;
elsif (ie_tipo_movimentacao_p = 'TO') then
	select	pls_obter_valores_conta_comp(nr_seq_competencia_p, 'HC') vl_total
	into STRICT	vl_final_w
	;

	select	pls_obter_valores_conta_comp(nr_seq_competencia_p, 'DP') vl_total
	into STRICT	vl_debitos_pendentes_w
	;

	select	pls_obter_valores_conta_comp(nr_seq_competencia_p, 'DA') vl_total
	into STRICT	vl_divida_ativa_w
	;

	vl_retorno_w := vl_final_w + vl_debitos_pendentes_w + vl_divida_ativa_w;
end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_valores_conta_comp ( nr_seq_competencia_p bigint, ie_tipo_movimentacao_p text) FROM PUBLIC;
