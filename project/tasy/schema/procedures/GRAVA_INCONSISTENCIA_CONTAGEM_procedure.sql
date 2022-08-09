-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE grava_inconsistencia_contagem ( nr_seq_inspecao_p bigint, cd_material_p bigint, ds_campo_p text, ds_contagem_um_p text, ds_contagem_dois_p text, ie_tipo_consistencia_p text, ds_consistencia_p text, nm_usuario_p text) AS $body$
DECLARE

ds_erro_w	varchar(255);


BEGIN

begin
	insert into insp_contagem_consiste(
		nr_seq_inspecao,
		cd_material,
		ds_campo,
		ds_contagem_um,
		ds_contagem_dois,
		ds_consistencia,
		ie_tipo_consistencia,
		nm_usuario_contagem)
	values (	nr_seq_inspecao_p,
		cd_material_p,
		ds_campo_p,
		ds_contagem_um_p,
		ds_contagem_dois_p,
		ds_consistencia_p,
		ie_tipo_consistencia_p,
		nm_usuario_p);
exception when others then
		ds_erro_w := substr(sqlerrm,1,255);
end;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE grava_inconsistencia_contagem ( nr_seq_inspecao_p bigint, cd_material_p bigint, ds_campo_p text, ds_contagem_um_p text, ds_contagem_dois_p text, ie_tipo_consistencia_p text, ds_consistencia_p text, nm_usuario_p text) FROM PUBLIC;
