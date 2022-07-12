-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_can_lateralidade (NR_SEQUENCIA_P bigint) RETURNS varchar AS $body$
DECLARE


ds_lateralidade_w varchar(255);


BEGIN
SELECT ds_lateralidade
INTO STRICT ds_lateralidade_w
FROM can_lateralidade
WHERE nr_sequencia = nr_sequencia_p;


RETURN ds_lateralidade_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_can_lateralidade (NR_SEQUENCIA_P bigint) FROM PUBLIC;

