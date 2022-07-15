-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_score_escala_possum_9_md ( ie_vigor_p bigint, ie_energia_p bigint, ie_esgotado_p bigint, ie_cansado_p bigint, ie_nervosa_p bigint, ie_deprimido_p bigint, ie_calmo_p bigint, ie_desanimado_p bigint, ie_feliz_p bigint, qt_questao_9_vitalidade_p INOUT bigint, qt_questao_9_saude_mental_p INOUT bigint ) AS $body$
BEGIN

	qt_questao_9_vitalidade_p := coalesce(ie_vigor_p, 0) + coalesce(ie_energia_p, 0) + coalesce(ie_esgotado_p, 0) +  coalesce(ie_cansado_p, 0);

	qt_questao_9_saude_mental_p	:= coalesce(ie_nervosa_p, 0) + coalesce(ie_deprimido_p, 0) + coalesce(ie_calmo_p, 0) + coalesce(ie_desanimado_p, 0) + coalesce(ie_feliz_p, 0);
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_score_escala_possum_9_md ( ie_vigor_p bigint, ie_energia_p bigint, ie_esgotado_p bigint, ie_cansado_p bigint, ie_nervosa_p bigint, ie_deprimido_p bigint, ie_calmo_p bigint, ie_desanimado_p bigint, ie_feliz_p bigint, qt_questao_9_vitalidade_p INOUT bigint, qt_questao_9_saude_mental_p INOUT bigint ) FROM PUBLIC;

