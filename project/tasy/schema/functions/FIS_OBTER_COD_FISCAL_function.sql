-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fis_obter_cod_fiscal ( cd_tributo_p bigint, ie_tributacao_cst_p text) RETURNS varchar AS $body$
DECLARE


ie_tipo_tributo_w 	varchar(15);


BEGIN
select max(t.ie_tipo_tributo)
into STRICT       ie_tipo_tributo_w
from       tributo t
where      t.cd_tributo = cd_tributo_p;

if (ie_tipo_tributo_w  = 'ICMS') then
	case ie_tributacao_cst_p
		 when '00'  then return 1;
		 when '20'  then return 1;
		 when '30'  then return 2;
   		 when '40'  then return 2;
		 when '41'  then return 2;
		 when '50'  then return 3;
		 when '51'  then return 3;
		 when '90'  then return 3;
		 when '10'  then return 4;
		 when '60'  then return 4;
		 when '70'  then return 4;
	        else  return 0;
        end case;

elsif (ie_tipo_tributo_w  =  'IPI') Then

	case ie_tributacao_cst_p
		 when '00'  then return 1;
		 when '02'  then return 2;
		 when '03'  then return 2;
   		 when '04'  then return 2;
		 when '01'  then return 3;
		 when '05'  then return 3;
		 when '49'  then return 3;
	        else  return 0;
        end case;
else
       return 0;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fis_obter_cod_fiscal ( cd_tributo_p bigint, ie_tributacao_cst_p text) FROM PUBLIC;

