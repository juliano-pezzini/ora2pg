-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pfcs_pck_utils.get_age (ds_age_unit_p text, qt_age_p bigint) RETURNS bigint AS $body$
DECLARE

		nr_return_w		bigint;
	
BEGIN
		if (qt_age_p IS NOT NULL AND qt_age_p::text <> '') then
			case ds_age_unit_p
				when PFCS_PCK_CONSTANTS.IE_MONTHS then
					nr_return_w := trunc(qt_age_p / 12);
				when PFCS_PCK_CONSTANTS.IE_YEARS then
					nr_return_w :=  qt_age_p;
			else
				nr_return_w := null;
			end case;
		end if;

		return nr_return_w;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pfcs_pck_utils.get_age (ds_age_unit_p text, qt_age_p bigint) FROM PUBLIC;
