-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_resultado_dia_lab_ant (cd_pessoa_fisica_p text, dt_referencia_p timestamp, nr_seq_exame_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_resultado_w			bigint;
nr_seq_resultado_prescr_w		bigint;
nr_seq_resultado_atual_w		bigint;
nr_seq_result_atual_prescr_w		bigint;
dt_digitacao_w				timestamp;

ds_resultado_w				varchar(90)	:= '0';


BEGIN

select 	coalesce(max(c.nr_seq_resultado),0)
into STRICT	nr_seq_resultado_atual_w
from	exame_laboratorio d,
	exame_lab_resultado a,
	exame_lab_result_item c
where	a.nr_seq_resultado 	= c.nr_seq_resultado
and	d.nr_seq_exame 		= c.nr_seq_exame
and	trunc(coalesce(c.dt_digitacao,dt_resultado),'dd') = trunc(dt_referencia_p,'dd')
and	a.cd_pessoa_fisica	= cd_pessoa_fisica_p
and	c.nr_seq_exame		= nr_seq_exame_p
and (coalesce(coalesce(CASE WHEN c.ds_resultado='0' THEN ''  ELSE CASE WHEN d.ie_formato_resultado='V' THEN ''  ELSE c.ds_resultado END  END ,	coalesce(to_char(c.qt_resultado),to_char(CASE WHEN c.pr_resultado=0 THEN ''  ELSE c.pr_resultado END ))),c.ds_resultado)) is not null;

select 	coalesce(max(c.nr_seq_resultado),0)
into STRICT	nr_seq_result_atual_prescr_w
from	exame_laboratorio d,
	exame_lab_resultado a,
	exame_lab_result_item c,
	prescr_medica b
where	a.nr_seq_resultado 	= c.nr_seq_resultado
and	d.nr_seq_exame 		= c.nr_seq_exame
and	trunc(c.dt_digitacao,'dd') = trunc(dt_referencia_p,'dd')
and	b.cd_pessoa_fisica	= cd_pessoa_fisica_p
and	c.nr_seq_exame		= nr_seq_exame_p
and	b.nr_prescricao		= a.nr_prescricao
and (coalesce(coalesce(CASE WHEN c.ds_resultado='0' THEN ''  ELSE CASE WHEN d.ie_formato_resultado='V' THEN ''  ELSE c.ds_resultado END  END ,	coalesce(to_char(c.qt_resultado),to_char(CASE WHEN c.pr_resultado=0 THEN ''  ELSE c.pr_resultado END ))),c.ds_resultado)) is not null;

if (nr_seq_result_atual_prescr_w > nr_seq_resultado_atual_w) then
	nr_seq_resultado_atual_w	:= nr_seq_result_atual_prescr_w;
end if;

if (nr_seq_resultado_atual_w > 0) then


	select	max(c.dt_digitacao)
	into STRICT	dt_digitacao_w
	from	exame_laboratorio d,
		exame_lab_result_item c
	where	c.nr_seq_resultado 	= nr_seq_resultado_atual_w
	and	c.nr_seq_exame		= nr_seq_exame_p
	and	d.nr_seq_exame 		= c.nr_seq_exame;


	select 	coalesce(max(c.nr_seq_resultado),0)
	into STRICT	nr_seq_resultado_w
	from	exame_laboratorio d,
		exame_lab_resultado a,
		exame_lab_result_item c
	where	a.nr_seq_resultado 	= c.nr_seq_resultado
	and	d.nr_seq_exame 		= c.nr_seq_exame
	and	a.cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	c.nr_seq_exame		= nr_seq_exame_p
	and (coalesce(c.dt_digitacao,dt_resultado) < dt_digitacao_w)
	and (coalesce(coalesce(CASE WHEN c.ds_resultado='0' THEN ''  ELSE CASE WHEN d.ie_formato_resultado='V' THEN ''  ELSE c.ds_resultado END  END ,	coalesce(to_char(c.qt_resultado),to_char(CASE WHEN c.pr_resultado=0 THEN ''  ELSE c.pr_resultado END ))),c.ds_resultado)) is not null;

	select 	coalesce(max(c.nr_seq_resultado),0)
	into STRICT	nr_seq_resultado_prescr_w
	from	exame_laboratorio d,
		exame_lab_resultado a,
		exame_lab_result_item c,
		prescr_medica b
	where	a.nr_seq_resultado 	= c.nr_seq_resultado
	and	d.nr_seq_exame 		= c.nr_seq_exame
	and (coalesce(c.dt_digitacao,dt_resultado)  < dt_digitacao_w)
	and	b.cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	c.nr_seq_exame		= nr_seq_exame_p
	and	b.nr_prescricao		= a.nr_prescricao
	and (coalesce(coalesce(CASE WHEN c.ds_resultado='0' THEN ''  ELSE CASE WHEN d.ie_formato_resultado='V' THEN ''  ELSE c.ds_resultado END  END ,	coalesce(to_char(c.qt_resultado),to_char(CASE WHEN c.pr_resultado=0 THEN ''  ELSE c.pr_resultado END ))),c.ds_resultado)) is not null;

	if (nr_seq_resultado_prescr_w > nr_seq_resultado_w) then
		nr_seq_resultado_w	:= nr_seq_resultado_prescr_w;
	end if;

	if (nr_seq_resultado_w > 0) then
		select	max(coalesce(coalesce(CASE WHEN c.ds_resultado='0' THEN ''  ELSE CASE WHEN d.ie_formato_resultado='V' THEN ''  ELSE c.ds_resultado END  END ,	coalesce(to_char(c.qt_resultado),to_char(CASE WHEN c.pr_resultado=0 THEN ''  ELSE c.pr_resultado END ))),c.ds_resultado))
		into STRICT	ds_resultado_w
		from	exame_laboratorio d,
			exame_lab_result_item c
		where	c.nr_seq_resultado 	= nr_seq_resultado_w
		and	c.nr_seq_exame		= nr_seq_exame_p
		and	d.nr_seq_exame 		= c.nr_seq_exame;
	else
		ds_resultado_w	:= 'NA';
	end if;
else
	ds_resultado_w	:= 'NA';
end if;

return ds_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_resultado_dia_lab_ant (cd_pessoa_fisica_p text, dt_referencia_p timestamp, nr_seq_exame_p bigint) FROM PUBLIC;

