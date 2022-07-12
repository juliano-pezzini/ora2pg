-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION billing_germany_pck.gerar_trailler_billing_germany () RETURNS SETOF T_BILLING_GERMANY_TRAILLER_DAT AS $body$
DECLARE


	linha_w   t_billing_germany_trailler;

	id_seq_w		bigint;
	ds_seq_w		varchar(14);
	unb_s004_0020_w         varchar(14);

        c01 CURSOR FOR
        SELECT  'UNZ' 		unz
		,ds_seq_w	unz_0036
		,unb_s004_0020_w unz_0020
;

	r_C01 	C01%rowtype;


	
BEGIN

	select count(1)
	into STRICT id_seq_w
	from table(billing_germany_pck.gerar_dataset_billing_germany());

	select unb_s004_0020
	into STRICT unb_s004_0020_w
	from table(billing_germany_pck.gerar_header_billing_germany());

	if	length(id_seq_w) < 6 then
		ds_seq_w := lpad(to_char(id_seq_w),6,'0');
	else
		ds_seq_w := to_char(id_seq_w);
	end if;

	open C01;
	loop
	fetch C01 into r_C01;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		linha_w.unz		:=	r_C01.unz;
		linha_w.unz_0036	:=	r_C01.unz_0036;
		linha_w.unz_0020	:=	r_C01.unz_0020;
		RETURN NEXT linha_w;
	end loop;
	close C01;

	return;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION billing_germany_pck.gerar_trailler_billing_germany () FROM PUBLIC;