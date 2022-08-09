-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_decimal_sinal_vital_md (qt_regras_p bigint, nr_seq_item_p bigint, vl_item_p bigint, vl_regra_p bigint, vl_decimal_p INOUT bigint, ie_decimal_p INOUT text ) AS $body$
DECLARE


   ie_decimal_w	 varchar(1) := 'S';
   vl_regra_w	 bigint;
   vl_decimal_w	 bigint;

BEGIN
	--INICIO MD 4
	if (qt_regras_p > 0 ) and (nr_seq_item_p = 10) then
		vl_decimal_w := somente_numero(TRUNC(vl_item_p) - vl_item_p);
			
		if (vl_decimal_w	<> 0) then
			if ( vl_decimal_w = vl_regra_p ) then
				ie_decimal_w 	:= 'S';
			else
				ie_decimal_w	:= 'N';
			end if;
		end if;
	end if;

	vl_decimal_p := vl_decimal_w;
	ie_decimal_p := ie_decimal_W;


END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_decimal_sinal_vital_md (qt_regras_p bigint, nr_seq_item_p bigint, vl_item_p bigint, vl_regra_p bigint, vl_decimal_p INOUT bigint, ie_decimal_p INOUT text ) FROM PUBLIC;
