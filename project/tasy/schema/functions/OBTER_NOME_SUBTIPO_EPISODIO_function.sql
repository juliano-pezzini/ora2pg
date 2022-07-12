-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_subtipo_episodio ( cd_subtipo_episodio_p bigint) RETURNS varchar AS $body$
DECLARE

 ds_retorno_w varchar(100);

BEGIN
 IF (cd_subtipo_episodio_p IS NOT NULL AND cd_subtipo_episodio_p::text <> '') THEN 
  BEGIN 
   SELECT SUBSTR(DS_SUBTIPO,1,100) 
   INTO STRICT ds_retorno_w 
   FROM subtipo_episodio 
   WHERE NR_SEQUENCIA = cd_subtipo_episodio_p;
  END;
 END IF;
RETURN ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_subtipo_episodio ( cd_subtipo_episodio_p bigint) FROM PUBLIC;
