-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_entao_regra_preco_cta_pck.obter_preco_brasindice ( nr_seq_prestador_p pls_conta.nr_seq_prestador_exec%type, nr_seq_material_p pls_conta_mat.nr_seq_material%type, dt_vigencia_p pls_cp_cta_emat.dt_base_fixo%type, tx_ajuste_pfb_p pls_cp_cta_emat.tx_ajuste_pfb%type, tx_pmc_neut_p pls_cp_cta_emat.tx_ajuste_pmc_neut%type, tx_pmc_neg_p pls_cp_cta_emat.tx_ajuste_pmc_neg%type, tx_pmc_pos_p pls_cp_cta_emat.tx_ajuste_pmc_pos%type, ie_tipo_preco_brasindice_p pls_cp_cta_emat.ie_tipo_preco_brasindice%type, vl_pfb_neutra_brasindice_p pls_cp_cta_emat.vl_pfb_neutra_brasindice%type, vl_pfb_positiva_brasindice_p pls_cp_cta_emat.vl_pfb_positiva_brasindice%type, vl_pfb_negativa_brasindice_p pls_cp_cta_emat.vl_pfb_negativa_brasindice%type, ie_tipo_ajuste_pfb_p pls_cp_cta_emat.ie_tipo_ajuste_pfb%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) RETURNS bigint AS $body$
DECLARE


cd_laboratorio_w	brasindice_preco.cd_laboratorio%type;
cd_medicamento_w	brasindice_preco.cd_medicamento%type;
cd_apresentacao_w	brasindice_preco.cd_apresentacao%type;
vl_medicamento_w	brasindice_preco.vl_preco_medicamento%type;
ie_tipo_preco_regra_w	pls_regra_brasindice_preco.ie_tipo_preco%type;
ie_tipo_preco_w		brasindice_preco.ie_tipo_preco%type;
qt_conversao_w		pls_material.qt_conversao%type;
dt_vigencia_bras_w	brasindice_preco.dt_inicio_vigencia%type;
pr_ipi_w		brasindice_preco.pr_ipi%type;
ie_pis_cofins_w		brasindice_preco.ie_pis_cofins%type;
cd_tiss_brasindice_w	brasindice_preco.cd_tiss%type;
ie_ultimo_vl_valido_w	pls_regra_brasindice_preco.ie_ultimo_valor_valido%type;
ie_preco_valido_w	boolean;

-- a pesquisa é dividida em duas etapas basicamente pelo motivo de que o código TISS não deve ser o único parâmetro levado 
-- em consideração para buscar os dados dos valores.
-- pode existir outro material de código TISS diferente e ele deve ser considerado conforme é feito no cursor C02
C01 CURSOR(	dt_vigencia_bras_pc	brasindice_preco.dt_inicio_vigencia%type,
		cd_tiss_brasindice_pc	brasindice_preco.cd_tiss%type) FOR
	SELECT	cd_laboratorio,
		cd_medicamento,
		cd_apresentacao
	from	brasindice_preco
	where	cd_tiss	= cd_tiss_brasindice_pc
	and	dt_inicio_vigencia <= dt_vigencia_bras_pc
	order by dt_inicio_vigencia desc;

C02 CURSOR(	dt_vigencia_bras_pc	brasindice_preco.dt_inicio_vigencia%type,
		cd_laboratorio_pc	brasindice_preco.cd_laboratorio%type,
		cd_medicamento_pc	brasindice_preco.cd_medicamento%type,
		cd_apresentacao_pc	brasindice_preco.cd_apresentacao%type) FOR
	SELECT 	coalesce(vl_preco_final, 0) vl_preco_final,
		coalesce(vl_preco_medicamento, 0) vl_preco_medicamento,
		ie_tipo_preco,
		dt_inicio_vigencia,
		coalesce(pr_ipi, 0) pr_ipi,
		coalesce(ie_pis_cofins, 'T') ie_pis_cofins,
		dt_liberacao
	from	brasindice_preco
	where	cd_laboratorio = cd_laboratorio_pc
	and	cd_medicamento = cd_medicamento_pc
	and	cd_apresentacao = cd_apresentacao_pc
	and	dt_inicio_vigencia <= dt_vigencia_bras_pc
	order by dt_inicio_vigencia desc,
		coalesce(vl_preco_final, vl_preco_medicamento) desc;
