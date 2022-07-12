-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_envia_ci_setor (nr_seq_regra_p bigint, cd_setor_p bigint) RETURNS varchar AS $body$
DECLARE


ie_enviar_w		varchar(1) := 'S';
cont_w			bigint;


BEGIN

select	count(*)
into STRICT	cont_w
from	rep_regra_ci_proced_setor
where	nr_seq_regra	= nr_seq_regra_p
and     (cd_setor_atendimento IS NOT NULL AND cd_setor_atendimento::text <> '');

if (cont_w > 0) then
	select	count(*)
	into STRICT	cont_w
	from	rep_regra_ci_proced_setor
	where	nr_seq_regra	= nr_seq_regra_p
	and	cd_setor_atendimento = cd_setor_p;

	if (cont_w = 0) then
		ie_enviar_w	:= 'N';
	end if;
end if;

return	ie_enviar_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_envia_ci_setor (nr_seq_regra_p bigint, cd_setor_p bigint) FROM PUBLIC;

