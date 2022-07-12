-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_name_field_desc () RETURNS varchar AS $body$
DECLARE


ie_possui_w         varchar(15) := '0';
ie_data_exist_w     varchar(1);
dt_new_initial_w    timestamp;
dt_new_final_w      timestamp;

ds_return_w         dic_objeto.ds_sql%type;
cd_exp_1n_w         REGRA_NOME_CAMPO_PF.NR_SEQ_PRIMEIRO_NOME%type;
cd_exp_2n_w         REGRA_NOME_CAMPO_PF.NR_SEQ_PRIMEIRO_NOME%type;
cd_exp_3n_w         REGRA_NOME_CAMPO_PF.NR_SEQ_PRIMEIRO_NOME%type;
cd_exp_4n_w         REGRA_NOME_CAMPO_PF.NR_SEQ_PRIMEIRO_NOME%type;
cd_establishment_w  estabelecimento.CD_ESTABELECIMENTO%type;
cd_profile_w         perfil.CD_PERFIL%type;



BEGIN
    cd_establishment_w := obter_estabelecimento_ativo;
    cd_profile_w       := obter_perfil_ativo;

    select  max(NR_SEQ_PRIMEIRO_NOME),
            max(NR_SEQ_SEGUNDO_NOME),
            max(NR_SEQ_TERCEIRO_NOME),
            max(NR_SEQ_QUARTO_NOME)
    into STRICT    cd_exp_1n_w,
            cd_exp_2n_w,
            cd_exp_3n_w,
            cd_exp_4n_w
    from    REGRA_NOME_CAMPO_PF
    where   IE_SITUACAO = 'A' and CD_ESTABELECIMENTO = cd_establishment_w and cd_perfil = cd_profile_w;

    if (coalesce(cd_exp_1n_w::text, '') = '' or coalesce(cd_exp_2n_w::text, '') = '' or coalesce(cd_exp_3n_w::text, '') = '' or coalesce(cd_exp_4n_w::text, '') = '') then
        select  coalesce(cd_exp_1n_w, max(NR_SEQ_PRIMEIRO_NOME)),
                coalesce(cd_exp_2n_w, max(NR_SEQ_SEGUNDO_NOME)),
                coalesce(cd_exp_3n_w, max(NR_SEQ_TERCEIRO_NOME)),
                coalesce(cd_exp_4n_w, max(NR_SEQ_QUARTO_NOME))
        into STRICT    cd_exp_1n_w,
                cd_exp_2n_w,
                cd_exp_3n_w,
                cd_exp_4n_w
        from    REGRA_NOME_CAMPO_PF
        where   IE_SITUACAO = 'A' and coalesce(CD_ESTABELECIMENTO::text, '') = '' and cd_perfil = cd_profile_w;
    end if;

    if (coalesce(cd_exp_1n_w::text, '') = '' or coalesce(cd_exp_2n_w::text, '') = '' or coalesce(cd_exp_3n_w::text, '') = '' or coalesce(cd_exp_4n_w::text, '') = '') then
        select  coalesce(cd_exp_1n_w, max(NR_SEQ_PRIMEIRO_NOME)),
                coalesce(cd_exp_2n_w, max(NR_SEQ_SEGUNDO_NOME)),
                coalesce(cd_exp_3n_w, max(NR_SEQ_TERCEIRO_NOME)),
                coalesce(cd_exp_4n_w, max(NR_SEQ_QUARTO_NOME))
        into STRICT    cd_exp_1n_w,
                cd_exp_2n_w,
                cd_exp_3n_w,
                cd_exp_4n_w
        from    REGRA_NOME_CAMPO_PF
        where   IE_SITUACAO = 'A' and CD_ESTABELECIMENTO = cd_establishment_w and coalesce(cd_perfil::text, '') = '';
    end if;

    if (coalesce(cd_exp_1n_w::text, '') = '' or coalesce(cd_exp_2n_w::text, '') = '' or coalesce(cd_exp_3n_w::text, '') = '' or coalesce(cd_exp_4n_w::text, '') = '') then
        select  coalesce(cd_exp_1n_w, max(NR_SEQ_PRIMEIRO_NOME)),
                coalesce(cd_exp_2n_w, max(NR_SEQ_SEGUNDO_NOME)),
                coalesce(cd_exp_3n_w, max(NR_SEQ_TERCEIRO_NOME)),
                coalesce(cd_exp_4n_w, max(NR_SEQ_QUARTO_NOME))
        into STRICT    cd_exp_1n_w,
                cd_exp_2n_w,
                cd_exp_3n_w,
                cd_exp_4n_w
        from    REGRA_NOME_CAMPO_PF
        where   IE_SITUACAO = 'A' and coalesce(CD_ESTABELECIMENTO::text, '') = '' and coalesce(cd_perfil::text, '') = '';
    end if;

    select  max(ds_sql)
    into STRICT    ds_return_w
    from    dic_objeto
    where   nr_sequencia = 754466;

    if ( coalesce(cd_exp_1n_w, coalesce(cd_exp_2n_w, coalesce(cd_exp_3n_w, coalesce(cd_exp_4n_w, -1)))) > -1) then
        if (cd_exp_1n_w > -1) then
            select  max(CD_EXP_VALOR_DOMINIO)
            into STRICT    cd_exp_1n_w
            from    valor_dominio
            where   cd_dominio = 10578 and vl_dominio = cd_exp_1n_w;
        end if;
        if (cd_exp_2n_w > -1) then
            select  max(CD_EXP_VALOR_DOMINIO)
            into STRICT    cd_exp_2n_w
            from    valor_dominio
            where   cd_dominio = 10578 and vl_dominio = cd_exp_2n_w;
        end if;
        if (cd_exp_3n_w > -1) then
            select  max(CD_EXP_VALOR_DOMINIO)
            into STRICT    cd_exp_3n_w
            from    valor_dominio
            where   cd_dominio = 10578 and vl_dominio = cd_exp_3n_w;
        end if;
        if (cd_exp_4n_w > -1) then
            select  max(CD_EXP_VALOR_DOMINIO)
            into STRICT    cd_exp_4n_w
            from    valor_dominio
            where   cd_dominio = 10578 and vl_dominio = cd_exp_4n_w;
        end if;
        ds_return_w := replace(ds_return_w, '18602', coalesce(cd_exp_1n_w, 18602));
        ds_return_w := replace(ds_return_w, '1197017', coalesce(cd_exp_2n_w, 1197017));
        ds_return_w := replace(ds_return_w, '668506', coalesce(cd_exp_3n_w, 668506));
        ds_return_w := replace(ds_return_w, '1197018', coalesce(cd_exp_4n_w, 1197018));
    end if;

return ds_return_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_name_field_desc () FROM PUBLIC;
