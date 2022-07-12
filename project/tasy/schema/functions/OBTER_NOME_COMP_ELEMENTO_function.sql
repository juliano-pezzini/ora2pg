-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_comp_elemento ( nr_seq_css_elemento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w	varchar(100);


BEGIN 
 
if (nr_seq_css_elemento_p IS NOT NULL AND nr_seq_css_elemento_p::text <> '') then 
	begin 
	    select	coalesce(max(a.nm_componente), '') 
	    into STRICT  ds_retorno_w 
	    from	web_componente a 
	    where	a.nr_sequencia = (	SELECT	b.nr_seq_componente 
					from	web_css_elemento b 
					where	b.nr_sequencia = nr_seq_css_elemento_p);
	end;
end if;
 
return	ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_comp_elemento ( nr_seq_css_elemento_p bigint) FROM PUBLIC;
