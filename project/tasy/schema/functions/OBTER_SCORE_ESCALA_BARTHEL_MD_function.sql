-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_score_escala_barthel_md ( ie_alimentacao_p bigint, ie_banho_p bigint, ie_cuidado_p bigint, ie_capacidade_p bigint, ie_intestinal_p bigint, ie_urinario_p bigint, ie_banheiro_p bigint, ie_transporte_p bigint, ie_mobilidade_p bigint, ie_escadas_p bigint ) RETURNS bigint AS $body$
BEGIN
    RETURN coalesce(ie_alimentacao_p, 0) + coalesce(ie_banho_p, 0) + coalesce(ie_cuidado_p, 0) + coalesce(ie_capacidade_p, 0) + coalesce(ie_intestinal_p, 0) +
           coalesce(ie_urinario_p, 0) + coalesce(ie_banheiro_p, 0) + coalesce(ie_transporte_p, 0) + coalesce(ie_mobilidade_p, 0) + coalesce(ie_escadas_p, 0);


END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_score_escala_barthel_md ( ie_alimentacao_p bigint, ie_banho_p bigint, ie_cuidado_p bigint, ie_capacidade_p bigint, ie_intestinal_p bigint, ie_urinario_p bigint, ie_banheiro_p bigint, ie_transporte_p bigint, ie_mobilidade_p bigint, ie_escadas_p bigint ) FROM PUBLIC;

