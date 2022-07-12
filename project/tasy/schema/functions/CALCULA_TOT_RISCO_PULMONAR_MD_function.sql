-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION calcula_tot_risco_pulmonar_md (qt_aneurisma_p bigint, qt_toracica_p bigint, qt_abnominal_alta_p bigint, qt_cabeca_pescoco_p bigint, qt_neurocirurgia_p bigint, qt_vascular_arterial_p bigint, qt_anestesia_geral_p bigint, qt_emergencia_p bigint, qt_transfusao_p bigint, qt_pontos_idade_p bigint, qt_status_funcional_p bigint, qt_diminuicao_peso_p bigint, qt_dpoc_p bigint, qt_acidente_vasc_cerebral_p bigint, qt_diminuicao_consciencia_p bigint, qt_pontos_ureia_p bigint, qt_corticoide_cronico_p bigint, qt_tabagismo_p bigint, qt_alcool_p bigint) RETURNS bigint AS $body$
BEGIN
  return coalesce(qt_aneurisma_p, 0) + coalesce(qt_toracica_p, 0) + coalesce(qt_abnominal_alta_p, 0) + coalesce(qt_cabeca_pescoco_p, 0) + coalesce(qt_neurocirurgia_p, 0) + coalesce(qt_vascular_arterial_p, 0) + coalesce(qt_anestesia_geral_p, 0) + coalesce(qt_emergencia_p, 0) + coalesce(qt_transfusao_p, 0) + coalesce(qt_pontos_idade_p, 0) + coalesce(qt_status_funcional_p, 0) + coalesce(qt_diminuicao_peso_p, 0) + coalesce(qt_dpoc_p, 0) + coalesce(qt_acidente_vasc_cerebral_p, 0) + coalesce(qt_diminuicao_consciencia_p, 0) + coalesce(qt_pontos_ureia_p, 0) + coalesce(qt_corticoide_cronico_p, 0) + coalesce(qt_tabagismo_p, 0) + coalesce(qt_alcool_p, 0);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION calcula_tot_risco_pulmonar_md (qt_aneurisma_p bigint, qt_toracica_p bigint, qt_abnominal_alta_p bigint, qt_cabeca_pescoco_p bigint, qt_neurocirurgia_p bigint, qt_vascular_arterial_p bigint, qt_anestesia_geral_p bigint, qt_emergencia_p bigint, qt_transfusao_p bigint, qt_pontos_idade_p bigint, qt_status_funcional_p bigint, qt_diminuicao_peso_p bigint, qt_dpoc_p bigint, qt_acidente_vasc_cerebral_p bigint, qt_diminuicao_consciencia_p bigint, qt_pontos_ureia_p bigint, qt_corticoide_cronico_p bigint, qt_tabagismo_p bigint, qt_alcool_p bigint) FROM PUBLIC;

