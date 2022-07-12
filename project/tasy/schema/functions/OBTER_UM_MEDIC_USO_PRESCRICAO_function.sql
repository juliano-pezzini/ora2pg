-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_um_medic_uso_prescricao (nr_prescricao_p bigint, nr_seq_medicamento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


qt_dose_w           		varchar(50);
cd_unidade_medida_dose_w	varchar(30);
ds_prescricao_w				varchar(60);
ie_via_w					varchar(05);
ds_retorno_w				varchar(50);


BEGIN

if (ie_opcao_p = 'N') then
	select	coalesce(max(a.qt_dose),0),
		coalesce(max(a.cd_unidade_medida_dose),''),
		coalesce(max(b.ds_prescricao),''),
		coalesce(max(a.ie_via_aplicacao),'')
	into STRICT	qt_dose_w,
		cd_unidade_medida_dose_w,
		ds_prescricao_w,
		ie_via_w
	FROM intervalo_prescricao b
LEFT OUTER JOIN prescr_material a ON (b.cd_intervalo = a.cd_intervalo)
WHERE a.nr_sequencia		= nr_seq_medicamento_p and a.nr_prescricao		= nr_prescricao_p;
end if;


IF (SUBSTR(qt_dose_w,1,1) = ',') THEN
	qt_dose_w	:= '0'|| qt_dose_w;
	qt_dose_w	:= REPLACE(qt_dose_w,'.',',');

END IF;


ds_retorno_w	:= qt_dose_w|| ' ' ||cd_unidade_medida_dose_w||'   '||ds_prescricao_w||'   '||ie_via_w;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_um_medic_uso_prescricao (nr_prescricao_p bigint, nr_seq_medicamento_p bigint, ie_opcao_p text) FROM PUBLIC;
