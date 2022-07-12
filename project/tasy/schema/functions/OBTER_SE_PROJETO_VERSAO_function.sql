-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_projeto_versao (ie_tipo_p bigint, ie_ret_p bigint, ds_versao_p text, nr_proj_p bigint) RETURNS varchar AS $body$
DECLARE

			
ds_retorno_w	varchar(20) := 'N';
ds_versao_w	xml_projeto.ds_versao%type;


BEGIN

if (nr_proj_p IS NOT NULL AND nr_proj_p::text <> '') then
select	max(ds_versao)
into STRICT	ds_versao_w
from	xml_projeto
where	nr_sequencia = nr_proj_p;

end if;

if (ie_ret_p = 1) then	
if	(((nr_proj_p = 101076) or (nr_proj_p = 101210) or (nr_proj_p = 101384) or (nr_proj_p = 101493) or (nr_proj_p = 101646) or (nr_proj_p = 101800) or (nr_proj_p = 101970) or (nr_proj_p = 102313) or (nr_proj_p = 102572) or (nr_proj_p = 102915) or (nr_proj_p = 103218) and (ie_tipo_p in (11,12,13,15,17)))) then
	ds_retorno_w := 'S';
end if;
end if;

if (ie_ret_p = 2) then	
if	(((nr_proj_p = 101385) or (nr_proj_p = 101491) or (nr_proj_p = 101647) or (nr_proj_p = 101795) or (nr_proj_p = 101968) or (nr_proj_p = 102311) or (nr_proj_p = 102570) or (nr_proj_p = 102913) or (nr_proj_p = 103216) and (ie_tipo_p in (9,12)))) then
	ds_retorno_w := 'S';
end if;
end if;

if (ie_ret_p = 3) then	
if	(((nr_proj_p = 101211 AND ds_versao_w = '3.01.00') or
	  (nr_proj_p = 101491 AND ds_versao_w = '3.02.00') or
	  (nr_proj_p = 101491 AND ds_versao_w = '3.02.01') or 
	  (nr_proj_p = 101647 AND ds_versao_w = '3.02.02') or 
	  (nr_proj_p = 101795 AND ds_versao_w = '3.03.00') or 
	  (nr_proj_p = 101795 AND ds_versao_w = '3.03.01') or 
	  (nr_proj_p = 101968 AND ds_versao_w = '3.03.02') or 
	  (nr_proj_p = 102311 AND ds_versao_w = '3.03.03') or 
	  (nr_proj_p = 102570 AND ds_versao_w = '3.04.00') or
	  (nr_proj_p = 102570 AND ds_versao_w = '3.05.00') or
	  ((nr_proj_p = 102570) and (position('3.04.00,3.04.01' in ds_versao_w) > 0)) or
	  (nr_proj_p = 102913 AND ds_versao_w = '3.04.01')or
	  (nr_proj_p = 103216 AND ds_versao_w = '4.00.01')) and (ie_tipo_p in (9,0))) then
	ds_retorno_w := 'S';
end if;
end if;

if (ie_ret_p = 4) then	
if (coalesce(ds_versao_p,'2.01.02') in ('3.01.00','3.01.01','3.02.00','3.02.01','3.02.02','3.03.00','3.03.01','3.03.02','3.03.03','3.04.00','3.04.01','3.05.00','4.00.01')) then
	ds_retorno_w := 'S';
elsif (position(ds_versao_p in '3.04.00,3.04.01') > 0) then
	ds_retorno_w := 'S';
end if;
end if;

if (ie_ret_p = 6) then	
if (nr_proj_p in (100022,100221,100321,101046,101209,101383,101494,101645,101799,101969,102312,102571,102914,103217)) then
	ds_retorno_w := 'S';
end if;
end if;

if (ie_ret_p = 7) then	
if (nr_proj_p in (98,105,116,100022,100221,100321,101046,101209,101383,101494,101645,101799,101969,102312,102571,102914,103217)) then
	ds_retorno_w := 'S';
end if;
end if;

if (ie_ret_p = 10) then	
	ds_retorno_w := ds_versao_w;
end if;

if (ie_ret_p = 11) then	
	if (ds_versao_p in ('3.04.00','3.04.01','3.05.00','4.00.01')) then
		ds_retorno_w := 'S';
	elsif (position(ds_versao_p in '3.04.00,3.04.01,3.05.00') > 0) then
		ds_retorno_w := 'S';
	end if;
end if;

if (ie_ret_p = 12) then	

	if (coalesce(ds_versao_p,'2.01.02') in ('3.00.01','3.01.00','3.01.01','3.02.00','3.02.01','3.02.02','3.03.00','3.03.01','3.03.02','3.03.03','3.04.00','3.04.01','3.05.00','4.00.01')) then
		ds_retorno_w := 'S';
	elsif (position(ds_versao_p in '3.04.00,3.04.01,3.05.00') > 0) then
		ds_retorno_w := 'S';
	end if;
	
end if;

if (ie_ret_p = 13) then	
if (coalesce(ds_versao_p,'2.01.02') in ('3.02.00','3.02.01','3.02.02','3.03.00','3.03.01','3.03.02','3.03.03','3.04.00','3.04.01','3.05.00','4.00.01')) then
	ds_retorno_w := 'S';
elsif (position(ds_versao_p in '3.04.00,3.04.01,3.05.00') > 0) then
	ds_retorno_w := 'S';
end if;
end if;

if (ie_ret_p = 14) then	
if	((nr_proj_p = 103216) or (nr_proj_p = 103217) or (nr_proj_p = 103218) or (nr_proj_p = 103219) or (nr_proj_p = 103261) or	 --4.00.01
	 (nr_proj_p = 102573) or (nr_proj_p = 102572) or (nr_proj_p = 102571) or (nr_proj_p = 102570) or 	 --3.05.00	  
	 (nr_proj_p = 102314) or (nr_proj_p = 102313) or (nr_proj_p = 102312) or (nr_proj_p = 102311) or 	 --3.03.03	  
	 (nr_proj_p = 101970) or (nr_proj_p = 101969) or (nr_proj_p = 101968) or (nr_proj_p = 101959) or 	 --3.03.02	  
	 (nr_proj_p = 101801) or (nr_proj_p = 101800) or (nr_proj_p = 101799) or (nr_proj_p = 101795) or 	 --3.03.01		 
	 (nr_proj_p = 101648) or (nr_proj_p = 101647) or (nr_proj_p = 101646) or (nr_proj_p = 101644) or 	 --3.02.02
	 (nr_proj_p = 101490) or (nr_proj_p = 101491) or (nr_proj_p = 101493) or (nr_proj_p = 101494) or 	 --3.02.01		 
	 (nr_proj_p = 101386) or (nr_proj_p = 101385) or (nr_proj_p = 101384) or (nr_proj_p = 101383)) then 	--3.02.00		  
	ds_retorno_w := 'S';
end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_projeto_versao (ie_tipo_p bigint, ie_ret_p bigint, ds_versao_p text, nr_proj_p bigint) FROM PUBLIC;
