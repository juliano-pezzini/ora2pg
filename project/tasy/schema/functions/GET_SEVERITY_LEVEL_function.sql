-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_severity_level ( nr_gravidade_p alerta_api.nr_gravidade%type, cd_api_p alerta_api.cd_api%type ) RETURNS bigint AS $body$
DECLARE


	nr_severity_result_w	alerta_api.nr_gravidade%type;

	LEVEL_MINOR				constant alerta_api.nr_gravidade%type := 0;
	LEVEL_CONTRAINDICATED	constant alerta_api.nr_gravidade%type := 1;
	LEVEL_MAJOR				constant alerta_api.nr_gravidade%type := 2;
	LEVEL_MODERATE			constant alerta_api.nr_gravidade%type := 3;
	LEVEL_INFO				constant alerta_api.nr_gravidade%type := 5;
	LEVEL_UNKNOWN			constant alerta_api.nr_gravidade%type := 999;

	/*
		--- APIs
		A 	DRUG
		B 	DISEASE ICD10
		C 	TC_DUPLICATION
		D 	DRUG_DOSE_INTERACTIONS
		E 	ROUTE_CONTRAINDICATIONS
		F 	AGE_CONTRAINDICATION
		G 	GENDER_CONTRAINDICATIONS
		H 	PREGNANCY
		I 	LACTATION
		DDC	DRUG_DISEASE_CONTRAINDICATIONS
		PE	PRECAUTIONS
	
		-- TASY LEVELS
		0 		MINOR
		1   	CONTRAINDICATED
		2   	MAJOR
		3   	MODERATE
		4   	MODERATE
		5  		INFO
		OTHERS 	UNKNOWN
		
		-- MEDISPAN LEVELS
		medispan.agecontraindications.SeverityLevel
		medispan.diseasecontraindications.SeverityLevel
		medispan.pregnancycontraindications.SeverityLevel
		medispan.lactationcontraindications.SeverityLevel
			CONTRAINDICATED_MEDISPAN_ID	"1"
			EXTREME_CAUTION_MEDISPAN_ID	"3"
			INFORMATIONAL_MEDISPAN_ID	"5"
			NOT_RECOMMENDED_MEDISPAN_ID	"2"
			USE_CAUTIOUSLY_MEDISPAN_ID	"4"

		medispan.gendercontraindications.SeverityLevel
			CONTRAINDICATED_MEDISPAN_ID	"1"
			EXTREME_CAUTION_MEDISPAN_ID	"3"
			INFORMATIONAL_MEDISPAN_ID	"5"
			NOT_INDICATED_MEDISPAN_ID	"2"
			USE_CAUTIOUSLY_MEDISPAN_ID	"4"	

		medispan.interactions.SeverityLevel
			MAJOR_MEDISPAN_ID			"3"
			MINOR_MEDISPAN_ID			"1"
			MODERATE_MEDISPAN_ID		"2"

		medispan.routecontraindications.SeverityLevel
			CONTRAINDICATED_MEDISPAN_ID	"1"
			NOT_RECOMMENDED_MEDISPAN_ID	"2"
	*/
