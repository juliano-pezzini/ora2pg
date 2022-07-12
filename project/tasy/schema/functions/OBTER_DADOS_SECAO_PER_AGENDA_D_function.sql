-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_secao_per_agenda_d ( nr_seq_agenda_p bigint, ie_diario_p text, ie_final_semana_p text, ie_opcao_p text, ds_dias_p text) RETURNS varchar AS $body$
DECLARE


qt_dia_w			smallint;
qt_total_secao_w	smallint;
nr_secao_w			smallint;
dt_agenda_w			timestamp;
dt_atual_w			timestamp;
cd_dia_semana_w		varchar(1);
ds_retorno_w		varchar(255);
ie_bloqueio_w		varchar(1);
ie_existe_turno_w	varchar(1);
ds_dias_w		varchar(255);
ie_gerar_dia_w		varchar(1)  := 'S';
qt_feriado_dia_w	bigint;
ie_agenda_feriado_w	varchar(1);
cd_agenda_w			bigint;
cd_estabelecimento_w		smallint;	
ie_existe_livre_w  varchar(1);
ie_dia_gerado_w  varchar(1);
qt_tentativas_w	bigint := 2000;
qt_tentativas_atual_w bigint := 0;


/*
D - end date
S - Number of Sections in the period
*/
BEGIN

