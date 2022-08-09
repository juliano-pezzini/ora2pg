-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_convert_mat_guia_xml_fat ( nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_material_p pls_material.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, ie_tipo_guia_p pls_conta.ie_tipo_guia%type, nr_seq_pagador_p pls_contrato_pagador.nr_sequencia%type, cd_material_conv_p INOUT pls_conv_mat_fat_xml.cd_material_conv%type, ds_material_conv_p INOUT pls_conv_mat_fat_xml.ds_material_conv%type, cd_prefixo_p INOUT pls_conv_mat_fat_xml.cd_prefixo%type, nr_seq_regra_p INOUT pls_conv_mat_fat_xml.nr_sequencia%type, cd_tab_item_p INOUT pls_conv_mat_fat_xml.cd_tab_item%type, ie_agrupamento_p INOUT pls_conv_mat_fat_xml.ie_agrupamento%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_prestador_p pls_prestador.nr_sequencia%type) AS $body$
DECLARE


ie_origem_analise_w		pls_analise_conta.ie_origem_analise%type;
ie_tipo_despesa_w		pls_material.ie_tipo_despesa%type;
cd_material_ops_w		pls_material.cd_material_ops%type;
ds_material_tuss_w		varchar(255);
cd_material_simpro_w		pls_material.cd_simpro%type;
ds_material_simpro_w		varchar(255);
ie_cod_tuss_w			pls_conv_mat_fat_xml.ie_cod_tuss%type;
ie_cod_simpro_w			pls_conv_mat_fat_xml.ie_cod_simpro%type;
ds_material_ops_w		pls_material.ds_material%type;
cd_material_tuss_w		pls_material_unimed.cd_material_tuss%type;
nr_seq_contrato_w		pls_contrato.nr_sequencia%type;
nr_seq_intercambio_w		pls_intercambio.nr_sequencia%type;
nr_seq_plano_w			pls_plano.nr_sequencia%type;
cd_material_conv_w		pls_conv_mat_fat_xml.cd_material_conv%type;
nr_seq_regra_w			pls_conv_mat_fat_xml.nr_sequencia%type;
ds_material_conv_w		pls_conv_mat_fat_xml.ds_material_conv%type;
ie_regra_origem_w		pls_conv_mat_fat_xml.ie_regra_origem%type;
cd_prefixo_w			pls_conv_mat_fat_xml.cd_prefixo%type;
cd_mascara_tuss_w		pls_conv_mat_fat_xml.cd_mascara_tuss%type;
cd_mascara_simpro_w		pls_conv_mat_fat_xml.cd_mascara_simpro%type;
cd_mascara_original_w		pls_conv_mat_fat_xml.cd_mascara_original%type;
cd_mascara_conv_fat_w		pls_conv_mat_fat_xml.cd_mascara_conv_fat%type;
ie_origem_protocolo_w		pls_protocolo_conta.ie_origem_protocolo%type;
ie_tipo_guia_princ_w		pls_conta.ie_tipo_guia%type;
cd_guia_w			pls_conta.cd_guia%type;
nr_seq_prestador_princ_w	pls_prestador.nr_sequencia%type;
nr_seq_conta_princ_w		pls_conta.nr_sequencia%type;
cd_tab_item_w			pls_conv_mat_fat_xml.cd_tab_item%type;
ie_agrupamento_w		pls_conv_mat_fat_xml.ie_agrupamento%type;
cd_material_a900_w		pls_material_unimed.cd_material%type;
nr_sequencia_w			pls_material.nr_sequencia%type;
nr_ver_tiss_w			pls_material.ds_versao_tiss%type;
cd_material_imp_w		pls_conta_mat.cd_material_imp%type;
ds_material_imp_w		pls_conta_mat.ds_material_imp%type;
ie_cod_brasindice_w		pls_conv_mat_fat_xml.ie_cod_brasindice%type;
cd_tiss_brasindice_w		pls_material.cd_tiss_brasindice%type;
ds_apre_mat_tuss_w		varchar(255);
cd_mascara_brasindice_w		pls_conv_mat_fat_xml.cd_mascara_brasindice%type;
ds_brasindice_w			brasindice_medicamento.ds_medicamento%type;
ie_data_conv_mat_unimed_w	pls_parametro_faturamento.ie_data_conv_mat_unimed%type;
dt_atendimento_referencia_w	pls_conta.dt_atendimento_referencia%type;

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Gerar a conversao do materiais na geracao das guias em XML na mensalidade
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ X ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
c01 CURSOR FOR
	SELECT	/*+USE_CONCAT*/		cd_material_conv,
		ds_material_conv,
		cd_prefixo,
		nr_sequencia,
		ie_regra_origem,
		cd_mascara_tuss,
		cd_mascara_simpro,
		cd_mascara_original,
		cd_mascara_conv_fat,
		cd_tab_item,
		ie_agrupamento,
		cd_mascara_brasindice
	from	pls_conv_mat_fat_xml
	where	CASE WHEN ie_data_conv_mat_unimed_w='DI' THEN  dt_atendimento_referencia_w  ELSE clock_timestamp() END  between dt_inicio_vigencia_ref and dt_fim_vigencia_ref
	and	ie_situacao = 'A'
	and	((ie_tipo_despesa	= ie_tipo_despesa_w) or (coalesce(ie_tipo_despesa::text, '') = ''))
	and	((pls_obter_se_mat_estrutura(nr_seq_material_p,nr_seq_estrutura_mat) = 'S') or (coalesce(nr_seq_estrutura_mat::text, '') = ''))
	and	((pls_se_grupo_preco_material(nr_seq_grupo_material, nr_seq_material_p) = 'S') or (coalesce(nr_seq_grupo_material::text, '') = ''))
	and	((nr_seq_material	= nr_seq_material_p) or (coalesce(nr_seq_material::text, '') = ''))
	and	((nr_seq_contrato	= nr_seq_contrato_w) or (coalesce(nr_seq_contrato::text, '') = ''))
	and	((nr_seq_intercambio	= nr_seq_intercambio_w) or (coalesce(nr_seq_intercambio::text, '') = ''))
	and	((nr_seq_plano		= nr_seq_plano_w) or (coalesce(nr_seq_plano::text, '') = ''))
	and	((ie_tipo_guia		= ie_tipo_guia_p) or (coalesce(ie_tipo_guia::text, '') = ''))
	and	((nr_seq_pagador	= nr_seq_pagador_p) or (coalesce(nr_seq_pagador::text, '') = ''))
	and	((ie_cod_tuss		= ie_cod_tuss_w) or (ie_cod_tuss = 'A'))
	and	((ie_cod_simpro		= ie_cod_simpro_w) or (ie_cod_simpro = 'A'))
	and	((ie_cod_brasindice	= ie_cod_brasindice_w) or (coalesce(ie_cod_brasindice,'A') = 'A'))
	and	((ie_origem_analise	= ie_origem_analise_w) or (coalesce(ie_origem_analise::text, '') = ''))
	and	((ie_origem_protocolo	= ie_origem_protocolo_w) or (coalesce(ie_origem_protocolo::text, '') = ''))
	and	((ie_tipo_guia_princ	= ie_tipo_guia_princ_w)	or (coalesce(ie_tipo_guia_princ::text, '') = ''))
	and 	((pls_se_grupo_preco_contrato(nr_seq_grupo_contrato, nr_seq_contrato_w,null) = 'S') or (pls_se_grupo_preco_contrato(nr_seq_grupo_contrato, null, nr_seq_intercambio_w) = 'S') or (coalesce(nr_seq_grupo_contrato::text, '') = ''))
	and	((exists (SELECT	1
				from	pls_preco_grupo_prestador	a,
					pls_preco_prestador		b
				where	b.nr_seq_grupo		= a.nr_sequencia
				and	a.nr_sequencia		= nr_seq_grupo_prestador
				and	b.nr_seq_prestador	= nr_seq_prestador_p
				and	a.ie_situacao		= 'A')) or (coalesce(nr_seq_grupo_prestador::text, '') = ''))
	order by coalesce(nr_seq_material,0) desc,
		coalesce(nr_seq_estrutura_mat,0) desc,
		coalesce(ie_tipo_despesa,' ') desc,
		coalesce(nr_seq_plano,0) desc,
		coalesce(nr_seq_contrato,0) desc,
		coalesce(nr_seq_intercambio,0) desc,
		coalesce(nr_seq_pagador,0) desc,
		coalesce(ie_cod_tuss,' ') desc,
		coalesce(ie_cod_simpro,' ') desc,
		coalesce(ie_origem_analise,0) desc,
		coalesce(ie_origem_protocolo,' ') desc,
		coalesce(ie_tipo_guia_princ,' ') desc,
		coalesce(nr_seq_grupo_contrato,0) desc;

