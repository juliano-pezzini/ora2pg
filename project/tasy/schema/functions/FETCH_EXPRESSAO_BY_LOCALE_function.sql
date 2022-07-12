-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fetch_expressao_by_locale ( error_desc_p w_expression_import_stg.error_desc%type, nm_user_p w_expression_import_stg.nm_usuario%type ) RETURNS varchar AS $body$
DECLARE

    error_desc_w        w_expression_import_stg.error_desc%type;
    error_desc_str_w    w_expression_import_stg.error_desc%type;

    curs_cd_expr CURSOR FOR
    SELECT
        nr_registro as cd_expr
    from
        TABLE( lista_pck.obter_lista(error_desc_p, ','));

    cur_cd_expr curs_cd_expr%rowtype;

    user_lang_w user_locale.ds_language%type;

BEGIN
    begin
        select
            ds_language
        into STRICT
            user_lang_w
        from
            user_locale
        where
            nm_user = nm_user_p;
    exception
        when no_data_found then
            user_lang_w := 'pt_BR';
        when too_many_rows then
            user_lang_w := 'pt_BR';
    end;

    open curs_cd_expr;
    loop
        fetch curs_cd_expr into cur_cd_expr;
        EXIT WHEN NOT FOUND; /* apply on curs_cd_expr */

        error_desc_w := expressao_pck.obter_desc_expressao(cur_cd_expr.cd_expr, user_lang_w);

        if (error_desc_w IS NOT NULL AND error_desc_w::text <> '') then    
            error_desc_str_w := error_desc_str_w||','||error_desc_w;
        else
            error_desc_str_w := error_desc_w;
        end if;
    end loop;
    close curs_cd_expr;
    return error_desc_str_w;
EXCEPTION
    WHEN no_data_found THEN
       return null;
    WHEN OTHERS THEN
        return null;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fetch_expressao_by_locale ( error_desc_p w_expression_import_stg.error_desc%type, nm_user_p w_expression_import_stg.nm_usuario%type ) FROM PUBLIC;

