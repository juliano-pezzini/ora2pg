-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_apac_atend (nr_atendimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*			
NA - Número do APAC
FV - Fim da validade do APAC
*/
			
nr_seq_apac_w		bigint;
ds_retorno_w		varchar(20);
dt_competencia_w	sus_apac_unif.dt_competencia%type;
			

BEGIN

select	max(y.dt_competencia)
into STRICT	dt_competencia_w	
from	sus_apac_unif y
where	y.nr_atendimento = nr_atendimento_p;

select	max(x.nr_sequencia)
into STRICT	nr_seq_apac_w
from	sus_apac_unif x
where	x.nr_atendimento = nr_atendimento_p
and	x.dt_competencia = dt_competencia_w;

if (ie_opcao_p = 'NA') then
	begin
	select	to_char(nr_apac)
	into STRICT	ds_retorno_w
	from	sus_apac_unif
	where	nr_sequencia = nr_seq_apac_w;
	end;
end if;

if (ie_opcao_p = 'FV') then
	begin
	select	to_char(DT_FIM_VALIDADE,'dd/mm/yyyy')
	into STRICT	ds_retorno_w
	from	sus_apac_unif
	where	nr_sequencia = nr_seq_apac_w;
	end;
end if;
	
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_apac_atend (nr_atendimento_p bigint, ie_opcao_p text) FROM PUBLIC;

