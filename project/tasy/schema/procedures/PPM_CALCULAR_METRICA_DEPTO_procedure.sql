-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ppm_calcular_metrica_depto (nr_seq_metrica_p bigint, nr_seq_obj_metrica_p bigint, dt_referencia_p timestamp, nm_usuario_p text, nr_seq_depto_p bigint, nr_seq_gerencia_p bigint, nr_seq_grupo_p bigint) AS $body$
DECLARE


vl_resultado_w		double precision;
vl_montante_w		double precision;
vl_individual_w		double precision;
nr_seq_objetivo_depto_w	bigint;
ie_informacao_w		varchar(5);
dt_referencia_w		timestamp;
qt_pessoas_w		bigint;


BEGIN

dt_referencia_w		:= pkg_date_utils.start_of(dt_referencia_p,'MONTH');

select	coalesce(ie_informacao,'P')
into STRICT	ie_informacao_w
from	ppm_metrica
where	nr_sequencia = nr_seq_metrica_p;

if (coalesce(nr_seq_grupo_p,0) > 0) then

	select	sum(a.vl_montante),
		sum(a.vl_individual)
	into STRICT	vl_montante_w,
		vl_individual_w
	from	ppm_objetivo_result a,
		ppm_objetivo_metrica b,
		ppm_objetivo_meta c,
		ppm_objetivo d,
		usuario e
	where	a.nr_seq_metrica	= b.nr_sequencia
	and	b.nr_seq_meta		= c.nr_sequencia
	and	b.nr_seq_metrica	= nr_seq_metrica_p
	and	c.nr_seq_objetivo	= d.nr_sequencia
	and	d.cd_pessoa_fisica	= e.cd_pessoa_fisica
	and	pkg_date_utils.start_of(a.dt_referencia,'MONTH') = dt_referencia_w
	and	e.ie_situacao		= 'A'
	and	exists (SELECT	1
			from	gerencia_wheb_grupo_usu x
			where	x.nm_usuario_grupo 	= e.nm_usuario
			and	x.nr_seq_grupo		= nr_seq_grupo_p);
			
	if (ie_informacao_w = 'P') then			
		vl_resultado_w	:= (dividir(vl_individual_w, vl_montante_w) * 100);
		/*if	(vl_resultado_w > 100) then
			vl_resultado_w	:= 100;
		end if;*/
	else
	
		--if	(nr_seq_metrica_p = 10) then
			select	count(1)
			into STRICT	qt_pessoas_w
			from	gerencia_wheb_grupo_usu x
			where	x.nr_seq_grupo = nr_seq_grupo_p;
			
			vl_resultado_w	:= vl_montante_w / coalesce(qt_pessoas_w,1);			
		/*else		
			vl_resultado_w	:= vl_montante_w;
		end if;	*/
		
	end if;
	
elsif (coalesce(nr_seq_gerencia_p,0) > 0) then
	
	select	sum(a.vl_montante),
		sum(a.vl_individual)
	into STRICT	vl_montante_w,
		vl_individual_w
	from	ppm_objetivo_result a,
		ppm_objetivo_metrica b,
		ppm_objetivo_meta c,
		ppm_objetivo d,
		usuario e
	where	a.nr_seq_metrica	= b.nr_sequencia
	and	b.nr_seq_meta		= c.nr_sequencia
	and	b.nr_seq_metrica	= nr_seq_metrica_p
	and	c.nr_seq_objetivo	= d.nr_sequencia
	and	d.cd_pessoa_fisica	= e.cd_pessoa_fisica
	and	pkg_date_utils.start_of(a.dt_referencia,'MONTH') = dt_referencia_w
	and	e.ie_situacao		= 'A'
	and	exists (SELECT	1
			from	gerencia_wheb_grupo_usu x,
				gerencia_wheb_grupo y
			where	x.nm_usuario_grupo 	= e.nm_usuario
			and	x.nr_seq_grupo		= y.nr_sequencia
			and	y.ie_situacao		= 'A'
			and	y.nr_seq_gerencia	= nr_seq_gerencia_p);
			
	if (ie_informacao_w = 'P') then			
		vl_resultado_w	:= (dividir(vl_individual_w, vl_montante_w) * 100);
		/*if	(vl_resultado_w > 100) then
			vl_resultado_w	:= 100;
		end if;*/
	else
		--if	(nr_seq_metrica_p = 10) then
			select	count(1)
			into STRICT	qt_pessoas_w
			from	gerencia_wheb_grupo_usu x,
				gerencia_wheb_grupo y
			where	x.nr_seq_grupo		= y.nr_sequencia
			and	y.ie_situacao		= 'A'
			and	y.nr_seq_gerencia	= nr_seq_gerencia_p;
			
			vl_resultado_w	:= vl_montante_w / coalesce(qt_pessoas_w,1);			
		/*else		
			vl_resultado_w	:= vl_montante_w;
		end if;	*/
	end if;
	
