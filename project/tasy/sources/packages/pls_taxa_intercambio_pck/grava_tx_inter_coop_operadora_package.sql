-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--  Considera as regras de intercambio cadastradas em OPS - Operadoras Congeneres e OPS - Cooperativas Medicas

--  Nao serao considerados os itens que ja encaixaram com alguma regra de intercambio na rotina grava_taxa_inter_contrato,

-- pois as regras definidas em OPS -Contratos de Intercambio\Intercambio\Regras sao prioritarias.




CREATE OR REPLACE PROCEDURE pls_taxa_intercambio_pck.grava_tx_inter_coop_operadora ( nr_seq_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_mat_p pls_conta_mat.nr_sequencia%type) AS $body$
DECLARE

dados_taxa_inter_w	dados_taxa_intercambio;
	
--Na tabela pls_aux_tx_inter, possui todo universo de contas envolvidas

--(e for requerido a obtencao da taxa de intercambio de um unico procedimento ou material, entao 

--tera a conta na qual esse item pertence, caso for informado protocolo, lote da conta etc, entao

--todas as contas envolvidas estarao nessa tabela, estara tambem a informacao do tipo de regra 

 --('CE' para operadoras congeneres e 'CO' para cooperativas medicas)

--que se aplica a essa conta e se a mesma e pagamento ou cobranca

C01 CURSOR FOR
	SELECT	distinct ie_tipo_regra
	from	pls_aux_tx_inter;

--Retorna os diferentes registros da tabela de regras de intercambio, 

--restringindo por ie_cobranca_pagamento e ie_tipo_ regra conforme a 

--tabela temporaria pls_aux_tx_inter.

C02 CURSOR(	ie_tipo_regra_pc		pls_aux_tx_inter.ie_tipo_regra%type)FOR
	SELECT 	regra.pr_taxa,
		regra.ie_tipo_data,
		regra.qt_dias_envio_taxa,
		regra.vl_taxa,
		regra.nr_sequencia,
		regra.ie_tipo_intercambio,
		regra.nr_seq_grupo_servico,
		regra.dt_inicio_vigencia,
		coalesce(regra.dt_fim_vigencia,clock_timestamp() + interval '1 days') dt_fim_vigencia,
		regra.nr_seq_plano,
		regra.ie_beneficio_obito,
		regra.ie_pcmso,
		regra.nr_seq_congenere,
		regra.nr_seq_grupo_coop_seg,
		regra.nr_seq_congenere_sup,
		regra.nr_seq_grupo_congenere,
		regra.nr_seq_regra_atend_cart,
		regra.nr_seq_grupo_rec,
		regra.ie_cobranca_pagamento,
		regra.ie_tipo_regra
	from 	pls_regra_intercambio regra
	where	regra.ie_cobranca_pagamento 	= 'P'
	and	regra.ie_tipo_regra		= ie_tipo_regra_pc
	and	coalesce(regra.nr_seq_intercambio::text, '') = ''
	order by				
		regra.dt_inicio_vigencia desc,
		coalesce(regra.nr_seq_grupo_servico, 0) desc,
		coalesce(regra.nr_seq_intercambio, 0) desc,
		coalesce(regra.nr_seq_plano,0) desc,
		coalesce(regra.nr_seq_congenere,0) desc,
		coalesce(regra.nr_seq_congenere_sup, 0) desc,
		coalesce(regra.nr_seq_grupo_coop_seg, 0) desc,
		coalesce(regra.nr_seq_grupo_congenere, 0) desc,
		coalesce(regra.ie_pcmso,'N') desc,
		coalesce(regra.ie_beneficio_obito, 'N') desc,
		coalesce(regra.ie_tipo_intercambio, 'A') desc,
		coalesce(regra.nr_seq_grupo_rec, 0) desc;
	
BEGIN
	--Percorre a tabela global temporaria  pls_aux_inter para obter os diferentes valores

	--de ie_tipo_regra e ie_pagamento_cobranca

	for r_C01_w in C01 loop

		--Percorre todas as regras restritas por ie_tipo_regra e ie_cobranca_pagamento definidos no primeiro cursor

		for r_C02_w in C02(r_C01_w.ie_tipo_regra) loop
			
			dados_taxa_inter_w.pr_taxa			:= r_C02_w.pr_taxa;
			dados_taxa_inter_w.ie_tipo_data			:= r_C02_w.ie_tipo_data;
			dados_taxa_inter_w.vl_taxa			:= r_C02_w.vl_taxa;
			dados_taxa_inter_w.nr_sequencia			:= r_C02_w.nr_sequencia;
			dados_taxa_inter_w.qt_dias_envio_taxa		:= r_C02_w.qt_dias_envio_taxa;
			dados_taxa_inter_w.ie_tipo_intercambio		:= r_C02_w.ie_tipo_intercambio;
			dados_taxa_inter_w.nr_seq_grupo_servico		:= r_C02_w.nr_seq_grupo_servico;
			dados_taxa_inter_w.dt_inicio_vigencia		:= r_C02_w.dt_inicio_vigencia;
			dados_taxa_inter_w.dt_fim_vigencia		:= r_C02_w.dt_fim_vigencia;
			dados_taxa_inter_w.nr_seq_plano			:= r_C02_w.nr_seq_plano;
			dados_taxa_inter_w.ie_beneficio_obito		:= r_C02_w.ie_beneficio_obito;
			dados_taxa_inter_w.ie_pcmso			:= r_C02_w.ie_pcmso;
			dados_taxa_inter_w.nr_seq_congenere		:= r_C02_w.nr_seq_congenere;
			dados_taxa_inter_w.nr_seq_grupo_coop_seg	:= r_C02_w.nr_seq_grupo_coop_seg;
			dados_taxa_inter_w.nr_seq_congenere_sup		:= r_C02_w.nr_seq_congenere_sup;
			dados_taxa_inter_w.nr_seq_grupo_congenere	:= r_C02_w.nr_seq_grupo_congenere;
			dados_taxa_inter_w.nr_seq_regra_atend_cart	:= r_C02_w.nr_seq_regra_atend_cart;
			dados_taxa_inter_w.nr_seq_grupo_rec		:= r_C02_w.nr_seq_grupo_rec;
			dados_taxa_inter_w.ie_cobranca_pagamento	:= r_C02_w.ie_cobranca_pagamento;
			dados_taxa_inter_w.ie_tipo_regra		:= r_C02_w.ie_tipo_regra;
			
			if (coalesce(nr_seq_mat_p::text, '') = '') then
				--Chama rotina onde sao encontrados os procedimentos elegiveis para a regra corrente. 				

				CALL pls_taxa_intercambio_pck.gravar_taxa_proc( nr_seq_proc_p, dados_taxa_inter_w);
			end if;
			
			if (coalesce(nr_seq_proc_p::text, '') = '') then
				--Chama rotina onde sao encontrados os materiais elegiveis para a regra corrente.

				CALL pls_taxa_intercambio_pck.gravar_taxa_mat(nr_seq_mat_p, dados_taxa_inter_w);
			end if;
		end loop;
			
	end loop;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_taxa_intercambio_pck.grava_tx_inter_coop_operadora ( nr_seq_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_mat_p pls_conta_mat.nr_sequencia%type) FROM PUBLIC;
