-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_result_esc_sist_nut_md ( ie_dietoterapia_p text, ie_fator_risco_p text ) RETURNS varchar AS $body$
DECLARE

  ds_retorno_w varchar(100) := '';

BEGIN
  if (ie_dietoterapia_p IS NOT NULL AND ie_dietoterapia_p::text <> '')	and (ie_fator_risco_p IS NOT NULL AND ie_fator_risco_p::text <> '') then
    if (ie_dietoterapia_p = 'N') and (ie_fator_risco_p = 'N') then
      ds_retorno_w	:= wheb_mensagem_pck.get_texto(309302);
    elsif	((ie_dietoterapia_p = 'N') and (ie_fator_risco_p = 'S') or (ie_dietoterapia_p = 'S') and (ie_fator_risco_p = 'N')) then
      ds_retorno_w	:= wheb_mensagem_pck.get_texto(309301);
    elsif (ie_dietoterapia_p = 'S') and (ie_fator_risco_p = 'S') then
      ds_retorno_w	:= wheb_mensagem_pck.get_texto(309300);
    end if;
  end if;
  return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_result_esc_sist_nut_md ( ie_dietoterapia_p text, ie_fator_risco_p text ) FROM PUBLIC;
