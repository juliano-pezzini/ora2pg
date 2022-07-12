-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ocorrencias_horarios_rep ( ds_horarios_p text) RETURNS bigint AS $body$
DECLARE


ds_das_w 		varchar(255) := obter_texto_tasy(439834, wheb_usuario_pck.get_nr_seq_idioma);
ds_as_w			varchar(50) := obter_texto_tasy(439836, wheb_usuario_pck.get_nr_seq_idioma);
ds_horarios_w 	varchar(2000);
hr_horario_w 	varchar(7);
nr_ocorrencia_w double precision := 0;
i  				integer;


BEGIN

if (ds_horarios_p IS NOT NULL AND ds_horarios_p::text <> '') then
	begin
		if (position(ds_das_w in ds_horarios_p) > 0) and (position(ds_as_w in ds_horarios_p) > 0) then
			-- Este replace foi adicionado, para normalizar 1 espaço entre os horários (O máximo de espaçamento pode ser 5) {Parâmetro [1033] da REP}
			ds_horarios_w	:= replace(replace(replace(ds_horarios_p, '   ', ' '), '  ', ' '), '  ', ' ');
			ds_horarios_w	:= replace(replace(ds_horarios_w, ';', ' e') || ' e',' e e',' e');
					
			
			while	substr(ds_horarios_w,1,1) = ' ' loop 
				begin
				ds_horarios_w	:= substr(ds_horarios_w,2,length(ds_horarios_w));
				end;
			end loop;
			
			while(ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') loop
				begin
				select position(' e' in ds_horarios_w)
				into STRICT i
				;

				if (i > 1) and ((substr(ds_horarios_w, 1, i-1) IS NOT NULL AND (substr(ds_horarios_w, 1, i-1))::text <> '')) then
					ds_horarios_w 	:= substr(ds_horarios_w, i+3, 2000);

					nr_ocorrencia_w := nr_ocorrencia_w + 1;

				elsif (ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') then
					ds_horarios_w := '';
				end if;
				end;
			end loop;		
		else
			-- Este replace foi adicionado, para normalizar 1 espaço entre os horários (O máximo de espaçamento pode ser 5) {Parâmetro [1033] da REP}
			ds_horarios_w	:= replace(replace(replace(ds_horarios_p, '   ', ' '), '  ', ' '), '  ', ' ');
			ds_horarios_w	:= ds_horarios_w || ' ';	

			while	substr(ds_horarios_w,1,1) = ' ' loop
				begin
				ds_horarios_w	:= substr(ds_horarios_w,2,length(ds_horarios_w));
				end;
			end loop;
			
			
			while(ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') loop
				begin
				select position(' ' in ds_horarios_w)
				into STRICT i
				;

				if (i > 1) and ((substr(ds_horarios_w, 1, i-1) IS NOT NULL AND (substr(ds_horarios_w, 1, i-1))::text <> '')) then
					hr_horario_w	:= substr(ds_horarios_w, 1, i-1);
					hr_horario_w 	:= replace(hr_horario_w, ' ', '');
					ds_horarios_w 	:= substr(ds_horarios_w, i+1, 2000);

					nr_ocorrencia_w := nr_ocorrencia_w + 1;

				elsif (ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') then
					ds_horarios_w := '';
				end if;
				end;
			
			end loop;
		end if;
	exception
	when others then
		nr_ocorrencia_w := 0;	
	end;
end if;

return nr_ocorrencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ocorrencias_horarios_rep ( ds_horarios_p text) FROM PUBLIC;
