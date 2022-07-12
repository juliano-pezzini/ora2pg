-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_estres_e_fuji_atu_md (IE_VAR_TONUS_P bigint, IE_VAR_POSTURA_P bigint, IE_VAR_COLORACAO_P bigint, IE_BAT_ASA_NASAL_P bigint, IE_TIRAGEM_P bigint, IE_APNEIA_P bigint, IE_ACOMULO_SALIVA_P bigint, IE_TREMORES_LINGUA_P bigint, IE_SOLUCO_P bigint, IE_CHORO_P bigint ) RETURNS bigint AS $body$
DECLARE


  qt_total_estresse_w		bigint;
  ie_sinal_estresse_w		bigint;

BEGIN
  --- Inicio MD 1
  qt_total_estresse_w	:= coalesce(IE_VAR_TONUS_P,0)		 +
                         coalesce(IE_VAR_POSTURA_P,0)	     +
                         coalesce(IE_VAR_COLORACAO_P,0)	 +
                         coalesce(IE_BAT_ASA_NASAL_P,0)	 +
                         coalesce(IE_TIRAGEM_P,0)		     +
                         coalesce(IE_APNEIA_P,0)			 +
                         coalesce(IE_ACOMULO_SALIVA_P,0)	 +
                         coalesce(IE_TREMORES_LINGUA_P,0)  +
                         coalesce(IE_SOLUCO_P,0)			 +
                         coalesce(IE_CHORO_P,0);

  if (qt_total_estresse_w = 0) then
    ie_sinal_estresse_w := 2;
  elsif (qt_total_estresse_w <= 3) then
    ie_sinal_estresse_w := 1;
  elsif (qt_total_estresse_w > 3) then
    ie_sinal_estresse_w := 0;
  end if;
  --- Fim MD 1
  RETURN coalesce(ie_sinal_estresse_w,0);
    
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_estres_e_fuji_atu_md (IE_VAR_TONUS_P bigint, IE_VAR_POSTURA_P bigint, IE_VAR_COLORACAO_P bigint, IE_BAT_ASA_NASAL_P bigint, IE_TIRAGEM_P bigint, IE_APNEIA_P bigint, IE_ACOMULO_SALIVA_P bigint, IE_TREMORES_LINGUA_P bigint, IE_SOLUCO_P bigint, IE_CHORO_P bigint ) FROM PUBLIC;