BEGIN

select	coalesce(max(ie_data_conv_mat_unimed), 'DA') -- (DA,DI)(Data atual,Data item)
into STRICT	ie_data_conv_mat_unimed_w
from	pls_parametro_faturamento
where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

select	max(a.ie_tipo_despesa),
	max(a.cd_material_ops),
	max(a.ds_material),
	substr(obter_dados_mat_tuss(max(a.nr_seq_tuss_mat_item),'C'),1,255),
	substr(obter_dados_mat_tuss(max(a.nr_seq_tuss_mat_item),'D'),1,255),
	substr(obter_dados_mat_tuss(max(a.nr_seq_tuss_mat_item),'A'),1,255),
	max(a.cd_simpro),
	substr(obter_desc_simpro(max(a.cd_simpro)),1,255),
	max(a.nr_sequencia),
	max(a.ds_versao_tiss),
	max(a.cd_tiss_brasindice),
	max(substr(pls_obter_desc_mat_bras_tiss(a.cd_tiss_brasindice), 1, 255))
into STRICT	ie_tipo_despesa_w,
	cd_material_ops_w,
	ds_material_ops_w,
	cd_material_tuss_w,
	ds_material_tuss_w,
	ds_apre_mat_tuss_w,
	cd_material_simpro_w,
	ds_material_simpro_w,
	nr_sequencia_w,
	nr_ver_tiss_w,
	cd_tiss_brasindice_w,
	ds_brasindice_w
