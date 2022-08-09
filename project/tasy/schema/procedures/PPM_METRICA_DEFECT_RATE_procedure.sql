-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ppm_metrica_defect_rate ( nr_seq_metrica_p bigint, nr_seq_objetivo_metrica_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, dt_referencia_p timestamp) AS $body$
DECLARE


dt_ref_inicio_w 	timestamp;
dt_ref_fim_w 		timestamp;
dt_referencia_w		timestamp;
dt_fim_ano_w		timestamp;
vl_resultado_w		ppm_objetivo_result.vl_resultado_calc%type;
nr_seq_diretoria_w	ppm_objetivo.nr_seq_diretoria%type;
nr_seq_gerencia_w	ppm_objetivo.nr_seq_gerencia%type;
nr_seq_grupo_w		ppm_objetivo.nr_seq_grupo%type;
vl_acumulado_w		ppm_objetivo_result.vl_resultado_calc%type;
nr_seq_acumulado_w	ppm_objetivo_result.nr_sequencia%type;


BEGIN

select	max(c.nr_seq_gerencia),
	max(c.nr_seq_grupo),
	max(c.nr_seq_diretoria)
into STRICT	nr_seq_gerencia_w,
	nr_seq_grupo_w,
	nr_seq_diretoria_w
from	ppm_objetivo_metrica a
join	ppm_objetivo_meta b on a.nr_seq_meta = b.nr_sequencia
join	ppm_objetivo c on b.nr_seq_objetivo = c.nr_sequencia
where	a.nr_sequencia = nr_seq_objetivo_metrica_p;

dt_referencia_w	:= trunc(dt_referencia_p);
dt_ref_inicio_w := pkg_date_utils.start_of(dt_referencia_w, 'MONTH');
dt_ref_fim_w 	:= pkg_date_utils.end_of(last_day(dt_referencia_w), 'DAY');
dt_fim_ano_w	:= trunc(pkg_date_utils.end_of(to_date('31/12/' || to_char(dt_referencia_w,'yyyy'),'dd/mm/yyyy'),'DAY'));

if (nr_seq_grupo_w IS NOT NULL AND nr_seq_grupo_w::text <> '') then
	begin

	select	coalesce(max(a.qt_def_rate_mes),0),
		coalesce(max(a.qt_def_rate_ano),0)
	into STRICT	vl_resultado_w,
		vl_acumulado_w
	from	w_indicador_desenv_apres a
	where	a.dt_referencia =  dt_referencia_w
	and	a.nr_seq_grupo	= nr_seq_grupo_w
	and	a.ie_abrangencia = 'GRU';

	CALL ppm_gravar_resultado(nr_seq_objetivo_metrica_p, dt_referencia_p, vl_resultado_w, 0, 0, nm_usuario_p);

	select	max(nr_sequencia)
	into STRICT	nr_seq_acumulado_w
	from	ppm_objetivo_result a
	where	a.nr_seq_metrica = nr_seq_objetivo_metrica_p
	and	trunc(dt_referencia) = dt_fim_ano_w;

	update	ppm_objetivo_result
	set	vl_resultado_calc = vl_acumulado_w
	where	nr_sequencia = nr_seq_acumulado_w;

	end;

elsif (nr_seq_gerencia_w IS NOT NULL AND nr_seq_gerencia_w::text <> '') then
	begin

	select	coalesce(max(a.qt_def_rate_mes),0),
		coalesce(max(a.qt_def_rate_ano),0)
	into STRICT	vl_resultado_w,
		vl_acumulado_w
	from	w_indicador_desenv_apres a
	where	a.dt_referencia = dt_referencia_w
	and	a.ie_abrangencia in ('GER')
	and	a.nr_seq_gerencia = nr_seq_gerencia_w;

	CALL ppm_gravar_resultado(nr_seq_objetivo_metrica_p, dt_referencia_p, vl_resultado_w, 0, 0, nm_usuario_p);

	select	max(a.nr_sequencia)
	into STRICT	nr_seq_acumulado_w
	from	ppm_objetivo_result a
	where	a.nr_seq_metrica = nr_seq_objetivo_metrica_p
	and	trunc(dt_referencia) = dt_fim_ano_w;

	update	ppm_objetivo_result
	set	vl_resultado_calc = vl_acumulado_w
	where	nr_sequencia = nr_seq_acumulado_w;

	end;

elsif (nr_seq_diretoria_w IS NOT NULL AND nr_seq_diretoria_w::text <> '') then
	begin

	select	coalesce(max(a.qt_def_rate_mes),0),
		coalesce(max(a.qt_def_rate_ano),0)
	into STRICT	vl_resultado_w,
		vl_acumulado_w
	from	w_indicador_desenv_apres a
	where	a.dt_referencia = dt_referencia_w
	and 	a.nr_seq_diretoria = nr_seq_diretoria_w;

	CALL ppm_gravar_resultado(nr_seq_objetivo_metrica_p, dt_referencia_p, vl_resultado_w, 0, 0, nm_usuario_p);

	select	max(a.nr_sequencia)
	into STRICT	nr_seq_acumulado_w
	from	ppm_objetivo_result a
	where	a.nr_seq_metrica = nr_seq_objetivo_metrica_p
	and	trunc(dt_referencia) = dt_fim_ano_w;

	update	ppm_objetivo_result
	set	vl_resultado_calc = vl_acumulado_w
	where	nr_sequencia = nr_seq_acumulado_w;

	end;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ppm_metrica_defect_rate ( nr_seq_metrica_p bigint, nr_seq_objetivo_metrica_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, dt_referencia_p timestamp) FROM PUBLIC;
