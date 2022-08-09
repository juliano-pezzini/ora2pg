-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_lista_problema ( NR_ATENDIMENTO_P bigint, IE_TIPO_REGISTRO_P text, IE_ESCALA_P bigint, NR_SEQ_REG_P bigint, CD_DIGNOSTICO_P text, NM_TABELA_P text, NM_USUARIO_P text, IE_TIPO_DIAG_P bigint DEFAULT NULL, IE_CIAP_INSERIR_LISTA_P text DEFAULT 'N', IE_IMPORTADO_HIST_P text DEFAULT 'N', DS_DESCRICAO_PROBLEMA_P text DEFAULT NULL, DT_INICIO_P timestamp DEFAULT NULL, NR_SEQ_PROBLEMA_P bigint DEFAULT NULL, IE_MAIN_ENC_PROBL_P text DEFAULT NULL, NR_SEQ_ATEND_CONS_PEPA_P ATEND_CONSULTA_PEPA.NR_SEQUENCIA%TYPE default null) AS $body$
DECLARE


nr_seq_problema_w		bigint;
cd_pessoa_fisica_w		varchar(10);
qt_reg_w				bigint := 0;
C01						integer;
ds_sql_w				varchar(255);
retorno_w				integer;
nm_atributo_inf_w		varchar(100);
qt_ponto_w				bigint;
ie_tipo_problema_w		varchar(10);
ds_problema_w			varchar(255);
ie_nivel_atencao_w		varchar(1);
nr_seq_soap_w			bigint;
cd_profissional_w		varchar(10);
ie_existe_w				varchar(1) := 'N';
ie_tipo_atendimento_w	smallint;
ie_tipo_evolucao_w		varchar(3)	;
ie_tipo_registro_w		varchar(3);
ds_problema_histo_w		varchar(255);

ds_classificacao_w		varchar(255);
ds_tipo_w				varchar(255);
dt_inicio_w				timestamp;

nr_seq_tipo_hist_w		tipo_historico_saude.nr_sequencia%type;


BEGIN

commit;

ie_tipo_registro_w := ie_tipo_registro_p;

If (NM_TABELA_P = 'DIAGNOSTICO_DOENCA') then

	ie_tipo_registro_w := 'DM';
	
elsif (coalesce(IE_ESCALA_P,0) > 0) then

	ie_tipo_registro_w := 'EI';
	
end if;

Select  max(wheb_assist_pck.get_nivel_atencao_perfil),
		max(obter_tipo_atendimento(nr_Atendimento_p)),
		max(obter_funcao_usuario(nm_usuario_p))
into STRICT	ie_nivel_atencao_w,
		ie_tipo_atendimento_w,
		ie_tipo_evolucao_w
;


if (ie_tipo_registro_w = 'EI') and (coalesce(ie_escala_p,0) > 0) then

	select	max(c.nr_sequencia)
	into STRICT	qt_reg_w
	from	cad_lista_problema_item a,
			vice_escala b,
			cad_lista_problema c
	where	a.nr_seq_escala = b.nr_sequencia
	and		c.nr_sequencia = a.nr_seq_lista
	and		ie_tipo_lista = ie_tipo_registro_w
	and		b.ie_escala = ie_escala_p
	and		coalesce(c.cd_estabelecimento, obter_estabelecimento_ativo) 	= obter_estabelecimento_ativo
	and		coalesce(c.cd_perfil, obter_perfil_ativo) 					= obter_perfil_ativo
	and		coalesce(c.cd_setor_atendimento, obter_setor_ativo) 			= obter_setor_ativo
	and		coalesce(c.ie_tipo_atendimento, ie_tipo_atendimento_w) 		= ie_tipo_atendimento_w
	and		coalesce(c.ie_tipo_evolucao, ie_tipo_evolucao_w) 			= ie_tipo_evolucao_w
	and		coalesce(c.ie_situacao,'A') = 'A'
	and 	coalesce(b.ds_function::text, '') = '';

	if (qt_reg_w > 0) then
		
		select	max(nm_atributo_inf)
		into STRICT	nm_atributo_inf_w
		from	cad_lista_problema_item a,
				vice_escala b
		where	a.nr_seq_escala = b.nr_sequencia
		and		ie_tipo_lista = ie_tipo_registro_w
		and		b.ie_escala = ie_escala_p
		and 	coalesce(b.ds_function::text, '') = '';
		
		ds_sql_w := ' select ' || nm_atributo_inf_w || ' qt_ponto from ' || nm_tabela_p || ' where nr_sequencia = ' || nr_seq_reg_p;
		
		C01 := DBMS_SQL.OPEN_CURSOR;
		
		DBMS_SQL.PARSE(C01, ds_sql_w, dbms_sql.Native);
		
		DBMS_SQL.DEFINE_COLUMN(C01, 1, qt_ponto_w);
		
		retorno_w := DBMS_SQL.execute(C01);
		
		if (DBMS_SQL.FETCH_ROWS(C01) > 0 ) then
			DBMS_SQL.COLUMN_VALUE(C01, 1, qt_ponto_w);
		end if;
		
		DBMS_SQL.CLOSE_CURSOR(C01);

		select	max(c.nr_sequencia)
		into STRICT	qt_reg_w
		from	cad_lista_problema_item a,
				vice_escala b,
				cad_lista_problema c
		where	a.nr_seq_escala = b.nr_sequencia
		and		c.nr_sequencia = a.nr_seq_lista
		and		ie_tipo_lista = ie_tipo_registro_w
		and		b.ie_escala = ie_escala_p
		and		qt_ponto_w between vl_minimo and vl_maximo
		and		coalesce(c.cd_estabelecimento, obter_estabelecimento_ativo) 	= obter_estabelecimento_ativo
		and		coalesce(c.cd_perfil, obter_perfil_ativo) 					= obter_perfil_ativo
		and		coalesce(c.cd_setor_atendimento, obter_setor_ativo) 			= obter_setor_ativo
		and		coalesce(c.ie_tipo_atendimento, ie_tipo_atendimento_w) 			= ie_tipo_atendimento_w
		and		coalesce(c.ie_tipo_evolucao, ie_tipo_evolucao_w) 			= ie_tipo_evolucao_w
		and		coalesce(c.ie_situacao,'A') = 'A';
		
		select	max(a.ds_titulo_problema)
		into STRICT 	ds_problema_w
		from	vice_escala b,
				cad_lista_problema_item a
		where	a.nr_seq_escala = b.nr_sequencia
		and 	ie_escala	= ie_escala_p;

	 end if;
		
