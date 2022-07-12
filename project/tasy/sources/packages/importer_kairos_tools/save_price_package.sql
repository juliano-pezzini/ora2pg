-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/**
 * BASPRC: 1422, BASIOM: 1423, BASPAMI: 1424
*/
CREATE OR REPLACE PROCEDURE importer_kairos_tools.save_price ( cd_tab_preco_mat_p TABELA_PRECO_MATERIAL.CD_TAB_PRECO_MAT%type, cd_material_glo_p MATERIAL_GLOBAL.CD_MATERIAL_GLO%type, cd_unit_p UNIDADE_MEDIDA_MATGLOBAL.CD_UNIDADE%type, vl_preco_p PRECO_MATERIAL_GLOBAL.VL_PRECO%type, dt_inicio_vigencia_p PRECO_MATERIAL_GLOBAL.DT_INICIO_VIGENCIA%type, dt_final_vigencia_p PRECO_MATERIAL_GLOBAL.DT_FINAL_VIGENCIA%type DEFAULT NULL) AS $body$
DECLARE


ora2pg_rowcount int;
cd_unit_w 			UNIDADE_MEDIDA_MATGLOBAL.CD_UNIDADE%type;
cd_material_glo_w 		MATERIAL_GLOBAL.CD_MATERIAL_GLO%type;
is_kairos_price_chart_w		TABELA_PRECO_MATERIAL.CD_TAB_PRECO_MAT%type;	


BEGIN
	SELECT 	MAX(a.CD_TAB_PRECO_MAT)
	INTO STRICT 	is_kairos_price_chart_w
	FROM 	TABELA_PRECO_MATERIAL a
	WHERE	CD_TAB_PRECO_MAT = cd_tab_preco_mat_p
	AND 	LOWER(DS_TAB_PRECO_MAT) like '%kairos%';

	IF (is_kairos_price_chart_w IS NOT NULL AND is_kairos_price_chart_w::text <> '') THEN
		cd_unit_w 		:= cd_material_glo_p || cd_unit_p;
		cd_material_glo_w	:= importer_kairos_tools.get_product_by_code_and_pres(cd_material_glo_p, cd_unit_w);
		

		UPDATE 	PRECO_MATERIAL_GLOBAL
		SET 	VL_PRECO 		= vl_preco_p,
			DT_INICIO_VIGENCIA 	= dt_inicio_vigencia_p,
			DT_FINAL_VIGENCIA 	= dt_final_vigencia_p,
			IE_SITUACAO 		= 'A'
		WHERE 	CD_TAB_PRECO_MAT 	= cd_tab_preco_mat_p
		AND   	CD_ESTABELECIMENTO 	= current_setting('importer_kairos_tools.cd_estabelecimento_s')::MATERIAL_GLOBAL.CD_ESTABELECIMENTO%type
		AND 	CD_MATERIAL_GLO 	= cd_material_glo_w;

		GET DIAGNOSTICS ora2pg_rowcount = ROW_COUNT;


		IF ( ora2pg_rowcount = 0) THEN
			INSERT INTO PRECO_MATERIAL_GLOBAL(
				NR_SEQUENCIA,
				CD_MATERIAL_GLO,
				CD_TAB_PRECO_MAT,
				VL_PRECO,
				DT_INICIO_VIGENCIA,
				DT_FINAL_VIGENCIA,
				CD_ESTABELECIMENTO,
				IE_SITUACAO,
				DT_ATUALIZACAO,
				DT_ATUALIZACAO_NREC,
				NM_USUARIO,
				NM_USUARIO_NREC
			) VALUES (
				nextval('preco_material_global_seq'),
				cd_material_glo_w,
				cd_tab_preco_mat_p,
				vl_preco_p,
				dt_inicio_vigencia_p,
				dt_final_vigencia_p,
				current_setting('importer_kairos_tools.cd_estabelecimento_s')::MATERIAL_GLOBAL.CD_ESTABELECIMENTO%type,
				'A',
				current_setting('importer_kairos_tools.dt_atual_s')::W_KAIROS.DT_IMPORTACAO%type,
				current_setting('importer_kairos_tools.dt_atual_s')::W_KAIROS.DT_IMPORTACAO%type,
				current_setting('importer_kairos_tools.nm_usuario_s')::W_KAIROS.NM_USUARIO%type,
				current_setting('importer_kairos_tools.nm_usuario_s')::W_KAIROS.NM_USUARIO%type
			);
		END IF;
		COMMIT;		
	END IF;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE importer_kairos_tools.save_price ( cd_tab_preco_mat_p TABELA_PRECO_MATERIAL.CD_TAB_PRECO_MAT%type, cd_material_glo_p MATERIAL_GLOBAL.CD_MATERIAL_GLO%type, cd_unit_p UNIDADE_MEDIDA_MATGLOBAL.CD_UNIDADE%type, vl_preco_p PRECO_MATERIAL_GLOBAL.VL_PRECO%type, dt_inicio_vigencia_p PRECO_MATERIAL_GLOBAL.DT_INICIO_VIGENCIA%type, dt_final_vigencia_p PRECO_MATERIAL_GLOBAL.DT_FINAL_VIGENCIA%type DEFAULT NULL) FROM PUBLIC;