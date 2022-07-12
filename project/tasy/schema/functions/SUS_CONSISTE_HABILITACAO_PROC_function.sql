-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_consiste_habilitacao_proc ( cd_procedimento_p bigint, ie_origem_proced_p bigint, dt_procedimento_p timestamp, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w		varchar(1) := 'S';
qt_proc_habilitacao_w	bigint;
qt_proc_hosp_hab_w	bigint;


BEGIN

select	count(*)
into STRICT	qt_proc_habilitacao_w
from	sus_proced_habilitacao
where	cd_procedimento		= cd_procedimento_p
and	ie_origem_proced	= ie_origem_proced_p;

/* Caso o procedimento possua habilitação, somente os hospitais cadastrados naquela habilitação podem executar o procedimento */

if (qt_proc_habilitacao_w > 0) then
	begin
	select	count(*)
	into STRICT	qt_proc_hosp_hab_w
	from	sus_habilitacao_hospital	a
	where	a.cd_estabelecimento	= cd_estabelecimento_p
	and	dt_procedimento_p between coalesce(a.dt_inicio_vigencia,dt_procedimento_p) and coalesce(a.dt_final_vigencia,dt_procedimento_p)
	and	a.cd_habilitacao in (	SELECT	x.cd_habilitacao
					from	sus_proced_habilitacao	x
					where	x.cd_procedimento	= cd_procedimento_p
					and	x.ie_origem_proced	= ie_origem_proced_p
					and	a.cd_habilitacao	= x.cd_habilitacao);
	if (qt_proc_hosp_hab_w = 0) then
		ds_retorno_w := 'N';
	end if;
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_consiste_habilitacao_proc ( cd_procedimento_p bigint, ie_origem_proced_p bigint, dt_procedimento_p timestamp, cd_estabelecimento_p bigint) FROM PUBLIC;
