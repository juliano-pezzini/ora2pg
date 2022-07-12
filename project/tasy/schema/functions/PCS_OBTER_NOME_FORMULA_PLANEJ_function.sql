-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pcs_obter_nome_formula_planej ( nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE

 
 
 
ds_retorno_w		varchar(255);

 
 

BEGIN 
 
 
 
SELECT	ds_formula 
INTO STRICT	ds_retorno_w 
FROM	pcs_formulas 
WHERE	nr_sequencia = nr_sequencia_p;
 
 
RETURN	ds_retorno_w;
 
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pcs_obter_nome_formula_planej ( nr_sequencia_p bigint) FROM PUBLIC;

