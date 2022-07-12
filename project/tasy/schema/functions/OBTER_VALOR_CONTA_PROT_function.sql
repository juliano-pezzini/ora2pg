-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_conta_prot (nr_protocolo_p bigint, dt_parametro_p timestamp, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE

/*ie_opcao_p: 
ECH	- 	Buscar valor medico quando estrutura dos procedimentos for 71,91,92 e 93. 
*/
 
vl_retorno_w		double precision;
vl_medico_w		double precision;


BEGIN 
 
if (ie_opcao_p = 'ECH') then 
	select	coalesce(sum(a.vl_medico),0) 
	into STRICT	vl_medico_w 
	from  procedimento_paciente a, 
		conta_paciente b, 
		titulo_receber c 
	where	b.nr_seq_protocolo	= nr_protocolo_p	 
	and	b.nr_seq_protocolo = c.NR_SEQ_PROTOCOLO 
	and	c.ie_situacao <> '5' 
	and (c.ie_situacao <> '3' or (c.dt_liquidacao > dt_parametro_p or coalesce(c.dt_liquidacao::text, '') = '')) 
	and	((coalesce(c.dt_liquidacao::text, '') = '') or (c.dt_liquidacao > dt_parametro_p)) 
	and	a.nr_interno_conta = b.nr_interno_conta 
	and	coalesce(b.ie_cancelamento::text, '') = '' 
	and	b.cd_estabelecimento	= obter_estabelecimento_ativo 
	and	a.ie_emite_conta in (71, 91, 92, 93);
	 
	vl_retorno_w :=	vl_medico_w;
end if;
 
return	vl_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_conta_prot (nr_protocolo_p bigint, dt_parametro_p timestamp, ie_opcao_p text) FROM PUBLIC;

