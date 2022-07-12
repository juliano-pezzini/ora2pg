-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION padroniza_horario_sae ( ds_horarios_p text, dt_hora_inicio_p text, dt_hora_inicio_val_p text, dt_inicio_interv_p timestamp default null, dt_fim_validade_p timestamp default null, cd_intervalo_p intervalo_prescricao.cd_intervalo%type default null) RETURNS varchar AS $body$
DECLARE


ds_valido_w 		varchar(12)		:= '1234567890A ';
ds_validos_ww		varchar(20)		:= '1234567890A:; ';
ds_texto_w			varchar(2000);
X					varchar(1);
i					integer;
qt_vezes_w			bigint;
index_space			bigint;
index_divider		bigint;

ds_horario_w		varchar(50);
dt_hora_inicio_w	varchar(50);
ds_horarios_w		varchar(2000);
ds_data_w			varchar(20);
ds_data_hor_w		varchar(20);
ds_hor_sae_w		varchar(4000);
ds_form_hor_w		varchar(20);
dt_atual_w			timestamp;
ds_hor_ant_w		varchar(07);

dt_horario_atual_w	timestamp;
ie_operacao_w	intervalo_prescricao.ie_operacao%type;
qt_operacao_w	intervalo_prescricao.qt_operacao%type;WITH RECURSIVE cte AS (


C01 CURSOR FOR
SELECT	regexp_substr(ds_horarios_w,'[^ ]+', 1,level) no_list

(regexp_substr(ds_horarios_w,'[^ ]+',1,level) IS NOT NULL AND (regexp_substr(ds_horarios_w,'[^ ]+',1,level))::text <> '')  UNION ALL


C01 CURSOR FOR
SELECT	regexp_substr(ds_horarios_w,'[^ ]+', 1,level) no_list

(regexp_substr(ds_horarios_w,'[^ ]+',1,level) IS NOT NULL AND (regexp_substr(ds_horarios_w,'[^ ]+',1,level))::text <> '') JOIN cte c ON ()

) SELECT * FROM cte ORDER BY  1;
;


BEGIN
dt_hora_inicio_w := dt_hora_inicio_p;

if (cd_intervalo_p IS NOT NULL AND cd_intervalo_p::text <> '') then
	select	max(a.ie_operacao),
		max(a.qt_operacao)
	into STRICT	ie_operacao_w,
		qt_operacao_w
	from	intervalo_prescricao a
	where	a.cd_intervalo = cd_intervalo_p;
end if;

if (ie_operacao_w = 'H' and qt_operacao_w > 24 and (dt_inicio_interv_p IS NOT NULL AND dt_inicio_interv_p::text <> '')) then
	begin
	dt_horario_atual_w := dt_inicio_interv_p;

	while(dt_horario_atual_w <= dt_fim_validade_p) loop
		begin
		select	rpad('A',floor(dt_horario_atual_w - trunc(dt_inicio_interv_p)),'A') ||
				lpad(pkg_date_utils.extract_field('HOUR',dt_horario_atual_w),2,'0') || ':' ||
				rpad(pkg_date_utils.extract_field('MINUTE',dt_horario_atual_w),2,'0')
		into STRICT	ds_horario_w
		;

		ds_horarios_w := ds_horarios_w || ' ' || ds_horario_w;

		dt_horario_atual_w := dt_horario_atual_w + (qt_operacao_w / 24);
		end;
	end loop;

	ds_hor_sae_w := substr(ds_horarios_w,1,2000);
	end;
