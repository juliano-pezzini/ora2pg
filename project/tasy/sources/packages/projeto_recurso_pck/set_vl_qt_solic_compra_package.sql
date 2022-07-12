-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>++++++ INSERIR VALORES NAS VARIAVEIS ++++++<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-

	--SV>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Insere valores  variaveis da solicitacao de compra <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--	



CREATE OR REPLACE PROCEDURE projeto_recurso_pck.set_vl_qt_solic_compra ( nr_seq_proj_rec_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE
	
	
	/* Variavel para retornar a quantidade total de solicitacoes de compra do projeto recurso.*/


	qt_total_solic_proj_rec		bigint;		
	
	/* Projeto Recurso */
		
	vl_comprometido_proj_rec_w	projeto_recurso_saldo.vl_comprometido%type;
	
	/* Solicitacao de Compra */


	nr_solic_compra_w		solic_compra.nr_solic_compra%type;
	
	/* Identifica se deve considerar o valor das solicitacoes no valor comprometido do projeto. 
	Sera considerado as solicitacoes vinculadas ao projeto que ja foram liberadas mas que nao estao vinculadas com ordem de compra ja liberada. */

	ie_cons_solic_acum_proj_rec_w   parametro_compras.ie_cons_solic_acum_proj_rec%type;
	
	/* Serve para identificar se o valor comprometido deve ser diminuido do saldo do projeto*/


	ie_considera_vl_compr_saldo_w	parametro_compras.ie_considera_vl_compr_saldo%type;
	
	
	/* Solicitacao de Compra */
			
	c01 CURSOR FOR
		SELECT  a.nr_solic_compra
		from    solic_compra a
		where   coalesce(a.nr_seq_motivo_cancel::text, '') = ''
		and     (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
		and	projeto_recurso_pck.obter_ie_comprometido_solic(nr_seq_proj_rec_p, a.nr_solic_compra) > 0
		and     exists (SELECT  1
				from    solic_compra_item b
				where   b.nr_seq_proj_rec = nr_seq_proj_rec_p
				and	b.vl_unit_previsto > 0
				and 	coalesce(b.dt_reprovacao::text, '') = ''
				and	((coalesce(b.dt_baixa::text, '') = '' and coalesce(b.cd_motivo_baixa::text, '') = '')
				or 	(((b.dt_baixa IS NOT NULL AND b.dt_baixa::text <> '') or (b.cd_motivo_baixa IS NOT NULL AND b.cd_motivo_baixa::text <> '')) 
				and 	(b.qt_material - coalesce(b.qt_material_cancelado,0) > (	select 	coalesce(sum(e.qt_prevista_entrega),0)
							from	ordem_compra o,
								ordem_compra_item i,
								ordem_compra_item_entrega e
							where	o.nr_ordem_compra = i.nr_ordem_compra
							and	i.nr_ordem_compra = e.nr_ordem_compra
							and	i.nr_item_oci = e.nr_item_oci
							and	i.nr_solic_compra = b.nr_solic_compra
							and	i.nr_item_solic_compra = b.nr_item_solic_compra
							and	(o.dt_liberacao IS NOT NULL AND o.dt_liberacao::text <> '')
							and     coalesce(o.nr_seq_motivo_cancel::text, '') = ''
							and	coalesce(e.dt_cancelamento::text, '') = ''))))
				and     a.nr_solic_compra = b.nr_solic_compra);
										
	
	
BEGIN
	
	qt_total_solic_proj_rec := 0;
	vl_comprometido_proj_rec_w := 0;
		
	select 	coalesce(max(ie_cons_solic_acum_proj_rec),'N'),
		coalesce(max(ie_considera_vl_compr_saldo),'N')
	into STRICT	ie_cons_solic_acum_proj_rec_w,
		ie_considera_vl_compr_saldo_w
	from   	parametro_compras
	where  	cd_estabelecimento = cd_estabelecimento_p;
	
	/*Considera valor comprometido?*/


	if (ie_considera_vl_compr_saldo_w = 'S') then	
		/* Considera solicitacao de compra em valores comprometidos? */


		if (ie_cons_solic_acum_proj_rec_w = 'S') then	
			open C01;
			loop
			fetch C01 into	
				nr_solic_compra_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin
				qt_total_solic_proj_rec := qt_total_solic_proj_rec + 1;
				vl_comprometido_proj_rec_w := vl_comprometido_proj_rec_w + projeto_recurso_pck.obter_vl_comprometido_solic(nr_seq_proj_rec_p,nr_solic_compra_w);
				end;
			end loop;
			close C01;
		end if;
	end if;
	
	current_setting('projeto_recurso_pck.solic_compra_wr')::solic_compra_ty.qt_transacao := qt_total_solic_proj_rec;
	current_setting('projeto_recurso_pck.solic_compra_wr')::solic_compra_ty.vl_transacao := vl_comprometido_proj_rec_w;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE projeto_recurso_pck.set_vl_qt_solic_compra ( nr_seq_proj_rec_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;