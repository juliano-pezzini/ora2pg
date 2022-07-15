-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_worklist_regulacao ( nr_sequencia_p bigint, ie_tipo_p text ) AS $body$
DECLARE

/*Descrição				ie_tipo_p
Encaminhamento			E
Solicitação				SE
Transferencia de cuidado		TC
*/
										
										
nr_seq_encaminhamento_w		bigint;
nr_seq_grupo_regulacao_w	bigint;
nr_seq_solic_transf_w		bigint;
nr_seq_requisicao_item_w	bigint;
cd_pessoa_fisica_w			varchar(10);
nr_atendimento_w			bigint;
dt_previsao_w				timestamp;
nr_seq_work_item_w			bigint;
nr_seq_parecer_ori_w		bigint;
cd_evolucao_w				bigint;
nm_usuario_w				varchar(15);
cd_estabelecimento_w		smallint;


nr_seq_pedido_w				bigint;
nr_seq_pedido_item_w		bigint;
nr_seq_cpoe_w				bigint;
nr_seq_cpoe_proc_w			bigint;

cd_medico_dest_w			varchar(10);
cd_especialidade_w			integer;

C01 CURSOR FOR
	SELECT nr_seq_work_item
	from   regra_regulacao a,
		   grupo_regulacao b,
		   grupo_regulacao_lib c
	where  a.ie_tipo_parecer = 'C'
	and    coalesce(a.cd_medico_dest,coalesce(cd_medico_dest_w,'0')) = coalesce(cd_medico_dest_w,'0')
	and    coalesce(a.cd_especialidade,coalesce(cd_especialidade_w,0)) = coalesce(cd_especialidade_w,0)
	and    a.nr_seq_grupo_regulacao = b.nr_sequencia
	and    coalesce(b.ie_situacao,'A') = 'A'
	and    coalesce(c.ie_situacao,'A') = 'A'
	and    c.nr_seq_grupo_regulacao = b.nr_sequencia
	and    coalesce(c.cd_estabelecimento,cd_estabelecimento_w) = cd_estabelecimento_w
	and    coalesce(c.cd_perfil,obter_perfil_ativo) = obter_perfil_ativo
	and    coalesce(c.nm_usuario_exclusivo,nm_usuario_w) = nm_usuario_w
	order by nr_seq_work_item desc;


BEGIN

