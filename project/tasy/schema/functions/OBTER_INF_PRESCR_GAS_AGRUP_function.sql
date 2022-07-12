-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_inf_prescr_gas_agrup (nr_seq_gas_cpoe_p cpoe_gasoterapia.nr_sequencia%type, ie_mostra_data_gas_p text) RETURNS varchar AS $body$
DECLARE


nr_prescricao_w			prescr_medica.nr_prescricao%type;
dt_prescricao_w			prescr_medica.dt_prescricao%type;
nr_seq_gasoterapia_w	prescr_gasoterapia.nr_sequencia%type;
qt_gasoterapia_w		prescr_gasoterapia.qt_gasoterapia%type;
cd_intervalo_w			prescr_gasoterapia.cd_intervalo%type;
ie_unidade_medica_w		prescr_gasoterapia.ie_unidade_medida%type;
ie_inicio_w				prescr_gasoterapia.ie_inicio%type;

ds_prescricao_w			varchar(4000);
ds_espacamento_w		varchar(2);
								

BEGIN

ds_espacamento_w	:= ' ';
ds_prescricao_w		:= '';

--Obtém a última prescricao vigente
select	max(a.nr_sequencia)
into STRICT	nr_seq_gasoterapia_w
from	prescr_gasoterapia		a
where	a.nr_seq_gas_cpoe	= nr_seq_gas_cpoe_p
and		obter_se_prescr_vigente(a.nr_prescricao) = 'S';

if (nr_seq_gasoterapia_w IS NOT NULL AND nr_seq_gasoterapia_w::text <> '') then
	--Obtém as informações da última prescrição vigente
	select	max(a.qt_gasoterapia),
			max(a.cd_intervalo),
			max(a.ie_unidade_medida),
			max(a.ie_inicio),
			max(b.dt_prescricao)
	into STRICT	qt_gasoterapia_w,
			cd_intervalo_w,
			ie_unidade_medica_w,
			ie_inicio_w,
			dt_prescricao_w
	from	prescr_gasoterapia		a,
			prescr_medica			b
	where	b.nr_prescricao		= a.nr_prescricao
	and		a.nr_sequencia		= nr_seq_gasoterapia_w;

	ds_prescricao_w	:= coalesce(cpoe_obter_vel_inf_gas(nr_seq_gas_cpoe_p),qt_gasoterapia_w);
	ds_prescricao_w	:= ds_prescricao_w || ds_espacamento_w;
	ds_prescricao_w	:= ds_prescricao_w || coalesce(Obter_ie_unidade_gas(nr_seq_gasoterapia_w), ie_unidade_medica_w);
	ds_prescricao_w	:= ds_prescricao_w || ds_espacamento_w || ds_espacamento_w;
	ds_prescricao_w	:= ds_prescricao_w || obter_desc_intervalo(cd_intervalo_w);
	ds_prescricao_w	:= ds_prescricao_w || ds_espacamento_w;
	ds_prescricao_w	:= ds_prescricao_w || obter_desc_expressao(648277); --Início:
	ds_prescricao_w	:= ds_prescricao_w || ds_espacamento_w;
	ds_prescricao_w	:= ds_prescricao_w || obter_valor_dominio(2569,ie_inicio_w);
	
	if (ie_mostra_data_gas_p = 'S') then
		ds_prescricao_w	:= ds_prescricao_w || ds_espacamento_w;
		ds_prescricao_w	:= ds_prescricao_w || obter_desc_expressao(888270); --Dt. Prescr.:
		ds_prescricao_w	:= ds_prescricao_w || ds_espacamento_w;
		ds_prescricao_w	:= ds_prescricao_w || to_char(dt_prescricao_w,'dd/mm/yyyy hh24:mi:ss');
	end if;
end if;

return	substr(ds_prescricao_w,1,2000);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_inf_prescr_gas_agrup (nr_seq_gas_cpoe_p cpoe_gasoterapia.nr_sequencia%type, ie_mostra_data_gas_p text) FROM PUBLIC;
