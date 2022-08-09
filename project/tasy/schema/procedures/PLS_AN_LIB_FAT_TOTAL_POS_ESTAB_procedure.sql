-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_an_lib_fat_total_pos_estab ( nr_seq_analise_p bigint, nr_seq_conta_pos_estab_p bigint, nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, nr_seq_proc_partic_p bigint, nr_seq_mot_liberacao_p bigint, ds_observacao_p text, cd_estabelecimento_p bigint, nr_seq_grupo_atual_p bigint, ie_tipo_item_p text, nm_usuario_p text) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
	 
	***ROTINA UTILIZADA NA NOVA GERAÇÃO DE PÓS-ESTABELECIDO*** 
 
Finalidade: Liberar pagamento total de um item da análise (Análise Nova) 
 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
ie_liberado_w			varchar(1);
nr_seq_ocor_benef_w		bigint;
qt_fluxo_w			bigint;
nr_seq_fluxo_padrao_w		bigint;
qt_fluxo_pend_w			bigint;
nr_seq_ocorrencia_w		bigint;
nr_seq_fluxo_w			bigint;
qt_ocor_val_w			integer;
qt_ocor_ativa_w			integer;
nr_seq_conta_w			pls_conta_pos_estabelecido.nr_seq_conta%type;
vl_calculado_w			pls_conta_pos_estabelecido.vl_calculado%type;

C01 CURSOR FOR 
	SELECT	a.nr_sequencia, 
		(SELECT	count(1) 
		from	pls_analise_glo_ocor_grupo x 
		where	x.nr_seq_analise	= nr_seq_analise_p 
		and	x.nr_seq_ocor_benef	= a.nr_sequencia) qt_fluxo, 
		(select	count(1) 
		from	pls_analise_glo_ocor_grupo x 
		where	x.nr_seq_analise	= nr_seq_analise_p 
		and	x.nr_seq_ocor_benef	= a.nr_sequencia 
		and	x.ie_status		= 'P') qt_pendente, 
		b.nr_sequencia, 
		(select	count(1) 
		from	pls_oc_regra_pos_estab	x 
		where	x.nr_seq_ocorrencia	= b.nr_sequencia 
		and	x.ie_valor_pos_zerado	= 'S') qt_ocor_valor 
	from	pls_ocorrencia b, 
		pls_ocorrencia_benef a 
	where	a.nr_seq_ocorrencia		= b.nr_sequencia 
	and	a.nr_seq_conta_pos_proc	= nr_seq_conta_pos_estab_p 
	and	ie_tipo_item_p		= 'P' 
	and (b.ie_pre_analise = 'N' or coalesce(b.ie_pre_analise::text, '') = '') 
	and (b.ie_auditoria_conta = 'S' or coalesce(b.ie_auditoria_conta::text, '') = '') 
	
union all
 
	select	a.nr_sequencia, 
		(select	count(1) 
		from	pls_analise_glo_ocor_grupo x 
		where	x.nr_seq_analise	= nr_seq_analise_p 
		and	x.nr_seq_ocor_benef	= a.nr_sequencia) qt_fluxo, 
		(select	count(1) 
		from	pls_analise_glo_ocor_grupo x 
		where	x.nr_seq_analise	= nr_seq_analise_p 
		and	x.nr_seq_ocor_benef	= a.nr_sequencia 
		and	x.ie_status		= 'P') qt_pendente, 
		b.nr_sequencia, 
		(select	count(1) 
		from	pls_oc_regra_pos_estab	x 
		where	x.nr_seq_ocorrencia	= b.nr_sequencia 
		and	x.ie_valor_pos_zerado	= 'S') qt_ocor_valor 
	from	pls_ocorrencia b, 
		pls_ocorrencia_benef a 
	where	a.nr_seq_ocorrencia		= b.nr_sequencia 
	and	a.nr_seq_conta_pos_mat	= nr_seq_conta_pos_estab_p 
	and	ie_tipo_item_p		= 'M' 
	and (b.ie_pre_analise = 'N' or coalesce(b.ie_pre_analise::text, '') = '') 
	and (b.ie_auditoria_conta = 'S' or coalesce(b.ie_auditoria_conta::text, '') = '');


