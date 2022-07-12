-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_grupo_agenda_exam (cd_agenda_p bigint) RETURNS bigint AS $body$
DECLARE


vl_retorno_w	bigint;


BEGIN

select	coalesce(max(nr_seq_agenda_grupo_exam),0)
into STRICT	vl_retorno_w
from	ageint_agenda_grupo_exam
where	cd_agenda	= cd_agenda_p;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_grupo_agenda_exam (cd_agenda_p bigint) FROM PUBLIC;

