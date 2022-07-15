-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_valores_prescr_medica_js ( nr_atendimento_pac_p bigint, nr_atendimento_p bigint, nr_seq_agenda_p bigint, cd_tipo_agenda_p bigint, cd_setor_usuario_p bigint, nr_atendimento_prescr_p bigint, cd_setor_atendimento_p bigint, dt_prescricao_p timestamp, nm_usuario_p text, nr_controle_p INOUT bigint, nr_sequencia_p INOUT bigint, qt_peso_p INOUT bigint, qt_altura_cm_p INOUT bigint, cd_setor_entrega_p INOUT bigint, cd_setor_atend_p INOUT bigint, cd_setor_agenda_servico_p INOUT text, ds_msg_aviso_p INOUT text, dt_primeiro_horario_p INOUT timestamp) AS $body$
DECLARE


nr_controle_w			bigint;
nr_sequencia_w			agenda_paciente.nr_sequencia%type;
cd_setor_entrega_w		integer;
cd_setor_atendimento_w		integer;
				

BEGIN

select  max(nr_controle)
into STRICT	nr_controle_w
from  	prescr_medica  
where 	nr_atendimento = nr_atendimento_pac_p;

select 	coalesce(max(nr_sequencia),0)
into STRICT	nr_sequencia_w
from 	agenda_paciente 
where 	nr_atendimento = nr_atendimento_p;

nr_controle_p	:= nr_controle_w;
nr_sequencia_p	:= nr_sequencia_w;

if	(((nr_seq_agenda_p > 0) or (nr_sequencia_w > 0)) and (cd_tipo_agenda_p = 2)) then
	begin
	
	if (nr_seq_agenda_p = 0)then
		begin
	
		qt_peso_p	:= obter_peso_altura_agenda(nr_sequencia_w, 'P');
		qt_altura_cm_p	:= obter_peso_altura_agenda(nr_sequencia_w, 'A');
	
		end;
	else
		begin
	
		qt_peso_p	:= obter_peso_altura_agenda(nr_seq_agenda_p, 'P');
		qt_altura_cm_p	:= obter_peso_altura_agenda(nr_seq_agenda_p, 'A');
	
		end;
	end if;
	
	end;
end if;

select 	coalesce(max(cd_setor_atendimento),coalesce(cd_setor_usuario_p,0))
into STRICT	cd_setor_entrega_w
from 	atend_paciente_unidade
where 	nr_seq_interno	= obter_atepacu_paciente(nr_atendimento_p, 'A');

select 	max(cd_setor_atendimento)
into STRICT	cd_setor_atendimento_w
from   	atend_paciente_unidade
where  	nr_seq_interno	= obter_atepacu_paciente(nr_atendimento_prescr_p, 'A');

cd_setor_entrega_p	:= cd_setor_entrega_w;
cd_setor_atend_p	:= cd_setor_atendimento_w;

cd_setor_agenda_servico_p	:= obter_dados_agendamento(nr_seq_agenda_p, 'CSA');
ds_msg_aviso_p			:= obter_texto_tasy(83008, 1);

dt_primeiro_horario_p		:= obter_prim_horario_prescricao(nr_atendimento_prescr_p, cd_setor_atendimento_p, dt_prescricao_p, nm_usuario_p, 'R');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_valores_prescr_medica_js ( nr_atendimento_pac_p bigint, nr_atendimento_p bigint, nr_seq_agenda_p bigint, cd_tipo_agenda_p bigint, cd_setor_usuario_p bigint, nr_atendimento_prescr_p bigint, cd_setor_atendimento_p bigint, dt_prescricao_p timestamp, nm_usuario_p text, nr_controle_p INOUT bigint, nr_sequencia_p INOUT bigint, qt_peso_p INOUT bigint, qt_altura_cm_p INOUT bigint, cd_setor_entrega_p INOUT bigint, cd_setor_atend_p INOUT bigint, cd_setor_agenda_servico_p INOUT text, ds_msg_aviso_p INOUT text, dt_primeiro_horario_p INOUT timestamp) FROM PUBLIC;

