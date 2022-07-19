-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_analise_liberar_glosar_pag ( nr_seq_analise_p bigint, nr_seq_w_item_p bigint, nr_seq_mot_liberacao_p bigint, nr_seq_grupo_atual_p bigint, ds_observacao_p text, ie_acao_p text, nm_usuario_p text, cd_estabelecimento_p bigint, nr_id_transacao_p bigint, nr_seq_proc_partic_p bigint) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicion?rio [ X ] Tasy (Delphi/Java) [  ] Portal [  ]  Relat?rios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de aten??o:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_status_analise_w		varchar(255);
ie_lib_pagamento_w		varchar(255);
ie_liberar_imp_w		varchar(255);
ie_selecionado_w		varchar(1);
vl_calculado_w			double precision;
vl_apresentado_w		double precision;
nr_seq_conta_w			bigint;
nr_seq_conta_proc_w		bigint;
nr_seq_conta_mat_w		bigint;
nr_seq_proc_partic_w		bigint;
nr_seq_w_item_w			bigint;
nr_identificador_w		bigint;
ie_somente_conta_w		varchar(1)	:= 'S';
ie_glosa_w			pls_conta.ie_glosa%type;
nr_seq_fluxo_w			bigint;
ds_item_w			w_pls_analise_item.ds_item%type;
ie_tipo_guia_w			pls_conta.ie_tipo_guia%type;
ie_expandido_w			w_pls_analise_item.ie_expandido%type;
ie_tipo_linha_w			w_pls_analise_item.ie_tipo_linha%type;
ie_valor_base_w			w_pls_analise_item.ie_valor_base%type;
ie_origem_conta_w		pls_conta.ie_origem_conta%type;
ie_a520_w			w_pls_analise_item.ie_a520%type;
ie_gerar_previa_pos_w		pls_parametros.ie_gerar_previa_pos%type;
ie_geracao_pos_estabelecido_w	pls_parametros.ie_geracao_pos_estabelecido%type;
ie_processa_w			varchar(1);
qt_reg_prev_w			integer := 0;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_conta,
		a.nr_seq_conta_proc,
		a.nr_seq_conta_mat,
		coalesce(a.nr_seq_proc_partic,0) nr_seq_proc_partic,
		a.ie_selecionado,
		a.ie_status_analise,
		a.ie_tipo_guia,
		a.ie_expandido,
		a.ie_tipo_linha,
		a.vl_calculado,
		a.vl_apresentado,
		a.nr_identificador,
		a.ie_valor_base,
		(	SELECT	max(x.ie_origem_conta)
			from	pls_conta	x
			where	x.nr_sequencia	= a.nr_seq_conta) ie_origem_conta,
		a.ie_a520
	from	w_pls_analise_item	a
	where	a.nr_seq_analise	= nr_seq_analise_p
	and	a.nr_id_transacao 	= nr_id_transacao_p
	and	a.ie_selecionado	= 'S'
	
union all

	select	a.nr_sequencia,
		a.nr_seq_conta,
		a.nr_seq_conta_proc,
		a.nr_seq_conta_mat,
		coalesce(a.nr_seq_proc_partic,0) nr_seq_proc_partic,
		a.ie_selecionado,
		a.ie_status_analise,
		a.ie_tipo_guia,
		a.ie_expandido,
		a.ie_tipo_linha,
		a.vl_calculado,
		a.vl_apresentado,
		a.nr_identificador,
		a.ie_valor_base,
		(	select	max(x.ie_origem_conta)
			from	pls_conta	x
			where	x.nr_sequencia	= a.nr_seq_conta) ie_origem_conta,
		a.ie_a520
	from	w_pls_analise_item	a
	where	a.nr_seq_analise	= nr_seq_analise_p
	and	a.nr_id_transacao 	= nr_id_transacao_p
	and	a.nr_sequencia		= nr_seq_w_item_p
	and (a.ie_selecionado 	= 'N' or coalesce(a.ie_selecionado::text, '') = '')
	and	coalesce(nr_seq_proc_partic_p::text, '') = ''
	
