-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_conteudo_email_periodo ( dt_inicial_p timestamp, dt_final_p timestamp, cd_medico_p text, cd_agenda_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_conteudo_w		varchar(6000);
ds_agenda_w			varchar(100);
hr_inicio_w			varchar(100);
nm_paciente_w		varchar(100);
ds_procedimento_w		PROCEDIMENTO.DS_PROCEDIMENTO%type;
nm_medico_w			varchar(100);	
 
c01 CURSOR FOR 
	SELECT	substr(wheb_mensagem_pck.get_texto(299803) || ' ' || Obter_Nome_Agenda(cd_agenda),1,100) ds_agenda, 
			substr(wheb_mensagem_pck.get_texto(299804) || ' ' || obter_nome_medico(cd_medico,'NC'),1,100) nm_medico, 
			wheb_mensagem_pck.get_texto(299805) || ' ' || to_char(hr_inicio,'dd/mm/yyyy hh24:mi:ss') hr_inicio, 
			(wheb_mensagem_pck.get_texto(299806) || ' ' || nm_paciente) nm_paciente, 
			substr(wheb_mensagem_pck.get_texto(299807) || ' ' || obter_exame_agenda(cd_procedimento, ie_origem_proced, nr_seq_proc_interno),1,255) ds_procedimento 
	from	agenda_paciente 
	where	dt_agenda between trunc(dt_inicial_p) and fim_dia(dt_final_p) 
	and		ie_status_agenda not in ('L','C') 
	and		obter_tipo_agenda(cd_agenda) = 1 
	and (cd_medico = cd_medico_p or cd_medico_p = 0) 
	and (cd_agenda = cd_agenda_p or cd_agenda_p = 0) 
	order 	by	ds_agenda desc, 
			hr_inicio;


BEGIN 
 
open c01;
loop 
fetch c01 into 
	ds_agenda_w, 
	nm_medico_w, 
	hr_inicio_w, 
	nm_paciente_w, 
	ds_procedimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	ds_conteudo_w	:= substr(	ds_agenda_w || chr(13) || chr(10) || 
								nm_medico_w || chr(13) || chr(10) || 
								hr_inicio_w || chr(13) || chr(10) || 
								nm_paciente_w || chr(13) || chr(10) || 
								ds_procedimento_w || chr(13) || chr(10) || chr(13) || chr(10) || 
								ds_conteudo_w,1,4000);	
end loop;
close c01;
 
return substr(ds_conteudo_w,1,4000);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_conteudo_email_periodo ( dt_inicial_p timestamp, dt_final_p timestamp, cd_medico_p text, cd_agenda_p bigint) FROM PUBLIC;

