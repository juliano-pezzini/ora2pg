-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_motivo_precaucoes ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_motivo_w varchar(255) := null;
ds_retorno_w   varchar(4000);

C01 CURSOR FOR
  SELECT b.ds_motivo
  FROM  atendimento_precaucao a ,
   motivo_isolamento b
  WHERE  a.nr_atendimento = nr_atendimento_p
  AND   b.nr_sequencia  = a.nr_seq_motivo_isol
  AND   coalesce(a.dt_inativacao::text, '') = ''
  AND   ((coalesce(a.dt_termino::text, '') = '') OR (clock_timestamp() BETWEEN coalesce(a.DT_INICIO,clock_timestamp() - interval '1 days') AND a.DT_TERMINO))
  AND   (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '');




BEGIN

OPEN C01;
LOOP
FETCH C01 INTO
 ds_motivo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

  IF (ds_motivo_w IS NOT NULL AND ds_motivo_w::text <> '') THEN
   ds_retorno_w := ds_retorno_w||', '||ds_motivo_w;
  ELSE
   ds_retorno_w := ds_motivo_w;
  END IF;
END LOOP;
CLOSE C01;
RETURN ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_motivo_precaucoes ( nr_atendimento_p bigint) FROM PUBLIC;

