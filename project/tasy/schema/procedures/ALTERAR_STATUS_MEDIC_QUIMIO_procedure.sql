-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_status_medic_quimio ( nr_seq_atendimento_p bigint, nr_seq_p bigint, nm_usuario_p text, ie_opcao_p text, ie_tipo_seq_p text, cd_estabelecimento_p bigint, dt_administracao_p timestamp default null, dt_fim_adm_p timestamp default null) AS $body$
DECLARE


ds_campo_seq_w			varchar(20);
qt_item_adm_w			bigint;
ie_consiste_seq_medic_w		varchar(1);
ie_consiste_sinal_vital 	varchar(1);
nr_atendimento_w		bigint;
ie_inserir_novo_item_adm_w 	varchar(1);
qt_mat_itens_w 			bigint;
ie_utiliza_data_adm_w		varchar(1);
ie_inserir_item_adm_w		varchar(1);
nr_seq_material_w		bigint;
nr_seq_ordem_w          can_ordem_prod.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	nr_seq_material
	from 	paciente_atend_medic
	where	nr_seq_atendimento	=	nr_seq_atendimento_p
	and	nr_agrupamento		=	nr_seq_p;

BEGIN

ie_inserir_novo_item_adm_w := obter_param_usuario(3130, 274, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_inserir_novo_item_adm_w);
ie_inserir_item_adm_w := obter_param_usuario(3130, 47, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_inserir_item_adm_w);
ie_utiliza_data_adm_w := obter_param_usuario(3130, 349, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_utiliza_data_adm_w);

select	coalesce(max(Obter_Valor_Param_Usuario(3130, 151, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p)), 'S')
	into STRICT	ie_consiste_sinal_vital
	;

	if (ie_consiste_sinal_vital = 'S') then /*Realizado a troca do local da consistencia pelo fato de caso o parametro [61] da quimioterapia estar habilitado o sistema nao realizava a consistencia*/
		select	max(nr_atendimento)
		into STRICT 	nr_atendimento_w
		from	paciente_atendimento
		where	nr_seq_atendimento = nr_seq_atendimento_p;

		select coalesce(max('S'),'N')
		into STRICT   ie_consiste_sinal_vital
		from   atendimento_sinal_vital
		where  nr_atendimento = nr_atendimento_w;

		if (ie_consiste_sinal_vital = 'N') and (ie_opcao_p = 'A') then
			CALL Wheb_mensagem_pck.Exibir_mensagem_abort(201560);
		end if;
	end  if;

if (ie_tipo_seq_p = 'A') then  -- Agrupador
	select	coalesce(max(Obter_Valor_Param_Usuario(3130, 125, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p)), 'S')
	into STRICT	ie_consiste_seq_medic_w
	;

	if (ie_consiste_seq_medic_w = 'S') and (ie_opcao_p = 'A') then

		select 	count(*)
		into STRICT	qt_item_adm_w
		from	paciente_atend_medic
		where	nr_seq_atendimento		=	nr_seq_atendimento_p
		and	nr_agrupamento			<	nr_seq_p
		and	coalesce(nr_seq_diluicao::text, '') = ''
		and	ie_administracao		not in ('A');

		if (qt_item_adm_w > 0) then
		CALL Wheb_mensagem_pck.Exibir_mensagem_abort(201559);
		end if;		
	end if;

	update		paciente_atend_medic
	set		ie_administracao	=	ie_opcao_p,
			nm_usuario		=	nm_usuario_p,
			dt_atualizacao		=	clock_timestamp()
	where		nr_seq_atendimento	=	nr_seq_atendimento_p
	and		nr_agrupamento		=	nr_seq_p;

elsif (ie_tipo_seq_p = 'S') then  -- Solucao
	update		paciente_atend_medic
	set		ie_administracao	=	ie_opcao_p,
			nm_usuario		=	nm_usuario_p,
			dt_atualizacao		=	clock_timestamp()
	where		nr_seq_atendimento	=	nr_seq_atendimento_p
	and		nr_seq_solucao		=	nr_seq_p;

elsif (ie_tipo_seq_p = 'M') then  -- Material	
	update	paciente_atend_medic
	set	ie_administracao	=	ie_opcao_p,
	--	nm_usuario		=	nm_usuario_p,
		dt_atualizacao		=	clock_timestamp()
	where	nr_seq_atendimento	=	nr_seq_atendimento_p
	and	nr_seq_material		=	nr_seq_p;

end if;

