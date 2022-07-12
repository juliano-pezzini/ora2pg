-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ptu_obter_dados_label ( nr_sequencia_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


cd_unimed_origem_w		varchar(4);
vl_retorno_w			double precision;
vl_calculado_w			double precision;
vl_proc_w			double precision;
vl_material_w			double precision;
vl_glosado_w			double precision;
vl_material_glosa_w		double precision;
vl_total_fatura_w		double precision;
vl_taxa_interc_w		double precision;
vl_taxa_proc_w			double precision;
vl_taxa_mat_w			double precision;
tx_intercambio_w		double precision;
vl_total_proc_w			double precision;
vl_total_mat_w			double precision;
vl_total_taxa_proc_w		double precision;
vl_total_taxa_mat_w		double precision;
nr_seq_conta_w			bigint;
nr_seq_regra_w			bigint;
nr_seq_congenere_w		bigint;
dt_prev_envio_w			timestamp;
vl_total_a500_w			double precision;

-- VFA - Valor fatura apresentado (cabecalho do arquivo)

-- VL  - Valor da soma dos itens apresentados (valor liquido)

-- VTX - Valor total taxas apresentadas

-- VTF - Soma de VL + VTX


-- VC - Valor calculado dos procedimentos e materiais

-- VTI - Valor taxa intercambio calculada pelo sistema

-- VTC - Valor total calculado


-- VLI - Valor liberado

-- VG - Valor glosado

-- PRG - Porcentagem do valor glosado.
BEGIN
if (ie_opcao_p	= 'VC') then
	select	sum(coalesce(a.vl_total_partic,0)) + sum(coalesce(a.vl_custo_operacional,0)) + sum(coalesce(a.vl_materiais,0))
	into STRICT	vl_proc_w
	from	pls_conta_proc		a,
		pls_protocolo_conta	c,
		pls_conta		b
	where	c.nr_sequencia	= b.nr_seq_protocolo
	and	b.nr_sequencia	= a.nr_seq_conta
	and	b.nr_seq_fatura	= nr_sequencia_p
	and	a.ie_status not in ('D','M');
	
	select	coalesce(sum(a.vl_material_ptu),0)
	into STRICT	vl_material_w
	from	pls_conta_mat		a,
		pls_protocolo_conta	c,
		pls_conta		b
	where	b.nr_sequencia	= a.nr_seq_conta
	and	c.nr_sequencia	= b.nr_seq_protocolo
	and	b.nr_seq_fatura	= nr_sequencia_p
	and	a.ie_status not in ('D','M');
	
	vl_calculado_w	:= vl_proc_w + vl_material_w;
	
	vl_retorno_w	:= vl_calculado_w;
elsif (ie_opcao_p	= 'VG') then
	select	coalesce(sum(a.vl_glosa),0)
	into STRICT	vl_glosado_w
	from	pls_conta_proc		a,
		pls_protocolo_conta	c,
		pls_conta		b
	where	b.nr_sequencia	= a.nr_seq_conta
	and	c.nr_sequencia	= b.nr_seq_protocolo
	and	b.nr_seq_fatura	= nr_sequencia_p
	and	a.ie_status not in ('D','M');
	
	select	coalesce(sum(a.vl_glosa),0)
	into STRICT	vl_material_glosa_w
	from	pls_conta_mat		a,
		pls_protocolo_conta	c,
		pls_conta		b
	where	b.nr_sequencia	= a.nr_seq_conta
	and	c.nr_sequencia	= b.nr_seq_protocolo
	and	b.nr_seq_fatura	= nr_sequencia_p
	and	a.ie_status not in ('D','M');
	
	vl_retorno_w	:= vl_glosado_w + vl_material_glosa_w;
elsif (ie_opcao_p	= 'D') then
	select	coalesce(sum(a.vl_procedimento),0),
		coalesce(sum(a.vl_glosa),0)
	into STRICT	vl_calculado_w,
		vl_glosado_w
	from	pls_conta_proc		a,
		pls_protocolo_conta	c,
		pls_conta		b
	where	b.nr_sequencia	= a.nr_seq_conta
	and	c.nr_sequencia	= b.nr_seq_protocolo
	and	b.nr_seq_fatura	= nr_sequencia_p
	and	a.ie_status not in ('D','M');

	select	coalesce(sum(a.vl_material),0),
		coalesce(sum(a.vl_glosa),0)
	into STRICT	vl_material_w,
		vl_material_glosa_w
	from	pls_conta_mat		a,
		pls_protocolo_conta	c,
		pls_conta		b
	where	b.nr_sequencia	= a.nr_seq_conta
	and	c.nr_sequencia	= b.nr_seq_protocolo
	and	b.nr_seq_fatura	= nr_sequencia_p
	and	a.ie_status not in ('D','M');
	
	vl_retorno_w	:= (vl_calculado_w - vl_glosado_w) + (vl_material_w - vl_material_glosa_w);
elsif (ie_opcao_p	= 'VTF') then
	select	coalesce(sum(coalesce(c.vl_procedimento,0) +
			coalesce(c.vl_filme,0) + 
			coalesce(c.vl_custo_operacional,0) +
			coalesce(vl_adic_procedimento,0) + 
			coalesce(vl_adic_co,0) + 
			coalesce(vl_adic_filme,0)
			),0)
	into STRICT	vl_total_fatura_w
	from	ptu_nota_servico	c,
		ptu_nota_cobranca	b,
		ptu_fatura		a
	where	a.nr_sequencia	= b.nr_seq_fatura
	and	b.nr_sequencia	= c.nr_seq_nota_cobr
	and	a.nr_sequencia	= nr_sequencia_p;
	
	vl_retorno_w	:= vl_total_fatura_w;
elsif (ie_opcao_p	= 'VTX') then
	select	coalesce(sum(coalesce(vl_adic_procedimento,0) + coalesce(vl_adic_co,0) + coalesce(vl_adic_filme,0)),0)
	into STRICT	vl_total_fatura_w
	from	ptu_fatura		a,
		ptu_nota_cobranca	b,
		ptu_nota_servico	c
	where	a.nr_sequencia	= nr_sequencia_p
	and	a.nr_sequencia	= b.nr_seq_fatura
	and	b.nr_sequencia	= c.nr_seq_nota_cobr;
	
	vl_retorno_w	:= vl_total_fatura_w;
elsif (ie_opcao_p	= 'VL') then
	select	coalesce(sum(coalesce(c.vl_procedimento,0) + coalesce(c.vl_filme,0) + coalesce(c.vl_custo_operacional,0)),0)
	into STRICT	vl_total_fatura_w
	from	ptu_nota_servico	c,
		ptu_nota_cobranca	b,
		ptu_fatura		a
	where	a.nr_sequencia	= b.nr_seq_fatura
	and	b.nr_sequencia	= c.nr_seq_nota_cobr
	and	a.nr_sequencia	= nr_sequencia_p;

	vl_retorno_w	:= vl_total_fatura_w;
elsif (ie_opcao_p	= 'VTI') then
	select	coalesce(a.dt_recebimento_fatura,clock_timestamp()),
		cd_unimed_origem
	into STRICT	dt_prev_envio_w,
		cd_unimed_origem_w
	from	ptu_fatura		a
	where	a.nr_sequencia	= nr_sequencia_p;
	
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_congenere_w
	from	pls_congenere a
	where	a.cd_cooperativa = cd_unimed_origem_w;
	
	select	sum((coalesce(pls_obter_valor_taxas_total(a.nr_sequencia,'C'),0))::numeric )
		--nvl(sum(nvl(a.vl_procedimento_ptu,0) * 

		--	dividir(pls_obter_taxa_interc_conta(nvl(a.dt_procedimento,b.dt_emissao), dt_prev_envio_w, nr_seq_congenere_w, b.nr_seq_segurado),100)),0)
	into STRICT	vl_taxa_proc_w
	from	pls_conta_proc		a,
		pls_segurado		d,
		pls_conta		b,
		pls_protocolo_conta	c
	where	b.nr_sequencia	= a.nr_seq_conta
	and	c.nr_sequencia	= b.nr_seq_protocolo
	and	d.nr_sequencia	= b.nr_seq_segurado
	and	b.nr_seq_fatura	= nr_sequencia_p
	and	a.ie_status not in ('D','M');
	
	select	coalesce(sum(coalesce(a.vl_material_ptu,0) *
			dividir(pls_obter_taxa_interc_conta(coalesce(a.dt_atendimento,b.dt_emissao), dt_prev_envio_w, nr_seq_congenere_w, b.nr_seq_segurado),100)),0)
	into STRICT	vl_taxa_mat_w
	from	pls_conta_mat		a,
		pls_segurado		d,
		pls_conta		b,
		pls_protocolo_conta	c
	where	b.nr_sequencia	= a.nr_seq_conta
	and	c.nr_sequencia	= b.nr_seq_protocolo
	and	d.nr_sequencia	= b.nr_seq_segurado
	and	b.nr_seq_fatura	= nr_sequencia_p
	and	a.ie_status not in ('D','M');
	
	vl_taxa_interc_w	:= vl_taxa_proc_w + vl_taxa_mat_w;
	
	vl_retorno_w	:= vl_taxa_interc_w;
elsif (ie_opcao_p	= 'VFA') then
	select	vl_total_fatura
	into STRICT	vl_total_fatura_w
	from	ptu_fatura
	where	nr_sequencia = nr_sequencia_p;
	
	vl_retorno_w	:= vl_total_fatura_w;
elsif (ie_opcao_p	= 'VTC') then
	select	coalesce(a.dt_recebimento_fatura,clock_timestamp()),
		cd_unimed_origem
	into STRICT	dt_prev_envio_w,
		cd_unimed_origem_w
	from	ptu_fatura		a
	where	a.nr_sequencia	= nr_sequencia_p;
	
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_congenere_w
	from	pls_congenere a
	where	a.cd_cooperativa = cd_unimed_origem_w;

	select	sum(coalesce(a.vl_procedimento,0))
	into STRICT	vl_total_proc_w
	from	pls_conta_proc		a,
		pls_protocolo_conta	c,
		pls_conta		b
	where	c.nr_sequencia	= b.nr_seq_protocolo
	and	b.nr_sequencia	= a.nr_seq_conta
	and	b.nr_seq_fatura	= nr_sequencia_p
	and	a.ie_status not in ('D','M');
	
	select	coalesce(sum(coalesce(a.vl_material_ptu,0) *
			dividir(pls_obter_taxa_interc_conta(coalesce(a.dt_atendimento,b.dt_emissao), dt_prev_envio_w, nr_seq_congenere_w, b.nr_seq_segurado),100)),0)
	into STRICT	vl_total_taxa_mat_w
	from	pls_conta_mat		a,
		pls_segurado		d,
		pls_protocolo_conta	c,
		pls_conta		b
	where	b.nr_sequencia	= a.nr_seq_conta
	and	c.nr_sequencia	= b.nr_seq_protocolo
	and	d.nr_sequencia	= b.nr_seq_segurado
	and	b.nr_seq_fatura	= nr_sequencia_p
	and	a.ie_status not in ('D','M');
	
	select	coalesce(sum(a.vl_material_ptu),0)
	into STRICT	vl_total_mat_w
	from	pls_conta_mat		a,
		pls_segurado		d,
		pls_protocolo_conta	c,
		pls_conta		b
	where	b.nr_sequencia	= a.nr_seq_conta
	and	c.nr_sequencia	= b.nr_seq_protocolo
	and	d.nr_sequencia	= b.nr_seq_segurado
	and	b.nr_seq_fatura	= nr_sequencia_p
	and	a.ie_status not in ('D','M');
	
	vl_retorno_w	:= coalesce(vl_total_proc_w,0) + coalesce(vl_total_mat_w,0) + coalesce(vl_total_taxa_proc_w,0) + coalesce(vl_total_taxa_mat_w,0);	
elsif (ie_opcao_p	= 'VLI') then
	select	sum(coalesce(a.vl_liberado,0))
	into STRICT	vl_proc_w
	from	pls_conta_proc		a,
		pls_protocolo_conta	c,
		pls_conta		b
	where	b.nr_sequencia	= a.nr_seq_conta
	and	c.nr_sequencia	= b.nr_seq_protocolo
	and	b.nr_seq_fatura	= nr_sequencia_p
	and	a.ie_status not in ('D','M');

	select	sum(coalesce(a.vl_liberado,0))
	into STRICT	vl_material_w
	from	pls_conta_mat		a,
		pls_protocolo_conta	c,
		pls_conta		b
	where	b.nr_sequencia	= a.nr_seq_conta
	and	c.nr_sequencia	= b.nr_seq_protocolo
	and	b.nr_seq_fatura	= nr_sequencia_p
	and	a.ie_status not in ('D','M');
	
	vl_retorno_w	:= coalesce(vl_proc_w,0) + coalesce(vl_material_w,0);
elsif (ie_opcao_p	= 'PRG') then
	select	coalesce(sum(a.vl_glosa),0)
	into STRICT	vl_glosado_w
	from	pls_conta_proc		a,
		pls_protocolo_conta	c,
		pls_conta		b
	where	b.nr_sequencia	= a.nr_seq_conta
	and	c.nr_sequencia	= b.nr_seq_protocolo
	and	b.nr_seq_fatura	= nr_sequencia_p
	and	a.ie_status not in ('D','M');
	
	select	coalesce(sum(a.vl_glosa),0)
	into STRICT	vl_material_glosa_w
	from	pls_conta_mat		a,
		pls_protocolo_conta	c,
		pls_conta		b
	where	b.nr_sequencia	= a.nr_seq_conta
	and	c.nr_sequencia	= b.nr_seq_protocolo
	and	b.nr_seq_fatura	= nr_sequencia_p
	and	a.ie_status not in ('D','M');
	
	select	coalesce(vl_total_fatura,0) + coalesce(vl_total_ndc,0)
	into STRICT	vl_total_a500_w
	from	ptu_fatura
	where	nr_sequencia = nr_sequencia_p;
	
	vl_retorno_w	:= trunc(coalesce(dividir_sem_round(((vl_glosado_w + vl_material_glosa_w) * 100), vl_total_a500_w ),0),2);
end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ptu_obter_dados_label ( nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;
