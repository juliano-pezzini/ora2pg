-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_agenda_fora_ordem ( nr_sequencia_p bigint, cd_agenda_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w		varchar(1);
dt_ultimo_agenda_w	timestamp;
dt_agendamento_ww	timestamp;
nr_sequencia_w		bigint;

BEGIN
ds_retorno_w := 'N';
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (cd_agenda_p IS NOT NULL AND cd_agenda_p::text <> '') then 
	 
	select 	min(dt_desejada), 
		min(nr_sequencia) 
	into STRICT	dt_ultimo_agenda_w, 
		nr_sequencia_w 
	from	agenda_lista_espera 
	where	cd_agenda	=	cd_agenda_p 
	and	((cd_pessoa_fisica IS NOT NULL AND cd_pessoa_fisica::text <> '') or (nm_pessoa_lista IS NOT NULL AND nm_pessoa_lista::text <> '')) 
	and	coalesce(ie_status_espera,'A') = 'A';
 
	 
	select 	max(dt_desejada) 
	into STRICT	dt_agendamento_ww 
	from	agenda_lista_espera 
	where	nr_sequencia	=	nr_sequencia_p;
	 
	 
	if (dt_agendamento_ww <> dt_ultimo_agenda_w) or (nr_sequencia_w <> nr_sequencia_p) then 
		ds_retorno_w := 'S';
	else	 
		ds_retorno_w := 'N';
	end if;
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_agenda_fora_ordem ( nr_sequencia_p bigint, cd_agenda_p bigint) FROM PUBLIC;

