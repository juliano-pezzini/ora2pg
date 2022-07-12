-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ptu_aviso_pck.gera_sql_arq_a520 ( dados_a520_p dados_lote_a520_t, alias_p alias_a520_t, dados_gerais_a520_p dados_gerais_a520_t, dados_bind_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Gera o SQL para a carga inicial do A520.

		Neste caso e feito um agrupamento conforme o processo da geracao (manual ou webservice).
		
		Apenas os arquivo (contendo varios protocolos) ou protocolos serao gerados nesta query, via regra de negocio
		algumas subrotina serao reaproveitadas, como por exemplo, os filtros adicionais e exececoes, portanto e utilizado
		o record com os alias, para manter a coerencia na montagem
		
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

ds_sql_w	varchar(32000);


BEGIN

-- monta a query

dados_bind_p := ptu_aviso_pck.gera_sql_arq_a520_select(dados_a520_p, alias_p, dados_gerais_a520_p, dados_bind_p);


return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ptu_aviso_pck.gera_sql_arq_a520 ( dados_a520_p dados_lote_a520_t, alias_p alias_a520_t, dados_gerais_a520_p dados_gerais_a520_t, dados_bind_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;