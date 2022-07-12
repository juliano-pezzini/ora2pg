-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_se_usuario_servico (nr_seq_servico_p bigint, nm_usuario_p text, cd_setor_atendimento_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ie_usuario_servico_w	varchar(5) := 'N';
cd_cargo_w		bigint;
cd_setor_atendimento_w	integer;
nr_seq_grupo_cargo_w	bigint;
cd_cargo_usuario_w	bigint;
cd_setor_usuario_w	integer;
qt_cargo_grupo_w	bigint := 0;
qt_existe_regra_w	bigint := 0;
qt_existe_regra_solic_w bigint := 0;

/*
ie_opcao_p:
S - Regra de solicitante
E - Regra de executor
*/
C01 CURSOR FOR
	SELECT	a.cd_cargo,
		a.cd_setor_atendimento,
		a.nr_seq_grupo_cargo
	from	servico_setor_atend_exec a
	where	a.nr_seq_servico = nr_seq_servico_p
	and	ie_opcao_p = 'E'
	
union

	SELECT	a.cd_cargo,
		a.cd_setor_atendimento,
		a.nr_seq_grupo_cargo
	from	servico_setor_atend_solic a
	where	a.nr_seq_servico = nr_seq_servico_p
	and	ie_opcao_p = 'S';


BEGIN
select	count(*)
into STRICT	qt_existe_regra_w
from	servico_setor_atend_exec
where	nr_seq_servico = nr_seq_servico_p
and	ie_opcao_p = 'E';

select	count(*)
into STRICT	qt_existe_regra_solic_w
from	servico_setor_atend_solic
where	nr_seq_servico = nr_seq_servico_p
and	ie_opcao_p = 'S';


if (qt_existe_regra_w > 0)or (qt_existe_regra_solic_w > 0) then
	begin
	open C01;
	loop
	fetch C01 into
		cd_cargo_w,
		cd_setor_atendimento_w,
		nr_seq_grupo_cargo_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		select	max(a.cd_cargo),
			max(b.cd_setor_atendimento)
		into STRICT	cd_cargo_usuario_w,
			cd_setor_usuario_w
		from	pessoa_fisica a,
			usuario b
		where	a.cd_pessoa_fisica = b.cd_pessoa_fisica
		and	b.nm_usuario = nm_usuario_p;

		select	count(*)
		into STRICT	qt_cargo_grupo_w
		from	qua_grupo_cargo a,
			qua_cargo_agrup b
		where	a.nr_sequencia = b.nr_seq_agrup
		and	a.nr_sequencia = nr_seq_grupo_cargo_w
		and	b.cd_cargo = cd_cargo_usuario_w;

		if (cd_cargo_usuario_w = cd_cargo_w) then
			ie_usuario_servico_w := 'S';
		elsif (cd_setor_atendimento_w = cd_setor_usuario_w) then
			ie_usuario_servico_w := 'S';
		elsif (qt_cargo_grupo_w > 0) then
			ie_usuario_servico_w := 'S';
		end if;

		end;
	end loop;
	close C01;
	end;
else
	ie_usuario_servico_w := 'S';
end if;



return	ie_usuario_servico_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_se_usuario_servico (nr_seq_servico_p bigint, nm_usuario_p text, cd_setor_atendimento_p text, ie_opcao_p text) FROM PUBLIC;

