-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_proc_tipo_atend ( nr_seq_tipo_atend_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1)	:= 'S';
qt_registro_regra_w	integer	:= 0;
ie_estrutura_w		varchar(1)	:= 'N';
cd_area_procedimento_w	integer;
cd_especialidade_w	integer;
cd_grupo_proc_w		bigint;

C01 CURSOR FOR
	SELECT	coalesce(ie_estrutura,'N')
	from	pls_proc_regra_tipo_atend	b,
		pls_regra_tipo_atendimento	a
	where	a.nr_sequencia	= b.nr_seq_regra_tipo_atend
	and	a.nr_seq_tipo_atendimento				= nr_seq_tipo_atend_p
	and	coalesce(b.cd_procedimento, coalesce(cd_procedimento_p,0))	= coalesce(cd_procedimento_p,0)
	and	coalesce(b.ie_origem_proced, coalesce(ie_origem_proced_p,0))	= coalesce(ie_origem_proced_p,0)
	and	coalesce(b.cd_grupo_proc, coalesce(cd_grupo_proc_w,0))		= coalesce(cd_grupo_proc_w,0)
	and	coalesce(b.cd_especialidade, coalesce(cd_especialidade_w,0))	= coalesce(cd_especialidade_w,0)
	and	coalesce(b.cd_area_procedimento, coalesce(cd_area_procedimento_w,0)) = coalesce(cd_area_procedimento_w,0)
	order by
		coalesce(cd_procedimento,-1),
		coalesce(cd_grupo_proc,-1),
		coalesce(cd_especialidade,-1),
		coalesce(cd_area_procedimento,-1);


BEGIN

select	count(*)
into STRICT	qt_registro_regra_w
from	pls_proc_regra_tipo_atend	b,
	pls_regra_tipo_atendimento	a
where	a.nr_sequencia			= b.nr_seq_regra_tipo_atend
and	nr_seq_tipo_atendimento		= nr_seq_tipo_atend_p;

if (qt_registro_regra_w	> 0) then
	begin
	select	cd_grupo_proc,
		cd_area_procedimento,
		cd_especialidade
	into STRICT	cd_grupo_proc_w,
		cd_area_procedimento_w,
		cd_especialidade_w
	from	estrutura_procedimento_v
	where	cd_procedimento		= cd_procedimento_p
	and	ie_origem_proced	= ie_origem_proced_p;
	exception
	     	when others then
		begin
		cd_area_procedimento_w	:= 0;
		cd_especialidade_w	:= 0;
		cd_grupo_proc_w		:= 0;
		end;
	end;
	ie_retorno_w	:= 'N';
	open C01;
	loop
	fetch C01 into
		ie_estrutura_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	end loop;
	close C01;
	ie_retorno_w	:= ie_estrutura_w;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_proc_tipo_atend ( nr_seq_tipo_atend_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint) FROM PUBLIC;

