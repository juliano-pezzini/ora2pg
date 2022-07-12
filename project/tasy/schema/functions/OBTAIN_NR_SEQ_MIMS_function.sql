-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obtain_nr_seq_mims (nr_version_p text) RETURNS bigint AS $body$
DECLARE

  ds_retorno_w bigint;

BEGIN
    IF (nr_version_p IS NOT NULL AND nr_version_p::text <> '') THEN 
      BEGIN 
          SELECT a.nr_sequencia 
          INTO STRICT   ds_retorno_w 
          FROM   mims_version a 
          WHERE  tasyautocomplete.Toindexwithoutaccents(a.nr_version) LIKE '%' 
                                                                           || 
                 Upper( 
                        Elimina_acentuacao(nr_version_p)) 
                                                                           || 
                 '%';
      END;
    END IF;

    RETURN ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obtain_nr_seq_mims (nr_version_p text) FROM PUBLIC;
