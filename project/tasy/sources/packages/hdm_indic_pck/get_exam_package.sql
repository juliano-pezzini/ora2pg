-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION hdm_indic_pck.get_exam ( nr_seq_exam_p bigint ) RETURNS bigint AS $body$
DECLARE

		nr_seq_exam_w	bigint;
	c_exams CURSOR FOR
		SELECT	a.nr_sequencia
		from	hdm_indic_dm_exam a
		where	a.nr_seq_exam = nr_seq_exam_p;
	
BEGIN
		for r_c_exams in c_exams loop
			nr_seq_exam_w := r_c_exams.nr_sequencia;
		end loop;
		return coalesce(nr_seq_exam_w,0);
	END;	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION hdm_indic_pck.get_exam ( nr_seq_exam_p bigint ) FROM PUBLIC;
