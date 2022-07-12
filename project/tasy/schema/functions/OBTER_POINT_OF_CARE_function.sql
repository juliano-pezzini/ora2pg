-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_point_of_care ( CD_SETOR_ATENDIMENTO_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text) RETURNS varchar AS $body$
DECLARE

ds_setor_atendimento_w    varchar(200);

BEGIN
 
if (CD_SETOR_ATENDIMENTO_p IS NOT NULL AND CD_SETOR_ATENDIMENTO_p::text <> '') and (cd_unidade_basica_p IS NOT NULL AND cd_unidade_basica_p::text <> '') and (cd_unidade_compl_p IS NOT NULL AND cd_unidade_compl_p::text <> '') then 
    select    max(coalesce(coalesce(NM_SETOR_INTEGRACAO, SUBSTR(obter_dados_setor(cd_setor_atendimento_p,'NC'),1,255)),
                                               SUBSTR(obter_dados_setor(cd_setor_atendimento_p,'DS'),1,255)))
    into STRICT    ds_setor_atendimento_w
    from    unidade_atendimento 
    where    cd_setor_atendimento    = CD_SETOR_ATENDIMENTO_p 
    and      cd_unidade_basica       = cd_unidade_basica_p 
    and      cd_unidade_compl        = cd_unidade_compl_p;
end if;
  
return    ds_setor_atendimento_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_point_of_care ( CD_SETOR_ATENDIMENTO_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text) FROM PUBLIC;
