-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE importer_kairos_tools.insert_presentation ( cd_unit_p UNIDADE_MEDIDA_MATGLOBAL.CD_UNIDADE%type, ds_unit_p UNIDADE_MEDIDA_MATGLOBAL.DS_UNIDADE%type, ie_situation_p UNIDADE_MEDIDA_MATGLOBAL.IE_SITUACAO%type DEFAULT 'A') AS $body$
BEGIN
	CALL importer_kairos_tools.check_conversion_rule(
			nm_table_p 		=> 'UNIDADE_MEDIDA_MATGLOBAL',
			nm_attribute_p 		=> 'IE_SITUACAO',
			cd_external_p 		=> 'B',
			cd_internal_p 		=> 'I'
	);

	INSERT INTO UNIDADE_MEDIDA_MATGLOBAL(
		CD_UNIDADE,
		DS_UNIDADE,
		IE_SITUACAO,
		DT_ATUALIZACAO,
		DT_ATUALIZACAO_NREC,
		NM_USUARIO,
		NM_USUARIO_NREC
	) VALUES (
		cd_unit_p,
		ds_unit_p,
		ie_situation_p,
		current_setting('importer_kairos_tools.dt_atual_s')::W_KAIROS.DT_IMPORTACAO%type,
		current_setting('importer_kairos_tools.dt_atual_s')::W_KAIROS.DT_IMPORTACAO%type,
		current_setting('importer_kairos_tools.nm_usuario_s')::W_KAIROS.NM_USUARIO%type,
		current_setting('importer_kairos_tools.nm_usuario_s')::W_KAIROS.NM_USUARIO%type
	);
	COMMIT;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE importer_kairos_tools.insert_presentation ( cd_unit_p UNIDADE_MEDIDA_MATGLOBAL.CD_UNIDADE%type, ds_unit_p UNIDADE_MEDIDA_MATGLOBAL.DS_UNIDADE%type, ie_situation_p UNIDADE_MEDIDA_MATGLOBAL.IE_SITUACAO%type DEFAULT 'A') FROM PUBLIC;