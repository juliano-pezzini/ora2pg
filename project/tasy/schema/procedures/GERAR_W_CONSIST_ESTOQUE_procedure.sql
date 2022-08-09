-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_consist_estoque ( cd_estabelecimento_p bigint, dt_mesano_referencia_p timestamp, ie_situacao_mat_p text, ie_tipo_p text) AS $body$
DECLARE


/*
ie_tipo_p
0 = Cadastro
1 = Saldo estoque
*/
ie_situacao_w	varchar(1);


BEGIN
if (ie_situacao_mat_p = '1') then
	ie_situacao_w := 'A';
elsif (ie_situacao_mat_p = '2') then
	ie_situacao_w := 'I';
else
	ie_situacao_w := null;
end if;

delete
from	w_consistencia_estoque;

/*Material consignado com saldo normal ou vive-versa*/

insert into w_consistencia_estoque(
	dt_mesano_referencia,
	ie_tipo,
	cd_material,
	ds_consistencia)
SELECT	dt_mesano_referencia_p,
	'0',
	a.cd_material,
	substr(wheb_mensagem_pck.get_texto(310773),1,255)
from	material a,
	material_estab b
where	a.cd_material		= b.cd_material
and	b.cd_estabelecimento	= cd_estabelecimento_p
and	a.ie_consignado		= '0'
and	a.ie_situacao 		= coalesce(ie_situacao_w,a.ie_situacao)
and exists (
	SELECT	1
	from	fornecedor_mat_consignado x
	where	x.dt_mesano_referencia	= dt_mesano_referencia_p
	and	x.cd_estabelecimento	= b.cd_estabelecimento
	and	x.cd_material		= a.cd_material
	and	x.qt_estoque		<> 0);

insert into w_consistencia_estoque(
	dt_mesano_referencia,
	ie_tipo,
	cd_material,
	ds_consistencia)
SELECT	dt_mesano_referencia_p,
	'0',
	a.cd_material,
	substr(wheb_mensagem_pck.get_texto(310774),1,255)
from	material_estab b,
	material a
where	a.cd_material		= b.cd_material
and	b.cd_estabelecimento	= cd_estabelecimento_p
and	a.ie_consignado		= '1'
and	a.ie_situacao 		= coalesce(ie_situacao_w,a.ie_situacao)
and exists (
	SELECT	1
	from	saldo_estoque x
	where	x.dt_mesano_referencia	= dt_mesano_referencia_p
	and	x.cd_estabelecimento	= b.cd_estabelecimento
	and	x.cd_material		= a.cd_material
	and	x.qt_estoque		<> 0);





/*Material Inativo com saldo estoque*/

insert into w_consistencia_estoque(
	dt_mesano_referencia,
	ie_tipo,
	cd_material,
	ds_consistencia)
SELECT	dt_mesano_referencia_p,
	'0',
	a.cd_material,
	substr(wheb_mensagem_pck.get_texto(310775),1,255)
from	material_estab b,
	material a
where	a.cd_material		= b.cd_material
and	b.cd_estabelecimento	= cd_estabelecimento_p
and	a.ie_situacao		= 'I'
and	a.ie_situacao 		= coalesce(ie_situacao_w,a.ie_situacao)
and exists (
	SELECT	1
	from	fornecedor_mat_consignado x
	where	x.dt_mesano_referencia	= dt_mesano_referencia_p
	and	x.cd_estabelecimento	= b.cd_estabelecimento
	and	x.cd_material		= a.cd_material
	and	x.qt_estoque		<> 0
	
union all

	select	1
	from	saldo_estoque x
	where	x.dt_mesano_referencia	= dt_mesano_referencia_p
	and	x.cd_estabelecimento	= b.cd_estabelecimento
	and	x.cd_material		= a.cd_material
	and	x.qt_estoque		<> 0);





/*Material não é de estoque com saldo estoque*/

insert into w_consistencia_estoque(
	dt_mesano_referencia,
	ie_tipo,
	cd_material,
	ds_consistencia)
SELECT	dt_mesano_referencia_p,
	'0',
	a.cd_material,
	substr(wheb_mensagem_pck.get_texto(310778),1,255)
from	material_estab b,
	material a
where	a.cd_material		= b.cd_material
and	b.cd_estabelecimento	= cd_estabelecimento_p
and	b.ie_material_estoque	= 'N'
and	a.ie_situacao 		= coalesce(ie_situacao_w,a.ie_situacao)
and exists (
	SELECT	1
	from	fornecedor_mat_consignado x
	where	x.dt_mesano_referencia	= dt_mesano_referencia_p
	and	x.cd_estabelecimento	= b.cd_estabelecimento
	and	x.cd_material		= a.cd_material
	and	x.qt_estoque		<> 0
	
union all

	select	1
	from	saldo_estoque z
	where	z.dt_mesano_referencia	= dt_mesano_referencia_p
	and	z.cd_estabelecimento	= b.cd_estabelecimento
	and	z.cd_material		= a.cd_material
	and	z.qt_estoque		<> 0);





/*Material não controlador dele mesmo e com saldo estoque*/

insert into w_consistencia_estoque(
	dt_mesano_referencia,
	ie_tipo,
	cd_material,
	ds_consistencia)
SELECT	dt_mesano_referencia_p,
	'0',
	a.cd_material,
	substr(wheb_mensagem_pck.get_texto(310779),1,255)
