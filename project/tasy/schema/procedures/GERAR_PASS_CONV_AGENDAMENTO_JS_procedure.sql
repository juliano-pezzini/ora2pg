-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_pass_conv_agendamento_js ( cd_tipo_agenda_p bigint, nr_seq_agenda_p bigint, ie_gerar_unid_compl_p text, nr_atendimento_p bigint, dt_entrada_p timestamp, nm_usuario_p text, ds_dados_agenda_p INOUT bigint, qt_agenda_p INOUT bigint) AS $body$
DECLARE

 
ds_dados_agenda_w	varchar(255);
qt_agenda_w		bigint;
nr_seq_unidade_w	bigint;
nr_seq_interno_w	bigint;
			

BEGIN 
 
ds_dados_agenda_w	:= obter_dados_agendas(cd_tipo_agenda_p, nr_seq_agenda_p, 'CS');
 
select 	count(*) 
into STRICT	qt_agenda_w 
from 	atend_paciente_unidade 
where 	nr_atendimento = nr_atendimento_p;
 
if (ie_gerar_unid_compl_p = 'S')and (cd_tipo_agenda_p = 5)and ((ds_dados_agenda_w)::numeric  > 0)and (qt_agenda_w = 0)then 
	begin 
	 
	select max(nr_seq_unidade) 
	into STRICT	nr_seq_unidade_w 
	from  agenda_consulta 
	where  nr_atendimento = nr_atendimento_p;
	 
	CALL ageserv_gerar_pass_setor_atend(nr_atendimento_p, (ds_dados_agenda_w)::numeric , dt_entrada_p, 'S', to_char(nr_seq_unidade_w), nm_usuario_p);
	 
	end;
else 
	begin 
	 
	if ((ds_dados_agenda_w)::numeric  > 0)and (qt_agenda_w = 0)then 
		begin 
		 
		CALL gerar_passagem_setor_atend(nr_atendimento_p, (ds_dados_agenda_w)::numeric , dt_entrada_p, 'S', nm_usuario_p);
		 
		select	coalesce(max(nr_seq_interno),0) 
		into STRICT	nr_seq_interno_w 
		from 	atend_paciente_unidade 
		where 	nr_atendimento = nr_atendimento_p;
		 
		if (nr_seq_interno_w > 0) then 
			CALL atend_paciente_unid_afterpost(nr_seq_interno_w, 'I', nm_usuario_p);
		end if;
		end;
	end if;
	 
	end;
end if;
 
ds_dados_agenda_p	:= (ds_dados_agenda_w)::numeric;
qt_agenda_p		:= qt_agenda_w;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_pass_conv_agendamento_js ( cd_tipo_agenda_p bigint, nr_seq_agenda_p bigint, ie_gerar_unid_compl_p text, nr_atendimento_p bigint, dt_entrada_p timestamp, nm_usuario_p text, ds_dados_agenda_p INOUT bigint, qt_agenda_p INOUT bigint) FROM PUBLIC;
