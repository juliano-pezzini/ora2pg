-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_benef_rescindido ( nr_seq_conta_p bigint, nr_seq_segurado_p bigint, dt_referencia_p timestamp ) RETURNS varchar AS $body$
DECLARE


dt_rescisao_w			timestamp;
dt_limite_utilizacao_w		timestamp;
dt_emissao_w			timestamp;
ie_retorno_w			varchar(1) := 'N';


BEGIN

if (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then

	select	max(dt_rescisao),
		max(fim_dia(dt_limite_utilizacao))
	into STRICT	dt_rescisao_w,
		dt_limite_utilizacao_w
	from	pls_segurado
	where	nr_sequencia	= nr_seq_segurado_p;

	if (dt_rescisao_w IS NOT NULL AND dt_rescisao_w::text <> '') and (trunc(dt_referencia_p) > dt_limite_utilizacao_w) then
		ie_retorno_w := 'S';
	end if;

end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_benef_rescindido ( nr_seq_conta_p bigint, nr_seq_segurado_p bigint, dt_referencia_p timestamp ) FROM PUBLIC;

