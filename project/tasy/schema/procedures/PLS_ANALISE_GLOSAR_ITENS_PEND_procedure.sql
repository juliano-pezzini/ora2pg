-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_analise_glosar_itens_pend (nr_seq_analise_p pls_analise_glo_ocor_grupo.nr_seq_analise%type, nr_seq_grupo_atual_p pls_analise_glo_ocor_grupo.nr_seq_grupo%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, ie_glosa_atend_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Glosar todos os itens pendentes para o grupo ou sem fluxo de análise ao finalizar
a análise do grupo
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_manter_w				varchar(255) := 'N';
ie_ultimo_grupo_w			varchar(1) := 'N';
nr_seq_conta_w				bigint;
nr_seq_conta_proc_w			bigint;
nr_seq_conta_mat_w			bigint;
nr_seq_proc_partic_w			bigint;
nr_seq_mot_liberacao_glosa_w		bigint;
nr_seq_conta_glosa_w			bigint;
nr_seq_conta_pos_estab_w		bigint;
qt_glosa_w				bigint;
qt_ocorrencia_glosa_w			bigint;
qt_parecer_ocor_w			bigint;
qt_parecer_glosa_w			bigint;
qt_parecer_ocor_def_w			bigint;
qt_parecer_glosa_def_w			bigint;
qt_parecer_w				bigint;
ie_finalizar_w				varchar(1);
nr_id_transacao_w			w_pls_analise_item.nr_id_transacao%type;

/* Itens pendentes de análise do grupo */

C01 CURSOR FOR
	SELECT	a.nr_seq_conta,
		a.nr_seq_conta_proc,
		a.nr_seq_conta_mat,
		a.nr_seq_proc_partic,
		a.nr_seq_conta_pos_estab
	from	w_pls_analise_item a
	where	a.nr_seq_analise	= nr_seq_analise_p
	and	a.nm_usuario		= nm_usuario_p
	and	((a.nr_id_transacao	= nr_id_transacao_w) or (coalesce(nr_id_transacao_w::text, '') = ''))
	and	a.ie_status_analise	= 'A' /* Amarelo - Pendente */
	and	a.ie_pend_grupo		= 'S'
	
union all

	SELECT	a.nr_seq_conta,
		a.nr_seq_conta_proc,
		a.nr_seq_conta_mat,
		a.nr_seq_proc_partic,
		a.nr_seq_conta_pos_estab
	from	w_pls_analise_item a
	where	a.nr_seq_analise	= nr_seq_analise_p
	and	a.nm_usuario		= nm_usuario_p
	and	((a.nr_id_transacao	= nr_id_transacao_w) or (coalesce(nr_id_transacao_w::text, '') = ''))
	and	a.ie_status_analise	= 'A' /* Amarelo - Pendente */
	and	ie_ultimo_grupo_w	= 'S'
	
union all

	select	a.nr_seq_conta,
		a.nr_seq_conta_proc,
		a.nr_seq_conta_mat,
		a.nr_seq_proc_partic,
		a.nr_seq_conta_pos_estab
	from	pls_ocorrencia_benef		a,
		pls_analise_glo_ocor_grupo	b
	where	a.nr_sequencia		= b.nr_seq_ocor_benef
	and	b.nr_seq_analise	= nr_seq_analise_p
	and	b.nr_seq_grupo		= nr_seq_grupo_atual_p
	and	b.ie_status		= 'P'
	
union all

	select	a.nr_seq_conta,
		a.nr_seq_conta_proc,
		a.nr_seq_conta_mat,
		a.nr_seq_proc_partic,
		a.nr_seq_conta_pos_estab
	from	w_pls_analise_item a
	where	a.nr_seq_analise	= nr_seq_analise_p
	and	a.nm_usuario		= nm_usuario_p
	and	((a.nr_id_transacao	= nr_id_transacao_w) or (coalesce(nr_id_transacao_w::text, '') = ''))
	and	a.ie_pagamento		= 'I' /* Amarelo - Pendente */
	and	ie_ultimo_grupo_w	= 'S';

C02 CURSOR FOR
	SELECT	nr_sequencia	nr_seq_conta_proc,
		null		nr_seq_conta_mat,
		nr_seq_conta
	from	pls_conta_proc	a
	where	a.ie_status not in ('D','L','S','M')
	and	a.nr_seq_conta	in (	SELECT	x.nr_sequencia
					from	pls_conta	x
					where	x.nr_seq_analise	= nr_seq_analise_p)
	
union all

	select	null		nr_seq_conta_proc,
		nr_sequencia	nr_seq_conta_mat,
		nr_seq_conta
	from	pls_conta_mat	a
	where	a.ie_status not in ('D','L','S','M')
	and	a.nr_seq_conta	in (	select	x.nr_sequencia
					from	pls_conta	x
					where	x.nr_seq_analise	= nr_seq_analise_p);
BEGIN
if (nr_seq_analise_p IS NOT NULL AND nr_seq_analise_p::text <> '') then

	select 	max(nr_id_transacao)
	into STRICT	nr_id_transacao_w
	from	w_pls_analise_item a
	where	a.nr_seq_analise	= nr_seq_analise_p
	and		a.nm_usuario		= nm_usuario_p;

	select	max(nr_seq_mot_liberacao_glosa)
	into STRICT	nr_seq_mot_liberacao_glosa_w
	from	pls_param_analise_conta a
	where	a.cd_estabelecimento	= cd_estabelecimento_p;

	if (coalesce(nr_seq_mot_liberacao_glosa_w::text, '') = '') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(206197);
	end if;

	ie_ultimo_grupo_w := pls_obter_se_fim_fluxo_analise(nr_seq_analise_p,nr_seq_grupo_atual_p);

	open C01;
	loop
	fetch C01 into
		nr_seq_conta_w,
		nr_seq_conta_proc_w,
		nr_seq_conta_mat_w,
		nr_seq_proc_partic_w,
		nr_seq_conta_pos_estab_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		-- feito o if abaixo para verificar se o que está retornando no select é procedimento, material ou conta
		if (nr_seq_conta_proc_w IS NOT NULL AND nr_seq_conta_proc_w::text <> '') then

			-- select para buscar quando for procedimento
			select 	count(1)
			into STRICT	qt_ocorrencia_glosa_w
			from	pls_ocorrencia_benef	a,
				pls_ocorrencia		b
			where	a.nr_seq_ocorrencia	= b.nr_sequencia
			and	a.nr_seq_conta_proc 	= nr_seq_conta_proc_w
			and	a.nr_seq_conta		= nr_seq_conta_w
			and	a.ie_situacao	 	= 'A'
			and	b.ie_glosar_pagamento	= 'S'
			and	not exists (	SELECT	1
						from	tiss_motivo_glosa y,
							pls_conta_glosa x
						where	x.nr_seq_motivo_glosa = y.nr_sequencia
						and	((x.nr_sequencia = a.nr_seq_glosa ) or (x.nr_seq_ocorrencia_benef = a.nr_sequencia))
						and	y.cd_motivo_tiss in ('1705','1706'))  LIMIT 1;

			select	count(1)
			into STRICT	qt_glosa_w
			from	pls_conta_glosa	a
			where	a.nr_seq_conta_proc 	= nr_seq_conta_proc_w
			and 	a.nr_seq_conta		= nr_seq_conta_w
			and	a.ie_situacao	 	= 'A'
			and	not exists (	SELECT	1
						from	tiss_motivo_glosa y
						where	a.nr_seq_motivo_glosa = y.nr_sequencia
						and	y.cd_motivo_tiss in ('1705','1706'))  LIMIT 1;

		elsif (nr_seq_conta_mat_w IS NOT NULL AND nr_seq_conta_mat_w::text <> '') then

			-- select para buscar quando for material
			select 	count(1)
			into STRICT	qt_ocorrencia_glosa_w
			from	pls_ocorrencia_benef	a,
				pls_ocorrencia		b
			where	a.nr_seq_ocorrencia	= b.nr_sequencia
			and	a.nr_seq_conta_mat	= nr_seq_conta_mat_w
			and	a.nr_seq_conta		= nr_seq_conta_w
			and	a.ie_situacao	 	= 'A'
			and	b.ie_glosar_pagamento	= 'S'
			and	not exists (	SELECT	1
						from	tiss_motivo_glosa y,
							pls_conta_glosa x
						where	x.nr_seq_motivo_glosa = y.nr_sequencia
						and	((x.nr_sequencia = a.nr_seq_glosa ) or (x.nr_seq_ocorrencia_benef = a.nr_sequencia))
						and	y.cd_motivo_tiss in ('1705','1706'))  LIMIT 1;

			select	count(1)
			into STRICT	qt_glosa_w
			from	pls_conta_glosa	a
			where	a.nr_seq_conta_mat = nr_seq_conta_mat_w
			and 	a.nr_seq_conta = nr_seq_conta_w
			and	ie_situacao = 'A'
			and	not exists (	SELECT	1
						from	tiss_motivo_glosa y
						where	a.nr_seq_motivo_glosa 	= y.nr_sequencia
						and	y.cd_motivo_tiss 	in ('1705','1706'))  LIMIT 1;

		elsif (nr_seq_conta_w IS NOT NULL AND nr_seq_conta_w::text <> '') then

			-- select para buscar quando for apenas a conta informada
			select 	count(1)
			into STRICT	qt_ocorrencia_glosa_w
			from	pls_ocorrencia_benef	a,
				pls_ocorrencia		b
			where	a.nr_seq_ocorrencia	= b.nr_sequencia
			and	a.nr_seq_conta		= nr_seq_conta_w
			and	coalesce(a.nr_seq_conta_mat::text, '') = ''
			and	coalesce(a.nr_seq_conta_proc::text, '') = ''
			and	a.ie_situacao	 	= 'A'
			and	b.ie_glosar_pagamento	= 'S'
			and	not exists (	SELECT	1
						from	tiss_motivo_glosa y,
							pls_conta_glosa x
						where	x.nr_seq_motivo_glosa 	= y.nr_sequencia
						and	((x.nr_sequencia 	= a.nr_seq_glosa ) or (x.nr_seq_ocorrencia_benef = a.nr_sequencia))
						and	y.cd_motivo_tiss 	in ('1705','1706'))  LIMIT 1;

			select	count(1)
			into STRICT	qt_glosa_w
			from	pls_conta_glosa	a
			where	a.nr_seq_conta		= nr_seq_conta_w
			and	a.ie_situacao	 	= 'A'
			and	coalesce(a.nr_seq_conta_mat::text, '') = ''
			and	coalesce(a.nr_seq_conta_proc::text, '') = ''
			and	not exists (	SELECT	1
						from	tiss_motivo_glosa y
						where	a.nr_seq_motivo_glosa = y.nr_sequencia
						and	y.cd_motivo_tiss in ('1705','1706'))  LIMIT 1;
		end if;

		-- se possui alguma ocorrencia ou glosa
		if (qt_glosa_w > 0) or (qt_ocorrencia_glosa_w > 0) then

			if (nr_seq_conta_pos_estab_w IS NOT NULL AND nr_seq_conta_pos_estab_w::text <> '') then

				CALL pls_analise_glosar_item_pos(	nr_seq_analise_p, nr_seq_conta_w, nr_seq_conta_proc_w,
								nr_seq_conta_mat_w, nr_seq_conta_pos_estab_w, null,
								nr_seq_mot_liberacao_glosa_w, null, cd_estabelecimento_p,
								nr_seq_grupo_atual_p, 'N', 'N',
								nm_usuario_p);

			else
				if (nr_seq_proc_partic_w IS NOT NULL AND nr_seq_proc_partic_w::text <> '') then

					nr_seq_conta_proc_w	:= null;

					select	count(1),
						sum(CASE WHEN a.ie_status='P' THEN  0 WHEN a.ie_status='M' THEN  0  ELSE 1 END )
					into STRICT	qt_parecer_ocor_w,
						qt_parecer_ocor_def_w
					from	pls_ocorrencia_benef		b,
						pls_analise_glo_ocor_grupo	a
					where	a.nr_seq_analise	= nr_seq_analise_p
					and	a.nr_seq_ocor_benef	= b.nr_sequencia
					and	b.nr_seq_proc_partic	= nr_seq_proc_partic_w;

					select	count(1),
						sum(CASE WHEN a.ie_status='P' THEN  0 WHEN a.ie_status='M' THEN  0  ELSE 1 END )
					into STRICT	qt_parecer_glosa_w,
						qt_parecer_glosa_def_w
					from	pls_conta_glosa			b,
						pls_analise_glo_ocor_grupo	a
					where	a.nr_seq_analise	= nr_seq_analise_p
					and	a.nr_seq_conta_glosa	= b.nr_sequencia
					and	b.nr_seq_proc_partic	= nr_seq_proc_partic_w;

					select	count(1)
					into STRICT	qt_parecer_w
					from	pls_analise_fluxo_item
					where	nr_seq_proc_partic	= nr_seq_proc_partic_w  LIMIT 1;

				elsif (nr_seq_conta_proc_w IS NOT NULL AND nr_seq_conta_proc_w::text <> '') then

					select	count(1),
						sum(CASE WHEN a.ie_status='P' THEN  0 WHEN a.ie_status='M' THEN  0  ELSE 1 END )
					into STRICT	qt_parecer_ocor_w,
						qt_parecer_ocor_def_w
					from	pls_ocorrencia_benef		b,
						pls_analise_glo_ocor_grupo	a
					where	a.nr_seq_analise	= nr_seq_analise_p
					and	a.nr_seq_ocor_benef	= b.nr_sequencia
					and	b.nr_seq_conta_proc	= nr_seq_conta_proc_w;

					select	count(1),
						sum(CASE WHEN a.ie_status='P' THEN  0 WHEN a.ie_status='M' THEN  0  ELSE 1 END )
					into STRICT	qt_parecer_glosa_w,
						qt_parecer_glosa_def_w
					from	pls_conta_glosa			b,
						pls_analise_glo_ocor_grupo	a
					where	a.nr_seq_analise	= nr_seq_analise_p
					and	a.nr_seq_conta_glosa	= b.nr_sequencia
					and	b.nr_seq_conta_proc	= nr_seq_conta_proc_w;

					select	count(1)
					into STRICT	qt_parecer_w
					from	pls_analise_fluxo_item
					where	nr_seq_conta_proc	= nr_seq_conta_proc_w  LIMIT 1;

				elsif (nr_seq_conta_mat_w IS NOT NULL AND nr_seq_conta_mat_w::text <> '') then

					select	count(1),
						sum(CASE WHEN a.ie_status='P' THEN  0 WHEN a.ie_status='M' THEN  0  ELSE 1 END )
					into STRICT	qt_parecer_ocor_w,
						qt_parecer_ocor_def_w
					from	pls_ocorrencia_benef		b,
						pls_analise_glo_ocor_grupo	a
					where	a.nr_seq_analise	= nr_seq_analise_p
					and	a.nr_seq_ocor_benef	= b.nr_sequencia
					and	b.nr_seq_conta_mat	= nr_seq_conta_mat_w;

					select	count(1),
						sum(CASE WHEN a.ie_status='P' THEN  0 WHEN a.ie_status='M' THEN  0  ELSE 1 END )
					into STRICT	qt_parecer_glosa_w,
						qt_parecer_glosa_def_w
					from	pls_conta_glosa			b,
						pls_analise_glo_ocor_grupo	a
					where	a.nr_seq_analise	= nr_seq_analise_p
					and	a.nr_seq_conta_glosa	= b.nr_sequencia
					and	b.nr_seq_conta_mat	= nr_seq_conta_mat_w;

					select	count(1)
					into STRICT	qt_parecer_w
					from	pls_analise_fluxo_item
					where	nr_seq_conta_mat	= nr_seq_conta_mat_w  LIMIT 1;

				elsif (nr_seq_conta_w IS NOT NULL AND nr_seq_conta_w::text <> '') then

					select	count(1),
						sum(CASE WHEN a.ie_status='P' THEN  0 WHEN a.ie_status='M' THEN  0  ELSE 1 END )
					into STRICT	qt_parecer_ocor_w,
						qt_parecer_ocor_def_w
					from	pls_ocorrencia_benef		b,
						pls_analise_glo_ocor_grupo	a
					where	a.nr_seq_analise	= nr_seq_analise_p
					and	a.nr_seq_ocor_benef	= b.nr_sequencia
					and	b.nr_seq_conta		= nr_seq_conta_w
					and	coalesce(nr_seq_conta_proc::text, '') = ''
					and	coalesce(nr_seq_conta_mat::text, '') = '';

					select	count(1),
						sum(CASE WHEN a.ie_status='P' THEN  0 WHEN a.ie_status='M' THEN  0  ELSE 1 END )
					into STRICT	qt_parecer_glosa_w,
						qt_parecer_glosa_def_w
					from	pls_conta_glosa			b,
						pls_analise_glo_ocor_grupo	a
					where	a.nr_seq_analise	= nr_seq_analise_p
					and	a.nr_seq_conta_glosa	= b.nr_sequencia
					and	b.nr_seq_conta		= nr_seq_conta_w
					and	coalesce(nr_seq_conta_proc::text, '') = ''
					and	coalesce(nr_seq_conta_mat::text, '') = '';

					select	count(1)
					into STRICT	qt_parecer_w
					from	pls_analise_fluxo_item
					where	nr_seq_conta		= nr_seq_conta_w
					and	coalesce(nr_seq_conta_proc::text, '') = ''
					and	coalesce(nr_seq_conta_mat::text, '') = ''  LIMIT 1;

				end if;

				if	((qt_parecer_ocor_w > 0 AND qt_parecer_ocor_def_w = 0) or qt_parecer_ocor_w = 0) and
					((qt_parecer_glosa_w > 0 AND qt_parecer_glosa_def_w = 0) or qt_parecer_glosa_w = 0) then
					ie_manter_w	:= 'N';
				else
					ie_manter_w	:= 'S';
				end if;

				if (ie_manter_w = 'S') then
					CALL pls_analise_manter_parecer(	nr_seq_analise_p, nr_seq_conta_w, nr_seq_conta_proc_w,
									nr_seq_conta_mat_w, nr_seq_proc_partic_w, nr_seq_grupo_atual_p,
									cd_estabelecimento_p, null, 'S',
									nm_usuario_p);
				else
					select 	CASE WHEN ie_glosa_atend_p='S' THEN 'N'  ELSE 'S' END
					into STRICT	ie_finalizar_w
					;
					CALL pls_analise_glosar_item(	nr_seq_analise_p, nr_seq_conta_w, nr_seq_conta_proc_w,
									nr_seq_conta_mat_w, nr_seq_proc_partic_w, null,
									nr_seq_mot_liberacao_glosa_w, null, cd_estabelecimento_p,
									nr_seq_grupo_atual_p, 'N', 'N',
									ie_finalizar_w, 'N', nm_usuario_p,
									null,'S','S');
				end if;
			end if;
		end if;
		end;
	end loop;
	close C01;

	/*Realizado Update dos itens pendentes para liberado pelo usuário e glosado DGKORZ OS 593588*/

	if (ie_ultimo_grupo_w = 'S') then

		for r_c02_w in C02 loop

			if (r_c02_w.nr_seq_conta_proc IS NOT NULL AND r_c02_w.nr_seq_conta_proc::text <> '') then

				update	pls_conta_proc	a
				set	vl_unitario		= 0,
					vl_liberado		= 0,
					qt_procedimento		= 0,
					ie_status		= 'L',
					ie_glosa		= 'S',
					vl_glosa		= vl_procedimento_imp,
					vl_lib_taxa_co   	= 0,
					vl_lib_taxa_material	= 0,
					vl_lib_taxa_servico     = 0,
					vl_liberado_co 		= 0,
					vl_liberado_hi          = 0,
					vl_liberado_material    = 0,
					vl_glosa_co         	= vl_co_ptu_imp,
					vl_glosa_hi             = vl_procedimento_ptu_imp,
					vl_glosa_material       = vl_material_ptu_imp,
					vl_glosa_taxa_co        = vl_taxa_co_imp,
					vl_glosa_taxa_material	= vl_taxa_material_imp,
					vl_glosa_taxa_servico   = vl_taxa_servico_imp,
					ie_status_pagamento	= 'G'
				where	a.nr_sequencia		= r_c02_w.nr_seq_conta_proc;

				CALL pls_inserir_hist_analise(	r_c02_w.nr_seq_conta, nr_seq_analise_p,
								3, r_c02_w.nr_seq_conta_proc,
								'P', null,
								null,'Item glosado ao finalizar a análise',
								nr_seq_grupo_atual_p, nm_usuario_p,
								cd_estabelecimento_p);
			else
				update	pls_conta_mat	a
				set	vl_unitario		= 0,
					vl_liberado		= 0,
					qt_material		= 0,
					ie_status		= 'L',
					ie_glosa		= 'S',
					vl_glosa		= vl_material_imp,
					vl_lib_taxa_material 	= 0,
					vl_glosa_taxa_material  = vl_taxa_material_imp,
					ie_status_pagamento	= 'G'
				where	a.nr_sequencia		= r_c02_w.nr_seq_conta_mat;

				CALL pls_inserir_hist_analise(	r_c02_w.nr_seq_conta, nr_seq_analise_p,
								3, r_c02_w.nr_seq_conta_mat,
								'M', null,
								null,'Item glosado ao finalizar a análise',
								nr_seq_grupo_atual_p, nm_usuario_p,
								cd_estabelecimento_p);
			end if;
		end loop;
	end if;
end if;

/* Sem commit */

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_analise_glosar_itens_pend (nr_seq_analise_p pls_analise_glo_ocor_grupo.nr_seq_analise%type, nr_seq_grupo_atual_p pls_analise_glo_ocor_grupo.nr_seq_grupo%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, ie_glosa_atend_p text) FROM PUBLIC;
