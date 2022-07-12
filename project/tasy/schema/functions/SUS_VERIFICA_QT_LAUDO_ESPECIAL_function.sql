-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_verifica_qt_laudo_especial (nr_atendimento_p bigint, nr_seq_interno_p bigint) RETURNS varchar AS $body$
DECLARE

					 
ds_retorno_w			varchar(15) := 'S';
cd_procedimento_solic_w		bigint;
ie_origem_proced_w		bigint;		
qt_procedimento_solic_w		bigint;
qt_regra_proc_w			bigint;
nr_seq_forma_org_w		bigint;
nr_seq_subgrupo_w		bigint;
nr_seq_grupo_w			bigint;
nr_seq_regra_w			bigint := 0;
qt_laudo_proc_w			bigint := 0;			
 

BEGIN 
 
select	count(*) 
into STRICT	qt_regra_proc_w 
from	sus_regra_proc_consist_uti 
where	ie_situacao = 'A';
 
if (qt_regra_proc_w > 0) then 
	begin 
	 
	begin 
	select	a.cd_procedimento_solic, 
		a.ie_origem_proced, 
		a.qt_procedimento_solic, 
		b.nr_seq_forma_org, 
		b.nr_seq_subgrupo, 
		b.nr_seq_grupo 
	into STRICT	cd_procedimento_solic_w, 
		ie_origem_proced_w, 
		qt_procedimento_solic_w, 
		nr_seq_forma_org_w, 
		nr_seq_subgrupo_w, 
		nr_seq_grupo_w	 
	from	sus_laudo_paciente a, 
		sus_estrutura_procedimento_v b 
	where	a.nr_atendimento = nr_atendimento_p 
	and	a.nr_seq_interno = nr_seq_interno_p 
	and	a.cd_procedimento_solic = b.cd_procedimento 
	and	a.ie_origem_proced = b.ie_origem_proced 
	and	coalesce(a.qt_procedimento_solic,0) > 0;	
	exception 
	when others then 
		cd_procedimento_solic_w	:= 0;
		ie_origem_proced_w	:= 0;
		qt_procedimento_solic_w	:= 0;
		nr_seq_forma_org_w	:= 0;
		nr_seq_subgrupo_w	:= 0;
		nr_seq_grupo_w		:= 0;
	end;
	 
	if (qt_procedimento_solic_w > 2) then 
		begin 
		 
		select	coalesce(max(nr_sequencia),0) 
		into STRICT	nr_seq_regra_w 
		from	sus_regra_proc_consist_uti 
		where	ie_situacao = 'A' 
		and	coalesce(cd_procedimento,cd_procedimento_solic_w) = cd_procedimento_solic_w 
		and	coalesce(ie_origem_proced,ie_origem_proced_w) = ie_origem_proced_w 
		and	coalesce(nr_seq_grupo,nr_seq_grupo_w) = nr_seq_grupo_w 
		and	coalesce(nr_seq_subgrupo,nr_seq_subgrupo_w) = nr_seq_subgrupo_w 
		and	coalesce(nr_seq_forma_org,nr_seq_forma_org_w) = nr_seq_forma_org_w;
		 
		if (nr_seq_regra_w > 0) then 
			begin 
			 
			select	count(*) 
			into STRICT	qt_laudo_proc_w 
			from	sus_laudo_paciente a 
			where	a.nr_atendimento = nr_atendimento_p 
			and	a.nr_seq_interno <> nr_seq_interno_p 
			and	a.cd_procedimento_solic = cd_procedimento_solic_w 
			and	a.ie_origem_proced = ie_origem_proced_w 
			and	coalesce(a.qt_procedimento_solic,0) > 0 
			and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '');
			 
			if (qt_procedimento_solic_w > 3) then 
				ds_retorno_w := 'N';
			elsif (qt_laudo_proc_w > 0) then 
				ds_retorno_w := 'N';
			end if;
			 
			end;
		end if;
		 
		end;
	end if;
		 
	end;
else 
	ds_retorno_w := 'S';
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_verifica_qt_laudo_especial (nr_atendimento_p bigint, nr_seq_interno_p bigint) FROM PUBLIC;
