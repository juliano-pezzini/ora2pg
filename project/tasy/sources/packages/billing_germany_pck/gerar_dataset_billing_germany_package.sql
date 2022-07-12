-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION billing_germany_pck.gerar_dataset_billing_germany () RETURNS SETOF T_BILLING_GERMANY_DATASET_DATA AS $body$
DECLARE


	linha_w   t_billing_germany_dataset;

	id_seq_w		bigint;
	ds_seq_w		varchar(14);

        c01 CURSOR FOR
        SELECT  'UNH' 		unh
		,ds_seq_w	unh_0062
		,'AUFN'		unh_s009_0065
		,14		unh_s009_0052
		,'000'		unh_s009_0054
		,'00'		unh_s009_0051
		,'UNT' 		unt
		,'2'		unt_0074
		,ds_seq_w	unt_0062
;

	r_C01 	C01%rowtype;


	
BEGIN

	id_seq_w := 0;

	for i in 1..10 loop

		id_seq_w := i;

		if	length(id_seq_w) < 6 then
			ds_seq_w := lpad(to_char(id_seq_w),5,'0');
		else
			ds_seq_w := to_char(id_seq_w);
		end if;


		open C01;
		loop
		fetch C01 into r_C01;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			linha_w.unh		:=	r_C01.unh;
			linha_w.unh_0062	:=	r_C01.unh_0062;
			linha_w.unh_s009_0065	:=	r_C01.unh_s009_0065;
			linha_w.unh_s009_0052	:=	r_C01.unh_s009_0052;
			linha_w.unh_s009_0054	:=	r_C01.unh_s009_0054;
			linha_w.unh_s009_0051	:=	r_C01.unh_s009_0051;
			linha_w.unt		:=	r_C01.unt;
			linha_w.unt_0074	:=	r_C01.unt_0074;
			linha_w.unt_0062	:=	r_C01.unt_0062;
			RETURN NEXT linha_w;
		end loop;
		close C01;

	end loop;

        return;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION billing_germany_pck.gerar_dataset_billing_germany () FROM PUBLIC;