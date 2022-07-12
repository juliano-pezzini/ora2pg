-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_maior_compra_mes ( cd_estabelecimento_p bigint, cd_material_p bigint, dt_mesano_referencia_p timestamp, ie_retorno_p text) RETURNS varchar AS $body$
DECLARE


/*dados:
SE	-= Sequência da NF
VU	= valor unitario item nf
PJ	= CGC fornecedor
MA	= Código da Marca
*/
nr_sequencia_w			bigint;
vl_unitario_item_nf_w		double precision;
vl_unitario_result_w		double precision;
nr_sequencia_result_w		bigint;
cd_cgc_emitente_w		varchar(14);
nr_seq_marca_w			bigint;
nr_seq_marca_result_w		bigint;
ds_retorno_w			varchar(255);


c01 CURSOR FOR
SELECT	x.nr_sequencia,
	y.vl_unitario_item_nf,
	y.nr_seq_marca
from	natureza_operacao n,
	operacao_nota o,
	nota_fiscal x,
	nota_fiscal_item y
where	x.nr_sequencia = y.nr_sequencia
and	n.cd_natureza_operacao = x.cd_natureza_operacao
and	x.cd_operacao_nf = o.cd_operacao_nf
and	n.ie_entrada_saida = 'E'
and	x.ie_acao_nf = 1
and	coalesce(o.ie_ultima_compra, 'S') = 'S'
and	y.cd_material	= cd_material_p
and	y.cd_estabelecimento = cd_estabelecimento_p
and	trunc(x.dt_emissao,'mm') = dt_mesano_referencia_p
order by vl_unitario_item_nf desc;



BEGIN

vl_unitario_item_nf_w		:= 0;
vl_unitario_result_w		:= 0;
nr_sequencia_result_w		:= 0;

open C01;
loop
fetch C01 into
	nr_sequencia_w,
	vl_unitario_item_nf_w,
	nr_seq_marca_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	--if	(vl_unitario_item_nf_w > vl_unitario_result_w) then
		vl_unitario_result_w 	:= vl_unitario_item_nf_w;
		nr_sequencia_result_w	:= nr_sequencia_w;
		nr_seq_marca_result_w	:= nr_seq_marca_w;
	--end if;
	exit;

	end;
end loop;
close C01;

if (nr_sequencia_result_w > 0) then

	select	cd_cgc_emitente
	into STRICT	cd_cgc_emitente_w
	from	nota_fiscal
	where	nr_sequencia = nr_sequencia_result_w;

	if (ie_retorno_p = 'SE') then
		ds_retorno_w	:= nr_sequencia_result_w;
	elsif (ie_retorno_p = 'VU') then
		ds_retorno_w 	:= vl_unitario_result_w;
	elsif (ie_retorno_p = 'PJ') then
		ds_retorno_w 	:= cd_cgc_emitente_w;
	elsif (ie_retorno_p = 'MA') then
		ds_retorno_w 	:= nr_seq_marca_result_w;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_maior_compra_mes ( cd_estabelecimento_p bigint, cd_material_p bigint, dt_mesano_referencia_p timestamp, ie_retorno_p text) FROM PUBLIC;

