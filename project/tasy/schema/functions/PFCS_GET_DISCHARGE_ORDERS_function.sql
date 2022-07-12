-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pfcs_get_discharge_orders (nr_sequencia_p bigint, cd_establishment_p bigint) RETURNS char AS $body$
DECLARE

	ie_discharge_written		char(1);


BEGIN
	select  coalesce(max('S'), 'N')
	into STRICT	ie_discharge_written
	FROM pfcs_detail_device pdd, pfcs_detail_bed pdb, pfcs_panel_detail ppd
LEFT OUTER JOIN pfcs_detail_patient pdp ON (ppd.nr_sequencia = pdp.nr_seq_detail)
WHERE ppd.nr_seq_indicator = 50  and ppd.nr_sequencia = pdb.nr_seq_detail and ppd.nr_sequencia = pdd.nr_seq_detail and pdp.nr_seq_encounter = nr_sequencia_p and (coalesce(cd_establishment_p::text, '') = '' or ppd.nr_seq_operational_level =  cd_establishment_p) and ppd.ie_situation = 'A';

	return ie_discharge_written;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pfcs_get_discharge_orders (nr_sequencia_p bigint, cd_establishment_p bigint) FROM PUBLIC;

