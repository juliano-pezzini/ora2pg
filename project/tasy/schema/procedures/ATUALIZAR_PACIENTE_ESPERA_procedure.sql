-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_paciente_espera ( nr_atendimento_p bigint, nr_sequencia_p bigint, ie_apagar_p text, nm_usuario_p text) AS $body$
DECLARE

 
ie_possui_atendimento_w		smallint;

BEGIN
if (ie_apagar_p = 'S') then 
	begin 
	delete	FROM paciente_espera 
	where	nr_sequencia = nr_sequencia_p;
	end;
else 
	begin 
	select	coalesce(max(1),0) 
	into STRICT	ie_possui_atendimento_w 
	from	atendimento_paciente 
	where	nr_atendimento = nr_atendimento_p;
 
	if (ie_possui_atendimento_w = 1) and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
		begin 
		update paciente_espera 
		set nr_atendimento = nr_atendimento_p 
		where nr_sequencia = nr_sequencia_p 
		and coalesce(nr_atendimento::text, '') = '';
		end;
	end if;
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_paciente_espera ( nr_atendimento_p bigint, nr_sequencia_p bigint, ie_apagar_p text, nm_usuario_p text) FROM PUBLIC;

