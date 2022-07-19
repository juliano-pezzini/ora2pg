-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE update_records_maxvalue () AS $body$
DECLARE

max_count_w integer;


BEGIN

select	max(nr_sequencia)
into STRICT	max_count_w
from	report_downloaded_count;

update	patient_former_names
set		nr_report_sequence = max_count_w
where 	coalesce(nr_report_sequence::text, '') = '';

update	clinical_diagosis_detail
set		nr_report_sequence = max_count_w
where 	coalesce(nr_report_sequence::text, '') = '';

update	cancer_details
set 	nr_report_sequence = max_count_w
where 	coalesce(nr_report_sequence::text, '') = '';

update	header_detail
set 	nr_report_sequence = max_count_w
where 	coalesce(nr_report_sequence::text, '') = '';

update	cancer_admission_details
set 	nr_report_sequence = max_count_w
where 	coalesce(nr_report_sequence::text, '') = '';

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE update_records_maxvalue () FROM PUBLIC;

