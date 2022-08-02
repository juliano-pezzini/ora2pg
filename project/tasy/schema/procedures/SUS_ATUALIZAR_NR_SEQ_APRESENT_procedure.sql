-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_atualizar_nr_seq_apresent (nr_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

	 
nr_interno_conta_w		conta_paciente.nr_interno_conta%type;
nr_seq_apresent_sus_w	conta_paciente.nr_seq_apresent_sus%type := 1;
qt_seq_utilizada_w		bigint := 0;
	
C01 CURSOR FOR 
	SELECT	nr_interno_conta 
	from	conta_paciente 
	where	nr_atendimento = nr_atendimento_p 
	and	coalesce(nr_seq_apresent_sus::text, '') = '' 
	order by	nr_interno_conta;					
 

BEGIN 
 
open C01;
loop 
fetch C01 into	 
	nr_interno_conta_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	<<inicio>> 
	 
	select	count(*) 
	into STRICT	qt_seq_utilizada_w 
	from	conta_paciente 
	where	nr_seq_apresent_sus 	= nr_seq_apresent_sus_w 
	and	nr_atendimento 		= nr_atendimento_p;
	 
	if (qt_seq_utilizada_w = 0) then 
		begin 
		 
		update 	conta_paciente 
		set 	nr_seq_apresent_sus 	= nr_seq_apresent_sus_w, 
			nm_usuario		= nm_usuario_p, 
			dt_atualizacao		= clock_timestamp() 
		where 	nr_interno_conta 		= nr_interno_conta_w 
		and	nr_atendimento 		= nr_atendimento_p;		
		 
		end;
	else 
		begin 
		 
		nr_seq_apresent_sus_w := nr_seq_apresent_sus_w + 1;
		 
		goto inicio;
		 
		end;
	end if;
	 
	 
	nr_seq_apresent_sus_w := nr_seq_apresent_sus_w + 1;
	 
	end;
end loop;
close C01;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_atualizar_nr_seq_apresent (nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

