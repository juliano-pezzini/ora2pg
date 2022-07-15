-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desvincular_grupo_evol_alta ( nr_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_atendimento_w	bigint;
cd_pessoa_fisica_w	varchar(10);
nr_seq_grupo_w		bigint;
cd_pessoa_w		varchar(10);
C01 CURSOR FOR
	SELECT	a.nr_atendimento,
		a.cd_pessoa_fisica,
		b.nr_seq_grupo
	from	evolucao_paciente a,
		tipo_evolucao_pac_grupo b
	where	a.nr_atendimento = nr_atendimento_p
	and	b.cd_tipo_evolucao = a.ie_evolucao_clinica
	and	b.ie_desvincular_alta = 'S'
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	group by a.nr_atendimento, a.cd_pessoa_fisica, b.nr_seq_grupo
	
union all

	SELECT	null nr_atendimento,
		a.cd_pessoa_fisica,
		b.nr_seq_grupo
	from	evolucao_paciente a,
		tipo_evolucao_pac_grupo b
	where	coalesce(a.nr_atendimento::text, '') = ''
	and	a.cd_pessoa_fisica = cd_pessoa_w
	and	b.cd_tipo_evolucao = a.ie_evolucao_clinica
	and	b.ie_desvincular_alta = 'S'
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	group by a.cd_pessoa_fisica, b.nr_seq_grupo;


BEGIN

begin
	select	obter_pessoa_atendimento(nr_atendimento_p,'C')
	into STRICT	cd_pessoa_w
	;

exception
when others then
	cd_pessoa_w := '';
end;
if (coalesce(nr_atendimento_p,0) > 0) then
	open C01;
	loop
	fetch C01 into
		nr_atendimento_w,
		cd_pessoa_fisica_w,
		nr_seq_grupo_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then
			update	pac_grupo_atend
			set	dt_saida = clock_timestamp(),
				nm_usuario = nm_usuario_p
			where	nr_atendimento = nr_atendimento_w
			and	coalesce(dt_saida::text, '') = ''
			and	nr_seq_grupo = nr_seq_grupo_w;
		else
			update	pac_grupo_atend
			set	dt_saida = clock_timestamp(),
				nm_usuario = nm_usuario_p
			where	cd_pessoa_fisica = cd_pessoa_fisica_w
			and	coalesce(nr_atendimento::text, '') = ''
			and	coalesce(dt_saida::text, '') = ''
			and	nr_seq_grupo = nr_seq_grupo_w;
		end if;

		end;
	end loop;
	close C01;

	if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desvincular_grupo_evol_alta ( nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

