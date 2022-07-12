-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_signature_status (nr_seq_main_daily_rep_p bigint) RETURNS bigint AS $body$
DECLARE


qtd_retorno_w			smallint;
dt_signature_1_w		agreg_signatures.dt_signature_1%type;
dt_signature_2_w		agreg_signatures.dt_signature_2%type;
dt_signature_3_w		agreg_signatures.dt_signature_3%type;
dt_signature_4_w		agreg_signatures.dt_signature_4%type;
dt_signature_5_w		agreg_signatures.dt_signature_5%type;
qtd_w				smallint := 0;


BEGIN
		
	select count(*)
	into STRICT
	qtd_w
	from	agreg_signatures where  nr_seq_main_daily_rep = nr_seq_main_daily_rep_p;

	if (qtd_w = 0) then
		qtd_retorno_w := 0;
	else
		select dt_signature_1,
			   dt_signature_2,
			   dt_signature_3,
		       dt_signature_4,
		       dt_signature_5
		into STRICT   dt_signature_1_w,
			   dt_signature_2_w,
			   dt_signature_3_w,
			   dt_signature_4_w,
			   dt_signature_5_w
		from   agreg_signatures
		where  nr_seq_main_daily_rep = nr_seq_main_daily_rep_p;
		
		if (coalesce(dt_signature_1_w::text, '') = ''
			and	coalesce(dt_signature_2_w::text, '') = ''
			and coalesce(dt_signature_3_w::text, '') = ''
			and coalesce(dt_signature_4_w::text, '') = ''
			and coalesce(dt_signature_5_w::text, '') = '') then
			
			qtd_retorno_w := 0;
		
		elsif ((dt_signature_1_w IS NOT NULL AND dt_signature_1_w::text <> '')
			   and (dt_signature_2_w IS NOT NULL AND dt_signature_2_w::text <> '')
			   and (dt_signature_3_w IS NOT NULL AND dt_signature_3_w::text <> '')
			   and (dt_signature_4_w IS NOT NULL AND dt_signature_4_w::text <> '')
			   and (dt_signature_5_w IS NOT NULL AND dt_signature_5_w::text <> '')) then
			 
			qtd_retorno_w := 2;
		else 	
			qtd_retorno_w := 1;
			
		end if;	
	end if;
	
return qtd_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_signature_status (nr_seq_main_daily_rep_p bigint) FROM PUBLIC;
