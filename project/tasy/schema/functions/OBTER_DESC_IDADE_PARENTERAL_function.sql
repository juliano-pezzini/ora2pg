-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_idade_parenteral (nr_atendimento_p bigint, nr_seq_cpoe_dieta_p bigint) RETURNS varchar AS $body$
DECLARE

 
 
qt_idade_ano_w   cpoe_dieta.qt_idade_ano%Type;
qt_idade_mes_w   cpoe_dieta.qt_idade_mes%Type;
qt_idade_dia_w   cpoe_dieta.qt_idade_dia%Type;
ds_retorno_w    varchar(255);
ie_existe_w     varchar(1);

BEGIN
 
  select coalesce(max('S'),'N') ie_existe, 
      max(qt_idade_ano) qt_idade_ano, 
      max(qt_idade_mes) qt_idade_mes, 
      max(qt_idade_dia) qt_idade_dia 
  into STRICT  ie_existe_w, 
      qt_idade_ano_w, 
      qt_idade_mes_w, 
      qt_idade_dia_w 
  from  cpoe_dieta 
  where  nr_sequencia = nr_seq_cpoe_dieta_p;
 
  if (coalesce(qt_idade_ano_w::text, '') = '') and (coalesce(qt_idade_mes_w::text, '') = '') and (coalesce(qt_idade_dia_w::text, '') = '') then 
		ds_retorno_w := '';
	elsif (ie_existe_w = 'S') then 
    ds_retorno_w := substr(wheb_mensagem_pck.get_texto(341153, 'QT_IDADE_ANO_W=' || qt_idade_ano_w || ';QT_IDADE_MES_W=' || qt_idade_mes_w || ';QT_IDADE_DIA_W=' || qt_idade_dia_w),1,255);
  end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_idade_parenteral (nr_atendimento_p bigint, nr_seq_cpoe_dieta_p bigint) FROM PUBLIC;

