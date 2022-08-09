-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE bft_request_mat_price ( ie_all_records_p text, nr_reference_p bigint, cd_estabelecimento_p bigint, cd_price_material_tab_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_json_param_w		text;	
ds_json_result_w	text;	
json_w		philips_json;
					

BEGIN


json_w := philips_json();
json_w.put('allRecords', coalesce(ie_all_records_p,'S'));
json_w.put('referenceNumber', coalesce(nr_reference_p,0));
json_w.put('establishmentId', coalesce(cd_estabelecimento_p,0));
json_w.put('materialPriceTableCode', coalesce(cd_price_material_tab_p,0));
dbms_lob.createtemporary(ds_json_param_w, true);
json_w.(ds_json_param_w);


select	bifrost.send_integration_content('request.material.price',ds_json_param_w,nm_usuario_p,'N')
into STRICT	ds_json_result_w
;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE bft_request_mat_price ( ie_all_records_p text, nr_reference_p bigint, cd_estabelecimento_p bigint, cd_price_material_tab_p bigint, nm_usuario_p text) FROM PUBLIC;
