-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE diops_ev_corresp_update_total ( nm_usuario_p text, nr_seq_periodo_p bigint, ie_tipo_evento_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE





vl_preco_pre_corresp_pre_w			diops_contrap_ev_corresp.vl_preco_pre_corresp_pre%type;
vl_preco_pre_corresp_pos_w			diops_contrap_ev_corresp.vl_preco_pre_corresp_pos%type;
vl_preco_pos_corresp_pre_w			diops_contrap_ev_corresp.vl_preco_pos_corresp_pre%type;
vl_preco_pos_corresp_pos_w			diops_contrap_ev_corresp.vl_preco_pos_corresp_pos%type;
vl_preco_pre_cart_propr_w			diops_contrap_ev_corresp.vl_preco_pre_cart_propr%type;
vl_preco_pre_corresp_assum_w			diops_contrap_ev_corresp.vl_preco_pre_corresp_assum%type;
vl_preco_pos_cart_propr_w			diops_contrap_ev_corresp.vl_preco_pos_cart_propr%type;
vl_preco_pos_corresp_assum_w			diops_contrap_ev_corresp.vl_preco_pos_corresp_assum%type;

BEGIN

	select 	sum(vl_preco_pre_corresp_pre),
		sum(vl_preco_pre_corresp_pos),
		sum(vl_preco_pos_corresp_pre),
		sum(vl_preco_pos_corresp_pos),
		sum(vl_preco_pre_cart_propr),
		sum(vl_preco_pre_corresp_assum),
		sum(vl_preco_pos_cart_propr),
		sum(vl_preco_pos_corresp_assum)
	into STRICT 	vl_preco_pre_corresp_pre_w,
		vl_preco_pre_corresp_pos_w,
		vl_preco_pos_corresp_pre_w,
		vl_preco_pos_corresp_pos_w,
		vl_preco_pre_cart_propr_w,
		vl_preco_pre_corresp_assum_w,
		vl_preco_pos_cart_propr_w,
		vl_preco_pos_corresp_assum_w
	from	diops_contrap_ev_corresp
	where	nr_seq_periodo 		= nr_seq_periodo_p
	and	cd_estabelecimento	= cd_estabelecimento_p
	and	cd_tipo_movimento not in (1, 2, 3, 4, 5, 6, 10, 11);


	update 	diops_contrap_ev_corresp
	set    	vl_preco_pre_corresp_pre 	= coalesce(vl_preco_pre_corresp_pre_w, 0),
		vl_preco_pre_corresp_pos 	= coalesce(vl_preco_pre_corresp_pos_w, 0),
		vl_preco_pos_corresp_pre	= coalesce(vl_preco_pos_corresp_pre_w, 0),
		vl_preco_pos_corresp_pos 	= coalesce(vl_preco_pos_corresp_pos_w, 0),
		vl_preco_pre_cart_propr 	= coalesce(vl_preco_pre_cart_propr_w, 0),
		vl_preco_pre_corresp_assum 	= coalesce(vl_preco_pre_corresp_assum_w, 0),
		vl_preco_pos_cart_propr 	= coalesce(vl_preco_pos_cart_propr_w, 0),
		vl_preco_pos_corresp_assum 	= coalesce(vl_preco_pos_corresp_assum_w, 0),
		nm_usuario 			= nm_usuario_p,
		dt_atualizacao			= clock_timestamp()
	where	nr_seq_periodo = nr_seq_periodo_p
	and	ie_tipo_evento = 'CE'
	and	cd_estabelecimento = cd_estabelecimento_p
	and	cd_tipo_movimento = 10;

commit;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE diops_ev_corresp_update_total ( nm_usuario_p text, nr_seq_periodo_p bigint, ie_tipo_evento_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
