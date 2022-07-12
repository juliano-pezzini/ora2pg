-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_regra_aviso_med (nr_interno_conta_p bigint) RETURNS varchar AS $body$
DECLARE

 
ie_aviso_w		varchar(1):= 'N';
cd_medico_executor_w	varchar(10);
cd_convenio_w		integer;
cd_estabelecimento_w	smallint;
qt_regra_medico_w	bigint;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
cd_grupo_proc_w		bigint;
cd_especialidade_w	bigint;
cd_area_proc_w		bigint;

C01 CURSOR FOR 
	SELECT	a.cd_medico_executor, 
		b.cd_estabelecimento, 
		b.cd_convenio_parametro, 
		a.cd_procedimento, 
		a.ie_origem_proced 
	from	procedimento_paciente a, 
		conta_paciente	b 
	where	b.nr_interno_conta = a.nr_interno_conta 
	and 	a.nr_interno_conta = nr_interno_conta_p 
	and 	coalesce(a.cd_motivo_exc_conta::text, '') = '' 
	order by a.nr_sequencia;
			

BEGIN 
 
ie_aviso_w:= 'N';
 
open C01;
loop 
fetch C01 into	 
	cd_medico_executor_w, 
	cd_estabelecimento_w, 
	cd_convenio_w, 
	cd_procedimento_w, 
	ie_origem_proced_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	select	coalesce(max(cd_grupo_proc),0), 
		coalesce(max(cd_especialidade),0), 
		coalesce(max(cd_area_procedimento),0) 
	into STRICT	cd_grupo_proc_w, 
		cd_especialidade_w, 
		cd_area_proc_w 
	from	estrutura_procedimento_v 
	where	cd_procedimento 	= cd_procedimento_w 
	and	ie_origem_proced	= ie_origem_proced_w;
	 
	qt_regra_medico_w:= 0;
	 
	select 	count(*) 
	into STRICT	qt_regra_medico_w 
	from 	regra_aviso_medico_conta 
	where 	coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_w, 1)) = coalesce(cd_estabelecimento_w ,1) 
	and 	coalesce(cd_convenio, coalesce(cd_convenio_w,0)) = coalesce(cd_convenio_w,0) 
	and	((coalesce(cd_procedimento::text, '') = '') or (cd_procedimento = cd_procedimento_w)) 
	and	((coalesce(cd_procedimento::text, '') = '') or (coalesce(ie_origem_proced,ie_origem_proced_w)= ie_origem_proced_w)) 
	--and	((ie_origem_proced is null) or (ie_origem_proced = ie_origem_proced_w)) 
	and	((coalesce(cd_grupo_proc::text, '') = '') or (cd_grupo_proc = cd_grupo_proc_w)) 
	and	((coalesce(cd_especialidade::text, '') = '') or (cd_especialidade = cd_especialidade_w)) 
	and	((coalesce(cd_area_procedimento::text, '') = '') or (cd_area_procedimento = cd_area_proc_w)) 
	and 	cd_medico = cd_medico_executor_w	 
	and 	(cd_medico_executor_w IS NOT NULL AND cd_medico_executor_w::text <> '');
	 
	if (qt_regra_medico_w > 0) then 
		ie_aviso_w:= 'S';
	end if;
	 
	end;
end loop;
close C01;
 
 
return	ie_aviso_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_regra_aviso_med (nr_interno_conta_p bigint) FROM PUBLIC;