BEGIN
	<<case_api>>
	CASE
		/*
		medispan.agecontraindications.SeverityLevel
		medispan.diseasecontraindications.SeverityLevel
		medispan.pregnancycontraindications.SeverityLevel
		medispan.lactationcontraindications.SeverityLevel
		*/
		WHEN cd_api_p IN ('B', 'F', 'H', 'I', 'DDC') THEN
			CASE
				/* CONTRAINDICATED_MEDISPAN_ID -> CONTRAINDICATED */

				WHEN nr_gravidade_p IN (1) THEN
					nr_severity_result_w := LEVEL_CONTRAINDICATED;
				/* NOT_RECOMMENDED_MEDISPAN_ID -> MODERATE */

				WHEN nr_gravidade_p IN (2) THEN
					nr_severity_result_w := LEVEL_MODERATE;
				/* EXTREME_CAUTION_MEDISPAN_ID -> MODERATE */

				WHEN nr_gravidade_p IN (3) THEN
					nr_severity_result_w := LEVEL_MODERATE;
				/* USE_CAUTIOUSLY_MEDISPAN_ID -> MINOR */

				WHEN nr_gravidade_p IN (4) THEN
					nr_severity_result_w := LEVEL_MINOR;
				/* INFORMATIONAL_MEDISPAN_ID -> MINOR */

				WHEN nr_gravidade_p IN (5) THEN
					nr_severity_result_w := LEVEL_MINOR;
				/* UNKNOWN */

				ELSE
					nr_severity_result_w := nr_gravidade_p;
			END CASE;
		/*
		medispan.gendercontraindications.SeverityLevel
		*/
		WHEN cd_api_p IN ('G') THEN
			CASE
				/* CONTRAINDICATED_MEDISPAN_ID -> CONTRAINDICATED */

				WHEN nr_gravidade_p IN (1) THEN
					nr_severity_result_w := LEVEL_CONTRAINDICATED;
				/* NOT_INDICATED_MEDISPAN_ID -> MODERATE */

				WHEN nr_gravidade_p IN (2) THEN
					nr_severity_result_w := LEVEL_MODERATE;
				/* EXTREME_CAUTION_MEDISPAN_ID -> MODERATE */

				WHEN nr_gravidade_p IN (3) THEN
					nr_severity_result_w := LEVEL_MODERATE;
				/* USE_CAUTIOUSLY_MEDISPAN_ID -> MINOR */

				WHEN nr_gravidade_p IN (4) THEN
					nr_severity_result_w := LEVEL_MINOR;
				/* INFORMATIONAL_MEDISPAN_ID -> MINOR */

				WHEN nr_gravidade_p IN (5) THEN
					nr_severity_result_w := LEVEL_MINOR;
				/* UNKNOWN */

				ELSE
					nr_severity_result_w := nr_gravidade_p;
			END CASE;
		/*
		medispan.interactions.SeverityLevel
		*/
		WHEN cd_api_p = 'A' THEN
			CASE
				/* MINOR_MEDISPAN_ID -> MINOR */

				WHEN nr_gravidade_p IN (1) THEN
					nr_severity_result_w := LEVEL_MINOR;
				/* MODERATE_MEDISPAN_ID -> MODERATE */

				WHEN nr_gravidade_p IN (2) THEN
					nr_severity_result_w := LEVEL_MODERATE;
				/* MAJOR_MEDISPAN_ID -> MAJOR */

				WHEN nr_gravidade_p IN (3) THEN
					nr_severity_result_w := LEVEL_MAJOR;
				/* UNKNOWN */

				ELSE
					nr_severity_result_w := nr_gravidade_p;
			END CASE;
		/*
		medispan.routecontraindications.SeverityLevel
		*/
		WHEN cd_api_p IN ('E') THEN
			CASE
				/* CONTRAINDICATED_MEDISPAN_ID -> CONTRAINDICATED */

				WHEN nr_gravidade_p IN (1) THEN
					nr_severity_result_w := LEVEL_CONTRAINDICATED;
				/* NOT_RECOMMENDED_MEDISPAN_ID -> MODERATE */

				WHEN nr_gravidade_p IN (2) THEN
					nr_severity_result_w := LEVEL_MODERATE;
				/* UNKNOWN */

				ELSE
					nr_severity_result_w := nr_gravidade_p;
			END CASE;
		/*
		medispan.duplicatetherapy
		*/
		WHEN cd_api_p IN ('C') THEN
			CASE
				/* DEFAULT QUEM VEM DO WSI */

				WHEN nr_gravidade_p IN (0) THEN
					/* Por enquanto empre exibir o icone vermelho quando tem interacao */

					nr_severity_result_w := LEVEL_MAJOR;
				ELSE
					nr_severity_result_w := nr_gravidade_p;
			END CASE;
		/*
		medispan.dosing
		*/
		WHEN cd_api_p IN ('D') THEN
			/* DEFAULT QUEM VEM DO WSI */

			nr_severity_result_w := nr_gravidade_p;

		/*
		Others, no mapped
		*/
		ELSE
			nr_severity_result_w := nr_gravidade_p;
	END CASE case_api;

	return	nr_severity_result_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_severity_level ( nr_gravidade_p alerta_api.nr_gravidade%type, cd_api_p alerta_api.cd_api%type ) FROM PUBLIC;
