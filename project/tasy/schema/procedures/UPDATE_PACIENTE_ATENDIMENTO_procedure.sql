-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE update_paciente_atendimento ( dt_inicio_adm_p text, dt_chegada_p text, dt_fim_adm_p text, dt_saida_previsto_p text, nr_seq_local_p bigint, nr_seq_atendimento_p text, nm_usuario_p text) AS $body$
DECLARE


ieAcomodTodosPac_w		varchar(1);
cd_estabelecimento_w		smallint;
ie_executa_agenda_w     varchar(1);
nr_seq_agenda_quimio_w	bigint;	
					  				

BEGIN
select	max(coalesce(cd_estabelecimento,0))
into STRICT	cd_estabelecimento_w
from	paciente_atendimento
where 	nr_seq_atendimento = nr_seq_atendimento_p;

ieAcomodTodosPac_w := Obter_Param_Usuario(3130, 73, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ieAcomodTodosPac_w);
if (nr_seq_atendimento_p IS NOT NULL AND nr_seq_atendimento_p::text <> '') then
	update	paciente_atendimento set
		nr_seq_local		= nr_seq_local_p,
                dt_atualizacao	 	= clock_timestamp(),  
		nm_usuario    	 	= nm_usuario_p, 
		dt_inicio_adm     	= to_date(dt_inicio_adm_p, 'dd/mm/yyyy hh24:mi:ss'),  
                dt_chegada    	 	= to_date(dt_chegada_p, 'dd/mm/yyyy hh24:mi:ss'),  
	        dt_fim_adm     		= to_date(dt_fim_adm_p, 'dd/mm/yyyy hh24:mi:ss'),  
	        dt_saida_previsto       = to_date(dt_saida_previsto_p, 'dd/mm/yyyy hh24:mi:ss')  ,
		dt_acomodacao_paciente  = clock_timestamp()
        where 	nr_seq_atendimento 	= nr_seq_atendimento_p;

  ie_executa_agenda_w := obter_param_usuario(865, 45, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_executa_agenda_w);

  if (ie_executa_agenda_w = 'S') then       
      select	max(nr_sequencia)
			into STRICT	nr_seq_agenda_quimio_w
			from	agenda_quimio
			where	nr_seq_atendimento = nr_seq_atendimento_p;
			
			if (nr_seq_agenda_quimio_w > 0) then
				begin
					CALL Qt_Alterar_Status_Agenda(nr_seq_agenda_quimio_w, 'E', nm_usuario_p, 'N', null, '', cd_estabelecimento_w, null);
				end;
			end if;		
       end if;
end if;

if (ieAcomodTodosPac_w = 'S') then
   update paciente_atendimento
	set nr_seq_local = nr_seq_local_p, 
	dt_acomodacao_paciente = clock_timestamp(), 
	nm_usuario = nm_usuario_p
	where obter_dados_paciente_setor(nr_seq_paciente,'C') = obter_dados_paciente_setor(nr_seq_atendimento_p,'C')
	and   (dt_chegada IS NOT NULL AND dt_chegada::text <> '') 
	and   to_char(dt_prevista,'dd/mm/yyyy') = to_char(clock_timestamp(),'dd/mm/yyyy');

elsif (ieAcomodTodosPac_w = 'R') then
   update paciente_atendimento
	set nr_seq_local = nr_seq_local_p, 
	dt_acomodacao_paciente = clock_timestamp(),
	nm_usuario = nm_usuario_p
	where obter_dados_paciente_setor(nr_seq_paciente,'C') = obter_dados_paciente_setor(nr_seq_atendimento_p,'C')
	and   to_char(dt_real,'dd/mm/yyyy') = clock_timestamp()
	and   (dt_chegada IS NOT NULL AND dt_chegada::text <> '');
end if;

	
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE update_paciente_atendimento ( dt_inicio_adm_p text, dt_chegada_p text, dt_fim_adm_p text, dt_saida_previsto_p text, nr_seq_local_p bigint, nr_seq_atendimento_p text, nm_usuario_p text) FROM PUBLIC;
