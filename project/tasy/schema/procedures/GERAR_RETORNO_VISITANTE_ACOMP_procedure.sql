-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_retorno_visitante_acomp ( nr_sequencia_p bigint, ie_controle_p text, nm_usuario_p text, ds_aviso_p INOUT text, ie_classificacao_p text, nr_seq_controle_p bigint, nr_seq_novo_visit_p INOUT bigint) AS $body$
DECLARE


nr_seq_controle_w			bigint;
nr_sequencia_w				bigint;

varacompanhante				varchar(5):='N';	/* param 23 ocupacao hospitalar */
varidadeconsitevisita		bigint:=0;		/* param 13 controle visitas */
nr_atendimento_w			bigint:=0;
qt_max_visitante_w			bigint:=0;
qt_idade_visitante_w		bigint:=0;
qt_visitantes_w				bigint:=0;
cd_pessoa_fisica_w			varchar(20):=0;
ie_permite_funcionario_w	varchar(1);
cd_funcionario_w			varchar(10);
nr_acompanhante_w			bigint;
ie_considera_estab_w		varchar(5);
nm_visitante_w				varchar(255);
ie_visitante_sem_saida_w	varchar(1);
ie_acompanhante_sem_saida_w	varchar(1);
nr_controle_unico_w			varchar(2);
cd_setor_atend_w			setor_atendimento.cd_setor_atendimento%type;
ie_busca_setor_w			varchar(1);
ie_status_w					atendimento_visita.ie_status%type;
ie_validar_retorno_w 		varchar(1);
ie_gerar_controle_acomp_w 	varchar(1);
nr_seq_controle_ww			bigint;
nr_controle_novo_w			bigint;


BEGIN

ie_gerar_controle_acomp_w := Obter_Param_Usuario(8014, 36, obter_perfil_ativo, nm_usuario_p, 0, ie_gerar_controle_acomp_w);
ie_considera_estab_w := Obter_Param_Usuario(8014, 59, obter_perfil_ativo, nm_usuario_p, 0, ie_considera_estab_w);
ie_busca_setor_w := Obter_Param_Usuario(8014, 91, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_busca_setor_w);
nr_controle_unico_w := Obter_Param_Usuario(8014, 119, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, nr_controle_unico_w);
ie_status_w := Obter_Param_Usuario(8014, 124, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_status_w);
ie_validar_retorno_w := Obter_Param_Usuario(8014, 127, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_validar_retorno_w);

nr_seq_controle_ww := nr_seq_controle_p;

/* obter dados visita */

select 	coalesce(max(nr_atendimento),0),
		max(cd_pessoa_fisica),
		max(NM_VISITANTE)
into STRICT	nr_atendimento_w,
		cd_pessoa_fisica_w,
		nm_visitante_w
from   	atendimento_visita
where  	nr_sequencia = nr_sequencia_p;

select	 max(nr_acompanhante)
into STRICT	nr_acompanhante_w
from	atendimento_acompanhante
where	nr_atendimento = nr_atendimento_w;

if (ie_busca_setor_w = 'S') then
	select	substr(obter_unidade_atendimento(nr_atendimento_w,'IAA','CS'), 1,100) cd_setor_atend
	into STRICT	cd_setor_atend_w
	;
end if;	

nr_acompanhante_w	:= coalesce(nr_acompanhante_w,0) + 1;

/*As consistencias abaixo foram criadas para nao permitir que seja gerado um retorno de um visitante como acompanhante, caso ja exista o registro de visitante para essa pessoa e vice e versa.*/

if (coalesce(ie_validar_retorno_w,'N') = 'S') then

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_visitante_sem_saida_w
	from	atendimento_visita
	where	coalesce(dt_saida::text, '') = ''
	and	nr_sequencia <> nr_sequencia_p
	and	((cd_pessoa_fisica = cd_pessoa_fisica_w) or (nm_visitante = nm_visitante_w));

	if (ie_visitante_sem_saida_w = 'S') then
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(228401);
	end if;

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_acompanhante_sem_saida_w
	from	atendimento_acompanhante
	where	coalesce(dt_saida::text, '') = ''
	and	((cd_pessoa_fisica = cd_pessoa_fisica_w) or (nm_acompanhante = nm_visitante_w));

	if (ie_acompanhante_sem_saida_w = 'S') then
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(228404);
	end if;
	
end if;

