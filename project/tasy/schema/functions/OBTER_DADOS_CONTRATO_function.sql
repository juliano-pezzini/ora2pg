-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_contrato ( nr_sequencia_p bigint, ie_tipo_p text) RETURNS varchar AS $body$
DECLARE



ds_retorno_w		varchar(255);
ds_contratado_w		varchar(80);
ie_classificacao_w	contrato.ie_classificacao%type;
cd_contrato_w		contrato.cd_contrato%type;
ds_objeto_contrato_w	contrato.ds_objeto_contrato%type;
cd_pessoa_contratada_w	contrato.cd_pessoa_contratada%type;
cd_cgc_contratado_w	contrato.cd_cgc_contratado%type;
dt_fim_w          	contrato.dt_fim%type;
dt_inicio_w		contrato.dt_inicio%type;
vl_total_contrato_w	contrato.vl_total_contrato%type;
cd_pessoa_resp_w	contrato.cd_pessoa_resp%type;
nr_seq_tipo_contrato_w	contrato.nr_seq_tipo_contrato%type;
nr_documento_externo_w	contrato.nr_documento_externo%type;
ie_pagar_receber_w	contrato.ie_pagar_receber%type;


/*Tipo retorno:
PF - Pessoa contratada	
PFN - Nome pessoa contratada
CNPJ - CNPJ contratado
DS - Descricao do contratado
CL - Classificacao do contrato
CD - Codigo do contrato
DO - Descricao do objeto do contrato
DI - Data inicio contrato
DF - Data fim contrato
VL - Valor Total do contrato
PR - Pessoa responsavel pelo contrato
PRN - Nome da pessoa responsavel pelo contrato
TC - Tipo de contrato
DTC - Descricao do tipo de contrato

NRE - Sequencia da etapa
NSE - Sequencia do tipo da etapa
NRR - Sequencia Regra pagamento
DSE - desc da etapa
NCR - nr crit rateio
DTE - desc tipo etapa
NDE - Nr documento externo

DRC - primeira data de vencimento do contrato do ultimo registro.
VRC - valor da regra do contrato do ultimo registro.
TPR - Tipo Pagar Receber.
*/
BEGIN

select	substr(obter_nome_pf_pj(cd_pessoa_contratada, cd_cgc_contratado),1,80),
	cd_pessoa_contratada,
	cd_cgc_contratado,
	ie_classificacao,
	cd_contrato,
	dt_fim,
	dt_inicio,
	substr(ds_objeto_contrato,1,255),
	coalesce(vl_total_contrato,0),
	cd_pessoa_resp,
	nr_seq_tipo_contrato,
	nr_documento_externo,
	ie_pagar_receber
into STRICT	ds_contratado_w,
	cd_pessoa_contratada_w,
	cd_cgc_contratado_w,
	ie_classificacao_w,
	cd_contrato_w,
	dt_fim_w,
	dt_inicio_w,
	ds_objeto_contrato_w,
	vl_total_contrato_w,
	cd_pessoa_resp_w,
	nr_seq_tipo_contrato_w,
	nr_documento_externo_w,
	ie_pagar_receber_w
from	contrato
where	nr_sequencia = nr_sequencia_p;

if (ie_tipo_p = 'DS') then
	ds_retorno_w	:= ds_contratado_w;
elsif (ie_tipo_p = 'CL') then
	ds_retorno_w	:= ie_classificacao_w;
elsif (ie_tipo_p = 'CD') then
	ds_retorno_w	:= cd_contrato_w;
elsif (ie_tipo_p = 'DO') then
	ds_retorno_w	:= ds_objeto_contrato_w;
elsif (ie_tipo_p = 'PF') then
	ds_retorno_w	:= cd_pessoa_contratada_w;
elsif (ie_tipo_p = 'CNPJ') then
	ds_retorno_w	:= cd_cgc_contratado_w;
elsif (ie_tipo_p = 'DF') then
	ds_retorno_w	:= to_char(dt_fim_w,'dd/mm/yyyy hh24:mm:ss');
elsif (ie_tipo_p = 'DI') then
	ds_retorno_w	:= to_char(dt_inicio_w,'dd/mm/yyyy hh24:mm:ss');
elsif (ie_tipo_p = 'VL') then
	ds_retorno_w	:= vl_total_contrato_w;
elsif (ie_tipo_p = 'PR') then
	ds_retorno_w	:= cd_pessoa_resp_w;	
