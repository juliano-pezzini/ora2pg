-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE redefinir_destino_gastos (nr_atendimento_mae_p bigint, nm_usuario_p text, ie_origem_p text) AS $body$
DECLARE

 
nr_atendimento_rn_w	bigint;	
nr_interno_conta_rn_w	bigint;	
nr_atendimento_mae_w	bigint;

 
ie_origem_w		varchar(10);		
ie_destino_w		varchar(10);		
				  
C01 CURSOR FOR 
	SELECT	nr_interno_conta 
	from	conta_paciente 
	where	nr_atendimento = nr_atendimento_rn_w 
	and 	ie_status_acerto = 1 
	
union all
 
	SELECT	nr_interno_conta 
	from	conta_paciente 
	where	nr_atendimento = nr_atendimento_mae_w 
	and 	ie_status_acerto = 1	 
	order by nr_interno_conta;		
				  

BEGIN 
 
if (ie_origem_p = 'S') then 
	 
	ie_origem_w	:= 'RN';	
	ie_destino_w	:= 'Mãe';
	 
else 
 
	ie_origem_w	:= 'Mãe';	
	ie_destino_w	:= 'RN';
 
end if;
 
if (ie_origem_p = 'S') then 
	select 	coalesce(max(nr_atendimento),0) 
	into STRICT	nr_atendimento_rn_w 
	from 	atendimento_paciente 
	where 	nr_atendimento_mae = nr_atendimento_mae_p 
	and 	ie_trat_conta_rn = ie_origem_w;
	 
	nr_atendimento_mae_w:= nr_atendimento_mae_p;
else	 
	 
	select 	coalesce(max(nr_atendimento),0), 
		coalesce(max(nr_atendimento_mae),0) 
	into STRICT	nr_atendimento_rn_w, 
		nr_atendimento_mae_w 
	from 	atendimento_paciente 
	where 	nr_atendimento_mae = 	(	SELECT	coalesce(max(nr_atendimento_mae),0) 
						from 	atendimento_paciente 
						where 	nr_atendimento = nr_atendimento_mae_p 
						and 	ie_trat_conta_rn = ie_origem_w) 
	and 	ie_trat_conta_rn = ie_origem_w;
	 
	 
end if;
 
 
if (nr_atendimento_rn_w > 0) then 
 
	update	atendimento_paciente 
	set	ie_trat_conta_rn = ie_destino_w 
	where 	nr_atendimento = nr_atendimento_rn_w;
 
	open C01;
	loop 
	fetch C01 into	 
		nr_interno_conta_rn_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		 
		CALL recalcular_conta_paciente(nr_interno_conta_rn_w, nm_usuario_p);
		 
		end;
	end loop;
	close C01;
 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE redefinir_destino_gastos (nr_atendimento_mae_p bigint, nm_usuario_p text, ie_origem_p text) FROM PUBLIC;

