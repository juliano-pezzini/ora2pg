-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_obter_incremento_proc ( cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_estabelecimento_p bigint, nr_interno_conta_p bigint, dt_procedimento_p timestamp, pr_incremento_sa_p INOUT bigint, pr_incremento_sh_p INOUT bigint, pr_incremento_sp_p INOUT bigint, pr_incremento_sadt_p INOUT bigint) AS $body$
DECLARE


cd_habilitacao_w			smallint;
pr_incremento_sa_w		double precision	:= 0;
pr_incremento_sh_w		double precision	:= 0;
pr_incremento_sp_w		double precision	:= 0;
pr_incremento_sadt_w		double precision	:= 0;
cd_carater_internacao_w		varchar(2);
ie_carater_inter_sus_w		atendimento_paciente.ie_carater_inter_sus%type;
ie_proc_aih_urgencia_w		varchar(2);
pr_urg_emerg_w			real	:= 0;
ie_tipo_Atendimento_w		atendimento_paciente.ie_tipo_Atendimento%type;
cd_procedimento_real_w		bigint;
dt_competencia_aih_w		timestamp;
dt_comp_apac_bpa_w		timestamp;
dt_competencia_sus_w		timestamp;
ie_inc_proc_urg_aih_w		varchar(1);
ie_regra_tipo_atend_w		parametro_faturamento.ie_regra_tipo_atend%type;
qt_proc_diaria_w		bigint	:= 0;
cd_cid_principal_w		sus_aih_unif.cd_cid_principal%type;
cd_especialidade_cid_w		cid_especialidade.cd_especialidade_cid%type;
nr_atendimento_w                atendimento_paciente.nr_atendimento%type;


BEGIN

begin
select	coalesce(dt_competencia_sus, clock_timestamp()),
	coalesce(dt_comp_apac_bpa, dt_competencia_sus,clock_timestamp()),
	coalesce(ie_regra_tipo_atend,'A')
into STRICT	dt_competencia_aih_w,
	dt_comp_apac_bpa_w,
	ie_regra_tipo_atend_w
from	parametro_faturamento
where	cd_estabelecimento	= cd_estabelecimento_p;
exception
	when others then
	dt_competencia_aih_w	:= clock_timestamp();
	dt_comp_apac_bpa_w	:= clock_timestamp();
	ie_regra_tipo_atend_w	:= 'A';
end;

begin
select	a.ie_carater_inter_sus,
	a.ie_tipo_Atendimento,
        a.nr_atendimento
into STRICT	ie_carater_inter_sus_w,
	ie_tipo_Atendimento_w,
        nr_atendimento_w
from	atendimento_paciente a,
	conta_paciente b
where	a.nr_atendimento	= b.nr_atendimento
and	b.nr_interno_conta	= nr_interno_conta_p;
exception
        when others then
        ie_carater_inter_sus_w  := null;
	ie_tipo_Atendimento_w   := null;
        nr_atendimento_w        := null;
end;

if (coalesce(ie_regra_tipo_atend_w,'A') = 'C') then
	begin
	select	coalesce(ie_tipo_atend_conta,ie_tipo_atendimento_w)
	into STRICT	ie_tipo_atendimento_w
	from 	conta_paciente
	where 	nr_interno_conta = nr_interno_conta_p;
	exception
		when others then
		ie_tipo_atendimento_w:= ie_tipo_atendimento_w;
	end;
end if;

if (ie_tipo_atendimento_w	<> 1) then
        begin
	dt_competencia_sus_w	:= dt_comp_apac_bpa_w;

        begin
        select  cd_cid_principal
        into STRICT    cd_cid_principal_w
        from    sus_apac_unif
        where	nr_interno_conta	= nr_interno_conta_p;
        exception
                when others then
                cd_cid_principal_w := null;
        end;

        if (coalesce(cd_cid_principal_w,'X') = 'X') then
                begin
                cd_cid_principal_w := obter_cid_atendimento(nr_atendimento_w,'P');
                end;
        end if;

        end;
