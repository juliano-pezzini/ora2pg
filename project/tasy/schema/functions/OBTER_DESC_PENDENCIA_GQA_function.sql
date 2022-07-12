-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_pendencia_gqa (ie_tipo_pendencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_pendencia_w varchar(200);


BEGIN

  if (ie_tipo_pendencia_p = 1) then
     ds_pendencia_w := wheb_mensagem_pck.get_texto(367599); -- Diagnóstico
  elsif (ie_tipo_pendencia_p = 2) then
     ds_pendencia_w := wheb_mensagem_pck.get_texto(367604); -- Exames de laboratório
  elsif (ie_tipo_pendencia_p = 3) then
     ds_pendencia_w := wheb_mensagem_pck.get_texto(367606); -- Sinais vitais
  elsif (ie_tipo_pendencia_p = 4) then
     ds_pendencia_w := wheb_mensagem_pck.get_texto(367607); -- Escalas e índices
  elsif (ie_tipo_pendencia_p = 5) then
     ds_pendencia_w := wheb_mensagem_pck.get_texto(367608); -- Curativos
  elsif (ie_tipo_pendencia_p = 6) then
     ds_pendencia_w := wheb_mensagem_pck.get_texto(367609); -- Protocolos Assistenciais
  elsif (ie_tipo_pendencia_p = 7) then
     ds_pendencia_w := wheb_mensagem_pck.get_texto(367610); -- Eventos
  elsif (ie_tipo_pendencia_p = 8) then
     ds_pendencia_w := wheb_mensagem_pck.get_texto(367611); -- Classificação de risco
  elsif (ie_tipo_pendencia_p = 9) then
     ds_pendencia_w := wheb_mensagem_pck.get_texto(1060535); -- CIAP
  end if;

return ds_pendencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_pendencia_gqa (ie_tipo_pendencia_p bigint) FROM PUBLIC;
