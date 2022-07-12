-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_score_escala_goldman_md (qt_idade_p bigint, ie_iam_p text, ie_galope_b3_p text, ie_distensao_p text, ie_estenose_p text, ie_disritmia_sinusal_p text, ie_disritmia_ventricular_p text, qt_pao2_p bigint, qt_paco2_p bigint, qt_potassio_p bigint, qt_hco3_p bigint, qt_ureia_p bigint, qt_creatinina_p bigint, ie_tgo_p text, ie_doenca_hepatica_p text, ie_pac_acamado_p text, ie_cir_abdominal_p text, ie_cir_toracica_p text, ie_cir_aortica_p text, ie_cir_emergencia_p text ) RETURNS bigint AS $body$
DECLARE


	qt_pontos_w	integer := 0;

BEGIN
	--- Inicio MD 1
	if (qt_idade_p > 70) then
		qt_pontos_w	:= qt_pontos_w + 5;
	end if;

	if (coalesce(ie_iam_p,'N') = 'S') then
		qt_pontos_w	:= qt_pontos_w + 10;
	end if;

	if (coalesce(ie_galope_b3_p,'N') = 'S') or (coalesce(ie_distensao_p,'N') = 'S') then
		qt_pontos_w	:= qt_pontos_w + 11;
	end if;
		
	if (coalesce(ie_estenose_p,'N') = 'S') then
		qt_pontos_w	:= qt_pontos_w + 3;
	end if;

	if (coalesce(ie_disritmia_sinusal_p,'N') = 'S') then
		qt_pontos_w	:= qt_pontos_w + 7;
	end if;

	if (coalesce(ie_disritmia_ventricular_p,'N') = 'S') then
		qt_pontos_w	:= qt_pontos_w + 7;
	end if;

	if (qt_pao2_p < 60) or (qt_paco2_p > 50) or (qt_potassio_p < 3) or (qt_hco3_p < 20) or (qt_ureia_p > 50) or (qt_creatinina_p > 3) or (coalesce(ie_tgo_p,'N') = 'S') or (coalesce(ie_doenca_hepatica_p,'N') = 'S') or (coalesce(ie_pac_acamado_p,'N') = 'S') then
		qt_pontos_w	:= qt_pontos_w + 3;
	end if;

	if (coalesce(ie_cir_abdominal_p,'N') = 'S') or (coalesce(ie_cir_toracica_p,'N') = 'S') or (coalesce(ie_cir_aortica_p,'N') = 'S') then
		qt_pontos_w	:= qt_pontos_w + 3;
	end if;
		
	if (coalesce(ie_cir_emergencia_p,'N') = 'S') then
		qt_pontos_w	:= qt_pontos_w + 4;
	end if;
	--- Fim MD 1
    RETURN coalesce(qt_pontos_w,0);
   
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_score_escala_goldman_md (qt_idade_p bigint, ie_iam_p text, ie_galope_b3_p text, ie_distensao_p text, ie_estenose_p text, ie_disritmia_sinusal_p text, ie_disritmia_ventricular_p text, qt_pao2_p bigint, qt_paco2_p bigint, qt_potassio_p bigint, qt_hco3_p bigint, qt_ureia_p bigint, qt_creatinina_p bigint, ie_tgo_p text, ie_doenca_hepatica_p text, ie_pac_acamado_p text, ie_cir_abdominal_p text, ie_cir_toracica_p text, ie_cir_aortica_p text, ie_cir_emergencia_p text ) FROM PUBLIC;

