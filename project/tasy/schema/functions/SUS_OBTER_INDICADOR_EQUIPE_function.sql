-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_indicador_equipe ( cd_funcao_p bigint) RETURNS bigint AS $body$
DECLARE


cd_retorno_w	smallint	:= 0;


BEGIN

select	coalesce(max(ie_ind_equipe_sus),0)
into STRICT	cd_retorno_w
from	funcao_medico
where	cd_funcao	= cd_funcao_p;

return	cd_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_indicador_equipe ( cd_funcao_p bigint) FROM PUBLIC;
