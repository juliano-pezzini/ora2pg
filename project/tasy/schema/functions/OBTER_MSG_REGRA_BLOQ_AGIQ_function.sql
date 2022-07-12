-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_msg_regra_bloq_agiq (nr_seq_estrutura_p bigint, nr_seq_resposta_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	ageint_quest_regra_bloq.ds_alerta%type;

BEGIN

select	max(a.ds_alerta)
into STRICT	ds_retorno_w
from	ageint_quest_regra_bloq a
where	a.nr_seq_estrutura = nr_seq_estrutura_p
and	a.nr_seq_resposta = nr_seq_resposta_p
and	coalesce(a.ie_situacao,'A') = 'A';

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_msg_regra_bloq_agiq (nr_seq_estrutura_p bigint, nr_seq_resposta_p bigint) FROM PUBLIC;
