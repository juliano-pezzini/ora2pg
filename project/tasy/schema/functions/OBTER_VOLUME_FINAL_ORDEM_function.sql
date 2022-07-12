-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_volume_final_ordem (nr_seq_ordem_p bigint) RETURNS varchar AS $body$
DECLARE



qt_dose_real_w		bigint;
qt_dose_mat_w		bigint;
cd_unid_med_w		varchar(30);
cd_material_w		bigint;

C01 CURSOR FOR
	SELECT		qt_dose_real,
			cd_unidade_medida_real,
			cd_material
	FROM		can_ordem_prod_mat
	WHERE		nr_seq_ordem	=	nr_seq_ordem_p
	ORDER BY 	qt_dose;


BEGIN

SELECT 		obter_conversao_ml(Obter_material_ordem_prod(NR_SEQUENCIA,'C'),Obter_material_ordem_prod(NR_SEQUENCIA,'D'),Obter_material_ordem_prod(NR_SEQUENCIA,'U'))
INTO STRICT		qt_dose_real_w
FROM 		can_ordem_prod
WHERE		nr_sequencia	=	nr_seq_ordem_p;

OPEN C01;
	LOOP
	FETCH C01 INTO
	qt_dose_mat_w,
	cd_unid_med_w,
	cd_material_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		BEGIN
		qt_dose_real_w := qt_dose_real_w + obter_conversao_ml(cd_material_w,qt_dose_mat_w, cd_unid_med_w);
		END;
	END LOOP;
	CLOSE C01;

RETURN	qt_dose_real_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_volume_final_ordem (nr_seq_ordem_p bigint) FROM PUBLIC;
