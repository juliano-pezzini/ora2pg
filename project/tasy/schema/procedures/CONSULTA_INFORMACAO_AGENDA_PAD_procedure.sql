-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consulta_informacao_agenda_pad (nr_sequencia_p bigint, dt_inicial_p INOUT timestamp, dt_final_p INOUT timestamp, qt_tempo_minuto_p INOUT bigint, ie_frequencia_p INOUT text, ie_controle_pad_p INOUT text ) AS $body$
DECLARE


dt_inicial_w    				hc_pad_controle.dt_inicial%type;
dt_final_w  				hc_pad_controle.dt_final%type;
nr_controle_pad_w				paciente_home_care.nr_controle_pad%type;
qt_tempo_minuto_w 			hc_paciente_servico.qt_tempo_minuto%type;
nr_seq_frequencia_w			hc_paciente_servico.nr_seq_frequencia%type;
ie_frequencia_w				hc_frequencia_servico.ie_frequencia%type;
				

BEGIN

ie_controle_pad_p:= 'N';

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

select  coalesce(nr_controle_pad,0)
into STRICT 	nr_controle_pad_w
from 	paciente_home_care
where 	nr_sequencia = nr_sequencia_p;

if (nr_controle_pad_w != 0) then

ie_controle_pad_p:= 'S';

	select coalesce(a.dt_inicial,clock_timestamp()),
		coalesce(a.dt_final,clock_timestamp())
	into STRICT   dt_inicial_w,
		dt_final_w
	from   hc_pad_controle a
	where  a.nr_sequencia = nr_controle_pad_w;

	select max(qt_tempo_minuto),
		   max(nr_seq_frequencia)
	into STRICT qt_tempo_minuto_w,
	     nr_seq_frequencia_w
	from hc_paciente_servico
	where nr_seq_pac_home_care = nr_sequencia_p;
	
	if (nr_seq_frequencia_w IS NOT NULL AND nr_seq_frequencia_w::text <> '') then
	
		select coalesce(ie_frequencia,0)
		into STRICT ie_frequencia_w
		from hc_frequencia_servico
		where nr_sequencia = nr_seq_frequencia_w;
		
	end if;
	
end if;

dt_inicial_p := dt_inicial_w;
dt_final_p := dt_final_w;
qt_tempo_minuto_p := qt_tempo_minuto_w;
ie_frequencia_p := ie_frequencia_w;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consulta_informacao_agenda_pad (nr_sequencia_p bigint, dt_inicial_p INOUT timestamp, dt_final_p INOUT timestamp, qt_tempo_minuto_p INOUT bigint, ie_frequencia_p INOUT text, ie_controle_pad_p INOUT text ) FROM PUBLIC;

