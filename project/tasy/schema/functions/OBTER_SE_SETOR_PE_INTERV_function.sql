-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_setor_pe_interv ( cd_setor_atendimento_p bigint, nr_seq_regra_p bigint) RETURNS varchar AS $body$
DECLARE


ie_permite_w    		varchar(1) := 'S';
cd_setor_atendimento_w	bigint 	:= coalesce(cd_setor_atendimento_p,0);

c01 CURSOR FOR
SELECT	ie_permite
from	pe_interv_protocolo_regra
where	nr_seq_regra		= nr_seq_regra_p
and (coalesce(cd_setor_atendimento,cd_setor_atendimento_w) = cd_setor_atendimento_w)
order by cd_setor_atendimento desc;


BEGIN

	open c01;
	loop
	fetch c01 into
			ie_permite_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	end loop;
	close c01;

	return	ie_permite_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_setor_pe_interv ( cd_setor_atendimento_p bigint, nr_seq_regra_p bigint) FROM PUBLIC;

