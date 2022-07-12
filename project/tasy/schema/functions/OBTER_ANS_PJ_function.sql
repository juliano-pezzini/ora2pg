-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ans_pj (cd_cgc_p text) RETURNS varchar AS $body$
DECLARE


cd_ans_w	varchar(20);


BEGIN

select	max(cd_ans)
into STRICT	cd_ans_w
from	pessoa_juridica
where	cd_cgc	= cd_cgc_p;

return	cd_ans_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ans_pj (cd_cgc_p text) FROM PUBLIC;

