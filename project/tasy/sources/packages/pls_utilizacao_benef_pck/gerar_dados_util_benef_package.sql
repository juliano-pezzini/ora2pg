-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_utilizacao_benef_pck.gerar_dados_util_benef ( param_util_p INOUT param_utilizacao_benef, regra_util_p INOUT regra_utilizacao_benef ) AS $body$
DECLARE

					
_ora2pg_r RECORD;
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Gera os dados para a utilizacao do beneficiario
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [ ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
Pontos de atencao:

	Essa rotina devera  chamar apenas as rotinas auxiliares, que serao responsaveis por levantar 
	as informacoes, tanto para o atendimento, como para os itens e tambem a atualizacao de informacoes
	complementares
	
	Nao devera ter a criacao de SQL dinamico aqui.	
	Nao devera ter a alteracao de parametros aqui.
	Nao devera ter a alteracao direta de dados aqui, apenas a chamada para as respectivas rotinas
	
Alteracoes:
-------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN

-- Gera os atendimentos
SELECT * FROM pls_utilizacao_benef_pck.gerar_atendimentos_util(param_util_p, regra_util_p) INTO STRICT _ora2pg_r;
 param_util_p := _ora2pg_r.param_util_p; regra_util_p := _ora2pg_r.regra_util_p;

-- Gera os itens do atendimento
SELECT * FROM pls_utilizacao_benef_pck.gerar_itens_util_benef(param_util_p, regra_util_p) INTO STRICT _ora2pg_r;
 param_util_p := _ora2pg_r.param_util_p; regra_util_p := _ora2pg_r.regra_util_p;

-- Gera o prestador e medico principal
SELECT * FROM pls_utilizacao_benef_pck.gera_prest_princ_util_benef(param_util_p, regra_util_p) INTO STRICT _ora2pg_r;
 param_util_p := _ora2pg_r.param_util_p; regra_util_p := _ora2pg_r.regra_util_p;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_utilizacao_benef_pck.gerar_dados_util_benef ( param_util_p INOUT param_utilizacao_benef, regra_util_p INOUT regra_utilizacao_benef ) FROM PUBLIC;