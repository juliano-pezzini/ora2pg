-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_smp_pck.gerar_simulacao ( nr_seq_simulacao_p pls_smp.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE



/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Gerar uma simulacao de precos conforme regras estabelecidas.

	Regras de geracao basicas para as tabelas de resultados
	Beneficiarios: sera copiado os beneficiarios cadastrados na regra de simulacao
	
	Prestadores: Para cada beneficiario, sera replicado todos os prestadores da
	simulacao, fazendo a ligacao com o campo nr_seq_smp_result_benef.
	
	Procedimentos / Materiais: Para cada prestadpr, sera replicado todos os
	procedimentos e materiais informado nas regras de simulacao. A tabela de
	resultado e a pls_smp_result_item, que tera a ligacao com o prestador na 
	nr_seq_smp_result_prest.
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
nr_seq_simulacao_w	pls_smp.nr_sequencia%type;
regra_simulacao_w	pls_smp_pck.regra_simulacao;


BEGIN
nr_seq_simulacao_w	:= nr_seq_simulacao_p;

if (nr_seq_simulacao_w IS NOT NULL AND nr_seq_simulacao_w::text <> '') then

	-- primeiramente desfaz a simulacao
	CALL pls_smp_pck.desfazer_simulacao(nr_seq_simulacao_w);
	commit;
	
	-- carrega os dados da regra
	select	nr_sequencia,
		dt_referencia,
		ie_regra_preco,
		coalesce(pr_inflator_deflator,0)
	into STRICT	regra_simulacao_w.nr_sequencia,
		regra_simulacao_w.dt_referencia,
		regra_simulacao_w.ie_regra_preco,
		regra_simulacao_w.pr_inflator_deflator
	from	pls_smp
	where	nr_sequencia	= nr_seq_simulacao_w  LIMIT 1;

	CALL pls_smp_pck.valida_simulacao(regra_simulacao_w);
	
	-- gerar os dados basicos
	CALL CALL pls_smp_pck.gerar_beneficiario(regra_simulacao_w, nm_usuario_p);
	CALL CALL pls_smp_pck.gerar_prestador(regra_simulacao_w, nm_usuario_p);
	CALL pls_smp_pck.gerar_itens(regra_simulacao_w, nm_usuario_p);
	
	-- Gerar os precos conforme a simulacao
	CALL pls_smp_pck.gerar_precos(	regra_simulacao_w,
			nm_usuario_p,
			cd_estabelecimento_p);
			
	-- utiliza os menores precos encontrados para cada item
	CALL pls_smp_pck.utilizar_menor_valor_regra(regra_simulacao_w);
	-- atualiza os valores dos prestadores
	CALL pls_smp_pck.atualiza_valores_prest(regra_simulacao_w);
	
	CALL pls_smp_pck.finalizar_geracao_simulacao(regra_simulacao_w);
end if; --  nr_seq_simulacao_w is not null
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_smp_pck.gerar_simulacao ( nr_seq_simulacao_p pls_smp.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
