-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_gastos_rn ( cd_convenio_p bigint, nr_atendimento_p bigint, ie_trat_conta_rn_p text, nr_seq_atepacu_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1):= 'N';
qt_setor_w		bigint;
cd_setor_atendimento_w	bigint;
qt_total_w		bigint;
cd_estabelecimento_w	smallint;
nr_seq_atepacu_w	atend_paciente_unidade.nr_seq_interno%type;

C01 CURSOR FOR
	SELECT	cd_setor_atendimento,
				nr_seq_interno
	from	atend_paciente_unidade
	where	nr_atendimento = nr_atendimento_p
	order by cd_setor_atendimento;


BEGIN

ie_retorno_w:= 'N';

if (ie_trat_conta_rn_p = 'Mãe') then

	select 	coalesce(max(cd_estabelecimento),0)
	into STRICT	cd_estabelecimento_w
	from 	atendimento_paciente
	where 	nr_atendimento = nr_atendimento_p;

	select 	count(1)
	into STRICT	qt_setor_w
	from 	conv_regra_gastos_rn
	where 	cd_convenio = cd_convenio_p
	and 	coalesce(cd_estabelecimento, cd_estabelecimento_w) = cd_estabelecimento_w
	and 	ie_situacao = 'A'  LIMIT 1;

	if (qt_setor_w > 0) then

		qt_total_w := 0;

		open C01;
		loop
		fetch C01 into
			cd_setor_atendimento_w,
			nr_seq_atepacu_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin

			select 	count(1)
			into STRICT	qt_setor_w
			from 	conv_regra_gastos_rn
			where 	cd_convenio = cd_convenio_p
			and 	ie_situacao = 'A'
			and 	coalesce(cd_estabelecimento, cd_estabelecimento_w) = cd_estabelecimento_w
			and 	cd_setor_atendimento = cd_setor_atendimento_w
			and	(((coalesce(ie_setor_atual,'N') = 'S') and (nr_seq_atepacu_w = nr_seq_atepacu_p)) or (coalesce(ie_setor_atual,'N') = 'N'))  LIMIT 1;

			qt_total_w := qt_total_w + qt_setor_w;

			end;
		end loop;
		close C01;

		if (qt_total_w > 0) then
			ie_retorno_w := 'S';
		end if;

	end if;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_gastos_rn ( cd_convenio_p bigint, nr_atendimento_p bigint, ie_trat_conta_rn_p text, nr_seq_atepacu_p bigint) FROM PUBLIC;

