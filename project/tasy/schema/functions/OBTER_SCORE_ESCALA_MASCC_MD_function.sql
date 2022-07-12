-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_score_escala_mascc_md (ie_sintoma_p bigint, qt_pas_p bigint, ie_bronquite_p text, ie_onco_hematologica_p text, ie_hidratacao_endo_p text, ie_febre_p text, qt_idade_p bigint ) RETURNS bigint AS $body$
DECLARE


   qt_pontos_w	bigint;

BEGIN
	qt_pontos_w	:= coalesce(qt_pontos_w,0) + coalesce(ie_sintoma_p,0);

	if (coalesce(qt_pas_p,0) >= 90)	then
		qt_pontos_w	:= qt_pontos_w + 5;
	end if;

	if (coalesce(ie_bronquite_p,'N') = 'N')	then
		qt_pontos_w	:= qt_pontos_w + 4;
	end if;

	if (coalesce(ie_onco_hematologica_p,'N') = 'N')	then
		qt_pontos_w	:= qt_pontos_w + 4;
	end if;

	if (coalesce(ie_hidratacao_endo_p,'N') = 'N')	then
		qt_pontos_w	:= qt_pontos_w + 3;
	end if;

	if (coalesce(ie_febre_p,'N') = 'S')	then
		qt_pontos_w	:= qt_pontos_w + 3;
	end if;

	if (qt_idade_p < 60)	then
		qt_pontos_w	:= qt_pontos_w + 2;
	end if;

  return coalesce(qt_pontos_w,0);
   
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_score_escala_mascc_md (ie_sintoma_p bigint, qt_pas_p bigint, ie_bronquite_p text, ie_onco_hematologica_p text, ie_hidratacao_endo_p text, ie_febre_p text, qt_idade_p bigint ) FROM PUBLIC;

