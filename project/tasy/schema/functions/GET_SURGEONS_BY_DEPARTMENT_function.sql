-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_surgeons_by_department ( cd_departamento_medico_lista_p text ) RETURNS varchar AS $body$
DECLARE

    cd_usuarios_w varchar(4000);
  i RECORD;

BEGIN
    FOR i IN (
        SELECT
            a.cd_pessoa_fisica
        FROM
            usuario a
        WHERE
            a.nm_usuario IN (
                SELECT
                    umd.nm_usuario
                FROM
                    user_medical_department umd
                WHERE
                    umd.cd_departamento IN (WITH RECURSIVE cte AS (

                        SELECT
                            (trim(both regexp_substr(cd_departamento_medico_lista_p, '[^,]+', 1, level)))::numeric
                        
                        instr(cd_departamento_medico_lista_p, ',', 1, level - 1) > 0
                      UNION ALL

                        SELECT
                            (trim(both regexp_substr(cd_departamento_medico_lista_p, '[^,]+', 1, level)))::numeric 
                        
                        instr(cd_departamento_medico_lista_p, ',', 1, level - 1) > 0
                     JOIN cte c ON ()

) SELECT * FROM cte;
)
            )
    ) LOOP
        cd_usuarios_w := i.cd_pessoa_fisica
                         || ','
                         || cd_usuarios_w;
    END LOOP;

    RETURN cd_usuarios_w;
EXCEPTION
    WHEN no_data_found THEN
        RETURN NULL;
    WHEN too_many_rows THEN
        RAISE;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_surgeons_by_department ( cd_departamento_medico_lista_p text ) FROM PUBLIC;
