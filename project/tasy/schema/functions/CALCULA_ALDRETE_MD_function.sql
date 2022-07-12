-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION calcula_aldrete_md ( ie_atividade_p bigint, ie_respiracao_p bigint, ie_pressao_arterial_p bigint, ie_consciencia_p bigint, ie_coloracao_p bigint, ie_saturation_o2_p bigint ) RETURNS bigint AS $body$
BEGIN
  return coalesce(ie_atividade_p, 0) +
    coalesce(ie_respiracao_p, 0) + 
    coalesce(ie_pressao_arterial_p, 0) + 
    coalesce(ie_consciencia_p, 0) + 
    coalesce(ie_coloracao_p, 0) + 
    coalesce(ie_saturation_o2_p, 0);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION calcula_aldrete_md ( ie_atividade_p bigint, ie_respiracao_p bigint, ie_pressao_arterial_p bigint, ie_consciencia_p bigint, ie_coloracao_p bigint, ie_saturation_o2_p bigint ) FROM PUBLIC;
