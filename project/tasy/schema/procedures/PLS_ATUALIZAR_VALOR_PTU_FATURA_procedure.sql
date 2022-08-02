-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_valor_ptu_fatura ( nr_seq_fatura_p ptu_fatura.nr_sequencia%type, ie_commit_p text) AS $body$
DECLARE


-- TOTAL
vl_liberado_w			double precision := 0;
vl_total_w			double precision := 0;
vl_total_fatura_w		double precision := 0;
vl_procedimento_glosa_w		double precision := 0;
vl_material_glosa_w		double precision := 0;
vl_fatura_glosa_w		double precision := 0;
vl_pendente_w			double precision := 0;
vl_procedimento_liberado_w	double precision := 0;
vl_material_liberado_w		double precision := 0;
vl_fatura_liberado_w		double precision := 0;
ie_classif_cobranca_w		varchar(1);

-- GLOSA
vl_glosa_ndc_w			double precision := 0;
vl_glosa_fatura_w		double precision := 0;
vl_glosa_proc_w			double precision := 0;
vl_glosa_material_w		double precision := 0;
vl_glosa_tx_proc_w		double precision := 0;
vl_glosa_tx_material_w		double precision := 0;

-- LIBERADO
vl_liberado_ndc_w		double precision := 0;
vl_liberado_fatura_w		double precision := 0;
vl_liberado_proc_w		double precision := 0;
vl_liberado_material_w		double precision := 0;
vl_liberado_tx_proc_w		double precision := 0;
vl_liberado_tx_material_w	double precision := 0;
					

