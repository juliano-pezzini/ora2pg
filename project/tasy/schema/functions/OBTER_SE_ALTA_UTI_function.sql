-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_alta_uti (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ie_retorno_w		varchar(20) := 'N';
cd_setor_atendimento_w	bigint := null;
cd_classif_setor_w	varchar(20);

c01 CURSOR FOR 
SELECT	b.cd_setor_atendimento 
from	atend_paciente_unidade b, 
	atendimento_paciente a 
where	a.nr_atendimento		= b.nr_atendimento 
and	a.nr_atendimento		= nr_atendimento_p 
and	(a.dt_alta IS NOT NULL AND a.dt_alta::text <> '') 
order 	by dt_entrada_unidade;


BEGIN 
 
select 	max(Obter_Setor_Atend_Data(nr_atendimento_p,dt_alta)) 
into STRICT	cd_setor_atendimento_w 
from 	atendimento_paciente 
where	nr_atendimento = nr_atendimento_p;
 
if (coalesce(cd_setor_atendimento_w::text, '') = '') then 
	open c01;
	loop	 
	fetch c01 into 
		cd_setor_atendimento_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	end loop;
	close c01;
end if;
 
select	max(cd_classif_setor) 
into STRICT	cd_classif_setor_w 
from	setor_atendimento 
where	cd_setor_atendimento	= cd_setor_atendimento_w;
	 
if (coalesce(cd_classif_setor_w, '0') = '4') then 
	ie_retorno_w		:= 'S';
end if;
 
return ie_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_alta_uti (nr_atendimento_p bigint) FROM PUBLIC;
