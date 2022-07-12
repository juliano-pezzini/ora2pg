-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fa_obter_numero_receita ( nr_atendimento_p bigint, ie_considera_serie_p text default 'S') RETURNS varchar AS $body$
DECLARE

ie_tipo_convenio_w	bigint;
nr_serie_w		varchar(2);
nr_receita_w		numeric(20);
nr_seq_inicial_w	bigint;
ds_retorno_w		varchar(100);

 

BEGIN 
 
nr_serie_w	:= '';
nr_receita_w	:= 0;
 
select 	max(coalesce(ie_tipo_convenio,0)) 
into STRICT	ie_tipo_convenio_w 
from	atendimento_paciente 
where	nr_atendimento = nr_atendimento_p;
 
if (ie_tipo_convenio_w > 0) then 
	select 	max(ds_serie), 
		coalesce(max(nr_seq_receita_inicial),0) 
	into STRICT	nr_serie_w, 
		nr_seq_inicial_w 
	from	fa_regra_serie_receita 
	where	ie_tipo_convenio = ie_tipo_convenio_w;
	 
	select 	coalesce(max((somente_numero(nr_receita))::numeric ),0) 
	into STRICT	nr_receita_w 
	from	fa_receita_farmacia 
	where	nr_atendimento in (SELECT nr_atendimento 
				  from  atendimento_paciente 
				  where ie_tipo_convenio = ie_tipo_convenio_w) 
	and	coalesce(ie_receita_externa,'N') = 'N';
	 
	if (nr_receita_w <= 0) then 
		nr_receita_w := nr_seq_inicial_w;
	else 
		nr_receita_w := nr_receita_w + 1;
	end if;
end if;
 
if (coalesce(ie_considera_serie_p,'S') = 'S') then 
	ds_retorno_w := nr_receita_w || '-' || nr_serie_w;
else	 
	ds_retorno_w := nr_receita_w;
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fa_obter_numero_receita ( nr_atendimento_p bigint, ie_considera_serie_p text default 'S') FROM PUBLIC;

