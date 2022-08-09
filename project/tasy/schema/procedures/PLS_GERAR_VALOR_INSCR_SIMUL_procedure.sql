-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_valor_inscr_simul ( nr_seq_simul_individual_p bigint, nr_seq_simul_coletivo_p bigint, nr_seq_prop_benef_online_p pls_proposta_benef_online.nr_sequencia%type) AS $body$
DECLARE


nr_seq_plano_w			bigint;
ie_grau_dependencia_w		varchar(2);
nr_seq_regra_w			bigint;
vl_inscricao_w			double precision;
tx_inscricao_w			double precision;
vl_mensalidade_w		double precision;
vl_retorno_w			double precision;
vl_inscricao_simul_w		double precision;
ie_tipo_proposta_w		bigint;

c01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.vl_inscricao,
		a.tx_inscricao
	from	pls_regra_inscricao a
	where	a.nr_seq_plano		= nr_seq_plano_w
	and	(((coalesce(a.ie_grau_dependencia,ie_grau_dependencia_w) = ie_grau_dependencia_w) or (a.ie_grau_dependencia = 'A')) or (ie_grau_dependencia_w = 'A'))
	and	1	>= a.qt_parcela_inicial
	and	1	<= a.qt_parcela_final
	and	((a.ie_acao_contrato = 'A') or (coalesce(a.ie_acao_contrato::text, '') = ''))
	and	trunc(clock_timestamp(),'month') between trunc(coalesce(dt_inicio_vigencia,clock_timestamp()),'month') and trunc(coalesce(dt_fim_vigencia,clock_timestamp()),'month')
	and	((a.ie_tipo_proposta = ie_tipo_proposta_w) or (coalesce(a.ie_tipo_proposta::text, '') = ''));


BEGIN

if (nr_seq_simul_individual_p <> 0) then
	select	ie_tipo_benef,
		nr_seq_produto,
		vl_mensal_sem_desc,
		(	select	z.ie_tipo_proposta
			from	pls_simulacao_preco	w,
				pls_contrato		y,
				pls_segurado		x,
				pls_proposta_adesao	z
			where	w.nr_seq_contrato	= y.nr_sequencia
			and	x.nr_seq_contrato	= y.nr_sequencia
			and	x.nr_proposta_adesao	= z.nr_sequencia
			and	x.cd_pessoa_fisica	= a.cd_pessoa_fisica
			and	w.nr_sequencia		= a.nr_seq_simulacao) ie_tipo_proposta
	into STRICT	ie_grau_dependencia_w,
		nr_seq_plano_w,
		vl_mensalidade_w,
		ie_tipo_proposta_w
	from	pls_simulpreco_individual	a
	where	nr_sequencia	= nr_seq_simul_individual_p;
elsif (nr_seq_simul_coletivo_p <> 0) then
	select	'A',
		nr_seq_plano,
		vl_preco_sem_desconto,
		(	select	z.ie_tipo_proposta
			from	pls_simulacao_preco	x,
				pls_contrato		y,
				pls_proposta_adesao	z
			where	x.nr_seq_contrato	= y.nr_sequencia
			and	y.nr_seq_proposta	= z.nr_sequencia
			and	x.nr_sequencia		= a.nr_seq_simulacao) ie_tipo_proposta
	into STRICT	ie_grau_dependencia_w,
		nr_seq_plano_w,
		vl_mensalidade_w,
		ie_tipo_proposta_w
	from	pls_simulpreco_coletivo	a
	where	nr_sequencia	= nr_seq_simul_coletivo_p;
elsif (nr_seq_prop_benef_online_p <> 0) then
	select	a.ie_tipo_benef,
		b.nr_seq_plano,
		a.vl_mensal_sem_desc,
		null ie_tipo_proposta
	into STRICT	ie_grau_dependencia_w,
		nr_seq_plano_w,
		vl_mensalidade_w,
		ie_tipo_proposta_w
	from	pls_proposta_benef_online	a,
		pls_proposta_online b
	where	a.nr_seq_prop_online 	= b.nr_sequencia
	and 	a.nr_sequencia		= nr_seq_prop_benef_online_p;
end if;

open c01;
loop
fetch c01 into
	nr_seq_regra_w,
	vl_inscricao_w,
	tx_inscricao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	vl_retorno_w	:= coalesce(vl_retorno_w,0) + ((coalesce(tx_inscricao_w,0) / 100) * coalesce(vl_mensalidade_w,0)) + coalesce(vl_inscricao_w,0);
	end;
end loop;
close c01;

if (nr_seq_simul_individual_p <> 0) then
	select	max(vl_inscricao)
	into STRICT	vl_inscricao_simul_w
	from	pls_simulpreco_individual
	where	nr_sequencia	= nr_seq_simul_individual_p;

	update	pls_simulpreco_individual
	set	vl_inscricao	= vl_retorno_w
	where	nr_sequencia	= nr_seq_simul_individual_p;

elsif (nr_seq_simul_coletivo_p <> 0) then
	select	max(vl_inscricao)
	into STRICT	vl_inscricao_simul_w
	from	pls_simulpreco_coletivo
	where	nr_sequencia	= nr_seq_simul_coletivo_p;

	update	pls_simulpreco_coletivo
	set	vl_inscricao	= vl_retorno_w
	where	nr_sequencia	= nr_seq_simul_coletivo_p;
elsif (nr_seq_prop_benef_online_p <> 0) then
	update	pls_proposta_benef_online
	set	vl_inscricao	= vl_retorno_w
	where	nr_sequencia	= nr_seq_prop_benef_online_p;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_valor_inscr_simul ( nr_seq_simul_individual_p bigint, nr_seq_simul_coletivo_p bigint, nr_seq_prop_benef_online_p pls_proposta_benef_online.nr_sequencia%type) FROM PUBLIC;
