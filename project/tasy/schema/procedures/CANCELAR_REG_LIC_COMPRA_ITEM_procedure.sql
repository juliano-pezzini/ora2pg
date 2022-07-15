-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cancelar_reg_lic_compra_item ( nr_sequencia_p bigint, nr_seq_motivo_cancel_p bigint, ds_justificativa_p text, nm_usuario_p text) AS $body$
DECLARE


nr_solic_compra_w			bigint;
nr_item_solic_compra_w		integer;
ds_motivo_cancel_w		varchar(255);
dt_baixa_w			timestamp;
cd_material_w			integer;
ds_material_w			varchar(255);
ds_justificativa_w			varchar(4000);


BEGIN

select	nr_solic_compra,
	nr_item_solic_compra
into STRICT	nr_solic_compra_w,
	nr_item_solic_compra_w
from	reg_lic_compra_item
where	nr_sequencia		= nr_sequencia_p;

select	ds_motivo
into STRICT	ds_motivo_cancel_w
from	motivo_cancel_sc_oc
where	nr_sequencia		= nr_seq_motivo_cancel_p;

update	reg_lic_compra_item
set	dt_cancelamento		= clock_timestamp(),
	nm_usuario_cancel		= nm_usuario_p,
	nr_seq_motivo_cancel	= nr_seq_motivo_cancel_p,
	ds_justif_cancel		= ds_justificativa_p
where	nr_sequencia		= nr_sequencia_p;


if (nr_solic_compra_w > 0) then

	update	solic_compra_item
	set	dt_baixa			= clock_timestamp(),
		cd_motivo_baixa 		= 2,
		nm_usuario		= nm_usuario_p,
		ds_observacao		= substr(CASE WHEN ds_observacao = NULL THEN Wheb_mensagem_pck.get_Texto(298434) || ds_motivo_cancel_w  ELSE ds_observacao || chr(10) || chr(13) || Wheb_mensagem_pck.get_Texto(298434) || ds_motivo_cancel_w END ,1,255)
	where	nr_solic_compra 		= nr_solic_compra_w
	and	nr_item_solic_compra	= nr_item_solic_compra_w;

	update	solic_compra
	set	dt_baixa			= clock_timestamp(),
		cd_motivo_baixa		= 2,
		nm_usuario		= nm_usuario_p
	where	nr_solic_compra 		= nr_solic_compra_w
	and	not exists (SELECT 1
			from	solic_compra_item
			where	nr_solic_compra = nr_solic_compra_w
			and	coalesce(dt_baixa::text, '') = '');

	update	processo_aprov_compra a
	set	a.ie_aprov_reprov = 'B',
		a.ds_observacao = substr(a.ds_observacao || Wheb_mensagem_pck.get_Texto(298435) || nr_solic_compra_w,1,2000)
	where	a.nr_sequencia in (
		SELECT	distinct(nr_seq_aprovacao)
		from	solic_compra_item
		where	nr_solic_compra = nr_solic_compra_w)
	and	ie_aprov_reprov = 'P'
	and	not exists (
		SELECT	1
		from	solic_compra_item x
		where	x.nr_seq_aprovacao = a.nr_sequencia
		and	coalesce(dt_baixa::text, '') = '');

	if (nr_item_solic_compra_w > 0) then

		select	cd_material,
			substr(obter_desc_material(cd_material),1,255)
		into STRICT	cd_material_w,
			ds_material_w
		from	solic_compra_item
		where	nr_solic_compra = nr_solic_compra_w
		and	nr_item_solic_compra = nr_item_solic_compra_w;

		if (ds_justificativa_p IS NOT NULL AND ds_justificativa_p::text <> '') then
			ds_justificativa_w	:= chr(13) || chr(10) || Wheb_mensagem_pck.get_Texto(298436) || ds_justificativa_p;
		end if;

		CALL gerar_historico_solic_compra(	nr_solic_compra_w,
				Wheb_mensagem_pck.get_Texto(298437),
				WHEB_MENSAGEM_PCK.get_texto(298438,
					'CD_MATERIAL_W='||cd_material_w||
					';DS_MATERIAL_W='||ds_material_w||
					';DS_MOTIVO_CANCEL_W='||ds_motivo_cancel_w||
					';DS_JUSTIFICATIVA_W='||ds_justificativa_w),
				'B',
				nm_usuario_p);
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancelar_reg_lic_compra_item ( nr_sequencia_p bigint, nr_seq_motivo_cancel_p bigint, ds_justificativa_p text, nm_usuario_p text) FROM PUBLIC;

