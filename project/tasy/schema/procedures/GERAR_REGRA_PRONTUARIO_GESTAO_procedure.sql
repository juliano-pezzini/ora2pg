-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_regra_prontuario_gestao (ie_tipo_atendimento_p bigint, cd_estabelecimento_p bigint, nr_atendimento_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, nr_seq_agenda_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_clinica_p bigint, cd_setor_passagem_p bigint, ie_tipo_Atend_alter_p bigint, cd_agenda_exame_p bigint, nr_interno_conta_p bigint default null, dt_periodo_inicial_p timestamp default null, dt_periodo_final_p timestamp default null) AS $body$
DECLARE


ie_tipo_prontuario_w	varchar(5);
ie_status_prontuario_w	varchar(5);
ie_setor_usuario_w	varchar(1);
cd_setor_atendimento_w	integer;
nr_seq_regra_w		bigint;
nr_seq_volume_w		integer;
qt_same_w		integer;
nr_seq_prontuario_w	bigint;
ie_forma_geracao_w	varchar(1);
nr_seq_local_w		bigint;
dt_periodo_inicial_w	timestamp;
dt_periodo_final_w	timestamp;
nr_seq_tipo_w          bigint;


BEGIN
/*  PS ESTA PROCEDURE NAO TEM COMMIT POIS ESTAH SENDO CHAMADA DE DENTRO DE UMA TRIGGER */

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (cd_setor_passagem_p IS NOT NULL AND cd_setor_passagem_p::text <> '') and (cd_agenda_exame_p = 99999) then
	
	select	coalesce(max(nr_sequencia),0),
		max(IE_FORMA_GERACAO) 
	into STRICT	nr_seq_regra_w,
		ie_forma_geracao_w
	from	regra_prontuario_gestao
	where	cd_estabelecimento					= cd_estabelecimento_p
	and	coalesce(ie_tipo_atendimento,coalesce(ie_tipo_atendimento_p,0))	= coalesce(ie_tipo_atendimento_p,0)
	and	coalesce(ie_clinica, coalesce(ie_clinica_p,0))			= coalesce(ie_clinica_p,0)
	and	coalesce(cd_setor_atend_regra,cd_setor_passagem_p)		= cd_setor_passagem_p
	and	coalesce(IE_FORMA_GERACAO,'A') = 'U';	
	
	
	if (nr_seq_regra_w > 0) then
		
		/*  Pega os dados padrões da regra */

		select	ie_tipo_prontuario,
			ie_status_prontuario,
			ie_setor_usuario,
			cd_setor_atendimento,
			nr_seq_local,
            nr_seq_tipo
		into STRICT	ie_tipo_prontuario_w,
			ie_status_prontuario_w,
			ie_setor_usuario_w,
			cd_setor_atendimento_w,
			nr_seq_local_w,
            nr_seq_tipo_w
		from	regra_prontuario_gestao
		where	nr_sequencia			= nr_seq_regra_w;

		/* Verifica se será gerada baseada com o setor do usuário que gerou o atendimento */

				
		if (ie_setor_usuario_w = 'P') then
			cd_setor_atendimento_w := cd_setor_passagem_p;
		elsif (ie_setor_usuario_w = 'A') then
			cd_setor_atendimento_w := obter_setor_ativo;
		elsif (ie_setor_usuario_w = 'S') then
			cd_setor_atendimento_w := OBTER_SETOR_USUARIO(nm_usuario_p);
		end if;		
		
		select 	coalesce(max(nr_seq_volume),0)+1
		into STRICT	nr_seq_volume_w
		from	same_prontuario
		where	cd_pessoa_fisica= cd_pessoa_fisica_p;

		select	nextval('same_prontuario_seq')
		into STRICT	nr_seq_prontuario_w
		;		
				
		select 	count(*)
		into STRICT	qt_same_w
		from	same_prontuario
		where	cd_pessoa_fisica= cd_pessoa_fisica_p;
		
		
		
		if (qt_same_w = 0) or (ie_forma_geracao_w = 'U') then
			
			
			/*  Gera o registro na gestão de prontuários */

			insert	into same_prontuario(
				nr_sequencia,
				cd_estabelecimento,
				ie_tipo,
				dt_atualizacao,
				nm_usuario,
				ie_status,
				cd_pessoa_fisica,
				nr_atendimento,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_setor_atendimento,
				ie_digitalizado,
				ie_microfilmado,
				nr_seq_volume,
				ie_forma_geracao_pront,
				cd_funcao,
				nr_seq_local,
                nr_seq_tipo
			) values (
				nr_seq_prontuario_w,
				cd_estabelecimento_p,
				ie_tipo_prontuario_w,
				clock_timestamp(),
				nm_usuario_p,
				ie_status_prontuario_w,
				cd_pessoa_fisica_p,
				CASE WHEN ie_forma_geracao_w='S' THEN null  ELSE nr_atendimento_p END ,
				clock_timestamp(),
				nm_usuario_p,
				cd_setor_atendimento_w,
				'N',
				'N',
				nr_seq_volume_w,
				'A',
				obter_funcao_ativa,
				nr_seq_local_w,
				nr_seq_tipo_w
			);
			
			
				
			CALL Gestao_Prontuario_Same(nr_seq_prontuario_w,nm_usuario_p,null,null,null,null,null,null,8,null,null,null,cd_estabelecimento_p);
					
		end if;

	end if;

