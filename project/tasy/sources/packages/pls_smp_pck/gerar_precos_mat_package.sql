-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_smp_pck.gerar_precos_mat ( regra_simulacao_p pls_smp_pck.regra_simulacao, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Gerar os precos dos materiais simulados
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
Pontos de atencao:
Alteracoes:
-------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
dados_regra_preco_mat_w		pls_cta_valorizacao_pck.dados_regra_preco_mat_data;
sg_estado_w			pessoa_juridica.sg_estado%type;
regra_simulacao_preco_mat_w	pls_smp_pck.regra_simulacao_preco_mat;

-- Informacoes sobre os beneficiarios
c01 CURSOR(	nr_seq_smp_pc	pls_smp.nr_sequencia%type,
		sg_estado_pc	pessoa_juridica.sg_estado%type) FOR
SELECT	a.nr_sequencia,
	a.nr_seq_segurado,
	b.nr_seq_plano,
	(pls_obter_dados_segurado(a.nr_seq_segurado, 'NC'))::numeric  nr_seq_contrato,
	b.nr_seq_congenere,
	pls_obter_dados_segurado(a.nr_seq_segurado, 'TCC') ie_tipo_contratacao,
	coalesce(d.sg_estado, 'X') sg_estado,
	coalesce(c.ie_nacional, 'N') ie_nacional,
	(case	when(coalesce(c.ie_nacional, 'N')  = 'S')	then 'N'
		when(coalesce(sg_estado_pc, 'X') <> 'X' and coalesce(d.sg_estado, 'X') <> 'X') then CASE WHEN coalesce(sg_estado_pc, 'X')=coalesce(d.sg_estado, 'X') THEN  'E'  ELSE 'N' END
		when(coalesce(c.ie_nacional, 'N') <> 'S') then 'A'	
	 end) ie_tipo_intercambio,
	 coalesce(b.ie_pcmso, 'N') ie_pcmso,
	pls_obter_conv_cat_segurado(a.nr_seq_segurado, 1) cd_convenio,
	pls_obter_conv_cat_segurado(a.nr_seq_segurado, 2) cd_categoria,
	e.ie_preco,
	coalesce(b.ie_pcmso, 'A') ie_atend_pcmso
FROM pls_plano e, pls_smp_result_benef a, pls_segurado b
LEFT OUTER JOIN pls_congenere c ON (b.nr_seq_congenere = c.nr_sequencia)
LEFT OUTER JOIN pessoa_juridica d ON (c.cd_cgc = d.cd_cgc)
WHERE b.nr_sequencia		= a.nr_seq_segurado and e.nr_sequencia		= b.nr_seq_plano   and nr_seq_smp		= nr_seq_smp_pc;

-- Informacoes sobre os prestadores e materiais
c02 CURSOR(	nr_seq_smp_result_benef_pc	pls_smp_result_benef.nr_sequencia%type) FOR
SELECT	a.nr_seq_prestador,
	b.nr_seq_material,
	b.nr_sequencia nr_seq_item_mat,
	ie_tipo_despesa,
	d.ie_tipo_vinculo,
	d.nr_seq_tipo_prestador,
	CASE WHEN ie_tipo_despesa='1' THEN  '5' WHEN ie_tipo_despesa='2' THEN  '12'  ELSE '95' END  ie_origem_preco,
	d.nr_seq_classificacao,
	d.cd_prestador,
	cd_material_ops,
	nr_seq_material_unimed,
	ds_versao_tiss,
	cd_tiss_brasindice
FROM pls_material c, pls_smp_result_item b, pls_smp_result_prest a
LEFT OUTER JOIN pls_prestador d ON (a.nr_seq_prestador = d.nr_sequencia)
WHERE b.nr_seq_smp_result_prest	= a.nr_sequencia and c.nr_sequencia			= b.nr_seq_material  and b.ie_tipo_vinculacao		= 'A' -- somente os itens que nao tiverem seu preco informado manualmente
  and a.nr_seq_smp_result_benef	= nr_seq_smp_result_benef_pc and (b.nr_seq_material IS NOT NULL AND b.nr_seq_material::text <> '');
BEGIN

-- Somente se tiver regra
if (regra_simulacao_p.nr_sequencia IS NOT NULL AND regra_simulacao_p.nr_sequencia::text <> '') then

	-- Informacoes acima dos beneficiarios
	begin
		select	coalesce(sg_estado,'X')
		into STRICT	sg_estado_w
		from	pessoa_juridica
		where	cd_cgc	= (	SELECT	max(cd_cgc_outorgante)
					from	pls_outorgante
					where	cd_estabelecimento	= cd_estabelecimento_p)  LIMIT 1;
	exception
		when no_data_found then sg_estado_w := 'X';
	end;
	
	-- carrega os beneficiarios e prestadores 
	for r_c01_w in c01(regra_simulacao_p.nr_sequencia, sg_estado_w) loop
		
		for r_c02_w in c02(r_c01_w.nr_sequencia) loop
		
			dados_regra_preco_mat_w.delete;
			
			-- levanta as informacoes para buscar as regras de precos
			regra_simulacao_preco_mat_w.cd_estabelecimento			:= cd_estabelecimento_p;
			regra_simulacao_preco_mat_w.nr_seq_prestador			:= r_c02_w.nr_seq_prestador;
			regra_simulacao_preco_mat_w.dt_vigencia				:= regra_simulacao_p.dt_referencia;
			regra_simulacao_preco_mat_w.nr_seq_material			:= r_c02_w.nr_seq_material;
			regra_simulacao_preco_mat_w.ie_tipo_tabela			:= regra_simulacao_p.ie_regra_preco;
			regra_simulacao_preco_mat_w.ie_tipo_despesa			:= r_c02_w.ie_tipo_despesa;
			regra_simulacao_preco_mat_w.ie_origem_preco			:= r_c02_w.ie_origem_preco;
			regra_simulacao_preco_mat_w.nr_seq_outorgante			:= null;
			regra_simulacao_preco_mat_w.nr_seq_segurado			:= r_c01_w.nr_seq_segurado;
			regra_simulacao_preco_mat_w.nr_seq_contrato_intercambio		:= null;
			regra_simulacao_preco_mat_w.nr_seq_fornecedor			:= r_c02_w.nr_seq_prestador;
			regra_simulacao_preco_mat_w.nr_seq_categoria			:= null;
			regra_simulacao_preco_mat_w.nr_seq_tipo_acomodacao		:= null;
			regra_simulacao_preco_mat_w.nr_seq_tipo_atendimento		:= null;
			regra_simulacao_preco_mat_w.nr_seq_clinica			:= null;
			regra_simulacao_preco_mat_w.ie_tipo_guia			:= null;
			regra_simulacao_preco_mat_w.ie_tipo_segurado			:= null;
			regra_simulacao_preco_mat_w.ie_tipo_vinculo			:= r_c02_w.ie_tipo_vinculo;
			regra_simulacao_preco_mat_w.nr_seq_tipo_prestador		:= r_c02_w.nr_seq_tipo_prestador;
			regra_simulacao_preco_mat_w.ie_preco				:= r_c01_w.ie_preco;
			regra_simulacao_preco_mat_w.nr_seq_plano			:= r_c01_w.nr_seq_plano;
			regra_simulacao_preco_mat_w.nr_seq_contrato			:= r_c01_w.nr_seq_contrato;
			regra_simulacao_preco_mat_w.nr_seq_congenere			:= r_c01_w.nr_seq_congenere;
			regra_simulacao_preco_mat_w.ie_internado			:= 'S';
			regra_simulacao_preco_mat_w.nr_seq_classificacao_prest		:= r_c02_w.nr_seq_classificacao;
			regra_simulacao_preco_mat_w.ie_tipo_contratacao			:= r_c01_w.ie_tipo_contratacao;
			regra_simulacao_preco_mat_w.sg_uf_operadora_intercambio		:= sg_estado_w;
			regra_simulacao_preco_mat_w.ie_tipo_intercambio			:= r_c01_w.ie_tipo_intercambio;
			regra_simulacao_preco_mat_w.nr_seq_tipo_uso			:= null;
			regra_simulacao_preco_mat_w.ie_pcmso				:= r_c01_w.ie_pcmso;
			regra_simulacao_preco_mat_w.ie_ref_guia_internacao		:= null;
			regra_simulacao_preco_mat_w.ie_atend_pcmso			:= r_c01_w.ie_atend_pcmso;
			regra_simulacao_preco_mat_w.nr_seq_tipo_atend_princ		:= null;
			regra_simulacao_preco_mat_w.ie_restringe_estab			:= pls_obter_se_controle_estab('RP');
			regra_simulacao_preco_mat_w.cd_prestador			:= r_c02_w.cd_prestador;
			regra_simulacao_preco_mat_w.nr_seq_mat_conta			:= null;
			regra_simulacao_preco_mat_w.cd_material_ops			:= r_c02_w.cd_material_ops;
			regra_simulacao_preco_mat_w.nr_seq_material_unimed		:= r_c02_w.nr_seq_material_unimed;
			regra_simulacao_preco_mat_w.ds_versao_tiss			:= r_c02_w.ds_versao_tiss;
			regra_simulacao_preco_mat_w.cd_tiss_brasindice			:= r_c02_w.cd_tiss_brasindice;
			regra_simulacao_preco_mat_w.cd_convenio				:= r_c01_w.cd_convenio;
			regra_simulacao_preco_mat_w.cd_categoria			:= r_c01_w.cd_categoria;
			regra_simulacao_preco_mat_w.nr_seq_item_mat			:= r_c02_w.nr_seq_item_mat;
			regra_simulacao_preco_mat_w.ie_tipo_atendimento			:= 'A';
			
			
			
			-- retorna as regras encontradas para o material
			dados_regra_preco_mat_w := pls_smp_pck.obter_regra_preco_mat(regra_simulacao_preco_mat_w, dados_regra_preco_mat_w);
			
			
			if (dados_regra_preco_mat_w IS NOT NULL AND dados_regra_preco_mat_w::text <> '') then
				-- Com as regras localizadas, gera os valores para o material
				CALL pls_smp_pck.aplicar_regra_preco_mat(regra_simulacao_p, regra_simulacao_preco_mat_w, dados_regra_preco_mat_w, nm_usuario_p);			
			end if;			
			
			
			
		end loop; -- fim prestadores e materiais
	end loop; -- fim beneficiario
end if; -- fim existe regra	
END;	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_smp_pck.gerar_precos_mat ( regra_simulacao_p pls_smp_pck.regra_simulacao, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
