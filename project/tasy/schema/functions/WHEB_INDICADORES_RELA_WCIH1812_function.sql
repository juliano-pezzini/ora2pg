-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION wheb_indicadores_rela_wcih1812 (dt_inicial_p timestamp, dt_final_p timestamp, ie_data_referencia_p bigint, cd_estab_p bigint, cd_clinica_p bigint, cd_p bigint, ie_retorno_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255) := '';
ds_indicador_w		varchar(255);
qt_indicador_w		double precision;
vl_indicador_w		double precision;
cd_w			bigint;

BEGIN
if (dt_inicial_p IS NOT NULL AND dt_inicial_p::text <> '') and (dt_final_p IS NOT NULL AND dt_final_p::text <> '') then

	select	ds, qt, vl, cd
	into STRICT	ds_indicador_w,
		qt_indicador_w,
		vl_indicador_w,
		cd_w
	from	(SELECT	wheb_mensagem_pck.get_texto(803127) ds,
			(select	count(*)
			from	cih_ficha_ocorrencia_v a
			where	a.dt_alta_interno between trunc(dt_inicial_p) and trunc(dt_final_p)+86399/86400
			and	((a.cd_clinica = cd_clinica_p) or (0 = cd_clinica_p))
			and	((a.cd_estabelecimento = cd_estab_p) or (0 = cd_estab_p))) qt,
			((select	count(*)
			from	cih_ficha_ocorrencia_v a
			where	a.dt_alta_interno between trunc(dt_inicial_p) and trunc(dt_final_p)+86399/86400
			and	((a.cd_clinica = cd_clinica_p) or (0 = cd_clinica_p))
			and	((a.cd_estabelecimento = cd_estab_p) or (0 = cd_estab_p)))/
			(select	sum(nr_admissoes)
			from	eis_ocupacao_setor_v a
			where	ie_periodo =  'M'
			and	dt_referencia between trunc(dt_inicial_p) and trunc(dt_final_p)+86399/86400
			and	((a.cd_estabelecimento = cd_estab_p) or (0 = cd_estab_p)))*100) vl,
			1 cd
		
		
union

		SELECT	wheb_mensagem_pck.get_texto(803128) ds,
			(select	sum(coalesce(b.nr_ih,0)) nr_ih
			FROM cih_infeccao_v b, cih_ficha_ocorrencia_v a
LEFT OUTER JOIN cih_evolucao_v c ON (a.cd_tipo_evolucao = c.cd_tipo_evolucao)
WHERE a.nr_ficha_ocorrencia	= b.nr_ficha_ocorrencia  and CASE WHEN ie_data_referencia_p=0 THEN a.dt_alta WHEN ie_data_referencia_p=1 THEN b.dt_infeccao END  between trunc(dt_inicial_p) and trunc(dt_final_p)+86399/86400 and ((a.cd_clinica = cd_clinica_p) or (0 = cd_clinica_p)) and ((a.cd_estabelecimento = cd_estab_p) or (0 = cd_estab_p)) ) qt,
			((select	sum(coalesce(b.nr_ih,0)) nr_ih
			FROM cih_infeccao_v b, cih_ficha_ocorrencia_v a
LEFT OUTER JOIN cih_evolucao_v c ON (a.cd_tipo_evolucao = c.cd_tipo_evolucao)
WHERE a.nr_ficha_ocorrencia	= b.nr_ficha_ocorrencia  and CASE WHEN ie_data_referencia_p=0 THEN a.dt_alta WHEN ie_data_referencia_p=1 THEN b.dt_infeccao END  between trunc(dt_inicial_p) and trunc(dt_final_p)+86399/86400 and ((a.cd_clinica = cd_clinica_p) or (0 = cd_clinica_p)) and ((a.cd_estabelecimento = cd_estab_p) or (0 = cd_estab_p)) )/
			(select	count(*)
			from	cih_ficha_ocorrencia_v a
			where	a.dt_alta_interno between trunc(dt_inicial_p) and trunc(dt_final_p)+86399/86400
			and	((a.cd_clinica = cd_clinica_p) or (0 = cd_clinica_p))
			and	((a.cd_estabelecimento = cd_estab_p) or (0 = cd_estab_p)))*100) vl,
			2 cd
		
		
union

		select	wheb_mensagem_pck.get_texto(803129) ds,
			(select	count(distinct b.nr_ficha_ocorrencia)
			from	cih_ficha_ocorrencia_v a,
				cih_infeccao_v b
			where	a.nr_ficha_ocorrencia = b.nr_ficha_ocorrencia
			and	b.nr_ih > 0
			and	a.dt_alta_interno between trunc(dt_inicial_p) and trunc(dt_final_p)+86399/86400
			and	((a.cd_clinica = cd_clinica_p) or (0 = cd_clinica_p))
			and	((a.cd_estabelecimento = cd_estab_p) or (0 = cd_estab_p))) qt,
			((select	count(distinct b.nr_ficha_ocorrencia)
			from	cih_ficha_ocorrencia_v a,
				cih_infeccao_v b
			where	a.nr_ficha_ocorrencia = b.nr_ficha_ocorrencia
			and	b.nr_ih > 0
			and	a.dt_alta_interno between trunc(dt_inicial_p) and trunc(dt_final_p)+86399/86400
			and	((a.cd_clinica = cd_clinica_p) or (0 = cd_clinica_p))
			and	((a.cd_estabelecimento = cd_estab_p) or (0 = cd_estab_p)))/
			(select	count(*)
			from	cih_ficha_ocorrencia_v a
			where	a.dt_alta_interno between trunc(dt_inicial_p) and trunc(dt_final_p)+86399/86400
			and	((a.cd_clinica = cd_clinica_p) or (0 = cd_clinica_p))
			and	((a.cd_estabelecimento = cd_estab_p) or (0 = cd_estab_p)))*100) vl,
			3 cd
		
		
union

		select	wheb_mensagem_pck.get_texto(803130) ds,
			(select	count(distinct a.nr_ficha_ocorrencia)
			from	cih_ficha_ocorrencia_v a,
				cih_infeccao_v b,
				cih_tipo_evolucao c
			where	a.nr_ficha_ocorrencia	= b.nr_ficha_ocorrencia
			and	a.cd_tipo_evolucao	= c.cd_tipo_evolucao
			and	a.dt_alta_interno between trunc(dt_inicial_p) and trunc(dt_final_p)+86399/86400
			and	b.nr_ih	> 0
			and	c.ie_obito_ih = 'H'
			and	((a.cd_clinica = cd_clinica_p) or (0 = cd_clinica_p))
			and	((a.cd_estabelecimento = cd_estab_p) or (0 = cd_estab_p))) qt,
			((select	count(distinct a.nr_ficha_ocorrencia)
			from	cih_ficha_ocorrencia_v a,
				cih_infeccao_v b,
				cih_tipo_evolucao c
			where	a.nr_ficha_ocorrencia	= b.nr_ficha_ocorrencia
			and	a.cd_tipo_evolucao	= c.cd_tipo_evolucao
			and	a.dt_alta_interno between trunc(dt_inicial_p) and trunc(dt_final_p)+86399/86400
			and	b.nr_ih	> 0
			and	c.ie_obito_ih = 'H'
			and	((a.cd_clinica = cd_clinica_p) or (0 = cd_clinica_p))
			and	((a.cd_estabelecimento = cd_estab_p) or (0 = cd_estab_p)))/
			(select	count(*)
			from	cih_ficha_ocorrencia_v a
			where	a.dt_alta_interno between trunc(dt_inicial_p) and trunc(dt_final_p)+86399/86400
			and	((a.cd_clinica = cd_clinica_p) or (0 = cd_clinica_p))
			and	((a.cd_estabelecimento = cd_estab_p) or (0 = cd_estab_p)))*100) vl,
			4 cd
		
		
union

		select	wheb_mensagem_pck.get_texto(803131) ds,
			(select	count(distinct a.nr_ficha_ocorrencia)
			from	cih_ficha_ocorrencia_v a,
				cih_infeccao_v b,
				cih_tipo_evolucao c
			where	a.nr_ficha_ocorrencia	= b.nr_ficha_ocorrencia
			and	a.cd_tipo_evolucao	= c.cd_tipo_evolucao
			and	a.dt_alta_interno between trunc(dt_inicial_p) and trunc(dt_final_p)+86399/86400
			and	b.nr_ih	> 0
			and	c.ie_obito_ih = 'H'
			and	((a.cd_clinica = cd_clinica_p) or (0 = cd_clinica_p))
			and	((a.cd_estabelecimento = cd_estab_p) or (0 = cd_estab_p))) qt,
			((select	count(distinct a.nr_ficha_ocorrencia)
			from	cih_ficha_ocorrencia_v a,
				cih_infeccao_v b,
				cih_tipo_evolucao c
			where	a.nr_ficha_ocorrencia	= b.nr_ficha_ocorrencia
			and	a.cd_tipo_evolucao	= c.cd_tipo_evolucao
			and	a.dt_alta_interno between trunc(dt_inicial_p) and trunc(dt_final_p)+86399/86400
			and	b.nr_ih	> 0
			and	c.ie_obito_ih = 'H'
			and	((a.cd_clinica = cd_clinica_p) or (0 = cd_clinica_p))
			and	((a.cd_estabelecimento = cd_estab_p) or (0 = cd_estab_p)))/
			(select	sum(coalesce(b.nr_ih,0)) nr_ih
			FROM cih_infeccao_v b, cih_ficha_ocorrencia_v a
LEFT OUTER JOIN cih_evolucao_v c ON (a.cd_tipo_evolucao = c.cd_tipo_evolucao)
WHERE a.nr_ficha_ocorrencia	= b.nr_ficha_ocorrencia  and CASE WHEN ie_data_referencia_p=0 THEN a.dt_alta WHEN ie_data_referencia_p=1 THEN b.dt_infeccao END  between trunc(dt_inicial_p) and trunc(dt_final_p)+86399/86400 and ((a.cd_estabelecimento = cd_estab_p) or (0 = cd_estab_p)) )*100) vl,
			5 cd
		
		
union

		select	wheb_mensagem_pck.get_texto(803132) ds,
			(select	sum(coalesce(b.nr_ic,0)) nr_ic
			FROM cih_infeccao_v b, cih_ficha_ocorrencia_v a
LEFT OUTER JOIN cih_evolucao_v c ON (a.cd_tipo_evolucao = c.cd_tipo_evolucao)
WHERE a.nr_ficha_ocorrencia	= b.nr_ficha_ocorrencia  and CASE WHEN ie_data_referencia_p=0 THEN a.dt_alta WHEN ie_data_referencia_p=1 THEN b.dt_infeccao END  between trunc(dt_inicial_p) and trunc(dt_final_p)+86399/86400 and ((a.cd_clinica = cd_clinica_p) or (0 = cd_clinica_p)) and ((a.cd_estabelecimento = cd_estab_p) or (0 = cd_estab_p)) ) qt,
			((select	sum(coalesce(b.nr_ic,0)) nr_ic
			FROM cih_infeccao_v b, cih_ficha_ocorrencia_v a
LEFT OUTER JOIN cih_evolucao_v c ON (a.cd_tipo_evolucao = c.cd_tipo_evolucao)
WHERE a.nr_ficha_ocorrencia	= b.nr_ficha_ocorrencia  and CASE WHEN ie_data_referencia_p=0 THEN a.dt_alta WHEN ie_data_referencia_p=1 THEN b.dt_infeccao END  between trunc(dt_inicial_p) and trunc(dt_final_p)+86399/86400 and ((a.cd_clinica = cd_clinica_p) or (0 = cd_clinica_p)) and ((a.cd_estabelecimento = cd_estab_p) or (0 = cd_estab_p)) )/
			(select	count(*)
			from	cih_ficha_ocorrencia_v a
			where	a.dt_alta_interno between trunc(dt_inicial_p) and trunc(dt_final_p)+86399/86400
			and	((a.cd_clinica = cd_clinica_p) or (0 = cd_clinica_p))
			and	((a.cd_estabelecimento = cd_estab_p) or (0 = cd_estab_p)))*100) vl,
			6 cd
		) alias193
	where	cd = cd_p;

	if (ie_retorno_p = 'DS') then	ds_retorno_w	:= ds_indicador_w;
	elsif (ie_retorno_p = 'QT') then	ds_retorno_w	:= qt_indicador_w;
	elsif (ie_retorno_p = 'VL') then	ds_retorno_w	:= vl_indicador_w;
	elsif (ie_retorno_p = 'CD') then	ds_retorno_w	:= cd_w;
	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION wheb_indicadores_rela_wcih1812 (dt_inicial_p timestamp, dt_final_p timestamp, ie_data_referencia_p bigint, cd_estab_p bigint, cd_clinica_p bigint, cd_p bigint, ie_retorno_p text) FROM PUBLIC;

