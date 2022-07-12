-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


	-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>OBTER RESTRICOES PROCEDIMENTO<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--



CREATE OR REPLACE FUNCTION mprev_pop_alvo_pck.obter_restricao_proc (dados_regra_p mprev_pop_alvo_pck.regra_proc) RETURNS varchar AS $body$
DECLARE


	ds_retorno_w		varchar(4000)	:= null;
	ds_retorno_guia_w	varchar(4000)	:= null;

	
BEGIN

	--Bloco inicial do select

	ds_retorno_w := 	' and	x.dt_procedimento >= :dt_referencia_pc ';

	current_setting('mprev_pop_alvo_pck.bind_sql_w')::sql_pck.t_dado_bind := sql_pck.bind_variable(':dt_referencia_pc', current_setting('mprev_pop_alvo_pck.dt_referencia_w')::timestamp, current_setting('mprev_pop_alvo_pck.bind_sql_w')::sql_pck.t_dado_bind);

	--CD_PROCEDIMENTO

	if (dados_regra_p.cd_procedimento IS NOT NULL AND dados_regra_p.cd_procedimento::text <> '') then
		-- Aqui monta a restricao e atualiza o valor das binds.

		ds_retorno_w :=	ds_retorno_w || current_setting('mprev_pop_alvo_pck.enter_w')::pls_util_pck.enter_w%type ||
				' 	and 	x.cd_procedimento = :cd_procedimento_'||dados_regra_p.cd_procedimento||'_pc';

		current_setting('mprev_pop_alvo_pck.bind_sql_w')::sql_pck.t_dado_bind := sql_pck.bind_variable(':cd_procedimento_'||dados_regra_p.cd_procedimento||'_pc', dados_regra_p.cd_procedimento, current_setting('mprev_pop_alvo_pck.bind_sql_w')::sql_pck.t_dado_bind);
	end if;

	--IE_ORIGEM_PROCED

	if (dados_regra_p.ie_origem_proced IS NOT NULL AND dados_regra_p.ie_origem_proced::text <> '') then
		-- Aqui monta a restricao e atualiza o valor das binds.

		ds_retorno_w :=	ds_retorno_w || current_setting('mprev_pop_alvo_pck.enter_w')::pls_util_pck.enter_w%type ||
				'	and 	x.ie_origem_proced = :ie_origem_proced_'||dados_regra_p.ie_origem_proced||'_pc';

		current_setting('mprev_pop_alvo_pck.bind_sql_w')::sql_pck.t_dado_bind := sql_pck.bind_variable(':ie_origem_proced_'||dados_regra_p.ie_origem_proced||'_pc', dados_regra_p.ie_origem_proced, current_setting('mprev_pop_alvo_pck.bind_sql_w')::sql_pck.t_dado_bind);
	end if;

	--QT_OCORRENCIA

	ds_retorno_w :=	ds_retorno_w || current_setting('mprev_pop_alvo_pck.enter_w')::pls_util_pck.enter_w%type ||
				' group by benef.nr_sequencia ' || current_setting('mprev_pop_alvo_pck.enter_w')::pls_util_pck.enter_w%type || 
				' having count(x.nr_sequencia) >= nvl(:qt_ocorrencia_'||dados_regra_p.qt_ocorrencia||'_pc'||',1) ';

	current_setting('mprev_pop_alvo_pck.bind_sql_w')::sql_pck.t_dado_bind := sql_pck.bind_variable(':qt_ocorrencia_'||dados_regra_p.qt_ocorrencia||'_pc', dados_regra_p.qt_ocorrencia, current_setting('mprev_pop_alvo_pck.bind_sql_w')::sql_pck.t_dado_bind);

	return	ds_retorno_w;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION mprev_pop_alvo_pck.obter_restricao_proc (dados_regra_p mprev_pop_alvo_pck.regra_proc) FROM PUBLIC;
