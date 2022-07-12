-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tip_medic_quimio (nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_medic_w		smallint;
ie_pre_medicacao_w 	varchar(1);

BEGIN

select	ie_pre_medicacao
into STRICT 	ie_pre_medicacao_w
from   	can_ordem_prod
where 	nr_sequencia = nr_sequencia_p;

if (ie_pre_medicacao_w = 'S') then
	nr_seq_medic_w := 1;
elsif (coalesce(ie_pre_medicacao_w,'N') = 'N') then
	nr_seq_medic_w := 2;
elsif (ie_pre_medicacao_w = 'P') then
	nr_seq_medic_w := 3;
end if;

return	nr_seq_medic_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tip_medic_quimio (nr_sequencia_p bigint) FROM PUBLIC;
