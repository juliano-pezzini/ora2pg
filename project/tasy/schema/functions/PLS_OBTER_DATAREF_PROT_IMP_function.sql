-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dataref_prot_imp ( nr_seq_prestador_p bigint, ie_origem_protocolo_p text, dt_mes_competencia_p timestamp, dt_protocolo_p timestamp, dt_recebimento_p timestamp, dt_aceite_p timestamp, ie_tipo_guia_p text, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type default null, ie_tipo_aplicacao_regra_p text default 'C', ie_rec_glosa_p text default 'A') RETURNS timestamp AS $body$
DECLARE


ie_tipo_data_base_w	varchar(10);
ie_referencia_w		varchar(1);
dt_limite_integracao_w	smallint;
dt_retorno_w		timestamp;
dt_referencia_w		timestamp;
ie_ultimo_dia_mes_w	pls_regra_prest_integracao.ie_ultimo_dia_mes%type := 'n';


BEGIN
dt_retorno_w	:= dt_mes_competencia_p;

SELECT * FROM pls_obter_limite_int(	nr_seq_prestador_p, dt_mes_competencia_p, ie_origem_protocolo_p, dt_protocolo_p, dt_recebimento_p, dt_aceite_p, ie_tipo_guia_p, nr_seq_protocolo_p, dt_limite_integracao_w, ie_referencia_w, ie_tipo_data_base_w, ie_ultimo_dia_mes_w, cd_estabelecimento_p, ie_tipo_aplicacao_regra_p, ie_rec_glosa_p) INTO STRICT dt_limite_integracao_w, ie_referencia_w, ie_tipo_data_base_w, ie_ultimo_dia_mes_w;

if (coalesce(ie_tipo_data_base_w,'C') = 'C') then
	dt_referencia_w	:= dt_mes_competencia_p;
elsif (coalesce(ie_tipo_data_base_w,'C') = 'P') then
	dt_referencia_w	:= dt_protocolo_p;
elsif (coalesce(ie_tipo_data_base_w,'C') = 'R') then
	dt_referencia_w	:= dt_recebimento_p;
elsif (coalesce(ie_tipo_data_base_w,'C') = 'F') then
	dt_referencia_w	:= dt_aceite_p;
end if;

if 		((coalesce(ie_ultimo_dia_mes_w,'N') = 'S') and ((to_char(dt_referencia_w, 'dd'))::numeric  = (to_char(last_day(clock_timestamp()), 'dd'))::numeric )) then
	if (ie_referencia_w = 'P') then
		dt_retorno_w	:= trunc(add_months(dt_referencia_w,1),'month');
	elsif (ie_referencia_w = 'A') then
		dt_retorno_w	:= trunc(dt_referencia_w,'dd'); /* sideker -  418489  */
	end if;	
elsif ((to_char( dt_referencia_w, 'dd'))::numeric  > dt_limite_integracao_w) then
	if (ie_referencia_w = 'P') then
		dt_retorno_w	:= trunc(add_months(dt_referencia_w,1),'month');
	elsif (ie_referencia_w = 'A') then
		dt_retorno_w	:= trunc(dt_referencia_w,'dd'); /* sideker -  418489  */
	end if;	
else
	if (ie_referencia_w = 'P') then
		dt_retorno_w	:= trunc(dt_referencia_w,'dd'); /* sideker -  418489 */
	elsif (ie_referencia_w = 'A') then
		dt_retorno_w	:= trunc(add_months(dt_referencia_w,-1),'month');
	end if;	
end if;

return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dataref_prot_imp ( nr_seq_prestador_p bigint, ie_origem_protocolo_p text, dt_mes_competencia_p timestamp, dt_protocolo_p timestamp, dt_recebimento_p timestamp, dt_aceite_p timestamp, ie_tipo_guia_p text, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type default null, ie_tipo_aplicacao_regra_p text default 'C', ie_rec_glosa_p text default 'A') FROM PUBLIC;

