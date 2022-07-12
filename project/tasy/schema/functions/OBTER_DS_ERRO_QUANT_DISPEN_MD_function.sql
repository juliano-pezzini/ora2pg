-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ds_erro_quant_dispen_md (qt_max_pres_p bigint, qt_Dispensar_p bigint, cd_unid_med_p bigint ) RETURNS varchar AS $body$
DECLARE


  ds_erro_w varchar(4000) := null;

BEGIN
  if (qt_max_pres_p > 0) and (qt_Dispensar_p > qt_max_pres_p) then
    ds_erro_w	:= wheb_mensagem_pck.get_texto(278174, 'QT_MAX_PRES_P=' || qt_max_pres_p || ';CD_UNID_MED_P=' || cd_unid_med_p);
  end if;

  return ds_erro_w;
   
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ds_erro_quant_dispen_md (qt_max_pres_p bigint, qt_Dispensar_p bigint, cd_unid_med_p bigint ) FROM PUBLIC;
