-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_emergency_info_jpn (nr_atendimento_p bigint, ie_info_type_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w   varchar(255);
DS_CONDICAO_ALTA_w varchar(255);
DS_STAT_RESULTADO_w varchar(255);

BEGIN

/*
M - Motive
R - Result
*/
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '' AND ie_info_type_p IS NOT NULL AND ie_info_type_p::text <> '') then
select substr(obter_desc_motivo_alta(max(cd_motivo_alta)),1,80),
       CASE WHEN max(IE_DESFECHO)='I' THEN obter_desc_expressao(341198,null) WHEN max(IE_DESFECHO)='T' THEN obter_desc_expressao(487527,null) WHEN max(IE_DESFECHO)='A' THEN obter_desc_expressao(283375,null) END
       into STRICT DS_CONDICAO_ALTA_w,
       DS_STAT_RESULTADO_w
       from atendimento_alta
       where nr_atendimento = nr_atendimento_p;
end if;

if ( ie_info_type_p = 'M') then
ds_retorno_w := DS_CONDICAO_ALTA_w;
elsif ( ie_info_type_p = 'R')  then
ds_retorno_w := DS_STAT_RESULTADO_w;
end if;

RETURN ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_emergency_info_jpn (nr_atendimento_p bigint, ie_info_type_p text) FROM PUBLIC;

