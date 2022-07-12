-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ds_tempo_leite_mater_md (qt_dietas_p bigint, cont_p bigint, cd_funcao_p bigint, ie_prescr_atual_p text) RETURNS varchar AS $body$
DECLARE


  ds_tempo_w varchar(4000);


BEGIN

  if (qt_dietas_p > 0) and
     ((cont_p = qt_dietas_p) or ((cont_p + 1) > qt_dietas_p)) and (cd_funcao_p <> 2314) then
    if (cd_funcao_p = 950) then
      ds_tempo_w := lower(wheb_mensagem_pck.get_texto(307506));
    elsif (ie_prescr_atual_p = 'N') then
      ds_tempo_w := lower(wheb_mensagem_pck.get_texto(307505));
    else
      ds_tempo_w := lower(wheb_mensagem_pck.get_texto(307503));
    end if;

  end if;

  return ds_tempo_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ds_tempo_leite_mater_md (qt_dietas_p bigint, cont_p bigint, cd_funcao_p bigint, ie_prescr_atual_p text) FROM PUBLIC;