elsif (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (cd_setor_passagem_p IS NOT NULL AND cd_setor_passagem_p::text <> '') then
	select	coalesce(max(nr_sequencia),0),
		max(IE_FORMA_GERACAO)
	into STRICT	nr_seq_regra_w,
		ie_forma_geracao_w
	from	regra_prontuario_gestao
	where	cd_estabelecimento					= cd_estabelecimento_p
	and	coalesce(ie_tipo_atendimento,coalesce(ie_tipo_atendimento_p,0))	= coalesce(ie_tipo_atendimento_p,0)
	and	coalesce(ie_clinica, coalesce(ie_clinica_p,0))			= coalesce(ie_clinica_p,0)
	and	cd_setor_atend_regra					= cd_setor_passagem_p
	and	coalesce(IE_FORMA_GERACAO,'A') = 'T';
	
	if (nr_seq_regra_w > 0) then
		
		/*  Pega os dados padrões da regra */

		select	ie_tipo_prontuario,
			ie_status_prontuario,
			ie_setor_usuario,
			cd_setor_atendimento,
			nr_seq_local
		into STRICT	ie_tipo_prontuario_w,
			ie_status_prontuario_w,
			ie_setor_usuario_w,
			cd_setor_atendimento_w,
			nr_seq_local_w
		from	regra_prontuario_gestao
		where	nr_sequencia			= nr_seq_regra_w;

		/* Verifica se será gerada baseada com o setor do usuário que gerou o atendimento */

		if (ie_setor_usuario_w = 'S') then
			cd_setor_atendimento_w := cd_setor_passagem_p;
		elsif (ie_setor_usuario_w = 'A') then
			cd_setor_atendimento_w := obter_setor_ativo;
		end if;
		

		select 	coalesce(max(nr_seq_volume),0)+1
		into STRICT	nr_seq_volume_w
		from	same_prontuario
		where	cd_pessoa_fisica= cd_pessoa_fisica_p;

		select	nextval('same_prontuario_seq')
		into STRICT	nr_seq_prontuario_w
		;		
				
		select 	count(*)
		into STRICT	qt_same_w
		from	same_prontuario
		where	cd_pessoa_fisica= cd_pessoa_fisica_p;
				
		if (qt_same_w = 0) or (ie_forma_geracao_w = 'T') then
			
			
			/*  Gera o registro na gestão de prontuários */

			insert	into same_prontuario(
				nr_sequencia,
				cd_estabelecimento,
				ie_tipo,
				dt_atualizacao,
				nm_usuario,
				ie_status,
				cd_pessoa_fisica,
				nr_atendimento,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_setor_atendimento,
				ie_digitalizado,
				ie_microfilmado,
				nr_seq_volume,
				ie_forma_geracao_pront,
				cd_funcao,
				nr_seq_local
			) values (
				nr_seq_prontuario_w,
				cd_estabelecimento_p,
				ie_tipo_prontuario_w,
				clock_timestamp(),
				nm_usuario_p,
				ie_status_prontuario_w,
				cd_pessoa_fisica_p,
				CASE WHEN ie_forma_geracao_w='S' THEN null  ELSE nr_atendimento_p END ,
				clock_timestamp(),
				nm_usuario_p,
				cd_setor_atendimento_w,
				'N',
				'N',
				nr_seq_volume_w,
				'A',
				obter_funcao_ativa,
				nr_seq_local_w
			);
				
			CALL Gestao_Prontuario_Same(nr_seq_prontuario_w,nm_usuario_p,null,null,null,null,null,null,8,null,null,null,cd_estabelecimento_p);
					
		end if;

	end if;

elsif (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') and (ie_origem_proced_p IS NOT NULL AND ie_origem_proced_p::text <> '') then
	/*  Código da última regra que é atendida */

	select	coalesce(max(nr_sequencia),0),
		max(IE_FORMA_GERACAO)
	into STRICT	nr_seq_regra_w,
		ie_forma_geracao_w
	from	regra_prontuario_gestao
	where	cd_estabelecimento					= cd_estabelecimento_p
	and	coalesce(ie_tipo_atendimento,coalesce(ie_tipo_atendimento_p,0))	= coalesce(ie_tipo_atendimento_p,0)
	and	coalesce(cd_procedimento, cd_procedimento_p)			= cd_procedimento_p
	and	coalesce(ie_origem_proced, ie_origem_proced_p)		= ie_origem_proced_p
	and	coalesce(IE_FORMA_GERACAO,'A') = 'P';
	
	if (nr_seq_regra_w > 0) then
		
		/*  Pega os dados padrões da regra */

		select	ie_tipo_prontuario,
			ie_status_prontuario,
			ie_setor_usuario,
			cd_setor_atendimento,
			nr_seq_local
		into STRICT	ie_tipo_prontuario_w,
			ie_status_prontuario_w,
			ie_setor_usuario_w,
			cd_setor_atendimento_w,
			nr_seq_local_w
		from	regra_prontuario_gestao
		where	nr_sequencia			= nr_seq_regra_w;

		/* Verifica se será gerada baseada com o setor do usuário que gerou o atendimento */

		if (ie_setor_usuario_w = 'S') then
			select	obter_setor_usuario(nm_usuario_p)
			into STRICT	cd_setor_atendimento_w
			;
		elsif (ie_setor_usuario_w = 'A') then
			cd_setor_atendimento_w := obter_setor_ativo;
		end if;

		select 	coalesce(max(nr_seq_volume),0)+1
		into STRICT	nr_seq_volume_w
		from	same_prontuario
		where	cd_pessoa_fisica= cd_pessoa_fisica_p;

		select	nextval('same_prontuario_seq')
		into STRICT	nr_seq_prontuario_w
		;
		
		
				
		select 	count(*)
		into STRICT	qt_same_w
		from	same_prontuario
		where	cd_pessoa_fisica= cd_pessoa_fisica_p;
		
		
		if (qt_same_w = 0) or (ie_forma_geracao_w = 'P') then
			
			
			/*  Gera o registro na gestão de prontuários */

			insert	into same_prontuario(
				nr_sequencia,
				cd_estabelecimento,
				ie_tipo,
				dt_atualizacao,
				nm_usuario,
				ie_status,
				cd_pessoa_fisica,
				nr_atendimento,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_setor_atendimento,
				ie_digitalizado,
				ie_microfilmado,
				nr_seq_volume,
				ie_forma_geracao_pront,
				cd_funcao,
				nr_seq_local
			) values (
				nr_seq_prontuario_w,
				cd_estabelecimento_p,
				ie_tipo_prontuario_w,
				clock_timestamp(),
				nm_usuario_p,
				ie_status_prontuario_w,
				cd_pessoa_fisica_p,
				CASE WHEN ie_forma_geracao_w='S' THEN null  ELSE nr_atendimento_p END ,
				clock_timestamp(),
				nm_usuario_p,
				cd_setor_atendimento_w,
				'N',
				'N',
				nr_seq_volume_w,
				'A',
				obter_funcao_ativa,
				nr_seq_local_w
			);
				
			CALL Gestao_Prontuario_Same(nr_seq_prontuario_w,nm_usuario_p,null,null,null,null,null,null,8,null,null,null,cd_estabelecimento_p);
			
			
		end if;

	end if;
elsif (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (ie_tipo_Atend_alter_p IS NOT NULL AND ie_tipo_Atend_alter_p::text <> '') then
	/*  Código da última regra que é atendida */

	select	coalesce(max(nr_sequencia),0),
		max(IE_FORMA_GERACAO)
	into STRICT	nr_seq_regra_w,
		ie_forma_geracao_w
	from	regra_prontuario_gestao
	where	cd_estabelecimento					= cd_estabelecimento_p
	and	coalesce(ie_tipo_atendimento,coalesce(ie_tipo_Atend_alter_p,0))	= coalesce(ie_tipo_Atend_alter_p,0)
	and	coalesce(ie_clinica, coalesce(ie_clinica_p,0))			= coalesce(ie_clinica_p,0)
	and	coalesce(IE_FORMA_GERACAO,'A') = 'I';
	
	
	if (nr_seq_regra_w > 0) then
		
		/*  Pega os dados padrões da regra */

		select	ie_tipo_prontuario,
			ie_status_prontuario,
			ie_setor_usuario,
			cd_setor_atendimento,
			nr_seq_local
		into STRICT	ie_tipo_prontuario_w,
			ie_status_prontuario_w,
			ie_setor_usuario_w,
			cd_setor_atendimento_w,
			nr_seq_local_w
		from	regra_prontuario_gestao
		where	nr_sequencia			= nr_seq_regra_w;

		/* Verifica se será gerada baseada com o setor do usuário que gerou o atendimento */

		if (ie_setor_usuario_w = 'S') then
			select	obter_setor_usuario(nm_usuario_p)
			into STRICT	cd_setor_atendimento_w
			;
		elsif (ie_setor_usuario_w = 'A') then
			cd_setor_atendimento_w := obter_setor_ativo;
		end if;

		select 	coalesce(max(nr_seq_volume),0)+1
		into STRICT	nr_seq_volume_w
		from	same_prontuario
		where	cd_pessoa_fisica= cd_pessoa_fisica_p;

		select	nextval('same_prontuario_seq')
		into STRICT	nr_seq_prontuario_w
		;
		
		
				
		select 	count(*)
		into STRICT	qt_same_w
		from	same_prontuario
		where	cd_pessoa_fisica= cd_pessoa_fisica_p;
		
		
		
		if (qt_same_w = 0) or (ie_forma_geracao_w = 'I') then
			
			/*  Gera o registro na gestão de prontuários */

			insert	into same_prontuario(
				nr_sequencia,
				cd_estabelecimento,
				ie_tipo,
				dt_atualizacao,
				nm_usuario,
				ie_status,
				cd_pessoa_fisica,
				nr_atendimento,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_setor_atendimento,
				ie_digitalizado,
				ie_microfilmado,
				nr_seq_volume,
				ie_forma_geracao_pront,
				cd_funcao,
				nr_seq_local
			) values (
				nr_seq_prontuario_w,
				cd_estabelecimento_p,
				ie_tipo_prontuario_w,
				clock_timestamp(),
				nm_usuario_p,
				ie_status_prontuario_w,
				cd_pessoa_fisica_p,
				CASE WHEN ie_forma_geracao_w='S' THEN null  ELSE nr_atendimento_p END ,
				clock_timestamp(),
				nm_usuario_p,
				cd_setor_atendimento_w,
				'N',
				'N',
				nr_seq_volume_w,
				'A',
				obter_funcao_ativa,
				nr_seq_local_w
			);
				
			CALL Gestao_Prontuario_Same(nr_seq_prontuario_w,nm_usuario_p,null,null,null,null,null,null,8,null,null,null, cd_estabelecimento_p);
			
			
		end if;

	end if;
elsif (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nr_interno_conta_p IS NOT NULL AND nr_interno_conta_p::text <> '') then -- CONTA PACIENTE
	/*  Código da última regra que é atendida */

	select	coalesce(max(nr_sequencia),0),
		max(IE_FORMA_GERACAO)
	into STRICT	nr_seq_regra_w,
		ie_forma_geracao_w
	from	regra_prontuario_gestao
	where	cd_estabelecimento					= cd_estabelecimento_p
	and	coalesce(ie_tipo_atendimento,coalesce(ie_tipo_atendimento_p,0))	= coalesce(ie_tipo_atendimento_p,0)
	and	coalesce(ie_clinica, coalesce(ie_clinica_p,0))			= coalesce(ie_clinica_p,0)
	and	coalesce(IE_FORMA_GERACAO,'A') = 'O';
	
	if (nr_seq_regra_w > 0) then
		
		/*  Pega os dados padrões da regra */

		select	ie_tipo_prontuario,
			ie_status_prontuario,
			ie_setor_usuario,
			cd_setor_atendimento,
			nr_seq_local
		into STRICT	ie_tipo_prontuario_w,
			ie_status_prontuario_w,
			ie_setor_usuario_w,
			cd_setor_atendimento_w,
			nr_seq_local_w
		from	regra_prontuario_gestao
		where	nr_sequencia			= nr_seq_regra_w;

		/* Verifica se será gerada baseada com o setor do usuário que gerou o atendimento */

		if (ie_setor_usuario_w = 'S') then
			select	obter_setor_usuario(nm_usuario_p)
			into STRICT	cd_setor_atendimento_w
			;
		elsif (ie_setor_usuario_w = 'A') then
			cd_setor_atendimento_w := obter_setor_ativo;
		end if;

		select 	coalesce(max(nr_seq_volume),0)+1
		into STRICT	nr_seq_volume_w
		from	same_prontuario
		where	cd_pessoa_fisica= cd_pessoa_fisica_p;

		select	nextval('same_prontuario_seq')
		into STRICT	nr_seq_prontuario_w
		;
		
		
				
		select 	count(*)
		into STRICT	qt_same_w
		from	same_prontuario
		where	cd_pessoa_fisica= cd_pessoa_fisica_p;
		
		if (qt_same_w = 0) or (ie_forma_geracao_w = 'O') then
			
			/*  Gera o registro na gestão de prontuários */

			insert	into same_prontuario(
				nr_sequencia,
				cd_estabelecimento,
				ie_tipo,
				dt_atualizacao,
				nm_usuario,
				ie_status,
				cd_pessoa_fisica,
				nr_atendimento,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_setor_atendimento,
				ie_digitalizado,
				ie_microfilmado,
				nr_seq_volume,
				ie_forma_geracao_pront,
				cd_funcao,
				nr_seq_local,
				dt_periodo_inicial,
				dt_periodo_final,
				nr_interno_conta
			) values (
				nr_seq_prontuario_w,
				cd_estabelecimento_p,
				ie_tipo_prontuario_w,
				clock_timestamp(),
				nm_usuario_p,
				ie_status_prontuario_w,
				cd_pessoa_fisica_p,
				CASE WHEN ie_forma_geracao_w='S' THEN null  ELSE nr_atendimento_p END ,
				clock_timestamp(),
				nm_usuario_p,
				cd_setor_atendimento_w,
				'N',
				'N',
				nr_seq_volume_w,
				'A',
				obter_funcao_ativa,
				nr_seq_local_w,
				dt_periodo_inicial_p,
				dt_periodo_final_p,
				nr_interno_conta_p
			);
				
			CALL Gestao_Prontuario_Same(nr_seq_prontuario_w,nm_usuario_p,null,null,null,null,null,null,8,null,null,null, cd_estabelecimento_p);
			
			
		end if;

	end if;
elsif (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	/*  Código da última regra que é atendida */

	select	coalesce(max(nr_sequencia),0),
		max(IE_FORMA_GERACAO)
	into STRICT	nr_seq_regra_w,
		ie_forma_geracao_w
	from	regra_prontuario_gestao
	where	cd_estabelecimento					= cd_estabelecimento_p
	and	coalesce(ie_tipo_atendimento,coalesce(ie_tipo_atendimento_p,0))	= coalesce(ie_tipo_atendimento_p,0)
	and	coalesce(ie_clinica, coalesce(ie_clinica_p,0))			= coalesce(ie_clinica_p,0)
	and	coalesce(IE_FORMA_GERACAO,'A') in ('S','A');
	
	
	if (nr_seq_regra_w > 0) then
		
		/*  Pega os dados padrões da regra */

		select	ie_tipo_prontuario,
			ie_status_prontuario,
			ie_setor_usuario,
			cd_setor_atendimento,
			nr_seq_local
		into STRICT	ie_tipo_prontuario_w,
			ie_status_prontuario_w,
			ie_setor_usuario_w,
			cd_setor_atendimento_w,
			nr_seq_local_w
		from	regra_prontuario_gestao
		where	nr_sequencia			= nr_seq_regra_w;

		/* Verifica se será gerada baseada com o setor do usuário que gerou o atendimento */

		if (ie_setor_usuario_w = 'S') then
			select	obter_setor_usuario(nm_usuario_p)
			into STRICT	cd_setor_atendimento_w
			;
		elsif (ie_setor_usuario_w = 'A') then
			cd_setor_atendimento_w := obter_setor_ativo;
		end if;

		select 	coalesce(max(nr_seq_volume),0)+1
		into STRICT	nr_seq_volume_w
		from	same_prontuario
		where	cd_pessoa_fisica= cd_pessoa_fisica_p;

		select	nextval('same_prontuario_seq')
		into STRICT	nr_seq_prontuario_w
		;
		
		
				
		select 	count(*)
		into STRICT	qt_same_w
		from	same_prontuario
		where	cd_pessoa_fisica= cd_pessoa_fisica_p;
		
		
		
		if (qt_same_w = 0) or (ie_forma_geracao_w in ('A')) then
			
			/*  Gera o registro na gestão de prontuários */

			insert	into same_prontuario(
				nr_sequencia,
				cd_estabelecimento,
				ie_tipo,
				dt_atualizacao,
				nm_usuario,
				ie_status,
				cd_pessoa_fisica,
				nr_atendimento,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_setor_atendimento,
				ie_digitalizado,
				ie_microfilmado,
				nr_seq_volume,
				ie_forma_geracao_pront,
				cd_funcao,
				nr_seq_local
			) values (
				nr_seq_prontuario_w,
				cd_estabelecimento_p,
				ie_tipo_prontuario_w,
				clock_timestamp(),
				nm_usuario_p,
				ie_status_prontuario_w,
				cd_pessoa_fisica_p,
				CASE WHEN ie_forma_geracao_w='S' THEN null  ELSE nr_atendimento_p END ,
				clock_timestamp(),
				nm_usuario_p,
				cd_setor_atendimento_w,
				'N',
				'N',
				nr_seq_volume_w,
				'A',
				obter_funcao_ativa,
				nr_seq_local_w
			);
				
			CALL Gestao_Prontuario_Same(nr_seq_prontuario_w,nm_usuario_p,null,null,null,null,null,null,8,null,null,null,cd_estabelecimento_p);
			
			
		end if;

	end if;
elsif (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') and (ie_origem_proced_p IS NOT NULL AND ie_origem_proced_p::text <> '') then
	/*  Código da última regra que é atendida */

	select	coalesce(max(nr_sequencia),0),
		max(IE_FORMA_GERACAO)
	into STRICT	nr_seq_regra_w,
		ie_forma_geracao_w
	from	regra_prontuario_gestao
	where	cd_estabelecimento					= cd_estabelecimento_p
	and	coalesce(cd_procedimento, cd_procedimento_p)			= cd_procedimento_p
	and	coalesce(ie_origem_proced, ie_origem_proced_p)		= ie_origem_proced_p
	and	coalesce(IE_FORMA_GERACAO,'A') = 'P';
	
	if (nr_seq_regra_w > 0) then
		
		/*  Pega os dados padrões da regra */

		select	ie_tipo_prontuario,
			ie_status_prontuario,
			ie_setor_usuario,
			cd_setor_atendimento,
			nr_seq_local
		into STRICT	ie_tipo_prontuario_w,
			ie_status_prontuario_w,
			ie_setor_usuario_w,
			cd_setor_atendimento_w,
			nr_seq_local_w
		from	regra_prontuario_gestao
		where	nr_sequencia			= nr_seq_regra_w;
		
		/* Verifica se será gerada baseada com o setor do usuário que gerou o atendimento */

		if (ie_setor_usuario_w = 'S') then
			select	obter_setor_usuario(nm_usuario_p)
			into STRICT	cd_setor_atendimento_w
			;
		elsif (ie_setor_usuario_w = 'A') then
			cd_setor_atendimento_w := obter_setor_ativo;
		end if;

		select 	coalesce(max(nr_seq_volume),0)+1
		into STRICT	nr_seq_volume_w
		from	same_prontuario
		where	cd_pessoa_fisica= cd_pessoa_fisica_p;
		
		
		select 	count(*)
		into STRICT	qt_same_w
		from	same_prontuario
		where	cd_pessoa_fisica= cd_pessoa_fisica_p;

		if (qt_same_w = 0) then
		
			select	nextval('same_prontuario_seq')
			into STRICT	nr_seq_prontuario_w
			;
				
			/*  Gera o registro na gestão de prontuários */

			insert	into same_prontuario(
				nr_sequencia,
				cd_estabelecimento,
				ie_tipo,
				dt_atualizacao,
				nm_usuario,
				ie_status,
				cd_pessoa_fisica,
				nr_atendimento,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_setor_atendimento,
				ie_digitalizado,
				ie_microfilmado,
				nr_seq_volume,
				ie_forma_geracao_pront,
				cd_funcao,
				nr_seq_local
			) values (
				nr_seq_prontuario_w,
				cd_estabelecimento_p,
				ie_tipo_prontuario_w,
				clock_timestamp(),
				nm_usuario_p,
				ie_status_prontuario_w,
				cd_pessoa_fisica_p,
				nr_atendimento_p,
				clock_timestamp(),
				nm_usuario_p,
				cd_setor_atendimento_w,
				'N',
				'N',
				nr_seq_volume_w,
				'A',
				obter_funcao_ativa,
				nr_seq_local_w
			);
			
			CALL Gestao_Prontuario_Same(nr_seq_prontuario_w,nm_usuario_p,null,null,null,null,null,null,8,null,null,null, cd_estabelecimento_p);
		end if;
	end if;
elsif (cd_agenda_exame_p IS NOT NULL AND cd_agenda_exame_p::text <> '') then
	/*  Código da última regra que é atendida */

	select	coalesce(max(nr_sequencia),0),
		max(IE_FORMA_GERACAO)
	into STRICT	nr_seq_regra_w,
		ie_forma_geracao_w
	from	regra_prontuario_gestao
	where	cd_estabelecimento					= cd_estabelecimento_p
	--and	nvl(cd_procedimento, cd_procedimento_p)			= cd_procedimento_p

	--and	nvl(ie_origem_proced, ie_origem_proced_p)		= ie_origem_proced_p
	and	coalesce(cd_agenda_exame, cd_agenda_exame_p)			= cd_agenda_exame_p
	and	coalesce(IE_FORMA_GERACAO,'A') = 'E'
	and	(nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '');
	
	
	if (nr_seq_regra_w > 0) then
		
		/*  Pega os dados padrões da regra */

		select	ie_tipo_prontuario,
			ie_status_prontuario,
			ie_setor_usuario,
			cd_setor_atendimento,
			nr_seq_local
		into STRICT	ie_tipo_prontuario_w,
			ie_status_prontuario_w,
			ie_setor_usuario_w,
			cd_setor_atendimento_w,
			nr_seq_local_w
		from	regra_prontuario_gestao
		where	nr_sequencia			= nr_seq_regra_w;
		
		/* Verifica se será gerada baseada com o setor do usuário que gerou o atendimento */

		if (ie_setor_usuario_w = 'S') then
			select	obter_setor_usuario(nm_usuario_p)
			into STRICT	cd_setor_atendimento_w
			;
		elsif (ie_setor_usuario_w = 'A') then
			cd_setor_atendimento_w := obter_setor_ativo;
		end if;

		select 	coalesce(max(nr_seq_volume),0)+1
		into STRICT	nr_seq_volume_w
		from	same_prontuario
		where	cd_pessoa_fisica= cd_pessoa_fisica_p;
		
		
		select 	count(*)
		into STRICT	qt_same_w
		from	same_prontuario
		where	cd_pessoa_fisica= cd_pessoa_fisica_p;

		if (qt_same_w = 0) then
		
			select	nextval('same_prontuario_seq')
			into STRICT	nr_seq_prontuario_w
			;
				
			/*  Gera o registro na gestão de prontuários */

			insert	into same_prontuario(
				nr_sequencia,
				cd_estabelecimento,
				ie_tipo,
				dt_atualizacao,
				nm_usuario,
				ie_status,
				cd_pessoa_fisica,
				nr_atendimento,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_setor_atendimento,
				ie_digitalizado,
				ie_microfilmado,
				nr_seq_volume,
				ie_forma_geracao_pront,
				cd_funcao,
				nr_seq_local
			) values (
				nr_seq_prontuario_w,
				cd_estabelecimento_p,
				ie_tipo_prontuario_w,
				clock_timestamp(),
				nm_usuario_p,
				ie_status_prontuario_w,
				cd_pessoa_fisica_p,
				nr_atendimento_p,
				clock_timestamp(),
				nm_usuario_p,
				cd_setor_atendimento_w,
				'N',
				'N',
				nr_seq_volume_w,
				'A',
				obter_funcao_ativa,
				nr_seq_local_w
			);
			
			CALL Gestao_Prontuario_Same(nr_seq_prontuario_w,nm_usuario_p,null,null,null,null,null,null,8,null,null,null, cd_estabelecimento_p);
		end if;
	end if;
else
	/*  Código da última regra que é atendida */

	select	coalesce(max(nr_sequencia),0),
		max(IE_FORMA_GERACAO)
	into STRICT	nr_seq_regra_w,
		ie_forma_geracao_w
	from	regra_prontuario_gestao
	where	cd_estabelecimento					= cd_estabelecimento_p
	and	(((coalesce(IE_FORMA_GERACAO,'A') = 'C') and (coalesce(nr_seq_agenda_p::text, '') = '')) or
		 ((coalesce(IE_FORMA_GERACAO,'A') = 'G') and (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '')));
	
	if (nr_seq_regra_w > 0) then
		
		/*  Pega os dados padrões da regra */

		select	ie_tipo_prontuario,
			ie_status_prontuario,
			ie_setor_usuario,
			cd_setor_atendimento,
			nr_seq_local
		into STRICT	ie_tipo_prontuario_w,
			ie_status_prontuario_w,
			ie_setor_usuario_w,
			cd_setor_atendimento_w,
			nr_seq_local_w
		from	regra_prontuario_gestao
		where	nr_sequencia			= nr_seq_regra_w;
		
		/* Verifica se será gerada baseada com o setor do usuário que gerou o atendimento */

		if (ie_setor_usuario_w = 'S') then
			select	obter_setor_usuario(nm_usuario_p)
			into STRICT	cd_setor_atendimento_w
			;
		elsif (ie_setor_usuario_w = 'A') then
			cd_setor_atendimento_w := obter_setor_ativo;
		end if;

		select 	coalesce(max(nr_seq_volume),0)+1
		into STRICT	nr_seq_volume_w
		from	same_prontuario
		where	cd_pessoa_fisica= cd_pessoa_fisica_p;
		
		
		select 	count(*)
		into STRICT	qt_same_w
		from	same_prontuario
		where	cd_pessoa_fisica= cd_pessoa_fisica_p;

		if (qt_same_w = 0) then
		
			select	nextval('same_prontuario_seq')
			into STRICT	nr_seq_prontuario_w
			;
				
			/*  Gera o registro na gestão de prontuários */

			insert	into same_prontuario(
				nr_sequencia,
				cd_estabelecimento,
				ie_tipo,
				dt_atualizacao,
				nm_usuario,
				ie_status,
				cd_pessoa_fisica,
				nr_atendimento,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_setor_atendimento,
				ie_digitalizado,
				ie_microfilmado,
				nr_seq_volume,
				ie_forma_geracao_pront,
				cd_funcao,
				nr_seq_local
			) values (
				nr_seq_prontuario_w,
				cd_estabelecimento_p,
				ie_tipo_prontuario_w,
				clock_timestamp(),
				nm_usuario_p,
				ie_status_prontuario_w,
				cd_pessoa_fisica_p,
				nr_atendimento_p,
				clock_timestamp(),
				nm_usuario_p,
				cd_setor_atendimento_w,
				'N',
				'N',
				nr_seq_volume_w,
				'A',
				obter_funcao_ativa,
				nr_seq_local_w
			);
			
			CALL Gestao_Prontuario_Same(nr_seq_prontuario_w,nm_usuario_p,null,null,null,null,null,null,8,null,null,null,cd_estabelecimento_p);
		end if;
	end if;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_regra_prontuario_gestao (ie_tipo_atendimento_p bigint, cd_estabelecimento_p bigint, nr_atendimento_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, nr_seq_agenda_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_clinica_p bigint, cd_setor_passagem_p bigint, ie_tipo_Atend_alter_p bigint, cd_agenda_exame_p bigint, nr_interno_conta_p bigint default null, dt_periodo_inicial_p timestamp default null, dt_periodo_final_p timestamp default null) FROM PUBLIC;

