-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_anal_prod_migr_geral_mes () AS $body$
DECLARE


nr_seq_analise_dia_w	bigint;

qt_os_colab_inic_w	bigint;
qt_os_colab_proj_inic_w	bigint;
qt_os_colab_rev_inic_w	bigint;
qt_os_colab_val_inic_w	bigint;

qt_os_colab_w		bigint;
qt_os_colab_proj_w	bigint;
qt_os_colab_rev_w	bigint;
qt_os_colab_val_w	bigint;

qt_os_colab_60_inic_w	bigint;
qt_os_colab_45_inic_w	bigint;
qt_os_colab_30_inic_w	bigint;
qt_os_colab_15_inic_w	bigint;
qt_os_colab_07_inic_w	bigint;
qt_os_colab_sem_inic_w	bigint;

qt_os_colab_60_w	bigint;
qt_os_colab_45_w	bigint;
qt_os_colab_30_w	bigint;
qt_os_colab_15_w	bigint;
qt_os_colab_07_w	bigint;
qt_os_colab_sem_w	bigint;

qt_hora_colab_w		double precision;

qt_hora_os_w		double precision;
qt_hora_os_proj_w	double precision;
qt_hora_os_proj_terc_w	double precision;
qt_hora_os_rev_w	double precision;
qt_hora_os_rev_terc_w	double precision;
qt_hora_os_nec_w	double precision;
qt_hora_os_nec_terc_w	double precision;
qt_hora_os_dep_w	double precision;
qt_hora_os_dep_terc_w	double precision;


BEGIN
/* obter análise dia / geral - caso existir */

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_analise_dia_w
from	w_analise_prod_migr_colab
where	dt_analise = trunc(clock_timestamp(),'month')
and	ie_analise = 'EM';

/* gerar análise dia / geral - caso não existir */