elsif (ie_tipo_registro_w = 'DM') and (coalesce(nr_seq_reg_p,0) > 0) then

		
		select	max(c.nr_sequencia)
		into STRICT	qt_reg_w
		from	cad_lista_problema_item a,				
				cad_lista_problema c
		where	c.nr_sequencia = a.nr_seq_lista
		and		a.ie_tipo_lista = ie_tipo_registro_p
		and		((coalesce(a.cd_doenca,cd_dignostico_p) = cd_dignostico_p) or (coalesce(a.ie_todos_diag,'N') = 'S'))
		and		coalesce(a.ie_tipo_diagnostico,ie_tipo_diag_p) = ie_tipo_diag_p
		and		coalesce(c.cd_estabelecimento, obter_estabelecimento_ativo) 	= obter_estabelecimento_ativo
		and		coalesce(c.cd_perfil, obter_perfil_ativo) 					= obter_perfil_ativo
		and		coalesce(c.cd_setor_atendimento, obter_setor_ativo) 			= obter_setor_ativo
		and		coalesce(c.ie_tipo_atendimento, ie_tipo_atendimento_w) 			= ie_tipo_atendimento_w
		and		coalesce(c.ie_tipo_evolucao, ie_tipo_evolucao_w) 			= ie_tipo_evolucao_w
		and		coalesce(c.ie_situacao,'A') = 'A';
		
		ie_tipo_problema_w := cd_dignostico_p;

elsif (ie_tipo_registro_w = 'DE') and (coalesce(nr_seq_reg_p,0) > 0) then

		
		select	max(c.nr_sequencia)
		into STRICT	qt_reg_w
		from	cad_lista_problema_item a,				
				cad_lista_problema c
		where	c.nr_sequencia = a.nr_seq_lista
		and		a.ie_tipo_lista = ie_tipo_registro_p
		and		((coalesce(a.nr_seq_diag_enf,cd_dignostico_p) = cd_dignostico_p) or (coalesce(a.ie_todos_diag_enf,'N') = 'S'))
		and		coalesce(c.cd_estabelecimento, obter_estabelecimento_ativo) 	= obter_estabelecimento_ativo
		and		coalesce(c.cd_perfil, obter_perfil_ativo) 					= obter_perfil_ativo
		and		coalesce(c.cd_setor_atendimento, obter_setor_ativo) 			= obter_setor_ativo
		and		coalesce(c.ie_tipo_atendimento, ie_tipo_atendimento_w) 			= ie_tipo_atendimento_w
		and		coalesce(c.ie_tipo_evolucao, ie_tipo_evolucao_w) 			= ie_tipo_evolucao_w
		and		coalesce(c.ie_situacao,'A') = 'A';
		
		ie_tipo_problema_w := cd_dignostico_p;
		
