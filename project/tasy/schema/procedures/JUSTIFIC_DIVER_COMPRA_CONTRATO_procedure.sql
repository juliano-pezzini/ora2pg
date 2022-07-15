-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE justific_diver_compra_contrato ( nr_documento_p bigint, ie_tipo_documento_p text, ds_justificativa_p text, nm_usuario_p text) AS $body$
BEGIN

if (ie_tipo_documento_p = 'SC') then
	begin

	update	solic_compra_item a
	set	a.ds_justif_diver = ds_justificativa_p
	where	a.nr_solic_compra = nr_documento_p
	and	a.nr_item_solic_compra in (SELECT	x.nr_item_documento
					from	diverg_contrato_item_doc x
					where	x.nr_documento = nr_documento_p
					and	x.ie_tipo_documento = ie_tipo_documento_p
					and	x.ie_justificativa = 'S');

	end;
elsif (ie_tipo_documento_p = 'OC') then
	begin

	update	ordem_compra_item a
	set	a.ds_justif_diver = ds_justificativa_p
	where	a.nr_ordem_compra = nr_documento_p
	and	a.nr_item_oci in (SELECT	x.nr_item_documento
				from	diverg_contrato_item_doc x
				where	x.nr_documento = nr_documento_p
				and	x.ie_tipo_documento = ie_tipo_documento_p
				and	x.ie_justificativa = 'S');

	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE justific_diver_compra_contrato ( nr_documento_p bigint, ie_tipo_documento_p text, ds_justificativa_p text, nm_usuario_p text) FROM PUBLIC;

