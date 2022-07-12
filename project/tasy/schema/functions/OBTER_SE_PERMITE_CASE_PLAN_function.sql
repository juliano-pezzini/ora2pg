-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_permite_case_plan () RETURNS varchar AS $body$
DECLARE


ie_permite_case_planejado_w varchar(1) := 'S';
cd_estabelecimento_w 		estabelecimento.cd_estabelecimento%type;
cd_perfil_w 				perfil.cd_perfil%type;

c_regra CURSOR FOR
    SELECT   1 ordem,
            coalesce(a.ie_case_futuro , 'S') IE_CASE_FUTURO 
    from     parametros_episodio a
    where    a.cd_estabelecimento = cd_estabelecimento_w
    and      a.cd_perfil = cd_perfil_w
    
union all

    SELECT   2 ordem, 
            coalesce(a.IE_CASE_FUTURO , 'S')
    from     parametros_episodio a
    where    coalesce(a.cd_estabelecimento::text, '') = ''
    and      a.cd_perfil = cd_perfil_w
    
union all

    select   3 ordem, 
            coalesce(a.IE_CASE_FUTURO , 'S')
    from     parametros_episodio a
    where    a.cd_estabelecimento = cd_estabelecimento_w
    and      coalesce(a.cd_perfil::text, '') = ''
    
union all

    select   4 ordem, 
            coalesce(a.IE_CASE_FUTURO , 'S')
    from     parametros_episodio a
    where    coalesce(a.cd_estabelecimento::text, '') = ''
    and      coalesce(a.cd_perfil::text, '') = ''
    order by ordem;

BEGIN

if (obter_uso_case = 'S') then
    cd_estabelecimento_w    := obter_estabelecimento_ativo;
    cd_perfil_w             := obter_perfil_ativo;

    for linha_regra in c_regra loop
        ie_permite_case_planejado_w := linha_regra.IE_CASE_FUTURO;
        exit;
    end loop;

end if;
return  ie_permite_case_planejado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_permite_case_plan () FROM PUBLIC;