if ( nr_sequencia_p > 0) then

	Select 	wheb_usuario_pck.get_nm_usuario,
			wheb_usuario_pck.get_cd_estabelecimento
	into STRICT	nm_usuario_w,
			cd_estabelecimento_w
	;
	
	dt_previsao_w := clock_timestamp() + interval '30 days';

	if ( ie_tipo_p = 'EN' ) then
	
		select	max(nr_seq_encaminhamento),
				max(nr_seq_grupo_regulacao),
				max(NR_SEQ_PARECER_ORI)
		into STRICT	nr_seq_encaminhamento_w,
				nr_seq_grupo_regulacao_w,
				nr_seq_parecer_ori_w
		from	regulacao_atend
		where	nr_sequencia = nr_sequencia_p;
		
		if ( nr_seq_encaminhamento_w > 0 ) then	

			Select 	max(nr_atendimento),
					max(cd_pessoa_fisica),
					max(dt_previsao),
					max(cd_medico_dest),
					max(cd_especialidade)
			into STRICT	nr_atendimento_w,
					cd_pessoa_fisica_w,
					dt_previsao_w,
					cd_medico_dest_w,
					cd_especialidade_w
			from	atend_encaminhamento
			where	nr_sequencia = nr_seq_encaminhamento_w;
			
			 		
		end if;
		
	elsif ( ie_tipo_p = 'EV' ) then
	
		select		max(cd_evolucao_ori),
					max(nr_seq_grupo_regulacao),
					max(nr_seq_parecer_ori)
			into STRICT	cd_evolucao_w,
					nr_seq_grupo_regulacao_w,
					nr_seq_parecer_ori_w
			from	regulacao_atend
			where	nr_sequencia = nr_sequencia_p;
			
			if ( cd_evolucao_w > 0 ) then	

				SELECT	MAX(a.nr_atendimento),
						MAX(a.cd_pessoa_fisica)
				INTO STRICT	nr_atendimento_w,
						cd_pessoa_fisica_w
				FROM	evolucao_paciente a
				WHERE	a.cd_evolucao = cd_evolucao_w;
			
			end if;
		
	elsif ( ie_tipo_p = 'SE' ) then
	
		select	max(nr_seq_pedido),
				max(nr_seq_pedido_item),
				max(nr_seq_grupo_regulacao),
				max(nr_seq_parecer_ori)
		into STRICT	nr_seq_pedido_w,
				nr_seq_pedido_item_w,
				nr_seq_grupo_regulacao_w,
				nr_seq_parecer_ori_w
		from	regulacao_atend
		where	nr_sequencia = nr_sequencia_p;
		
		if ( nr_seq_pedido_w > 0 ) then	

			Select 	max(nr_atendimento),
					max(cd_pessoa_fisica)
			into STRICT	nr_atendimento_w,
					cd_pessoa_fisica_w
			from	pedido_exame_externo
			where	nr_sequencia = nr_seq_pedido_w;
		
		end if;
		
	elsif ( ie_tipo_p = 'TC' ) then
	
		select	max(nr_seq_solic_transf),
				max(nr_seq_grupo_regulacao),
				max(nr_seq_parecer_ori)
		into STRICT	nr_seq_solic_transf_w,
				nr_seq_grupo_regulacao_w,
				nr_seq_parecer_ori_w
		from	regulacao_atend
		where	nr_sequencia = nr_sequencia_p;
		
		if ( nr_seq_solic_transf_w > 0 ) then	

			select	max(obter_pessoa_atendimento(a.nr_atendimento,'C')),
					max(a.nr_atendimento),
					max(a.dt_geracao_vaga)
			into STRICT	cd_pessoa_fisica_w,
					nr_atendimento_w,
					dt_previsao_w
			from	solic_transf_externa a
			where	a.nr_sequencia = nr_seq_solic_transf_w;	
		
		end if;
		
	elsif ( ie_tipo_p = 'EQ' ) then
	
		select	max(nr_seq_requisicao_item),
				max(nr_seq_grupo_regulacao),
				max(nr_seq_parecer_ori)
		into STRICT	nr_seq_requisicao_item_w,
				nr_seq_grupo_regulacao_w,
				nr_seq_parecer_ori_w
		from	regulacao_atend
		where	nr_sequencia = nr_sequencia_p;
		
		if ( nr_seq_requisicao_item_w > 0 ) then	

			select	max(a.cd_pessoa_solicitante),
					max(a.nr_atendimento)
			into STRICT	cd_pessoa_fisica_w,
					nr_atendimento_w
			from	requisicao_item a
			where	a.nr_sequencia = nr_seq_requisicao_item_w;	
		
		end if;
		
	elsif ( ie_tipo_p = 'ME' ) then
	
		select	max(nr_seq_cpoe),
				max(nr_seq_grupo_regulacao),
				max(nr_seq_parecer_ori)
		into STRICT	nr_seq_cpoe_w,
				nr_seq_grupo_regulacao_w,
				nr_seq_parecer_ori_w
		from	regulacao_atend
		where	nr_sequencia = nr_sequencia_p;
		
		if ( nr_seq_cpoe_w > 0 ) then	

			select	max(a.cd_pessoa_fisica),
					max(a.nr_atendimento)
			into STRICT	cd_pessoa_fisica_w,
					nr_atendimento_w
			from	cpoe_material a
			where	a.nr_sequencia = nr_seq_cpoe_w;	
		
		end if;
		
	elsif ( ie_tipo_p = 'CPOE' ) then
	
		select	max(nr_seq_cpoe_proc),
				max(nr_seq_grupo_regulacao),
				max(nr_seq_parecer_ori)
		into STRICT	nr_seq_cpoe_proc_w,
				nr_seq_grupo_regulacao_w,
				nr_seq_parecer_ori_w
		from	regulacao_atend
		where	nr_sequencia = nr_sequencia_p;
		
		if ( nr_seq_cpoe_proc_w > 0 ) then	

			select	max(a.cd_pessoa_fisica),
					max(a.nr_atendimento)
			into STRICT	cd_pessoa_fisica_w,
					nr_atendimento_w
			from	cpoe_procedimento a
			where	a.nr_sequencia = nr_seq_cpoe_proc_w;	
		
		end if;
	
		
	end if;
		

		
		
	open C01;
	loop
	fetch C01 into	
		nr_seq_work_item_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		
		insert into wl_worklist( 	nr_sequencia,
									nr_atendimento,
									cd_pessoa_fisica,
									dt_atualizacao,
									dt_Atualizacao_nrec,
									nm_usuario,
									nm_usuario_nrec,
									nr_parecer,
									nr_seq_regulacao_atend,
									nr_seq_grupo_regulacao,
									nr_seq_item,
									dt_inicial,
									dt_final_previsto,
									ie_regulacao)
						values ( 	nextval('wl_worklist_seq'),
									nr_atendimento_w,
									cd_pessoa_fisica_w,
									clock_timestamp(),
									clock_timestamp(),
									nm_usuario_w,
									nm_usuario_w,
									nr_seq_parecer_ori_w,
									nr_sequencia_p,
									nr_seq_grupo_regulacao_w,
									nr_seq_work_item_w,
									clock_timestamp(),
									coalesce(dt_previsao_w,clock_timestamp() + interval '30 days'),
									'S');	
			
		end;
	end loop;
	close C01;
			
	commit;
	
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_worklist_regulacao ( nr_sequencia_p bigint, ie_tipo_p text ) FROM PUBLIC;

