-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tempo_atend_senhas (nr_seq_pac_senha_fila_p bigint) RETURNS varchar AS $body$
DECLARE

			
qt_segundo_w    	bigint;
qt_min_w   		bigint;
qt_hora_w		bigint;
qt_dia_w		bigint;
dt_diferenca_w		varchar(100);		
			

BEGIN
qt_segundo_w    := 0;
qt_min_w   	:= 0;
qt_hora_w	:= 0;
	
		begin
			select 	sum(coalesce(dt_fim_atendimento,clock_timestamp()) - dt_inicio_atendimento) * 86400
			into STRICT 	qt_segundo_w
			from	atendimentos_senha
			where	nr_seq_pac_senha_fila = nr_seq_pac_senha_fila_p;
		exception
		when others then
			qt_segundo_w := 9999999999;
		end;
	
	while(qt_segundo_w > 60) loop
		qt_min_w := qt_min_w + 1;
		qt_segundo_w := qt_segundo_w - 60;
	end loop;
	
	while(qt_min_w > 60) loop
		qt_hora_w := qt_hora_w + 1;
		qt_min_w := qt_min_w - 60;
	end loop;
	
	if (qt_hora_w < 100) then
		dt_diferenca_w := lpad(qt_hora_w, 2, '0') || ':' || lpad(qt_min_w, 2, '0')|| ':' || lpad(coalesce(qt_segundo_w,'00'), 2, '0');
		
	elsif (qt_hora_w < 1000) then
		dt_diferenca_w := lpad(qt_hora_w, 3, '0') || ':' || lpad(qt_min_w, 2, '0')|| ':' || lpad(coalesce(qt_segundo_w,'00'), 2, '0');
		
	elsif (qt_hora_w < 10000) then
		dt_diferenca_w := lpad(qt_hora_w, 4, '0') || ':' || lpad(qt_min_w, 2, '0')|| ':' || lpad(coalesce(qt_segundo_w,'00'), 2, '0');
		
	else
		dt_diferenca_w := lpad(qt_hora_w, 5, '0') || ':' || lpad(qt_min_w, 2, '0')|| ':' || lpad(coalesce(qt_segundo_w,'00'), 2, '0');
	end if;
	

	return dt_diferenca_w;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tempo_atend_senhas (nr_seq_pac_senha_fila_p bigint) FROM PUBLIC;