from	pls_material a
where	a.nr_sequencia = nr_seq_material_p;

if	(ds_material_tuss_w IS NOT NULL AND ds_material_tuss_w::text <> '' AND ds_apre_mat_tuss_w IS NOT NULL AND ds_apre_mat_tuss_w::text <> '') then
	ds_material_tuss_w := substr(ds_material_tuss_w || ' - ' || ds_apre_mat_tuss_w, 1, 255);
end if;

ie_cod_tuss_w := 'S';
if (coalesce(cd_material_tuss_w::text, '') = '') then
	ie_cod_tuss_w := 'N';
end if;

ie_cod_simpro_w := 'S';
if (coalesce(cd_material_simpro_w::text, '') = '') then
	ie_cod_simpro_w := 'N';
end if;

if (coalesce(cd_tiss_brasindice_w::text, '') = '') then
	ie_cod_brasindice_w := 'N';
else
	ie_cod_brasindice_w := 'S';
end if;

select	max(nr_seq_contrato),
	max(nr_seq_intercambio),
	max(nr_seq_plano)
into STRICT	nr_seq_contrato_w,
	nr_seq_intercambio_w,
	nr_seq_plano_w
from	pls_segurado
where	nr_sequencia = nr_seq_segurado_p;

select	max(ie_origem_analise),
	max(cd_guia),
	max(nr_seq_prestador)
into STRICT	ie_origem_analise_w,
	cd_guia_w,
	nr_seq_prestador_princ_w
from	pls_analise_conta
where	nr_sequencia = nr_seq_analise_p;

select	max(a.ie_origem_protocolo),
	coalesce(cd_guia_w,max(b.cd_guia)),
	coalesce(nr_seq_prestador_princ_w,max(b.nr_seq_prestador)),
	max(coalesce(b.dt_atendimento,b.dt_atendimento_referencia))
into STRICT	ie_origem_protocolo_w,
	cd_guia_w,
	nr_seq_prestador_princ_w,
	dt_atendimento_referencia_w
from	pls_protocolo_conta a,
	pls_conta b
where	a.nr_sequencia = b.nr_seq_protocolo
and	b.nr_sequencia = nr_seq_conta_p;

nr_seq_conta_princ_w := pls_obter_conta_principal(	cd_guia_w, nr_seq_analise_p, nr_seq_segurado_p,
							nr_seq_prestador_princ_w);

select	max(ie_tipo_guia)
into STRICT	ie_tipo_guia_princ_w
from	pls_conta
where	nr_sequencia = nr_seq_conta_princ_w;

