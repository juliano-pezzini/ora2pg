-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_sobreposicao_ms ( nr_seq_agenda_p agenda_paciente.nr_sequencia%type, cd_agenda_p agenda.cd_agenda%type, nr_minuto_duracao_p agenda_paciente.nr_minuto_duracao%type, ie_consiste_duracao_p INOUT text, ds_sobreposicao_p INOUT text) AS $body$
DECLARE

					
cd_tipo_agenda_w	agenda.cd_tipo_agenda%type;
nr_minuto_duracao_w	agenda_paciente.nr_minuto_duracao%type;
dt_agenda_w		timestamp;
hr_inicio_w		timestamp;
ie_se_sobreposicao_w	varchar(1);
ie_consiste_duracao_w	varchar(1);
ds_sobreposicao_w	varchar(256);


BEGIN
	if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') and (cd_agenda_p IS NOT NULL AND cd_agenda_p::text <> '') then
	
	   select max(cd_tipo_agenda)
	   into STRICT	  cd_tipo_agenda_w
	   from	  agenda
	   where  cd_agenda = cd_agenda_p;
	
	   select coalesce(max(ie_consiste_duracao), 'I')
	   into STRICT	  ie_consiste_duracao_w
	   from	  parametro_agenda
	   where  cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;
				
	   if (ie_consiste_duracao_w <> 'N') then
		if (cd_tipo_agenda_w in (2,5)) then
			select  max(nr_minuto_duracao)
			into STRICT	nr_minuto_duracao_w
			from    agenda_paciente
			where   nr_sequencia = nr_seq_agenda_p;
			
			if (nr_minuto_duracao_p <> nr_minuto_duracao_w) then
				select max(hr_inicio)
				into STRICT  hr_inicio_w
				from  agenda_paciente
				where nr_sequencia = nr_seq_agenda_p;
					
				ie_se_sobreposicao_w	:= substr(obter_se_sobreposicao_horario(cd_agenda_p, hr_inicio_w, nr_minuto_duracao_p),1,1);
				
				if (ie_se_sobreposicao_w = 'S') then
					if (ie_consiste_duracao_w = 'A') then
						ds_sobreposicao_w	:= substr(obter_texto_tasy(37791, wheb_usuario_pck.get_nr_seq_idioma),1,255);
					elsif (ie_consiste_duracao_w = 'I') then				
						ds_sobreposicao_w	:= substr(obter_texto_tasy(37793, wheb_usuario_pck.get_nr_seq_idioma),1,255);				
					end if;
				end if;		
			end if;
		elsif (cd_tipo_agenda_w = 3) then
			select  max(nr_minuto_duracao)
			into STRICT	nr_minuto_duracao_w
			from    agenda_consulta
			where   nr_sequencia = nr_seq_agenda_p;
			
			if (nr_minuto_duracao_p <> nr_minuto_duracao_w) then
				select max(dt_agenda)
				into STRICT  hr_inicio_w
				from  agenda_consulta
				where nr_sequencia = nr_seq_agenda_p;

				if (hr_inicio_w IS NOT NULL AND hr_inicio_w::text <> '') then
					select	min(dt_agenda)
					into STRICT	dt_agenda_w
					from	agenda_consulta
					where	cd_agenda = cd_agenda_p
					and	pkg_date_utils.get_diffdate(hr_inicio_w, dt_agenda, 'DAY') = 0
					and	dt_agenda > hr_inicio_w
					and	ie_status_agenda not in ('C','L','II');
					
					if  ((hr_inicio_w + (nr_minuto_duracao_p / 1440)) > dt_agenda_w) then
						ie_se_sobreposicao_w	:= 'S';
					else
						ie_se_sobreposicao_w	:= 'N';
					end if;
					
					if (ie_se_sobreposicao_w = 'S') then
						if (ie_consiste_duracao_w = 'A') then
							ds_sobreposicao_w	:= substr(obter_texto_tasy(37791, wheb_usuario_pck.get_nr_seq_idioma),1,255);
						elsif (ie_consiste_duracao_w = 'I') then				
							ds_sobreposicao_w	:= substr(obter_texto_tasy(37793, wheb_usuario_pck.get_nr_seq_idioma),1,255);				
						end if;
					end if;		
				end if;
			end if;
		end if;
	   end if;
	end if;

	ie_consiste_duracao_p	:= ie_consiste_duracao_w;
	ds_sobreposicao_p	:= ds_sobreposicao_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_sobreposicao_ms ( nr_seq_agenda_p agenda_paciente.nr_sequencia%type, cd_agenda_p agenda.cd_agenda%type, nr_minuto_duracao_p agenda_paciente.nr_minuto_duracao%type, ie_consiste_duracao_p INOUT text, ds_sobreposicao_p INOUT text) FROM PUBLIC;

