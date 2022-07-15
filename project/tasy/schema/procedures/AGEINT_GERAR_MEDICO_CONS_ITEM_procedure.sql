-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_gerar_medico_cons_item ( nr_seq_ageint_p bigint, nr_seq_item_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_item_w		bigint;
cd_especialidade_w	integer;
qt_idade_w			smallint;
cd_paciente_w		varchar(10);
dt_nascimento_w		timestamp;
ie_sexo_w			varchar(1);
cd_medico_item_w	varchar(10);
cd_estabelecimento_w	integer;
ie_estab_usuario_w	varchar(1);
cd_estab_agenda_w	integer;
ie_perm_agenda_w	varchar(1)	:= 'S';
qt_estab_user_w		bigint;
nr_Seq_grupo_selec_w	bigint;
ie_consiste_regra_lib_w	varchar(1);
nr_seq_area_selec_w		bigint;
nr_seq_area_atuacao_w	agenda_integrada_item.nr_seq_area_atuacao%type;
nr_seq_area_atuacao_ww	medico_area_atuacao.nr_seq_area_atuacao%type;
nr_seq_atuacao_agenda_w	agenda.nr_seq_area_atuacao%type;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
			a.cd_especialidade,
			a.nr_seq_grupo_selec,
			coalesce(a.nr_seq_area_atuacao,0)
	from	agenda_integrada_item a
	where	a.nr_seq_agenda_int	= nr_seq_Ageint_p
	and		a.nr_sequencia		= coalesce(nr_seq_item_p, a.nr_sequencia)
	and		a.ie_tipo_agendamento	= 'C'
	and		not exists (SELECT 1 from ageint_medico_item b where b.nr_seq_item = a.nr_sequencia)
	order by 1;

C02 CURSOR FOR
	SELECT	coalesce(am.cd_medico, a.cd_pessoa_fisica),
			a.cd_estabelecimento,
			coalesce(a.nr_seq_area_atuacao,0)
	FROM agenda a
LEFT OUTER JOIN agenda_medico am ON (a.cd_agenda = am.cd_agenda)
WHERE coalesce(a.ie_agenda_integrada,'N')	= 'S' and coalesce(am.ie_situacao, 'A')		= 'A' and a.ie_situacao			= 'A' and (a.cd_especialidade		= cd_especialidade_w or exists (SELECT 1
                                                     from AGENDA_CONS_ESPECIALIDADE acp
                                                    where acp.cd_especialidade =  cd_especialidade_w
                                                      and acp.cd_agenda = a.cd_agenda)) and a.cd_tipo_Agenda = 3 and (((ie_consiste_regra_lib_w = 'S') and (	exists (select	1
					from 	agenda_cons_regra_proc x
					where 	x.nr_seq_grupo_ageint = nr_Seq_grupo_selec_w
					and 	x.cd_agenda = a.cd_agenda
					)
		or	not	exists (select	1
					from 	agenda_cons_regra_proc y
					where 	(y.nr_seq_grupo_ageint IS NOT NULL AND y.nr_seq_grupo_ageint::text <> '')
					and 	y.cd_agenda = a.cd_agenda
					)
			))
		or (ie_consiste_regra_lib_w = 'N')
		or (coalesce(nr_seq_grupo_selec_w::text, '') = '')
			) and ((qt_idade_w	>= coalesce(qt_idade_min,0)
	and		qt_idade_w	<= coalesce(qt_idade_max,999))
	or		qt_idade_w = 0) and (((ie_consiste_regra_lib_w = 'S') and (	exists (select	1
					from 	agenda_cons_regra_proc x
					where 	x.nr_seq_area_ageint = nr_seq_area_selec_w
					and 	x.cd_agenda = a.cd_agenda
					)
		or	not	exists (select	1
					from 	agenda_cons_regra_proc y
					where 	(y.nr_seq_area_ageint IS NOT NULL AND y.nr_seq_area_ageint::text <> '')
					and 	y.cd_agenda = a.cd_agenda
					)
			))
		or (ie_consiste_regra_lib_w = 'N')
		or (coalesce(nr_seq_area_selec_w::text, '') = '')
			);

/*Consistir area de atuacao:
- Se informada no cadastro da agenda, consiste somente a area do cadastro;
- Se nao informado no cadastro, consiste a area de atuacao do cadastro do medico*/
			
C03 CURSOR FOR
	SELECT	a.nr_seq_area_atuacao
	from	medico_area_atuacao a
	where	a.cd_pessoa_fisica = cd_medico_item_w
	and		coalesce(nr_seq_area_atuacao_w,0) <> 0
	and		coalesce(nr_seq_area_atuacao_w,0) = a.nr_seq_area_atuacao
	and		coalesce(nr_seq_atuacao_agenda_w,0) = 0
	and		(a.nr_seq_area_atuacao IS NOT NULL AND a.nr_seq_area_atuacao::text <> '')
	order by 1;			


BEGIN

ie_estab_usuario_w	:= coalesce(Obter_Valor_Param_Usuario(869, 1, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p), 'S');
ie_consiste_regra_lib_w	:= coalesce(Obter_Valor_Param_Usuario(869, 164, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p), 'N');

CALL ageint_excluir_medico_item(nr_seq_ageint_p, nm_usuario_p);

/*update	agenda_integrada_item
set	cd_medico	= null
where	nr_sequencia	= nr_seq_item_p;*/
select	cd_pessoa_fisica,
		cd_estabelecimento
into STRICT	cd_paciente_w,
		cd_estabelecimento_w
from	agenda_integrada
where	nr_sequencia	= nr_seq_Ageint_p;

if (cd_paciente_w IS NOT NULL AND cd_paciente_w::text <> '') then
	select	max(ie_Sexo),
			max(dt_nascimento)
	into STRICT	ie_Sexo_w,
			dt_nascimento_w
	from	pessoa_fisica
	where	cd_pessoa_fisica	= cd_paciente_w;
end if;

qt_idade_w	:= obter_idade(dt_nascimento_w, clock_timestamp(), 'A');


open C01;
loop
fetch C01 into
	nr_seq_item_w,
	cd_especialidade_w,
	nr_Seq_grupo_selec_w,
	nr_seq_area_atuacao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	if (nr_Seq_grupo_selec_w IS NOT NULL AND nr_Seq_grupo_selec_w::text <> '')then
		select	max(x.nr_seq_area)
		into STRICT	nr_seq_area_selec_w
		from	agenda_int_grupo x
		where	x.nr_sequencia	= nr_Seq_grupo_selec_w;
	else
		nr_seq_area_selec_w	:= null;
	end if;	

	open C02;
	loop
	fetch C02 into
		cd_medico_item_w,
		cd_estab_agenda_w,
		nr_seq_atuacao_agenda_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		ie_perm_agenda_w	:= 'S';
		if (ie_estab_usuario_w	= 'S') or (ie_estab_usuario_w	= 'C') then
			if (cd_estab_agenda_w	<> cd_estabelecimento_p) then
				ie_perm_agenda_w	:= 'N';
			end if;
		elsif (ie_estab_usuario_w	= 'N') then
			select	count(*)
			into STRICT	qt_estab_user_w
			from	usuario_estabelecimento
			where	nm_usuario_param	= nm_usuario_p
			and	cd_estabelecimento	= cd_estab_agenda_w;
			if (qt_estab_user_w	= 0) then
				ie_perm_agenda_w	:= 'N';
			end if;
		end if;
		
		/* 	- Consistir a area de atuacao do cadastro da agenda
			- Consistir a area de atuacao dos profissionais liberados para a agenda(Cadastro Medico > Relacionamentos > Area atuacao)
		*/
		if (nr_seq_atuacao_agenda_w <> 0) and (nr_seq_area_atuacao_w <> 0)then
			if (nr_seq_atuacao_agenda_w <> nr_seq_area_atuacao_w)then
				ie_perm_agenda_w := 'N';
			end if;
		else			
			open C03;
			loop
			fetch C03 into	
				nr_seq_area_atuacao_ww;
			EXIT WHEN NOT FOUND; /* apply on C03 */
				begin				
				
				if (nr_seq_area_atuacao_ww IS NOT NULL AND nr_seq_area_atuacao_ww::text <> '') and (nr_seq_area_atuacao_ww = nr_seq_area_atuacao_w) then
					ie_perm_agenda_w := 'S';
				else
					ie_perm_agenda_w := 'N';
				end if;				
				
				/*insert into log_agenda (	
					ds_dados)
				values(	cd_medico_item_w || ' - ' || nr_seq_area_atuacao_ww || ' - ' || nr_seq_area_atuacao_w || ' - ' || ie_perm_agenda_w);
				commit;
				*/
				end;
			end loop;
			close C03;
		end if;		
		
		if (ie_perm_agenda_w	= 'S') then
			insert into ageint_medico_item(nr_sequencia,
				nr_seq_item,
				cd_pessoa_fisica,
				nm_usuario,
				dt_Atualizacao,
				nm_usuario_nrec,
				dt_Atualizacao_nrec)
			values (nextval('ageint_medico_item_seq'),
				nr_seq_item_w,
				cd_medico_item_w,
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp());
		end if;

		end;
	end loop;
	close C02;

	end;
end loop;
close C01;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_gerar_medico_cons_item ( nr_seq_ageint_p bigint, nr_seq_item_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

