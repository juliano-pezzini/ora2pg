-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION calcular_esforco_area ( nr_sequencia_p bigint, nr_seq_gap_p bigint, nr_seq_prs_p bigint, ie_opcao_P text, ie_necessita_design_p text , ie_necessita_tecnologia_p text, qt_tempo_horas_p bigint, ie_necessita_traducao_p text default null) RETURNS varchar AS $body$
DECLARE


nr_seq_pais_w		LATAM_GAP.NR_SEQ_PAIS%type;
ie_regra_w			smallint;
ie_gap_w			varchar(1);
qt_reg_w			smallint;
vl_base_w			bigint;
qt_result_horas_w	LATAM_REQUISITO.QT_HORAS_DESIGN%type;
nr_seq_gap_w		LATAM_GAP.NR_SEQUENCIA%type;


BEGIN

if (coalesce(nr_seq_gap_p::text, '') = '' OR coalesce(nr_seq_gap_p, 0) = 0) THEN
	BEGIN
        SELECT  coalesce(MAX(e.nr_seq_gap),0)
        INTO STRICT	nr_seq_gap_w
        FROM    latam_requisito_prs b,
                latam_requisito_crs c,
                latam_subprocesso d,
                latam_modulo e
        WHERE   e.nr_sequencia = d.nr_seq_modulo
        AND     d.nr_sequencia = c.nr_seq_latam_subprocesso
        AND     c.nr_sequencia = b.nr_seq_requisito_crs
        AND     b.nr_sequencia = nr_seq_prs_p;
	END;
else
	nr_seq_gap_w := nr_seq_gap_p;
end if;

SELECT	coalesce(MAX(nr_seq_pais), 0)
INTO STRICT	nr_seq_pais_w
FROM 	latam_gap
WHERE	nr_sequencia = nr_seq_gap_w;

ie_gap_w := 'A';

if (ie_opcao_p = 'TE' AND ie_necessita_tecnologia_p = 'S') THEN
	BEGIN
		ie_gap_w := 'A';

		SELECT	COUNT(*)
		INTO STRICT	ie_regra_w
		FROM	latam_regra_esforco
		WHERE	nr_seq_gap 		= nr_seq_gap_w
		AND		ie_tipo_regra 	= 'TE'
		AND		ie_regra_geral 	= 'N';

		if (ie_regra_w = 0) THEN
			BEGIN
				SELECT	COUNT(*)
				INTO STRICT	ie_regra_w
				FROM	latam_regra_esforco
				WHERE	nr_seq_pais 	= nr_seq_pais_w
				AND		ie_tipo_regra 	= 'TE'
				AND		ie_regra_geral 	= 'N';

			if (ie_regra_w > 0) THEN
				BEGIN
					ie_gap_w := 'C';
				END;
			end if;
			END;
		else
			BEGIN
				ie_gap_w := 'G';
			END;
		end if;

		SELECT	MAX(coalesce(vl_regra,0))
		INTO STRICT	vl_base_w
		FROM	latam_regra_esforco
		WHERE	((nr_seq_gap = nr_seq_gap_w AND ie_gap_w = 'G')  OR (ie_gap_w = 'C' AND nr_seq_pais = nr_seq_pais_w) OR (ie_gap_w = 'A' AND coalesce(nr_seq_pais::text, '') = '' AND coalesce(nr_seq_gap::text, '') = ''))
		AND		ie_tipo_regra 	= 'TE'
		AND		ie_regra_geral 	= 'N';

		qt_result_horas_w :=  (qt_tempo_horas_p * vl_base_w)/100;
	END;
elsif (ie_opcao_p = 'DE' AND ie_necessita_design_p = 'S') THEN
	BEGIN
		ie_gap_w := 'A';

		SELECT	COUNT(*)
		INTO STRICT	ie_regra_w
		FROM	LATAM_REGRA_ESFORCO
		WHERE	nr_seq_gap 		= nr_seq_gap_w
		AND		ie_tipo_regra 	= 'DE'
		AND		ie_regra_geral 	= 'N';

		if (ie_regra_w = 0) THEN
			BEGIN
				SELECT	COUNT(*)
				INTO STRICT	ie_regra_w
				FROM	LATAM_REGRA_ESFORCO
				WHERE	nr_seq_pais 	= nr_seq_pais_w
				AND		ie_tipo_regra 	= 'DE'
				AND		ie_regra_geral 	= 'N';

			if (ie_regra_w > 0) THEN
				BEGIN
					ie_gap_w := 'C';
				END;
			end if;
			END;
		else
			BEGIN
				ie_gap_w := 'G';
			END;
		end if;

		SELECT	MAX(coalesce(vl_regra, 0))
		INTO STRICT	vl_base_w
		FROM	latam_regra_esforco
		WHERE	((nr_seq_gap = nr_seq_gap_w AND ie_gap_w = 'G') OR (ie_gap_w = 'C' AND nr_seq_pais = nr_seq_pais_w) OR (ie_gap_w = 'A' AND coalesce(nr_seq_pais::text, '') = '' AND coalesce(nr_seq_gap::text, '') = ''))
		AND		ie_tipo_regra 	= 'DE'
		AND		ie_regra_geral 	= 'N';

		qt_result_horas_w :=  (qt_tempo_horas_p * vl_base_w)/100;
	END;
elsif (ie_opcao_p = 'TR' AND ie_necessita_traducao_p = 'S') THEN
	BEGIN
		ie_gap_w := 'A';

		SELECT	COUNT(*)
		INTO STRICT	ie_regra_w
		FROM	latam_regra_esforco
		WHERE	nr_seq_gap 		= nr_seq_gap_w
		AND		ie_tipo_regra 	= 'TR'
		AND		ie_regra_geral 	= 'N';

		if (ie_regra_w = 0) THEN
			BEGIN
				SELECT	COUNT(*)
				INTO STRICT	ie_regra_w
				FROM	latam_regra_esforco
				WHERE	nr_seq_pais 	= nr_seq_pais_w
				AND		ie_tipo_regra 	= 'TR'
				AND		ie_regra_geral 	= 'N';

			if (ie_regra_w > 0) THEN
				BEGIN
					ie_gap_w := 'C';
				END;
			end if;
			END;
		else
			BEGIN
				ie_gap_w := 'G';
			END;
		end if;

		SELECT	MAX(coalesce(vl_regra,0))
		INTO STRICT	vl_base_w
		FROM	latam_regra_esforco
		WHERE	((nr_seq_gap = nr_seq_gap_w AND ie_gap_w = 'G')  OR (ie_gap_w = 'C' AND nr_seq_pais = nr_seq_pais_w) OR (ie_gap_w = 'A' AND coalesce(nr_seq_pais::text, '') = '' AND coalesce(nr_seq_gap::text, '') = ''))
		AND		ie_tipo_regra 	= 'TR'
		AND		ie_regra_geral 	= 'N';

		qt_result_horas_w :=  (qt_tempo_horas_p * vl_base_w)/100;
    END;
end if;

RETURN qt_result_horas_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION calcular_esforco_area ( nr_sequencia_p bigint, nr_seq_gap_p bigint, nr_seq_prs_p bigint, ie_opcao_P text, ie_necessita_design_p text , ie_necessita_tecnologia_p text, qt_tempo_horas_p bigint, ie_necessita_traducao_p text default null) FROM PUBLIC;
