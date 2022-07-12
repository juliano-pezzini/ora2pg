-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_evento_painel ( DT_ANALISE_P timestamp, DT_CHEGADA_P timestamp, DT_PAC_AGUARDO_P timestamp, DT_ALTA_P timestamp, DT_PRE_INDUC_P timestamp, DT_SALA_REC_P timestamp, DT_CHEGADA_FIM_P timestamp, DT_SAIDA_CC_P timestamp, DT_CANCELAMENTO_P timestamp, IE_STATUS_AGENDA text) RETURNS timestamp AS $body$
DECLARE


dt_retorno_w	timestamp;


BEGIN

if (IE_STATUS_AGENDA = 'C') then
	dt_retorno_w := DT_CANCELAMENTO_P;
elsif (DT_SAIDA_CC_P IS NOT NULL AND DT_SAIDA_CC_P::text <> '') then
	dt_retorno_w := DT_SAIDA_CC_P;
elsif (DT_ALTA_P IS NOT NULL AND DT_ALTA_P::text <> '') then
	dt_retorno_w := DT_ALTA_P;
elsif (DT_SALA_REC_P IS NOT NULL AND DT_SALA_REC_P::text <> '') then
	dt_retorno_w := DT_SALA_REC_P;
elsif (DT_CHEGADA_FIM_P IS NOT NULL AND DT_CHEGADA_FIM_P::text <> '') then
	dt_retorno_w := DT_CHEGADA_FIM_P;
elsif (DT_PRE_INDUC_P IS NOT NULL AND DT_PRE_INDUC_P::text <> '') then
	dt_retorno_w := DT_PRE_INDUC_P;
elsif (DT_PAC_AGUARDO_P IS NOT NULL AND DT_PAC_AGUARDO_P::text <> '') then
	dt_retorno_w := DT_PAC_AGUARDO_P;
elsif (DT_CHEGADA_P IS NOT NULL AND DT_CHEGADA_P::text <> '') then
	dt_retorno_w := DT_CHEGADA_P;
elsif (DT_ANALISE_P IS NOT NULL AND DT_ANALISE_P::text <> '') then
	dt_retorno_w := DT_ANALISE_P;
end if;

RETURN	dt_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_evento_painel ( DT_ANALISE_P timestamp, DT_CHEGADA_P timestamp, DT_PAC_AGUARDO_P timestamp, DT_ALTA_P timestamp, DT_PRE_INDUC_P timestamp, DT_SALA_REC_P timestamp, DT_CHEGADA_FIM_P timestamp, DT_SAIDA_CC_P timestamp, DT_CANCELAMENTO_P timestamp, IE_STATUS_AGENDA text) FROM PUBLIC;

