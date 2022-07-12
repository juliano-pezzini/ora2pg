-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_servico_liberado ( nr_atendimento_p bigint, nr_seq_servico_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1);
nr_seq_regra_atend_w	bigint;


BEGIN
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nr_seq_servico_p IS NOT NULL AND nr_seq_servico_p::text <> '') then

	select	max(coalesce(nr_seq_regra_acomp,0))
	into STRICT	nr_seq_regra_atend_w
	from	atend_categoria_convenio
	where	nr_atendimento = nr_atendimento_p
	and	nr_seq_interno = OBTER_ATECACO_ATENDIMENTO(nr_atendimento_p);

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_retorno_w
	from	nut_regra_cons_acomp_item
	where	nr_seq_regra_acomp = nr_seq_regra_atend_w
	and	nr_seq_servico = nr_seq_servico_p;

end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_servico_liberado ( nr_atendimento_p bigint, nr_seq_servico_p bigint) FROM PUBLIC;