elsif (coalesce(nr_seq_depto_p,0) > 0) then
	
	select	sum(a.vl_montante),
		sum(a.vl_individual)
	into STRICT	vl_montante_w,
		vl_individual_w
	from	ppm_objetivo_result a,
		ppm_objetivo_metrica b,
		ppm_objetivo_meta c,
		ppm_objetivo d,
		usuario e
	where	a.nr_seq_metrica	= b.nr_sequencia
	and	b.nr_seq_meta		= c.nr_sequencia
	and	b.nr_seq_metrica	= nr_seq_metrica_p
	and	c.nr_seq_objetivo	= d.nr_sequencia
	and	d.cd_pessoa_fisica	= e.cd_pessoa_fisica
	and	pkg_date_utils.start_of(a.dt_referencia,'MONTH') = dt_referencia_w
	and	e.ie_situacao		= 'A'
	and	exists (SELECT	1
			from	gerencia_wheb_grupo_usu x,
				gerencia_wheb_grupo y,
				gerencia_wheb z,
				depto_gerencia_philips v
			where	x.nm_usuario_grupo 	= e.nm_usuario
			and	x.nr_seq_grupo		= y.nr_sequencia					
			and	y.nr_seq_gerencia	= z.nr_sequencia
			and	z.nr_sequencia		= v.nr_seq_gerencia
			and	z.ie_situacao		= 'A'
			and	y.ie_situacao		= 'A'	
			and	v.nr_seq_departamento	= nr_seq_depto_p);
			
	if (ie_informacao_w = 'P') then			
		vl_resultado_w	:= (dividir(vl_individual_w, vl_montante_w) * 100);
		/*if	(vl_resultado_w > 100) then
			vl_resultado_w	:= 100;
		end if;*/
	else
		--if	(nr_seq_metrica_p = 10) then
			select	count(1)
			into STRICT	qt_pessoas_w
			from	gerencia_wheb_grupo_usu x,
				gerencia_wheb_grupo y,
				gerencia_wheb z,
				depto_gerencia_philips v
			where	x.nr_seq_grupo		= y.nr_sequencia					
			and	y.nr_seq_gerencia	= z.nr_sequencia
			and	z.nr_sequencia		= v.nr_seq_gerencia
			and	z.ie_situacao		= 'A'
			and	y.ie_situacao		= 'A'	
			and	v.nr_seq_departamento	= nr_seq_depto_p;
			
			vl_resultado_w	:= vl_montante_w / coalesce(qt_pessoas_w,1);			
		/*else		
			vl_resultado_w	:= vl_montante_w;
		end if;*/
	end if;
	
end if;

CALL PPM_GRAVAR_RESULTADO(nr_seq_obj_metrica_p, dt_referencia_w, vl_resultado_w, vl_montante_w, vl_individual_w, nm_usuario_p);

--Gravar os valores calculados a nivel de departamento (Departamento/Gerencia/Grupo)

/*select	max(a.nr_sequencia)
into	nr_seq_objetivo_depto_w
from	ppm_objetivo_metrica a
where	a.nr_seq_metrica = nr_seq_metrica_p
and	exists
	(select	1
	from	ppm_objetivo x,
		ppm_objetivo_meta y
	where	y.nr_sequencia = a.nr_seq_meta
	and	y.nr_seq_objetivo = x.nr_sequencia
	and	(x.nr_seq_departamento = nr_seq_depto_p or
		x.nr_seq_gerencia = nr_seq_gerencia_p or
		x.nr_seq_grupo = nr_seq_grupo_p));
		
if	(nr_seq_objetivo_depto_w is not null) then

	PPM_GRAVAR_RESULTADO(nr_seq_objetivo_depto_w, dt_referencia_w, vl_resultado_w, vl_montante_w, vl_individual_w, nm_usuario_p);

end if;
*/
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ppm_calcular_metrica_depto (nr_seq_metrica_p bigint, nr_seq_obj_metrica_p bigint, dt_referencia_p timestamp, nm_usuario_p text, nr_seq_depto_p bigint, nr_seq_gerencia_p bigint, nr_seq_grupo_p bigint) FROM PUBLIC;

