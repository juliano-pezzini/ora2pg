-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_material (cd_estabelecimento_p bigint, cd_material_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(80);
qt_saldo_almoxarifado_w		double precision;
qt_minima_planej_w		double precision;
qt_maxima_planej_w		double precision;
qt_consumo_30_dias_w		double precision;
qt_consumo_90_dias_w		double precision;
qt_consumo_180_dias_w		double precision;
qt_consumo_base_calculo_w	double precision;
qt_cobertura_almoxarifado_w	double precision;
qt_dia_planej_w			double precision;
qt_dia_compra_w			double precision;
qt_dia_frequencia_w		double precision;
qt_dia_ressup_forn_w		smallint;
qt_estoque_seguranca_w		double precision;

--function criada para a OS de projeto 509264.
BEGIN

select	coalesce(b.qt_dia_compra,0),
	coalesce(b.qt_dia_frequencia,0)
into STRICT	qt_dia_compra_w,
                qt_dia_frequencia_w
from	segmento_compras_estrut a,
	grupo_segmento_compras b,
	segmento_compras  c,
	segmento_compra_vinc_grupo d
where	c.nr_sequencia = d.nr_seq_segmento
and	d.nr_seq_grupo = b.nr_sequencia
and	a.nr_seq_segmento = c.nr_sequencia
and	a.cd_material = cd_material_p;


select	coalesce(sum(obter_saldo_disp_estoque(cd_estabelecimento_p, cd_material_p, cd_local_estoque, trunc(clock_timestamp(),'mm'))),0)
					into STRICT	qt_saldo_almoxarifado_w
					from	local_estoque
					where	ie_tipo_local = 4
					and	cd_estabelecimento = cd_estabelecimento_p;

select 	coalesce(a.qt_maxima_planej,0),
                coalesce(a.qt_minima_planej,0),
	coalesce(b.qt_dia_ressup_forn,0)
into STRICT	qt_maxima_planej_w,
                qt_minima_planej_w,
	qt_dia_ressup_forn_w
from	material a,
	material_estab b
where	a.cd_material = b.cd_material
and	a.cd_material = cd_material_p
and	b.cd_estabelecimento = cd_estabelecimento_p;


select	dividir(coalesce(sum(qt_consumo),0),30)
into STRICT	qt_consumo_30_dias_w
from   	movimento_estoque_v a,
	material m
where  	a.cd_material_estoque	= m.cd_material_estoque
and  	m.cd_material         	= cd_material_p
and  	a.cd_estabelecimento 	= cd_estabelecimento_p
and  	trunc(dt_movimento_estoque,'dd') between trunc(clock_timestamp() - interval '29 days','dd') and trunc(clock_timestamp(),'dd')
and 	((not exists (
		SELECT  1
		from	operacao_nota x
		where	x.cd_operacao_estoque = a.cd_operacao_estoque
		and	coalesce(x.ie_transferencia_estab, 'N') = 'S'))
		and (a.cd_centro_custo IS NOT NULL AND a.cd_centro_custo::text <> ''));


select	dividir(coalesce(sum(qt_consumo),0),90)
into STRICT	qt_consumo_90_dias_w
from   	movimento_estoque_v a,
	material m
where  	a.cd_material_estoque	= m.cd_material_estoque
and  	m.cd_material         	= cd_material_p
and  	a.cd_estabelecimento 	= cd_estabelecimento_p
and  	trunc(dt_movimento_estoque,'dd') between trunc(clock_timestamp() - interval '89 days','dd') and trunc(clock_timestamp(),'dd')
and 	((not exists (
		SELECT	1
		from	operacao_nota x
		where	x.cd_operacao_estoque = a.cd_operacao_estoque
		and	coalesce(x.ie_transferencia_estab, 'N') = 'S'))
		and (a.cd_centro_custo IS NOT NULL AND a.cd_centro_custo::text <> ''));


select	dividir(coalesce(sum(qt_consumo),0),90)
into STRICT	qt_consumo_180_dias_w
from   	movimento_estoque_v a,
	material m
where  	a.cd_material_estoque	= m.cd_material_estoque
and  	m.cd_material         	= cd_material_p
and  	a.cd_estabelecimento 	= cd_estabelecimento_p
and  	trunc(dt_movimento_estoque,'dd') between trunc(clock_timestamp() - interval '179 days','dd') and trunc(clock_timestamp(),'dd')
and 	((not exists (
		SELECT	1
		from	operacao_nota x
		where	x.cd_operacao_estoque = a.cd_operacao_estoque
		and	coalesce(x.ie_transferencia_estab, 'N') = 'S'))
		and (a.cd_centro_custo IS NOT NULL AND a.cd_centro_custo::text <> ''));


	qt_consumo_base_calculo_w := qt_consumo_30_dias_w;
if (qt_consumo_base_calculo_w = 0) then
	qt_consumo_base_calculo_w := qt_consumo_90_dias_w;
elsif (qt_consumo_base_calculo_w = 0) then
	qt_consumo_base_calculo_w := qt_consumo_180_dias_w;
end if;

qt_cobertura_almoxarifado_w	:= coalesce(dividir(qt_saldo_almoxarifado_w,qt_consumo_base_calculo_w),0);

-- qt_dia_compra_w - qt_dia_frequencia_w  = Estoque médio
qt_estoque_seguranca_w := qt_dia_compra_w - (qt_dia_ressup_forn_w + qt_dia_frequencia_w);

if (qt_maxima_planej_w <> 0) and (qt_minima_planej_w <> 0) and (qt_saldo_almoxarifado_w  > qt_minima_planej_w) and (qt_saldo_almoxarifado_w  < qt_maxima_planej_w) then
	ds_retorno_w	:= Wheb_mensagem_pck.get_texto(309922); --'Dentro da Faixa';
else if (qt_saldo_almoxarifado_w = 0) then
	ds_retorno_w	:= Wheb_mensagem_pck.get_texto(309923); --'Sem Estoque';
else if (qt_maxima_planej_w <> 0) and (qt_minima_planej_w <> 0) and (qt_saldo_almoxarifado_w < qt_maxima_planej_w) then
	ds_retorno_w	:= Wheb_mensagem_pck.get_texto(309924); --'Abaixo Est Min';
else if (qt_maxima_planej_w <> 0) and (qt_minima_planej_w <> 0) and (qt_saldo_almoxarifado_w > qt_maxima_planej_w) then
	ds_retorno_w	:= Wheb_mensagem_pck.get_texto(309925); --'Acima Est Max';
else if (qt_cobertura_almoxarifado_w > qt_dia_compra_w) then
	ds_retorno_w	:= Wheb_mensagem_pck.get_texto(309926); --'Excesso';
else if       (qt_cobertura_almoxarifado_w > (qt_dia_compra_w - qt_dia_frequencia_w))	then
	ds_retorno_w	:= Wheb_mensagem_pck.get_texto(309927); --'Dentro da Política';
else if (qt_cobertura_almoxarifado_w >= qt_estoque_seguranca_w)	 then
	ds_retorno_w	:= Wheb_mensagem_pck.get_texto(309928); --'Est Médio';
else if (qt_cobertura_almoxarifado_w < qt_estoque_seguranca_w)	 then
	ds_retorno_w	:= Wheb_mensagem_pck.get_texto(309929); --'Est Seg';
end if;
end if;
end if;
end if;
end if;
end if;
end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_material (cd_estabelecimento_p bigint, cd_material_p bigint) FROM PUBLIC;
