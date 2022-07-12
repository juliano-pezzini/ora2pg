-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_score_stratify_md ( ie_queda_p text, ie_queda_6_meses_p text, ie_confuso_p text, ie_agitado_p text, ie_desorientado_p text, ie_oculos_p text, ie_visao_turva_p text, ie_glaucoma_p text, ie_alteracao_diurese_p text, ie_mobilidade_p bigint, ie_transferencia_p bigint ) RETURNS bigint AS $body$
DECLARE

  qt_historia_w		bigint := 0;
  qt_mental_w			bigint := 0;
  qt_visao_w			bigint := 0;
  qt_toilet_w			bigint := 0;
  qt_trans_mob_w	bigint := 0;

BEGIN
  if (ie_queda_p = 'S') then
    qt_historia_w	:=	1;
  end if;
  if (ie_queda_6_meses_p = 'S') then
    qt_historia_w	:=	1;	
  end if;

  if (ie_confuso_p = 'S') then
    qt_mental_w	:= 	1;
  end if;
  if (ie_agitado_p = 'S') then
    qt_mental_w	:=  1;
  end if;
  if (ie_desorientado_p = 'S') then
    qt_mental_w	:= 	1;
  end if;

  if (ie_oculos_p = 'S') then
    qt_visao_w	:=  1;
  end if;
  if (ie_visao_turva_p = 'S') then
    qt_visao_w	:=  1;
  end if;
  if (ie_glaucoma_p = 'S') then
    qt_visao_w	:=  1;
  end if;

  if (ie_alteracao_diurese_p = 'S') then
    qt_toilet_w	:=  1;
  end if;

  qt_trans_mob_w	:= 	ie_mobilidade_p + ie_transferencia_p;

  if (qt_trans_mob_w in (3,4,5,6)) then
    qt_trans_mob_w	:= 1;
  elsif (qt_trans_mob_w in (0,1,2)) then	
    qt_trans_mob_w	:= 0;
  end if;

  return(6 * qt_historia_w) + (14 * qt_mental_w) + (qt_visao_w) + (2 * qt_toilet_w) + (7 * qt_trans_mob_w);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_score_stratify_md ( ie_queda_p text, ie_queda_6_meses_p text, ie_confuso_p text, ie_agitado_p text, ie_desorientado_p text, ie_oculos_p text, ie_visao_turva_p text, ie_glaucoma_p text, ie_alteracao_diurese_p text, ie_mobilidade_p bigint, ie_transferencia_p bigint ) FROM PUBLIC;

