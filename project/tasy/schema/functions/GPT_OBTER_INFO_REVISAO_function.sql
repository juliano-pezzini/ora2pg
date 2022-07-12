-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gpt_obter_info_revisao (nr_atendimento_p bigint, cd_pessoa_fisica_p text, ie_opcao_p text default 'P') RETURNS varchar AS $body$
DECLARE


nr_prescricao_w				prescr_medica.nr_prescricao%type;
nm_usuario_analise_enf_w	prescr_medica_compl.nm_usuario_analise_enf%type;
dt_inicio_analise_enf_w		varchar(40);
ds_retorno_w		varchar(254);
				

BEGIN

select 	max(nm_usuario_revisao),
        max(to_char(dt_revisao,'dd/mm/yyyy hh24:mi:ss'))
into STRICT	nm_usuario_analise_enf_w,
        dt_inicio_analise_enf_w
from ( SELECT  nm_usuario_revisao,
                 dt_revisao
          from   table(gpt_utils_pck.get_rev_prescr_plan( nr_atendimento_p,
                                                          cd_pessoa_fisica_p,
                                                          'N'))
      order by dt_revisao desc) alias5 LIMIT 1;

if (ie_opcao_p = 'U') and (nm_usuario_analise_enf_w IS NOT NULL AND nm_usuario_analise_enf_w::text <> '') then

    ds_retorno_w	:= substr(obter_nome_usuario(nm_usuario_analise_enf_w),1,254);

elsif (ie_opcao_p = 'D') and (dt_inicio_analise_enf_w IS NOT NULL AND dt_inicio_analise_enf_w::text <> '') then

    ds_retorno_w	:= dt_inicio_analise_enf_w; --PKG_DATE_UTILS.get_DateTime(dt_inicio_analise_enf_w,dt_inicio_analise_enf_w);
elsif (ie_opcao_p = 'P') then

    ds_retorno_w	:= nr_prescricao_w;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gpt_obter_info_revisao (nr_atendimento_p bigint, cd_pessoa_fisica_p text, ie_opcao_p text default 'P') FROM PUBLIC;
