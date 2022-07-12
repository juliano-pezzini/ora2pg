-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_se_result_nao_aceit (nr_seq_exame_result_p bigint, ds_resultado_p text, qt_resultado_p bigint, pr_resultado_p bigint, nr_seq_prescr_p bigint, nr_prescricao_p bigint, nr_seq_exame_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1);
ie_tipo_valor_w 	smallint;
qt_dias_w		double precision	:= 0;
qt_horas_w		bigint	:= 0;
ie_sexo_w		varchar(1);
nr_seq_material_w	bigint;
ie_formato_resultado_w	varchar(3);
qt_casas_decimais_dias_w	bigint := 2;
cd_estabelecimento_w		prescr_medica.cd_estabelecimento%type;


BEGIN

ds_retorno_w := 'N';

ie_sexo_w := obter_sexo_prescricao(nr_prescricao_p);

select 	obter_dias_entre_datas_lab(obter_nascimento_prescricao(nr_prescricao_p),clock_timestamp()),
	Obter_Hora_Entre_datas(obter_nascimento_prescricao(nr_prescricao_p),clock_timestamp())
into STRICT 	qt_dias_w,
	qt_horas_w
;

select 	MAX(a.nr_sequencia)
into STRICT	nr_seq_material_w
from	material_exame_lab a,
	prescr_procedimento b
where  	a.cd_material_exame = b.cd_material_exame
and	b.nr_prescricao = nr_prescricao_p
and	b.nr_sequencia = nr_seq_prescr_p;

select	coalesce(max(cd_estabelecimento),0)
into STRICT	cd_estabelecimento_w
from 	prescr_medica
where	nr_prescricao = nr_prescricao_p;

select	CASE WHEN coalesce(max(ie_idade_int_val_ref), 'N')='N' THEN  2  ELSE 0 END
into STRICT	qt_casas_decimais_dias_w
from 	lab_parametro
where	cd_estabelecimento = cd_estabelecimento_w;

ie_formato_resultado_w :=  obter_formato_result_exame(nr_seq_exame_p, nr_seq_material_w);


if (ie_formato_resultado_w = 'P') then
			begin
			select ie_tipo_valor
			into STRICT	 ie_tipo_valor_w
			from exame_lab_padrao
			where ((ie_sexo = coalesce(ie_sexo_w,'0')) or (ie_sexo = '0'))
			  and nr_seq_exame = nr_seq_exame_p
			  and coalesce(nr_seq_material,nr_seq_material_w) = nr_seq_material_w
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


			if (ie_tipo_valor_w = 2) then
				ds_retorno_w := 'S';
			end if;

		elsif (ie_formato_resultado_w = 'V') then
			begin
			select coalesce(max(ie_tipo_valor),0)
			into STRICT	 ie_tipo_valor_w
			from exame_lab_padrao
			where ((ie_sexo = coalesce(ie_sexo_w,'0')) or (ie_sexo = '0'))
			  and nr_seq_exame = nr_seq_exame_p
			  and coalesce(nr_seq_material,nr_seq_material_w) = nr_seq_material_w
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

			if (ie_tipo_valor_w = 2) then
				ds_retorno_w := 'S';
			end if;

		elsif	((ie_formato_resultado_w = 'D') or (ie_formato_resultado_w = 'S') or (ie_formato_resultado_w = 'SM')) then
			begin
			select ie_tipo_valor
			into STRICT	 ie_tipo_valor_w
			from exame_lab_padrao
			where ((ie_sexo = coalesce(ie_sexo_w,'0')) or (ie_sexo = '0'))
			  and nr_seq_exame = nr_seq_exame_p
			  and coalesce(nr_seq_material,nr_seq_material_w) = nr_seq_material_w
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

			if (ie_tipo_valor_w = 2) then
				ds_retorno_w := 'S';
			end if;
		end if;




return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_se_result_nao_aceit (nr_seq_exame_result_p bigint, ds_resultado_p text, qt_resultado_p bigint, pr_resultado_p bigint, nr_seq_prescr_p bigint, nr_prescricao_p bigint, nr_seq_exame_p bigint) FROM PUBLIC;

