-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION calcula_bishop_md (ie_dilatacao_p bigint, ie_efface_p bigint, ie_station_p bigint, ie_posicao_p bigint, ie_consistencia_p bigint) RETURNS bigint AS $body$
BEGIN
  return coalesce(ie_dilatacao_p, 0) + coalesce(ie_efface_p, 0) + coalesce(ie_station_p, 0) + coalesce(ie_posicao_p, 0) + coalesce(ie_consistencia_p, 0);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION calcula_bishop_md (ie_dilatacao_p bigint, ie_efface_p bigint, ie_station_p bigint, ie_posicao_p bigint, ie_consistencia_p bigint) FROM PUBLIC;

