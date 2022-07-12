-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_medispan_frequency ( cd_intervalo_p intervalo_prescricao.cd_intervalo%type, ie_evento_unico_p intervalo_prescricao.ie_dose_unica_cpoe%type, ie_administracao_p intervalo_prescricao.ie_se_necessario%type, nr_ocorrencia_p cpoe_material.nr_ocorrencia%type, ds_opcao_p text ) RETURNS varchar AS $body$
DECLARE

	ds_return_w		varchar(255);
	ds_opcao_w		varchar(255);
	qt_dose_w		double precision;
	qt_frequencia_w	double precision;
	ds_operacao_w	varchar(255);
	ie_operacao_w	intervalo_prescricao.ie_operacao%type;
	qt_operacao_w	intervalo_prescricao.qt_operacao%type;
	ie_24_h_w		intervalo_prescricao.ie_24_h%type;
	qt_freq_days_w	double precision;
	qt_freq_week_w	double precision;
	
	ds_operation_day_w	constant varchar(10) := 'Day';
	ds_operation_hour_w	constant varchar(10) := 'Hour';
	ds_operation_week_w	constant varchar(10) := 'Week';

/*
	Para frequencia a API aceita horas, dias ou semanas
	Isto representa: [X] doses por [Y] [Z]
	[1] dose por [2] [dias]
	[1] dose por [7] [dias]
	[2] doses por [1] [dias]
	[1] dose a cada [12] [horas]
	
	X = Dosis
	Y = Interval
	Z = Unit (Day/Hour)
*/
BEGIN
	qt_dose_w := 0;
	qt_frequencia_w := 0;
	ds_operacao_w := '';
	ds_return_w := '';
	ds_opcao_w := upper(ds_opcao_p);
	
	if (coalesce(ie_evento_unico_p, 'N') = 'S') then
		qt_dose_w := 1;
		qt_frequencia_w := 1;
		ds_operacao_w := ds_operation_day_w;
	else
		select	coalesce(max(ie_operacao), ''),
				coalesce(max(qt_operacao), 1),
				coalesce(max(ie_24_h), 'N')
		  into STRICT	ie_operacao_w,
				qt_operacao_w,
				ie_24_h_w
		  from	intervalo_prescricao
		 where	cd_intervalo = cd_intervalo_p;

		if (ie_operacao_w = 'H') then
			qt_dose_w := 1;
			qt_frequencia_w := qt_operacao_w;
			ds_operacao_w := ds_operation_hour_w;
			
			if (ie_24_h_w = 'S') then
				qt_freq_days_w := qt_frequencia_w/24;
				/* Verifica se sao dias inteiros para converter grandes quantidades de horas em dias */

				if ((qt_freq_days_w - trunc(qt_freq_days_w, 0)) = 0) then
					qt_freq_week_w := qt_freq_days_w/7;
					/* Verifica se consegue converter os dias em semana cheia */

					if ((qt_freq_week_w - trunc(qt_freq_week_w, 0)) = 0) then
						qt_frequencia_w := qt_freq_week_w;
						ds_operacao_w := ds_operation_week_w;
					else
						qt_frequencia_w := qt_freq_days_w;
						ds_operacao_w := ds_operation_day_w;
					end if;
				end if;
			end if;
		elsif (ie_operacao_w in ('X', 'F', 'V', 'D')) then
			qt_dose_w := qt_operacao_w;
			qt_frequencia_w := 1;
			ds_operacao_w := ds_operation_day_w;
		end if;

	end if;

	if (ds_opcao_w = 'FREQUENCYDOSES') then
		ds_return_w := qt_dose_w;
	elsif (ds_opcao_w = 'FREQUENCY') then
		ds_return_w := qt_frequencia_w;
	elsif (ds_opcao_w = 'FREQUENCYUOM') then
		ds_return_w := ds_operacao_w;
	end if;

	return ds_return_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_medispan_frequency ( cd_intervalo_p intervalo_prescricao.cd_intervalo%type, ie_evento_unico_p intervalo_prescricao.ie_dose_unica_cpoe%type, ie_administracao_p intervalo_prescricao.ie_se_necessario%type, nr_ocorrencia_p cpoe_material.nr_ocorrencia%type, ds_opcao_p text ) FROM PUBLIC;

