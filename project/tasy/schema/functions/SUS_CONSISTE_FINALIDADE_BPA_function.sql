-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_consiste_finalidade_bpa ( cd_procedimento_p bigint, ie_finalidade_p bigint) RETURNS varchar AS $body$
DECLARE



ds_retorno_w		varchar(1)	:= 'N';
cd_subgrupo_bpa_w	bigint;
cd_grupo_bpa_w		bigint;
ie_finalidade_w		smallint;


C01 CURSOR FOR
SELECT	ie_finalidade
from	sus_proc_finalidade
where	ie_origem_proced		= 3
and	((coalesce(cd_procedimento::text, '') = '')	or (cd_procedimento = cd_procedimento_p))
and	((coalesce(cd_subgrupo_bpa::text, '') = '') 	or (cd_subgrupo_bpa = cd_subgrupo_bpa_w))
and	((coalesce(cd_grupo_bpa::text, '') = '') 	or (cd_grupo_bpa = cd_grupo_bpa_w))
order by
	coalesce(cd_grupo_bpa,0),
	coalesce(cd_subgrupo_bpa,0),
	coalesce(cd_procedimento,0);


BEGIN

/* Obtera estrutura BPA */

begin
select	cd_subgrupo_bpa,
	cd_grupo_bpa
into STRICT	cd_subgrupo_bpa_w,
	cd_grupo_bpa_w
from	sus_estrutura_bpa_v
where	cd_procedimento		= cd_procedimento_p
and	ie_origem_proced	= 3;
exception
	when others then
	cd_subgrupo_bpa_w	:= null;
	cd_grupo_bpa_w 		:= null;
end;

OPEN C01;
LOOP
FETCH C01 into
	ie_finalidade_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	BEGIN
	if (ie_finalidade_p	= ie_finalidade_w) then
		ds_retorno_w	:= 'S';
	end if;
	END;
END LOOP;
CLOSE C01;

return	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_consiste_finalidade_bpa ( cd_procedimento_p bigint, ie_finalidade_p bigint) FROM PUBLIC;