for r_c01_w in c01 loop

	cd_material_conv_w := r_c01_w.cd_material_conv;
	ds_material_conv_w := r_c01_w.ds_material_conv;
	cd_prefixo_w := r_c01_w.cd_prefixo;
	nr_seq_regra_w := r_c01_w.nr_sequencia;
	ie_regra_origem_w := r_c01_w.ie_regra_origem;
	cd_mascara_tuss_w := r_c01_w.cd_mascara_tuss;
	cd_mascara_simpro_w := r_c01_w.cd_mascara_simpro;
	cd_mascara_original_w := r_c01_w.cd_mascara_original;
	cd_mascara_conv_fat_w := r_c01_w.cd_mascara_conv_fat;
	cd_tab_item_w := r_c01_w.cd_tab_item;
	ie_agrupamento_w := r_c01_w.ie_agrupamento;
	cd_mascara_brasindice_w := r_c01_w.cd_mascara_brasindice;

	exit;
end loop;

-- Se a regra "OPS - Faturamento > Cadastros > Conversoes > Regra XML > Material > Conversao" estiver com "Cod/Descricao" e "Prefixo" em branco buscar informacoes em "OPS - Cadastro de Materiais > Materiais > Operadora > Dados operadora"
if (ie_regra_origem_w IS NOT NULL AND ie_regra_origem_w::text <> '') and (coalesce(cd_material_conv_w::text, '') = '') then
	if (coalesce(cd_mascara_original_w::text, '') = '') then
		cd_material_conv_w	:= cd_material_ops_w;
	else
		cd_material_conv_w	:= campo_mascara_cod_mat_xml_fat(cd_material_ops_w,cd_mascara_original_w);
	end if;
	ds_material_conv_w	:= ds_material_ops_w;

-- Se tem "Origem das informacoes" informada e tem "OPS - Faturamento > Cadastros > Conversoes > Regra XML > Material > Conversao" estiver com "Cod/Descricao" e "Prefixo" informado
elsif (ie_regra_origem_w IS NOT NULL AND ie_regra_origem_w::text <> '') and (cd_material_conv_w IS NOT NULL AND cd_material_conv_w::text <> '') then
	cd_material_conv_w	:= campo_mascara_cod_mat_xml_fat(cd_material_conv_w,cd_mascara_conv_fat_w);
end if;

-- "Origem das informacoes = SFO": Origem Simpro ou OPS - Faturamento ou OPS - Cadastro de Materiais
if (ie_regra_origem_w = 'SFO') then
	-- Busca valores de "Simpro" em "OPS - Cadastro de Materiais > Materiais > Operadora > Conversao"
	if (cd_material_simpro_w IS NOT NULL AND cd_material_simpro_w::text <> '') then
		if (coalesce(cd_mascara_simpro_w::text, '') = '') then
			cd_material_conv_w 	:= cd_material_simpro_w;
		else
			cd_material_conv_w	:= campo_mascara_cod_mat_xml_fat(cd_material_simpro_w,cd_mascara_simpro_w);
		end if;
		ds_material_conv_w	:= ds_material_simpro_w;
	end if;

-- "Origem das informacoes = TFO": Origem TUSS ou OPS - Faturamento ou OPS - Cadastro de Materiais
elsif (ie_regra_origem_w = 'TFO') then
	-- Busca valores de "TUSS" em "OPS - Cadastro de Materiais > Materiais > Operadora > Dados operadora"
	if (cd_material_tuss_w IS NOT NULL AND cd_material_tuss_w::text <> '') then
		if (coalesce(cd_mascara_tuss_w::text, '') = '') then
			cd_material_conv_w 	:= cd_material_tuss_w;
		else
			cd_material_conv_w	:= campo_mascara_cod_mat_xml_fat(cd_material_tuss_w,cd_mascara_tuss_w);
		end if;
		ds_material_conv_w	:= ds_material_tuss_w;
	end if;

