-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_os_desenv_data ( nr_ordem_servico_p bigint, dt_referencia_p timestamp) RETURNS varchar AS $body$
DECLARE


ie_retorno_w			varchar(15);
nr_seq_estagio_w			bigint;



BEGIN

ie_retorno_w			:= 'N';

if (trunc(dt_referencia_p,'dd') <> trunc(clock_timestamp(),'dd')) then
	begin

/*
	select	nvl(max(ie_desenv),'N')
	into	ie_retorno_w
	from	man_estagio_processo b,
		man_ordem_servico a
	where	a.nr_sequencia		= nr_ordem_servico_p
	and	a.nr_seq_estagio		= b.nr_sequencia
	and	b.nr_sequencia		<> 51;

*/
	select	max(a.nr_seq_estagio)
	into STRICT	nr_seq_estagio_w
	from	man_ordem_serv_estagio a
	where	a.nr_seq_ordem	= nr_ordem_servico_p
	and	a.dt_atualizacao	= (	SELECT	max(y.dt_atualizacao)
					from	man_ordem_serv_estagio y
					where	y.nr_seq_ordem	= nr_ordem_servico_p
					and	y.dt_atualizacao <= dt_referencia_p
					and	y.nr_seq_estagio	<> 51);

	select	coalesce(max(ie_desenv),'N')
	into STRICT	ie_retorno_w
	from	man_estagio_processo b
	where	b.nr_sequencia	= nr_seq_estagio_w
	and	ie_aguarda_cliente = 'N';
	end;
else
	select	coalesce(max(ie_desenv),'N')
	into STRICT	ie_retorno_w
	from	man_estagio_processo b,
		man_ordem_servico a
	where	a.nr_sequencia		= nr_ordem_servico_p
	and	a.nr_seq_estagio		= b.nr_sequencia
	and	ie_aguarda_cliente = 'N'
	and	b.nr_sequencia		<> 51;
end if;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_os_desenv_data ( nr_ordem_servico_p bigint, dt_referencia_p timestamp) FROM PUBLIC;

