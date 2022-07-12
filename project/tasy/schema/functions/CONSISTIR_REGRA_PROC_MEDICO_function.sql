-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION consistir_regra_proc_medico (cd_procedimento_p text, nr_seq_proc_interno_p bigint, ie_origem_proced_p bigint) RETURNS varchar AS $body$
DECLARE


retorno_w		varchar(3);
cd_grupo_proc_w		bigint;
cd_area_proc_w		bigint;
cd_especialidade_proc_w	bigint;
qt_atend_regra_w	bigint;


BEGIN
retorno_w := 'S';

select	cd_grupo_proc,
	cd_area_procedimento,
	cd_especialidade
into STRICT	cd_grupo_proc_w,
	cd_area_proc_w,
	cd_especialidade_proc_w
from	estrutura_procedimento_v
where	cd_procedimento		= cd_procedimento_p
and	ie_origem_proced	= ie_origem_proced_p;

select	coalesce(count(*),0)
into STRICT	qt_atend_regra_w
from	REGRA_PRESCR_MEDIC_EXEC
where	coalesce(nr_seq_proc_interno, coalesce(nr_seq_proc_interno_p,0))		= coalesce(nr_seq_proc_interno_p,0)
and	coalesce(cd_area_procedimento, coalesce(cd_area_proc_w,0))		= coalesce(cd_area_proc_w,0)
and	coalesce(cd_grupo_proc, 	  coalesce(cd_grupo_proc_w,0))		= coalesce(cd_grupo_proc_w,0)
and	coalesce(cd_especialidade,     coalesce(cd_especialidade_proc_w,0))	= coalesce(cd_especialidade_proc_w,0)
and	coalesce(cd_procedimento,      coalesce(cd_procedimento_p,0))		= coalesce(cd_procedimento_p,0)
and	coalesce(ie_origem_proced,     coalesce(ie_origem_proced_p,0))		= coalesce(ie_origem_proced_p,0);

if ( qt_atend_regra_w > 0) then
	select	max(ie_consiste)
	into STRICT	retorno_w
	from	REGRA_PRESCR_MEDIC_EXEC
	where	coalesce(nr_seq_proc_interno, coalesce(nr_seq_proc_interno_p,0))		= coalesce(nr_seq_proc_interno_p,0)
	and	coalesce(cd_area_procedimento, coalesce(cd_area_proc_w,0))		= coalesce(cd_area_proc_w,0)
	and	coalesce(cd_grupo_proc, 	  coalesce(cd_grupo_proc_w,0))		= coalesce(cd_grupo_proc_w,0)
	and	coalesce(cd_especialidade,     coalesce(cd_especialidade_proc_w,0))	= coalesce(cd_especialidade_proc_w,0)
	and	coalesce(cd_procedimento,      coalesce(cd_procedimento_p,0))		= coalesce(cd_procedimento_p,0)
	and	coalesce(ie_origem_proced,     coalesce(ie_origem_proced_p,0))		= coalesce(ie_origem_proced_p,0);
end if;

return	retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION consistir_regra_proc_medico (cd_procedimento_p text, nr_seq_proc_interno_p bigint, ie_origem_proced_p bigint) FROM PUBLIC;