-- "Origem das informacoes = TSFO": Origem TUSS ou Origem Simpro ou OPS - Faturamento ou OPS - Cadastro de Materiais
elsif (ie_regra_origem_w = 'TSFO') then
	-- Busca valores de "TUSS" em "OPS - Cadastro de Materiais > Materiais > Operadora > Dados operadora"
	if (cd_material_tuss_w IS NOT NULL AND cd_material_tuss_w::text <> '') then
		if (coalesce(cd_mascara_tuss_w::text, '') = '') then
			cd_material_conv_w	:= cd_material_tuss_w;
		else
			cd_material_conv_w	:= campo_mascara_cod_mat_xml_fat(cd_material_tuss_w,cd_mascara_tuss_w);
		end if;
		ds_material_conv_w	:= ds_material_tuss_w;
	-- Busca valores de "Simpro" em "OPS - Cadastro de Materiais > Materiais > Operadora > Conversao"
	elsif (cd_material_simpro_w IS NOT NULL AND cd_material_simpro_w::text <> '') then
		if (coalesce(cd_mascara_simpro_w::text, '') = '') then
			cd_material_conv_w	:= cd_material_simpro_w;
		else
			cd_material_conv_w	:= campo_mascara_cod_mat_xml_fat(cd_material_simpro_w,cd_mascara_simpro_w);
		end if;
		ds_material_conv_w	:= ds_material_simpro_w;
	end if;
	
-- "Origem das informacoes = TSBOF": Origem TUSS ou Origem Simpro ou Origem Brasindice ou OPS - Cadastro de Materiais - OPS - Faturamento
elsif (ie_regra_origem_w = 'TSBOF') then

	--  Busca valores de "TUSS" em "OPS - Cadastro de Materiais > Materiais > Operadora > Dados operadora"
	if (cd_material_tuss_w IS NOT NULL AND cd_material_tuss_w::text <> '') then
	
		-- verifica a mascara
		if (coalesce(cd_mascara_tuss_w::text, '') = '') then
		
			cd_material_conv_w	:= cd_material_tuss_w;
		else
		
			cd_material_conv_w	:= campo_mascara_cod_mat_xml_fat(cd_material_tuss_w,cd_mascara_tuss_w);
		end if;
		
		ds_material_conv_w	:= ds_material_tuss_w;
	
	-- Busca valores de "Simpro" em "OPS - Cadastro de Materiais > Materiais > Operadora > Conversao"
	elsif (cd_material_simpro_w IS NOT NULL AND cd_material_simpro_w::text <> '') then
	
		-- Verifica a mascara
		if (coalesce(cd_mascara_simpro_w::text, '') = '') then
		
			cd_material_conv_w	:= cd_material_simpro_w;
		else
		
			cd_material_conv_w	:= campo_mascara_cod_mat_xml_fat(cd_material_simpro_w,cd_mascara_simpro_w);
		end if;
		
		ds_material_conv_w	:= ds_material_simpro_w;
	
	-- Busca os valores de Brasindice
	elsif (cd_tiss_brasindice_w IS NOT NULL AND cd_tiss_brasindice_w::text <> '') then
	
		-- Verifica a mascara
		if (coalesce(cd_mascara_brasindice_w::text, '') = '') then
		
			cd_material_conv_w	:= cd_tiss_brasindice_w;
		else
		
			cd_material_conv_w	:= campo_mascara_cod_mat_xml_fat(cd_tiss_brasindice_w,cd_mascara_brasindice_w);
		end if;
		
		ds_material_conv_w	:= ds_brasindice_w;
	
	-- Busca os valores do cadastro de Materiais
	elsif (cd_material_conv_w IS NOT NULL AND cd_material_conv_w::text <> '') then
	
		-- verifica a mascara
		if (coalesce(cd_mascara_original_w::text, '') = '') then
		
			cd_material_conv_w	:= cd_material_ops_w;
		else
		
			cd_material_conv_w	:= campo_mascara_cod_mat_xml_fat(cd_material_ops_w,cd_mascara_original_w);
		end if;
		
		ds_material_conv_w	:= ds_material_ops_w;
	
	end if;

