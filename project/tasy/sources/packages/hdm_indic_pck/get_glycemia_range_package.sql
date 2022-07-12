-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION hdm_indic_pck.get_glycemia_range ( qt_glycemia_p bigint, dt_nascimento_p timestamp, ie_sexo_p text) RETURNS bigint AS $body$
DECLARE

		nr_seq_range_w	bigint	:= null;
	c_glycemia_range CURSOR FOR
		SELECT	a.nr_sequencia
		from	hdm_indic_dm_glyc_range a
		where	qt_glycemia_p between a.nr_minimum and a.nr_maximum
		and	(trunc((months_between(clock_timestamp(), dt_nascimento_p))/12) between a.nr_age_minimum and a.nr_age_maximum
			or (coalesce(dt_nascimento_p::text, '') = ''
				or (coalesce(a.nr_age_minimum::text, '') = ''
					or	coalesce(a.nr_age_maximum::text, '') = '')))
		and (ie_sexo_p = a.si_sex	
			or (coalesce(ie_sexo_p::text, '') = ''	
				or	coalesce(a.si_sex::text, '') = ''));
	
BEGIN
		for r_c_glycemia_range in c_glycemia_range loop
			nr_seq_range_w	:= r_c_glycemia_range.nr_sequencia;
		end loop;
		return coalesce(nr_seq_range_w,0);
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION hdm_indic_pck.get_glycemia_range ( qt_glycemia_p bigint, dt_nascimento_p timestamp, ie_sexo_p text) FROM PUBLIC;
