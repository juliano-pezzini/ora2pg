-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_se_result_relev ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_exame_p bigint, nr_seq_material_p bigint, ds_resultado_p text, qt_resultado_p bigint, pr_resultado_p bigint) RETURNS varchar AS $body$
DECLARE


ie_resultado_relevante_w	varchar(1);
ie_tipo_valor_w 		smallint;
qt_dias_w			double precision;
qt_horas_w			bigint;
ie_sexo_w			varchar(1);
nm_exame_w			varchar(255);
ie_formato_resultado_w		varchar(4);
qt_casas_decimais_dias_w	bigint := 2;
cd_estabelecimento_w		prescr_medica.cd_estabelecimento%type;


BEGIN

ie_resultado_relevante_w := 'N';

qt_dias_w := 0;
qt_horas_w := 0;

ie_formato_resultado_w := Obter_formato_result_exame(nr_seq_exame_p, nr_seq_material_p);

select	Obter_dias_entre_datas_lab(obter_nascimento_prescricao(nr_prescricao_p),clock_timestamp()),
	Obter_Hora_Entre_datas(obter_nascimento_prescricao(nr_prescricao_p),clock_timestamp()),
	Obter_sexo_prescricao(nr_prescricao_p)
into STRICT	qt_dias_w,
	qt_horas_w,
	ie_sexo_w
;

select 	coalesce(max(cd_estabelecimento),0)
into STRICT	cd_estabelecimento_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;

select	CASE WHEN coalesce(max(ie_idade_int_val_ref), 'N')='N' THEN  2  ELSE 0 END
into STRICT	qt_casas_decimais_dias_w
from	lab_parametro
where 	cd_estabelecimento = cd_estabelecimento_w;

if (ie_formato_resultado_w = 'P') then
	begin
		select ie_tipo_valor
		into STRICT	 ie_tipo_valor_w
		from exame_lab_padrao
		where ((ie_sexo = coalesce(ie_sexo_w,'0')) or (ie_sexo = '0'))
		  and coalesce(ie_gera_alerta,'N') = 'S'
		  and nr_seq_exame = nr_seq_exame_p
		  and (((coalesce(trunc((qt_dias_w / 365.25),qt_casas_decimais_dias_w),0) between qt_idade_min and qt_idade_max) and (ie_periodo = 'A')) or
			 ((coalesce(trunc(((qt_dias_w / 365.25) * 12),qt_casas_decimais_dias_w),0) between qt_idade_min and qt_idade_max) and (ie_periodo = 'M')) or
			 (((coalesce(qt_dias_w,0)) between qt_idade_min and qt_idade_max) and (ie_periodo = 'D')) or
			 (((coalesce(qt_horas_w,0)) between qt_idade_min and qt_idade_max) and (ie_periodo = 'H')))
		  and pr_resultado_p between qt_percent_min and qt_percent_max
		  and coalesce(ie_situacao,'A') = 'A'
		order by nr_seq_material, ie_sexo, ie_tipo_valor;
	exception
		when others then
			ie_tipo_valor_w := 0;
	end;


	if (ie_tipo_valor_w = 4) then
		ie_resultado_relevante_w := 'S';
	end if;

elsif (ie_formato_resultado_w = 'V') then
	begin
		select coalesce(max(ie_tipo_valor),0)
		into STRICT	 ie_tipo_valor_w
		from exame_lab_padrao
		where ((ie_sexo = coalesce(ie_sexo_w,'0')) or (ie_sexo = '0'))
		  and nr_seq_exame = nr_seq_exame_p
		  and coalesce(ie_gera_alerta,'N') = 'S'
		  and (((coalesce(trunc((qt_dias_w / 365.25),qt_casas_decimais_dias_w),0) between qt_idade_min and qt_idade_max) and (ie_periodo = 'A')) or
			 ((coalesce(trunc(((qt_dias_w / 365.25) * 12),qt_casas_decimais_dias_w),0) between qt_idade_min and qt_idade_max) and (ie_periodo = 'M')) or
			 (((coalesce(qt_dias_w,0)) between qt_idade_min and qt_idade_max) and (ie_periodo = 'D')) or
			 (((coalesce(qt_horas_w,0)) between qt_idade_min and qt_idade_max) and (ie_periodo = 'H')))
		  and qt_resultado_p between qt_minima and qt_maxima
		  and coalesce(ie_situacao,'A') = 'A'
		order by nr_seq_material, ie_sexo, ie_tipo_valor;
	exception
		when others then
			ie_tipo_valor_w := 0;
	end;

	if (ie_tipo_valor_w = 4) then
		ie_resultado_relevante_w := 'S';
	end if;

elsif	((ie_formato_resultado_w = 'D') or (ie_formato_resultado_w = 'SM') or (ie_formato_resultado_w = 'SDM')) then
	begin
		select ie_tipo_valor
		into STRICT	 ie_tipo_valor_w
		from exame_lab_padrao
		where ((ie_sexo = coalesce(ie_sexo_w,'0')) or (ie_sexo = '0'))
		  and nr_seq_exame = nr_seq_exame_p
		  and coalesce(ie_gera_alerta,'N') = 'S'
		  and (((coalesce(trunc((qt_dias_w / 365.25),qt_casas_decimais_dias_w),0) between qt_idade_min and qt_idade_max) and (ie_periodo = 'A')) or
			 ((coalesce(trunc(((qt_dias_w / 365.25) * 12),qt_casas_decimais_dias_w),0) between qt_idade_min and qt_idade_max) and (ie_periodo = 'M')) or
			 (((coalesce(qt_dias_w,0)) between qt_idade_min and qt_idade_max) and (ie_periodo = 'D')) or
			 (((coalesce(qt_horas_w,0)) between qt_idade_min and qt_idade_max) and (ie_periodo = 'H')))
		  and upper(ELIMINA_ACENTOS(ds_resultado_p)) like upper(ELIMINA_ACENTOS(DS_OBSERVACAO))
		  and coalesce(ie_situacao,'A') = 'A'
		order by nr_seq_material, ie_sexo;
	exception
		when others then
			ie_tipo_valor_w := 0;
	end;

	if (ie_tipo_valor_w = 4) then
		ie_resultado_relevante_w := 'S';
	end if;

