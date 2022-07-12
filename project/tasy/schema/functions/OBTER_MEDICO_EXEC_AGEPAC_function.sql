-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_medico_exec_agepac (nr_seq_agenda_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
cd_medico_w	varchar(10);
nm_medico_w	varchar(60);
ds_retorno_w	varchar(60);


BEGIN 
if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') then 
 
	select	coalesce(max(cd_medico_exec),0) cd_medico, 
		substr(obter_nome_pf(coalesce(max(cd_medico_exec),0)),1,60) nm_medico 
	into STRICT	cd_medico_w, 
		nm_medico_w 
	from	agenda_paciente 
	where	nr_sequencia = nr_seq_agenda_p;
 
	if (coalesce(ie_opcao_p,'C') = 'C') then 
		ds_retorno_w := cd_medico_w;
	elsif (coalesce(ie_opcao_p,'C') = 'N') then 
		ds_retorno_w := nm_medico_w;
	end if;
 
end if;
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_medico_exec_agepac (nr_seq_agenda_p bigint, ie_opcao_p text) FROM PUBLIC;

