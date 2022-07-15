-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_into (ds_tabela_p text, ds_valores_p text, ds_separador_p text, ds_colunas_p text) AS $body$
DECLARE

ds_separador_w       varchar(5);
valores_insert_w     varchar(10000);WITH RECURSIVE cte AS (


c01 is CURSOR
with data as (SELECT ds_valores_p str )
SELECT trim(both regexp_substr(str, '[^' || ds_separador_w || ']+', 1, 1)) valor_w
from data
instr(str, ds_separador_w, 1, level - 1) > 0  UNION ALL


c01 is CURSOR
with data as (SELECT ds_valores_p str )
SELECT trim(both regexp_substr(str, '[^' || ds_separador_w || ']+', 1, (c.level+1))) valor_w
from data
instr(str, ds_separador_w, 1, level - 1) > 0 JOIN cte c ON ()

) SELECT * FROM cte;
;

linha_w			         c01%rowtype;


BEGIN
  if (coalesce(ds_separador_p::text, '') = '') then
    ds_separador_w := '|';
  else
    ds_separador_w := ds_separador_p;
  end if;

  open C01;
  loop
  fetch C01 into
    linha_w;
  EXIT WHEN NOT FOUND; /* apply on c01 */
    begin
      if (linha_w.valor_w IS NOT NULL AND linha_w.valor_w::text <> '') then
        valores_insert_w := ' values (' || linha_w.valor_w || ')';
        if (ds_colunas_p IS NOT NULL AND ds_colunas_p::text <> '') then
          valores_insert_w := ' (' || ds_colunas_p || ') ' || valores_insert_w;
        end if;
        EXECUTE 'insert into ' || ds_tabela_p || valores_insert_w;
      end if;
    end;
  end loop;
  commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_into (ds_tabela_p text, ds_valores_p text, ds_separador_p text, ds_colunas_p text) FROM PUBLIC;