elsif (ie_tipo_registro_w = 'CP')  and (coalesce(nr_seq_reg_p,0) > 0) then		
		
		select	max(c.nr_sequencia)
		into STRICT	qt_reg_w
		from	cad_lista_problema_item a,				
				cad_lista_problema c
		where	c.nr_sequencia = a.nr_seq_lista
		and		a.ie_tipo_lista = 'CP'
		and		((coalesce(a.cd_ciap,cd_dignostico_p) = cd_dignostico_p) or (coalesce(a.ie_todos_ciap,'N') = 'S'))
		and		coalesce(c.cd_estabelecimento, obter_estabelecimento_ativo) 	= obter_estabelecimento_ativo
		and		coalesce(c.cd_perfil, obter_perfil_ativo) 					= obter_perfil_ativo
		and		coalesce(c.cd_setor_atendimento, obter_setor_ativo) 			= obter_setor_ativo
		and		coalesce(c.ie_tipo_atendimento, ie_tipo_atendimento_w) 			= ie_tipo_atendimento_w
		and		coalesce(c.ie_tipo_evolucao, ie_tipo_evolucao_w) 			= ie_tipo_evolucao_w
		and		coalesce(c.ie_situacao,'A') = 'A';
		
		ie_tipo_problema_w := cd_dignostico_p;
		
elsif (ie_tipo_registro_w = 'HS') then

		select	max(nr_seq_tipo_hist)
		into STRICT	nr_seq_tipo_hist_w
		from	historico_saude
		where	nr_sequencia = cd_dignostico_p;
			
						
		ie_tipo_problema_w := cd_dignostico_p;
		
		if (nm_tabela_p = 'PACIENTE_HABITO_VICIO') then
		
			select  max(substr(obter_valor_dominio(1335,ie_classificacao),1,60)),
					max(substr(obter_desc_tipo_vicio(NR_SEQ_TIPO),1,80)),
					max(dt_inicio)
			into STRICT 	ds_classificacao_w,
					ds_tipo_w,
					dt_inicio_w
			from 	paciente_habito_vicio
			where 	nr_sequencia = nr_seq_problema_p;
			
			if (ds_classificacao_w IS NOT NULL AND ds_classificacao_w::text <> '') then
				
				ds_problema_histo_w := ds_classificacao_w||' '||ds_tipo_w;
			
			end if;
		
		
		end if;
			
