-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION calcula_escala_isi_md ( ie_dif_pegar_sono_p text, ie_dif_manter_sono_P text, ie_despertar_cedo_p text, ie_satisfacao_sono_p text, ie_interfere_ativ_p text, ie_percebe_qualidade_p text, ie_nivel_estres_p text ) RETURNS bigint AS $body$
BEGIN

  return campo_numerico_md(ie_dif_pegar_sono_p) +
         campo_numerico_md(ie_dif_manter_sono_P) +
         campo_numerico_md(ie_despertar_cedo_p) +
         campo_numerico_md(ie_satisfacao_sono_p) +
         campo_numerico_md(ie_interfere_ativ_p) +
         campo_numerico_md(ie_percebe_qualidade_p) +
         campo_numerico_md(ie_nivel_estres_p);
		
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION calcula_escala_isi_md ( ie_dif_pegar_sono_p text, ie_dif_manter_sono_P text, ie_despertar_cedo_p text, ie_satisfacao_sono_p text, ie_interfere_ativ_p text, ie_percebe_qualidade_p text, ie_nivel_estres_p text ) FROM PUBLIC;
