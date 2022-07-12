-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE importer_kairos_tools.save_barcode ( cd_material_glo_p MATERIAL_GLOBAL.CD_MATERIAL_GLO%type, cd_barcode_p BARRAS_MATGLOBAL.CD_BARRAS%type, ie_situation_p BARRAS_MATGLOBAL.IE_SITUACAO%type DEFAULT 'A') AS $body$
DECLARE

cd_barcode_w	BARRAS_MATGLOBAL.CD_BARRAS%type;

BEGIN

	SELECT 	MAX(a.CD_BARRAS)
	INTO STRICT 	cd_barcode_w
	FROM 	BARRAS_MATGLOBAL a
	WHERE 	a.CD_BARRAS = cd_barcode_p
	AND 	a.CD_MATERIAL_GLO = cd_material_glo_p;

	IF (coalesce(cd_barcode_w::text, '') = '') THEN
		CALL importer_kairos_tools.check_conversion_rule(
			nm_table_p 		=> 'BARRAS_MATGLOBAL',
			nm_attribute_p 		=> 'IE_SITUACAO',
			cd_external_p 		=> 'B',
			cd_internal_p 		=> 'I'
		);

		INSERT INTO BARRAS_MATGLOBAL(
			NR_SEQUENCIA,
			CD_BARRAS,
			CD_MATERIAL_GLO,
			IE_SITUACAO,
			DT_ATUALIZACAO,
			DT_ATUALIZACAO_NREC,
			NM_USUARIO,
			NM_USUARIO_NREC
		) VALUES (
			nextval('barras_matglobal_seq'),
			cd_barcode_p,
			cd_material_glo_p,
			ie_situation_p,
			current_setting('importer_kairos_tools.dt_atual_s')::W_KAIROS.DT_IMPORTACAO%type,
			current_setting('importer_kairos_tools.dt_atual_s')::W_KAIROS.DT_IMPORTACAO%type,
			current_setting('importer_kairos_tools.nm_usuario_s')::W_KAIROS.NM_USUARIO%type,
			current_setting('importer_kairos_tools.nm_usuario_s')::W_KAIROS.NM_USUARIO%type
		);
		COMMIT;
	END IF;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE importer_kairos_tools.save_barcode ( cd_material_glo_p MATERIAL_GLOBAL.CD_MATERIAL_GLO%type, cd_barcode_p BARRAS_MATGLOBAL.CD_BARRAS%type, ie_situation_p BARRAS_MATGLOBAL.IE_SITUACAO%type DEFAULT 'A') FROM PUBLIC;