union all

	select	a.nr_sequencia,
		a.nr_seq_conta,
		a.nr_seq_conta_proc,
		a.nr_seq_conta_mat,
		nr_seq_proc_partic_p nr_seq_proc_partic,
		a.ie_selecionado,
		a.ie_status_analise,
		a.ie_tipo_guia,
		a.ie_expandido,
		a.ie_tipo_linha,
		a.vl_calculado,
		a.vl_apresentado,
		a.nr_identificador,
		a.ie_valor_base,
		(	select	max(x.ie_origem_conta)
			from	pls_conta	x
			where	x.nr_sequencia	= a.nr_seq_conta) ie_origem_conta,
		a.ie_a520
	from	w_pls_analise_item	a
	where	a.nr_seq_analise	= nr_seq_analise_p
	and	a.nr_id_transacao 	= nr_id_transacao_p
	and	a.nr_sequencia		= nr_seq_w_item_p
	and (a.ie_selecionado 	= 'N' or coalesce(a.ie_selecionado::text, '') = '')
	and	(nr_seq_proc_partic_p IS NOT NULL AND nr_seq_proc_partic_p::text <> '')
	order by
		ie_selecionado,
		nr_seq_conta_proc,
		5 desc;
		
C02 CURSOR(nr_seq_analise_pc	pls_analise_conta.nr_sequencia%type,
		 ie_tipo_guia_pc	pls_analise_conta.ie_tipo_guia%type)FOR
	SELECT	nr_sequencia nr_seq_conta
	from	pls_conta
	where	nr_seq_analise 	= nr_seq_analise_pc
	and	ie_tipo_guia	= ie_tipo_guia_pc;
	
C03 CURSOR FOR
	SELECT	distinct nr_seq_conta
	from	w_pls_analise_item
	where	nr_seq_analise = nr_seq_analise_p;
		
BEGIN

select	coalesce(max(a.ie_geracao_pos_estabelecido),'F'),
	coalesce(max(ie_gerar_previa_pos), 'N')
into STRICT	ie_geracao_pos_estabelecido_w,
	ie_gerar_Previa_pos_w
from	pls_parametros	a
where	a.cd_estabelecimento	= cd_estabelecimento_p;


select	coalesce(max(a.ie_geracao_pos_estabelecido),'F'),
	coalesce(max(ie_gerar_previa_pos), 'N')
into STRICT	ie_geracao_pos_estabelecido_w,
	ie_gerar_Previa_pos_w
from	pls_parametros	a
where	a.cd_estabelecimento	= cd_estabelecimento_p;


