-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_signature_user (nr_seq_main_daily_rep_p bigint, cd_signature_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	agreg_signatures.nm_user_signature_1%type := null;
nm_user_1_w		agreg_signatures.nm_user_signature_1%type;
nm_user_2_w		agreg_signatures.nm_user_signature_2%type;
nm_user_3_w		agreg_signatures.nm_user_signature_3%type;
nm_user_4_w		agreg_signatures.nm_user_signature_4%type;
nm_user_5_w		agreg_signatures.nm_user_signature_5%type;


BEGIN
	
	select nm_user_signature_1,
		   nm_user_signature_2,
		   nm_user_signature_3,
		   nm_user_signature_4,
		   nm_user_signature_5
	into STRICT   nm_user_1_w,
		   nm_user_2_w,
		   nm_user_3_w,
		   nm_user_4_w,
		   nm_user_5_w
	from   agreg_signatures
	where  nr_seq_main_daily_rep = nr_seq_main_daily_rep_p;
	
	if (cd_signature_p = 1) then
		ds_retorno_w := nm_user_1_w;
	elsif (cd_signature_p = 2) then
		ds_retorno_w := nm_user_2_w;
	elsif (cd_signature_p = 3) then
		ds_retorno_w := nm_user_3_w;
	elsif (cd_signature_p = 4) then
		ds_retorno_w := nm_user_4_w;
	elsif (cd_signature_p = 5) then
		ds_retorno_w := nm_user_5_w;
	end if;
	
return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_signature_user (nr_seq_main_daily_rep_p bigint, cd_signature_p bigint) FROM PUBLIC;

