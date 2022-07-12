-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_smp_pck.gerar_precos ( regra_simulacao_p pls_smp_pck.regra_simulacao, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Gerar os precos de cada item
	
	Cada procedimento / material pode ter mais de uma regra de preco, com uma
	valorizacao diferente, as regras serao gravadas na tabela pls_smp_result_regra,
	e na pls_smp_result_item, sera listado o valor mais baixo.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
Pontos de atencao:
Alteracoes:
-------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN

-- Somente se possuir regra
if (regra_simulacao_p.nr_sequencia IS NOT NULL AND regra_simulacao_p.nr_sequencia::text <> '') then

	-- Gera a simulacao para os procedimentos
	CALL pls_smp_pck.gerar_precos_proc(	regra_simulacao_p,
				nm_usuario_p,
				cd_estabelecimento_p);
	
	-- Gera a simulacao para os Materiais
	CALL pls_smp_pck.gerar_precos_mat(	regra_simulacao_p,
				nm_usuario_p,
				cd_estabelecimento_p);
	-- Gerar a simulacao para servicos
	CALL pls_smp_pck.gerar_precos_servico(	regra_simulacao_p,
				nm_usuario_p,
				cd_estabelecimento_p);
end if; -- fim regra
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_smp_pck.gerar_precos ( regra_simulacao_p pls_smp_pck.regra_simulacao, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;