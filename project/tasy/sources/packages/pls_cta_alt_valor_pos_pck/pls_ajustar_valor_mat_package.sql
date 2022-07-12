-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Rotina utilizada quando configurado para utilização de forma antiga de geração de pós
CREATE OR REPLACE PROCEDURE pls_cta_alt_valor_pos_pck.pls_ajustar_valor_mat ( nr_seq_conta_p pls_conta_v.nr_sequencia%type, nr_seq_conta_pos_estab_p pls_conta_pos_estabelecido.nr_sequencia%type, qt_liberada_p pls_conta_proc_v.qt_procedimento%type, vl_liberado_p pls_conta_proc_v.vl_liberado%type, vl_unitario_p pls_conta_proc_v.vl_unitario%type, vl_lib_taxa_mat_p pls_conta_proc_v.vl_lib_taxa_material%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


ie_tipo_conta_w 	pls_conta_v.ie_tipo_conta%type;
vl_glosa_w 		pls_conta_mat_v.vl_glosa%type;
vl_glosa_taxa_w 	pls_conta_mat_v.vl_glosa_taxa_material%type;

C01 CURSOR(nr_seq_conta_pos_estab_pc		pls_conta_pos_estabelecido.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia nr_seq_conta_pos_estabelecido,
		b.vl_liberado,		
		a.vl_lib_taxa_material
	from	pls_conta_pos_estabelecido 	a,
		pls_conta_mat_v			b
	where	a.nr_sequencia	= nr_seq_conta_pos_estab_pc
	and	b.nr_sequencia	= a.nr_seq_conta_mat
	and	b.nr_seq_conta	= a.nr_seq_conta
	and	((a.ie_situacao		= 'A') or (coalesce(a.ie_situacao::text, '') = ''));

BEGIN

for r_C01_w in C01(nr_seq_conta_pos_estab_p) loop

	-- se for intercâmbio
	vl_glosa_taxa_w := pls_util_cta_pck.pls_obter_vl_glosa(vl_lib_taxa_mat_p, r_C01_w.vl_lib_taxa_material);
	
	-- Somar o valor de glosa da taxa ao valor de glosa do item
	-- OS 606930.
	if (vl_liberado_p > 0) and (qt_liberada_p = 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(331628);
	end if;
	
	if (vl_liberado_p = vl_lib_taxa_mat_p) and (vl_liberado_p > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(779915);
	end if;
	
	update 	pls_conta_pos_estabelecido set
		vl_liberado_co_fat  		= 0,
		vl_liberado_hi_fat 		= 0,             
		vl_liberado_material_fat      	= coalesce(vl_liberado_p,0) - coalesce(vl_lib_taxa_mat_p,0),  
		vl_lib_taxa_co			= 0,                  
		vl_lib_taxa_material 		= vl_lib_taxa_mat_p,  
		vl_administracao		= vl_lib_taxa_mat_p,
		vl_lib_taxa_servico       	= 0,      
		vl_glosa_co_fat			= 0,          
		vl_glosa_hi_fat			= 0,        
		vl_glosa_material_fat		= 0,   
		vl_glosa_taxa_co        	= 0,
		vl_glosa_taxa_material  	= vl_glosa_taxa_w,
		vl_glosa_taxa_servico   	= 0,		
		vl_beneficiario			= vl_liberado_p,
		vl_materiais			= coalesce(vl_liberado_p,0) - coalesce(vl_lib_taxa_mat_p,0),
		vl_custo_operacional		= 0,
		vl_medico			= 0,
		qt_item				= qt_liberada_p,
		nm_usuario			= nm_usuario_p,
		dt_atualizacao			= clock_timestamp(),
		ie_status_faturamento		= 'L',
		ie_tipo_liberacao		= 'U'
	where	nr_sequencia			= r_C01_w.nr_seq_conta_pos_estabelecido;

end loop;
						
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_alt_valor_pos_pck.pls_ajustar_valor_mat ( nr_seq_conta_p pls_conta_v.nr_sequencia%type, nr_seq_conta_pos_estab_p pls_conta_pos_estabelecido.nr_sequencia%type, qt_liberada_p pls_conta_proc_v.qt_procedimento%type, vl_liberado_p pls_conta_proc_v.vl_liberado%type, vl_unitario_p pls_conta_proc_v.vl_unitario%type, vl_lib_taxa_mat_p pls_conta_proc_v.vl_lib_taxa_material%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;