elsif (ie_formato_resultado_w = 'DV') then

	if (ds_resultado_p IS NOT NULL AND ds_resultado_p::text <> '') then
		if  ((ds_resultado_p <> somente_numero_virg_char(ds_resultado_p)) or (coalesce(somente_numero_virg_char(ds_resultado_p)::text, '') = '')) then

			begin
				select coalesce(max(ie_tipo_valor),0)
				into STRICT	 ie_tipo_valor_w
				from exame_lab_padrao
				where ((ie_sexo = coalesce(ie_sexo_w,'0')) or (ie_sexo = '0'))
				  and nr_seq_exame = nr_seq_exame_p
				  and coalesce(ie_gera_alerta,'N') = 'S'
				  and (((coalesce(trunc((qt_dias_w / 365.25),qt_casas_decimais_dias_w),0) between qt_idade_min and qt_idade_max) and (ie_periodo = 'A')) or
					 ((coalesce(trunc(((qt_dias_w / 365.25) * 12),qt_casas_decimais_dias_w),0) between qt_idade_min and qt_idade_max) and (ie_periodo = 'M')) or
					 (((coalesce(qt_dias_w,0)) between qt_idade_min and qt_idade_max) and (ie_periodo = 'D')) or
					 (((coalesce(qt_horas_w,0)) between qt_idade_min and qt_idade_max) and (ie_periodo = 'H')))
				  and upper(ELIMINA_ACENTOS(trim(both ds_resultado_p))) like upper(ELIMINA_ACENTOS(trim(both DS_OBSERVACAO)))
				  and coalesce(ie_situacao,'A') = 'A'
				order by nr_seq_material, ie_sexo;

			exception
				when others then
					ie_tipo_valor_w := 0;
			end;

		else

			begin
				select coalesce(max(ie_tipo_valor),0)
				into STRICT	 ie_tipo_valor_w
				from exame_lab_padrao
				where ((ie_sexo = coalesce(ie_sexo_w,'0')) or (ie_sexo = '0'))
				  and nr_seq_exame = nr_seq_exame_p
				  and coalesce(ie_gera_alerta,'N') = 'S'
				  and (((coalesce(trunc((qt_dias_w / 365.25),qt_casas_decimais_dias_w),0) between qt_idade_min and qt_idade_max) and (ie_periodo = 'A')) or
					 ((coalesce(trunc(((qt_dias_w / 365.25) * 12),qt_casas_decimais_dias_w),0) between qt_idade_min and qt_idade_max) and (ie_periodo = 'M')) or
					 (((coalesce(qt_dias_w,0)) between qt_idade_min and qt_idade_max) and (ie_periodo = 'D')) or
					 (((coalesce(qt_horas_w,0)) between qt_idade_min and qt_idade_max) and (ie_periodo = 'H')))
				  and ds_resultado_p between qt_minima and qt_maxima
				  and coalesce(ie_situacao,'A') = 'A'
				order by nr_seq_material, ie_sexo, ie_tipo_valor;
			exception
				when others then
					ie_tipo_valor_w := 0;
			end;
		end if;
	else
		begin
			select coalesce(max(ie_tipo_valor),0)
			into STRICT	 ie_tipo_valor_w
			from exame_lab_padrao
			where ((ie_sexo = coalesce(ie_sexo_w,'0')) or (ie_sexo = '0'))
			  and nr_seq_exame = nr_seq_exame_p
			  and coalesce(ie_gera_alerta,'N') = 'S'
			  and (((coalesce(trunc((qt_dias_w / 365.25),qt_casas_decimais_dias_w),0) between qt_idade_min and qt_idade_max) and (ie_periodo = 'A')) or
				 ((coalesce(trunc(((qt_dias_w / 365.25) * 12),qt_casas_decimais_dias_w),0) between qt_idade_min and qt_idade_max) and (ie_periodo = 'M')) or
				 (((coalesce(qt_dias_w,0)) between qt_idade_min and qt_idade_max) and (ie_periodo = 'D')) or
				 (((coalesce(qt_horas_w,0)) between qt_idade_min and qt_idade_max) and (ie_periodo = 'H')))
			  and qt_resultado_p between qt_minima and qt_maxima
			  and coalesce(ie_situacao,'A') = 'A'
			order by nr_seq_material, ie_sexo, ie_tipo_valor;
		exception
			when others then
				ie_tipo_valor_w := 0;
		end;
	end if;

	if (ie_tipo_valor_w = 4) then
		ie_resultado_relevante_w := 'S';
	end if;

end if;

return ie_resultado_relevante_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_se_result_relev ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_exame_p bigint, nr_seq_material_p bigint, ds_resultado_p text, qt_resultado_p bigint, pr_resultado_p bigint) FROM PUBLIC;

