-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_entao_regra_preco_cta_pck.obter_valor_mat_a900_icms ( nr_seq_material_p pls_conta_mat.nr_seq_material%type, vl_perc_icms_p pls_regra_icms.vl_perc_icms%type, dt_atend_material_p pls_conta_mat.dt_atendimento%type, ds_versao_tiss_p pls_mat_unimed_fed_sc.ds_versao_tiss%type) RETURNS bigint AS $body$
DECLARE


vl_material_w		pls_mat_unimed_trib.vl_pmc%type;
nr_seq_mat_unimed_w	pls_mat_unimed_fed_sc.nr_sequencia%type;

c01 CURSOR(	nr_seq_mat_unimed_pc	pls_material_unimed.nr_sequencia%type,
		vl_perc_icms_pc		pls_mat_unimed_trib.vl_perc_icms%type,
		dt_vigencia_pc		pls_conta_mat.dt_atendimento%type) FOR
	SELECT	vl_pmc
	from	pls_mat_unimed_trib
	where	nr_seq_mat_unimed = nr_seq_mat_unimed_pc
	and	vl_perc_icms = vl_perc_icms_pc
	and	dt_inicio_vigencia_ref <= dt_vigencia_pc
	order 	by dt_inicio_vigencia_ref desc;

BEGIN

vl_material_w := null;

-- obtém a sequencia do material unimed, possui tratamento pela versão tiss já
nr_seq_mat_unimed_w := pls_entao_regra_preco_cta_pck.obter_mat_unimed_a900(	nr_seq_material_p);

-- abre o cursor que está ordenado para trazer o registro mais rescente primeiro
for r_c01_w in c01(nr_seq_mat_unimed_w, vl_perc_icms_p, dt_atend_material_p) loop

	-- o primeiro que retornou é o correto
	vl_material_w := r_c01_w.vl_pmc;
	
	-- sai do for e fecha o cursor
	exit;
end loop;

return coalesce(vl_material_w, 0);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_entao_regra_preco_cta_pck.obter_valor_mat_a900_icms ( nr_seq_material_p pls_conta_mat.nr_seq_material%type, vl_perc_icms_p pls_regra_icms.vl_perc_icms%type, dt_atend_material_p pls_conta_mat.dt_atendimento%type, ds_versao_tiss_p pls_mat_unimed_fed_sc.ds_versao_tiss%type) FROM PUBLIC;