if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') then
	begin
	/* get schedule data */

	select	max(coalesce(a.nr_secao,1)),
			max(a.dt_agenda),
			max(coalesce(a.qt_total_secao,0)),
			max(b.cd_estabelecimento)
	into STRICT	nr_secao_w,
			dt_agenda_w,
			qt_total_secao_w,
			cd_estabelecimento_w
	from	agenda_consulta a,
		agenda b
	where	a.cd_agenda = b.cd_agenda
	and	a.nr_sequencia = nr_seq_agenda_p;
	
	if (ds_dias_p IS NOT NULL AND ds_dias_p::text <> '') then
	
		ds_dias_w := ds_dias_p;
		
		if (ie_final_semana_p = 'N') then
			
			if not( (obter_se_contido('2' ,ds_dias_w) = 'S') or (obter_se_contido('3' ,ds_dias_w) = 'S') or (obter_se_contido('4' ,ds_dias_w) = 'S') or (obter_se_contido('5' ,ds_dias_w) = 'S') or (obter_se_contido('6' ,ds_dias_w) = 'S'))  then
					qt_total_secao_w := 0;
			end if;	
		
		end if;
		
	end if;
	
	--nr_secao_w	:= 1;
	dt_atual_w	:= dt_agenda_w;
	if (qt_total_secao_w > 0) then
		
		while(nr_secao_w < qt_total_secao_w and qt_tentativas_atual_w < qt_tentativas_w) loop
			begin
			dt_atual_w	:= dt_atual_w + 1;
			select	substr(Obter_Cod_Dia_Semana(dt_atual_w),1,1)
			into STRICT	cd_dia_semana_w
			;	
						
			if (ie_final_semana_p = 'N') and
				((cd_dia_semana_w = 1) or (cd_dia_semana_w = 7))then
					
				if (cd_dia_semana_w = 1) then
					--IF IT DOES NOT GENERATE ON THE WEEKEND, IF IT IS SUNDAY(1) ADD +1 DAY TO THE CURRENT DATE
					dt_atual_w	:= dt_atual_w + 1;
				elsif (cd_dia_semana_w = 7) then
						--IF IT DOES NOT GENERATE ON THE WEEKEND, IF IT IS SATURDAY(7) ADD +2 DAYS TO THE CURRENT DATE
					dt_atual_w	:= dt_atual_w + 2;
				end if;
				
				select	substr(Obter_Cod_Dia_Semana(dt_atual_w),1,1)
				into STRICT	cd_dia_semana_w
				;	
				
			end if;
			
			--VALIDATE IF THERE IS A HOLIDAY IN THE MIDDLE OF THE GENERATION PERIOD OF THE SCHEDULE DAYS
			select	coalesce(max(obter_se_feriado(cd_estabelecimento_w, dt_atual_w)), 0)
			into STRICT	qt_feriado_dia_w
			;
			
			--SEARCH CODE. FROM THE SCHEDULE TO VERIFY IF SCHEDULE IS ALLOWED ON DAYS THAT ARE HOLIDAYS
			select	coalesce(max(cd_agenda), 0)
			into STRICT	cd_agenda_w
			from	agenda_consulta
			where	nr_sequencia	= nr_seq_agenda_p;
			
			if (cd_agenda_w > 0)then
				begin
				
				select 	coalesce(max(ie_feriado),'N')
				into STRICT	ie_agenda_feriado_w
				from	agenda
				where	cd_agenda = cd_agenda_w;
				
				end;			
			end if;
			
			/* validate time x lock */

			select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
			into STRICT	ie_bloqueio_w
			from	agenda_bloqueio
			where	cd_agenda = cd_agenda_w
			and	dt_final >= trunc(dt_atual_w)
			and	dt_inicial <= trunc(dt_atual_w)
			AND (TO_CHAR(hr_final_bloqueio,'hh24:mi:ss') >= TO_CHAR(dt_atual_w,'hh24:mi') 
				OR coalesce(hr_final_bloqueio::text, '') = '')
			AND (TO_CHAR(hr_inicio_bloqueio, 'hh24:mi:ss') <= TO_CHAR(dt_atual_w,'hh24:mi') 
				OR coalesce(hr_inicio_bloqueio::text, '') = '')
			and	((coalesce(ie_dia_semana::text, '') = '') or (ie_dia_semana = cd_dia_semana_w));
			
			/*
			SHIFT TERMS:
			*/
			select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
			into STRICT	ie_existe_turno_w
			from   	agenda_turno
			where  	cd_agenda       	= 	cd_agenda_w
			and    	((ie_dia_semana   	= 	cd_dia_semana_w) 
				or (ie_dia_semana = 9))
			AND	TO_CHAR(hr_final, 'hh24:mi:ss') >= TO_CHAR(dt_atual_w,'hh24:mi:ss')
			AND	TO_CHAR(hr_inicial, 'hh24:mi:ss') <= TO_CHAR(dt_atual_w,'hh24:mi:ss');	
			
			/* validate if there is a schedule */

			select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
			into STRICT	ie_existe_livre_w
			from	agenda_consulta
			where	cd_agenda = cd_agenda_w
			and  dt_agenda = dt_atual_w
			and 	ie_status_agenda = 'L';
			
			/*Validate if day was generated*/

			select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
			into STRICT	ie_dia_gerado_w
			from	agenda_consulta
			where	cd_agenda = cd_agenda_w
			and  dt_agenda = dt_atual_w;
						
		
			if (ds_dias_w IS NOT NULL AND ds_dias_w::text <> '') then
				ie_gerar_dia_w	:=  obter_se_contido(cd_dia_semana_w, ds_dias_w);
			end if;
			
						
			if (ie_existe_turno_w = 'N') and (ie_gerar_dia_w = 'S') then
				ie_gerar_dia_w	:= 'N';			
			end if;
			
			if (ie_existe_livre_w = 'N' and ie_dia_gerado_w = 'S') and (ie_gerar_dia_w	= 'S')	then
				ie_gerar_dia_w	:= 'N';
			end if;
			
			if (ie_bloqueio_w = 'S') and (ie_gerar_dia_w = 'S')  then
				ie_gerar_dia_w	:= 'N';
			end if;	
			
			if (qt_feriado_dia_w > 0) and (ie_gerar_dia_w = 'S') and (ie_agenda_feriado_w = 'N')then
				ie_gerar_dia_w	:= 'N';
			end if;

			
			if (ie_gerar_dia_w	= 'S') then
				nr_secao_w	:= nr_secao_w + 1;
			else
				qt_tentativas_atual_w := qt_tentativas_atual_w + 1;
			end if;
	
			end;
		end loop;
	end if;
	
	if (qt_tentativas_atual_w = qt_tentativas_w) then
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(1058532);
	end if;
	
	if (ie_opcao_p = 'D') then
		ds_retorno_w	:= dt_atual_w;
	elsif (ie_opcao_p = 'S') then
		ds_retorno_w	:= nr_secao_w;
	end if;
	end;
end if;
	
return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_secao_per_agenda_d ( nr_seq_agenda_p bigint, ie_diario_p text, ie_final_semana_p text, ie_opcao_p text, ds_dias_p text) FROM PUBLIC;