elsif (ie_tipo_p = 'PRN') then
	ds_retorno_w	:= substr(obter_nome_pf(cd_pessoa_resp_w),1,255);		
elsif (ie_tipo_p = 'PFN') then
	ds_retorno_w	:= substr(obter_nome_pf(cd_pessoa_contratada_w),1,255);	
elsif (ie_tipo_p = 'TC') then
	ds_retorno_w	:= nr_seq_tipo_contrato_w;
elsif (ie_tipo_p = 'NDE') then
	ds_retorno_w	:= nr_documento_externo_w;
elsif (ie_tipo_p = 'TPR') then
	ds_retorno_w	:= ie_pagar_receber_w;		
elsif (ie_tipo_p = 'DTC') then
	begin
	select	substr(max(DS_TIPO_CONTRATO),1,200)
	into STRICT	ds_retorno_w
	from	tipo_contrato
	where	nr_sequencia = nr_seq_tipo_contrato_w;	
	end;
elsif (ie_tipo_p = 'NCR') then
	begin
	select	max(nr_seq_crit_rateio)
	into STRICT	ds_retorno_w
	from	contrato_regra_pagto
	where	nr_seq_contrato = nr_sequencia_p;
	end;
elsif (ie_tipo_p = 'NRR') then
	begin
	select	max(nr_sequencia)
	into STRICT	ds_retorno_w
	from	contrato_regra_pagto
	where	nr_seq_contrato = nr_sequencia_p;
	end;
elsif (ie_tipo_p = 'NRE') then
	begin
	select	nr_sequencia
	into STRICT	ds_retorno_w
	from	contrato_etapa
	where	nr_seq_contrato = nr_sequencia_p;
	end;

elsif (ie_tipo_p = 'NSE') then
	begin
	select	max(nr_seq_tipo_etapa)
	into STRICT	ds_retorno_w
	from	contrato_etapa
	where	nr_seq_contrato = nr_sequencia_p;
	end;
elsif (ie_tipo_p = 'DSE') then
	begin
	select	ds_etapa
	into STRICT	ds_retorno_w
	from	contrato_etapa
	where	nr_seq_contrato = nr_sequencia_p;
	end;
elsif (ie_tipo_p = 'DTE') then
	begin
	select	ds_tipo_etapa
	into STRICT	ds_retorno_w
	from	contrato_tipo_etapa
	where	nr_sequencia = (SELECT	max(nr_seq_tipo_etapa)
			from	contrato_etapa
			where	nr_seq_contrato = nr_sequencia_p);
	end;

elsif (ie_tipo_p = 'DRC') then
	begin
	select	min(b.dt_primeiro_vencto)
	into STRICT	ds_retorno_w
	from	contrato a,
		contrato_regra_pagto b
	where	b.nr_seq_contrato = a.nr_sequencia
	and	(b.dt_primeiro_vencto IS NOT NULL AND b.dt_primeiro_vencto::text <> '')
	and	a.nr_sequencia = nr_sequencia_p
	and	b.nr_sequencia = (SELECT	max(b.nr_sequencia) nr_sequencia
				  from		contrato a,
						contrato_regra_pagto b
				  where		b.nr_seq_contrato = a.nr_sequencia
				  and		(b.dt_primeiro_vencto IS NOT NULL AND b.dt_primeiro_vencto::text <> '')
				  and		a.nr_sequencia = nr_sequencia_p);
	end;
elsif (ie_tipo_p = 'VRC') then
	begin
	select	b.vl_pagto
	into STRICT	ds_retorno_w
	from	contrato a,
		contrato_regra_pagto b
	where	b.nr_seq_contrato = a.nr_sequencia
	and	(b.dt_primeiro_vencto IS NOT NULL AND b.dt_primeiro_vencto::text <> '')
	and	a.nr_sequencia = nr_sequencia_p
	and	b.nr_sequencia = (SELECT	max(b.nr_sequencia) nr_sequencia
				  from		contrato a,
						contrato_regra_pagto b
				  where		b.nr_seq_contrato = a.nr_sequencia
				  and		(b.dt_primeiro_vencto IS NOT NULL AND b.dt_primeiro_vencto::text <> '')
				  and		a.nr_sequencia = nr_sequencia_p);
	end;	
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_contrato ( nr_sequencia_p bigint, ie_tipo_p text) FROM PUBLIC;