BEGIN

dt_vigencia_bras_w := coalesce(dt_vigencia_p, clock_timestamp());

-- verifica o tipo preço brasindice 
-- PMC = preço maximo ao consumidor
-- PFB = preço de fabrica
-- CR = conforme regra
-- tem um nvl na leitura da regra que caso este campo seja nulo o valor fica CR
if (ie_tipo_preco_brasindice_p = 'CR') then

	-- PMC, PFB ou PFM (PFB quando PMC = 0)
	ie_ultimo_vl_valido_w := pls_entao_regra_preco_cta_pck.obter_regra_brasindice(	nr_seq_material_p, dt_vigencia_bras_w, nr_seq_prestador_p, cd_estabelecimento_p);
else

	ie_tipo_preco_regra_w := ie_tipo_preco_brasindice_p;
end if;

-- pega os dados do material
select	max(cd_tiss_brasindice),
	max(qt_conversao)
into STRICT	cd_tiss_brasindice_w,
	qt_conversao_w
from	pls_material
where	nr_sequencia = nr_seq_material_p
and	cd_estabelecimento = cd_estabelecimento_p;

for r_c01_w in C01(	dt_vigencia_bras_w, cd_tiss_brasindice_w) loop

	cd_laboratorio_w := r_c01_w.cd_laboratorio;
	cd_medicamento_w := r_c01_w.cd_medicamento;
	cd_apresentacao_w := r_c01_w.cd_apresentacao;
	exit;

end loop;

-- verifica todos os registros do material ordenando pela data, a data mais atual válida é a correta
for r_c02_w in C02(	dt_vigencia_bras_w, cd_laboratorio_w, cd_medicamento_w,
			cd_apresentacao_w) loop

	-- sempre inicia sendo válida
	ie_preco_valido_w := true;

	-- se exige liberação e a data de liberação não está informada
	if (current_setting('pls_entao_regra_preco_cta_pck.ie_exige_lib_w')::pls_parametros.ie_exige_lib_bras%type = 'S') and (coalesce(r_c02_w.dt_liberacao::text, '') = '') then
	
		ie_preco_valido_w := false;
	end if;
	
	-- deve ser o último valor válido e os valores estão zerados então não é válido
	if (ie_ultimo_vl_valido_w = 'S') and (r_c02_w.vl_preco_final = 0) and (r_c02_w.vl_preco_medicamento = 0) then
	
		ie_preco_valido_w := false;
	end if;
	
	-- se for tipo de preço diferente e o tipo da regra é PFM precisa verificar
	if (ie_tipo_preco_regra_w != r_c02_w.ie_tipo_preco) and (ie_tipo_preco_regra_w = 'PFM') then
	
		-- se for PMC e não tiver preço informado não é válido
		if (ie_tipo_preco_regra_w = 'PFM') and (r_c02_w.ie_tipo_preco = 'PMC') and (r_c02_w.vl_preco_final = 0) and (r_c02_w.vl_preco_medicamento = 0) then
			
			ie_preco_valido_w := false;
		end if;
	-- for diferente então não é válido
	elsif (ie_tipo_preco_regra_w != r_c02_w.ie_tipo_preco) then
		
		ie_preco_valido_w := false;
	end if;
	
	-- se for válido atribui os valores para as variáveis
	if (ie_preco_valido_w) then
	
		ie_tipo_preco_w := r_c02_w.ie_tipo_preco;
		pr_ipi_w := r_c02_w.pr_ipi;
		ie_pis_cofins_w := r_c02_w.ie_pis_cofins;
		
		-- se tem o preço final cadastrado atribui ele
		if (r_c02_w.vl_preco_final > 0) then

			vl_medicamento_w := r_c02_w.vl_preco_final;

		-- senão atribui o valor do medicamento
		else

			vl_medicamento_w := r_c02_w.vl_preco_medicamento;
		end if;
		
		-- a partir do momento que identificou o preço sai fora do cursor
		-- o cursor é automaticamente fechado quando acontece isso
		exit;
	end if;