else
        begin

	dt_competencia_sus_w	:= dt_competencia_aih_w;

        begin
        select	coalesce(ie_inc_proc_urg_aih,'S')
        into STRICT	ie_inc_proc_urg_aih_w
        from	sus_parametros_aih
        where	cd_estabelecimento	= cd_estabelecimento_p;
        exception
                when others then
                ie_inc_proc_urg_aih_w	:= 'S';
        end;

        begin
        select	coalesce(cd_carater_internacao,ie_carater_inter_sus_w,'00'),
                cd_procedimento_real,
                cd_cid_principal
        into STRICT	cd_carater_internacao_w,
                cd_procedimento_real_w,
                cd_cid_principal_w
        from	sus_aih_unif
        where	nr_interno_conta	= nr_interno_conta_p;
        exception
                when others then
                cd_carater_internacao_w := '00';
                cd_procedimento_real_w  := null;
                cd_cid_principal_w      := null;
        end;

        end;
end if;

/*Adicionado o TRIM no select abaixo pois esta salvando um espaco na importacao do SUS*/

begin
select	coalesce(max(trim(both ie_urgencia)),'N')
into STRICT	ie_proc_aih_urgencia_w
from	sus_procedimento
where	cd_procedimento		= cd_procedimento_real_w
and	ie_origem_proced	= 7;
exception
when others then
	ie_proc_aih_urgencia_w := 'N';
end;

begin
select	a.cd_especialidade_cid
into STRICT	cd_especialidade_cid_w
from	cid_especialidade a,
	cid_categoria b,
	cid_doenca c
where	a.cd_especialidade_cid = b.cd_especialidade
and	b.cd_categoria_cid = c.cd_categoria_cid
and	c.cd_doenca_cid = coalesce(cd_cid_principal_w,'X');
exception
	when others then
	cd_especialidade_cid_w	:= 0;
end;

begin
select	coalesce(max(pr_incremento_sa),0),
	coalesce(max(pr_incremento_sh),0),
	coalesce(max(pr_incremento_sp),0),
	coalesce(max(pr_incremento_sadt),0),
	coalesce(max(b.cd_habilitacao),0)
into STRICT	pr_incremento_sa_w,
	pr_incremento_sh_w,
	pr_incremento_sp_w,
	pr_incremento_sadt_w,
	cd_habilitacao_w
from	sus_proced_incremento_origem	c,
	sus_habilitacao			b,
	sus_habilitacao_hospital	a
where	cd_estabelecimento	= cd_estabelecimento_p
and	cd_procedimento		= cd_procedimento_p
and	ie_origem_proced	= ie_origem_proced_p
and	dt_procedimento_p between coalesce(dt_inicio_vigencia,dt_procedimento_p) and coalesce(dt_final_vigencia,dt_procedimento_p)
and	a.cd_habilitacao        = b.cd_habilitacao
and	b.cd_habilitacao        = c.cd_habilitacao
and	((c.cd_habilitacao in (3401,3402,3403) and cd_especialidade_cid_w = 19) or
	c.cd_habilitacao not in (3401,3402,3403))
and	coalesce(c.dt_competencia,dt_competencia_sus_w)	= 
		(SELECT	coalesce(max(d.dt_competencia),dt_competencia_sus_w)
		from	sus_proced_incremento_origem d
		where	c.cd_procedimento	= d.cd_procedimento
		and	c.ie_origem_proced	= d.ie_origem_proced
		and	d.dt_competencia	= dt_competencia_sus_w);
exception
	when others then
	pr_incremento_sh_w	:= 0;
	pr_incremento_sa_w	:= 0;
	pr_incremento_sp_w	:= 0;
	pr_incremento_sadt_w	:= 0;
	cd_habilitacao_w	:= 0;
end;

