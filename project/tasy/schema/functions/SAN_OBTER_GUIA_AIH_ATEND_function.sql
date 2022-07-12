-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_guia_aih_atend (nr_atendimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w	varchar(50);

BEGIN
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 
	if (ie_opcao_p = 'G') then 
		select	max(h.nr_doc_convenio) 
		into STRICT	ds_retorno_w 
		from	atend_categoria_convenio h, 
			atendimento_paciente x 
		where	h.nr_atendimento = x.nr_atendimento 
		and	x.nr_atendimento = nr_atendimento_p;
	elsif (ie_opcao_p = 'A') then 
		select	max(j.nr_aih) 
		into STRICT	ds_retorno_w 
		from	sus_aih j, 
			atendimento_paciente x 
		where	j.nr_atendimento = x.nr_atendimento 
		and	x.nr_atendimento = nr_atendimento_p;
		 
		if (coalesce(ds_retorno_w::text, '') = '') then	 
			select	max(j.nr_aih) 
			into STRICT	ds_retorno_w 
			from	sus_aih_unif j, 
				atendimento_paciente x 
			where	j.nr_atendimento = x.nr_atendimento 
			and	x.nr_atendimento = nr_atendimento_p;
		end if;
		 
		if (coalesce(ds_retorno_w::text, '') = '') then	 
			select	max(j.nr_aih) 
			into STRICT	ds_retorno_w 
			from	sus_laudo_paciente j, 
				atendimento_paciente x 
			where	j.nr_atendimento = x.nr_atendimento 
			and	x.nr_atendimento = nr_atendimento_p;
		end if;	
	end if;	
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_guia_aih_atend (nr_atendimento_p bigint, ie_opcao_p text) FROM PUBLIC;

