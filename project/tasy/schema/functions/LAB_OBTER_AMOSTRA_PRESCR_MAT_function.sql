-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_amostra_prescr_mat (ds_valor_p text, nr_prescricao_p bigint, nr_seq_material_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_grupo_w		bigint;
nr_seq_grupo_imp_w	bigint;
nr_seq_lab_w		varchar(20);
dt_liberacao_W		timestamp;
dt_liberacao_medico_w	timestamp;
dt_prescricao_w		timestamp;
nr_prescricao_w		bigint;
ds_resultado_w		varchar(30);
nr_seq_mat_w		bigint;
nr_identificador_w	bigint;
nr_seq_barras_w		bigint;
nr_seq_mat_result_w	bigint;
ds_seq_mat_w		varchar(10);


BEGIN
select	max(c.nr_seq_grupo),
	max(c.nr_seq_grupo_imp),
	coalesce(max(a.nr_seq_lab),0),
	max(b.dt_liberacao),
	max(b.dt_prescricao),
	max(b.dt_liberacao_medico),
	max(a.nr_prescricao),
	max(d.nr_sequencia)
into STRICT	nr_seq_grupo_w,
	nr_seq_grupo_imp_w,
	nr_seq_lab_w,
	dt_liberacao_W,
	dt_prescricao_w,
	dt_liberacao_medico_w,
	nr_prescricao_w,
	nr_seq_mat_w
from 	material_exame_lab d,
	exame_laboratorio c,
	prescr_medica b,
	prescr_procedimento a
where	b.nr_prescricao = a.nr_prescricao
and	d.cd_material_exame = a.cd_material_exame
and	c.nr_seq_exame	= a.nr_seq_exame
and	a.nr_prescricao = nr_prescricao_p
and	d.nr_sequencia  = nr_seq_material_p;


ds_seq_mat_w := to_char(nr_seq_mat_w);

if ((nr_seq_mat_w IS NOT NULL AND nr_seq_mat_w::text <> '') and (length(nr_seq_mat_w) < 2)) then
	ds_seq_mat_w := '0'||nr_seq_mat_w;
end if;

if (ds_valor_p = 'PM') then
	ds_resultado_w := lpad(nr_prescricao_w || 'M' || ds_seq_mat_w,10,'0');

elsif (ds_valor_p = 'PM11') then
	ds_resultado_w := lpad(nr_prescricao_w || 'M' || nr_seq_mat_w,11,'0');
elsif (ds_valor_p = 'PM13') then
	ds_resultado_w := lpad(nr_prescricao_w || 'M' || nr_seq_mat_w,13,'0');
elsif (ds_valor_p = 'PMR11') then
	select	coalesce(max(d.nr_seq_material),nr_seq_mat_w)
	into STRICT	nr_seq_mat_result_w
	from 	exame_lab_result_item d,
		exame_lab_resultado c,
		prescr_medica b,
		prescr_procedimento a
	where	b.nr_prescricao = a.nr_prescricao
	and	b.nr_prescricao = c.nr_prescricao
	and	c.nr_seq_resultado = d.nr_seq_resultado
	and	d.nr_seq_prescr = a.nr_sequencia
	and	a.nr_prescricao = nr_prescricao_p
	and	d.nr_seq_material  = nr_seq_material_p;
	ds_resultado_w := lpad(nr_prescricao_w || 'M' || nr_seq_mat_result_w,11,'0');
elsif (ds_valor_p = 'P') then
	ds_resultado_w := nr_prescricao_w;

elsif (ds_valor_p = 'DGS') then
	ds_resultado_w := to_char(coalesce(dt_liberacao_medico_w,coalesce(dt_liberacao_w,dt_prescricao_w)),'ddmm') || lpad(nr_seq_grupo_w,2,'0')
			|| lpad(nr_seq_lab_w,3,'0');

elsif (ds_valor_p = 'DGIS') then
	ds_resultado_w := to_char(coalesce(dt_liberacao_medico_w,coalesce(dt_liberacao_w,dt_prescricao_w)),'ddmm') || lpad(nr_seq_grupo_imp_w,2,'0')
			|| lpad(nr_seq_lab_w,3,'0');

elsif (ds_valor_p = 'DS4GI') then
	ds_resultado_w := to_char(coalesce(dt_liberacao_medico_w,coalesce(dt_liberacao_w,dt_prescricao_w)),'ddmm') || lpad(nr_seq_lab_w,4,'0')
			|| lpad(nr_seq_grupo_imp_w,2,'0');

elsif (ds_valor_p = 'DGSL') then
	ds_resultado_w := to_char(coalesce(dt_liberacao_medico_w,coalesce(dt_liberacao_w,dt_prescricao_w)),'dd') || lpad(nr_seq_grupo_w,2,'0')
			|| lpad(nr_seq_lab_w,4,'0');

elsif (ds_valor_p = 'DAGS4') then
	ds_resultado_w := to_char(coalesce(dt_liberacao_medico_w,coalesce(dt_liberacao_w,dt_prescricao_w)),'ddmmyy') || lpad(nr_seq_grupo_w,2,'0')
			|| lpad(nr_seq_lab_w,4,'0');

elsif (ds_valor_p = 'DGS7') then
	ds_resultado_w := to_char(coalesce(dt_liberacao_medico_w,coalesce(dt_liberacao_w,dt_prescricao_w)),'ddmm') || lpad(nr_seq_grupo_w,2,'0')
			|| lpad(nr_seq_lab_w,7,'0');

elsif (ds_valor_p = 'DGS6') then
	ds_resultado_w := to_char(coalesce(dt_liberacao_medico_w,coalesce(dt_liberacao_w,dt_prescricao_w)),'ddmm') || lpad(nr_seq_grupo_w,2,'0')
			|| lpad(nr_seq_lab_w,6,'0');

elsif (ds_valor_p = 'DGS5') then
	ds_resultado_w := to_char(coalesce(dt_liberacao_medico_w,coalesce(dt_liberacao_w,dt_prescricao_w)),'ddmm') || lpad(nr_seq_grupo_w,2,'0')
			|| lpad(nr_seq_lab_w,6,'0');
end if;

return ds_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_amostra_prescr_mat (ds_valor_p text, nr_prescricao_p bigint, nr_seq_material_p bigint) FROM PUBLIC;