if (nr_seq_analise_dia_w = 0) then
	begin
	select	sum(w.qt_os_colab_inic) qt_os_colab_inic,
		sum(w.qt_os_colab_proj_inic) qt_os_colab_proj_inic,
		sum(w.qt_os_colab_rev_inic) qt_os_colab_rev_inic,
		sum(w.qt_os_colab_val_inic) qt_os_colab_val_inic,
		sum(w.qt_os_colab_60_inic) qt_os_colab_60_inic,
		sum(w.qt_os_colab_45_inic) qt_os_colab_45_inic,
		sum(w.qt_os_colab_30_inic) qt_os_colab_30_inic,
		sum(w.qt_os_colab_15_inic) qt_os_colab_15_inic,
		sum(w.qt_os_colab_07_inic) qt_os_colab_07_inic,
		sum(w.qt_os_colab_sem_inic) qt_os_colab_sem_inic
	into STRICT	qt_os_colab_inic_w,
		qt_os_colab_proj_inic_w,
		qt_os_colab_rev_inic_w,
		qt_os_colab_val_inic_w,
		qt_os_colab_60_inic_w,
		qt_os_colab_45_inic_w,
		qt_os_colab_30_inic_w,
		qt_os_colab_15_inic_w,
		qt_os_colab_07_inic_w,
		qt_os_colab_sem_inic_w
	from	w_analise_prod_migr_colab w
	where	w.nr_sequencia in (
			SELECT	min(x.nr_sequencia)
			from	w_analise_prod_migr_colab x
			where	trunc(x.dt_analise,'month') = trunc(clock_timestamp(),'month')
			and	x.ie_analise = 'CM'
			group by
				x.nm_usuario_colab);

	select	sum(w.qt_os_colab) qt_os_colab,
		sum(w.qt_os_colab_proj) qt_os_colab_proj,
		sum(w.qt_os_colab_rev) qt_os_colab_rev,
		sum(w.qt_os_colab_val) qt_os_colab_val,
		sum(w.qt_os_colab_60) qt_os_colab_60,
		sum(w.qt_os_colab_45) qt_os_colab_45,
		sum(w.qt_os_colab_30) qt_os_colab_30,
		sum(w.qt_os_colab_15) qt_os_colab_15,
		sum(w.qt_os_colab_07) qt_os_colab_07,
		sum(w.qt_os_colab_sem) qt_os_colab_sem,
		sum(w.qt_hora_colab) qt_hora_colab,
		sum(w.qt_hora_os) qt_hora_os,
		sum(w.qt_hora_os_proj) qt_hora_os_proj,
		sum(w.qt_hora_os_proj_terc) qt_hora_os_proj_terc,
		sum(w.qt_hora_os_rev) qt_hora_os_rev,
		sum(w.qt_hora_os_rev_terc) qt_hora_os_rev_terc,
		sum(w.qt_hora_os_nec) qt_hora_os_nec,
		sum(w.qt_hora_os_nec_terc) qt_hora_os_nec_terc,
		sum(w.qt_hora_os_dep) qt_hora_os_dep,
		sum(w.qt_hora_os_dep_terc) qt_hora_os_dep_terc
	into STRICT	qt_os_colab_w,
		qt_os_colab_proj_w,
		qt_os_colab_rev_w,
		qt_os_colab_val_w,
		qt_os_colab_60_w,
		qt_os_colab_45_w,
		qt_os_colab_30_w,
		qt_os_colab_15_w,
		qt_os_colab_07_w,
		qt_os_colab_sem_w,
		qt_hora_colab_w,
		qt_hora_os_w,
		qt_hora_os_proj_w,
		qt_hora_os_proj_terc_w,
		qt_hora_os_rev_w,
		qt_hora_os_rev_terc_w,
		qt_hora_os_nec_w,
		qt_hora_os_nec_terc_w,
		qt_hora_os_dep_w,
		qt_hora_os_dep_terc_w
	from	w_analise_prod_migr_colab w
	where	w.nr_sequencia in (
			SELECT	max(x.nr_sequencia)
			from	w_analise_prod_migr_colab x
			where	trunc(x.dt_analise,'month') = trunc(clock_timestamp(),'month')
			and	x.ie_analise = 'CM'
			group by
				x.nm_usuario_colab);

	insert into w_analise_prod_migr_colab(
		nr_sequencia,
		dt_analise,
		ie_analise,
		nm_usuario_analise,
		nr_seq_grupo_des,
		qt_os_colab_inic,
		qt_os_colab_proj_inic,
		qt_os_colab_rev_inic,
		qt_os_colab_val_inic,
		qt_os_colab,
		qt_os_colab_proj,
		qt_os_colab_rev,
		qt_os_colab_val,
		qt_os_colab_60_inic,
		qt_os_colab_45_inic,
		qt_os_colab_30_inic,
		qt_os_colab_15_inic,
		qt_os_colab_07_inic,
		qt_os_colab_sem_inic,
		qt_os_colab_60,
		qt_os_colab_45,
		qt_os_colab_30,
		qt_os_colab_15,
		qt_os_colab_07,
		qt_os_colab_sem,
		qt_hora_colab,
		qt_hora_os,
		qt_hora_os_proj,
		qt_hora_os_proj_terc,
		qt_hora_os_rev,
		qt_hora_os_rev_terc,
		qt_hora_os_nec,
		qt_hora_os_nec_terc,
		qt_hora_os_dep,
		qt_hora_os_dep_terc)
	values (
		nextval('w_analise_prod_migr_colab_seq'),
		trunc(clock_timestamp(),'month'),
		'EM',
		'Rafael',
		57,
		qt_os_colab_inic_w,
		qt_os_colab_proj_inic_w,
		qt_os_colab_rev_inic_w,
		qt_os_colab_val_inic_w,
		qt_os_colab_w,
		qt_os_colab_proj_w,
		qt_os_colab_rev_w,
		qt_os_colab_val_w,
		qt_os_colab_60_inic_w,
		qt_os_colab_45_inic_w,
		qt_os_colab_30_inic_w,
		qt_os_colab_15_inic_w,
		qt_os_colab_07_inic_w,
		qt_os_colab_sem_inic_w,
		qt_os_colab_60_w,
		qt_os_colab_45_w,
		qt_os_colab_30_w,
		qt_os_colab_15_w,
		qt_os_colab_07_w,
		qt_os_colab_sem_w,
		qt_hora_colab_w,
		qt_hora_os_w,
		qt_hora_os_proj_w,
		qt_hora_os_proj_terc_w,
		qt_hora_os_rev_w,
		qt_hora_os_rev_terc_w,
		qt_hora_os_nec_w,
		qt_hora_os_nec_terc_w,
		qt_hora_os_dep_w,
		qt_hora_os_dep_terc_w);
	end;
