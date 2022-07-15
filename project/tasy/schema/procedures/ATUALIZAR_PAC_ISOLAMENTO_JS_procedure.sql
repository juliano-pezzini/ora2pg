-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_pac_isolamento_js ( nr_sequencia_p bigint, nr_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_isolamento_w	varchar(1);					

BEGIN

begin
  select coalesce(ie_isolamento,'S')
  into STRICT   ie_isolamento_w  
  from cih_precaucao 
  where nr_sequencia = nr_sequencia_p;
exception when others then
  ie_isolamento_w := 'S';
end;

if ie_isolamento_w = 'S' then
	if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 		
		update	atendimento_paciente
		set    	ie_paciente_isolado = 'S', 
			dt_atualizacao = clock_timestamp(), 
			nm_usuario = nm_usuario_p
		where  	nr_atendimento = nr_atendimento_p;		
	end if;		
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_pac_isolamento_js ( nr_sequencia_p bigint, nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

