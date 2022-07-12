-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ptu_obter_versao_transacao ( ie_tipo_transacao_p text, cd_versao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);


BEGIN

if (ie_tipo_transacao_p = 'A100') then
	if (cd_versao_p = '5.0') then
		ds_retorno_w	:= '11';
	elsif (cd_versao_p = '6.0') then
		ds_retorno_w	:= '12';
	elsif (cd_versao_p = '9.0') then
		ds_retorno_w	:= '16';
	elsif (cd_versao_p in ('10.0','10.0a')) then
		ds_retorno_w	:= '17';
	elsif (cd_versao_p = '11.0') then
		ds_retorno_w	:= '18';
	else	
		ds_retorno_w	:= '18';
	end if;
	
elsif (ie_tipo_transacao_p = 'A200') then
	if (cd_versao_p = '5.0') then
		ds_retorno_w	:= '04';
	elsif (cd_versao_p = '6.0') then
		ds_retorno_w	:= '04';
	elsif (cd_versao_p in ('9.0','9.1')) then
		ds_retorno_w	:= '07';
	elsif (cd_versao_p in ('10.0','10.0a','11.0')) then
		ds_retorno_w	:= '08';
	else 	
		ds_retorno_w	:= '08';
	end if;
	
elsif (ie_tipo_transacao_p = 'A300') then
	if (cd_versao_p = '5.0') then
		ds_retorno_w	:= '11';
	elsif (cd_versao_p = '6.0') then
		ds_retorno_w	:= '12';
	elsif (cd_versao_p in ('9.0','9.1','10.0','10.0a','11.0')) then
		ds_retorno_w	:= '15';
	else	
		ds_retorno_w	:= '15';
	end if;
	
elsif (ie_tipo_transacao_p = 'A400') then
	if (cd_versao_p = '5.0') then
		ds_retorno_w	:= '20';
	elsif (cd_versao_p = '6.0') then
		ds_retorno_w	:= '21';
	elsif (cd_versao_p = '6.2') then
		ds_retorno_w	:= '22';
	elsif (cd_versao_p = '6.3') then
		ds_retorno_w	:= '23';
	elsif (cd_versao_p = '7.0') then
		ds_retorno_w	:= '24';
	elsif (cd_versao_p = '8.0') then
		ds_retorno_w	:= '25';
	elsif (cd_versao_p = '8.1') then
		ds_retorno_w	:= '26';
	elsif (cd_versao_p in ('10.0','10.0a')) then
		ds_retorno_w	:= '27';
	elsif (cd_versao_p = '11.0') then
		ds_retorno_w	:= '28';
	end if;
	
elsif (ie_tipo_transacao_p = 'A450') then
	if (cd_versao_p = '5.0') then
		ds_retorno_w	:= '03';
	elsif (cd_versao_p = '6.0') then
		ds_retorno_w	:= '03';
	elsif (cd_versao_p = '6.3') then
		ds_retorno_w	:= '04';
	elsif (cd_versao_p = '8.0') then
		ds_retorno_w	:= '06';
	elsif (cd_versao_p in ('10.0','10.0a','11.0')) then
		ds_retorno_w	:= '07';
	end if;
	
elsif (ie_tipo_transacao_p = 'A500') then
	if (cd_versao_p = '5.0') then
		ds_retorno_w	:= '21';
	elsif (cd_versao_p = '6.0') then
		ds_retorno_w	:= '22';
	elsif (cd_versao_p = '6.1') then
		ds_retorno_w	:= '23';
	elsif (cd_versao_p = '6.3') then
		ds_retorno_w	:= '24';
	elsif (cd_versao_p = '7.0') then
		ds_retorno_w	:= '25';
	elsif (cd_versao_p = '8.0') then
		ds_retorno_w	:= '26';
	elsif (cd_versao_p = '9.0') then
		ds_retorno_w	:= '27';
	elsif (cd_versao_p = '9.1') then
		ds_retorno_w	:= '28';
	elsif (cd_versao_p = '10.0') then
		ds_retorno_w	:= '29';
	elsif (cd_versao_p = '10.0a') then
		ds_retorno_w	:= '30';
	elsif (cd_versao_p = '11.0') then
		ds_retorno_w	:= '31';
	elsif (cd_versao_p = '11.0a') then
		ds_retorno_w	:= '32';
	elsif (cd_versao_p = '11.3') then
		ds_retorno_w	:= '33';
	end if;
	
elsif (ie_tipo_transacao_p = 'A510') then
	if (cd_versao_p in ('7.0','8.0','9.0','9.1')) then
		ds_retorno_w	:= '01';
	
	elsif (cd_versao_p in ('10.0') or (somente_numero(cd_versao_p) > 100)) then
		ds_retorno_w	:= '02';
	end if;
	
elsif (ie_tipo_transacao_p = 'A530') then
	if (cd_versao_p in ('10.0') or (somente_numero(cd_versao_p) > 100)) then
		ds_retorno_w	:= '01';
	end if;
	
