-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_evento_permite_obs (nr_seq_motivo_p bigint) RETURNS varchar AS $body$
DECLARE


ie_observacao_w	varchar(1) := 'P';


BEGIN
if (nr_seq_motivo_p IS NOT NULL AND nr_seq_motivo_p::text <> '') then
	select	coalesce(max(ie_observacao),'P')
	into STRICT	ie_observacao_w
	from	adep_motivo_interrupcao
	where	nr_sequencia = nr_seq_motivo_p;
end if;

return ie_observacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_evento_permite_obs (nr_seq_motivo_p bigint) FROM PUBLIC;