if (ie_proc_aih_urgencia_w		= 'S') and (cd_carater_internacao_w	= '02') and (ie_tipo_Atendimento_w		= 1) and (sus_validar_regra(41,cd_procedimento_p,ie_origem_proced_p,dt_procedimento_p)	= 0) then
	begin
	select	coalesce(max(pr_incremento_sa),0),
		coalesce(max(pr_incremento_sh),0),
		coalesce(max(pr_incremento_sp),0),
		coalesce(max(pr_incremento_sadt),0)
	into STRICT	pr_incremento_sa_w,
		pr_incremento_sh_w,
		pr_incremento_sp_w,
		pr_incremento_sadt_w
	from	sus_proced_incremento_origem	c,
		sus_habilitacao			b,
		sus_habilitacao_hospital	a
	where	cd_estabelecimento	= cd_estabelecimento_p
	and	cd_procedimento		= cd_procedimento_real_w
	and	ie_origem_proced	= 7
	and	dt_procedimento_p between coalesce(dt_inicio_vigencia,dt_procedimento_p) and coalesce(dt_final_vigencia,dt_procedimento_p)
	and	a.cd_habilitacao        = b.cd_habilitacao
	and	b.cd_habilitacao        = c.cd_habilitacao
	and	c.cd_habilitacao not in (3401,3402,3403);
	exception
		when others then
		pr_incremento_sh_w	:= 0;
		pr_incremento_sa_w	:= 0;
		pr_incremento_sp_w	:= 0;
		pr_incremento_sadt_w	:= 0;
	end;
end if;

if (coalesce(cd_procedimento_p,0) 	= 802010210) and (cd_carater_internacao_w	= '02') and (ie_tipo_Atendimento_w		= 1) and (sus_validar_regra(41,cd_procedimento_p,ie_origem_proced_p,dt_procedimento_p) = 0) then
	
	begin
	select	coalesce(max(pr_incremento_sa),0),
		coalesce(max(pr_incremento_sh),0),
		coalesce(max(pr_incremento_sp),0),
		coalesce(max(pr_incremento_sadt),0),
		coalesce(max(b.cd_habilitacao),0)
	into STRICT	pr_incremento_sa_w,
		pr_incremento_sh_w,
		pr_incremento_sp_w,
		pr_incremento_sadt_w,
		cd_habilitacao_w
	from	sus_proced_incremento_origem	c,
		sus_habilitacao			b,
		sus_habilitacao_hospital	a
	where	cd_estabelecimento	= cd_estabelecimento_p
	and	cd_procedimento		= cd_procedimento_p
	and	ie_origem_proced	= 7
	and	dt_procedimento_p between coalesce(dt_inicio_vigencia,dt_procedimento_p) and coalesce(dt_final_vigencia,dt_procedimento_p)
	and	a.cd_habilitacao        = b.cd_habilitacao
	and	b.cd_habilitacao        = c.cd_habilitacao
	and	((c.cd_habilitacao in (3401,3402,3403) and cd_especialidade_cid_w = 19) or
		c.cd_habilitacao not in (3401,3402,3403));
	exception
		when others then
		pr_incremento_sh_w	:= 0;
		pr_incremento_sa_w	:= 0;
		pr_incremento_sp_w	:= 0;
		pr_incremento_sadt_w	:= 0;
		cd_habilitacao_w	:= 0;
	end;	
	ie_proc_aih_urgencia_w := 'S';
end if;

if (cd_habilitacao_w in (2701,2702,2703)) and	
	((cd_carater_internacao_w <> '02') or (ie_tipo_atendimento_w	<> 1)or
	(ie_proc_aih_urgencia_w = 'N' AND ie_inc_proc_urg_aih_w	 = 'N')) then

	pr_incremento_sh_w	:= 0;
	pr_incremento_sa_w	:= 0;
	pr_incremento_sp_w	:= 0;
	pr_incremento_sadt_w	:= 0;
	
