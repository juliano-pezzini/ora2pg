-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_tipo_localizador ( nr_sequencia_p bigint ) RETURNS varchar AS $body$
DECLARE


ds_localizador_w		varchar(40);

BEGIN

    SELECT  MAX(ds_localizador)
    INTO STRICT    ds_localizador_w
    FROM    tipo_localizar
    WHERE   nr_sequencia = nr_sequencia_p;

    RETURN	ds_localizador_w;

    EXCEPTION
      WHEN no_data_found THEN
        RETURN NULL;

    
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_tipo_localizador ( nr_sequencia_p bigint ) FROM PUBLIC;