elsif (ie_tipo_transacao_p = 'A550') then
	if (cd_versao_p = '5.0') then
		ds_retorno_w	:= '10';
	elsif (cd_versao_p = '6.0') then
		ds_retorno_w	:= '11';
	elsif (cd_versao_p = '6.0') then
		ds_retorno_w	:= '12';
	elsif (cd_versao_p = '7.0') then
		ds_retorno_w	:= '13';
	elsif (cd_versao_p = '8.0') then
		ds_retorno_w	:= '14';
	elsif (cd_versao_p = '9.0') then
		ds_retorno_w	:= '15';
	elsif (cd_versao_p in ('9.1','10.0','10.0a')) then
		ds_retorno_w	:= '16';
	elsif (cd_versao_p in ('11.0', '11.0a', '11.3')) then
		ds_retorno_w	:= '17';
	end if;
	
elsif (ie_tipo_transacao_p = 'A560') then
	if (cd_versao_p = '5.0') then
		ds_retorno_w	:= '06';
	elsif (cd_versao_p = '6.0') then
		ds_retorno_w	:= '07';
	elsif (cd_versao_p = '7.0') then
		ds_retorno_w	:= '08';
	elsif (cd_versao_p in ('8.0','9.0','9.1','10.0','10.0a','11.0')) then
		ds_retorno_w	:= '09';
	end if;

elsif (ie_tipo_transacao_p = 'A580') then
	if (cd_versao_p in ('9.0','9.1','10.0','10.0a')) then
		ds_retorno_w	:= '07';
	elsif (cd_versao_p = '11.0') then
		ds_retorno_w	:= '08';
	end if;
	
elsif (ie_tipo_transacao_p = 'A600') then
	if (cd_versao_p = '5.0') then
		ds_retorno_w	:= '06';
	elsif (cd_versao_p in ('6.0','9.0','9.1','10.0','10.0a','11.0')) then
		ds_retorno_w	:= '07';
	end if;
	
elsif (ie_tipo_transacao_p = 'A700') then
	if (cd_versao_p = '4.1') then
		ds_retorno_w	:= '15';
	elsif (cd_versao_p = '5.0') then
		ds_retorno_w	:= '16';
	elsif (cd_versao_p = '6.0') then
		ds_retorno_w	:= '17';
	elsif (cd_versao_p = '6.1') then
		ds_retorno_w	:= '18';
	elsif (cd_versao_p = '8.0') then
		ds_retorno_w	:= '19';
	elsif	((cd_versao_p = '9.0') or (cd_versao_p = '9.1'))then
		ds_retorno_w	:= '20';
	elsif (cd_versao_p = '10.0') then
		ds_retorno_w	:= '21';
	elsif (cd_versao_p = '10.0a') then
		ds_retorno_w	:= '22';
	elsif (cd_versao_p in ('11.0', '11.0a', '11.3')) then
		ds_retorno_w	:= '23';
	elsif (cd_versao_p = '13.0') then
		ds_retorno_w	:= '26';
	end if;
	
elsif (ie_tipo_transacao_p = 'A800') then
	if (cd_versao_p = '5.0') then
		ds_retorno_w	:= '05';
	elsif (cd_versao_p = '6.0') then
		ds_retorno_w	:= '05';
	elsif (cd_versao_p in ('9.0','9.1','10.0','10.0a','11.0')) then
		ds_retorno_w	:= '07';
	else
		ds_retorno_w	:= '07';
	end if;
	
elsif (ie_tipo_transacao_p = 'A1200') then
	if (cd_versao_p = '4.0') then
		ds_retorno_w	:= '01';
	elsif (cd_versao_p = '7.0') then
		ds_retorno_w	:= '02';
	elsif (cd_versao_p = '8.0') then
		ds_retorno_w	:= '03';
	elsif (cd_versao_p in ('9.0','9.1','10.0','10.0a','11.0'))then
		ds_retorno_w	:= '04';
	elsif (cd_versao_p = '11.0a') then
		ds_retorno_w	:= '05';
        elsif (cd_versao_p = '11.3') then
                ds_retorno_w	:= '06';
	elsif (cd_versao_p = '12.0') then
                ds_retorno_w	:= '07';
  elsif (cd_versao_p = '13.0') then
        ds_retorno_w    := '08'; 		
	end if;
	
elsif (ie_tipo_transacao_p = 'A1300') then
	if (cd_versao_p = '11.0') then
		ds_retorno_w	:= '11';
	elsif (cd_versao_p in ('10.0','10.0a')) then
		ds_retorno_w	:= '10';
	elsif (cd_versao_p in ('9.0','9.1')) then
		ds_retorno_w	:= '09';
	elsif (cd_versao_p = '8.0') then
		ds_retorno_w	:= '08';
	elsif (cd_versao_p = '7.0') then
		ds_retorno_w	:= '07';
	elsif (cd_versao_p = '6.3a') then
		ds_retorno_w	:= '06';
	elsif (cd_versao_p = '6.3') then
		ds_retorno_w	:= '05';
	elsif (cd_versao_p = '6.2') then
		ds_retorno_w	:= '04';
	else
		ds_retorno_w	:= '11';
	end if;
	
elsif (ie_tipo_transacao_p = 'A1350') then
	if (cd_versao_p in ('9.0','9.1','10.0','10.0a','11.0')) then
		ds_retorno_w	:= '02';
	else
		ds_retorno_w	:= '02';
	end if;
	
end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ptu_obter_versao_transacao ( ie_tipo_transacao_p text, cd_versao_p text) FROM PUBLIC;
