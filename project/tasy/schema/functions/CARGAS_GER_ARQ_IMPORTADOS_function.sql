-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cargas_ger_arq_importados (nr_seq_carga_inicial_p ger_carga_inicial.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


ds_retorno_w    varchar(2);
nr_count        bigint;

c_ger_carga_arq CURSOR FOR
SELECT  a.*
from    ger_carga_arq a
where   a.nr_seq_carga = nr_seq_carga_inicial_p;

BEGIN

ds_retorno_w := 'S';
nr_count := 0;

for ger_carga_arq_w in c_ger_carga_arq loop
    nr_count := nr_count+ 1;
    if((ger_carga_arq_w.ie_obrigatorio = 'S') and (coalesce(ger_carga_arq_w.dt_fim_importacao::text, '') = ''))then
        return 'N';
    end if;
end loop;

if (nr_count =0)then
    ds_retorno_w := 'N';
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cargas_ger_arq_importados (nr_seq_carga_inicial_p ger_carga_inicial.nr_sequencia%type) FROM PUBLIC;

