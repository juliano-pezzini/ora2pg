-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dt_ultimo_sinal_vital (nr_atendimento_p bigint) RETURNS timestamp AS $body$
DECLARE


vl_retorno_w		timestamp;


BEGIN

if (nr_atendimento_p > 0) then
	begin

		select	max(dt_sinal_vital)
		into STRICT	vl_retorno_w
		from	atendimento_sinal_vital
		where	nr_sequencia = (SELECT	coalesce(max(nr_sequencia),-1)
					from	atendimento_sinal_vital
					where	nr_atendimento	= nr_atendimento_p
					and	ie_situacao = 'A'
					and	coalesce(IE_RN,'N')	= 'N');
	end;
end if;

return vl_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dt_ultimo_sinal_vital (nr_atendimento_p bigint) FROM PUBLIC;