else
	begin
	select	sum(w.qt_os_colab) qt_os_colab,
		sum(w.qt_os_colab_proj) qt_os_colab_proj,
		sum(w.qt_os_colab_rev) qt_os_colab_rev,
		sum(w.qt_os_colab_val) qt_os_colab_val,
		sum(w.qt_os_colab_60) qt_os_colab_60,
		sum(w.qt_os_colab_45) qt_os_colab_45,
		sum(w.qt_os_colab_30) qt_os_colab_30,
		sum(w.qt_os_colab_15) qt_os_colab_15,
		sum(w.qt_os_colab_07) qt_os_colab_07,
		sum(w.qt_os_colab_sem) qt_os_colab_sem,
		sum(w.qt_hora_colab) qt_hora_colab,
		sum(w.qt_hora_os) qt_hora_os,
		sum(w.qt_hora_os_proj) qt_hora_os_proj,
		sum(w.qt_hora_os_proj_terc) qt_hora_os_proj_terc,
		sum(w.qt_hora_os_rev) qt_hora_os_rev,
		sum(w.qt_hora_os_rev_terc) qt_hora_os_rev_terc,
		sum(w.qt_hora_os_nec) qt_hora_os_nec,
		sum(w.qt_hora_os_nec_terc) qt_hora_os_nec_terc,
		sum(w.qt_hora_os_dep) qt_hora_os_dep,
		sum(w.qt_hora_os_dep_terc) qt_hora_os_dep_terc
	into STRICT	qt_os_colab_w,
		qt_os_colab_proj_w,
		qt_os_colab_rev_w,
		qt_os_colab_val_w,
		qt_os_colab_60_w,
		qt_os_colab_45_w,
		qt_os_colab_30_w,
		qt_os_colab_15_w,
		qt_os_colab_07_w,
		qt_os_colab_sem_w,
		qt_hora_colab_w,
		qt_hora_os_w,
		qt_hora_os_proj_w,
		qt_hora_os_proj_terc_w,
		qt_hora_os_rev_w,
		qt_hora_os_rev_terc_w,
		qt_hora_os_nec_w,
		qt_hora_os_nec_terc_w,
		qt_hora_os_dep_w,
		qt_hora_os_dep_terc_w
	from	w_analise_prod_migr_colab w
	where	w.nr_sequencia in (
			SELECT	max(x.nr_sequencia)
			from	w_analise_prod_migr_colab x
			where	trunc(x.dt_analise,'month') = trunc(clock_timestamp(),'month')
			and	x.ie_analise = 'CM'
			group by
				x.nm_usuario_colab);

	update	w_analise_prod_migr_colab
	set	qt_os_colab = qt_os_colab_w,
		qt_os_colab_proj = qt_os_colab_proj_w,
		qt_os_colab_rev = qt_os_colab_rev_w,
		qt_os_colab_val = qt_os_colab_val,
		qt_os_colab_60 = qt_os_colab_60_w,
		qt_os_colab_45 = qt_os_colab_45_w,
		qt_os_colab_30 = qt_os_colab_30_w,
		qt_os_colab_15 = qt_os_colab_15_w,
		qt_os_colab_07 = qt_os_colab_07_w,
		qt_os_colab_sem = qt_os_colab_sem_w,
		qt_hora_colab = qt_hora_colab_w,
		qt_hora_os = qt_hora_os_w,
		qt_hora_os_proj = qt_hora_os_proj_w,
		qt_hora_os_proj_terc = qt_hora_os_proj_terc_w,
		qt_hora_os_rev = qt_hora_os_rev_w,
		qt_hora_os_rev_terc = qt_hora_os_rev_terc_w,
		qt_hora_os_nec = qt_hora_os_nec_w,
		qt_hora_os_nec_terc = qt_hora_os_nec_terc_w,
		qt_hora_os_dep = qt_hora_os_dep_w,
		qt_hora_os_dep_terc = qt_hora_os_dep_terc_w
	where	nr_sequencia = nr_seq_analise_dia_w;
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_anal_prod_migr_geral_mes () FROM PUBLIC;

