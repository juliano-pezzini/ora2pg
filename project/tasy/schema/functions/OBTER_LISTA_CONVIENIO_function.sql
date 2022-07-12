-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_lista_convienio ( nr_sequenica_p bigint DEFAULT NULL) RETURNS varchar AS $body$
DECLARE


    ds_retorno_w varchar(4000) := '';


BEGIN
    SELECT (SELECT DISTINCT  rtrim(xmlagg(XMLELEMENT(name e, ds_convenio || ', ')).extract['//text()'].getclobval(), ', ')
        FROM  convenio  WHERE   cd_convenio IN (WITH RECURSIVE cte AS (

                SELECT  regexp_substr(coalesce(a.ds_selec_con, NULL), '[^,]+', 1, level) AS data_w

                regexp_substr(coalesce(a.ds_selec_con, NULL), '[^,]+', 1, level) IS NOT NULL  UNION ALL

                SELECT  regexp_substr(coalesce(a.ds_selec_con, NULL), '[^,]+', 1, level) AS data_w
                
                regexp_substr(coalesce(a.ds_selec_con, NULL), '[^,]+', 1, level) IS NOT NULL JOIN cte c ON ()

) SELECT * FROM cte;
))
  into STRICT ds_retorno_w
    FROM
        subtipo_episodio_validade a
    WHERE
    nr_sequencia = coalesce(nr_sequenica_p, 0);

RETURN ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_lista_convienio ( nr_sequenica_p bigint DEFAULT NULL) FROM PUBLIC;
