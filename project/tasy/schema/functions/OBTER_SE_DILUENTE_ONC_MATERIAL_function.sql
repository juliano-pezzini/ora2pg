-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_diluente_onc_material ( nr_seq_paciente_p bigint, nr_seq_material_p bigint, nr_seq_interno_p bigint) RETURNS varchar AS $body$
DECLARE


ie_via_aplicacao_w		varchar(5);
cd_setor_atendimento_w	integer;
nr_seq_agrupamento_w	bigint;
ds_retorno_w			varchar(1) := 'S';


BEGIN

select	max(ie_via_aplicacao)
into STRICT	ie_via_aplicacao_w
from	paciente_protocolo_medic
where	nr_seq_paciente = nr_seq_paciente_p
and		nr_seq_material = nr_seq_material_p;

select	max(cd_setor_atendimento)
into STRICT	cd_setor_atendimento_w
from	paciente_setor
where	nr_seq_paciente = nr_seq_paciente_p;

if (ie_via_aplicacao_w IS NOT NULL AND ie_via_aplicacao_w::text <> '') then

	select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ds_retorno_w
	from	material_diluicao
	where	nr_seq_interno = nr_seq_interno_p
	and (ie_via_aplicacao = ie_via_aplicacao_w or coalesce(ie_via_aplicacao::text, '') = '')
	and		ie_reconstituicao = 'N';

end if;

if (ds_retorno_w = 'S') and (cd_setor_atendimento_w IS NOT NULL AND cd_setor_atendimento_w::text <> '') then

	select	obter_agrupamento_setor(cd_setor_atendimento_w)
	into STRICT	nr_seq_agrupamento_w
	;

	select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ds_retorno_w
	from	material_diluicao
	where	nr_seq_interno = nr_seq_interno_p
	and (cd_setor_atendimento = cd_setor_atendimento_w or coalesce(cd_setor_atendimento::text, '') = '');

	if (ds_retorno_w = 'S') and (nr_seq_agrupamento_w IS NOT NULL AND nr_seq_agrupamento_w::text <> '') then

		select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ds_retorno_w
		from	material_diluicao
		where	nr_seq_interno = nr_seq_interno_p
		and (nr_seq_agrupamento = nr_seq_agrupamento_w or coalesce(nr_seq_agrupamento::text, '') = '');

	end if;

end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_diluente_onc_material ( nr_seq_paciente_p bigint, nr_seq_material_p bigint, nr_seq_interno_p bigint) FROM PUBLIC;
