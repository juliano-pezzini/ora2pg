-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qt_obter_mat_especifico_regra (cd_material_p material.cd_material%type, cd_convenio_p bigint, cd_pessoa_fisica_p regra_apresentacao_quimio.cd_pessoa_fisica%type, cd_estabelecimento_p bigint) RETURNS MATERIAL.CD_MATERIAL%TYPE AS $body$
DECLARE


c01 CURSOR FOR
SELECT  r.cd_material_especifico
from    regra_apresentacao_quimio r
where   r.ie_regra_aplicacao = 'P'
and     coalesce(ie_situacao, 'A') = 'A'
and     r.ie_regra = 'ME'
and     r.cd_material = cd_material_p
and (coalesce(r.cd_pessoa_fisica::text, '') = '' or r.cd_pessoa_fisica = cd_pessoa_fisica_p)
and (coalesce(r.dt_inicio_vigencia::text, '') = '' or clock_timestamp() >= inicio_dia(r.dt_inicio_vigencia))
and (coalesce(r.dt_fim_vigencia::text, '') = '' or clock_timestamp() <= fim_dia(r.dt_fim_vigencia))
and (coalesce(r.cd_estabelecimento::text, '') = '' or r.cd_estabelecimento = cd_estabelecimento_p)
and (coalesce(r.cd_convenio::text, '') = '' or r.cd_convenio = cd_convenio_p)
order by coalesce(r.cd_pessoa_fisica, 0),
    coalesce(r.cd_convenio, 0),
    coalesce(r.cd_estabelecimento, 0);

retorno_w material.cd_material%type;

BEGIN
    for item in c01 loop
        retorno_w := item.cd_material_especifico;
    end loop;

    return retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qt_obter_mat_especifico_regra (cd_material_p material.cd_material%type, cd_convenio_p bigint, cd_pessoa_fisica_p regra_apresentacao_quimio.cd_pessoa_fisica%type, cd_estabelecimento_p bigint) FROM PUBLIC;
