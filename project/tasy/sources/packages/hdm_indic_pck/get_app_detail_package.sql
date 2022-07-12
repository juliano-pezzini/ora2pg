-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION hdm_indic_pck.get_app_detail (si_form_p text, si_type_p text, nm_place_p text, si_status_p text, nr_reason_cancel_p bigint, si_confirmed_p text, si_cancelled_p text) RETURNS bigint AS $body$
DECLARE

	nr_seq_app_det_w	bigint;
	c_detail CURSOR FOR
		SELECT	x.nr_sequencia
		from	hdm_indic_dm_app_details x
		where	x.si_form = si_form_p
		and	x.si_type = si_type_p
		and	x.nm_place = nm_place_p
		and	x.si_status = si_status_p
		and	x.nr_reason_cancel = nr_reason_cancel_p
		and	x.si_confirmed = si_confirmed_p
		and	x.si_cancelled = si_cancelled_p;
	
BEGIN
		for r_c_detail in c_detail loop
			nr_seq_app_det_w := r_c_detail.nr_sequencia;
		end loop;
		
		return nr_seq_app_det_w;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION hdm_indic_pck.get_app_detail (si_form_p text, si_type_p text, nm_place_p text, si_status_p text, nr_reason_cancel_p bigint, si_confirmed_p text, si_cancelled_p text) FROM PUBLIC;