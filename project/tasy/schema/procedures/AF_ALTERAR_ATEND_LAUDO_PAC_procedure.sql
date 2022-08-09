-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE af_alterar_atend_laudo_pac ( nr_atend_origem_p bigint, nr_atendimento_p bigint, nr_seq_atend_futuro_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_interno_w	bigint;				
				 
C01 CURSOR FOR 
	SELECT	nr_seq_interno 
	from	sus_laudo_paciente 
	where	nr_atendimento = nr_atend_origem_p;
	

BEGIN 
if (nr_atend_origem_p IS NOT NULL AND nr_atend_origem_p::text <> '') and (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 
	 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_interno_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		update	sus_laudo_paciente 
		set	nr_atendimento = nr_atendimento_p, 
			nr_laudo_sus  = (coalesce((	SELECT 	coalesce(max(nr_laudo_sus),0) 
						from	sus_laudo_paciente     
					    where	nr_atendimento = nr_atendimento_p),0)+1), 
			nr_seq_atend_futuro = CASE WHEN coalesce(nr_seq_atend_futuro::text, '') = '' THEN nr_seq_atend_futuro_p  ELSE nr_seq_atend_futuro END 			 
		where	nr_seq_interno = nr_seq_interno_w;	
		 
		CALL gravar_log_tasy(57962,'nr_seq_interno_w='||nr_seq_interno_w||' nr_atend_origem_p='||nr_atend_origem_p||' nr_atendimento_p='||nr_atendimento_p,nm_usuario_p);
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
-- REVOKE ALL ON PROCEDURE af_alterar_atend_laudo_pac ( nr_atend_origem_p bigint, nr_atendimento_p bigint, nr_seq_atend_futuro_p bigint, nm_usuario_p text) FROM PUBLIC;
