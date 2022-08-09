-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_score_ris_card_risco_md ( ie_fat_diabete_p text, ie_fat_extra_sistoles_p text, ie_fat_onda_q_p text, ie_fat_angina_p text, ie_fat_hist_iam_p text, ie_fat_hist_icc_p text, ie_fat_hipertensao_p text, ie_idade_maior_70_p text, qt_risco_p INOUT bigint ) AS $body$
DECLARE

	qt_fator_risco_w smallint := 0;

BEGIN
	
	if (ie_fat_diabete_p = 'S') then
	  qt_fator_risco_w := qt_fator_risco_w + 1;
	end if;
	
	if (ie_fat_extra_sistoles_p = 'S') then
	  qt_fator_risco_w := qt_fator_risco_w + 1;
	end if;
	
	if (ie_fat_onda_q_p = 'S') then
	  qt_fator_risco_w := qt_fator_risco_w + 1;
	end if;
	
	if (ie_fat_angina_p = 'S') then
	  qt_fator_risco_w := qt_fator_risco_w + 1;
	end if;
	
	if (ie_fat_hist_iam_p = 'S') then
	  qt_fator_risco_w := qt_fator_risco_w + 1;
	end if;
	
	if (ie_fat_hist_icc_p = 'S') then
	  qt_fator_risco_w := qt_fator_risco_w + 1;
	end if;
	
	if (ie_fat_hipertensao_p = 'S') then
	  qt_fator_risco_w := qt_fator_risco_w + 1;
	end if;
	
	if (ie_idade_maior_70_p = 'S') then
	  qt_fator_risco_w := qt_fator_risco_w + 1;
	end if;
	
	qt_risco_p := qt_fator_risco_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_score_ris_card_risco_md ( ie_fat_diabete_p text, ie_fat_extra_sistoles_p text, ie_fat_onda_q_p text, ie_fat_angina_p text, ie_fat_hist_iam_p text, ie_fat_hist_icc_p text, ie_fat_hipertensao_p text, ie_idade_maior_70_p text, qt_risco_p INOUT bigint ) FROM PUBLIC;
