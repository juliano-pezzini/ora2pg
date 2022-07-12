-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_estagio_os ( nr_seq_ordem_p bigint, ie_opcao_p text) RETURNS timestamp AS $body$
DECLARE

dt_retorno_w			timestamp;
/* ie_opcao_p
	'D' - Desenvolvimento
	'S' - Suporte
	'C' - Cliente
	'G' - Geral
*/
BEGIN
if (nr_seq_ordem_p IS NOT NULL AND nr_seq_ordem_p::text <> '') then
	if (ie_opcao_p = 'D') then
		select	min(a.dt_atualizacao)
		into STRICT	dt_retorno_w
		from	man_estagio_processo b, man_ordem_serv_estagio a
		where	a.nr_seq_ordem		= nr_seq_ordem_p
		and	a.nr_seq_estagio	= b.nr_sequencia
		and	b.IE_DESENV		= 'S';
		/*and	to_char(nr_seq_estagio) in ('4','731','732','131','261'); */

	elsif (ie_opcao_p = 'S') then
		select	min(a.dt_atualizacao)
		into STRICT	dt_retorno_w
		from	man_estagio_processo b, man_ordem_serv_estagio a
		where	a.nr_seq_ordem		= nr_seq_ordem_p
		and	a.nr_seq_estagio	= b.nr_sequencia
		and	b.ie_suporte		= 'S'
		and	b.ie_desenv		= 'N';
	elsif (ie_opcao_p = 'C') then
		select	min(dt_atualizacao)
		into STRICT	dt_retorno_w
		from	man_ordem_serv_estagio
		where	nr_seq_ordem	= nr_seq_ordem_p
		and	nr_seq_estagio in ('4','731','732','131','261');
	else
		select	min(dt_atualizacao)
		into STRICT	dt_retorno_w
		from	man_ordem_serv_estagio
		where	nr_seq_ordem	= nr_seq_ordem_p;
	end if;
end if;
return dt_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_estagio_os ( nr_seq_ordem_p bigint, ie_opcao_p text) FROM PUBLIC;

