-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_agrup_cel_apap ( nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE

  ds_retorno_w varchar(10) := '';

BEGIN
  BEGIN
    SELECT
      CASE
        WHEN coalesce(a.ie_tipo_agrupamento,'G') = 'S'
        THEN 'SUM'
        WHEN coalesce(a.ie_tipo_agrupamento,'G') = 'U'
        THEN 'LAST'
        WHEN coalesce(a.ie_tipo_agrupamento,'G') = 'C'
        THEN 'GROUP'
        ELSE 'LAST'
      END AS ie_tipo_agrupamento
    INTO STRICT ds_retorno_w
    FROM documento_subsecao a,
      w_apap_pac_informacao b
    WHERE a.nr_sequencia =
      CASE
        WHEN coalesce(b.nr_seq_superior::text, '') = ''
        THEN b.nr_seq_doc_subsecao
        ELSE (SELECT c.nr_seq_doc_subsecao
          FROM w_apap_pac_informacao c
          WHERE c.nr_sequencia = b.nr_seq_superior
          )
      END
    AND b.nr_sequencia = nr_sequencia_p;
  EXCEPTION
  WHEN OTHERS THEN
    ds_retorno_w := 'LAST';
  END;
RETURN ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_agrup_cel_apap ( nr_sequencia_p bigint) FROM PUBLIC;
