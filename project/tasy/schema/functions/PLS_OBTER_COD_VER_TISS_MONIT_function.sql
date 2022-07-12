-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_cod_ver_tiss_monit (cd_versao_tiss_p pls_versao_tiss.cd_versao_tiss%type) RETURNS varchar AS $body$
DECLARE


cd_versao_tiss_w		varchar(3);
			

BEGIN
if (cd_versao_tiss_p = '1.00.00') then
	cd_versao_tiss_w := '001';
	
elsif (cd_versao_tiss_p = '1.01.00') then
	cd_versao_tiss_w := '002';
	
elsif (cd_versao_tiss_p = '2.00.00') then
	cd_versao_tiss_w := '003';
	
elsif (cd_versao_tiss_p = '2.01.01') then
	cd_versao_tiss_w := '004';
	
elsif (cd_versao_tiss_p = '2.01.02') then
	cd_versao_tiss_w := '005';
	
elsif (cd_versao_tiss_p = '2.01.03') then
	cd_versao_tiss_w := '006';
	
elsif (cd_versao_tiss_p = '2.02.01') then
	cd_versao_tiss_w := '007';
	
elsif (cd_versao_tiss_p = '2.02.02') then
	cd_versao_tiss_w := '008';
	
elsif (cd_versao_tiss_p = '2.02.03') then
	cd_versao_tiss_w := '009';
	
elsif (cd_versao_tiss_p = '3.00.00') then
	cd_versao_tiss_w := '010';
	
elsif (cd_versao_tiss_p = '3.00.01') then
	cd_versao_tiss_w := '011';
	
elsif (cd_versao_tiss_p = '3.01.00') then
	cd_versao_tiss_w := '012';
	
elsif (cd_versao_tiss_p = '3.02.00') then
	cd_versao_tiss_w := '013';
	
elsif (cd_versao_tiss_p = '3.02.01') then
	cd_versao_tiss_w := '014';
	
elsif (cd_versao_tiss_p = '3.02.02') then
	cd_versao_tiss_w := '015';
	
elsif (cd_versao_tiss_p = '3.03.00') then
	cd_versao_tiss_w := '016';
	
elsif (cd_versao_tiss_p = '3.03.01') then
	cd_versao_tiss_w := '017';
	
elsif (cd_versao_tiss_p = '3.03.02') then
	cd_versao_tiss_w := '018';
	
elsif (cd_versao_tiss_p = '3.03.03') then
	cd_versao_tiss_w := '019';

elsif (cd_versao_tiss_p = '3.04.00') then
	cd_versao_tiss_w := '020';

elsif (cd_versao_tiss_p = '3.04.01') then
	cd_versao_tiss_w := '021';
	
elsif (cd_versao_tiss_p = '3.05.00') then
	cd_versao_tiss_w := '022';
	
elsif (cd_versao_tiss_p = '4.00.00') then
	cd_versao_tiss_w := '023';
	
elsif (cd_versao_tiss_p = '4.00.01') then
	cd_versao_tiss_w := '024';	
		
end if;

return	cd_versao_tiss_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_cod_ver_tiss_monit (cd_versao_tiss_p pls_versao_tiss.cd_versao_tiss%type) FROM PUBLIC;

