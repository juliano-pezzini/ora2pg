-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION far_obter_conv_cliente_dep (cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


nr_seq_participante_w	bigint;
cd_retorno_w		varchar(10);


BEGIN

select	coalesce(max(b.nr_seq_participante),0)
into STRICT	nr_seq_participante_w
from	far_contrato_conv a,
	far_contrato_part_dep b
where	a.nr_sequencia = b.nr_seq_contrato
and	trunc(clock_timestamp()) between a.dt_inicio_vigencia and a.dt_final_vigencia
and	b.cd_pessoa_fisica = cd_pessoa_fisica_p;

if (nr_seq_participante_w > 0) then
	begin

	select	cd_pessoa_fisica
	into STRICT	cd_retorno_w
	from	far_contrato_partic
	where	nr_sequencia = nr_seq_participante_w;

	end;
end if;

return	cd_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION far_obter_conv_cliente_dep (cd_pessoa_fisica_p text) FROM PUBLIC;
