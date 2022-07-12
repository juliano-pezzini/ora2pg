-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_entao_regra_preco_cta_pck.obter_regra_brasindice ( nr_seq_material_p pls_material.nr_sequencia%type, dt_vigencia_p timestamp, nr_seq_prestador_p pls_prestador.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_ultimo_vl_valido_p out pls_regra_brasindice_preco.ie_ultimo_valor_valido%type) AS $body$
DECLARE


ie_tipo_preco_w		pls_regra_brasindice_preco.ie_tipo_preco%type;
ie_valido_w		boolean;

C01 CURSOR(	cd_estabelecimento_pc	estabelecimento.cd_estabelecimento%type,
		nr_seq_material_pc	pls_material.nr_sequencia%type,
		dt_vigencia_pc		timestamp) FOR
	SELECT	ie_tipo_preco,
		pls_obter_se_mat_estrutura(nr_seq_material_pc, nr_seq_estrutura_mat) ie_mat_estrutura,
		nr_seq_estrutura_mat,
		nr_seq_prestador,
		cd_estabelecimento,
		nr_seq_material,
		coalesce(ie_ultimo_valor_valido, 'N') ie_ultimo_vl_valido
	from	pls_regra_brasindice_preco
	where	dt_vigencia_pc between dt_inicio_vigencia_ref and dt_fim_vigencia_ref
	and	cd_estabelecimento = cd_estabelecimento_pc
	and	ie_situacao = 'A'
	order by coalesce(nr_seq_estrutura_mat, 9999999999) desc,
		coalesce(nr_seq_prestador, 9999999999) desc,
		coalesce(cd_estabelecimento, 9999999999) desc,
		coalesce(nr_seq_material, 9999999999) desc;

BEGIN

-- abre o cursor e retorna o último registro válido
for r_c01_w in C01(	cd_estabelecimento_p, nr_seq_material_p, dt_vigencia_p) loop
	
	-- sempre inicia sendo válido
	ie_valido_w := true;
	
	-- se a estrutura do material não for válida
	if (r_c01_w.ie_mat_estrutura = 'N') then
	
		ie_valido_w := false;
	end if;
	
	-- tem um material na regra e o material do parametro não for o mesmo
	if (r_c01_w.nr_seq_material IS NOT NULL AND r_c01_w.nr_seq_material::text <> '') and (r_c01_w.nr_seq_material != nr_seq_material_p) then
	
		ie_valido_w := false;
	end if;
	
	-- se tem um prestador informado na regra e o passado de parametro for diferente
	if (r_c01_w.nr_seq_prestador IS NOT NULL AND r_c01_w.nr_seq_prestador::text <> '') and (r_c01_w.nr_seq_prestador != nr_seq_prestador_p) then
	
		ie_valido_w := false;
	end if;
	
	if (ie_valido_w) then
	
		ie_tipo_preco_w := r_c01_w.ie_tipo_preco;
		ie_ultimo_vl_valido_p := r_c01_w.ie_ultimo_vl_valido;
		
		exit;
	end if;
end loop;

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_entao_regra_preco_cta_pck.obter_regra_brasindice ( nr_seq_material_p pls_material.nr_sequencia%type, dt_vigencia_p timestamp, nr_seq_prestador_p pls_prestador.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_ultimo_vl_valido_p out pls_regra_brasindice_preco.ie_ultimo_valor_valido%type) FROM PUBLIC;
