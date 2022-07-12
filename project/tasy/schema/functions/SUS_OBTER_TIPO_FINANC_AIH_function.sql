-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_tipo_financ_aih ( nr_interno_conta_p bigint) RETURNS varchar AS $body$
DECLARE


cd_procedimento_real_w		bigint;
ie_tipo_financiamento_w		varchar(4);
ie_vincular_laudos_aih_w	varchar(1)	:= 'N';
nr_atendimento_w		conta_paciente.nr_atendimento%type;
nr_seq_interno_w		sus_laudo_paciente.nr_seq_interno%type;
dt_inicial_w			sus_aih_unif.dt_inicial%type;


BEGIN

select 	coalesce(max(nr_atendimento),0)
into STRICT	nr_atendimento_w
from 	conta_paciente
where	nr_interno_conta = nr_interno_conta_p;

select	max(cd_procedimento_real),
	max(dt_inicial)
into STRICT	cd_procedimento_real_w,
	dt_inicial_w
from	sus_aih_unif
where	nr_interno_conta	= nr_interno_conta_p;

ie_vincular_laudos_aih_w 	:= coalesce(obter_valor_param_usuario(1123,180,obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario,wheb_usuario_pck.get_cd_estabelecimento),'N');

if ((ie_vincular_laudos_aih_w = 'S') and (coalesce(cd_procedimento_real_w::text, '') = '')) then
	begin
	select	coalesce(max(x.nr_seq_interno),0)
	into STRICT	nr_seq_interno_w
	from	sus_laudo_paciente x
	where	x.nr_interno_conta	= nr_interno_conta_p
	and	x.nr_atendimento	= nr_atendimento_w
	and	x.ie_classificacao 	= 1
	and	x.ie_tipo_laudo_sus 	= 1;
	
	if (nr_seq_interno_w = 0) then
		begin
		select	coalesce(max(x.nr_seq_interno),0)
		into STRICT	nr_seq_interno_w
		from	sus_laudo_paciente x
		where	x.nr_interno_conta	= nr_interno_conta_p
		and	x.nr_atendimento	= nr_atendimento_w
		and	x.ie_classificacao 	= 1
		and	x.ie_tipo_laudo_sus 	= 0;
		end;
	end if;
	
	if (nr_seq_interno_w = 0) then
		begin
		select	coalesce(max(x.nr_seq_interno),0)
		into STRICT	nr_seq_interno_w
		from	sus_laudo_paciente x
		where	x.nr_atendimento	= nr_atendimento_w
		and	x.ie_classificacao 	= 1
		and	x.ie_tipo_laudo_sus 	= 0;
		end;
	end if;	
		
	
	if (coalesce(nr_seq_interno_w,0) > 0) then
		begin
		
		select  cd_procedimento_solic,
			dt_emissao
		into STRICT	cd_procedimento_real_w,
			dt_inicial_w
		from	sus_laudo_paciente
		where	nr_seq_interno = nr_seq_interno_w;
		end;
	end if;		
	
	end;	
end if;	

if (cd_procedimento_real_w IS NOT NULL AND cd_procedimento_real_w::text <> '') then
	begin
	if (sus_validar_regra(nr_seq_regra_p => 11,cd_procedimento_p => cd_procedimento_real_w,ie_origem_proced_p => 7,dt_competencia_p => dt_inicial_w) = 0) then
		select	max(ie_tipo_financiamento)
		into STRICT	ie_tipo_financiamento_w
		from	sus_procedimento
		where	cd_procedimento	= cd_procedimento_real_w
		and	ie_origem_proced	= 7;
	else
		select	min(a.ie_tipo_financiamento)
		into STRICT	ie_tipo_financiamento_w
		from	sus_procedimento a,
			procedimento_paciente b
		where	a.cd_procedimento	= b.cd_procedimento
		and	a.ie_origem_proced	= b.ie_origem_proced
		and	b.nr_interno_conta	= nr_interno_conta_p
		and	sus_obter_tiporeg_proc(b.cd_procedimento,b.ie_origem_proced,'C',2) = 3;
	end if;
	end;
end if;

return	ie_tipo_financiamento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_tipo_financ_aih ( nr_interno_conta_p bigint) FROM PUBLIC;
