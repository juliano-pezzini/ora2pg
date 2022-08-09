-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_lote_fornec_resp_item ( nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_resp_consig_item_p bigint, nr_seq_resp_consig_item_dev_p bigint, dt_validade_p timestamp, ds_lote_p text, ie_tipo_p text) AS $body$
DECLARE


nr_seq_resp_w			bigint;
nr_Seq_lote_fornec_w		bigint;
cd_material_w			bigint;
cd_cnpj_W			varchar(15);
nr_nota_fiscal_w		varchar(255);
nr_seq_item_nf_w		integer;
nr_seq_nf_w			bigint;
qt_material_W			double precision;


BEGIN

if (ie_tipo_p = 'S') then
	begin
	select	cd_material,
		nr_seq_resp,
		qt_material,
		nr_seq_resp
	into STRICT	cd_material_w,
		nr_seq_resp_W,
		qt_material_W,
		nr_seq_resp_w
	from 	sup_resp_consig_item_dev
	where	nr_sequencia = nr_seq_resp_consig_item_dev_p;
	end;
elsif (ie_tipo_p = 'E') then
	begin
	select	cd_material,
		nr_seq_resp,
		qt_material,
		nr_seq_resp
	into STRICT	cd_material_w,
		nr_seq_resp_W,
		qt_material_W,
		nr_seq_resp_w
	from 	sup_resp_consig_item
	where	nr_sequencia = nr_seq_resp_consig_item_p;
	end;
end if;

select	cd_fornec_consig
into STRICT	cd_cnpj_w
from 	sup_Resp_consignado
where	nr_Sequencia = nr_seq_resp_w;

select	nextval('material_lote_fornec_seq')
into STRICT	nr_seq_lote_fornec_W
;

insert into material_lote_fornec(
				nr_sequencia,
				cd_material,
				nr_digito_verif,
				dt_atualizacao,
				nm_usuario,
				ds_lote_fornec,
				dt_validade,
				cd_cgc_fornec,
				qt_material,
				cd_estabelecimento,
				ie_validade_indeterminada,
				ie_situacao,
				dt_atualizacao_nrec,
				nm_usuario_nrec)
			values ( nr_seq_lote_fornec_w,
				cd_material_w,
				calcula_digito('Modulo11',nr_seq_lote_fornec_w),
				clock_timestamp(),
				nm_usuario_p,
				ds_lote_p,
				dt_validade_p,
				cd_cnpj_w,
				qt_material_w,
				cd_Estabelecimento_p,
				CASE WHEN coalesce(dt_validade_p::text, '') = '' THEN 'S'  ELSE 'N' END ,
				'A',
				clock_timestamp(),
				nm_usuario_p);

if (ie_tipo_p = 'S') then
	update	sup_resp_consig_item_dev
	set	nr_seq_lote_fornec = nr_seq_lote_fornec_w
	where	nr_sequencia = nr_seq_resp_consig_item_dev_p
	and	nr_seq_Resp = nr_seq_resp_w;
elsif (ie_tipo_p = 'E') then
	begin
	update	sup_resp_consig_item
	set	nr_seq_lote_fornec = nr_seq_lote_fornec_w
	where	nr_sequencia = nr_seq_resp_consig_item_p
	and	nr_seq_Resp = nr_seq_resp_w;
	end;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_lote_fornec_resp_item ( nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_resp_consig_item_p bigint, nr_seq_resp_consig_item_dev_p bigint, dt_validade_p timestamp, ds_lote_p text, ie_tipo_p text) FROM PUBLIC;
