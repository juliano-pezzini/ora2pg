-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_proc_inter_conv (cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint ) RETURNS varchar AS $body$
DECLARE
	
ds_retorno_w	varchar(255);
nr_seq_proc_interno_w 	bigint;
			

BEGIN 
	if (nr_seq_proc_interno_p IS NOT NULL AND nr_seq_proc_interno_p::text <> '') then 
		ds_retorno_w := obter_desc_proc_interno(nr_seq_proc_interno_p);
	elsif (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') and (ie_origem_proced_p IS NOT NULL AND ie_origem_proced_p::text <> '') then 
		  
		select coalesce(max(a.nr_seq_proc_interno),0) 
		into STRICT nr_seq_proc_interno_w 
		from proc_interno_conv a 
		where a.cd_procedimento = cd_procedimento_p 
		and  a.ie_origem_proced = ie_origem_proced_p;
		 
		if (nr_seq_proc_interno_w > 0) then 
			ds_retorno_w := obter_desc_proc_interno(nr_seq_proc_interno_w);
		else 
			ds_retorno_w := '';
		end if;
	end if;
	 
	return ds_retorno_w;
	 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_proc_inter_conv (cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint ) FROM PUBLIC;