else
	begin
	if (length(dt_hora_inicio_w) < 12) then
		dt_hora_inicio_w := substr(dt_hora_inicio_w,1,10)||' 00:00:01';
	end if;

	ds_horarios_w := ds_horarios_p ||' ';

	/*Eliminar caracteres indevidos*/

	if (ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') then
		begin
		ds_horarios_w	:= Replace(ds_horarios_w,',',' ');
		ds_texto_w	:= '';
		FOR i IN 1..length(ds_horarios_w) LOOP
			X	:= substr(ds_horarios_w, i, 1);	
			if (position(X in ds_validos_ww) > 0) then
				ds_texto_w	:= ds_texto_w || X;
			else
				ds_texto_w	:= ds_texto_w ||' ';
			end if;
		END LOOP;
		ds_horarios_w	:= ds_texto_w;

		if (ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') then	
			-- Verifica se horarios de item continuo, separados por virgula
			if (position(';' in ds_horarios_w) > 0) then
				-- Remover espacamentos duplos
				ds_horarios_w	:= replace(replace(replace(replace(ds_horarios_w,'  ',' '),'  ',' '),'  ',' '),'  ',' ');

				-- Remover espacamentos entre horarios
				ds_horarios_w	:= replace(replace(ds_horarios_w||';','; ',';'),' ;',';');			

				-- Remover virgulas duplicadas
				ds_horarios_w	:= replace(ds_horarios_w,';',' ');
				
				-- Remover espacamento inicial
				while(ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') and (substr(ds_horarios_w,1,1) = ' ') loop
					ds_horarios_w	:= substr(ds_horarios_w,2,length(ds_horarios_w));
				end loop;
				
				ds_texto_w		:= ds_horarios_w;
				ds_horarios_w	:= '';

				while(ds_texto_w IS NOT NULL AND ds_texto_w::text <> '') loop
					index_space			:= position(' ' in ds_texto_w);
					index_divider			:= position(';' in ds_texto_w);
					if (index_space = 0) then
						index_space		:= index_divider;
					end if;
					ds_horarios_w	:= substr(ds_horarios_w || substr(ds_texto_w,1,index_space-1) || ' ',1,4000);
					ds_texto_w		:= substr(substr(ds_texto_w,index_divider+1,length(ds_texto_w)),1,4000);
				end loop;
			end if;
		end if;
		end;
	end if;	

	ds_data_hor_w := substr(dt_hora_inicio_w,1,10);
	ds_data_w 	 := substr(dt_hora_inicio_w,1,16) || ':00';
	dt_atual_w   := to_date(ds_data_w,'dd/mm/yyyy hh24:mi:ss');
	ds_hor_sae_w := '';
	ds_hor_ant_w := ' ';


	if (ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') then
		open C01;
		loop
		fetch C01 into
			ds_horario_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			
			if (ds_horario_w <> ' ') then
										
				if (substr(ds_horario_w,1,2) = '24') then
					ds_horario_w := '00';
				end if;
							
				if (length(ds_horario_w) > 2) then
					if (position(':' in ds_horario_w) = 0) then
						ds_horario_w := substr(ds_horario_w,1,2)||':'||substr(ds_horario_w,3,4);
					else
						ds_horario_w := substr(ds_horario_w,1,5);
					end if;
				else
					ds_horario_w := ds_horario_w ||':00';
				end if;
				
				if (ds_hor_ant_w <> ' ') and (ds_hor_ant_w <> ds_horario_w) then				
					dt_atual_w   := to_date(ds_data_w,'dd/mm/yyyy hh24:mi:ss');
					ds_hor_ant_w := ' ';
				end if;
							
				if (substr(ds_horario_w,1,2) < '24') then
					if  ((ds_data_hor_w || ' ' || ds_horario_w || ':00') >= ds_data_w) then
						ds_form_hor_w := ds_horario_w;
					else
						ds_form_hor_w := ds_horario_w;
						if (ds_hor_ant_w = ' ') then --so vem vazio no primeiro dia
							dt_atual_w := dt_atual_w + 1;
						end if;
					end if;
					
					qt_vezes_w := dt_atual_w - to_date(ds_data_w,'dd/mm/yyyy hh24:mi:ss');
					
					if (qt_vezes_w > 0) and (qt_vezes_w <= 15)  then
						i := 0;					
						FOR i IN 1..qt_vezes_w LOOP
							ds_form_hor_w := 'A'||ds_form_hor_w;
						END LOOP;
					end if;
					ds_hor_sae_w := substr(ds_hor_sae_w|| ' ' || ds_form_hor_w,1,2000);
				end if;
			end if;
			end;
			dt_atual_w := dt_atual_w + 1;
			ds_hor_ant_w := ds_horario_w;
		end loop;
		close C01;
	end if;
	end;
end if;

return trim(both ds_hor_sae_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION padroniza_horario_sae ( ds_horarios_p text, dt_hora_inicio_p text, dt_hora_inicio_val_p text, dt_inicio_interv_p timestamp default null, dt_fim_validade_p timestamp default null, cd_intervalo_p intervalo_prescricao.cd_intervalo%type default null) FROM PUBLIC;
