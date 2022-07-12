-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gqa_obter_de_para_icones (ds_tipo_p text) RETURNS bigint AS $body$
DECLARE


ds_retorno_w          bigint := null;


BEGIN
  if (ds_tipo_p = 'AVC') then -- AVC (Acidente Vascular Cerebral)
    ds_retorno_w := 753;
  elsif (ds_tipo_p = 'CPA') then -- Cuidados Paliativos
    ds_retorno_w := 764;
  elsif (ds_tipo_p = 'DOR') then -- Dor Toracica
    ds_retorno_w := 763;
  elsif (ds_tipo_p = 'GLI') then -- Glicemia
    ds_retorno_w := 761;
  elsif (ds_tipo_p = 'IAM') then -- IAM (Infarto Agudo do Miocardio)
    ds_retorno_w := 759;
  elsif (ds_tipo_p = 'SEP') then -- Sepse
    ds_retorno_w := 760;
  elsif (ds_tipo_p = 'SUI') then -- Suicidio
    ds_retorno_w := 762;
  elsif (ds_tipo_p = 'TEV') then -- TEV (Tromboembolismo Venoso) Clinico e Cirurgico
    ds_retorno_w := 757;
  end if;

  return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gqa_obter_de_para_icones (ds_tipo_p text) FROM PUBLIC;

