-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_agend_confirmada_sms ( nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE

			
ds_retorno_w		varchar(1) := 'N';
ds_retorno_cons_w	varchar(1) := 'N';
ds_retorno_exam_w	varchar(1) := 'N';
nr_seq_agenda_exame_w	agenda_paciente.nr_sequencia%type;
nr_seq_agenda_cons_w	agenda_consulta.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	nr_seq_agenda_exame,
		nr_seq_agenda_cons
	from	agenda_integrada_item
	where	nr_seq_agenda_int =  nr_sequencia_p;
	
	

BEGIN
if (coalesce(nr_sequencia_p,0) > 0) then
	open C01;
	loop
	fetch C01 into	
		nr_seq_agenda_exame_w,
		nr_seq_agenda_cons_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		
		if (coalesce(nr_seq_agenda_cons_w,0) > 0) and (ds_retorno_cons_w = 'N') then
		
			select  coalesce(max('S'),'N')
			into STRICT	ds_retorno_cons_w
			from	agenda_consulta
			where	nr_sequencia 	= nr_seq_agenda_cons_w
			and	coalesce(dt_confirmacao::text, '') = '';
		
		elsif (coalesce(nr_seq_agenda_exame_w,0) > 0) and (ds_retorno_exam_w = 'N') then
			select  coalesce(max('S'),'N')
			into STRICT	ds_retorno_exam_w
			from	agenda_paciente
			where	nr_sequencia 	= nr_seq_agenda_exame_w
			and	coalesce(dt_confirmacao::text, '') = '';
		end if;
		
		end;
	end loop;
	close C01;
end if;

if (ds_retorno_cons_w = 'S') then
	ds_retorno_w	:= ds_retorno_cons_w;
else
	ds_retorno_w	:= ds_retorno_exam_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_agend_confirmada_sms ( nr_sequencia_p bigint) FROM PUBLIC;