BEGIN 
if (nr_seq_analise_p IS NOT NULL AND nr_seq_analise_p::text <> '') then 
 
	/* Gravar o fluxo de análise do item - histórico */
 
	nr_seq_fluxo_w := pls_gravar_fluxo_analise_item(	nr_seq_analise_p, null, nr_seq_conta_proc_p, nr_seq_conta_mat_p, nr_seq_proc_partic_p, nr_seq_conta_pos_estab_p, nr_seq_grupo_atual_p, 'L', /* Liberado */
 
					nr_seq_mot_liberacao_p, ds_observacao_p, 'N', 'N', nm_usuario_p, 'N', null, '1', nr_seq_fluxo_w);
					 
	/* Mudar o status das ocorrências do o grupo que está analisando */
	 
	if (ie_tipo_item_p	= 'P') then 
			 
		select	coalesce(max(vl_calculado), 0) 
		into STRICT	vl_calculado_w 
		from	pls_conta_pos_proc_v 
		where	nr_sequencia = nr_seq_conta_pos_estab_p;
	 
	else 
	 
		select	coalesce(max(vl_calculado), 0) 
		into STRICT	vl_calculado_w 
		from	pls_conta_pos_mat_v 
		where	nr_sequencia = nr_seq_conta_pos_estab_p;
	 
	end if;
	 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_ocor_benef_w, 
		qt_fluxo_w, 
		qt_fluxo_pend_w, 
		nr_seq_ocorrencia_w, 
		qt_ocor_val_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
			 
		ie_liberado_w	:= pls_obter_se_nivel_lib_auditor(nr_seq_ocorrencia_w, nr_seq_grupo_atual_p, nm_usuario_p, 'S');
		 
		if (ie_liberado_w = 'N') then 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(207091);
		end if;
		 
		/* Se não tem fluxo para a ocorrência, dar insert do fluxo */
 
		if (qt_fluxo_w = 0) then 
			insert into pls_analise_glo_ocor_grupo(nr_sequencia, 
				nm_usuario, 
				dt_atualizacao, 
				nm_usuario_nrec, 
				dt_atualizacao_nrec, 
				nr_seq_analise, 
				nr_seq_ocor_benef, 
				nr_seq_grupo, 
				nr_seq_fluxo, 
				ie_fluxo_gerado, 
				nm_usuario_analise, 
				dt_analise, 
				ie_status) 
			values (nextval('pls_analise_glo_ocor_grupo_seq'), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nr_seq_analise_p, 
				nr_seq_ocor_benef_w, 
				nr_seq_grupo_atual_p, 
				nr_seq_fluxo_padrao_w, 
				'S', 
				nm_usuario_p, 
				clock_timestamp(), 
				'L');
		else 
			update	pls_analise_glo_ocor_grupo 
			set	ie_status		= 'L', /* Liberado */
 
				nm_usuario		= nm_usuario_p, 
				dt_atualizacao		= clock_timestamp(), 
				nm_usuario_analise	= nm_usuario_p, 
				dt_analise		= clock_timestamp() 
			where	nr_seq_ocor_benef	= nr_seq_ocor_benef_w 
			and	nr_seq_grupo		= nr_seq_grupo_atual_p;
		end if;
		-- Acrescentado a verificação pelo valor calculado pois caso tenha valor calculado 
		-- deve inativar as glosas para poder valorizar o item novamente OS 
		if (qt_ocor_val_w	= 0) or (vl_calculado_w > 0) then 
			/* Se for o último fluxo (só um pendente) deve inativar a ocorrência */
 
			update	pls_ocorrencia_benef 
			set	ie_situacao	= 'I', 
				nm_usuario	= nm_usuario_p, 
				dt_atualizacao	= clock_timestamp(), 
				ie_lib_manual	 = NULL 
			where	nr_sequencia	= nr_seq_ocor_benef_w;
		end if;
		 
		end;
	end loop;
	close C01;
	 
	if (ie_tipo_item_p = 'P') then 
		select	count(a.nr_sequencia) 
		into STRICT	qt_ocor_ativa_w 
		from	pls_ocorrencia b, 
			pls_ocorrencia_benef a 
		where	a.nr_seq_ocorrencia	= b.nr_sequencia 
		and	a.nr_seq_conta_pos_proc	= nr_seq_conta_pos_estab_p 
		and	a.ie_situacao		= 'A';
		 
	elsif (ie_tipo_item_p = 'M') then 
		select	count(a.nr_sequencia) 
		into STRICT	qt_ocor_ativa_w 
		from	pls_ocorrencia b, 
			pls_ocorrencia_benef a 
		where	a.nr_seq_ocorrencia	= b.nr_sequencia 
		and	a.nr_seq_conta_pos_mat	= nr_seq_conta_pos_estab_p 
		and	a.ie_situacao		= 'A';
	end if;
	 
	if (qt_ocor_ativa_w	= 0) then 
 
		if (ie_tipo_item_p = 'P') then 
		 
			update	pls_conta_pos_proc 
			set	qt_item				= qt_item + qt_glosa, 
				ie_status_faturamento 		= 'P', 
				vl_medico			= vl_medico_calc, 
				vl_materiais			= vl_materiais_calc, 
				vl_custo_operacional		= vl_custo_operacional_calc, 
				nm_usuario 			= nm_usuario_p, 
				dt_atualizacao 			= clock_timestamp(), 
				vl_liberado_material_fat 	= vl_materiais_calc, 
				vl_liberado_co_fat	  	= vl_custo_operacional_calc, 
				vl_liberado_hi_fat		= vl_medico_calc, 
				vl_glosa_material_fat		= 0, 
				vl_glosa_hi_fat			= 0, 
				vl_glosa_co_fat			= 0, 
				vl_lib_taxa_co   		= vl_taxa_co, 
				vl_lib_taxa_material		= vl_taxa_material, 
				vl_lib_taxa_servico   	= vl_taxa_servico, 
				vl_glosa_taxa_co   		= 0, 
				vl_glosa_taxa_material		= 0, 
				vl_glosa_taxa_servico	 	= 0 
			where	nr_sequencia			= nr_seq_conta_pos_estab_p;
			 
			select	max(nr_seq_conta) 
			into STRICT	nr_seq_conta_w 
			from	pls_conta_pos_proc 
			where	nr_sequencia	= nr_seq_conta_pos_estab_p;
				 
		elsif (ie_tipo_item_p = 'M') then 
		 
			update	pls_conta_pos_mat 
			set	qt_item				= qt_item + qt_glosa, 
				ie_status_faturamento 		= 'P', 
				vl_materiais			= vl_materiais_calc, 
				nm_usuario 			= nm_usuario_p, 
				dt_atualizacao 			= clock_timestamp(), 
				vl_liberado_material_fat 	= vl_materiais_calc, 
				vl_glosa_material_fat		= 0, 
				vl_lib_taxa_material		= vl_taxa_material, 
				vl_glosa_taxa_material		= 0 
			where	nr_sequencia			= nr_seq_conta_pos_estab_p;
			 
			select	max(nr_seq_conta) 
			into STRICT	nr_seq_conta_w 
			from	pls_conta_pos_mat 
			where	nr_sequencia	= nr_seq_conta_pos_estab_p;
		 
		end if;
										 
		CALL pls_pos_estabelecido_pck.gerar_valores_adicionais( 	null, null, null, 
									null, nr_seq_conta_w, nr_seq_conta_mat_p, 
									nr_seq_conta_proc_p, 'N', nm_usuario_p, 
									cd_estabelecimento_p);
		 
	end if;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_an_lib_fat_total_pos_estab ( nr_seq_analise_p bigint, nr_seq_conta_pos_estab_p bigint, nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, nr_seq_proc_partic_p bigint, nr_seq_mot_liberacao_p bigint, ds_observacao_p text, cd_estabelecimento_p bigint, nr_seq_grupo_atual_p bigint, ie_tipo_item_p text, nm_usuario_p text) FROM PUBLIC;