if (ie_acao_p = 'L') then
	ie_lib_pagamento_w := obter_param_usuario(	1365, 12, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_lib_pagamento_w);
	
	ie_liberar_imp_w	:= pls_obter_permissao_auditor(	nr_seq_analise_p,
								nr_seq_grupo_atual_p,
								nm_usuario_p,
								'LC');
	ie_somente_conta_w := 'S';
	open C01;
	loop
	fetch C01 into	
		nr_seq_w_item_w,
		nr_seq_conta_w,
		nr_seq_conta_proc_w,
		nr_seq_conta_mat_w,
		nr_seq_proc_partic_w,
		ie_selecionado_w,
		ie_status_analise_w,
		ie_tipo_guia_w,
		ie_expandido_w,
		ie_tipo_linha_w,
		vl_calculado_w,
		vl_apresentado_w,
		nr_identificador_w,
		ie_valor_base_w,
		ie_origem_conta_w,
		ie_a520_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin	
		ie_processa_w := 'S';
		
		-- verifica se o item n?o ? completamente glosado no A500
		if (pls_obter_se_a504_glosado(ie_a520_w, ie_origem_conta_w, vl_apresentado_w) = 'S') then
		
			ie_processa_w := 'N';
		end if;
		
		-- controle de deve aplicar a altera??o no item atual ou n?o
		if (ie_processa_w = 'S') then
		
			if (nr_seq_proc_partic_w = 0) then
				nr_seq_proc_partic_w	:= null;
			end if;
			if (ie_tipo_linha_w	= 'C') and (ie_expandido_w		= 'N') then
				for r_c02_w in C02(nr_seq_analise_p, ie_tipo_guia_w) loop
					begin
					if (ie_status_analise_w <> 'I') then
						
						CALL pls_analise_lib_pag_total(	nr_seq_analise_p,
										r_c02_w.nr_seq_conta,
										null,
										null,
										null,
										nr_seq_mot_liberacao_p,
										ds_observacao_p,
										cd_estabelecimento_p,
										nr_seq_grupo_atual_p,
										nm_usuario_p,
										'U',
										ie_liberar_imp_w);

					end if;
					end;
				end loop;
			else
				if (nr_seq_conta_proc_w IS NOT NULL AND nr_seq_conta_proc_w::text <> '') or (nr_seq_conta_mat_w IS NOT NULL AND nr_seq_conta_mat_w::text <> '') or (nr_seq_proc_partic_w IS NOT NULL AND nr_seq_proc_partic_w::text <> '') then
					
					/*  tratamento realizado para verificar se o item existe  e est? cadastrado na base, se n?o estiver gera a mensagem e n?o deixar liberar o item,
					    lembrando que na an?lise quando o sistema n?o encontrar o procedimento na base, o mesmo fica destacado em uma linha vermelha como n?o informado.
					    Quando se tentar liberar um item n?o informado o sistema ira lan?ar a seguinte mensagem.
					    N?o ? poss?vel liberar esta conta / item, existem itens informados que n?o foram encontrados em sua base ! drquadros 03/09/2013*/
					ds_item_w	:=	pls_obter_se_existe_item(nr_seq_conta_proc_w, nr_seq_conta_mat_w);
					/*Se o procedimento for nulo a funtion para obter o seu c?digo retorna ' '*/

					if (coalesce(ds_item_w::text, '') = '') or (ds_item_w = ' ')	then
						CALL wheb_mensagem_pck.exibir_mensagem_abort(257450);
					end if;
					
					ie_somente_conta_w := 'N';
					
					if (nr_seq_conta_w IS NOT NULL AND nr_seq_conta_w::text <> '') then

						select	max(ie_glosa)
						into STRICT	ie_glosa_w
						from	pls_conta	c
						where	c.nr_sequencia	= nr_seq_conta_w
						and	exists (SELECT	1
								from	pls_conta_glosa cg
								where	cg.nr_seq_conta		= c.nr_sequencia
								and	coalesce(cg.nr_seq_conta_proc::text, '') = ''
								and	coalesce(cg.nr_seq_conta_mat::text, '') = ''
								and	cg.ie_situacao		= 'A');
								
						if (ie_glosa_w = 'S') then
							CALL wheb_mensagem_pck.exibir_mensagem_abort(243116, 'NR_CONTA=' || nr_seq_conta_w);
						end if;
					end if;
				end if;
				if (ie_status_analise_w <> 'I') then
					if (ie_lib_pagamento_w <> 'S') then

						if (vl_calculado_w = 0) and (coalesce(ie_valor_base_w,2) not in ('1','4')) and (ie_lib_pagamento_w = 'CZ') then
							CALL wheb_mensagem_pck.exibir_mensagem_abort(210997, 'NR_ID=' || nr_identificador_w);
						elsif (vl_calculado_w = 0) and (vl_apresentado_w = 0) and (ie_lib_pagamento_w = 'ACZ') then
							CALL wheb_mensagem_pck.exibir_mensagem_abort(215046, 'NR_ID=' || nr_identificador_w);
						end if;
					end if;
					
					CALL pls_analise_lib_pag_total(	nr_seq_analise_p,
									nr_seq_conta_w,
									nr_seq_conta_proc_w,
									nr_seq_conta_mat_w,
									nr_seq_proc_partic_w,
									nr_seq_mot_liberacao_p,
									ds_observacao_p,
									cd_estabelecimento_p,
									nr_seq_grupo_atual_p,
									nm_usuario_p,
									'U',
									ie_liberar_imp_w);

				end if;
			end if;
		end if; -- fim se processa = S
		
		end;
	end loop;
	close C01;	

	open C01;
	loop
	fetch C01 into	
		nr_seq_w_item_w,
		nr_seq_conta_w,
		nr_seq_conta_proc_w,
		nr_seq_conta_mat_w,
		nr_seq_proc_partic_w,
		ie_selecionado_w,
		ie_status_analise_w,
		ie_tipo_guia_w,
		ie_expandido_w,
		ie_tipo_linha_w,
		vl_calculado_w,
		vl_apresentado_w,
		nr_identificador_w,
		ie_valor_base_w,
		ie_origem_conta_w,
		ie_a520_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	
	
		ie_processa_w := 'S';
		
		-- verifica se o item n?o ? completamente glosado no A500
		if (pls_obter_se_a504_glosado(ie_a520_w, ie_origem_conta_w, vl_apresentado_w) = 'S') then
		
			ie_processa_w := 'N';
		end if;
		
		begin
		-- controle de deve aplicar a altera??o no item atual ou n?o
		if (ie_processa_w = 'S') then
		
			if (nr_seq_proc_partic_w = 0) then
				nr_seq_proc_partic_w	:= null;
			end if;
			if (ie_tipo_linha_w	= 'C') and (ie_expandido_w		= 'N') then
				for r_c02_w in C02(nr_seq_analise_p, ie_tipo_guia_w) loop
					begin
					if ( ie_somente_conta_w = 'S' ) then
						CALL pls_propagar_lib_conta(	nr_seq_analise_p, r_c02_w.nr_seq_conta, nr_seq_grupo_atual_p,
									nr_seq_mot_liberacao_p, cd_estabelecimento_p, nm_usuario_p);
									
						/*Gravar fluxo de analise para a conta drquadros O.S 619388*/

						nr_seq_fluxo_w := pls_gravar_fluxo_analise_item(	nr_seq_analise_p, r_c02_w.nr_seq_conta, null, null, null, null, nr_seq_grupo_atual_p, 'L', nr_seq_mot_liberacao_p, ds_observacao_p, 'N', 'N', nm_usuario_p, 'S', 'L', '1', nr_seq_fluxo_w);
					end if;
					end;
				end loop;
			else
				if ( ie_somente_conta_w = 'S' ) then
					CALL pls_propagar_lib_conta(	nr_seq_analise_p, nr_seq_conta_w, nr_seq_grupo_atual_p,
								nr_seq_mot_liberacao_p, cd_estabelecimento_p, nm_usuario_p);
								
					/*Gravar fluxo de analise para a conta drquadros O.S 619388*/

					nr_seq_fluxo_w := pls_gravar_fluxo_analise_item(	nr_seq_analise_p, nr_seq_conta_w, nr_seq_conta_proc_w, nr_seq_conta_mat_w, nr_seq_proc_partic_w, null, nr_seq_grupo_atual_p, 'L', nr_seq_mot_liberacao_p, ds_observacao_p, 'N', 'N', nm_usuario_p, 'S', 'L', '1', nr_seq_fluxo_w);
				else
					ie_glosa_w :=  pls_obter_se_conta_glosada(nr_seq_conta_w);
					update	pls_conta
					set	ie_glosa 	= ie_glosa_w
					where	nr_sequencia 	= nr_seq_conta_w;
				end if;
			end if;
			
			CALL pls_gerar_w_analise_selec_item(	nr_seq_analise_p,
							nr_seq_w_item_w,
							null,
							'D',
							nm_usuario_p,
							'N',
							nr_id_transacao_p);
		end if; -- fim se processa = S					
		end;
	end loop;
	close C01;
	
	if ( ie_gerar_previa_pos_w = 'S' ) then
		
		--atualiza valores de previa de pos. Necessario pois o usuario pode atuar sobre itens e nao consistir a analise antes de fechar,  ficando as previas com valores desatualizados
		for r_c03_w in C03 loop
					
			if ( (r_c03_w.nr_seq_conta IS NOT NULL AND r_c03_w.nr_seq_conta::text <> '') or (nr_seq_conta_w IS NOT NULL AND nr_seq_conta_w::text <> '') ) then
			
				if (r_c03_w.nr_seq_conta IS NOT NULL AND r_c03_w.nr_seq_conta::text <> '') then
					select 	count(1)
					into STRICT	qt_reg_prev_w
					from	pls_conta_pos_estab_prev
					where	nr_seq_conta = r_c03_w.nr_seq_conta
					and 	(nr_lote_contabil_prov IS NOT NULL AND nr_lote_contabil_prov::text <> '');
				else
					select 	count(1)
					into STRICT	qt_reg_prev_w
					from	pls_conta_pos_estab_prev
					where	nr_seq_conta = nr_seq_conta_w
					and 	(nr_lote_contabil_prov IS NOT NULL AND nr_lote_contabil_prov::text <> '');
				end if;
					
				CALL pls_excluir_previa_pos(coalesce(r_c03_w.nr_seq_conta, nr_seq_conta_w), 'T');
				
				if (qt_reg_prev_w = 0) then
					CALL pls_gerar_valor_pos_estab( coalesce(r_c03_w.nr_seq_conta, nr_seq_conta_w), nm_usuario_p, ie_geracao_pos_estabelecido_w, null, null,'P');
				end if;
			end if;
		
		end loop;
		
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_analise_liberar_glosar_pag ( nr_seq_analise_p bigint, nr_seq_w_item_p bigint, nr_seq_mot_liberacao_p bigint, nr_seq_grupo_atual_p bigint, ds_observacao_p text, ie_acao_p text, nm_usuario_p text, cd_estabelecimento_p bigint, nr_id_transacao_p bigint, nr_seq_proc_partic_p bigint) FROM PUBLIC;

