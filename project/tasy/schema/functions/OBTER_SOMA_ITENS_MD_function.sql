-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_soma_itens_md (cd_valores_p text) RETURNS varchar AS $body$
DECLARE

  v_result_w      varchar(3200);
  v_soma_w        bigint := 0;
  v_valor_atual_w bigint;
  v_cont_w        bigint := 0;
  i RECORD;

BEGIN

  for i in (WITH RECURSIVE cte AS (
SELECT regexp_substr(cd_valores_p, '[^-]+', 1, level) as linha

            (regexp_substr(cd_valores_p, '[^-]+', 1, level) IS NOT NULL AND (regexp_substr(cd_valores_p, '[^-]+', 1, level))::text <> '')  UNION ALL
SELECT regexp_substr(cd_valores_p, '[^-]+', 1, level) as linha
              
            (regexp_substr(cd_valores_p, '[^-]+', 1, level) IS NOT NULL AND (regexp_substr(cd_valores_p, '[^-]+', 1, level))::text <> '') JOIN cte c ON ()

) SELECT * FROM cte;
) loop
  
    v_valor_atual_w := i.linha;
    v_soma_w        := v_soma_w + v_valor_atual_w;
    if (v_cont_w = 0) then
      v_result_w := v_result_w || v_soma_w;
    else
      v_result_w := v_result_w || '-' || v_soma_w;
    end if;
    v_cont_w := v_cont_w + 1;
  end loop;
  return v_result_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_soma_itens_md (cd_valores_p text) FROM PUBLIC;

