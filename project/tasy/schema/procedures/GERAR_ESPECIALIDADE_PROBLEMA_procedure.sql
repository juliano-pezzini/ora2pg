-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_especialidade_problema ( nr_seq_problema_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, nr_sequencia_apres_p bigint default 1, ie_novo_registro_p text default 'S') AS $body$
DECLARE


nr_seq_problema_sup_w		lista_problema_pac.nr_seq_problema_sup%type;
cd_pessoa_profissional_w	pessoa_fisica.cd_pessoa_fisica%type;
cd_especialidade_w			especialidade_medica.cd_especialidade%type;
ie_gerado_w					varchar(5);

nr_sequencia_w				lista_problema_pac.nr_sequencia%type;
nr_sequencia_apres_w		bigint;
nr_seq_especialidade_w		lista_problema_seq_esp.nr_sequencia%type;

											
C01 CURSOR FOR
	SELECT	nr_sequencia
	from	lista_problema_pac
	where	cd_pessoa_fisica = cd_pessoa_fisica_p
	and		coalesce(nr_seq_problema_sup::text, '') = ''
	and		coalesce(ie_status,'1') <> '5'
	order by dt_inicio desc;
	
C02 CURSOR FOR
	SELECT	nr_sequencia
	from	lista_problema_seq_esp
	where	cd_pessoa_fisica = cd_pessoa_fisica_p
	and		cd_especialidade = cd_especialidade_w
	and		coalesce(nr_seq_problema_sup::text, '') = ''
	and		nr_seq_problema <> nr_seq_problema_p
	and		nr_seq_apresentacao >= nr_sequencia_apres_p
	order by nr_seq_apresentacao desc;
										
											

BEGIN


	Select 	max(nr_seq_problema_sup)
	into STRICT	nr_seq_problema_sup_w
	from	lista_problema_pac
	where	nr_sequencia = nr_seq_problema_p;


	Select  max(obter_pf_usuario(nm_usuario_p,'C'))
	into STRICT	cd_pessoa_profissional_w
	;

	Select  max(obter_especialidade_medico(cd_pessoa_profissional_w,'C'))
	into STRICT	cd_especialidade_w
	;

	if (cd_especialidade_w IS NOT NULL AND cd_especialidade_w::text <> '') then

		if ( coalesce(nr_seq_problema_sup_w::text, '') = '' ) then
		
			Select 	coalesce(max('S'),'N')
			into STRICT	ie_gerado_w
			from	lista_problema_seq_esp
			where	cd_pessoa_fisica = cd_pessoa_fisica_p
			and		coalesce(nr_seq_problema_sup::text, '') = ''
			and		cd_especialidade = cd_especialidade_w;
			
			
			if ( ie_gerado_w = 'N') then
			
				nr_sequencia_apres_w := 1;
				
				insert into lista_problema_seq_esp( 	nr_sequencia,
														nm_usuario,
														nm_usuario_nrec,
														dt_atualizacao,
														dt_atualizacao_nrec,
														nr_seq_problema,
														cd_especialidade,
														nr_seq_apresentacao,
														cd_pessoa_fisica)
											values ( 	nextval('lista_problema_seq_esp_seq'),
														nm_usuario_p,
														nm_usuario_p,
														clock_timestamp(),
														clock_timestamp(),
														nr_seq_problema_p,
														cd_especialidade_w,
														coalesce(nr_sequencia_apres_p,1),
														cd_pessoa_fisica_p);
				
			
				open C01;
				loop
				fetch C01 into	
					nr_sequencia_w;
				EXIT WHEN NOT FOUND; /* apply on C01 */
					begin
					
					if (nr_sequencia_apres_w = coalesce(nr_sequencia_apres_p,1)) then
					
						nr_sequencia_apres_w := nr_sequencia_apres_w + 1;
					
					end if;
					
					if ( nr_sequencia_w <> nr_seq_problema_p ) then					
					
						insert into lista_problema_seq_esp( 	nr_sequencia,
													nm_usuario,
													nm_usuario_nrec,
													dt_atualizacao,
													dt_atualizacao_nrec,
													nr_seq_problema,
													cd_especialidade,
													nr_seq_apresentacao,
													cd_pessoa_fisica)
										values ( 	nextval('lista_problema_seq_esp_seq'),
													nm_usuario_p,
													nm_usuario_p,
													clock_timestamp(),
													clock_timestamp(),
													nr_sequencia_w,
													cd_especialidade_w,
													nr_sequencia_apres_w,
													cd_pessoa_fisica_p);
					
					end if;
						
					nr_sequencia_apres_w := nr_sequencia_apres_w + 1;	
										
					end;
				end loop;
				close C01;
				
				commit;
			
			
			else
			
				open C02;
				loop
				fetch C02 into	
					nr_seq_especialidade_w;
				EXIT WHEN NOT FOUND; /* apply on C02 */
					begin
										
					update 	lista_problema_seq_esp
					set		nr_seq_apresentacao  = nr_seq_apresentacao + 1
					where	nr_sequencia = 	nr_seq_especialidade_w;
										
					end;
				end loop;
				close C02;

				
				commit;
				
				if (ie_novo_registro_p = 'S') then
					
					
					insert into lista_problema_seq_esp( 	nr_sequencia,
														nm_usuario,
														nm_usuario_nrec,
														dt_atualizacao,
														dt_atualizacao_nrec,
														nr_seq_problema,
														cd_especialidade,
														nr_seq_apresentacao,
														cd_pessoa_fisica
														)
											values ( 	nextval('lista_problema_seq_esp_seq'),
														nm_usuario_p,
														nm_usuario_p,
														clock_timestamp(),
														clock_timestamp(),
														nr_seq_problema_p,
														cd_especialidade_w,
														coalesce(nr_sequencia_apres_p,1),
														cd_pessoa_fisica_p);

					commit;
				
				
				
				else
				
					update 	lista_problema_seq_esp
					set		nr_seq_apresentacao = coalesce(nr_sequencia_apres_p,1)
					where	cd_pessoa_fisica = cd_pessoa_fisica_p
					and		cd_especialidade = cd_especialidade_w
					and		coalesce(nr_seq_problema_sup::text, '') = ''
					and		nr_seq_problema = nr_seq_problema_p;
					
				
					commit;
				
				end if;
				
			end if;


		else

				update 	lista_problema_seq_esp
				set		nr_seq_apresentacao  = nr_seq_apresentacao + 1
				where	cd_pessoa_fisica = cd_pessoa_fisica_p
				and		cd_especialidade = cd_especialidade_w
				and		(nr_seq_problema_sup IS NOT NULL AND nr_seq_problema_sup::text <> '')
				and		nr_seq_apresentacao >= nr_sequencia_apres_p;
				
				update 	lista_problema_seq_esp
				set		nr_seq_apresentacao = nr_sequencia_apres_p
				where	cd_pessoa_fisica = cd_pessoa_fisica_p
				and		cd_especialidade = cd_especialidade_w
				and		(nr_seq_problema_sup IS NOT NULL AND nr_seq_problema_sup::text <> '')
				and		nr_seq_problema	= nr_seq_problema_p;
				

		end if;
		
		
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_especialidade_problema ( nr_seq_problema_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, nr_sequencia_apres_p bigint default 1, ie_novo_registro_p text default 'S') FROM PUBLIC;
