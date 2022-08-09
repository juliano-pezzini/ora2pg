-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE far_atualizar_total_item ( nr_seq_item_p bigint, nm_usuario_p text) AS $body$
DECLARE


vl_total_trib_w		far_venda_item.vl_liquido%type;
vl_total_w		far_venda_item.vl_total%type;
vl_desconto_w		far_venda_item.vl_desconto%type;
nr_seq_venda_w		far_venda.nr_sequencia%type;


BEGIN

if (nr_seq_item_p IS NOT NULL AND nr_seq_item_p::text <> '') then

	select	max(nr_seq_venda) nr_seq_venda
	into STRICT	nr_seq_venda_w
	from	far_venda_item
	where	nr_sequencia = nr_seq_item_p;

	-- TEM QUE CHAMAR PARA CÁLCULAR O IMPOSTO DO ITEM
	CALL far_gerar_tributo_item(nr_seq_venda_w,nr_seq_item_p,nm_usuario_p);

	select	coalesce(sum(CASE WHEN b.ie_soma_diminui='S' THEN a.vl_tributo WHEN b.ie_soma_diminui='D' THEN a.vl_tributo*-1  ELSE 0 END ),0) vl_tributo
	into STRICT	vl_total_trib_w
	from	far_venda_item_trib a,
		tributo b
	where	a.cd_tributo = b.cd_tributo
	and	a.nr_seq_item = nr_seq_item_p;

	select (qt_material * vl_unitario) vl_total, -- ANTES BUSCAVA PELO VALOR TOTAL (VL_TOTAL), ONDE JÁ ESTÁ DIMINUIDO O VALOR DO DESCONTO, COM ISSO CALCULANDO DUAS VEZES O DESCONTO
			vl_desconto
	into STRICT	vl_total_w,
		vl_desconto_w
	from	far_venda_item
	where	nr_sequencia = nr_seq_item_p;

	update	far_venda_item
	set	vl_liquido = vl_total_w + vl_total_trib_w - vl_desconto_w,
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where	nr_sequencia = nr_seq_item_p;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE far_atualizar_total_item ( nr_seq_item_p bigint, nm_usuario_p text) FROM PUBLIC;