if (ie_tipo_seq_p = 'A') and (ie_inserir_item_adm_w = 'S') and (ie_opcao_p = 'A') and (ie_utiliza_data_adm_w = 'S') then
	open C01;
	loop
	fetch C01 into	
		nr_seq_material_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		select 	count(*)
		into STRICT	qt_mat_itens_w
		from 	paciente_atend_medic_adm
		where 	nr_seq_atendimento = nr_seq_atendimento_p
		and	nr_seq_material	= nr_seq_material_w;

		if (qt_mat_itens_w = 0) or (ie_inserir_novo_item_adm_w = 'S')then
			insert into paciente_atend_medic_adm(	
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_atendimento,
					nr_seq_material,
					dt_administracao,
					cd_profissional,
					ds_observacao,
					ie_status_adm,
					dt_fim_administracao)
				values (
					nextval('paciente_atend_medic_adm_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_atendimento_p,
					nr_seq_material_w,
					coalesce(dt_administracao_p,clock_timestamp()),
					obter_pessoa_fisica_usuario(nm_usuario_p,'C'),
					null,
					1,
					coalesce(dt_fim_adm_p,clock_timestamp()));
		end if;

		if (qt_mat_itens_w > 0) and (ie_inserir_novo_item_adm_w = 'N') then

		update 		paciente_atend_medic_adm
		set		dt_atualizacao		= clock_timestamp(),
				nm_usuario		= nm_usuario_p,
				dt_administracao	= clock_timestamp(),
				cd_profissional		= obter_pessoa_fisica_usuario(nm_usuario_p,'C'),
				ie_status_adm		= 1,
				dt_fim_administracao	= dt_fim_adm_p
		where 		nr_seq_atendimento	= nr_seq_atendimento_p
		and		nr_seq_material		= nr_seq_material_w;

		end if;
		end;
	end loop;
	close C01;
end if;

if (ie_tipo_seq_p = 'M') and (ie_inserir_item_adm_w = 'S') and (ie_opcao_p = 'A') then

	select 	count(*)
	into STRICT	qt_mat_itens_w
	from 	paciente_atend_medic_adm
	where 	nr_seq_atendimento = nr_seq_atendimento_p
	and	nr_seq_material	= nr_seq_p;

	if (qt_mat_itens_w = 0) or (ie_inserir_novo_item_adm_w = 'S')then
		insert into paciente_atend_medic_adm(	
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_atendimento,
				nr_seq_material,
				dt_administracao,
				cd_profissional,
				ds_observacao,
				ie_status_adm,
				dt_fim_administracao)
			values (
				nextval('paciente_atend_medic_adm_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_atendimento_p,
				nr_seq_p,
				coalesce(dt_administracao_p,clock_timestamp()),
				obter_pessoa_fisica_usuario(nm_usuario_p,'C'),
				null,
				1,
				coalesce(dt_fim_adm_p, clock_timestamp()));
	end if;

	if (qt_mat_itens_w > 0) and (ie_inserir_novo_item_adm_w = 'N') then

	update 		paciente_atend_medic_adm
	set		dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p,
			dt_administracao	= clock_timestamp(),
			--cd_profissional		= obter_pessoa_fisica_usuario(nm_usuario_p,'C'),
			ie_status_adm		= 1,
			dt_fim_administracao	= coalesce(dt_fim_adm_p, clock_timestamp())
	where 		nr_seq_atendimento	= nr_seq_atendimento_p
	and		nr_seq_material		= nr_seq_p;

	end if;

end if;

select 	max(a.nr_sequencia)
into STRICT    nr_seq_ordem_w
from    can_ordem_prod a,
        prescr_medica b,
        prescr_material c,
        prescr_mat_hor d,
        can_ordem_item_prescr e
where 	b.nr_seq_atend          = nr_seq_atendimento_p
and     c.nr_seq_material       = nr_seq_p
and   	a.nr_sequencia          = e.nr_seq_ordem
and   	b.nr_prescricao         = c.nr_prescricao
and   	c.nr_prescricao         = d.nr_prescricao
and   	c.nr_sequencia          = d.nr_seq_material
and     coalesce(c.nr_sequencia_diluicao::text, '') = ''
and     d.nr_sequencia          = e.nr_seq_mat_hor
and 	coalesce(a.dt_checagem::text, '') = ''
and     a.ie_cancelada 	        = 'N'
order by  a.nr_sequencia desc;

if (nr_seq_ordem_w > 0) then
    update  can_ordem_prod
    set     dt_checagem 	= clock_timestamp(),
            nm_usuario 	= nm_usuario_p,
            dt_atualizacao 	= clock_timestamp()
    where   nr_seq_atendimento 	= nr_seq_atendimento_p
    and     nr_sequencia  	= nr_seq_ordem_w;
end if;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_status_medic_quimio ( nr_seq_atendimento_p bigint, nr_seq_p bigint, nm_usuario_p text, ie_opcao_p text, ie_tipo_seq_p text, cd_estabelecimento_p bigint, dt_administracao_p timestamp default null, dt_fim_adm_p timestamp default null) FROM PUBLIC;
