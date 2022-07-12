-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_medico_departamento ( nr_seq_agenda_p bigint, cd_departamento_medico_lista_p text, ie_consulta_tabela_pai text DEFAULT 'S') RETURNS varchar AS $body$
DECLARE

    ds_retorno_w varchar(1) := 'N';

BEGIN
    IF ( ie_consulta_tabela_pai = 'N' ) THEN
        SELECT
            coalesce(MAX('S'), 'N')
        INTO STRICT ds_retorno_w
        FROM
            agenda_paciente_proc b
        WHERE
                b.nr_sequencia = nr_seq_agenda_p
            AND b.cd_medico IN (WITH RECURSIVE cte AS (

                SELECT
                    (trim(both regexp_substr(get_surgeons_by_department(cd_departamento_medico_lista_p), '[^,]+', 1, level)))::numeric
                
                instr(get_surgeons_by_department(cd_departamento_medico_lista_p), ',', 1, level) > 0
              UNION ALL

                SELECT
                    (trim(both regexp_substr(get_surgeons_by_department(cd_departamento_medico_lista_p), '[^,]+', 1, level)))::numeric 
                
                instr(get_surgeons_by_department(cd_departamento_medico_lista_p), ',', 1, level) > 0
             JOIN cte c ON ()

) SELECT * FROM cte;
);

    ELSE
        SELECT
            coalesce(MAX('S'), 'N')
        INTO STRICT ds_retorno_w
        FROM
            agenda_paciente_v a
        WHERE
                a.nr_sequencia = nr_seq_agenda_p
            AND a.cd_medico IN (WITH RECURSIVE cte AS (

                SELECT
                    (trim(both regexp_substr(get_surgeons_by_department(cd_departamento_medico_lista_p), '[^,]+', 1, level)))::numeric
                
                instr(get_surgeons_by_department(cd_departamento_medico_lista_p), ',', 1, level) > 0
              UNION ALL

                SELECT
                    (trim(both regexp_substr(get_surgeons_by_department(cd_departamento_medico_lista_p), '[^,]+', 1, level)))::numeric 
                
                instr(get_surgeons_by_department(cd_departamento_medico_lista_p), ',', 1, level) > 0
             JOIN cte c ON ()

) SELECT * FROM cte;
);

    END IF;

    RETURN ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_medico_departamento ( nr_seq_agenda_p bigint, cd_departamento_medico_lista_p text, ie_consulta_tabela_pai text DEFAULT 'S') FROM PUBLIC;

