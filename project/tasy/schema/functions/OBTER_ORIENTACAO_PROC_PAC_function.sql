-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_orientacao_proc_pac (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_orientacao_w 	varchar(4000);
nr_atendimento_w	bigint;
qt_idade_w		bigint;
nr_seq_proc_interno_w	bigint;
cd_medico_executor_w	varchar(10);
cd_estabelecimento_w	smallint;

C01 CURSOR FOR 
	SELECT	ds_orientacao_pac 
	from	proc_interno_pac_orient 
	where	coalesce(qt_idade_w,0) between coalesce(qt_idade_min, coalesce(qt_idade_w,0)) and coalesce(qt_idade_max, 999) 
	and 	nr_seq_proc_interno = nr_seq_proc_interno_w 
	and 	coalesce(cd_pessoa_fisica, cd_medico_executor_w) = cd_medico_executor_w 
	and 	cd_estabelecimento = cd_estabelecimento_w 
	and 	coalesce(ie_situacao,'A') = 'A' 
	order by coalesce(cd_pessoa_fisica,'0'), 
		coalesce(qt_idade_min,0), 
		coalesce(qt_idade_max,999);
			

BEGIN 
 
ds_orientacao_w:= '';
 
select 	coalesce(max(nr_atendimento),0), 
	coalesce(max(nr_seq_proc_interno),0), 
	coalesce(max(cd_medico_executor),'0') 
into STRICT	nr_atendimento_w, 
	nr_seq_proc_interno_w, 
	cd_medico_executor_w 
from 	procedimento_paciente 
where 	nr_sequencia = nr_sequencia_p;
 
if (nr_atendimento_w > 0) and (nr_seq_proc_interno_w > 0) then 
 
	select 	obter_idade_pf(cd_pessoa_fisica, clock_timestamp(), 'A'), 
		cd_estabelecimento 
	into STRICT	qt_idade_w, 
		cd_estabelecimento_w 
	from 	atendimento_paciente 
	where 	nr_atendimento = nr_atendimento_w;
	 
	open C01;
	loop 
	fetch C01 into	 
		ds_orientacao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		ds_orientacao_w:= ds_orientacao_w;
		end;
	end loop;
	close C01;
 
end if;
	 
return	ds_orientacao_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_orientacao_proc_pac (nr_sequencia_p bigint) FROM PUBLIC;

