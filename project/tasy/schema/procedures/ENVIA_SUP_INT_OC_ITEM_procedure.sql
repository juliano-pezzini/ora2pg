-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE envia_sup_int_oc_item ( nr_ordem_compra_p bigint, nr_sequencia_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_de_para_unid_med_w		varchar(15);
ie_de_para_material_w		varchar(15);
qt_existe_w			bigint;

nr_item_oci_w			integer;
cd_material_w			integer;
cd_unidade_medida_compra_w	varchar(30);
vl_unitario_material_w		double precision;
qt_material_w			double precision;
ds_material_direto_w		varchar(255);
ds_observacao_w			varchar(255);
cd_centro_custo_w		integer;
cd_conta_contabil_w		varchar(20);
qt_existe_item_w			bigint;
vl_ipi_w			sup_int_oc_item.vl_ipi%type;
tx_ipi_w			sup_int_oc_item.tx_ipi%type;
pr_descontos_w			sup_int_oc_item.pr_descontos%type;
vl_desconto_w			sup_int_oc_item.vl_desconto%type;
nr_seq_marca_w			ordem_compra_item.nr_seq_marca%type;

c01 CURSOR FOR
SELECT	nr_item_oci,
	cd_material,
	cd_unidade_medida_compra,
	vl_unitario_material,
	qt_material,
	ds_material_direto,
	ds_observacao,
	cd_centro_custo,
	cd_conta_contabil,
	nr_seq_marca
from	ordem_compra_item
where	nr_ordem_compra = nr_ordem_compra_p;


BEGIN

select	obter_ie_de_para_sup_integr('OC','E','UNIDADE_MEDIDA'),
	obter_ie_de_para_sup_integr('OC','E','MATERIAL')
into STRICT	ie_de_para_unid_med_w,
	ie_de_para_material_w
;

open c01;
loop
fetch c01 into
	nr_item_oci_w,
	cd_material_w,
	cd_unidade_medida_compra_w,
	vl_unitario_material_w,
	qt_material_w,
	ds_material_direto_w,
	ds_observacao_w,
	cd_centro_custo_w,
	cd_conta_contabil_w,
	nr_seq_marca_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select	max(vl_ipi),
		max(tx_ipi),
		max(pr_descontos)
	into STRICT	vl_ipi_w,
		tx_ipi_w,
		pr_descontos_w
	from	sup_int_oc_item
	where	nr_sequencia = nr_sequencia_p
	and	nr_item_oci = nr_item_oci_w;

	if (coalesce(pr_descontos_w,0) > 0) then
		vl_desconto_w := dividir((qt_material_w * vl_unitario_material_w * pr_descontos_w),100);
	else
		vl_desconto_w := pr_descontos_w;
	end if;

	select	count(*)
	into STRICT	qt_existe_item_w
	from	sup_int_oc_item
	where	nr_sequencia = nr_sequencia_p
	and	nr_item_oci = nr_item_oci_w;

	if (qt_existe_item_w > 0) then
		begin

		delete
		from	sup_int_oc_item
		where	nr_sequencia = nr_sequencia_p
		and	nr_item_oci = nr_item_oci_w;

		end;
	end if;

	/*Conversao para unidade de medida*/

	if (ie_de_para_unid_med_w = 'C') then
		cd_unidade_medida_compra_w	:= coalesce(Obter_Conversao_externa(null,'UNIDADE_MEDIDA','CD_UNIDADE_MEDIDA',cd_unidade_medida_compra_w),cd_unidade_medida_compra_w);
	elsif (ie_de_para_unid_med_w = 'S') then
		cd_unidade_medida_compra_w	:= coalesce(obter_dados_unid_medida(cd_unidade_medida_compra_w,'SA'),cd_unidade_medida_compra_w);
	end if;

	/*Conversao para material*/

	if (ie_de_para_material_w = 'C') then
		cd_material_w		:= coalesce(Obter_Conversao_externa(null,'MATERIAL','CD_MATERIAL',cd_material_w),cd_material_w);
	elsif (ie_de_para_material_w = 'S') then
		cd_material_w	:= coalesce(obter_dados_material_estab(cd_material_w, cd_estabelecimento_p, 'CSA'),cd_material_w);
	end if;

	insert into sup_int_oc_item(
		nr_sequencia,
		nr_item_oci,
		nr_ordem_compra,
		cd_material,
		cd_unidade_medida_compra,
		vl_unitario_material,
		qt_material,
		ds_material_direto,
		ds_observacao,
		cd_centro_custo,
		cd_conta_contabil,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		vl_ipi,
		tx_ipi,
		pr_descontos,
		vl_desconto,
		nr_seq_marca) values (
			nr_sequencia_p,
			nr_item_oci_w,
			nr_ordem_compra_p,
			cd_material_w,
			cd_unidade_medida_compra_w,
			vl_unitario_material_w,
			qt_material_w,
			ds_material_direto_w,
			ds_observacao_w,
			cd_centro_custo_w,
			cd_conta_contabil_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			vl_ipi_w,
			tx_ipi_w,
			pr_descontos_w,
			vl_desconto_w,
			nr_seq_marca_w);

	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE envia_sup_int_oc_item ( nr_ordem_compra_p bigint, nr_sequencia_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
