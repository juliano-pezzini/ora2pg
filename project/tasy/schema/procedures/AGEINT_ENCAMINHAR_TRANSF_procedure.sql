-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_encaminhar_transf (dt_inicial_p timestamp, dt_final_p timestamp, hr_inicial_p timestamp, hr_final_p timestamp, cd_agenda_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

				   
nr_seq_agenda_w		agenda_paciente.nr_sequencia%type;				

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	agenda_paciente
	where	cd_agenda = cd_agenda_p
	and    	((cd_pessoa_fisica IS NOT NULL AND cd_pessoa_fisica::text <> '') or (nm_paciente IS NOT NULL AND nm_paciente::text <> '')) 
	and    	trunc(dt_agenda) between dt_inicial_p and fim_dia(dt_final_p)
	and (hr_inicio	>= to_date(to_char(hr_inicio,'dd/mm/yyyy') || to_char(coalesce(hr_inicial_p, trunc(clock_timestamp()) +1/86400),'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'))
	and (hr_inicio	<= to_date(to_char(hr_inicio,'dd/mm/yyyy') || to_char(coalesce(hr_final_p, trunc(clock_timestamp()) +86399/86400),'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'));
				

BEGIN

open C01;
loop
fetch C01 into	
	nr_seq_agenda_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin	
	update	agenda_paciente
	set	ie_pendente_transf = 'S'
	where	nr_sequencia = nr_seq_agenda_w;	
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_encaminhar_transf (dt_inicial_p timestamp, dt_final_p timestamp, hr_inicial_p timestamp, hr_final_p timestamp, cd_agenda_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

