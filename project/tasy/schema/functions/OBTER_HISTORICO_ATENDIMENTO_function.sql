-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_historico_atendimento ( nr_atendimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(100);


BEGIN

if (ie_opcao_p = 'C') then
	select	max(nr_seq_tipo_historico)
	into STRICT	ds_retorno_w
	from	atendimento_hist_paciente
	where	nr_atendimento = nr_atendimento_p;
elsif (ie_opcao_p = 'D') then
	select	max(b.ds_tipo_historico)
	into STRICT	ds_retorno_w
	from	atendimento_hist_paciente a,
		tipo_historico_atendimento b
	where	nr_atendimento = nr_atendimento_p
	and	b.nr_sequencia = a.nr_seq_tipo_historico;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_historico_atendimento ( nr_atendimento_p bigint, ie_opcao_p text) FROM PUBLIC;
