-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
	/*---------------------------------------------------------------------------------------------------------------------------------------------
	|			GENERATE VITAL SIGNS RANGE VARIATIONS				    |
	*/

	


CREATE OR REPLACE PROCEDURE hdm_indic_pck.generate_vital_sign_range_var () AS $body$
DECLARE

	
		last_nr_bmi_range_order_w	hdm_indic_dm_bmi_range.nr_range_order%type;
		last_nr_bp_range_order_w	hdm_indic_dm_bp_range.nr_range_order%type;	
		last_nr_glyc_range_order_w	hdm_indic_dm_glyc_range.nr_range_order%type;
		last_person_w			hdm_indic_ft_vital_sign.nr_dif_person%type;
		qt_bmi_range_variation_w	hdm_indic_ft_vital_sign.qt_bmi_range_variation%type;
		qt_bp_range_variation_w		hdm_indic_ft_vital_sign.qt_bp_range_variation%type;
	        glyc_range_variation_w		hdm_indic_ft_vital_sign.qt_glyc_range_variation%type;
		
		c_ordered_vs CURSOR(	dt_start_pc	timestamp,
					dt_end_pc	timestamp) FOR
			SELECT	a.nr_sequencia,
				a.nr_dif_person,
				bmi.nr_range_order nr_bmi_range_order,
				bp.nr_range_order nr_bp_range_order,
				glyc.nr_range_order nr_glyc_range_order
			from	hdm_indic_dm_bmi_range bmi,
				hdm_indic_dm_bp_range bp,
				hdm_indic_dm_glyc_range glyc,
				hdm_indic_ft_vital_sign a,
				hdm_indic_dm_day b
			where	b.nr_sequencia = a.nr_seq_day
			and	a.nr_seq_bmi_range = bmi.nr_sequencia
			and	a.nr_seq_bp_range = bp.nr_sequencia
			and	a.nr_seq_glyc_range = glyc.nr_sequencia
			and	b.dt_complete_date between dt_start_pc and dt_end_pc
			order by
				a.nr_dif_person,
				b.dt_complete_date;
	
	
BEGIN
		last_nr_bmi_range_order_w	:= -1;
		last_nr_bp_range_order_w	:= -1;
		last_nr_glyc_range_order_w	:= -1;
		last_person_w			:= 'X';
		PERFORM set_config('hdm_indic_pck.qt_record_w', 0, false);
		
		for r_c_ordered_vs in c_ordered_vs(current_setting('hdm_indic_pck.dt_start_w')::timestamp,current_setting('hdm_indic_pck.dt_end_w')::timestamp) loop
			if (r_c_ordered_vs.nr_dif_person <> last_person_w) then
				qt_bmi_range_variation_w	:= 0;
				qt_bp_range_variation_w		:= 0;
				glyc_range_variation_w		:= 0;
			else
				qt_bmi_range_variation_w	:= r_c_ordered_vs.nr_bmi_range_order - last_nr_bmi_range_order_w;
				qt_bp_range_variation_w		:= r_c_ordered_vs.nr_bp_range_order - last_nr_bp_range_order_w;
				glyc_range_variation_w		:= r_c_ordered_vs.nr_glyc_range_order - last_nr_glyc_range_order_w;
			end if;
		
			update	hdm_indic_ft_vital_sign
			set	qt_bmi_range_variation	= qt_bmi_range_variation_w,
				qt_bp_range_variation	= qt_bp_range_variation_w,
				qt_glyc_range_variation = glyc_range_variation_w
			where	nr_sequencia	= r_c_ordered_vs.nr_sequencia;
			
			if (current_setting('hdm_indic_pck.qt_record_w')::integer > current_setting('hdm_indic_pck.qt_rec_commit_w')::integer) then
				commit;
				PERFORM set_config('hdm_indic_pck.qt_record_w', 0, false);
			end if;
			
			PERFORM set_config('hdm_indic_pck.qt_record_w', current_setting('hdm_indic_pck.qt_record_w')::integer + 1, false);
			last_nr_bmi_range_order_w	:= r_c_ordered_vs.nr_bmi_range_order;
			last_nr_bp_range_order_w	:= r_c_ordered_vs.nr_bp_range_order;
			last_nr_glyc_range_order_w	:= r_c_ordered_vs.nr_glyc_range_order;
			last_person_w			:= r_c_ordered_vs.nr_dif_person;
		end loop;
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hdm_indic_pck.generate_vital_sign_range_var () FROM PUBLIC;
