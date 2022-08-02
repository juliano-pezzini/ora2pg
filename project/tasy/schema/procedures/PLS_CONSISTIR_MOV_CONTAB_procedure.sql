-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_mov_contab ( nr_seq_movimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[  ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_item_mensalidade_w	bigint;
nr_seq_conta_proc_w		bigint;
nr_seq_conta_mat_w		bigint;
nr_seq_conta_copartic_w		bigint;
nr_seq_conta_pos_estab_w	bigint;
nr_seq_grupo_ans_w		bigint;
nr_seq_conta_resumo_w		pls_conta_medica_resumo.nr_sequencia%type;
nr_seq_conta_w			pls_conta.nr_sequencia%type;
nr_seq_conta_pos_estab_prev_w	pls_conta_pos_estab_prev.nr_sequencia%type;

cd_tipo_lote_contabil_w		bigint;
cd_estabelecimento_w		pls_conta.cd_estabelecimento%type;

qt_inconsistencia_mov_w		bigint;

ie_tipo_segurado_w		varchar(3);
ie_ato_cooperado_w		varchar(1);
ie_tipo_protocolo_w		pls_protocolo_conta.ie_tipo_protocolo%type;
ie_tipo_outorgante_w		pls_outorgante.ie_tipo_outorgante%type;
qt_registros_w			bigint;


BEGIN
qt_registros_w := 1;

begin
	select	a.nr_seq_item_mensalidade,
		a.nr_seq_conta_proc,
		a.nr_seq_conta_mat,
		a.nr_seq_conta_copartic,
		a.nr_seq_conta_pos_estab,
		a.nr_seq_conta_pos_estab_prev,
		b.cd_tipo_lote_contabil,
		a.nr_seq_resumo
	into STRICT	nr_seq_item_mensalidade_w,
		nr_seq_conta_proc_w,
		nr_seq_conta_mat_w,
		nr_seq_conta_copartic_w,
		nr_seq_conta_pos_estab_w,
		nr_seq_conta_pos_estab_prev_w,
		cd_tipo_lote_contabil_w,
		nr_seq_conta_resumo_w
	from	pls_movimento_contabil 		a,
		pls_atualizacao_contabil	b
	where	a.nr_seq_atualizacao	= b.nr_sequencia
	and	a.nr_sequencia		= nr_seq_movimento_p
	and 	a.ie_status 		<> '7';
exception
	when others then
	qt_registros_w := 0;
end;

if (qt_registros_w > 0) then
	if (nr_seq_item_mensalidade_w IS NOT NULL AND nr_seq_item_mensalidade_w::text <> '') then
		select	max(c.ie_tipo_segurado)
		into STRICT	ie_tipo_segurado_w
		from	pls_mensalidade_seg_item	a,
			pls_mensalidade_segurado	b,
			pls_segurado			c
		where	a.nr_seq_mensalidade_seg	= b.nr_sequencia
		and	b.nr_seq_segurado		= c.nr_sequencia
		and	a.nr_sequencia			= nr_seq_item_mensalidade_w;
		
		if (coalesce(ie_tipo_segurado_w::text, '') = '') then
			CALL pls_gravar_incons_mov_contab(nr_seq_movimento_p, 1, cd_tipo_lote_contabil_w, nm_usuario_p);
		end if;
	elsif (nr_seq_conta_proc_w IS NOT NULL AND nr_seq_conta_proc_w::text <> '') and (coalesce(nr_seq_conta_resumo_w::text, '') = '') then
		select	max(c.ie_tipo_segurado),
			max(a.ie_ato_cooperado),
			max(a.nr_seq_grupo_ans),
			max(b.cd_estabelecimento),
     			max(d.ie_tipo_protocolo)
		into STRICT	ie_tipo_segurado_w,
			ie_ato_cooperado_w,
			nr_seq_grupo_ans_w,
			cd_estabelecimento_w,
			ie_tipo_protocolo_w
		FROM pls_protocolo_conta d, pls_conta_proc a, pls_conta b
LEFT OUTER JOIN pls_segurado c ON (b.nr_seq_segurado = c.nr_sequencia)
WHERE a.nr_seq_conta		= b.nr_sequencia  and d.nr_sequencia = b.nr_seq_protocolo and a.nr_sequencia		= nr_seq_conta_proc_w;


		select	max(ie_tipo_outorgante)
		into STRICT	ie_tipo_outorgante_w
		from	pls_outorgante	a
		where	a.cd_estabelecimento	= cd_estabelecimento_w;
		
		if	((coalesce(ie_tipo_segurado_w::text, '') = '') and (ie_tipo_protocolo_w <> 'I')) then
			CALL pls_gravar_incons_mov_contab(nr_seq_movimento_p, 1, cd_tipo_lote_contabil_w, nm_usuario_p);
		end if;
		
		if (coalesce(ie_ato_cooperado_w::text, '') = '') and (ie_tipo_outorgante_w in ('3','4')) then
			CALL pls_gravar_incons_mov_contab(nr_seq_movimento_p, 2, cd_tipo_lote_contabil_w, nm_usuario_p);
		end if;
		
		if (coalesce(nr_seq_grupo_ans_w::text, '') = '') then
			CALL pls_gravar_incons_mov_contab(nr_seq_movimento_p, 3, cd_tipo_lote_contabil_w, nm_usuario_p);
		end if;
	elsif (nr_seq_conta_mat_w IS NOT NULL AND nr_seq_conta_mat_w::text <> '') and (coalesce(nr_seq_conta_resumo_w::text, '') = '') then
		select	max(c.ie_tipo_segurado),
			max(a.ie_ato_cooperado),
			max(a.nr_seq_grupo_ans),
			max(b.cd_estabelecimento),
			max(d.ie_tipo_protocolo)
		into STRICT	ie_tipo_segurado_w,
			ie_ato_cooperado_w,
			nr_seq_grupo_ans_w,
			cd_estabelecimento_w,
			ie_tipo_protocolo_w
		FROM pls_protocolo_conta d, pls_conta_mat a, pls_conta b
LEFT OUTER JOIN pls_segurado c ON (b.nr_seq_segurado = c.nr_sequencia)
WHERE a.nr_seq_conta		= b.nr_sequencia  and d.nr_sequencia = b.nr_seq_protocolo and a.nr_sequencia		= nr_seq_conta_mat_w;
		
		select	max(ie_tipo_outorgante)
		into STRICT	ie_tipo_outorgante_w
		from	pls_outorgante	a
		where	a.cd_estabelecimento	= cd_estabelecimento_w;
		
		if	((coalesce(ie_tipo_segurado_w::text, '') = '') and (ie_tipo_protocolo_w <> 'I')) then
			CALL pls_gravar_incons_mov_contab(nr_seq_movimento_p, 1, cd_tipo_lote_contabil_w, nm_usuario_p);
		end if;
		
		if (coalesce(ie_ato_cooperado_w::text, '') = '') and (ie_tipo_outorgante_w in ('3','4')) then
			CALL pls_gravar_incons_mov_contab(nr_seq_movimento_p, 2, cd_tipo_lote_contabil_w, nm_usuario_p);
		end if;
		
		if (coalesce(nr_seq_grupo_ans_w::text, '') = '') then
			CALL pls_gravar_incons_mov_contab(nr_seq_movimento_p, 3, cd_tipo_lote_contabil_w, nm_usuario_p);
		end if;
	elsif (nr_seq_conta_copartic_w IS NOT NULL AND nr_seq_conta_copartic_w::text <> '') then	
		select  max(c.ie_tipo_segurado)
		into STRICT	ie_tipo_segurado_w
		from	pls_conta_coparticipacao	a,
			pls_conta			b,
			pls_segurado			c,
			pls_conta_copartic_contab	d
		where	a.nr_seq_conta		= b.nr_sequencia
		and	b.nr_seq_segurado	= c.nr_sequencia
		and	d.nr_seq_conta_copartic	= a.nr_sequencia
		and	d.nr_sequencia		= nr_seq_conta_copartic_w;
		
		if (coalesce(ie_tipo_segurado_w::text, '') = '') then
			CALL pls_gravar_incons_mov_contab(nr_seq_movimento_p, 1, cd_tipo_lote_contabil_w, nm_usuario_p);
		end if;
	elsif (nr_seq_conta_pos_estab_w IS NOT NULL AND nr_seq_conta_pos_estab_w::text <> '') then	
		select	max(c.ie_tipo_segurado)
		into STRICT	ie_tipo_segurado_w
		from	pls_conta_pos_estabelecido	a,
			pls_conta			b,
			pls_segurado			c,
			pls_conta_pos_estab_contab	d
		where	a.nr_seq_conta		= b.nr_sequencia
		and	b.nr_seq_segurado	= c.nr_sequencia
		and	a.nr_sequencia		= d.nr_seq_conta_pos
		and	d.nr_sequencia		= nr_seq_conta_pos_estab_w;
		
		if (coalesce(ie_tipo_segurado_w::text, '') = '') then
			CALL pls_gravar_incons_mov_contab(nr_seq_movimento_p, 1, cd_tipo_lote_contabil_w, nm_usuario_p);
		end if;

	elsif (nr_seq_conta_pos_estab_prev_w IS NOT NULL AND nr_seq_conta_pos_estab_prev_w::text <> '') then
		select	max(c.ie_tipo_segurado)
		into STRICT	ie_tipo_segurado_w
		from	pls_conta_pos_estab_prev	a,
			pls_conta			b,
			pls_segurado			c
		where	a.nr_seq_conta		= b.nr_sequencia
		and	b.nr_seq_segurado	= c.nr_sequencia
		and	a.nr_sequencia		= nr_seq_conta_pos_estab_prev_w;
		
		if (coalesce(ie_tipo_segurado_w::text, '') = '') then
			CALL pls_gravar_incons_mov_contab(nr_seq_movimento_p, 1, cd_tipo_lote_contabil_w, nm_usuario_p);
		end if;
	elsif (nr_seq_conta_resumo_w IS NOT NULL AND nr_seq_conta_resumo_w::text <> '') then
		if (nr_seq_conta_mat_w IS NOT NULL AND nr_seq_conta_mat_w::text <> '') then

			select	nr_seq_conta
			into STRICT	nr_seq_conta_w
			from	pls_conta_mat
			where	nr_sequencia = nr_seq_conta_mat_w;

			select	max(c.ie_tipo_segurado),
				max(coalesce(a.ie_ato_cooperado,(	select	m.ie_ato_cooperado
								from	pls_conta_mat	m
								where	m.nr_sequencia	= a.nr_seq_conta_mat))) ie_ato_cooperado,
				max(coalesce(a.nr_seq_grupo_ans,(	select	m.nr_seq_grupo_ans
								from	pls_conta_mat	m
								where	m.nr_sequencia	= a.nr_seq_conta_mat))) nr_seq_grupo_ans,
				max(b.cd_estabelecimento)
			into STRICT	ie_tipo_segurado_w,
				ie_ato_cooperado_w,
				nr_seq_grupo_ans_w,
				cd_estabelecimento_w
			from	pls_conta_medica_resumo	a,
				pls_conta		b,
				pls_segurado		c
			where	a.nr_seq_conta		= b.nr_sequencia
			and	b.nr_seq_segurado	= c.nr_sequencia
			and	a.nr_sequencia		= nr_seq_conta_resumo_w
			and	b.nr_sequencia		= nr_seq_conta_w;
			
		elsif (nr_seq_conta_proc_w IS NOT NULL AND nr_seq_conta_proc_w::text <> '') then
			
			select	nr_seq_conta
			into STRICT	nr_seq_conta_w
			from	pls_conta_proc
			where	nr_sequencia = nr_seq_conta_proc_w;	
			
			select	max(c.ie_tipo_segurado),
				max(coalesce(a.ie_ato_cooperado,(	select	p.ie_ato_cooperado
								from	pls_conta_proc	p
								where	p.nr_sequencia	= a.nr_seq_conta_proc))) ie_ato_cooperado,
				max(coalesce(a.nr_seq_grupo_ans,(	select	p.nr_seq_grupo_ans
								from	pls_conta_proc	p
								where	p.nr_sequencia	= a.nr_seq_conta_proc))) nr_seq_grupo_ans,
				max(b.cd_estabelecimento)
			into STRICT	ie_tipo_segurado_w,
				ie_ato_cooperado_w,
				nr_seq_grupo_ans_w,
				cd_estabelecimento_w
			from	pls_conta_medica_resumo	a,
				pls_conta		b,
				pls_segurado		c
			where	a.nr_seq_conta		= b.nr_sequencia
			and	b.nr_seq_segurado	= c.nr_sequencia
			and	a.nr_sequencia		= nr_seq_conta_resumo_w
			and	b.nr_sequencia		= nr_seq_conta_w;
		end if;
			
		select	max(ie_tipo_outorgante)
		into STRICT	ie_tipo_outorgante_w
		from	pls_outorgante	a
		where	a.cd_estabelecimento	= cd_estabelecimento_w;
		
		if (coalesce(ie_tipo_segurado_w::text, '') = '') then
			CALL pls_gravar_incons_mov_contab(nr_seq_movimento_p, 1, cd_tipo_lote_contabil_w, nm_usuario_p);
		end if;
		
		if (coalesce(ie_ato_cooperado_w::text, '') = '') and (ie_tipo_outorgante_w in ('3','4')) then
			CALL pls_gravar_incons_mov_contab(nr_seq_movimento_p, 2, cd_tipo_lote_contabil_w, nm_usuario_p);
		end if;
		
		if (coalesce(nr_seq_grupo_ans_w::text, '') = '') then
			CALL pls_gravar_incons_mov_contab(nr_seq_movimento_p, 3, cd_tipo_lote_contabil_w, nm_usuario_p);
		end if;
	end if;

	select	count(1)
	into STRICT	qt_inconsistencia_mov_w
	from	pls_movto_contab_inconsist
	where	nr_seq_movimento	= nr_seq_movimento_p;

	if (qt_inconsistencia_mov_w > 0) then
		update	pls_movimento_contabil
		set	ie_status	= '5'
		where	nr_sequencia	= nr_seq_movimento_p;
	end if;
end if;
--commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_mov_contab ( nr_seq_movimento_p bigint, nm_usuario_p text) FROM PUBLIC;

