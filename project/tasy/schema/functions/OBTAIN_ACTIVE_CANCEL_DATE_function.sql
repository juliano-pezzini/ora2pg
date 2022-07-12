-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obtain_active_cancel_date (nr_seq_lote_p bigint, cd_resp_type_p text) RETURNS timestamp AS $body$
DECLARE

	dt_review_accepted_cancelled_w ap_lote_review.DT_REVIEW_ACCEPTED%type;

BEGIN
	dt_review_accepted_cancelled_w := null;
	
	if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then
		if ( coalesce(cd_resp_type_p, 'NA') = 'A' ) then
		   select coalesce(DT_REVIEW_ACCEPTED, null) into STRICT dt_review_accepted_cancelled_w
		   from ap_lote_review where nr_seq_lote = nr_seq_lote_p;
		elsif ( coalesce(cd_resp_type_p, 'NA') = 'C' ) then
		   select coalesce(DT_REVIEW_CANCELLED, null) into STRICT dt_review_accepted_cancelled_w
		   from ap_lote_review where nr_seq_lote = nr_seq_lote_p;
		else
		   dt_review_accepted_cancelled_w := null;
		end if;
	end if;
return dt_review_accepted_cancelled_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obtain_active_cancel_date (nr_seq_lote_p bigint, cd_resp_type_p text) FROM PUBLIC;
