-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_saldo_total_disp_estoque (cd_material_p bigint, cd_local_estoque_p bigint, cd_estabelecimento_p bigint, nr_seq_lote_fornec_p bigint default null, cd_cgc_fornecedor_p text default null, ie_soma_saldo_consig_p text default 'N') RETURNS bigint AS $body$
DECLARE


/* Function utilizada para obter o saldo disponivel dos materiais quando necessario verificar regra de material consignado ambos.
Caso o material for do tipo consignado ambos e houver regra de saldo consignado cadastrada, entao realizara a soma das quantidades disponiveis.
Do contrario, retorna o saldo consignado quando material consignado e o saldo proprio quando material nao consignado.
Caso o material for do tipo consignado ambos e nao houver regra de saldo consignado cadastrada,
sera retornado o saldo consignado caso houver fornecedor informado. Senao, retorna o sado proprio. */
/* ie_soma_saldo_consig_p -	Parametro utilizado para a funcao Requisicao de Materiais e Medicamentos,
				para apresentar a quantidade de estoque do item requisitado.
				Caso a operacao da requisicao for do tipo consignada e nao houver regra de consignado ambos,
				entao deve somar apenas o saldo consignado do item. */
ie_regra_saldo_consig_w	parametro_estoque.ie_regra_saldo_consig%type;
dt_mesano_vigente_w	parametro_estoque.dt_mesano_vigente%type;
cd_material_estoque_w	material.cd_material_estoque%type;
ie_consignado_w		material.ie_consignado%type;
ie_estoque_lote_w	material_estab.ie_estoque_lote%type;
cd_cgc_fornecedor_w	material_lote_fornec.cd_cgc_fornec%type := cd_cgc_fornecedor_p;
qt_saldo_estoque_w	double precision := 0;
qt_estoque_consigado_w	double precision := 0;


BEGIN

select	coalesce(max(ie_regra_saldo_consig),0),
	PKG_DATE_UTILS.start_of(clock_timestamp(), 'MONTH', 0)
into STRICT	ie_regra_saldo_consig_w,
	dt_mesano_vigente_w
from	parametro_estoque
where	cd_estabelecimento = cd_estabelecimento_p;

select	a.cd_material_estoque,
	coalesce(a.ie_consignado,'0'),
	coalesce(b.ie_estoque_lote, 'N')
into STRICT	cd_material_estoque_w,
	ie_consignado_w,
	ie_estoque_lote_w
from	material a,
	material_estab b
where	a.cd_material = b.cd_material
and	a.cd_material = cd_material_p
and	b.cd_estabelecimento = cd_estabelecimento_p;

/* Atencao aqui!
Caso nao for informado o fornecedor e houver lote fornecedor informado, sera obtido o fornecedor do lote.
Tratamento realizado para correto retorno do saldo no caso da utilizacao do objeto ao bipar item por barras. */
/*if	(cd_cgc_fornecedor_w is null) and
	(nr_seq_lote_fornec_p is not null) then
	cd_cgc_fornecedor_w := obter_dados_lote_fornec(
					nr_sequencia_p	=> nr_seq_lote_fornec_p,
					ie_opcao_p	=> 'CF');
end if;*/
/* Item proprio ou consignado ambos sem fornecedor informado. */

if (ie_consignado_w = '0') or (ie_consignado_w = '2' and coalesce(cd_cgc_fornecedor_w::text, '') = '' and (ie_soma_saldo_consig_p = 'N' or ie_regra_saldo_consig_w > 0)) then
	qt_saldo_estoque_w := obter_saldo_disp_estoque(
					cd_estabelecimento_p	=> cd_estabelecimento_p,
					cd_material_p		=> cd_material_estoque_w,
					cd_local_estoque_p	=> cd_local_estoque_p,
					dt_mesano_referencia_p	=> dt_mesano_vigente_w,
					nr_seq_lote_p		=> nr_seq_lote_fornec_p);

	/* Caso o item for consignado ambos e houver regra de consignado, devera somar o saldo consignado ao proprio. */

	if (ie_consignado_w = '2') and (ie_regra_saldo_consig_w > 0)then
		/* Utilizada a function abaixo porque ela era utilizada anteriormente para obter o saldo de estoque do item da requisicao ao cria-la,
		quando a requisicao fosse de operacao consignado. Caso for necessario alterar essa consulta,
		observar se os valores do item da requisicao estao sendo apresentados corretamente. */
		qt_estoque_consigado_w := obter_saldo_estoque_consig(
						cd_estabelecimento_p	=> cd_estabelecimento_p,
						cd_cgc_fornec_p		=> cd_cgc_fornecedor_w,
						cd_material_estoque_p	=> cd_material_estoque_w,
						cd_local_estoque_p	=> cd_local_estoque_p);

		qt_saldo_estoque_w	:= qt_saldo_estoque_w + qt_estoque_consigado_w;
	end if;

/* Item consignado ou consignado ambos com fornecedor informado. */

elsif (ie_consignado_w = '1') or (ie_consignado_w = '2' and ((cd_cgc_fornecedor_w IS NOT NULL AND cd_cgc_fornecedor_w::text <> '') or ie_soma_saldo_consig_p = 'S')) then
	/* Utilizada a function abaixo porque ela era utilizada anteriormente para obter o saldo de estoque do item da requisicao ao cria-la,
	quando a requisicao fosse de operacao consignado. Caso for necessario alterar essa consulta,
	observar se os valores do item da requisicao estao sendo apresentados corretamente. */
	qt_saldo_estoque_w := obter_saldo_estoque_consig(
					cd_estabelecimento_p	=> cd_estabelecimento_p,
					cd_cgc_fornec_p		=> cd_cgc_fornecedor_w,
					cd_material_estoque_p	=> cd_material_estoque_w,
					cd_local_estoque_p	=> cd_local_estoque_p);
end if;

return qt_saldo_estoque_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_saldo_total_disp_estoque (cd_material_p bigint, cd_local_estoque_p bigint, cd_estabelecimento_p bigint, nr_seq_lote_fornec_p bigint default null, cd_cgc_fornecedor_p text default null, ie_soma_saldo_consig_p text default 'N') FROM PUBLIC;
