-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_idade_pac_proc ( dt_procedimento_p procedimento_paciente.dt_procedimento%type, dt_nascimento_p pessoa_fisica.dt_nascimento%type) RETURNS bigint AS $body$
DECLARE


qt_idade_pac_w		real;


BEGIN

qt_idade_pac_w	:= ceil(months_between(dt_procedimento_p,dt_nascimento_p));

if (qt_idade_pac_w < 12) then
	begin
	qt_idade_pac_w := months_between(dt_procedimento_p,dt_nascimento_p);
	if (qt_idade_pac_w < 1) then
		begin
		qt_idade_pac_w	:= trunc((0.5/12),2);
		end;
	elsif (qt_idade_pac_w < 2) then
		begin
		qt_idade_pac_w := trunc((1.5/12),2);
		end;
	elsif (qt_idade_pac_w < 3) then
		begin
		qt_idade_pac_w := trunc((2.5/12),2);
		end;
	elsif (qt_idade_pac_w < 4) then
		begin
		qt_idade_pac_w := trunc((3.5/12),2);
		end;
	elsif (qt_idade_pac_w < 5) then
		begin
		qt_idade_pac_w := trunc((4.5/12),2);
		end;
	elsif (qt_idade_pac_w < 6) then
		begin
		qt_idade_pac_w := trunc((5.5/12),2);
		end;
	elsif (qt_idade_pac_w < 7) then
		begin
		qt_idade_pac_w := trunc((6.5/12),2);
		end;
	elsif (qt_idade_pac_w < 8) then
		begin
		qt_idade_pac_w := trunc((7.5/12),2);
		end;
	elsif (qt_idade_pac_w < 9) then
		begin
		qt_idade_pac_w := trunc((8.5/12),2);
		end;
	elsif (qt_idade_pac_w < 10) then
		begin
		qt_idade_pac_w := trunc((9.5/12),2);
		end;
	elsif (qt_idade_pac_w < 11) then
		begin
		qt_idade_pac_w := trunc((10.5/12),2);
		end;
	else
		begin
		qt_idade_pac_w := trunc((11.5/12),2);
		end;
	end if;
	end;
else
	qt_idade_pac_w := months_between(dt_procedimento_p,dt_nascimento_p);
	qt_idade_pac_w := trunc(qt_idade_pac_w / 12);
end if;

return	qt_idade_pac_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_idade_pac_proc ( dt_procedimento_p procedimento_paciente.dt_procedimento%type, dt_nascimento_p pessoa_fisica.dt_nascimento%type) FROM PUBLIC;
