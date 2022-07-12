-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_valor_ref_res ( nr_atendimento_p bigint, nr_seq_prescr_p bigint, nr_seq_exame_p bigint, ie_opcao_p bigint) RETURNS bigint AS $body$
DECLARE


qt_dias_w					double precision	:= 0;
qt_horas_w					bigint	:= 0;
qt_minima_w					double precision;
qt_maxima_w					double precision;
pr_minimo_w					double precision;
pr_maximo_w					double precision;
ds_refer_w					bigint;
ie_sexo_w					varchar(1);
nr_seq_material_w			bigint;
nr_seq_metodo_w				bigint;
qt_casas_decimais_dias_w	bigint := 2;
cd_estabelecimento_w		atendimento_paciente.cd_estabelecimento%type;
cd_pessoa_fisica_w			exame_lab_resultado.cd_pessoa_fisica%type;

/*
IE_OPCAO_P:
1 = Valor de referência mínimo
2 = Valor de referência máximo
*/
BEGIN

select	coalesce(max(a.nr_seq_material),0),
		coalesce(max(a.nr_seq_metodo),0),
		coalesce(max(b.cd_pessoa_fisica),obter_pessoa_atendimento(nr_Atendimento_p,'C'))
into STRICT	nr_seq_material_w,
		nr_seq_metodo_w,
		cd_pessoa_fisica_w
from	exame_lab_result_item a,
		exame_lab_resultado b
where	a.nr_seq_resultado = b.nr_seq_resultado
and		b.nr_atendimento = nr_atendimento_p
and		a.nr_seq_prescr = nr_seq_prescr_p
and		a.nr_seq_exame = nr_seq_exame_p;


select	obter_dias_entre_datas_lab(obter_dados_pf(cd_pessoa_fisica_w,'DN'),clock_timestamp()),
		substr(obter_dados_pf(cd_pessoa_fisica_w,'SE'),1,1),
		Obter_Hora_Entre_datas(obter_dados_pf(cd_pessoa_fisica_w,'DN'),clock_timestamp()),
		obter_estab_atendimento(nr_atendimento_p)
into STRICT	qt_dias_w,
		ie_sexo_w,
		qt_horas_w,
		cd_estabelecimento_w
;


select	CASE WHEN coalesce(max(ie_idade_int_val_ref), 'N')='N' THEN  2  ELSE 0 END
into STRICT	qt_casas_decimais_dias_w
from	lab_parametro
where	cd_estabelecimento = cd_estabelecimento_w;

select 	qt_minima,
		qt_maxima,
		qt_percent_min,
		qt_percent_max
into STRICT	qt_minima_w,
		qt_maxima_w,
		pr_minimo_w,
		pr_maximo_w
from (
		SELECT 	qt_minima,
				qt_maxima,
				qt_percent_min,
				qt_percent_max
		from 	exame_lab_padrao
		where 	((ie_sexo = ie_sexo_w) or (ie_sexo = '0'))
		and 	nr_seq_exame = nr_seq_exame_p
		and 	coalesce(nr_seq_material,nr_seq_material_w) = nr_seq_material_w
		and 	coalesce(nr_seq_metodo, nr_seq_metodo_w) = nr_seq_metodo_w
		and 	(((trunc((qt_dias_w / 365.25),qt_casas_decimais_dias_w) between coalesce(qt_idade_min,0) and coalesce(qt_idade_max,99999)) and (ie_periodo = 'A')) or
				((trunc(((qt_dias_w / 365.25) * 12),qt_casas_decimais_dias_w) between coalesce(qt_idade_min,0) and coalesce(qt_idade_max,99999)) and (ie_periodo = 'M')) or
				((qt_dias_w between coalesce(qt_idade_min,0) and coalesce(qt_idade_max,99999)) and (ie_periodo = 'D')) or
				((qt_horas_w between coalesce(qt_idade_min,0) and coalesce(qt_idade_max,99999)) and (ie_periodo = 'H')))
		and 	ie_tipo_valor in (0,3)
		and coalesce(ie_situacao,'A') = 'A'
		order by coalesce(nr_seq_material, 9999999999), coalesce(nr_seq_metodo, 9999999999), ie_sexo, CASE WHEN ie_periodo='D' THEN 1 WHEN ie_periodo='M' THEN 2  ELSE 3 END ) alias35 LIMIT 1;


if (ie_opcao_p = 1) then
	ds_refer_w := coalesce(qt_minima_w,pr_minimo_w);
elsif (ie_opcao_p = 2) then
	ds_refer_w := coalesce(qt_maxima_w,pr_maximo_w);
end if;

return	ds_refer_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_valor_ref_res ( nr_atendimento_p bigint, nr_seq_prescr_p bigint, nr_seq_exame_p bigint, ie_opcao_p bigint) FROM PUBLIC;
