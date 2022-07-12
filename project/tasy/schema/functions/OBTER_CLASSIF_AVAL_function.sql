-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_classif_aval (ie_prioridade_p bigint) RETURNS varchar AS $body$
DECLARE


ds_classif_w	varchar(255);


BEGIN

SELECT	ds_classificacao
INTO STRICT	ds_classif_w
FROM	nut_atend_serv_classif
WHERE	ie_prioridade = ie_prioridade_p;

return	ds_classif_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_classif_aval (ie_prioridade_p bigint) FROM PUBLIC;

