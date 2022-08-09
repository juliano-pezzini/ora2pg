-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE FUNCTION get_valid_pfcs_function ( cd_funcao_p bigint, ie_pfcs_p text default current_setting('PFCS_PCK_CONSTANTS.IE_NO'), ie_main_screen_p text default current_setting('PFCS_PCK_CONSTANTS.IE_NO') ) 
RETURNS varchar AS $body$
DECLARE


-- CONSTANTS
CD_MODULE_CLOC_W                        CONSTANT MODULO_TASY.NR_SEQUENCIA%TYPE   := 1606;
CD_SYSTEM_MENU_W                        CONSTANT FUNCAO.CD_FUNCAO%TYPE           := 0;
CD_LEGAL_ENT_W                          CONSTANT FUNCAO.CD_FUNCAO%TYPE           := 6;
CD_ARCHIMEDES_W                         CONSTANT FUNCAO.CD_FUNCAO%TYPE           := 463;
CD_COMP_ESTAB_W                         CONSTANT FUNCAO.CD_FUNCAO%TYPE           := 911;
CD_INTERNAL_COMMUNICATION_W             CONSTANT FUNCAO.CD_FUNCAO%TYPE           := 87;
CD_SYSTEM_PARAMETERS_W                  CONSTANT FUNCAO.CD_FUNCAO%TYPE           := 254;
CD_REPORT_MANAGER_W                     CONSTANT FUNCAO.CD_FUNCAO%TYPE           := 260;
CD_LOG_ADMINISTRATION_W                 CONSTANT FUNCAO.CD_FUNCAO%TYPE           := 284;
CD_SO_MANAGEMENT_W                      CONSTANT FUNCAO.CD_FUNCAO%TYPE           := 296;
CD_SERVICE_ORDER_NEW_W                  CONSTANT FUNCAO.CD_FUNCAO%TYPE           := 297;
CD_ACCESS_CONTROL_W                     CONSTANT FUNCAO.CD_FUNCAO%TYPE           := 329;
CD_GENERAL_RECORDS_W                    CONSTANT FUNCAO.CD_FUNCAO%TYPE           := 3001;
CD_SYSTEM_ADMINISTRATION_W              CONSTANT FUNCAO.CD_FUNCAO%TYPE           := 6001;
CD_FUNCTION_INFO_W                      CONSTANT FUNCAO.CD_FUNCAO%TYPE           := 6005;
CD_MENU_INFO_W                          CONSTANT FUNCAO.CD_FUNCAO%TYPE           := 6006;

-- DYNAMIC VARIABLES
ie_return_w                             varchar(1) := current_setting('PFCS_PCK_CONSTANTS.IE_YES');
ie_table_origin_w                       pfcs_general_rule.ie_table_origin%type;



BEGIN
if (cd_funcao_p IS NOT NULL AND cd_funcao_p::text <> '') then
    select  max(ie_table_origin)
    into STRICT    ie_table_origin_w
    from    pfcs_general_rule;

    if (ie_table_origin_w = current_setting('PFCS_PCK_CONSTANTS.IE_TRUE')::real or ie_pfcs_p <> current_setting('PFCS_PCK_CONSTANTS.IE_NO') ) then -- ONLY PFCS
        select  coalesce(max(current_setting('PFCS_PCK_CONSTANTS.IE_YES')),current_setting('PFCS_PCK_CONSTANTS.IE_NO') )
        into STRICT    ie_return_w
        from    funcao f,
                pfcs_official_use o
        where   f.NR_SEQ_MODULO = CD_MODULE_CLOC_W
        and     f.cd_funcao = cd_funcao_p
        and     f.cd_funcao = o.cd_funcao
        and ( ie_main_screen_p = current_setting('PFCS_PCK_CONSTANTS.IE_NO')
                    or f.cd_funcao not in (
                        SELECT distinct dyn.cd_funcao
                        from pfcs_dynamic_module dyn
                        where dyn.cd_funcao <> current_setting('PFCS_PCK_CONSTANTS.CD_FUNC_ENTERPRISE_DEMAND')::integer
                    ) );

        if (ie_return_w = current_setting('PFCS_PCK_CONSTANTS.IE_NO') ) then
            select  coalesce(max(current_setting('PFCS_PCK_CONSTANTS.IE_YES') ),current_setting('PFCS_PCK_CONSTANTS.IE_NO') )
            into STRICT    ie_return_w
            from    funcao f
            where   f.cd_funcao in (
                        current_setting('PFCS_PCK_CONSTANTS.CD_FUNC_PFCS_SETTINGS')::integer,
                        CD_SYSTEM_MENU_W, CD_INTERNAL_COMMUNICATION_W,
                        CD_SYSTEM_PARAMETERS_W, CD_REPORT_MANAGER_W,
                        CD_LOG_ADMINISTRATION_W, CD_SO_MANAGEMENT_W,
                        CD_SERVICE_ORDER_NEW_W, CD_ACCESS_CONTROL_W,
                        CD_GENERAL_RECORDS_W, CD_SYSTEM_ADMINISTRATION_W,
                        CD_FUNCTION_INFO_W, CD_MENU_INFO_W, CD_LEGAL_ENT_W,
                        CD_ARCHIMEDES_W, CD_COMP_ESTAB_W)
            and     f.cd_funcao = cd_funcao_p;
        end if;

    else -- PFCS + TASY
        select  coalesce(max(current_setting('PFCS_PCK_CONSTANTS.IE_NO') ),current_setting('PFCS_PCK_CONSTANTS.IE_YES') )
        into STRICT    ie_return_w
        from    funcao f
        where   f.NR_SEQ_MODULO = CD_MODULE_CLOC_W
        and     f.cd_funcao = cd_funcao_p
        and     f.cd_funcao <> current_setting('PFCS_PCK_CONSTANTS.CD_FUNC_PFCS_SETTINGS')::integer
        and ( ie_main_screen_p = current_setting('PFCS_PCK_CONSTANTS.IE_NO')
                    or f.cd_funcao not in (
                        SELECT distinct dyn.cd_funcao
                        from pfcs_dynamic_module dyn
                        where dyn.cd_funcao <> current_setting('PFCS_PCK_CONSTANTS.CD_FUNC_ENTERPRISE_DEMAND')::integer
                    ) )
        and     not exists (SELECT 1
                        from    pfcs_official_use o
                        where   f.cd_funcao = o.cd_funcao);

    end if;
end if;

return ie_return_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_valid_pfcs_function ( cd_funcao_p bigint, ie_pfcs_p text default PFCS_PCK_CONSTANTS.IE_NO, ie_main_screen_p text default PFCS_PCK_CONSTANTS.IE_NO) FROM PUBLIC;

