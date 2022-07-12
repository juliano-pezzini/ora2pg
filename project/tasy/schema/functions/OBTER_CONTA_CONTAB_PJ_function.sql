-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_conta_contab_pj ( cd_empresa_p bigint, cd_estabelecimento_p bigint, cd_cgc_p text, ie_tipo_p text, dt_vigencia_p timestamp) RETURNS varchar AS $body$
DECLARE


cd_conta_contabil_w	varchar(40);


BEGIN

    begin
        select  cd_conta_contabil
        into STRICT    cd_conta_contabil_w
        from (
            SELECT  a.cd_conta_contabil
            from    pessoa_jur_conta_cont a
            where   a.cd_cgc = cd_cgc_p
            and     a.cd_empresa = cd_empresa_p
            and     a.ie_tipo_conta = ie_tipo_p
            and     coalesce(a.cd_estabelecimento, coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0)
            and (coalesce(dt_inicio_vigencia, dt_vigencia_p) <= dt_vigencia_p and coalesce(dt_fim_vigencia, dt_vigencia_p) >= dt_vigencia_p)
            order by    a.cd_estabelecimento nulls last,
                        a.dt_inicio_vigencia desc
        ) alias6 LIMIT 1;
    exception
        when no_data_found then
            cd_conta_contabil_w := '0';
    end;

    if (coalesce(cd_conta_contabil_w, '0') = '0') then
    	select	max(cd_conta_contabil)
    	into STRICT	cd_conta_contabil_w
    	from	pessoa_juridica
    	where	cd_cgc = cd_cgc_p;
    end if;

    return cd_conta_contabil_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_conta_contab_pj ( cd_empresa_p bigint, cd_estabelecimento_p bigint, cd_cgc_p text, ie_tipo_p text, dt_vigencia_p timestamp) FROM PUBLIC;