end if;

if (cd_habilitacao_w in (3401,3402,3403)) then
	begin
	if	((coalesce(cd_procedimento_p,0) <> 802010210) and (cd_especialidade_cid_w = 19) and (cd_carater_internacao_w in ('02','03','04','05'))) then
		begin	
		select	sum(pr_incremento_sa),
			sum(pr_incremento_sh),
			sum(pr_incremento_sp),
			sum(pr_incremento_sadt)			
		into STRICT	pr_incremento_sa_w,
			pr_incremento_sh_w,
			pr_incremento_sp_w,
			pr_incremento_sadt_w			
		from	sus_proced_incremento_origem	c,
			sus_habilitacao			b,
			sus_habilitacao_hospital	a
		where	cd_estabelecimento	= cd_estabelecimento_p
		and	cd_procedimento		= cd_procedimento_p
		and	ie_origem_proced	= ie_origem_proced_p
		and	dt_procedimento_p between coalesce(dt_inicio_vigencia,dt_procedimento_p) and coalesce(dt_final_vigencia,dt_procedimento_p)
		and	a.cd_habilitacao        = b.cd_habilitacao
		and	b.cd_habilitacao        = c.cd_habilitacao
		and	coalesce(c.dt_competencia,dt_competencia_sus_w)	=
				(SELECT	coalesce(max(d.dt_competencia),dt_competencia_sus_w)
				from	sus_proced_incremento_origem d
				where	c.cd_procedimento	= d.cd_procedimento
				and	c.ie_origem_proced	= d.ie_origem_proced
				and	d.dt_competencia	= dt_competencia_sus_w);		
		end;
	elsif	((coalesce(cd_procedimento_p,0) = 802010210) and
		((cd_especialidade_cid_w <> 19) or (cd_carater_internacao_w not in ('02','03','04','05')))) then
		begin
		pr_incremento_sh_w	:= 0;
		pr_incremento_sa_w	:= 0;
		pr_incremento_sp_w	:= 0;
		pr_incremento_sadt_w	:= 0;
		end;
	end if;	
	end;
end if;

/*Procedimentos sequenciais nao podem dar direito a Incremento*/

if (cd_procedimento_real_w	= 415020034) then
	begin
	
	select	count(1)
	into STRICT	qt_proc_diaria_w
	from	sus_forma_organizacao a,
		sus_procedimento b
	where	a.nr_sequencia = b.nr_seq_forma_org
	and	a.cd_forma_organizacao = 80201
	and	b.cd_procedimento = cd_procedimento_p
	and	b.ie_origem_proced = ie_origem_proced_p
	and	cd_habilitacao_w = 2608;
	
	if (qt_proc_diaria_w = 0) then
		begin
		pr_incremento_sa_w	:= 0;
		pr_incremento_sh_w	:= 0;
		pr_incremento_sp_w	:= 0;
		pr_incremento_sadt_w	:= 0;
		pr_urg_emerg_w		:= 0;
		end;
	end if;
	end;
end if;

if (cd_habilitacao_w = 203) and (ie_tipo_atendimento_w <> 1) and (coalesce(cd_cid_principal_w,'X') not in ('E660','E662','E668','E669')) then
        begin
        pr_incremento_sa_w      := 0;
        end;
end if;

pr_incremento_sh_p	:= pr_incremento_sh_w;
pr_incremento_sa_p	:= pr_incremento_sa_w;
pr_incremento_sp_p	:= pr_incremento_sp_w;
pr_incremento_sadt_p	:= pr_incremento_sadt_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_obter_incremento_proc ( cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_estabelecimento_p bigint, nr_interno_conta_p bigint, dt_procedimento_p timestamp, pr_incremento_sa_p INOUT bigint, pr_incremento_sh_p INOUT bigint, pr_incremento_sp_p INOUT bigint, pr_incremento_sadt_p INOUT bigint) FROM PUBLIC;
