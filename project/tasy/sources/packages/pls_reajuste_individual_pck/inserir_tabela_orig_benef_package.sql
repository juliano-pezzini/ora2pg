-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_reajuste_individual_pck.inserir_tabela_orig_benef ( ie_tipo_operacao_plano_p text) AS $body$
DECLARE


C01 CURSOR(	ie_tipo_operacao_plano_pc	text,
		ie_regulamentacao_pc		pls_reajuste.ie_regulamentacao%type,
		nr_mes_reajuste_pc		bigint) FOR
	--	Busca as tabelas de preco vinculada ao beneficiario

	SELECT	c.nr_sequencia nr_seq_tabela,
		d.nr_sequencia nr_seq_plano,
		b.dt_contrato,
		b.nr_seq_contrato,
		c.nr_segurado nr_seq_segurado,
		a.dt_rescisao,
		coalesce((pls_obter_dados_segurado(c.nr_segurado, 'NRTI'))::numeric , c.nr_segurado) nr_seq_titular,
		pls_obter_dados_segurado(c.nr_segurado, 'PF') cd_pessoa_fisica,
		(SELECT	max(x.ie_reajuste)
		from	pls_contrato x
		where	x.nr_sequencia = b.nr_seq_contrato) ie_reajuste,
		coalesce(	(select	max(x.qt_intervalo)
			from	pls_contrato x
			where	x.nr_sequencia = b.nr_seq_contrato),12) qt_intervalo,
		a.dt_contratacao,
		(select	max(x.nr_seq_grupo_reajuste)
		from	pls_contrato x
		where	x.nr_sequencia = b.nr_seq_contrato) nr_seq_grupo_reajuste
	from	pls_segurado		a,
		pls_contrato_temp	b,
		pls_tabela_preco	c,
		pls_plano		d
	where	b.nr_seq_contrato	= a.nr_seq_contrato
	and	d.nr_sequencia		= c.nr_seq_plano
	and	c.nr_sequencia		= a.nr_seq_tabela
	and	d.ie_tipo_contratacao	= 'I'
	and	a.nr_mes_reajuste	= nr_mes_reajuste_pc
	and	not exists (	select	1
				from	pls_contrato_plano x
				where	x.nr_seq_contrato	= b.nr_seq_contrato
				and	x.nr_seq_tabela		= a.nr_seq_tabela)
	and	((d.ie_tipo_operacao = ie_tipo_operacao_plano_pc) or (coalesce(ie_tipo_operacao_plano_pc::text, '') = ''))
	and	((d.ie_regulamentacao = ie_regulamentacao_pc) or (coalesce(ie_regulamentacao_pc::text, '') = ''))
	
union

	--	Busca as tabelas de preco que ja foram vinculadas ao beneficiario

	select	c.nr_sequencia nr_seq_tabela,
		d.nr_sequencia nr_seq_plano,
		b.dt_contrato,
		b.nr_seq_contrato,
		c.nr_segurado nr_seq_segurado,
		a.dt_rescisao,
		coalesce((pls_obter_dados_segurado(c.nr_segurado, 'NRTI'))::numeric , c.nr_segurado) nr_seq_titular,
		pls_obter_dados_segurado(c.nr_segurado, 'PF') cd_pessoa_fisica,
		(select	max(x.ie_reajuste)
		from	pls_contrato x
		where	x.nr_sequencia = b.nr_seq_contrato) ie_reajuste,
		coalesce(	(select	max(x.qt_intervalo)
			from	pls_contrato x
			where	x.nr_sequencia = b.nr_seq_contrato),12) qt_intervalo,
		a.dt_contratacao,
		(select	max(x.nr_seq_grupo_reajuste)
		from	pls_contrato x
		where	x.nr_sequencia = b.nr_seq_contrato) nr_seq_grupo_reajuste
	from	pls_segurado		a,
		pls_contrato_temp	b,
		pls_tabela_preco	c,
		pls_plano		d
	where	b.nr_seq_contrato	= a.nr_seq_contrato
	and	d.nr_sequencia		= c.nr_seq_plano
	and	a.nr_sequencia		= c.nr_segurado
	and	d.ie_tipo_contratacao	= 'I'
	and	((c.nr_contrato = a.nr_seq_contrato) or (coalesce(c.nr_contrato::text, '') = ''))
	and	a.nr_mes_reajuste	= nr_mes_reajuste_pc
	and	not exists (	select	1
				from	pls_contrato_plano x
				where	x.nr_seq_contrato	= b.nr_seq_contrato
				and	x.nr_seq_tabela		= c.nr_sequencia)
	and	((d.ie_tipo_operacao = 'B') and (('A' <> ie_tipo_operacao_plano_pc) or (coalesce(ie_tipo_operacao_plano_pc::text, '') = '')))
	and	((d.ie_regulamentacao = ie_regulamentacao_pc) or (coalesce(ie_regulamentacao_pc::text, '') = ''));

BEGIN

for r_c01_w in c01(	ie_tipo_operacao_plano_p,
			current_setting('pls_reajuste_individual_pck.pls_reajuste_w')::pls_reajuste%rowtype.ie_regulamentacao,
			(to_char(current_setting('pls_reajuste_individual_pck.pls_reajuste_w')::pls_reajuste%rowtype.dt_reajuste,'mm'))::numeric ) loop
	begin
	
	alimentar_vetor(r_c01_w.nr_seq_tabela,
			r_c01_w.nr_seq_plano,
			r_c01_w.dt_contrato,
			r_c01_w.nr_seq_contrato,
			r_c01_w.nr_seq_segurado,
			r_c01_w.dt_rescisao,
			r_c01_w.nr_seq_titular,
			r_c01_w.cd_pessoa_fisica,
			r_c01_w.ie_reajuste,
			r_c01_w.qt_intervalo,
			r_c01_w.dt_contratacao,
			r_c01_w.nr_seq_grupo_reajuste);
	
	CALL pls_reajuste_individual_pck.inserir_tabelas('N');
	end;
end loop; --C01

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_reajuste_individual_pck.inserir_tabela_orig_benef ( ie_tipo_operacao_plano_p text) FROM PUBLIC;
