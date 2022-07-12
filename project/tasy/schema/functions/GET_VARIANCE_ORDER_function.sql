-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_variance_order (NR_SEQUENCIA_P bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);


BEGIN
if (NR_SEQUENCIA_P IS NOT NULL AND NR_SEQUENCIA_P::text <> '') then

    SELECT MAX(ORDEM)
    into STRICT ds_retorno_w
    FROM (WITH RECURSIVE cte AS (
SELECT row_number() OVER () AS ORDEM,NR_SEQUENCIA,ARRAY[ row_number() OVER (ORDER BY  DS_VARIANCIA) ] as hierarchy
             FROM PROTOCOLO_INTEGRADO_VARIAN WHERE coalesce(NR_SEQ_REFERENCIA::text, '') = ''
  UNION ALL
SELECT row_number() OVER () AS ORDEM,NR_SEQUENCIA, array_append(c.hierarchy, row_number() OVER (ORDER BY  DS_VARIANCIA))  as hierarchy
             FROM PROTOCOLO_INTEGRADO_VARIAN JOIN cte c ON (c.NR_SEQUENCIA = NR_SEQ_REFERENCIA)

) SELECT * FROM cte ORDER BY hierarchy;
) AUX
    WHERE AUX.NR_SEQUENCIA = NR_SEQUENCIA_P;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_variance_order (NR_SEQUENCIA_P bigint) FROM PUBLIC;
