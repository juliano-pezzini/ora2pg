-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_peso_pacient_protocol (nr_seq_paciente_p bigint, nr_seq_atendimento_p bigint, ie_tipo_peso text) RETURNS double precision AS $body$
DECLARE


qt_peso_w 			bigint;
cd_pessoa_fisica_w	bigint;
qt_altura_w			bigint;
nr_seq_paciente_w	bigint;


BEGIN
	nr_seq_paciente_w := nr_seq_paciente_p;

	if (lower(ie_tipo_peso) = 'peso_ideal') then
		if (coalesce(nr_seq_paciente_w::text, '') = '' and (nr_seq_atendimento_p IS NOT NULL AND nr_seq_atendimento_p::text <> '')) then
			select 	max(nr_seq_paciente)
			into STRICT 	nr_seq_paciente_w
			from 	paciente_atendimento
			where 	nr_seq_atendimento = nr_seq_atendimento_p;
		end if;
	
		select max(ps.cd_pessoa_fisica)
		into STRICT cd_pessoa_fisica_w
		from paciente_setor ps 
		where ps.nr_seq_paciente = nr_seq_paciente_w;
		
		if (nr_seq_atendimento_p IS NOT NULL AND nr_seq_atendimento_p::text <> '') then
			select max(ps.qt_altura)
			into STRICT qt_altura_w 
			from paciente_atendimento ps 
			where ps.nr_seq_atendimento = nr_seq_atendimento_p;
		
		else
			select max(ps.qt_altura)
			into STRICT qt_altura_w 
			from paciente_setor ps 
			where ps.nr_seq_paciente = nr_seq_paciente_w;
		end if;
		
		qt_peso_w := obter_peso_ideal_pac(cd_pessoa_fisica_w, qt_altura_w);
	
  else

		if (nr_seq_atendimento_p IS NOT NULL AND nr_seq_atendimento_p::text <> '') then
			select obter_peso_ciclo(nr_seq_atendimento_p)
			into STRICT qt_peso_w 
;
		
		else
			select obter_peso_protocolo(nr_seq_paciente_w)
			into STRICT qt_peso_w
;
		end if;
		
	end if;
	
return qt_peso_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_peso_pacient_protocol (nr_seq_paciente_p bigint, nr_seq_atendimento_p bigint, ie_tipo_peso text) FROM PUBLIC;