-- "Origem das informacoes = TSBOF": Origem TUSS ou Origem Brasindice ou Origem Simpro ou OPS - Cadastro de Materiais - OPS - Faturamento
elsif (ie_regra_origem_w = 'TBSOF') then

	--  Busca valores de "TUSS" em "OPS - Cadastro de Materiais > Materiais > Operadora > Dados operadora"
	if (cd_material_tuss_w IS NOT NULL AND cd_material_tuss_w::text <> '') then
	
		-- verifica a mascara
		if (coalesce(cd_mascara_tuss_w::text, '') = '') then
		
			cd_material_conv_w	:= cd_material_tuss_w;
		else
		
			cd_material_conv_w	:= campo_mascara_cod_mat_xml_fat(cd_material_tuss_w,cd_mascara_tuss_w);
		end if;
		
		ds_material_conv_w	:= ds_material_tuss_w;
		
	-- Busca os valores de Brasindice
	elsif (cd_tiss_brasindice_w IS NOT NULL AND cd_tiss_brasindice_w::text <> '') then
	
		-- Verifica a mascara
		if (coalesce(cd_mascara_brasindice_w::text, '') = '') then
		
			cd_material_conv_w	:= cd_tiss_brasindice_w;
		else
		
			cd_material_conv_w	:= campo_mascara_cod_mat_xml_fat(cd_tiss_brasindice_w,cd_mascara_brasindice_w);
		end if;
		
		ds_material_conv_w	:= ds_brasindice_w;
	
	-- Busca valores de "Simpro" em "OPS - Cadastro de Materiais > Materiais > Operadora > Conversao"
	elsif (cd_material_simpro_w IS NOT NULL AND cd_material_simpro_w::text <> '') then
	
		-- Verifica a mascara
		if (coalesce(cd_mascara_simpro_w::text, '') = '') then
		
			cd_material_conv_w	:= cd_material_simpro_w;
		else
		
			cd_material_conv_w	:= campo_mascara_cod_mat_xml_fat(cd_material_simpro_w,cd_mascara_simpro_w);
		end if;
		
		ds_material_conv_w	:= ds_material_simpro_w;
	
	-- Busca os valores do cadastro de Materiais
	elsif (cd_material_conv_w IS NOT NULL AND cd_material_conv_w::text <> '') then
	
		-- verifica a mascara
		if (coalesce(cd_mascara_original_w::text, '') = '') then
		
			cd_material_conv_w	:= cd_material_ops_w;
		else
		
			cd_material_conv_w	:= campo_mascara_cod_mat_xml_fat(cd_material_ops_w,cd_mascara_original_w);
		end if;
		
		ds_material_conv_w	:= ds_material_ops_w;
	
	end if;	

-- Origem das informacoes = TO": Origem TUSS ou OPS - Cadastro de Materiais
elsif (ie_regra_origem_w = 'TO') then
	-- Busca valores de "TUSS" em "OPS - Cadastro de Materiais > Materiais > Operadora > Dados operadora"
	if (cd_material_tuss_w IS NOT NULL AND cd_material_tuss_w::text <> '') then
		if (coalesce(cd_mascara_tuss_w::text, '') = '') then
			cd_material_conv_w 	:= cd_material_tuss_w;
		else
			cd_material_conv_w	:= campo_mascara_cod_mat_xml_fat(cd_material_tuss_w,cd_mascara_tuss_w);
		end if;
		ds_material_conv_w	:= ds_material_tuss_w;
	end if;
	
	-- Tratamento necessario visto que independente da regra selecionada a rotina busca o material cadastrado na regra, porem a regra 'TF' deve buscar apenas "Origem TUSS ou OPS - Cadastro de Materiais"

	-- Entao se nao houver cadastro em Origem TUSS ou OPS - Cadastro de Materiais nao deve ser enviado codigo/descricao.
	if (coalesce(cd_material_ops_w::text, '') = '') and (coalesce(cd_material_tuss_w::text, '') = '') then
		cd_material_conv_w	:= null;
		ds_material_conv_w	:= null;
	end if;