end loop;

-- se for preço de fabrica
if (ie_tipo_preco_w = 'PFB') then

	-- se é para aplicar taxa única
	-- tem nvl no momento de ler as regras
	if (ie_tipo_ajuste_pfb_p = 'U') and (tx_ajuste_pfb_p IS NOT NULL AND tx_ajuste_pfb_p::text <> '') then
		
		vl_medicamento_w := (vl_medicamento_w * tx_ajuste_pfb_p);

	-- se for o conjunto de taxas
	else
		-- verifica qual a taxa que deve ser aplicada (Neutra, Positiva ou Negativa)
		if (ie_pis_cofins_w = 'S') then

			vl_medicamento_w := dividir_sem_round(vl_medicamento_w, vl_pfb_positiva_brasindice_p);

		elsif (ie_pis_cofins_w = 'N') then

			vl_medicamento_w := dividir_sem_round(vl_medicamento_w, vl_pfb_negativa_brasindice_p);
		else

			vl_medicamento_w := dividir_sem_round(vl_medicamento_w, vl_pfb_neutra_brasindice_p);
		end if;
	end if;

-- se for preco máximo ao consumidor e ao menos a taxa neutra está informada
elsif (ie_tipo_preco_w = 'PMC') and (tx_pmc_neut_p IS NOT NULL AND tx_pmc_neut_p::text <> '') then

	-- verifca qual a taxa que deve ser aplicada (Neutra, Positiva ou Negativa)
	if (ie_pis_cofins_w = 'S') then

		vl_medicamento_w := vl_medicamento_w * coalesce(tx_pmc_pos_p, tx_pmc_neut_p);

	elsif (ie_pis_cofins_w = 'N') then

		vl_medicamento_w := vl_medicamento_w * coalesce(tx_pmc_neg_p, tx_pmc_neut_p);
	else

		vl_medicamento_w := vl_medicamento_w * tx_pmc_neut_p;
	end if;
end if;

-- aplica a taxa ipi e a conversão
if (vl_medicamento_w > 0) then

	-- se não tem quantidade de conversão informada ou está como zero fica 1
	if (coalesce(qt_conversao_w::text, '') = '') or (qt_conversao_w = 0) then
		
		qt_conversao_w := 1;
	end if;

	vl_medicamento_w := vl_medicamento_w + (vl_medicamento_w * pr_ipi_w / 100);
	vl_medicamento_w := vl_medicamento_w / qt_conversao_w;
end if;

return vl_medicamento_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_entao_regra_preco_cta_pck.obter_preco_brasindice ( nr_seq_prestador_p pls_conta.nr_seq_prestador_exec%type, nr_seq_material_p pls_conta_mat.nr_seq_material%type, dt_vigencia_p pls_cp_cta_emat.dt_base_fixo%type, tx_ajuste_pfb_p pls_cp_cta_emat.tx_ajuste_pfb%type, tx_pmc_neut_p pls_cp_cta_emat.tx_ajuste_pmc_neut%type, tx_pmc_neg_p pls_cp_cta_emat.tx_ajuste_pmc_neg%type, tx_pmc_pos_p pls_cp_cta_emat.tx_ajuste_pmc_pos%type, ie_tipo_preco_brasindice_p pls_cp_cta_emat.ie_tipo_preco_brasindice%type, vl_pfb_neutra_brasindice_p pls_cp_cta_emat.vl_pfb_neutra_brasindice%type, vl_pfb_positiva_brasindice_p pls_cp_cta_emat.vl_pfb_positiva_brasindice%type, vl_pfb_negativa_brasindice_p pls_cp_cta_emat.vl_pfb_negativa_brasindice%type, ie_tipo_ajuste_pfb_p pls_cp_cta_emat.ie_tipo_ajuste_pfb%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;