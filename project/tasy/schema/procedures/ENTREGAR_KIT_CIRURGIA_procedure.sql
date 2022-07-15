-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE entregar_kit_cirurgia (nr_prescricao_p bigint, cd_kit_material_p bigint, nr_seq_kit_estoque_p bigint, nr_doc_interno_p text, nr_doc_interno_aux_p text, ie_tipo_doc_interno_p text, ie_tipo_doc_interno_aux_p text, nm_usuario_p text) AS $body$
BEGIN

if (cd_kit_material_p IS NOT NULL AND cd_kit_material_p::text <> '') then
	update	prescr_material
	set	nr_doc_interno 		= nr_doc_interno_p,
		nr_doc_interno_aux 	= nr_doc_interno_aux_p,
		ie_tipo_doc_interno	= ie_tipo_doc_interno_p,
		ie_tipo_doc_interno_aux	= ie_tipo_doc_interno_aux_p
	where	nr_prescricao		= nr_prescricao_p
	and	cd_kit_material		= cd_kit_material_p;
end if;

if (nr_seq_kit_estoque_p IS NOT NULL AND nr_seq_kit_estoque_p::text <> '') then
	update	prescr_material
	set	nr_doc_interno 			= nr_doc_interno_p,
		nr_doc_interno_aux 		= nr_doc_interno_aux_p,
		ie_tipo_doc_interno		= ie_tipo_doc_interno_p,
		ie_tipo_doc_interno_aux		= ie_tipo_doc_interno_aux_p
	where	nr_prescricao		= nr_prescricao_p
	and	nr_seq_kit_estoque	= nr_seq_kit_estoque_p;
end if;


commit;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE entregar_kit_cirurgia (nr_prescricao_p bigint, cd_kit_material_p bigint, nr_seq_kit_estoque_p bigint, nr_doc_interno_p text, nr_doc_interno_aux_p text, ie_tipo_doc_interno_p text, ie_tipo_doc_interno_aux_p text, nm_usuario_p text) FROM PUBLIC;

