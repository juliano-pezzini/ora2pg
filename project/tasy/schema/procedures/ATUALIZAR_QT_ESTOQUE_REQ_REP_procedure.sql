-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_qt_estoque_req_rep ( nr_seq_item_p bigint, qt_material_requisitada_p bigint, cd_material_cons_req_rep_p bigint, cd_material_item_req_mat_p bigint, qt_requisitada_p bigint, ie_consiste_conversao_p text, ie_atualizar_estoque_p INOUT text, ds_erro_p INOUT text, nm_usuario_p text) AS $body$
DECLARE


qt_conv_estoque_consumo_w	double precision;
ds_erro_w			varchar(255)	:= '';
ie_multiplo_w			varchar(1);
qt_material_requisitada_w	double precision;


BEGIN

ie_atualizar_estoque_p	:= 'N';

if (nr_seq_item_p IS NOT NULL AND nr_seq_item_p::text <> '') and (qt_material_requisitada_p IS NOT NULL AND qt_material_requisitada_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin

	update	w_requisicao_material
	set	qt_material_requisitada	= qt_material_requisitada_p
	where	nm_usuario		= nm_usuario_p
	and	nr_sequencia		= nr_seq_item_p;

	select	qt_conv_estoque_consumo
	into STRICT	qt_conv_estoque_consumo_w
	from	material
	where	cd_material = cd_material_cons_req_rep_p;

	if (ie_consiste_conversao_p = 'S') and (cd_material_item_req_mat_p IS NOT NULL AND cd_material_item_req_mat_p::text <> '') then
		begin

		ds_erro_w := Consiste_Minimo_Multiplo_Req(cd_material_item_req_mat_p, qt_requisitada_p, ds_erro_w);

		if (coalesce(ds_erro_w::text, '') = '') then
			ie_multiplo_w	:= 'S';
		else
			ie_multiplo_w	:= 'N';
		end if;
		end;
	end if;

	if (ie_multiplo_w = 'S') then
		begin

		if (qt_conv_estoque_consumo_w > 1) then
			begin

			qt_material_requisitada_w	:= qt_material_requisitada_p / qt_conv_estoque_consumo_w;

			update	w_requisicao_material
			set	qt_estoque	= qt_material_requisitada_w
			where	nm_usuario	= nm_usuario_p
			and	nr_sequencia	= nr_seq_item_p;

			end;
		else
			begin
			update	w_requisicao_material
			set	qt_estoque	= qt_material_requisitada_p
			where	nm_usuario	= nm_usuario_p
			and	nr_sequencia	= nr_seq_item_p;

			ie_atualizar_estoque_p	:= 'S';
			end;
		end if;
		end;

	end if;

	commit;

	end;
end if;

ds_erro_p	:= ds_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_qt_estoque_req_rep ( nr_seq_item_p bigint, qt_material_requisitada_p bigint, cd_material_cons_req_rep_p bigint, cd_material_item_req_mat_p bigint, qt_requisitada_p bigint, ie_consiste_conversao_p text, ie_atualizar_estoque_p INOUT text, ds_erro_p INOUT text, nm_usuario_p text) FROM PUBLIC;
