-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_hist_saude_medic (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(4000);
cd_unid_med_w		varchar(30);
qt_dose_w		double precision;
cd_intervalo_w		varchar(80);
dt_inicio_w		timestamp;
dt_fim_w		timestamp;
ds_reacao_w		varchar(255);
ds_observacao_w		varchar(255);
ds_duracao_w		varchar(20);


BEGIN

select	cd_unid_med,
	qt_dose,
	substr(obter_desc_intervalo_prescr(cd_intervalo),1,80) cd_intervalo,
	dt_inicio,
	dt_fim,
	ds_reacao,
	ds_observacao,
	substr(obter_idade(dt_inicio,coalesce(dt_fim,clock_timestamp()),'S'),1,20)
into STRICT	cd_unid_med_w,
	qt_dose_w,
	cd_intervalo_w,
	dt_inicio_w,
	dt_fim_w,
	ds_reacao_w,
	ds_observacao_w,
	ds_duracao_w
from	paciente_medic_uso
where	nr_sequencia	= nr_sequencia_p;

ds_retorno_w	:= Wheb_mensagem_pck.get_texto(309582) || '  ' /*'Desde  '*/||to_char(dt_inicio_w,'dd/mm/yyyy')|| chr(13) || chr(10);

if (dt_fim_w IS NOT NULL AND dt_fim_w::text <> '') then
	ds_retorno_w	:= Wheb_mensagem_pck.get_texto(309582) || '  ' /*'Desde  '*/||to_char(dt_inicio_w,'dd/mm/yyyy')|| ' ' || lower(Wheb_mensagem_pck.get_texto(309583)) || ' ' /*' até '*/||to_char(dt_fim_w,'dd/mm/yyyy')|| '   ' || Wheb_mensagem_pck.get_texto(309584) || ' ' /*'   Duração '*/||ds_duracao_w||chr(13) || chr(10);
end if;

if (cd_unid_med_w IS NOT NULL AND cd_unid_med_w::text <> '') or (qt_dose_w IS NOT NULL AND qt_dose_w::text <> '') or (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '') then
	ds_retorno_w	:= ds_retorno_w ||qt_dose_w||' '||cd_unid_med_w||' '||cd_intervalo_w || chr(13) || chr(10);
end if;

if (ds_reacao_w IS NOT NULL AND ds_reacao_w::text <> '') then
	ds_retorno_w	:= ds_retorno_w ||Wheb_mensagem_pck.get_texto(309589) || '  ' /*'Reação  '*/||ds_reacao_w|| chr(13) || chr(10);
end if;

if (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') then
	ds_retorno_w	:= ds_retorno_w ||Wheb_mensagem_pck.get_texto(309588) || '  ' /*'Observação  '*/||ds_observacao_w|| chr(13) || chr(10);
end if;

return ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_hist_saude_medic (nr_sequencia_p bigint) FROM PUBLIC;
