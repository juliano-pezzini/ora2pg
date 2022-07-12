-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_score_escala_icdsc_md ( ie_nivel_consciencia_alt_p text, ie_desatencao_p text, ie_desorientacao_p text, ie_alucinacao_p text, ie_agitacao_p text, ie_fala_emo_inap_p text, ie_disturbio_sono_p text, ie_flutuacao_p text ) RETURNS bigint AS $body$
DECLARE

  qt_ponto_w smallint;

BEGIN
  if (ie_nivel_consciencia_alt_p = 'D') or (ie_nivel_consciencia_alt_p = 'E') then
	qt_ponto_w := null;
  else
	
    qt_ponto_w := 0;
	
	if (ie_nivel_consciencia_alt_p = 'A') or (ie_nivel_consciencia_alt_p = 'C') then
		qt_ponto_w := qt_ponto_w + 1;
	end if;
	
	if (ie_desatencao_p = 'S') then
		qt_ponto_w := qt_ponto_w + 1;
	end if;
	
	if (ie_desorientacao_p = 'S') then
		qt_ponto_w := qt_ponto_w + 1;
	end if;
	
	if (ie_alucinacao_p = 'S') then
		qt_ponto_w := qt_ponto_w + 1;
	end if;
	
	if (ie_agitacao_p = 'S') then
		qt_ponto_w := qt_ponto_w + 1;
	end if;
	
	if (ie_fala_emo_inap_p = 'S') then
		qt_ponto_w := qt_ponto_w + 1;
	end if;
	
	if (ie_disturbio_sono_p = 'S') then
		qt_ponto_w := qt_ponto_w + 1;
	end if;
	
	if (ie_flutuacao_p = 'S') then
		qt_ponto_w := qt_ponto_w + 1;
	end if;
  end if;

  return coalesce(qt_ponto_w,0);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_score_escala_icdsc_md ( ie_nivel_consciencia_alt_p text, ie_desatencao_p text, ie_desorientacao_p text, ie_alucinacao_p text, ie_agitacao_p text, ie_fala_emo_inap_p text, ie_disturbio_sono_p text, ie_flutuacao_p text ) FROM PUBLIC;