from	material b,
	saldo_estoque a
where	a.dt_mesano_referencia	= dt_mesano_referencia_p
and	a.cd_estabelecimento	= cd_estabelecimento_p
and	a.cd_material		= b.cd_material
and	a.qt_estoque		<> 0
and	b.ie_situacao 		= coalesce(ie_situacao_w,b.ie_situacao)
and exists (
	SELECT	1
	from	material x
	where	x.cd_material	= a.cd_material
	and	x.cd_material	<> x.cd_material_estoque);

insert into w_consistencia_estoque(
	dt_mesano_referencia,
	ie_tipo,
	cd_material,
	ds_consistencia)
SELECT	dt_mesano_referencia_p,
	'0',
	a.cd_material,
	substr(wheb_mensagem_pck.get_texto(310780),1,255)
from	material b,
	fornecedor_mat_consignado a
where	a.dt_mesano_referencia	= dt_mesano_referencia_p
and	a.cd_estabelecimento	= cd_estabelecimento_p
and	a.cd_material		= b.cd_material
and	a.qt_estoque		<> 0
and	b.ie_situacao 		= coalesce(ie_situacao_w,b.ie_situacao)
and exists (
	SELECT	1
	from	material x
	where	x.cd_material	= a.cd_material
	and	x.cd_material	<> x.cd_material_estoque);





/*Material em estoque com local inativo*/

insert into w_consistencia_estoque(
	dt_mesano_referencia,
	ie_tipo,
	cd_material,
	ds_consistencia)
SELECT	dt_mesano_referencia_p,
	'0',
	a.cd_material,
	substr(wheb_mensagem_pck.get_texto(310781,'CD_LOCAL_ESTOQUE= ' || c.cd_local_estoque),1,255)
from	local_estoque c,
	material b,
	saldo_estoque a
where	a.dt_mesano_referencia	= dt_mesano_referencia_p
and	a.cd_estabelecimento	= cd_estabelecimento_p
and	a.cd_material		= b.cd_material
and	a.cd_local_estoque		= c.cd_local_estoque
and	c.ie_situacao		= 'I'
and	b.ie_situacao 		= coalesce(ie_situacao_w,b.ie_situacao)
and	a.qt_estoque		<> 0;

insert into w_consistencia_estoque(
	dt_mesano_referencia,
	ie_tipo,
	cd_material,
	ds_consistencia)
SELECT	dt_mesano_referencia_p,
	'0',
	a.cd_material,
	substr(wheb_mensagem_pck.get_texto(310783,'CD_LOCAL_ESTOQUE= ' || c.cd_local_estoque),1,255)
from	local_estoque c,
	material b,
	fornecedor_mat_consignado a
where	a.dt_mesano_referencia	= dt_mesano_referencia_p
and	a.cd_estabelecimento	= cd_estabelecimento_p
and	a.cd_material		= b.cd_material
and	a.cd_local_estoque		= c.cd_local_estoque
and	c.ie_situacao		= 'I'
and	b.ie_situacao 		= coalesce(ie_situacao_w,b.ie_situacao)
and	a.qt_estoque		<> 0;




/*Terminou com saldo e não possui saldo no mês futuro */

insert into w_consistencia_estoque(
	dt_mesano_referencia,
	ie_tipo,
	cd_material,
	ds_consistencia)
SELECT	dt_mesano_referencia_p,
	'1',
	a.cd_material,
	substr(wheb_mensagem_pck.get_texto(310784,'CD_LOCAL_ESTOQUE= ' || cd_local_estoque),1,255)
from	saldo_estoque a
where	a.dt_mesano_referencia	= dt_mesano_referencia_p
and	cd_estabelecimento		= cd_estabelecimento_p
and	PKG_DATE_UTILS.start_of(clock_timestamp(),'month',0)		> dt_mesano_referencia_p /*somente se o mes não for o atual*/
and	a.qt_estoque > 0
and	not exists (
	SELECT	1
	from	saldo_estoque b
	where	b.cd_estabelecimento	= a.cd_estabelecimento
	and	b.cd_local_estoque		= a.cd_local_estoque
	and	b.cd_material		= a.cd_material
	and	b.dt_mesano_referencia	= PKG_DATE_UTILS.ADD_MONTH(dt_mesano_referencia_p, 1, 0));

/*Unidade de consumo do material é diferente do controlador*/

insert into w_consistencia_estoque(
	dt_mesano_referencia,
	ie_tipo,
	cd_material,
	ds_consistencia)
SELECT	dt_mesano_referencia_p,
	'0',
	a.cd_material,
	substr(wheb_mensagem_pck.get_texto(310787),1,255)
from	material a,
	material b
where	a.cd_material_estoque = b.cd_material
and	a.cd_unidade_medida_consumo <> b.cd_unidade_medida_consumo
and	a.ie_situacao 		= coalesce(ie_situacao_w,a.ie_situacao)
and 	not exists (select	1
			from	material_conversao_unidade x
			where	x.cd_material = b.cd_material
			and	x.cd_unidade_medida = a.cd_unidade_medida_consumo);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_consist_estoque ( cd_estabelecimento_p bigint, dt_mesano_referencia_p timestamp, ie_situacao_mat_p text, ie_tipo_p text) FROM PUBLIC;
