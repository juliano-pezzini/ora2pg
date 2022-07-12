-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_dias_sus_atend (nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE


ds_retorno_w		integer;

dt_entrada_w		timestamp;
dt_alta_w			timestamp;
qt_diarias_w		bigint	:= 0;
cd_procedimento_real_w	bigint;
ie_origem_proc_real_w	bigint;
ie_permanencia_w		varchar(1)	:= 'N';
qt_permanencia_w		bigint	:= 0;
qt_diarias_uti_w		bigint	:= 0;
qt_longa_perm_total_w	bigint	:= 0;
qt_longa_perm_liq_w	bigint	:= 0;
cd_procedimento_w	bigint;

nr_seq_aih_w		bigint;
dt_inicial_w		sus_aih_unif.dt_inicial%type;

C01 CURSOR FOR
	SELECT 	cd_procedimento
	from	procedimento_paciente
	where	nr_atendimento	= nr_atendimento_p
	and	coalesce(cd_motivo_Exc_conta::text, '') = ''
	and	Sus_Obter_TipoReg_Proc(cd_procedimento,ie_origem_proced,'C',13) = 3
	order by obter_qt_dia_internacao_sus(cd_procedimento, ie_origem_proced);


BEGIN


select	max(nr_sequencia)
into STRICT	nr_seq_aih_w
from	sus_aih_unif
where	nr_Atendimento	= nr_atendimento_p;

begin
select	max(cd_procedimento_solic),
	max(ie_origem_proced)
into STRICT	cd_procedimento_real_w,
	ie_origem_proc_real_w
from	sus_laudo_paciente
where	nr_atendimento	= nr_atendimento_p
and	ie_classificacao 	= 1
and	ie_tipo_laudo_sus	= 1;
exception
	when others then
	cd_procedimento_real_w	:= 0;
	ie_origem_proc_real_w	:= 0;
end;

if (coalesce(cd_procedimento_real_w,0)	= 0) then
	begin
	select	max(cd_procedimento_solic),
		max(ie_origem_proced)
	into STRICT	cd_procedimento_real_w,
		ie_origem_proc_real_w
	from	sus_laudo_paciente
	where	nr_atendimento	= nr_atendimento_p
	and	ie_classificacao 	= 1
	and	ie_tipo_laudo_sus	= 0;
	exception
		when others then
		cd_procedimento_real_w	:= 0;
		ie_origem_proc_real_w	:= 0;
	end;
	
	if (coalesce(cd_procedimento_real_w,0)	= 0) then
		begin
		select	max(cd_procedimento_real),
			max(ie_origem_proc_real),
			max(dt_inicial)
		into STRICT	cd_procedimento_real_w,
			ie_origem_proc_real_w,
			dt_inicial_w
		from	sus_aih_unif
		where	nr_atendimento	= nr_atendimento_p
		and	nr_sequencia	= nr_seq_aih_w;
		exception
			when others then
			cd_procedimento_real_w	:= 0;
			ie_origem_proc_real_w	:= 0;
		end;		
	end if;
end if;



if (Sus_Validar_Regra(11,cd_procedimento_real_w,coalesce(ie_origem_proc_real_w,7),dt_inicial_w) >0) then
	open C01;
	loop
	fetch C01 into	
		cd_procedimento_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	end loop;
	close C01;
	
	if (coalesce(cd_procedimento_w,0)	<> 0) then
		cd_procedimento_real_w	:= cd_procedimento_w;
	end if;
end if;

begin
select	ie_permanencia,
	obter_qt_dia_internacao_sus(cd_procedimento, ie_origem_proced)
into STRICT	ie_permanencia_w,
	qt_permanencia_w
from	sus_procedimento
where	cd_procedimento	= cd_procedimento_real_w
and	ie_origem_proced	= coalesce(ie_origem_proc_real_w,7);
exception
	when others then
	ie_permanencia_w	:= 'N';
end;

--qt_permanencia_w	:= qt_permanencia_w * 2;
ds_retorno_w	:= qt_permanencia_w;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_dias_sus_atend (nr_atendimento_p bigint) FROM PUBLIC;

