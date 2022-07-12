-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



	-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>OBTER RESTRICOES COMPLEMENTO PESSOA<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--



CREATE OR REPLACE FUNCTION mprev_pop_alvo_pck.obter_restricao_compl_pf (dados_regra_p mprev_pop_alvo_pck.table_regra_compl_pf) RETURNS varchar AS $body$
DECLARE


	ds_retorno_w		varchar(4000)	:= null;

	
BEGIN

	--Codigo municipio IBGE

	if (dados_regra_p.cd_municipio_ibge IS NOT NULL AND dados_regra_p.cd_municipio_ibge::text <> '') then
		-- Aqui monta o select com as restricoes

		ds_retorno_w :=	ds_retorno_w || current_setting('mprev_pop_alvo_pck.enter_w')::pls_util_pck.enter_w%type ||
				'and	compl.cd_municipio_ibge = :cd_municipio_ibge_pc';
		-- Aqui adiciona o valor da bild variable

		current_setting('mprev_pop_alvo_pck.bind_sql_w')::sql_pck.t_dado_bind := sql_pck.bind_variable(':cd_municipio_ibge_pc', dados_regra_p.cd_municipio_ibge, current_setting('mprev_pop_alvo_pck.bind_sql_w')::sql_pck.t_dado_bind);
	end if;

  --Estado

	if ((dados_regra_p.sg_estado IS NOT NULL AND dados_regra_p.sg_estado::text <> '') and coalesce(dados_regra_p.cd_municipio_ibge::text, '') = '') then
		-- Aqui monta o select com as restricoessanta catarina

		ds_retorno_w :=	ds_retorno_w || current_setting('mprev_pop_alvo_pck.enter_w')::pls_util_pck.enter_w%type ||
				'and	compl.sg_estado = :sg_estado_pc';
		-- Aqui adiciona o valor da bild variable

		current_setting('mprev_pop_alvo_pck.bind_sql_w')::sql_pck.t_dado_bind := sql_pck.bind_variable(':sg_estado_pc', dados_regra_p.sg_estado, current_setting('mprev_pop_alvo_pck.bind_sql_w')::sql_pck.t_dado_bind);
	end if;

	--Tipo de complemento do endereco do cadastro de enderecos da pessoa.

	if (dados_regra_p.ie_tipo_complemento IS NOT NULL AND dados_regra_p.ie_tipo_complemento::text <> '') then
		-- Aqui monta o select com as restricoes

		ds_retorno_w :=	ds_retorno_w || current_setting('mprev_pop_alvo_pck.enter_w')::pls_util_pck.enter_w%type ||
				'and	compl.ie_tipo_complemento = :ie_tipo_complemento_pc';
		-- Aqui adiciona o valor da bild variable

		current_setting('mprev_pop_alvo_pck.bind_sql_w')::sql_pck.t_dado_bind := sql_pck.bind_variable(':ie_tipo_complemento_pc', dados_regra_p.ie_tipo_complemento, current_setting('mprev_pop_alvo_pck.bind_sql_w')::sql_pck.t_dado_bind);
	end if;

	return	ds_retorno_w;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION mprev_pop_alvo_pck.obter_restricao_compl_pf (dados_regra_p mprev_pop_alvo_pck.table_regra_compl_pf) FROM PUBLIC;