end if;


			
if ( qt_reg_w > 0 or ie_ciap_inserir_lista_p = 'S') then

		select	max(cd_pessoa_fisica),
				max(obter_consulta_soap(nr_atendimento,cd_profissional_w))
		into STRICT	cd_pessoa_fisica_w,
				nr_seq_soap_w
		from	atendimento_paciente
		where	nr_atendimento = nr_atendimento_p;


	if ( ie_tipo_registro_w = 'DM') then	
	
		Select 	coalesce(max('S'),'N')
		into STRICT	ie_existe_w
		from 	lista_problema_pac
		where	cd_doenca	=	cd_dignostico_p
		and		cd_pessoa_fisica = cd_pessoa_fisica_w
		and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
		and		coalesce(dt_fim,clock_timestamp()) >= clock_timestamp()
		and		coalesce(ie_situacao,'A') = 'A';
		
	elsif (ie_tipo_registro_w = 'CP') then

		Select 	coalesce(max('S'),'N')
		into STRICT	ie_existe_w
		from 	lista_problema_pac
		where	cd_ciap	=	cd_dignostico_p
		and		cd_pessoa_fisica = cd_pessoa_fisica_w
		and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
		and		coalesce(dt_fim,clock_timestamp()) >= clock_timestamp()
		and		coalesce(ie_situacao,'A') = 'A';

	
	
	elsif (ie_tipo_registro_w = 'HS') then

		Select 	coalesce(max('S'),'N')
		into STRICT	ie_existe_w
		from 	lista_problema_pac
		where	nr_seq_historico	=	cd_dignostico_p
		and		nr_seq_tipo_hist	=	nr_seq_tipo_hist_w
		and		cd_pessoa_fisica = cd_pessoa_fisica_w
		and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
		and		coalesce(dt_fim,clock_timestamp()) >= clock_timestamp()
		and		coalesce(ie_situacao,'A') = 'A';
		
	elsif (ie_tipo_registro_w = 'EI') then
	
		Select 	coalesce(max('S'),'N')
		into STRICT	ie_existe_w
		from 	lista_problema_pac a,
				lista_problema_pac_item b
		where	b.nr_seq_problema = a.nr_sequencia
		and		cd_pessoa_fisica = cd_pessoa_fisica_w
		and		upper(b.nm_tabela) = upper(NM_TABELA_P)
		and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
		and		coalesce(a.dt_fim,clock_timestamp()) >= clock_timestamp()
		and		coalesce(a.ie_situacao,'A') = 'A';

				
	end if;
	
	if ( ie_existe_w = 'N') then
	
		Select  max(b.ds_problema)
		into STRICT	ds_problema_w
		from 	cad_lista_problema a,
				cadastro_problema b
		where	a.nr_sequencia = coalesce(qt_reg_w,0)
		and		b.nr_sequencia = a.nr_Seq_regra;
	
		select	nextval('lista_problema_pac_seq'),
				obter_pf_usuario(nm_usuario_p,'C')
		into STRICT	nr_seq_problema_w,
				cd_profissional_w
		;
		
			
		if (coalesce(ds_problema_w::text, '') = '')then
			Select 	obter_desc_problema(ie_tipo_registro_p,ie_tipo_problema_w, nm_tabela_p)
			into STRICT	ds_problema_w
			;
		end if;
		
		
		
		insert into lista_problema_pac(	nr_sequencia,
											dt_atualizacao,
											dt_atualizacao_nrec,
											nm_usuario,
											nm_usuario_nrec,
											cd_pessoa_fisica,
											nr_atendimento,
											dt_inicio,
											ds_problema,
											ie_situacao,
											ie_nivel_atencao,
											nr_seq_soap,
											cd_medico,
											ie_intensidade,
											ie_importado_historico,
											dt_liberacao,
                      ie_main_enc_probl,
                      nr_seq_atend_cons_pepa)
								values (		nr_seq_problema_w,
											clock_timestamp(),
											clock_timestamp(),
											nm_usuario_p,
											nm_usuario_p,
											cd_pessoa_fisica_w,
											nr_atendimento_p,
											coalesce(dt_inicio_w,coalesce(dt_inicio_p,clock_timestamp())),
											coalesce(ds_problema_histo_w,coalesce(ds_descricao_problema_p,ds_problema_w)),
											'A',
											ie_nivel_atencao_w,
											nr_seq_soap_w,
											cd_profissional_w,
											'L',
											ie_importado_hist_p,
											clock_timestamp(),
                      ie_main_enc_probl_p,
                      nr_seq_atend_cons_pepa_p);
		commit;
		
		if (ie_tipo_registro_w = 'DM') then	
			update	lista_problema_pac
			set		cd_doenca	=	cd_dignostico_p
			where	nr_sequencia	=	nr_seq_problema_w;		
		elsif (ie_tipo_registro_w = 'CP') then	
			update	lista_problema_pac
			set		cd_ciap	=	cd_dignostico_p
			where	nr_sequencia	=	nr_seq_problema_w;	
		elsif (ie_tipo_registro_w = 'HS') then		
			update	lista_problema_pac
			set		nr_seq_historico	=	cd_dignostico_p,
					nr_seq_tipo_hist	=	nr_seq_tipo_hist_w
			where	nr_sequencia	=	nr_seq_problema_w;	
			
		end if;
		
		insert into lista_problema_pac_item(	nr_sequencia,
												dt_atualizacao,
												dt_atualizacao_nrec,
												nm_usuario,
												nm_usuario_nrec,
												nr_seq_problema,
												nr_seq_registro,
												ie_tipo_registro,
												nm_tabela,
												ie_tipo_problema,
												nr_seq_tipo_hist)
									values (		nextval('lista_problema_pac_item_seq'),
												clock_timestamp(),
												clock_timestamp(),
												nm_usuario_p,
												nm_usuario_p,
												nr_seq_problema_w,
												nr_seq_reg_p,
												ie_tipo_registro_p,
												nm_tabela_p,
												ie_tipo_problema_w,
												nr_seq_tipo_hist_w);

		commit;
		
		CALL gerar_especialidade_problema(nr_seq_problema_w,cd_pessoa_fisica_w,nm_usuario_p,1,'S');
		
		
	end if;
	
end if;
		

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_lista_problema ( NR_ATENDIMENTO_P bigint, IE_TIPO_REGISTRO_P text, IE_ESCALA_P bigint, NR_SEQ_REG_P bigint, CD_DIGNOSTICO_P text, NM_TABELA_P text, NM_USUARIO_P text, IE_TIPO_DIAG_P bigint DEFAULT NULL, IE_CIAP_INSERIR_LISTA_P text DEFAULT 'N', IE_IMPORTADO_HIST_P text DEFAULT 'N', DS_DESCRICAO_PROBLEMA_P text DEFAULT NULL, DT_INICIO_P timestamp DEFAULT NULL, NR_SEQ_PROBLEMA_P bigint DEFAULT NULL, IE_MAIN_ENC_PROBL_P text DEFAULT NULL, NR_SEQ_ATEND_CONS_PEPA_P ATEND_CONSULTA_PEPA.NR_SEQUENCIA%TYPE default null) FROM PUBLIC;
