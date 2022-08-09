-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_liberar_automatic_pos ( nr_seq_analise_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_conta_p pls_conta.nr_sequencia%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Liberar pagamento total de um item da análise (Análise Nova)
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atençao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
qt_ocorrencia_w			integer;
qt_pagamento_fat_w		integer;
ie_regra_glosa_parcial_w	pls_regra_preco_pos_estab.ie_glosa_parc_valor%type;
vl_liberado_w			pls_conta_proc.vl_liberado%type;
vl_glosa_w			pls_conta_proc.vl_glosa%type;
ie_glosa_parcial_w		varchar(1);
qt_apresentada_w		pls_conta_proc.qt_procedimento_imp%type;
qt_liberada_w			pls_conta_proc.qt_procedimento_imp%type;
ie_glosa_qt_parcial_w		varchar(1);
ie_gerar_pos_remido_w		pls_parametro_faturamento.ie_gerar_pos_remido%type;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;

C01 CURSOR(nr_seq_analise_pc	pls_conta_pos_estabelecido.nr_seq_analise%type)FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_conta_proc,
		a.nr_seq_conta_mat,
		a.nr_seq_conta,
		a.nr_seq_regra_tp_pos,
		a.ie_vl_pag_prestador,
		a.nr_seq_disc_proc,
		a.nr_seq_disc_mat
	from	pls_conta_pos_estabelecido	a
	where	a.nr_seq_analise	= nr_seq_analise_p
	and	((a.ie_situacao		= 'A') or (coalesce(a.ie_situacao::text, '') = ''))
	and	a.vl_calculado	> 0
	and	a.ie_status_faturamento	!= 'A'
	and	a.ie_cobrar_mensalidade	!= 'A'
	and (coalesce(a.ie_tipo_liberacao::text, '') = '' or a.ie_tipo_liberacao <> 'U')
	and	coalesce(a.nr_seq_conta_pos_orig::text, '') = ''  -- nao pode ser um pos de estorno
	and	not exists (	SELECT	1 -- nao pode estar apontando para nenhum estorno
				from	pls_conta_pos_estabelecido	x
				where	x.nr_seq_conta_pos_orig		= a.nr_sequencia)
	
union all

	select	a.nr_sequencia,
		a.nr_seq_conta_proc,
		a.nr_seq_conta_mat,
		a.nr_seq_conta,
		a.nr_seq_regra_tp_pos,
		a.ie_vl_pag_prestador,
		a.nr_seq_disc_proc,
		a.nr_seq_disc_mat
	from	pls_conta_pos_estabelecido	a
	where	a.nr_seq_conta		= nr_seq_conta_p
	and	((a.ie_situacao		= 'A') or (coalesce(a.ie_situacao::text, '') = ''))
	and	a.vl_calculado	> 0
	and	a.ie_status_faturamento	!= 'A'
	and	a.ie_cobrar_mensalidade	!= 'A'
	and (coalesce(a.ie_tipo_liberacao::text, '') = '' or a.ie_tipo_liberacao <> 'U')
	and	coalesce(a.nr_seq_conta_pos_orig::text, '') = ''  -- nao pode ser um pos de estorno
	and	not exists (	select	1 -- nao pode estar apontando para nenhum estorno
				from	pls_conta_pos_estabelecido	x
				where	x.nr_seq_conta_pos_orig		= a.nr_sequencia);

C02 CURSOR FOR
	SELECT	distinct(nr_seq_conta) nr_seq_conta
	from	pls_conta_pos_estabelecido
	where	nr_seq_analise	= nr_seq_analise_p
	and	ie_status_faturamento	!= 'A'
	and	ie_cobrar_mensalidade	!= 'A'
	and	((ie_situacao		= 'A') or (coalesce(ie_situacao::text, '') = ''))
	
union all

	SELECT	distinct(nr_seq_conta) nr_seq_conta
	from	pls_conta_pos_estabelecido
	where	nr_seq_conta	= nr_seq_conta_p
	and	ie_status_faturamento	!= 'A'
	and	ie_cobrar_mensalidade	!= 'A'
	and	((ie_situacao		= 'A') or (coalesce(ie_situacao::text, '') = ''));
BEGIN

for r_c01_w in C01(nr_seq_analise_p) loop
	begin
	ie_regra_glosa_parcial_w := 'N';
	ie_glosa_parcial_w := 'N';
	ie_glosa_qt_parcial_w := 'N';
	select	count(1)
	into STRICT	qt_ocorrencia_w
	from	pls_ocorrencia_benef
	where	nr_seq_conta_pos_estab	= r_c01_w.nr_sequencia
	and	ie_situacao		= 'A';

	select	count(1)
	into STRICT	qt_pagamento_fat_w
	from	pls_ocorrencia_benef	b,
		pls_ocorrencia		a
	where	b.nr_seq_conta		= r_c01_w.nr_seq_conta
	and	coalesce(b.nr_seq_conta_proc::text, '') = ''
	and	coalesce(b.nr_seq_conta_mat::text, '') = ''
	and	b.ie_situacao		= 'A'
	and	a.nr_sequencia		= b.nr_seq_ocorrencia
	and 	a.ie_glosar_faturamento	= 'S'
	and	a.ie_auditoria_conta	= 'S';
	
	if (qt_pagamento_fat_w	= 0) then
		select	count(1)
		into STRICT	qt_pagamento_fat_w
		from	pls_conta_glosa		c
		where	c.nr_seq_conta		= r_c01_w.nr_seq_conta
		and	coalesce(c.nr_seq_conta_proc::text, '') = ''
		and	coalesce(c.nr_seq_conta_mat::text, '') = ''
		and	c.ie_situacao		= 'A'
		and	not exists (SELECT	1
					from	pls_ocorrencia_benef	b,
						pls_ocorrencia		a
					where	b.nr_sequencia		= c.nr_seq_ocorrencia_benef
					and	b.ie_situacao		= 'A'
					and	a.nr_sequencia		= b.nr_seq_ocorrencia
					and 	coalesce(a.ie_glosar_faturamento,'N')	= 'N');
		
		if (qt_pagamento_fat_w	= 0) then
			select	count(1)
			into STRICT	qt_pagamento_fat_w
			from	pls_conta_glosa		b
			where	b.nr_seq_conta_proc	= r_c01_w.nr_seq_conta_proc
			and	b.ie_situacao		= 'A'
			and	not exists (SELECT	1
						from	tiss_motivo_glosa y
						where	b.nr_seq_motivo_glosa = y.nr_sequencia
						and	y.cd_motivo_tiss in ('1705','1706'))
			and	not exists	(select	1
						from	pls_ocorrencia_benef	ocor
						where	1 = 1
						and	((ocor.nr_sequencia 	= b.nr_seq_ocorrencia_benef) or (ocor.nr_seq_glosa 	= b.nr_sequencia)));
			if (qt_pagamento_fat_w	= 0) then
				select	count(1)
				into STRICT	qt_pagamento_fat_w
				from	pls_conta_glosa		b
				where	b.nr_seq_conta_mat	= r_c01_w.nr_seq_conta_mat
				and	b.ie_situacao		= 'A'
				and	not exists (SELECT	1
							from	tiss_motivo_glosa y
							where	b.nr_seq_motivo_glosa = y.nr_sequencia
							and	y.cd_motivo_tiss in ('1705','1706'))
				and	not exists	(select	1
							from	pls_ocorrencia_benef	ocor
							where	1 = 1
							and	((ocor.nr_sequencia 	= b.nr_seq_ocorrencia_benef) or (ocor.nr_seq_glosa 	= b.nr_sequencia)));
				
			end if;
			
		end if;
	end if;
	
	--Se tiver glosa, verifica se a regra de valor do pos é do tipo glosa parcial
	if (qt_pagamento_fat_w > 0) then
		
		select  coalesce(max(ie_glosa_parc_valor),'N')
		into STRICT	ie_regra_glosa_parcial_w
		from	pls_regra_preco_pos_estab
		where	nr_sequencia = r_c01_w.nr_seq_regra_tp_pos;
		
		if (r_c01_w.nr_seq_conta_proc IS NOT NULL AND r_c01_w.nr_seq_conta_proc::text <> '') then
			select	vl_liberado,
				vl_glosa,
				qt_procedimento_imp,
				qt_procedimento
			into STRICT	vl_liberado_w,
				vl_glosa_w,
				qt_apresentada_w,
				qt_liberada_w
			from	pls_conta_proc
			where	nr_sequencia = r_c01_w.nr_seq_conta_proc;
		elsif (r_c01_w.nr_seq_conta_mat IS NOT NULL AND r_c01_w.nr_seq_conta_mat::text <> '') then
			select	vl_liberado,
				vl_glosa,
				qt_material_imp,
				qt_material
			into STRICT	vl_liberado_w,
				vl_glosa_w,
				qt_apresentada_w,
				qt_liberada_w
			from	pls_conta_mat
			where	nr_sequencia = r_c01_w.nr_seq_conta_mat;
		end if;
		
		if (qt_apresentada_w > qt_liberada_w) and (qt_liberada_w > 0) then
			ie_glosa_qt_parcial_w := 'S';
		end if;
		
		if (vl_glosa_w > 0 and vl_liberado_w > 0) then
			ie_glosa_parcial_w := 'S';
		else	
			ie_glosa_parcial_w := 'N';
		end if;
	end if;
	
	if	(qt_ocorrencia_w	= 0 AND qt_pagamento_fat_w	= 0) or
		(ie_regra_glosa_parcial_w = 'S' AND ie_glosa_parcial_w = 'S') and (ie_glosa_qt_parcial_w = 'N') then
		
		--Libera tudo, porém apenas verifica as conversoes quando nao for discussao 
		if ( coalesce(r_c01_w.nr_seq_disc_proc::text, '') = '' and coalesce(r_c01_w.nr_seq_disc_mat::text, '') = '') then
		
			update	pls_conta_pos_estabelecido
			set	qt_item				= CASE WHEN cd_unidade_medida = NULL THEN CASE WHEN nr_seq_regra_conv_proc = NULL THEN qt_original  ELSE CASE WHEN coalesce(qt_item,0)=0 THEN qt_original  ELSE qt_item END  END   ELSE CASE WHEN coalesce(qt_item,0)=0 THEN qt_original  ELSE qt_item END  END , --aaschlote OS 923624
				vl_beneficiario 		= (coalesce(vl_materiais_calc,0) + coalesce(vl_custo_operacional_calc,0) + coalesce(vl_medico_calc,0) + round((coalesce(vl_taxa_co,0))::numeric,2)+ round((coalesce(vl_taxa_material,0))::numeric,2) + round((coalesce(vl_taxa_servico,0))::numeric, 2)),
				ie_status_faturamento 		= 'L',
				nm_usuario 			= nm_usuario_p,
				dt_atualizacao 			= clock_timestamp(),
				vl_liberado_material_fat 	= vl_materiais_calc,
				vl_liberado_co_fat	   	= vl_custo_operacional_calc,
				vl_liberado_hi_fat		= vl_medico_calc,
				vl_glosa_material_fat		= 0,
				vl_glosa_hi_fat			= 0,
				vl_glosa_co_fat			= 0,
				vl_lib_taxa_co     		= vl_taxa_co,
				vl_lib_taxa_material		= vl_taxa_material,
				vl_lib_taxa_servico     	= vl_taxa_servico,
				vl_glosa_taxa_co     		= 0, 
				vl_glosa_taxa_material		= 0,
				vl_glosa_taxa_servico	 	= 0,
				vl_custo_operacional		= vl_custo_operacional_calc,
				vl_medico			= vl_medico_calc,
				vl_materiais			= vl_materiais_calc
			where	nr_sequencia			= r_c01_w.nr_sequencia;
		
		--Se for discussao, entao trata aqui
		else
		
			update	pls_conta_pos_estabelecido
			set	qt_item				= qt_item,
				vl_beneficiario 		= (coalesce(vl_materiais_calc,0) + coalesce(vl_custo_operacional_calc,0) + coalesce(vl_medico_calc,0) + round((coalesce(vl_taxa_co,0))::numeric,2)+ round((coalesce(vl_taxa_material,0))::numeric,2) + round((coalesce(vl_taxa_servico,0))::numeric, 2)),
				ie_status_faturamento 		= 'L',
				nm_usuario 			= nm_usuario_p,
				dt_atualizacao 			= clock_timestamp(),
				vl_liberado_material_fat 	= vl_materiais_calc,
				vl_liberado_co_fat	   	= vl_custo_operacional_calc,
				vl_liberado_hi_fat		= vl_medico_calc,
				vl_glosa_material_fat		= 0,
				vl_glosa_hi_fat			= 0,
				vl_glosa_co_fat			= 0,
				vl_lib_taxa_co     		= vl_taxa_co,
				vl_lib_taxa_material		= vl_taxa_material,
				vl_lib_taxa_servico     	= vl_taxa_servico,
				vl_glosa_taxa_co     		= 0, 
				vl_glosa_taxa_material		= 0,
				vl_glosa_taxa_servico	 	= 0,
				vl_custo_operacional		= vl_custo_operacional_calc,
				vl_medico			= vl_medico_calc,
				vl_materiais			= vl_materiais_calc
			where	nr_sequencia			= r_c01_w.nr_sequencia;
			
		end if;
			

	end if;
	
	end;
end loop;

for r_c02_w in C02() loop
	begin
	CALL pls_gerar_contab_val_adic(	r_c02_w.nr_seq_conta, null,null,
					null, null,null,
					null, 'P','N', nm_usuario_p);
	end;
end loop;

if (coalesce(cd_estabelecimento_p::text, '') = '') then

	select	max(b.cd_estabelecimento)
	into STRICT	cd_estabelecimento_w
	from	pls_conta_pos_estabelecido	a,
		pls_conta			b
	where	b.nr_sequencia		= a.nr_seq_conta
	and	a.nr_seq_analise	= nr_seq_analise_p;
	
else

	cd_estabelecimento_w := cd_estabelecimento_p;
end if;

--- carrega parametrizacoes do faturamento
select	coalesce(max(a.ie_gerar_pos_remido), 'N') ie_gerar_pos_remido
into STRICT	ie_gerar_pos_remido_w
from	pls_parametro_Faturamento	a
where	a.cd_estabelecimento		= cd_estabelecimento_w;

if (ie_gerar_pos_remido_w = 'S') then
	
	-- atualiza a cobranca de mensalidade
	CALL pls_cobrar_mens_remido(nr_seq_analise_p, null, null, null, cd_estabelecimento_w, nm_usuario_p);
	CALL pls_status_faturamento_remido(nr_seq_analise_p, null, null, null, cd_estabelecimento_w, nm_usuario_p);
end if;

end 	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_liberar_automatic_pos ( nr_seq_analise_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_conta_p pls_conta.nr_sequencia%type) FROM PUBLIC;
