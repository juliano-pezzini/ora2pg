-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



/*
	Rotina respons_vel para liberacao de item de p_s-estabelecido.
*/




CREATE OR REPLACE PROCEDURE pls_pos_estabelecido_pck.libera_automatic_pos ( nr_seq_lote_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


i				integer := 0;
tb_seq_item_w			pls_util_cta_pck.t_number_table;
qt_ocorrencia_w			integer;
qt_pagamento_fat_w		integer;
ie_regra_glosa_parcial_w	pls_regra_preco_pos_estab.ie_glosa_parc_valor%type;
vl_liberado_w			pls_conta_proc.vl_liberado%type;
vl_glosa_w			pls_conta_proc.vl_glosa%type;
ie_glosa_parcial_w		varchar(1);

C01 CURSOR(	nr_seq_lote_pc			pls_lote_protocolo_conta.nr_sequencia%type,
		nr_seq_protocolo_pc		pls_protocolo_conta.nr_sequencia%type,
		nr_seq_analise_pc		pls_analise_conta.nr_sequencia%type,
		nr_seq_conta_pc			pls_conta.nr_sequencia%type) FOR
	SELECT	nr_sequencia,
		nr_seq_conta_proc,
		nr_seq_conta,
		nr_seq_regra_preco	nr_seq_regra_tp_pos
	from	pls_conta_pos_proc
	where	nr_seq_conta	= nr_seq_conta_pc
	and (vl_materiais_calc + vl_medico_calc + vl_custo_operacional_calc) > 0
	
union all

	SELECT	nr_sequencia,
		nr_seq_conta_proc,
		nr_seq_conta,
		nr_seq_regra_preco	nr_seq_regra_tp_pos 
	from	pls_conta_pos_proc
	where	nr_seq_analise	= nr_seq_analise_pc
	and (vl_materiais_calc + vl_medico_calc + vl_custo_operacional_calc) > 0
	
union all

	select	a.nr_sequencia,
		a.nr_seq_conta_proc,
		a.nr_seq_conta,
		a.nr_seq_regra_preco	nr_seq_regra_tp_pos 
	from	pls_conta_pos_proc a,
		pls_conta_v b
	where	a.nr_seq_conta = b.nr_sequencia
	and	b.nr_seq_protocolo = nr_seq_protocolo_pc
	and (a.vl_materiais_calc + a.vl_medico_calc + a.vl_custo_operacional_calc) > 0
	
union all

	select	a.nr_sequencia,
		a.nr_seq_conta_proc,
		a.nr_seq_conta,
		a.nr_seq_regra_preco	nr_seq_regra_tp_pos 
	from	pls_conta_pos_proc a,
		pls_conta_v b
	where	a.nr_seq_conta = b.nr_sequencia
	and	b.nr_seq_lote_conta = nr_seq_lote_pc
	and (a.vl_materiais_calc + a.vl_medico_calc + a.vl_custo_operacional_calc) > 0;

C02 CURSOR(	nr_seq_lote_pc			pls_lote_protocolo_conta.nr_sequencia%type,
		nr_seq_protocolo_pc		pls_protocolo_conta.nr_sequencia%type,
		nr_seq_analise_pc		pls_analise_conta.nr_sequencia%type,
		nr_seq_conta_pc			pls_conta.nr_sequencia%type) FOR
	SELECT	nr_sequencia,
		nr_seq_conta_mat,
		nr_seq_conta,
		nr_seq_regra_pos_estab	nr_seq_regra_tp_pos
	from	pls_conta_pos_mat
	where	nr_seq_conta	= nr_seq_conta_pc
	and	vl_materiais_calc > 0
	
union all

	SELECT	nr_sequencia,
		nr_seq_conta_mat,
		nr_seq_conta,
		nr_seq_regra_pos_estab	nr_seq_regra_tp_pos 
	from	pls_conta_pos_mat
	where	nr_seq_analise	= nr_seq_analise_pc
	and	vl_materiais_calc > 0
	
union all

	select	a.nr_sequencia,
		a.nr_seq_conta_mat,
		a.nr_seq_conta,
		a.nr_seq_regra_pos_estab	nr_seq_regra_tp_pos 
	from	pls_conta_pos_mat a,
		pls_conta_v b
	where	a.nr_seq_conta = b.nr_sequencia
	and	vl_materiais_calc > 0
	and	b.nr_seq_protocolo = nr_seq_protocolo_pc
	
union all

	select	a.nr_sequencia,
		a.nr_seq_conta_mat,
		a.nr_seq_conta,
		a.nr_seq_regra_pos_estab	nr_seq_regra_tp_pos 
	from	pls_conta_pos_mat a,
		pls_conta_v b
	where	a.nr_seq_conta = b.nr_sequencia
	and	vl_materiais_calc > 0
	and	b.nr_seq_lote_conta = nr_seq_lote_pc;
BEGIN


	for r_c01_w in C01(nr_seq_lote_p,
	                   nr_seq_protocolo_p,
	                   nr_seq_analise_p,
	                   nr_seq_conta_p) loop		
		ie_regra_glosa_parcial_w := 'N';
		ie_glosa_parcial_w := 'N';
		select	count(1)
		into STRICT	qt_ocorrencia_w
		from	pls_ocorrencia_benef
		where	nr_seq_conta_pos_proc	= r_c01_w.nr_sequencia
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
			end if;
		end if;
		
		--Se tiver glosa, verifica se a regra de valor do pos _ do tipo glosa parcial

		if (qt_pagamento_fat_w > 0) then
			
			select  coalesce(max(ie_glosa_parc_valor),'N')
			into STRICT	ie_regra_glosa_parcial_w
			from	pls_regra_preco_pos_estab
			where	nr_sequencia = r_c01_w.nr_seq_regra_tp_pos;

			select	vl_liberado,
				vl_glosa
			into STRICT	vl_liberado_w,
				vl_glosa_w
			from	pls_conta_proc
			where	nr_sequencia = r_c01_w.nr_seq_conta_proc;
			
			if ( vl_glosa_w > 0 and vl_liberado_w > 0) then
				ie_glosa_parcial_w := 'S';
			else	
				ie_glosa_parcial_w := 'N';
			end if;
		end if;
		
		if	( qt_ocorrencia_w	= 0 AND  qt_pagamento_fat_w	= 0) or
			 ( ie_regra_glosa_parcial_w = 'S' AND  ie_glosa_parcial_w = 'S') then			
			tb_seq_item_w(i) := r_c01_w.nr_sequencia;
			
			if ( i > pls_util_cta_pck.qt_registro_transacao_w) then
				tb_seq_item_w := pls_pos_estabelecido_pck.upd_lib_automatic_pos_proc(tb_seq_item_w, nm_usuario_p);
				i := 0;
			else
				i := i + 1;
			end if;
		end if;
	end loop;
	
	 tb_seq_item_w := pls_pos_estabelecido_pck.upd_lib_automatic_pos_proc( tb_seq_item_w, nm_usuario_p);
	i := 0;
	
	for r_c02_w in C02(nr_seq_lote_p,
	                   nr_seq_protocolo_p,
	                   nr_seq_analise_p,
	                   nr_seq_conta_p) loop
	
		ie_regra_glosa_parcial_w := 'N';
		ie_glosa_parcial_w := 'N';
		select	count(1)
		into STRICT	qt_ocorrencia_w
		from	pls_ocorrencia_benef
		where	nr_seq_conta_pos_mat	= r_c02_w.nr_sequencia
		and	ie_situacao		= 'A';

		select	count(1)
		into STRICT	qt_pagamento_fat_w
		from	pls_ocorrencia_benef	b,
			pls_ocorrencia		a
		where	b.nr_seq_conta		= r_c02_w.nr_seq_conta
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
			where	c.nr_seq_conta		= r_c02_w.nr_seq_conta
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
				where	b.nr_seq_conta_mat	= r_c02_w.nr_seq_conta_mat
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
		
		--Se tiver glosa, verifica se a regra de valor do pos _ do tipo glosa parcial

		if (qt_pagamento_fat_w > 0) then
			
			select  coalesce(max(ie_glosa_parc_valor),'N')
			into STRICT	ie_regra_glosa_parcial_w
			from	pls_regra_preco_pos_estab
			where	nr_sequencia = r_c02_w.nr_seq_regra_tp_pos;
			
			select	vl_liberado,
				vl_glosa
			into STRICT	vl_liberado_w,
				vl_glosa_w
			from	pls_conta_mat
			where	nr_sequencia = r_c02_w.nr_seq_conta_mat;
			
			if ( vl_glosa_w > 0 and vl_liberado_w > 0) then
				ie_glosa_parcial_w := 'S';
			else	
				ie_glosa_parcial_w := 'N';
			end if;
		end if;
		
		if	( qt_ocorrencia_w	= 0 AND  qt_pagamento_fat_w	= 0) or
			 ( ie_regra_glosa_parcial_w = 'S' AND  ie_glosa_parcial_w = 'S') then
		
			tb_seq_item_w(i) := r_c02_w.nr_sequencia;
			
			if ( i > pls_util_cta_pck.qt_registro_transacao_w) then
				 tb_seq_item_w := pls_pos_estabelecido_pck.upd_lib_automatic_pos_mat( tb_seq_item_w, nm_usuario_p);
				i := 0;
			else
				i := i + 1;
			end if;
		end if;
	end loop;
	
	tb_seq_item_w := pls_pos_estabelecido_pck.upd_lib_automatic_pos_mat(tb_seq_item_w, nm_usuario_p);
	
	--Necessita atualizar valorer cont_beis.

	CALL pls_pos_estabelecido_pck.geracao_valores_contabeis(null, null, null,
	                          null, nm_usuario_p, cd_estabelecimento_p);
	
	CALL pls_pos_estabelecido_pck.geracao_valores_ptu( nm_usuario_p, cd_estabelecimento_p);
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pos_estabelecido_pck.libera_automatic_pos ( nr_seq_lote_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
