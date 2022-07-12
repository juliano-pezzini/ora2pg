-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pfcs_pck_utils.get_start_encounter_class (nr_seq_encounter_p bigint, ds_class_p text) RETURNS timestamp AS $body$
DECLARE

		dt_start_w  pfcs_encounter_classif.period_start%type;
	
BEGIN
		select	period_start
		into STRICT	dt_start_w
		from (SELECT period_start
			from  pfcs_encounter_classif
			where  nr_seq_encounter = nr_seq_encounter_p
			and  upper(si_classif) = upper(ds_class_p)
			order by period_start desc) alias2 LIMIT 1;

		return dt_start_w;

		exception
			when no_data_found then return null;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pfcs_pck_utils.get_start_encounter_class (nr_seq_encounter_p bigint, ds_class_p text) FROM PUBLIC;
