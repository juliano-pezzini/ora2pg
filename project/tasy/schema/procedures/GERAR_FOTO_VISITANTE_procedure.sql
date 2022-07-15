-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_foto_visitante ( nr_cpf_p text, ds_tabela_atual_p text, nr_sequencia_atual_p bigint, dt_acompanhante_p timestamp default clock_timestamp(), nr_sequencia_foto INOUT text DEFAULT NULL) AS $body$
DECLARE


nr_seq_foto_visita_w			atendimento_visita_foto.nr_sequencia%type;
dt_atualizacao_foto_visita_w	atendimento_visita_foto.dt_atualizacao%type;
nr_seq_foto_acomp_w				atendimento_acomp_foto.nr_sequencia%type;
dt_atualizacao_foto_acomp_w		atendimento_visita_foto.dt_atualizacao%type;
im_pessoa_fisica_w				bytea;
nm_usuario_w					atendimento_visita_foto.nm_usuario%type;
qt_dias_w						bigint;


BEGIN

	qt_dias_w := obter_param_usuario(8014, 129, obter_perfil_ativo, obter_usuario_ativo, obter_estabelecimento_ativo, qt_dias_w);
	
	if (ds_tabela_atual_p = 'ATENDIMENTO_VISITA') then
	begin
		select 	max(nr_sequencia),
				max(dt_atualizacao)
		into STRICT 	nr_seq_foto_visita_w,
				dt_atualizacao_foto_visita_w
		from 	atendimento_visita_foto
		where 	trunc(dt_atualizacao) > trunc(clock_timestamp() - qt_dias_w)
		and		nr_seq_atend_visita in (
			SELECT 	nr_sequencia
			from 	atendimento_visita
			where 	nr_identidade = nr_cpf_p);
	end;
	else
	begin	
		select 	max(nr_sequencia),
				max(dt_atualizacao)
		into STRICT 	nr_seq_foto_acomp_w,
				dt_atualizacao_foto_acomp_w
		from 	atendimento_acomp_foto	
		where 	trunc(dt_atualizacao) > trunc(clock_timestamp() - qt_dias_w)
		and 	nr_atendimento in (
			SELECT 	nr_atendimento
			from 	atendimento_paciente
			where 	nr_atendimento in (	
				SELECT 	nr_atendimento
				from 	atendimento_acompanhante
				where 	nr_identidade = nr_cpf_p));
		end;
	end if;
	
	if ( (dt_atualizacao_foto_visita_w IS NOT NULL AND dt_atualizacao_foto_visita_w::text <> '') or (dt_atualizacao_foto_acomp_w IS NOT NULL AND dt_atualizacao_foto_acomp_w::text <> '') ) then
	begin		
		if ((dt_atualizacao_foto_visita_w > dt_atualizacao_foto_acomp_w)
			or (coalesce(dt_atualizacao_foto_acomp_w::text, '') = ''))		then
		begin
			select nextval('atendimento_visita_foto_seq')
			into STRICT nr_sequencia_foto
			;
			
			select 	'00' im_pessoa_fisica,
					nm_usuario
			into STRICT	im_pessoa_fisica_w,
					nm_usuario_w
			from 	atendimento_visita_foto
			where 	nr_sequencia = nr_seq_foto_visita_w  LIMIT 1;
					
			insert into atendimento_visita_foto(
				nr_sequencia,
				im_pessoa_fisica, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				nr_seq_atend_visita)
				values (
				nr_sequencia_foto,
				im_pessoa_fisica_w, 
				clock_timestamp(),
				nm_usuario_w, 
				clock_timestamp(),
				nm_usuario_w, 
				nr_sequencia_atual_p);
				
				copia_campo_long_de_para_java('ATENDIMENTO_VISITA_FOTO',
									'IM_PESSOA_FISICA',
									' WHERE NR_SEQUENCIA = :nr_seq_foto_visita_w',
									'nr_seq_foto_visita_w='||nr_seq_foto_visita_w,									  
									'ATENDIMENTO_VISITA_FOTO',
									'IM_PESSOA_FISICA', 
									' WHERE NR_SEQUENCIA = :nr_sequencia_foto',
									'nr_sequencia_foto='||nr_sequencia_foto,									  
									'LR' );				
		end;			
		else
		begin
			select nextval('atendimento_acomp_foto_seq')
			into STRICT nr_sequencia_foto
			;
			
			select 	'00' im_pessoa_fisica,
					nm_usuario
			into STRICT	im_pessoa_fisica_w,
					nm_usuario_w
			from 	atendimento_acomp_foto 
			where 	nr_sequencia = nr_seq_foto_acomp_w  LIMIT 1;
			
			insert into atendimento_acomp_foto(
				nr_sequencia,
				im_pessoa_fisica, 
				dt_atualizacao, 
				nm_usuario,  
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				nr_atendimento,
				dt_acompanhante)
				values (
				nr_sequencia_foto,
				im_pessoa_fisica_w, 
				clock_timestamp(),
				nm_usuario_w,
                clock_timestamp(),
				nm_usuario_w, 
				nr_sequencia_atual_p,
				dt_acompanhante_p);				

				copia_campo_long_de_para_java('ATENDIMENTO_ACOMP_FOTO',
									'IM_PESSOA_FISICA',
									' WHERE NR_SEQUENCIA = :nr_seq_foto_acomp_w',
									'nr_seq_foto_acomp_w='||nr_seq_foto_acomp_w,									  
									'ATENDIMENTO_ACOMP_FOTO',
									'IM_PESSOA_FISICA', 
									' WHERE NR_SEQUENCIA = :nr_sequencia_foto',
									'nr_sequencia_foto='||nr_sequencia_foto,									  
									'LR' );
		end;	
		end if;
	end;	
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_foto_visitante ( nr_cpf_p text, ds_tabela_atual_p text, nr_sequencia_atual_p bigint, dt_acompanhante_p timestamp default clock_timestamp(), nr_sequencia_foto INOUT text DEFAULT NULL) FROM PUBLIC;

