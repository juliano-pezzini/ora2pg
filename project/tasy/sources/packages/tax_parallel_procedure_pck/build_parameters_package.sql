-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION tax_parallel_procedure_pck.build_parameters (parameters_p dbms_sql.varchar2_table) RETURNS varchar AS $body$
DECLARE

        parmaters_w varchar(4000) := '';

BEGIN
        for i in parameters_p.first .. parameters_p.last
        loop
            parmaters_w := parmaters_w || parameters_p(i);
            if parameters_p.count <> i then
                parmaters_w := parmaters_w || ',';
            end if;
        end loop;

        return parmaters_w;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION tax_parallel_procedure_pck.build_parameters (parameters_p dbms_sql.varchar2_table) FROM PUBLIC;