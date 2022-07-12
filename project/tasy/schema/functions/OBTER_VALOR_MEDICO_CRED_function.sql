-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_medico_cred (nr_interno_conta_p bigint) RETURNS bigint AS $body$
DECLARE

					 
cd_convenio_w		bigint;
cd_medico_w 		bigint;
ie_conveniado_w		varchar(1);
vl_medico_w			double precision;
vl_resultado_w		double precision := 0;

C01 CURSOR FOR 
	SELECT 		sum(coalesce(p.vl_medico,0)), 
				p.cd_medico, 
				p.cd_convenio 
	from		conta_paciente_honorario_v p, 
				procedimento_paciente a 
	where		p.nr_interno_conta = nr_interno_conta_p 
	and			coalesce(p.cd_motivo_exc_conta::text, '') = '' 
	and 		a.nr_interno_conta = p.nr_interno_conta 
	GROUP BY	p.cd_medico,p.cd_convenio;
	
	 
 

BEGIN 
 
open C01;
	loop 
		fetch 	C01 
		 HAVING 		sum(coalesce(p.vl_medico,0)) <> 0 
	into 	vl_medico_w,					 
				cd_medico_w, 
				cd_convenio_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
 
		begin 
		select 	ie_conveniado 
		into STRICT 	ie_conveniado_w 
		from	medico_convenio 
		where	cd_pessoa_fisica	= cd_medico_w 
		and		cd_convenio 		= cd_convenio_w;
		exception 
		when others then 
			ie_conveniado_w := 'N';
		end;	
			 
		if (ie_conveniado_w = 'S') then 
			vl_resultado_w := vl_resultado_w + vl_medico_w;	
		end if;
		 
	end loop;
close C01;
 
return coalesce(vl_resultado_w,0);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_medico_cred (nr_interno_conta_p bigint) FROM PUBLIC;
