-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_ptu_nota_serv_item ( nr_seq_nota_servico_p ptu_nota_servico_item.nr_sequencia%type, nr_seq_conta_pos_estab_p pls_conta_pos_estabelecido.nr_sequencia%type, nr_seq_pos_proc_p pls_conta_pos_proc.nr_sequencia%type, nr_seq_pos_mat_p pls_conta_pos_mat.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_pos_pac_p pls_conta_pos_pac_fat.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_proc_partic_p pls_proc_participante.nr_sequencia%type, nr_seq_conta_pos_contab_p pls_conta_pos_estab_contab.nr_sequencia%type, nr_seq_pos_proc_fat_p pls_conta_pos_proc_fat.nr_sequencia%type, nr_seq_pos_mat_fat_p pls_conta_pos_mat_fat.nr_sequencia%type, vl_procedimento_p ptu_nota_servico_item.vl_procedimento%type, vl_filme_p ptu_nota_servico_item.vl_filme%type, vl_custo_operacional_p ptu_nota_servico_item.vl_custo_operacional%type, vl_adic_procedimento_p ptu_nota_servico_item.vl_adic_procedimento%type, vl_adic_filme_p ptu_nota_servico_item.vl_adic_filme%type, vl_adic_co_p ptu_nota_servico_item.vl_adic_co%type, qt_procedimento_p ptu_nota_servico_item.qt_procedimento%type, ie_opcao_p text, ie_local_p ptu_nota_servico_item.ie_local%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_pos_estab_taxa_p pls_conta_pos_estab_taxa.nr_sequencia%type, nr_seq_pos_taxa_contab_p pls_conta_pos_taxa_contab.nr_sequencia%type, nr_seq_pos_proc_partic_p pls_conta_pos_proc_part.nr_sequencia%type, nr_seq_pos_proc_tx_p pls_conta_pos_proc_tx.nr_sequencia%type, nr_seq_pos_proc_tx_fat_p pls_conta_pos_proc_tx_fat.nr_sequencia%type, nr_seq_pos_mat_tx_p pls_conta_pos_mat_tx.nr_sequencia%type, nr_seq_pos_mat_tx_fat_p pls_conta_pos_mat_tx_fat.nr_sequencia%type, nr_seq_cobranca_rrs_p ptu_nota_cobranca_rrs.nr_sequencia%type) AS $body$
DECLARE

					
vl_procedimento_w		ptu_nota_servico_item.vl_procedimento%type	:= coalesce(vl_procedimento_p, 0);
vl_filme_w			ptu_nota_servico_item.vl_filme%type		:= coalesce(vl_filme_p, 0);
vl_custo_operacional_w		ptu_nota_servico_item.vl_custo_operacional%type := coalesce(vl_custo_operacional_p, 0);
vl_adic_procedimento_w		ptu_nota_servico_item.vl_adic_procedimento%type := coalesce(vl_adic_procedimento_p, 0);
vl_adic_filme_w			ptu_nota_servico_item.vl_adic_filme%type	:= coalesce(vl_adic_filme_p, 0);
vl_adic_co_w			ptu_nota_servico_item.vl_adic_co%type		:= coalesce(vl_adic_co_p, 0);
qt_procedimento_w		ptu_nota_servico_item.qt_procedimento%type	:= coalesce(qt_procedimento_p, 1);


BEGIN
-- Inserir os itens que fazem parte da nota serviço
if (ie_opcao_p = '1') then
	if (nr_seq_conta_pos_estab_p IS NOT NULL AND nr_seq_conta_pos_estab_p::text <> '') then
		insert into ptu_nota_servico_item(	nr_sequencia,				dt_atualizacao,			nm_usuario,
							dt_atualizacao_nrec,			nm_usuario_nrec,		nr_seq_nota_servico,
							nr_seq_conta_pos_estab,			nr_seq_conta_proc,		nr_seq_conta_mat,
							nr_seq_conta,				nr_seq_conta_pos_pac,		vl_procedimento,
							vl_filme,				vl_custo_operacional,		vl_adic_procedimento,
							vl_adic_filme,				vl_adic_co,			qt_procedimento,
							ie_local,				nr_seq_proc_partic,		nr_seq_conta_pos_contab,
							nr_seq_pos_estab_taxa,			nr_seq_pos_taxa_contab,		nr_seq_nota_servico_rrs)
						values (	nextval('ptu_nota_servico_item_seq'),	clock_timestamp(),			nm_usuario_p,
							clock_timestamp(),				nm_usuario_p,			nr_seq_nota_servico_p,
							nr_seq_conta_pos_estab_p,		nr_seq_conta_proc_p,		nr_seq_conta_mat_p,
							nr_seq_conta_p,				nr_seq_conta_pos_pac_p,		vl_procedimento_w,
							vl_filme_w,				vl_custo_operacional_w,		vl_adic_procedimento_w,
							vl_adic_filme_w,			vl_adic_co_w,			qt_procedimento_w,
							ie_local_p,				nr_seq_proc_partic_p,		nr_seq_conta_pos_contab_p,
							nr_seq_pos_estab_taxa_p,		nr_seq_pos_taxa_contab_p,	nr_seq_cobranca_rrs_p);
	end if;
