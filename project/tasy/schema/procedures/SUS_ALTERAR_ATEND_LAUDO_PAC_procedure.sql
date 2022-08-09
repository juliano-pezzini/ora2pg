-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_alterar_atend_laudo_pac ( nr_atendimento_p bigint, nr_seq_interno_p bigint, nm_usuario_p text) AS $body$
BEGIN
 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nr_seq_interno_p IS NOT NULL AND nr_seq_interno_p::text <> '') then 
	begin 
 
	update	sus_laudo_paciente 
	set	nr_atendimento = nr_atendimento_p, 
		nr_laudo_sus = (coalesce((	SELECT	coalesce(max(nr_laudo_sus),0) 
					from	sus_laudo_paciente 
					where	nr_atendimento = nr_atendimento_p),0)+1) 
	where	nr_seq_interno = nr_seq_interno_p;
	 
	commit;
	end;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_alterar_atend_laudo_pac ( nr_atendimento_p bigint, nr_seq_interno_p bigint, nm_usuario_p text) FROM PUBLIC;
