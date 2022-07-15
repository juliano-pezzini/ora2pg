-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_devolucao_material ( nr_sequencia_p bigint, nr_item_nf_p bigint, qt_devolucao_p bigint, nr_seq_nf_origem_p bigint, ie_estorna_ordem_p text, nm_usuario_p text) AS $body$
DECLARE


vl_total_item_nf_w		double precision;
vl_unitario_item_nf_w	double precision;
vl_desconto_w			double precision;
vl_liquido_w			double precision;
nr_seq_unidade_adic_w	bigint;
qt_conversao_w			double precision;
qt_item_estoque_w		double precision;
qt_registros_w			integer;
nr_ordem_compra_w		bigint;
nr_item_oci_w			bigint;
cd_material_w			integer;
cd_estabelecimento_w	smallint;
dt_entrega_ordem_w		timestamp;
ds_historico_w			varchar(2000);
nr_nota_fiscal_w		varchar(255);


BEGIN

select	count(1)
into STRICT	qt_registros_w
from	nota_fiscal_item a
where	a.nr_sequencia 	= nr_sequencia_p
and		a.nr_item_nf 	= nr_item_nf_p
and		a.qt_item_nf >= qt_devolucao_p;

if (qt_registros_w > 0) and (qt_devolucao_p > 0) then
	select	a.vl_total_item_nf,
			a.vl_unitario_item_nf,
			coalesce(a.vl_desconto,0),
			coalesce(a.nr_seq_unidade_adic,0),
			obter_qt_convertida_compra_est(a.cd_material,qt_devolucao_p,a.cd_unidade_medida_compra,a.nr_seq_marca,b.cd_cgc,b.cd_estabelecimento),
			b.cd_estabelecimento,
			b.nr_nota_fiscal
	into STRICT	vl_total_item_nf_w,
			vl_unitario_item_nf_w,
			vl_desconto_w,
			nr_seq_unidade_adic_w,
			qt_item_estoque_w,
			cd_estabelecimento_w,
			nr_nota_fiscal_w
	from	nota_fiscal_item a,
			nota_fiscal b
	where	a.nr_sequencia 	= nr_sequencia_p
	and		a.nr_item_nf 	= nr_item_nf_p
	and		a.nr_sequencia 	= b.nr_sequencia
	and		a.qt_item_nf >= qt_devolucao_p;

	vl_total_item_nf_w	:= (qt_devolucao_p * vl_unitario_item_nf_w);
	vl_liquido_w		:= (vl_total_item_nf_w - vl_desconto_w);

	update	nota_fiscal_item
	set	vl_liquido = vl_liquido_w,
		vl_total_item_nf = vl_total_item_nf_w,
		qt_item_estoque = qt_item_estoque_w,
		qt_item_nf = qt_devolucao_p
	where	nr_sequencia = nr_sequencia_p
	and	nr_item_nf = nr_item_nf_p;

	ds_historico_w	:= wheb_mensagem_pck.get_texto(311000) || ': ' || nr_nota_fiscal_w || ' seq.: ' || nr_sequencia_p;


	if (ie_estorna_ordem_p = 'S') then
		begin
		ds_historico_w	:= wheb_mensagem_pck.get_texto(311003) ||': '||nr_seq_nf_origem_p || ' seq.: ' || nr_sequencia_p;

		begin
		select	a.nr_ordem_compra,
			a.nr_item_oci,
			a.cd_material,
			a.dt_entrega_ordem
		into STRICT	nr_ordem_compra_w,
			nr_item_oci_w,
			cd_material_w,
			dt_entrega_ordem_w
		from	nota_fiscal_item a
		where	a.nr_sequencia = nr_seq_nf_origem_p
		and	(a.nr_ordem_compra IS NOT NULL AND a.nr_ordem_compra::text <> '')
		and	a.nr_item_nf = nr_item_nf_p;
		exception
		when others then
			nr_ordem_compra_w	:= 0;
		end;

		if (nr_ordem_compra_w > 0) then
			CALL estornar_baixa_OC_nota_dev(nr_ordem_compra_w, nr_item_oci_w, dt_entrega_ordem_w, nm_usuario_p,cd_estabelecimento_w,qt_devolucao_p);
		end if;
		end;
	end if;

	CALL gerar_historico_nota_fiscal(nr_seq_nf_origem_p, nm_usuario_p, '3', ds_historico_w);
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_devolucao_material ( nr_sequencia_p bigint, nr_item_nf_p bigint, qt_devolucao_p bigint, nr_seq_nf_origem_p bigint, ie_estorna_ordem_p text, nm_usuario_p text) FROM PUBLIC;