-- Atualizar os itens que fazem parte da nota serviço
elsif (ie_opcao_p = '2') then
	if (nr_seq_conta_pos_estab_p IS NOT NULL AND nr_seq_conta_pos_estab_p::text <> '') then
		if (nr_seq_nota_servico_p IS NOT NULL AND nr_seq_nota_servico_p::text <> '') then
			update	ptu_nota_servico_item
			set	vl_procedimento		= vl_procedimento_w,
				vl_custo_operacional	= vl_custo_operacional_w,
				vl_filme		= vl_filme_w,
				vl_adic_procedimento	= vl_adic_procedimento_w,
				vl_adic_co		= vl_adic_co_w,
				vl_adic_filme		= vl_adic_filme_w,
				qt_procedimento		= qt_procedimento_w,
				ie_local		= ie_local_p
			where	nr_seq_nota_servico	= nr_seq_nota_servico_p;
			
		elsif (nr_seq_cobranca_rrs_p IS NOT NULL AND nr_seq_cobranca_rrs_p::text <> '') then
			update	ptu_nota_servico_item
			set	vl_procedimento		= vl_procedimento_w,
				vl_custo_operacional	= vl_custo_operacional_w,
				vl_filme		= vl_filme_w,
				vl_adic_procedimento	= vl_adic_procedimento_w,
				vl_adic_co		= vl_adic_co_w,
				vl_adic_filme		= vl_adic_filme_w,
				qt_procedimento		= qt_procedimento_w,
				ie_local		= ie_local_p
			where	nr_seq_nota_servico_rrs	= nr_seq_cobranca_rrs_p;
		end if;
		
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_ptu_nota_serv_item ( nr_seq_nota_servico_p ptu_nota_servico_item.nr_sequencia%type, nr_seq_conta_pos_estab_p pls_conta_pos_estabelecido.nr_sequencia%type, nr_seq_pos_proc_p pls_conta_pos_proc.nr_sequencia%type, nr_seq_pos_mat_p pls_conta_pos_mat.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_pos_pac_p pls_conta_pos_pac_fat.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_proc_partic_p pls_proc_participante.nr_sequencia%type, nr_seq_conta_pos_contab_p pls_conta_pos_estab_contab.nr_sequencia%type, nr_seq_pos_proc_fat_p pls_conta_pos_proc_fat.nr_sequencia%type, nr_seq_pos_mat_fat_p pls_conta_pos_mat_fat.nr_sequencia%type, vl_procedimento_p ptu_nota_servico_item.vl_procedimento%type, vl_filme_p ptu_nota_servico_item.vl_filme%type, vl_custo_operacional_p ptu_nota_servico_item.vl_custo_operacional%type, vl_adic_procedimento_p ptu_nota_servico_item.vl_adic_procedimento%type, vl_adic_filme_p ptu_nota_servico_item.vl_adic_filme%type, vl_adic_co_p ptu_nota_servico_item.vl_adic_co%type, qt_procedimento_p ptu_nota_servico_item.qt_procedimento%type, ie_opcao_p text, ie_local_p ptu_nota_servico_item.ie_local%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_pos_estab_taxa_p pls_conta_pos_estab_taxa.nr_sequencia%type, nr_seq_pos_taxa_contab_p pls_conta_pos_taxa_contab.nr_sequencia%type, nr_seq_pos_proc_partic_p pls_conta_pos_proc_part.nr_sequencia%type, nr_seq_pos_proc_tx_p pls_conta_pos_proc_tx.nr_sequencia%type, nr_seq_pos_proc_tx_fat_p pls_conta_pos_proc_tx_fat.nr_sequencia%type, nr_seq_pos_mat_tx_p pls_conta_pos_mat_tx.nr_sequencia%type, nr_seq_pos_mat_tx_fat_p pls_conta_pos_mat_tx_fat.nr_sequencia%type, nr_seq_cobranca_rrs_p ptu_nota_cobranca_rrs.nr_sequencia%type) FROM PUBLIC;

