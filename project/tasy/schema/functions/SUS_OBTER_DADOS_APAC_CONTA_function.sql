-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_dados_apac_conta ( nr_interno_conta_p bigint, ie_opcao_p text, ie_tipo_p text) RETURNS varchar AS $body$
DECLARE

/*
Tipo:
C - Codigo
D - Descricao
Opcao:
CX - Complexidade
TF - Tipo de financiamento
TA - Tipo de APAC
AS - APAC Segunda continuidade
DO - Data de ocorrencia
*/
					
ds_retorno_w			varchar(255) := '';
ie_tipo_financiamento_w		varchar(15);
ie_complexidade_w			varchar(15);
ie_tipo_apac_w			smallint;
nr_apac_w			bigint;
nr_seq_apac_w			bigint;
nr_atendimento_w			bigint;
qt_continuidade_w			bigint;
nr_seq_primeira_apac_w		bigint;
ie_continuidade_w			varchar(15) := 'N';
dt_ocorrencia_w			timestamp;


BEGIN	

begin
select	max(b.ie_complexidade),
	max(b.ie_tipo_financiamento),
	max(a.ie_tipo_apac),
	max(nr_apac),
	max(nr_sequencia),
	max(nr_atendimento),
	max(dt_ocorrencia)
into STRICT	ie_complexidade_w,
	ie_tipo_financiamento_w,
	ie_tipo_apac_w,
	nr_apac_w,
	nr_seq_apac_w,
	nr_atendimento_w,
	dt_ocorrencia_w
from	sus_apac_unif a,
	sus_procedimento b
where	a.cd_procedimento 	= b.cd_procedimento
and	a.ie_origem_proced	= b.ie_origem_proced
and	a.nr_interno_conta	= nr_interno_conta_p;
exception
when others then
	ie_complexidade_w 	:= '';
	ie_tipo_financiamento_w	:= '';
end;

if (ie_opcao_p = 'CX') then
	begin
	if (ie_tipo_p = 'C') then
		begin
		ds_retorno_w := ie_complexidade_w;
		end;
	else
		begin
		ds_retorno_w := substr(obter_valor_dominio(1763,ie_complexidade_w),1,255);
		end;
	end if;
	end;
elsif (ie_opcao_p = 'TF') then
	begin
	if (ie_tipo_p = 'C') then
		begin
		ds_retorno_w := ie_tipo_financiamento_w;
		end;
	else
		begin
		ds_retorno_w := substr(obter_valor_dominio(2135,ie_tipo_financiamento_w),1,255);
		end;
	end if;
	end;
elsif (ie_opcao_p = 'TA') then
	begin
	if (ie_tipo_p = 'C') then
		begin
		ds_retorno_w := ie_tipo_apac_w;
		end;
	else
		begin
		ds_retorno_w := substr(obter_valor_dominio(1092,ie_tipo_apac_w),1,255);
		end;
	end if;
	end;
elsif (ie_opcao_p = 'AS') then
	begin
	
	if (ie_tipo_apac_w = 2) then

		select	count(*)
		into STRICT	qt_continuidade_w
		from	sus_apac_unif
		where	nr_atendimento 	= nr_atendimento_w
		and	nr_apac		= nr_apac_w
		and	ie_tipo_apac 	= ie_tipo_apac_w
		and	nr_sequencia	<> nr_seq_apac_w;
		
		if (qt_continuidade_w > 0) then
		
			select	min(a.nr_sequencia)
			into STRICT	nr_seq_primeira_apac_w
			from	sus_apac_unif a
			where	a.nr_atendimento 	= nr_atendimento_w
			and	a.nr_apac		= nr_apac_w
			and	a.ie_tipo_apac 		= ie_tipo_apac_w;
			
			if (nr_seq_primeira_apac_w <> nr_seq_apac_w) then
				ie_continuidade_w	:= 'S';
			else
				ie_continuidade_w	:= 'N';
			end if;	
		else
			ie_continuidade_w	:= 'N';
		end if;

	end if;	

	ds_retorno_w := ie_continuidade_w;

	end;
elsif (ie_opcao_p = 'DO') then
	begin
	ds_retorno_w := substr(to_char(dt_ocorrencia_w,'dd/mm/yyyy hh24:mi:ss'),1,255);
	end;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_dados_apac_conta ( nr_interno_conta_p bigint, ie_opcao_p text, ie_tipo_p text) FROM PUBLIC;

