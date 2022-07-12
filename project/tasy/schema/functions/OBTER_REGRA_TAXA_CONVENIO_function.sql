-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_taxa_convenio (ie_tipo_convenio_p bigint, cd_convenio_p bigint) RETURNS varchar AS $body$
DECLARE

	
	concla CURSOR FOR
		SELECT nr_seq_classificacao
		FROM   convenio_classif
		WHERE  cd_convenio = cd_convenio_p;

    ie_exige_taxa_w   regra_taxa_adic_int.ie_exige_taxa%TYPE := 'N';
BEGIN
	IF (coalesce(ie_exige_taxa_w,'N') = 'N') THEN
	BEGIN
		SELECT ie_exige_taxa
		INTO STRICT   ie_exige_taxa_w
		FROM   regra_taxa_adic_int
		WHERE  coalesce(ie_tipo_convenio::text, '') = ''
		AND    coalesce(nr_seq_classif_conv::text, '') = ''
		AND    coalesce(cd_convenio::text, '') = '';
	EXCEPTION
		WHEN no_data_found THEN
            ie_exige_taxa_w := 'N';
    END;
	END IF;
	
	IF (coalesce(ie_exige_taxa_w,'N') = 'N') THEN
    BEGIN
        SELECT max(ie_exige_taxa)
        INTO STRICT   ie_exige_taxa_w
        FROM   regra_taxa_adic_int
        WHERE  ie_tipo_convenio = ie_tipo_convenio_p
	AND    coalesce(cd_convenio::text, '') = '';
    EXCEPTION
        WHEN no_data_found THEN
            ie_exige_taxa_w := 'N';
    END;
	END IF;
	
	IF (coalesce(ie_exige_taxa_w,'N') = 'N') THEN
    BEGIN
        FOR concla_r IN concla LOOP
            BEGIN
                SELECT ie_exige_taxa
                INTO STRICT   ie_exige_taxa_w
                FROM   regra_taxa_adic_int
                WHERE  nr_seq_classif_conv = concla_r.nr_seq_classificacao;
            EXCEPTION
                WHEN no_data_found THEN
                    ie_exige_taxa_w := 'N';
            END;

            IF (ie_exige_taxa_w = 'S') THEN
                EXIT;
            END IF;
        END LOOP;
    END;
	END IF;
	
	IF (coalesce(ie_exige_taxa_w,'N') = 'N') THEN
    BEGIN
        SELECT ie_exige_taxa
        INTO STRICT   ie_exige_taxa_w
        FROM   regra_taxa_adic_int
        WHERE  cd_convenio = cd_convenio_p
	AND    ((ie_tipo_convenio = ie_tipo_convenio_p) or (coalesce(ie_tipo_convenio::text, '') = '') or (coalesce(ie_tipo_convenio_p::text, '') = ''));
    EXCEPTION
        WHEN no_data_found THEN
            ie_exige_taxa_w := 'N';
    END;
	END IF;

    RETURN ie_exige_taxa_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_taxa_convenio (ie_tipo_convenio_p bigint, cd_convenio_p bigint) FROM PUBLIC;

