-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE freeze_surgical_schedules ( shedules_sequencies_p text, ie_inconsistencies_p INOUT text) AS $body$
DECLARE


ie_frozen_status_w 		varchar(4000);
ds_query_w 			varchar(255);
id 				bigint;
nr_schedule_sequence_w		varchar(10);
qt_inconsistencies_w		bigint;WITH RECURSIVE cte AS (


sequencies CURSOR FOR
SELECT level as id, regexp_substr(shedules_sequencies_p, '[^,]+', 1, level) as data

(regexp_substr(shedules_sequencies_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(shedules_sequencies_p, '[^,]+', 1, level))::text <> '')  UNION ALL


sequencies CURSOR FOR
SELECT level as id, regexp_substr(shedules_sequencies_p, '[^,]+', 1, level) as data

(regexp_substr(shedules_sequencies_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(shedules_sequencies_p, '[^,]+', 1, level))::text <> '') JOIN cte c ON ()

) SELECT * FROM cte;
;


BEGIN

if (shedules_sequencies_p IS NOT NULL AND shedules_sequencies_p::text <> '') then

	ie_inconsistencies_p := 'N';

	open sequencies;
	loop
	fetch sequencies into	
		id,
		nr_schedule_sequence_w;
	EXIT WHEN NOT FOUND; /* apply on sequencies */
		
		CALL gerar_cirurgia_agenda_html5(nr_schedule_sequence_w);
	
	end loop;
	close sequencies;
	
	select 	max(ie_status_agenda)
	into STRICT 	ie_frozen_status_w
	from 	regra_agenda_fechada;

	ds_query_w := '	update agenda_paciente 
			set	ie_status_agenda = ' || chr(39) || ie_frozen_status_w || chr(39) ||
		'	where nr_sequencia in(' || shedules_sequencies_p || ')';
		
	EXECUTE ds_query_w;
	
	commit;
	
	ds_query_w := ' select count(1) 
			from w_agenda_cirurgica_consist 
			where nr_seq_agenda in(' || shedules_sequencies_p || ')
			and ie_tipo <> ' || chr(39) || 'R' || chr(39);
			
	EXECUTE ds_query_w into STRICT qt_inconsistencies_w;
	
	if (qt_inconsistencies_w > 0) then
		ie_inconsistencies_p := 'S';
	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE freeze_surgical_schedules ( shedules_sequencies_p text, ie_inconsistencies_p INOUT text) FROM PUBLIC;

