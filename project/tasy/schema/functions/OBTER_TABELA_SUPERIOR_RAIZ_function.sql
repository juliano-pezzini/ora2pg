-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tabela_superior_raiz (NM_TABELA_P text) RETURNS varchar AS $body$
DECLARE

  nm_tabela_raiz_w varchar(255);

BEGIN
  nm_tabela_raiz_w := NULL;

  IF (NM_TABELA_P IS NOT NULL AND NM_TABELA_P::text <> '') THEN
    SELECT NM_TABELA
      INTO STRICT nm_tabela_raiz_w
      FROM (WITH RECURSIVE cte AS (
           SELECT NM_TABELA,NM_TABELA_SUPERIOR
                         FROM TABELA_SISTEMA WHERE NM_TABELA = NM_TABELA_P
  UNION ALL
           SELECT NM_TABELA,NM_TABELA_SUPERIOR
                         FROM TABELA_SISTEMA JOIN cte c ON (c.NM_TABELA_SUPERIOR = NM_TABELA)

) SELECT * FROM cte;
) alias1
      WHERE coalesce(NM_TABELA_SUPERIOR::text, '') = '';
  END IF;

  RETURN nm_tabela_raiz_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tabela_superior_raiz (NM_TABELA_P text) FROM PUBLIC;

