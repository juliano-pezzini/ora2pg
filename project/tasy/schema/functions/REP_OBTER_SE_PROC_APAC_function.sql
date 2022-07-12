-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rep_obter_se_proc_apac (nr_prescricao_p bigint, nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ie_proc_apac_w		varchar(255);
ds_retorno_w		varchar(255);
cd_procedimento_w	bigint;
cont_w			bigint;
ds_procedimento_w	varchar(255);
			
c01 CURSOR FOR 
SELECT	a.cd_procedimento, 
	substr(obter_desc_prescr_proc(a.cd_procedimento,a.ie_origem_proced, a.nr_seq_proc_interno),1,240) 
from	procedimento b, 
	prescr_procedimento a 
where	a.nr_prescricao		= nr_prescricao_p 
and	a.cd_Procedimento	= b.cd_Procedimento 
and	a.ie_origem_proced	= b.ie_origem_proced 
and	b.IE_EXIGE_AUTOR_SUS	= 'S';


BEGIN 
 
select	count(*) 
into STRICT	cont_w 
from	sus_laudo_paciente 
where	nr_atendimento	= nr_atendimento_p;
 
if (cont_w = 0) then 
	open C01;
	loop 
	fetch C01 into	 
		cd_procedimento_w, 
		ds_procedimento_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		ds_retorno_w	:= substr(ds_procedimento_w || ', ' || ds_retorno_w,1,255);
	end loop;
	close C01;
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rep_obter_se_proc_apac (nr_prescricao_p bigint, nr_atendimento_p bigint) FROM PUBLIC;

