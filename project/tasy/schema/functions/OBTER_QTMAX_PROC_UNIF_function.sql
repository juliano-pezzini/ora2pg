-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qtmax_proc_unif ( nr_interno_conta_p conta_paciente.nr_interno_conta%type, cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proced_p procedimento.ie_origem_proced%type) RETURNS bigint AS $body$
DECLARE



qt_retorno_w			integer	:= 0;
cd_procedimento_real_w		sus_aih_unif.cd_procedimento_real%type;
ie_origem_proc_real_w		sus_aih_unif.ie_origem_proc_real%type;
qt_max_procedimento_w		procedimento.qt_max_procedimento%type;
qt_proc_permitida_w		sus_proc_compativel.qt_proc_permitida%type;
dt_inicial_w				sus_aih_unif.dt_inicial%type;
		

BEGIN

begin
select	cd_procedimento_real,
	ie_origem_proc_real,
	dt_inicial
into STRICT	cd_procedimento_real_w,
	ie_origem_proc_real_w,
	dt_inicial_w
from	sus_aih_unif
where	nr_interno_conta = nr_interno_conta_p;
exception
	when others then
	cd_procedimento_real_w	:= 0;
	ie_origem_proc_real_w	:=0;
	end;

if (sus_validar_regra(11, cd_procedimento_real_w, ie_origem_proc_real_w, dt_inicial_w) = 0) then
	begin
	
	select	coalesce(max(qt_proc_permitida),0)
	into STRICT	qt_proc_permitida_w
	from	sus_proc_compativel a
	where	a.cd_proc_secundario	= cd_procedimento_p
	and	a.ie_origem_proc_sec	= ie_origem_proced_p
	and	a.cd_proc_principal	= cd_procedimento_real_w
	and	a.ie_origem_proc_princ	= ie_origem_proc_real_w;
	
	select	coalesce(max(qt_max_procedimento),0)
	into STRICT	qt_max_procedimento_w
	from	procedimento
	where	cd_procedimento		= cd_procedimento_p
	and	ie_origem_proced	= ie_origem_proced_p;
	
	
	if (qt_proc_permitida_w > 0) then
		begin
		if (qt_proc_permitida_w > qt_max_procedimento_w) then
			qt_retorno_w := qt_proc_permitida_w;
		else
			qt_retorno_w := qt_max_procedimento_w;
		end if;		
		end;
	else
		qt_retorno_w := qt_max_procedimento_w;
	end if;
		
	end;
else
	begin
	
	select 	coalesce(max(c.qt_proc_permitida),0)
	into STRICT	qt_proc_permitida_w
	from	procedimento_paciente a,
		sus_valor_proc_paciente b,
		sus_proc_compativel c
	where	a.nr_interno_conta	= nr_interno_conta_p
	and	a.nr_sequencia 		= b.nr_sequencia
	and	c.cd_proc_secundario	= cd_procedimento_p
	and	c.ie_origem_proc_sec	= ie_origem_proced_p
	and	c.cd_proc_principal	= a.cd_procedimento
	and	c.ie_origem_proc_princ	= a.ie_origem_proced
	and	coalesce(a.cd_motivo_exc_conta::text, '') = ''
	and	a.ie_origem_proced	= 7
	and	coalesce(b.cd_registro_proc,sus_obter_tiporeg_proc(a.cd_procedimento,a.ie_origem_proced,'C',2)) in (3,4);
	
	select	coalesce(max(qt_max_procedimento),0)
	into STRICT	qt_max_procedimento_w
	from	procedimento
	where	cd_procedimento		= cd_procedimento_p
	and	ie_origem_proced	= ie_origem_proced_p;
	
	if (qt_proc_permitida_w > 0) then
		begin
		if (qt_proc_permitida_w > qt_max_procedimento_w) then
			qt_retorno_w := qt_proc_permitida_w;
		else
			qt_retorno_w := qt_max_procedimento_w;
		end if;		
		end;
	else
		qt_retorno_w := qt_max_procedimento_w;
	end if;
	
	end;
end if;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qtmax_proc_unif ( nr_interno_conta_p conta_paciente.nr_interno_conta%type, cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proced_p procedimento.ie_origem_proced%type) FROM PUBLIC;
