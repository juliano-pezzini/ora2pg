-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_sigla_exame_fleury ( nr_prescricao_p bigint, nr_seq_prescr_p bigint ) RETURNS varchar AS $body$
DECLARE

 
cd_sigla_w		varchar(20) := null;
nr_seq_proc_interno_w	bigint;
nr_seq_exame_w		bigint;
qt_regra_w		bigint;
ie_exame_fleury_w	varchar(2);

			 

BEGIN 
 
select	max(p.nr_seq_proc_interno)	 
into STRICT	nr_seq_proc_interno_w 
from	prescr_procedimento p, 
	proc_interno i 
where	p.nr_seq_proc_interno 	= i.nr_sequencia 
and	p.nr_prescricao	 	= nr_prescricao_p 
and	p.nr_sequencia  	= nr_seq_prescr_p 
and	p.cd_cgc_laboratorio 	= '60840055000131' 
and	i.ie_tipo 		in ('AP','APH','APC');
 
 
if (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') then 
 
	select	--max(cd_integracao) 
			max(laudo_obter_cd_integracao(nr_prescricao_p, nr_seq_prescr_p, 3)) 
	into	cd_sigla_w 
	from	regra_proc_interno_integra 
	where	nr_seq_proc_interno 	= nr_seq_proc_interno_w 
	and		ie_tipo_integracao 	= 3;
	 
	if (coalesce(cd_sigla_w::text, '') = '')	then 
		 
		select	count(*) 
		into STRICT	qt_regra_w 
		from	regra_proc_interno_integra 
		where	nr_seq_proc_interno 	= nr_seq_proc_interno_w 
		and	ie_tipo_integracao 	= 3;
		 
		if (qt_regra_w > 0) then 
		 
			select	coalesce(max(cd_integracao), to_char(nr_seq_proc_interno_w))	 
			into STRICT	cd_sigla_w 
			from	proc_interno 
			where	nr_sequencia = nr_seq_proc_interno_w;
			 
		end if;
		 
	end if;
 
end if;
 
 
 
if (coalesce(cd_sigla_w::text, '') = '') then --caso não seja procedimento de anatomo 
 
 
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
	into STRICT	ie_exame_fleury_w 
	from	exame_laboratorio e, 
		prescr_procedimento p 
	where	p.nr_prescricao = nr_prescricao_p 
	and	p.nr_sequencia 	= nr_seq_prescr_p 
	and	e.nr_seq_exame 	= p.nr_seq_exame 
	and	e.cd_cgc_externo = '60840055000131';
	 
	if (ie_exame_fleury_w = 'S') then 
 
		cd_sigla_w := obter_codigo_exame_equip_presc('FLEURY', nr_prescricao_p, nr_seq_prescr_p);
	 
	end if;
	 
end if;	
 
return	cd_sigla_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_sigla_exame_fleury ( nr_prescricao_p bigint, nr_seq_prescr_p bigint ) FROM PUBLIC;