BEGIN
if (nr_seq_fatura_p IS NOT NULL AND nr_seq_fatura_p::text <> '') then

	select	coalesce(sum(a.vl_glosa),0),
		coalesce(sum(a.vl_liberado),0),
		sum(coalesce(a.vl_glosa_hi,0)) + sum(coalesce(a.vl_glosa_co,0)) + sum(coalesce(a.vl_glosa_material,0)),
		sum(coalesce(a.vl_glosa_taxa_servico,0)) + sum(coalesce(a.vl_glosa_taxa_co,0)) + sum(coalesce(a.vl_glosa_taxa_material,0)),
		sum(coalesce(a.vl_liberado_hi,0)) + sum(coalesce(a.vl_liberado_co,0)) + sum(coalesce(a.vl_liberado_material,0)),
		sum(coalesce(a.vl_lib_taxa_servico,0)) + sum(coalesce(a.vl_lib_taxa_co,0)) + sum(coalesce(a.vl_lib_taxa_material,0))
	into STRICT	vl_procedimento_glosa_w,
		vl_procedimento_liberado_w,
		vl_glosa_proc_w,
		vl_glosa_tx_proc_w,
		vl_liberado_proc_w,
		vl_liberado_tx_proc_w
	from	pls_conta_proc		a,
		pls_conta		b
	where	b.nr_seq_fatura	= nr_seq_fatura_p
	and	a.nr_seq_conta = b.nr_sequencia
	and	a.ie_status <> 'M';
	
	select	coalesce(sum(a.vl_glosa),0),
		coalesce(sum(a.vl_liberado),0),
		sum(coalesce(a.vl_glosa,0)) - sum(coalesce(a.vl_glosa_taxa_material,0)),
		sum(coalesce(a.vl_glosa_taxa_material,0)),
		sum(coalesce(a.vl_liberado,0)) - sum(coalesce(a.vl_lib_taxa_material,0)),
		sum(coalesce(a.vl_lib_taxa_material,0))
	into STRICT	vl_material_glosa_w,
		vl_material_liberado_w,
		vl_glosa_material_w,
		vl_glosa_tx_material_w,
		vl_liberado_material_w,
		vl_liberado_tx_material_w
	from	pls_conta_mat a,
		pls_conta b
	where	b.nr_seq_fatura	= nr_seq_fatura_p
	and	a.nr_seq_conta = b.nr_sequencia
	and	a.ie_status <> 'M';
	
	vl_fatura_glosa_w := vl_procedimento_glosa_w + vl_material_glosa_w;
	vl_fatura_liberado_w := vl_procedimento_liberado_w + vl_material_liberado_w;
	
	-- VALORES DE GLOSA
	vl_glosa_ndc_w := coalesce(vl_glosa_ndc_w,0) + coalesce(vl_glosa_proc_w,0) + coalesce(vl_glosa_material_w,0);
	vl_glosa_fatura_w := coalesce(vl_glosa_fatura_w,0) + coalesce(vl_glosa_tx_proc_w,0) + coalesce(vl_glosa_tx_material_w,0);
	
	-- VALORES LIBERADOS
	vl_liberado_ndc_w := coalesce(vl_liberado_ndc_w,0) + coalesce(vl_liberado_proc_w,0) + coalesce(vl_liberado_material_w,0);
	vl_liberado_fatura_w := coalesce(vl_liberado_fatura_w,0) + coalesce(vl_liberado_tx_proc_w,0) + coalesce(vl_liberado_tx_material_w,0);
	vl_liberado_w := coalesce(vl_liberado_ndc_w,0) + coalesce(vl_liberado_fatura_w,0);
		
	vl_total_w := coalesce(vl_fatura_glosa_w,0) + coalesce(vl_liberado_w,0);
		
	select	coalesce(a.vl_total_fatura,0) + coalesce(a.vl_total_ndc,0),
		coalesce(a.ie_classif_cobranca,'2')
	into STRICT	vl_total_fatura_w,
		ie_classif_cobranca_w
	from	ptu_fatura a
	where	a.nr_sequencia	= nr_seq_fatura_p;
	
	-- NDC
	if (ie_classif_cobranca_w = '1') then

		vl_liberado_ndc_w := vl_liberado_ndc_w + vl_liberado_fatura_w;
		vl_liberado_fatura_w := 0;
		vl_glosa_ndc_w := vl_fatura_glosa_w;
		vl_glosa_fatura_w := 0;
		
		if (vl_liberado_ndc_w < vl_fatura_liberado_w) then
			vl_liberado_ndc_w := vl_fatura_liberado_w;
			vl_total_w := coalesce(vl_fatura_glosa_w,0) + vl_fatura_liberado_w;
		end if;
	
	-- FATURA
	elsif (ie_classif_cobranca_w = '2') then
		vl_liberado_fatura_w := vl_liberado_fatura_w + vl_liberado_ndc_w;
		vl_liberado_ndc_w := 0;
		vl_glosa_fatura_w := vl_fatura_glosa_w;
		vl_glosa_ndc_w := 0;
		
		--se o valores somados forem diferentes do total liberado da analise, assume o total liberado da analise
		if (vl_liberado_fatura_w <> vl_fatura_liberado_w) then
			vl_liberado_fatura_w := vl_fatura_liberado_w;
			vl_total_w := coalesce(vl_fatura_glosa_w,0) + vl_fatura_liberado_w;
		end if;
	end if;
	
	vl_pendente_w := (vl_total_fatura_w - vl_total_w);
	
	if (vl_pendente_w < 0) then
		vl_pendente_w := 0;
	end if;
		
	update	ptu_fatura
	set	vl_total	= vl_liberado_fatura_w,
		vl_liberado_ndc	= vl_liberado_ndc_w,
		vl_glosa	= vl_glosa_fatura_w,
		vl_glosa_ndc	= vl_glosa_ndc_w,
		vl_pendente	= vl_pendente_w
	where	nr_sequencia	= nr_seq_fatura_p;

	if (coalesce(ie_commit_p,'N') = 'S') then
		commit;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_valor_ptu_fatura ( nr_seq_fatura_p ptu_fatura.nr_sequencia%type, ie_commit_p text) FROM PUBLIC;

