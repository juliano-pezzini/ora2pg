-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pos_estabelecido_pck.upd_lib_automatic_pos_mat ( tb_seq_proc_upd_p INOUT pls_util_cta_pck.t_number_table, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

	if (tb_seq_proc_upd_p.count > 0) then
		forall i in tb_seq_proc_upd_p.first..tb_seq_proc_upd_p.last
			update	pls_conta_pos_mat
				set	qt_item				= qt_item,
					vl_administracao 		= (round((coalesce(vl_taxa_material,0))::numeric,2)),
					ie_status_faturamento		= CASE WHEN current_setting('pls_pos_estabelecido_pck.ie_controle_pos_estabelecido_w')::pls_parametros.ie_controle_pos_estabelecido%type='S' THEN  'P'  ELSE 'L' END ,
					nm_usuario 			= nm_usuario_p,
					dt_atualizacao 			= clock_timestamp(),
					vl_liberado_material_fat 	= vl_materiais_calc,
					vl_glosa_material_fat		= 0,
					vl_lib_taxa_material		= vl_taxa_material,
					vl_glosa_taxa_material		= 0,
					vl_materiais			= vl_materiais_calc
				where	nr_sequencia			= tb_seq_proc_upd_p(i);
		end if;
		tb_seq_proc_upd_p.delete;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pos_estabelecido_pck.upd_lib_automatic_pos_mat ( tb_seq_proc_upd_p INOUT pls_util_cta_pck.t_number_table, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
