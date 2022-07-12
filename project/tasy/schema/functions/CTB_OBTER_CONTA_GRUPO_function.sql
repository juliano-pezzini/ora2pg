-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_conta_grupo ( cd_conta_contabil_p text) RETURNS varchar AS $body$
DECLARE


cd_grupo_w		bigint;
vl_resultado_w		bigint;


BEGIN

SELECT	MAX(cd_grupo)
INTO STRICT	cd_grupo_w
FROM	conta_contabil
WHERE	cd_conta_contabil = cd_conta_contabil_p;


vl_resultado_w	:= coalesce(cd_grupo_w,0);

RETURN vl_resultado_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_conta_grupo ( cd_conta_contabil_p text) FROM PUBLIC;

