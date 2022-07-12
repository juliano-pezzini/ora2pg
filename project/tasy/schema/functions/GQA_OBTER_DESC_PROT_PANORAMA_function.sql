-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gqa_obter_desc_prot_panorama (nr_seq_protocolo_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w          varchar(4000) := null;

ds_protocolo        varchar(4000);
ds_etapa_atual      varchar(4000);
ds_info             varchar(4000);
qtd                 bigint;
lb                  varchar(4) := '<br>';


BEGIN
  select count(1) into STRICT qtd
  from gqa_protocolo_pac a
  where nr_sequencia = nr_seq_protocolo_p;

  if (qtd = 0) then
    return ds_retorno_w;
  end if;

  select
      a.ds_nome_protocolo,
      gqa_obter_protocolo_tag_atual(a.nr_sequencia, 'NOME'),
      to_char(a.dt_inclusao, 'dd/mm/yyyy hh24:mi:ss') ds
  into STRICT
      ds_protocolo,
      ds_etapa_atual,
      ds_info
  from gqa_protocolo_pac a 
  where nr_sequencia = nr_seq_protocolo_p;

  ds_retorno_w := '<strong>' || obter_desc_expressao(761566) || '</strong>: ' || ds_protocolo;

  if (ds_etapa_atual IS NOT NULL AND ds_etapa_atual::text <> '') then
    ds_retorno_w := ds_retorno_w || lb || ' <strong>' || obter_desc_expressao(328156) || '</strong>: ' || ds_etapa_atual;
  end if;

  if (ds_info IS NOT NULL AND ds_info::text <> '') then
    ds_retorno_w := ds_retorno_w || lb || ' <strong>' || obter_desc_expressao(703969) || '</strong>: ' || ds_info;
  end if;

  return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gqa_obter_desc_prot_panorama (nr_seq_protocolo_p bigint) FROM PUBLIC;