if (ie_classificacao_p = 'V')	then

	
	/* 	
	obter vl parametro [23] da ocupacao hospitalar.
	*/
	select	coalesce(max(obter_valor_param_usuario(44, 23, obter_perfil_ativo, nm_usuario_p, null)), 'N')
	into STRICT	varacompanhante
	;
	
	/* 
	obter vl parametro [13] da controle visitas.
	*/
	select	coalesce(max(obter_valor_param_usuario(8014, 13, obter_perfil_ativo, nm_usuario_p, null)),0)
	into STRICT	varidadeconsitevisita
	;
	
	/* obter capacidade/limite de visitantes do setor-unidade */

	select 	coalesce(max(qt_max_visitante),1)
	into STRICT	qt_max_visitante_w
	from   	unidade_atendimento
	where  	cd_setor_atendimento 	= obter_setor_atendimento(nr_atendimento_w)
	and    	cd_unidade_basica 	= obter_unidade_atendimento(nr_atendimento_w,'A','UB')
	and    	cd_unidade_compl 	= obter_unidade_atendimento(nr_atendimento_w,'A','UC');
	
	/* obter idade do visitante */

	select obter_idade_pf(cd_pessoa_fisica_w,clock_timestamp(),'A')
	into STRICT   qt_idade_visitante_w
	;
	
	/* obter quantidade de visitantes*/
	select 	coalesce(count(*),0)
	into STRICT	qt_visitantes_w 
	from   	atendimento_visita
	where  	nr_atendimento = nr_atendimento_w
	and    	coalesce(dt_saida::text, '') = ''
	and	coalesce(ie_paciente,'N') = 'N'
	and    	((coalesce(cd_pessoa_fisica::text, '') = '') or (coalesce(obter_idade_pf(cd_pessoa_fisica,clock_timestamp(),'A'),0) > coalesce(varidadeconsitevisita,1)));
	
	select	coalesce(max(obter_valor_param_usuario(8014, 48, obter_perfil_ativo, nm_usuario_p, null)), 'N')
	into STRICT	ie_permite_funcionario_w
	;
	
	select	Obter_Pf_Usuario(nm_usuario_p,'C')
	into STRICT	cd_funcionario_w
	;
		
		
	if (varacompanhante <> 'N' AND qt_max_visitante_w <> 0) then		
		if (qt_visitantes_w >= qt_max_visitante_w) 					 	and
		((qt_idade_visitante_w > varidadeconsitevisita) or (varidadeconsitevisita = 0)) 	then	   	  	   
			if (varacompanhante = 'B') then
				CALL Wheb_mensagem_pck.exibir_mensagem_abort(262466);
			elsif (varacompanhante = 'A') then
				ds_aviso_p := obter_texto_tasy(262466, wheb_usuario_pck.get_nr_seq_idioma);
			end if;				
		end if;
	end if;	
			if (ie_controle_p = 'S')  and (coalesce(nr_seq_controle_p::text, '') = '') then
				/*select	max(nr_seq_controle) + 1
				into	nr_seq_controle_w
				from	atendimento_visita;*/
				
				if (ie_considera_estab_w = 'S') then
					nr_seq_controle_w	:=	obter_nr_controle_estab(wheb_usuario_pck.get_cd_estabelecimento);
				
				elsif (nr_controle_unico_w = 'S')then
					select	nextval('controle_visita_unico_seq')
					into STRICT	nr_seq_controle_w
					;
				else
					select	nextval('atendimento_visita_seq2')
					into STRICT	nr_seq_controle_w
					;
				end if;

			end if;
	
			select 	nextval('atendimento_visita_seq')
			into STRICT	nr_sequencia_w
			;
			
			insert into 	
				atendimento_visita(
				nr_sequencia,
				nr_atendimento,
				dt_atualizacao,
				nm_usuario,
				dt_entrada,
				nr_seq_tipo,
				dt_saida,
				ds_observacao,
				cd_pessoa_fisica,
				nr_seq_controle,
				nm_visitante,
				cd_setor_atendimento,
				nr_identidade,
				nr_telefone,
				dt_nascimento,
				cd_funcionario,
				cd_empresa,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_setor_atend,
				ie_sexo, 
				ie_status)
			SELECT	nr_sequencia_w,
				nr_atendimento,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nr_seq_tipo,
				null,
				null,
				cd_pessoa_fisica,
				coalesce(nr_seq_controle_p,nr_seq_controle_w ),
				nm_visitante,
				cd_setor_atendimento,
				nr_identidade,
				nr_telefone,
				dt_nascimento,
				CASE WHEN ie_permite_funcionario_w='S' THEN cd_funcionario_w  ELSE null END ,
				cd_empresa,
				clock_timestamp(),
				nm_usuario_p,
				cd_setor_atend_w, 
				ie_sexo, 
				ie_status_w
			from	atendimento_visita
			where	nr_sequencia	= nr_sequencia_p;
	
			update	atendimento_visita_foto
			set	nr_seq_atend_visita = nr_sequencia_w
			where	nr_seq_atend_visita = nr_sequencia_p;
		
end if;

if (ie_classificacao_p = 'A')	then

	begin
	
	if (coalesce(nr_seq_controle_ww::text, '') = '') THEN
	
		if (ie_gerar_controle_acomp_w = 'S') then	
			if (nr_controle_unico_w = 'S') then
				select	nextval('controle_visita_unico_seq')
				into STRICT	nr_controle_novo_w
				;
			else
				SELECT 	coalesce(MAX((REGEXP_replace(nr_controle, '[^[:digit:]]', ''))::numeric ),0) + 1
				into STRICT	nr_controle_novo_w
				from	atendimento_acompanhante;
			end if;
			
			nr_seq_controle_ww := nr_controle_novo_w;		
		end if;
		
	end if;

	exception
		when	others then
			nr_seq_controle_ww := nr_seq_controle_p;
	end;
	
	insert into atendimento_acompanhante(nr_atendimento,
		dt_acompanhante, 
		nr_acompanhante, 
		dt_atualizacao, 
		nm_usuario, 
		nm_acompanhante, 
		cd_pessoa_fisica, 
		dt_saida, 
		nr_identidade, 
		nr_controle, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec,
		nr_seq_tipo,
		nr_telefone)
	SELECT	nr_atendimento_w,
		clock_timestamp(),
		nr_acompanhante_w,
		clock_timestamp(),
		nm_usuario_p,
		substr(obter_nome_visitante(nr_sequencia_p),1,40),
		cd_pessoa_fisica,
		null,
		nr_identidade,
		coalesce(nr_seq_controle_ww, nr_Seq_controle),
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_tipo,
		nr_telefone
	from	atendimento_visita
	where	nr_sequencia	= nr_sequencia_p;
	
	nr_sequencia_w	:= nr_acompanhante_w;
	
end if;
	
commit;



nr_seq_novo_visit_p := nr_sequencia_w;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_retorno_visitante_acomp ( nr_sequencia_p bigint, ie_controle_p text, nm_usuario_p text, ds_aviso_p INOUT text, ie_classificacao_p text, nr_seq_controle_p bigint, nr_seq_novo_visit_p INOUT bigint) FROM PUBLIC;

