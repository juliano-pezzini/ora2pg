-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_prest_resp_proc (cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_convenio_p bigint) RETURNS varchar AS $body$
DECLARE


cd_prestador_w			varchar(14);
CD_AREA_PROCEDIMENTO_w		bigint;
CD_ESPECIALIDADE_w		bigint;
CD_GRUPO_PROc_w			bigint;

C01 CURSOR FOR
	SELECT	CD_PRESTADOR
	from	REGRA_PREST_RESP_PROC
	where	coalesce(CD_AREA_PROCEDIMENTO, CD_AREA_PROCEDIMENTO_w)	= CD_AREA_PROCEDIMENTO_w
	and	coalesce(cd_especialidade, CD_ESPECIALIDADE_w)		= CD_ESPECIALIDADE_w
	and	coalesce(CD_GRUPO_PROC, CD_GRUPO_PROc_w)			= CD_GRUPO_PROc_w
	and	coalesce(cd_procedimento, cd_procedimento_p)			= cd_procedimento_p
	and	coalesce(cd_convenio, coalesce(cd_convenio_p,0))			= coalesce(cd_convenio_p,0)
	order by coalesce(cd_procedimento, 0),
		 coalesce(cd_grupo_proc, 0),
		 coalesce(cd_especialidade, 0),
		 coalesce(cd_area_procedimento,0),
		 coalesce(cd_convenio,0);


BEGIN

select	max(CD_AREA_PROCEDIMENTO),
	max(CD_ESPECIALIDADE),
	max(CD_GRUPO_PROC)
into STRICT	CD_AREA_PROCEDIMENTO_w,
	CD_ESPECIALIDADE_w,
	CD_GRUPO_PROc_w
from	estrutura_procedimento_v
where	cd_procedimento		= cd_procedimento_p
and	ie_origem_proced	= ie_origem_proced_p;

if (CD_AREA_PROCEDIMENTO_w > 0) then
	open C01;
	loop
	fetch C01 into	cd_prestador_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		cd_prestador_w	:= cd_prestador_w;
		end;
	end loop;
	close C01;
end if;

return	cd_prestador_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_prest_resp_proc (cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_convenio_p bigint) FROM PUBLIC;
