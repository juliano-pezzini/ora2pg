-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION hdm_indic_pck.get_date_start_habit (dt_start_p timestamp, dt_birth_p timestamp, qt_age_exp_p bigint, qt_age_reg_p bigint, dt_release_p timestamp) RETURNS timestamp AS $body$
BEGIN
		if (coalesce(dt_start_p::text, '') = '') then
			if (coalesce(dt_birth_p::text, '') = ''
				or (coalesce(qt_age_exp_p::text, '') = '' and coalesce(qt_age_reg_p::text, '') = '')) then
				return dt_release_p;
			else
				if (qt_age_exp_p IS NOT NULL AND qt_age_exp_p::text <> '')  then
					return PKG_DATE_UTILS.start_of(pkg_date_utils.add_month(dt_birth_p, qt_age_exp_p * 12, 0), 'dd', 0);
				elsif (qt_age_reg_p IS NOT NULL AND qt_age_reg_p::text <> '') then
					return PKG_DATE_UTILS.start_of(pkg_date_utils.add_month(dt_birth_p, qt_age_reg_p * 12, 0), 'dd', 0);
				end if;
			end if;
		else
			return dt_start_p;
		end if;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION hdm_indic_pck.get_date_start_habit (dt_start_p timestamp, dt_birth_p timestamp, qt_age_exp_p bigint, qt_age_reg_p bigint, dt_release_p timestamp) FROM PUBLIC;