-- "Origem das informacoes = TOT": Origem TUSS ou OPS - Cadastro de Materiais ou TNUMM (A900)
elsif (ie_regra_origem_w = 'TOT') then
	-- Busca valores "A900" em "OPS - Cadastro de Materiais > Materiais Unimed > A900 > Materiais"
	select	max(cd_material_imp),
		max(ds_material_imp)
	into STRICT	cd_material_imp_w,
		ds_material_imp_w
	from	pls_conta_mat
	where	nr_sequencia	= nr_seq_conta_mat_p;
	
	begin
	cd_material_a900_w := (cd_material_imp_w)::numeric;
	exception
	when others then
		cd_material_a900_w := null;
	end;
	
	SELECT * FROM pls_obter_mat_a900_vigente(nr_sequencia_w, clock_timestamp(), cd_material_a900_w, nr_ver_tiss_w) INTO STRICT nr_sequencia_w, cd_material_a900_w;
	
	if (cd_material_a900_w IS NOT NULL AND cd_material_a900_w::text <> '') then
		cd_material_conv_w	:= cd_material_a900_w;
		ds_material_conv_w	:= substr(coalesce(trim(both ds_material_imp_w),pls_obter_dados_material_a900(cd_material_a900_w, null, 'NM')),1,255);
	end if;
	
	-- Busca valores de "TUSS" em "OPS - Cadastro de Materiais > Materiais > Operadora > Dados operadora"
	if (cd_material_tuss_w IS NOT NULL AND cd_material_tuss_w::text <> '') then
		if (coalesce(cd_mascara_tuss_w::text, '') = '') then
			cd_material_conv_w 	:= cd_material_tuss_w;
		else
			cd_material_conv_w	:= campo_mascara_cod_mat_xml_fat(cd_material_tuss_w,cd_mascara_tuss_w);
		end if;
		ds_material_conv_w	:= ds_material_tuss_w;
	end if;	
	
	-- Tratamento necessario visto que independente da regra selecionada a rotina busca o material cadastrado na regra, porem a regra 'TOT' deve buscar apenas "Origem TUSS ou OPS - Cadastro de Materiais ou TNUMM (A900)"

	-- Entao se nao houver cadastro em Origem TUSS ou OPS - Cadastro de Materiais ou TNUMM (A900) nao deve ser enviado codigo/descricao.
	if (coalesce(cd_material_a900_w::text, '') = '') and (coalesce(cd_material_tuss_w::text, '') = '') then
		cd_material_conv_w	:= null;
		ds_material_conv_w	:= null;
	end if;

-- "Origem das informacoes = T": TNUMM (A900)
elsif (ie_regra_origem_w = 'T') then	
	-- Busca valores "A900" em "OPS - Cadastro de Materiais > Materiais Unimed > A900 > Materiais"
	select	max(cd_material_imp),
		max(ds_material_imp)
	into STRICT	cd_material_imp_w,
		ds_material_imp_w
	from	pls_conta_mat
	where	nr_sequencia	= nr_seq_conta_mat_p;
	
	begin
	cd_material_a900_w := (cd_material_imp_w)::numeric;
	exception
	when others then
		cd_material_a900_w := null;
	end;
	
	SELECT * FROM pls_obter_mat_a900_vigente(nr_sequencia_w, clock_timestamp(), cd_material_a900_w, nr_ver_tiss_w) INTO STRICT nr_sequencia_w, cd_material_a900_w;
	
	if (cd_material_a900_w IS NOT NULL AND cd_material_a900_w::text <> '') then
		cd_material_conv_w	:= cd_material_a900_w;
		ds_material_conv_w	:= substr(coalesce(trim(both ds_material_imp_w),pls_obter_dados_material_a900(cd_material_a900_w, null, 'NM')),1,255);
	else
		cd_material_conv_w	:= null;
		ds_material_conv_w	:= null;
	end if;
	
-- "Origem das informacoes" nao esta informada e tem "OPS - Faturamento (Mascara)"
elsif (coalesce(ie_regra_origem_w::text, '') = '') and (cd_mascara_conv_fat_w IS NOT NULL AND cd_mascara_conv_fat_w::text <> '') then
	cd_material_conv_w	:= campo_mascara_cod_mat_xml_fat(cd_material_conv_w,cd_mascara_conv_fat_w);
end if;

cd_material_conv_p	:= cd_material_conv_w;
ds_material_conv_p	:= ds_material_conv_w;
cd_prefixo_p		:= cd_prefixo_w;
nr_seq_regra_p		:= nr_seq_regra_w;
cd_tab_item_p		:= cd_tab_item_w;
ie_agrupamento_p	:= coalesce(ie_agrupamento_w,'N');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_convert_mat_guia_xml_fat ( nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_material_p pls_material.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, ie_tipo_guia_p pls_conta.ie_tipo_guia%type, nr_seq_pagador_p pls_contrato_pagador.nr_sequencia%type, cd_material_conv_p INOUT pls_conv_mat_fat_xml.cd_material_conv%type, ds_material_conv_p INOUT pls_conv_mat_fat_xml.ds_material_conv%type, cd_prefixo_p INOUT pls_conv_mat_fat_xml.cd_prefixo%type, nr_seq_regra_p INOUT pls_conv_mat_fat_xml.nr_sequencia%type, cd_tab_item_p INOUT pls_conv_mat_fat_xml.cd_tab_item%type, ie_agrupamento_p INOUT pls_conv_mat_fat_xml.ie_agrupamento%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_prestador_p pls_prestador.nr_sequencia%type) FROM PUBLIC;
