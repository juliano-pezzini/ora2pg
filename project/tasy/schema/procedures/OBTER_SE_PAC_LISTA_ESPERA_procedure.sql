-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_se_pac_lista_espera ( nr_seq_agenda_p bigint, nm_pessoa_lista_p INOUT text, cd_pessoa_fisica_p INOUT text) AS $body$
DECLARE

						 
 
ds_retorno_w		varchar(2000) := null;
nm_pessoa_lista_w	varchar(255);
ds_agenda_w		varchar(60);
nm_pessoa_lista_ww	varchar(255);
ds_agenda_ww		varchar(60);
cd_pessoa_fisica_ww	varchar(10);
cd_pessoa_fisica_w	varchar(10);

						 
c01 CURSOR FOR 
	SELECT	substr(a.nm_pessoa_lista,1,255) nm_pessoa_lista, 
		a.cd_pessoa_fisica 
	from	agenda_lista_espera a, 
		agenda_paciente b 
	where	a.dt_desejada between b.hr_inicio and b.hr_inicio + (b.nr_minuto_duracao/1440) 
	and	((a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '') or (a.nm_pessoa_lista IS NOT NULL AND a.nm_pessoa_lista::text <> '')) 
	and	obter_tipo_agenda(a.cd_agenda) 	= 1 
	and	obter_tipo_agenda(b.cd_agenda) 	= 1 
	and 	a.ie_status_espera 		= 'A' 
	and	b.nr_sequencia 			= nr_seq_agenda_p 
	order by a.dt_desejada desc;


BEGIN 
 
open C01;
loop 
fetch C01 into	 
	nm_pessoa_lista_w, 
	cd_pessoa_fisica_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	nm_pessoa_lista_ww	:= nm_pessoa_lista_w;
	cd_pessoa_fisica_ww	:= cd_pessoa_fisica_w;
	end;
end loop;
close C01;
 
nm_pessoa_lista_p	:= nm_pessoa_lista_ww;
cd_pessoa_fisica_p	:= cd_pessoa_fisica_ww;
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_se_pac_lista_espera ( nr_seq_agenda_p bigint, nm_pessoa_lista_p INOUT text, cd_pessoa_fisica_p INOUT text) FROM PUBLIC;
