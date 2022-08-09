-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_conv_status_regulacao ( nr_sequencia_p bigint, nm_tabela_p text, ie_status_p text, nm_usuario_p text, ds_observacao_p text default null, nr_seq_motivo_p bigint default null) AS $body$
DECLARE


	nr_seq_regulacao_w			regulacao_atend.nr_sequencia%type;
	ds_profissional_w			regulacao_status.ds_profissional%type;
	ds_observacao_w				regulacao_status.ds_observacao%type;
	nr_seq_pls_requisicao_w		pls_requisicao.nr_sequencia%type;
	nr_seq_lista_esp_w			agenda_lista_espera.nr_sequencia%type;
	nr_seq_situacao_atual_w		lista_espera_situacao_cont.nr_sequencia%type;


BEGIN

	if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '' AND ie_status_p IS NOT NULL AND ie_status_p::text <> '') then
		
		
		if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
		
			select  obter_nome_usuario(nm_usuario_p)
			into STRICT	ds_profissional_w
			;
		
		end if;
		
		if (nm_tabela_p = 'PEDIDO_EXAME_EXTERNO') then
		
			select	max(nr_sequencia)
			into STRICT	nr_seq_regulacao_w	
			from	regulacao_atend
			where	nr_seq_pedido = nr_sequencia_p;
			
		elsif (nm_tabela_p = 'REGULACAO_ATEND') then
		
			nr_seq_regulacao_w := nr_sequencia_p;
		
		end if;
		
		if (nr_seq_regulacao_w IS NOT NULL AND nr_seq_regulacao_w::text <> '') then
		
			if ( ie_status_p = 'CA' ) then
			
				if ( coalesce(ds_observacao_p::text, '') = '') then
				
					ds_observacao_w := obter_desc_expressao(711471); --Registro inativo
					
				end if;
		
				update	parecer_medico
				set		dt_inativacao = clock_timestamp(),
						nm_usuario_inativacao = nm_usuario_p,
						dt_atualizacao = clock_timestamp(),
						ds_justificativa = ds_observacao_w
				where	nr_seq_regulacao = nr_seq_regulacao_w;
			
				update	WL_WORKLIST
				set		dt_final_real = clock_timestamp(),
						nm_usuario = nm_usuario_p,
						dt_atualizacao = clock_timestamp()
				where	nr_seq_regulacao_atend = nr_seq_regulacao_w;
				
				select 	max(nr_sequencia)
				into STRICT	nr_seq_pls_requisicao_w
				from 	pls_requisicao
				where 	nr_seq_regulacao = nr_seq_regulacao_w;

				update pls_requisicao
				set ie_estagio = 3
				where nr_sequencia = nr_seq_pls_requisicao_w;

				select	max(nr_sequencia)
				into STRICT	nr_seq_lista_esp_w
				from	agenda_lista_espera
				where	nr_seq_regulacao = nr_seq_regulacao_w;

				if (nr_seq_lista_esp_w IS NOT NULL AND nr_seq_lista_esp_w::text <> '') then
					update	agenda_lista_espera
					set		ie_status_espera	= 'C',
							dt_atualizacao		= clock_timestamp(),
							nm_usuario			= nm_usuario_p
					where	nr_sequencia		= nr_seq_lista_esp_w;

					select	max(nr_sequencia)
					into STRICT	nr_seq_situacao_atual_w
					from	lista_espera_situacao_cont
					where	ie_situacao		= 'A'
					and		ie_tipo_contato = 'PD';

					if (nr_seq_situacao_atual_w IS NOT NULL AND nr_seq_situacao_atual_w::text <> '') then
						insert into ag_lista_espera_contato(
							nr_sequencia,
							dt_atualizacao,
							dt_atualizacao_nrec,
							nm_usuario,
							nm_usuario_nrec,
							nr_seq_lista_espera,
							dt_contato,
							ie_origem,
							nm_pessoa_contato,
							nr_seq_situacao_atual,
							ds_observacao,
							dt_liberacao,
							nm_usuario_liberacao,
							ie_contato_realizado
						) values (
							nextval('ag_lista_espera_contato_seq'),
							clock_timestamp(),
							clock_timestamp(),
							nm_usuario_p,
							nm_usuario_p,
							nr_seq_lista_esp_w,
							clock_timestamp(),
							'M',
							ds_profissional_w,
							nr_seq_situacao_atual_w,
							obter_expressao_dic_objeto(1100149),
							clock_timestamp(),
							nm_usuario_p,
							'N'
						);
					end if;

				end if;

			end if;

			CALL Alterar_status_regulacao( nr_seq_regulacao_w, ie_status_p, coalesce(ds_observacao_p,ds_observacao_w), ds_profissional_w ,'S', nr_seq_motivo_p);

			commit;
			
		end if;

	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_conv_status_regulacao ( nr_sequencia_p bigint, nm_tabela_p text, ie_status_p text, nm_usuario_p text, ds_observacao_p text default null, nr_seq_motivo_p bigint default null) FROM PUBLIC;
