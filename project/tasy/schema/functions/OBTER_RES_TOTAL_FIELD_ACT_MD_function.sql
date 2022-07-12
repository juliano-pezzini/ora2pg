-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_res_total_field_act_md ( ds_valor_list_p text ) RETURNS bigint AS $body$
WITH RECURSIVE cte AS (
DECLARE

  c01 CURSOR FOR
    SELECT level as id, regexp_substr(ds_valor_list_p, '[^;]+', 1, level) as val
      
    (regexp_substr(ds_valor_list_p, '[^;]+', 1, level) IS NOT NULL AND (regexp_substr(ds_valor_list_p, '[^;]+', 1, level))::text <> '')  UNION ALL
DECLARE

  c01 CURSOR FOR 
    SELECT level as id, regexp_substr(ds_valor_list_p, '[^;]+', 1, level) as val
      
    (regexp_substr(ds_valor_list_p, '[^;]+', 1, level) IS NOT NULL AND (regexp_substr(ds_valor_list_p, '[^;]+', 1, level))::text <> '') JOIN cte c ON ()

) SELECT * FROM cte;
;

  c01_w c01%rowtype;
  qt_result_w bigint := 0;

BEGIN
    open c01;
    loop
      fetch c01 into c01_w;
        EXIT WHEN NOT FOUND; /* apply on c01 */
        begin
          qt_result_w := to_number(trim(both c01_w.val), '999999999D999999999', 'NLS_NUMERIC_CHARACTERS = ''.,''') + qt_result_w;
        end;
    end loop;
    close c01;

    return coalesce(qt_result_w,0);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_res_total_field_act_md ( ds_valor_list_p text ) FROM PUBLIC;

