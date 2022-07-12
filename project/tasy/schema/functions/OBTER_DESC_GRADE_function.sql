-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_grade (cd_grade_p bigint) RETURNS varchar AS $body$
DECLARE

					
ds_retorno_w		varchar(4000) := null;
ds_grade_w 			varchar(20) := '';


BEGIN

select substr(obter_desc_expressao(CD_EXP_GRADE, null), 1, 254) DS_GRID
into STRICT ds_grade_w
from EVENTOS_ADVERSOS_GRADE
where CD_GRADE = cd_grade_p
and (DS_DESCRICAO_CLIENTE IS NOT NULL AND DS_DESCRICAO_CLIENTE::text <> '');

if (ds_grade_w IS NOT NULL AND ds_grade_w::text <> '') then
	ds_retorno_w	:=  ds_grade_w;

end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_grade (cd_grade_p bigint) FROM PUBLIC;

