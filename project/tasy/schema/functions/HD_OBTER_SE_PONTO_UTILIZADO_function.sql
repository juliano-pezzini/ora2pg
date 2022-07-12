-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_se_ponto_utilizado ( nr_sequencia_p bigint, nr_seq_ponto_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(1);
ie_valida_w	varchar(1);

BEGIN

if (nr_seq_ponto_p IS NOT NULL AND nr_seq_ponto_p::text <> '') then
	select	max(ie_local_ponto)
	into STRICT	ie_valida_w
	from	hd_ponto_acesso a
	where	a.nr_sequencia = nr_seq_ponto_p;

end if;



if (coalesce(ie_valida_w,'N') not in ('R','M')) then
	select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_retorno_w
	from	hd_maquina_dialise
	where	nr_seq_ponto = nr_seq_ponto_p
	and	cd_estabelecimento = cd_estabelecimento_p
	and	(nr_seq_ponto IS NOT NULL AND nr_seq_ponto::text <> '')
	and	nr_sequencia <> nr_sequencia_p;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_se_ponto_utilizado ( nr_sequencia_p bigint, nr_seq_ponto_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
