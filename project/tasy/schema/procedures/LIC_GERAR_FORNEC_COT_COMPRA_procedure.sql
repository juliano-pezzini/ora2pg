-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lic_gerar_fornec_cot_compra ( nr_seq_licitacao_p bigint, nm_usuario_p text) AS $body$
DECLARE



cd_cgc_fornecedor_w					cot_compra_forn.cd_cgc_fornecedor%type;
cd_pessoa_fisica_w					cot_compra_forn.cd_pessoa_fisica%type;
cd_material_w						cot_compra_forn_item.cd_material%type;
vl_unitario_material_w					cot_compra_forn_item.vl_unitario_material%type;
qt_material_w						cot_compra_forn_item.qt_material%type;
ds_marca_fornec_w					cot_compra_forn_item.ds_marca_fornec%type;
nr_seq_fornec_w						reg_lic_fornec.nr_sequencia%type;
nr_seq_item_w						reg_lic_item_fornec.nr_sequencia%type;
nr_seq_lic_item_w						reg_lic_item.nr_seq_lic_item%type;
nr_seq_marca_w						marca.nr_sequencia%type;

c01 CURSOR FOR
SELECT	b.cd_cgc_fornecedor,
	b.cd_pessoa_fisica,
	c.cd_material,
	c.vl_unitario_material,
	c.qt_material,
	coalesce(c.ds_marca_fornec,c.ds_marca)
from	cot_compra a,
	cot_compra_forn b,
	cot_compra_forn_item c
where	a.nr_cot_compra = b.nr_cot_compra
and	b.nr_sequencia = c.nr_seq_cot_forn
and	a.nr_seq_reg_licitacao = nr_seq_licitacao_p
order by	cd_cgc_fornecedor,
	cd_material;


BEGIN

open C01;
loop
fetch C01 into
	cd_cgc_fornecedor_w,
	cd_pessoa_fisica_w,
	cd_material_w,
	vl_unitario_material_w,
	qt_material_w,
	ds_marca_fornec_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_fornec_w
	from	reg_lic_fornec
	where	nr_seq_licitacao = nr_seq_licitacao_p
	and	((cd_cgc_fornecedor_w IS NOT NULL AND cd_cgc_fornecedor_w::text <> '' AND cd_cgc_fornec = cd_cgc_fornecedor_w) or
		 (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '' AND cd_pessoa_fisica = cd_pessoa_fisica_w));

	if (nr_seq_fornec_w = 0) then

		select	nextval('reg_lic_fornec_seq')
		into STRICT	nr_seq_fornec_w
		;

		insert into reg_lic_fornec(
			nr_sequencia,
			nr_seq_licitacao,
			dt_atualizacao,
			nm_usuario,
			cd_cgc_fornec,
			cd_pessoa_fisica,
			ds_tecnico,
			ie_situacao,
			ds_motivo_inativo,
			ie_habilitado,
			ds_motivo_desabilitado)
		values (	nr_seq_fornec_w,
			nr_seq_licitacao_p,
			clock_timestamp(),
			nm_usuario_p,
			cd_cgc_fornecedor_w,
			cd_pessoa_fisica_w,
			null,
			'A',
			'',
			null,
			null);
	end if;

	select	coalesce(max(nr_seq_lic_item),0)
	into STRICT	nr_seq_lic_item_w
	from	reg_lic_item
	where	nr_seq_licitacao = nr_seq_licitacao_p
	and	cd_material = cd_material_w;

	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_item_w
	from	reg_lic_item_fornec
	where	nr_Seq_fornec = nr_seq_fornec_w
	and	cd_material = cd_material_w;

	if (nr_seq_lic_item_w > 0) then

		if (nr_seq_item_w = 0) then

			if (ds_marca_fornec_w IS NOT NULL AND ds_marca_fornec_w::text <> '') then

				select	max(nr_sequencia)
				into STRICT	nr_seq_marca_w
				from	marca
				where	elimina_acentuacao(upper(ds_marca)) = elimina_acentuacao(upper(ds_marca_fornec_w));
			end if;

			insert into reg_lic_item_fornec(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_fornec,
				nr_seq_lic_item,
				nr_seq_parecer,
				ie_vencedor,
				vl_item,
				cd_material,
				nr_seq_licitacao,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				ds_motivo_vencedor,
				ie_qualificado,
				vl_original,
				ds_marca,
				qt_item,
				ds_motivo_desqualif,
				ie_qualif_lance_fornec,
				vl_lote,
				nr_seq_marca)
			values (	nextval('reg_lic_item_fornec_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_fornec_w,
				nr_seq_lic_item_w,
				null,
				'N',
				vl_unitario_material_w,
				cd_material_w,
				nr_seq_licitacao_p,
				clock_timestamp(),
				nm_usuario_p,
				null,
				'S',
				vl_unitario_material_w,
				ds_marca_fornec_w,
				qt_material_w,
				null,
				null,
				null,
				nr_seq_marca_w);
		else
			update	reg_lic_item_fornec
			set	vl_item	= vl_unitario_material_w,
				nm_usuario = nm_usuario_p,
				dt_atualizacao = clock_timestamp()
			where	nr_sequencia = nr_seq_item_w;
		end if;


	end if;

	end;
end loop;
close C01;



commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lic_gerar_fornec_cot_compra ( nr_seq_licitacao_p bigint, nm_usuario_p text) FROM PUBLIC;
