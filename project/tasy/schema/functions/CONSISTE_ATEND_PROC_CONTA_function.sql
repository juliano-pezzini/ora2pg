-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION consiste_atend_proc_conta ( cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


cd_grupo_w				bigint		:= 0;
cd_especialidade_w			bigint		:= 0;
cd_area_w				bigint		:= 0;
ie_permite_w				varchar(1)		:= 'N';




BEGIN

/* obter estrutura do procedimento */

begin
select 	cd_grupo_proc,
	cd_especialidade,
	cd_area_procedimento
into STRICT	cd_grupo_w,
	cd_especialidade_w,
	cd_area_w
from	estrutura_procedimento_v
where	cd_procedimento 	= cd_procedimento_p
and	ie_origem_proced	= ie_origem_proced_p;
exception
     	when others then
	begin
	cd_grupo_w		:= 0;
	cd_especialidade_w	:= 0;
	cd_area_w		:= 0;
	end;
end;

begin

select	coalesce(ie_tipo_setor,'N')
into STRICT	ie_permite_w
from	regra_proc_exec_conta
where (cd_procedimento = cd_procedimento_p or coalesce(cd_procedimento::text, '') = '')
and (ie_origem_proced = ie_origem_proced_p or coalesce(ie_origem_proced::text, '') = '')
and (cd_grupo_proc = cd_grupo_w or coalesce(cd_grupo_proc::text, '') = '')
and (cd_especialidade = cd_especialidade_w or coalesce(cd_especialidade::text, '') = '')
and (cd_area_procedimento = cd_area_w or coalesce(cd_area_procedimento::text, '') = '');
exception
     	when others then
	begin
	return 'N';
	end;
end;

return	ie_permite_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION consiste_atend_proc_conta ( cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

