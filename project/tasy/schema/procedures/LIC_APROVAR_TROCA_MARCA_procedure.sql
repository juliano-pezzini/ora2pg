-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lic_aprovar_troca_marca ( nr_sequencia_p bigint, ds_justificativa_p text, nm_usuario_p text) AS $body$
DECLARE


ds_marca_w			varchar(255);
ds_marca_original_w		varchar(255);
ds_justificativa_w			varchar(255);
ds_justificativa_ww			varchar(255);
nr_seq_reg_compra_item_w		bigint;
ds_historico_w			varchar(4000);
cd_material_w			integer;
ds_material_w			varchar(255);
nr_seq_reg_compra_w		bigint;
nr_seq_marca_w			bigint;
qt_existe_w			bigint;

BEGIN

select	nr_seq_reg_compra_item,
	ds_marca,
	ds_marca_original,
	ds_justificativa
into STRICT	nr_seq_reg_compra_item_w,
	ds_marca_w,
	ds_marca_original_w,
	ds_justificativa_w
from	reg_lic_troca_marca
where	nr_sequencia = nr_sequencia_p;

select	nr_seq_reg_compra,
	cd_material,
	substr(obter_desc_material(cd_material),1,255) ds_material
into STRICT	nr_seq_reg_compra_w,
	cd_material_w,
	ds_material_w
from	reg_compra_item
where	nr_sequencia	= nr_seq_reg_compra_item_w;

if (ds_marca_w IS NOT NULL AND ds_marca_w::text <> '') then
	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_marca_w
	from	marca
	where	elimina_acentuacao(upper(ds_marca)) = elimina_acentuacao(upper(ds_marca_w));

	if (nr_seq_marca_w = 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266170,'DS_MARCA=' || ds_marca_w);
		--'Não existe nenhuma marca cadastrada no sistema com o nome ' || ds_marca_w || '.' || chr(13) || chr(10) || 'Favor cadastra-la para dar continuidade no processo.');
	else
		select	count(*)
		into STRICT	qt_existe_w
		from	material_marca
		where	cd_material = cd_material_w
		and	nr_sequencia = nr_seq_marca_w;

		if (qt_existe_w = 0) then

			insert into material_marca(
				cd_material,
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				qt_prioridade,
				ie_situacao)
			values (	cd_material_w,
				nr_seq_marca_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				1,
				'A');
		end if;
	end if;
end if;

ds_justificativa_ww	:= ds_justificativa_w;

if (ds_justificativa_p IS NOT NULL AND ds_justificativa_p::text <> '') then

	if (ds_justificativa_w IS NOT NULL AND ds_justificativa_w::text <> '') then
		ds_justificativa_ww := substr(ds_justificativa_w || chr(13) || chr(10) || ds_justificativa_p,1,255);
	else
		ds_justificativa_ww := substr(ds_justificativa_p,1,255);
	end if;
end if;

update	reg_compra_item
set	ds_marca		= ds_marca_w
where	nr_sequencia	= nr_seq_reg_compra_item_w;

update	reg_lic_troca_marca
set	dt_aprovacao	= clock_timestamp(),
	nm_usuario_aprov	= nm_usuario_p,
	ds_justificativa	= substr(ds_justificativa_ww,1,255)
where	nr_sequencia	= nr_sequencia_p;

ds_historico_w := 	substr(WHEB_MENSAGEM_PCK.get_texto(310370, 'CD_MATERIAL_W=' || cd_material_w || ';DS_MATERIAL_W=' || ds_material_w || ';DS_MARCA_ORIGINAL_W=' || ds_marca_original_w) || ds_marca_w || '.',1,4000); --Aprovado a troca da marca do material ' || cd_material_w || ' - ' || ds_material_w || ', de ' || ds_marca_original_w || ' para
CALL lic_gerar_historico_reg_preco(nr_seq_reg_compra_w, ds_historico_w, 'S', nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lic_aprovar_troca_marca ( nr_sequencia_p bigint, ds_justificativa_p text, nm_usuario_p text) FROM PUBLIC;
