-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE assumir_pac_medico_desfecho_pa ( ie_desfecho_p text, cd_medico_destino_p text, nr_atendimento_p bigint, ie_forma_assumir_p text, ie_medico_p text, ie_medico_transf_int_p text, nm_usuario_p text) AS $body$
BEGIN
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
	begin	 
	if (ie_desfecho_p IS NOT NULL AND ie_desfecho_p::text <> '') then 
		begin 
		if (cd_medico_destino_p IS NOT NULL AND cd_medico_destino_p::text <> '') then 
			begin 
			if (ie_desfecho_p <> 'A') then 
				begin 
				CALL assumir_paciente(nr_atendimento_p, obter_pessoa_fisica_usuario(nm_usuario_p,'C'), ie_forma_assumir_p, nm_usuario_p);
				end;
			end if;			
			if (ie_medico_p = 'S') and (ie_desfecho_p = 'I') then 
				begin 
				CALL assumir_paciente(nr_atendimento_p, cd_medico_destino_p, ie_forma_assumir_p, nm_usuario_p);
				end;
			end if;			
			if (ie_medico_transf_int_p = 'S') and (ie_desfecho_p = 'T') then 
				begin 
				CALL assumir_paciente(nr_atendimento_p, cd_medico_destino_p, ie_forma_assumir_p, nm_usuario_p);
				end;
			end if;
			end;
		end if;
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
-- REVOKE ALL ON PROCEDURE assumir_pac_medico_desfecho_pa ( ie_desfecho_p text, cd_medico_destino_p text, nr_atendimento_p bigint, ie_forma_assumir_p text, ie_medico_p text, ie_medico_transf_int_p text, nm_usuario_p text) FROM PUBLIC;

