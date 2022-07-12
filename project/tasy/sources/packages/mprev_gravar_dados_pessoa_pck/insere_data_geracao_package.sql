-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE mprev_gravar_dados_pessoa_pck.insere_data_geracao ( nr_seq_populacao_p bigint, ie_opcao_p text) AS $body$
DECLARE

	ds_sql_w	varchar(2000);	
	
BEGIN	
		if (coalesce(nr_seq_populacao_p,0) <> 0) then		
			case
			-- data inicio geracao			

			when	ie_opcao_p = '1' then
				update	mprev_populacao_alvo	
				set		nm_usuario = wheb_usuario_pck.get_nm_usuario,				
						dt_atualizacao = clock_timestamp(),
						dt_inicio_geracao =	clock_timestamp()
				where	nr_sequencia = nr_seq_populacao_p;
			-- data inicio filtro pessoa	

			when	ie_opcao_p = '2' then 			
				update	mprev_populacao_alvo	
				set		nm_usuario = wheb_usuario_pck.get_nm_usuario,				
						dt_atualizacao = clock_timestamp(),
						dt_inicio_filtro_pessoa	= clock_timestamp()
				where	nr_sequencia = nr_seq_populacao_p;					
			-- data inicio filtro beneficiarios

			when	ie_opcao_p = '3' then
				update	mprev_populacao_alvo	
				set		nm_usuario = wheb_usuario_pck.get_nm_usuario,				
						dt_atualizacao = clock_timestamp(),
						dt_inicio_filtro_benef = clock_timestamp()
				where	nr_sequencia = nr_seq_populacao_p;
			-- data fim filtro beneficiarios				

			when	ie_opcao_p = '4' then
				update	mprev_populacao_alvo	
				set		nm_usuario = wheb_usuario_pck.get_nm_usuario,				
						dt_atualizacao = clock_timestamp(),
						dt_fim_filtro_benef	= clock_timestamp()
				where	nr_sequencia = nr_seq_populacao_p;
			-- data inicio filtro atendimentos

			when	ie_opcao_p = '5' then
				update	mprev_populacao_alvo	
				set		nm_usuario = wheb_usuario_pck.get_nm_usuario,				
						dt_atualizacao = clock_timestamp(),
						dt_inicio_filtro_atend = clock_timestamp()
				where	nr_sequencia = nr_seq_populacao_p;
			-- data fim filtro atendimentos				

			when	ie_opcao_p = '6' then
				update	mprev_populacao_alvo	
				set		nm_usuario = wheb_usuario_pck.get_nm_usuario,				
						dt_atualizacao = clock_timestamp(),
						dt_fim_filtro_atend	= clock_timestamp()
				where	nr_sequencia = nr_seq_populacao_p;
			-- data inicio filtro custo

			when	ie_opcao_p = '7' then
				update	mprev_populacao_alvo	
				set		nm_usuario = wheb_usuario_pck.get_nm_usuario,				
						dt_atualizacao = clock_timestamp(),
						dt_inicio_filtro_custo = clock_timestamp()
				where	nr_sequencia = nr_seq_populacao_p;
			-- data fim filtro custo				

			when	ie_opcao_p = '8' then
				update	mprev_populacao_alvo	
				set		nm_usuario = wheb_usuario_pck.get_nm_usuario,				
						dt_atualizacao = clock_timestamp(),
						dt_fim_filtro_custo	= clock_timestamp()
				where	nr_sequencia = nr_seq_populacao_p;				
			-- data fim filtro pessoa

			when	ie_opcao_p = '9' then
				update	mprev_populacao_alvo	
				set		nm_usuario = wheb_usuario_pck.get_nm_usuario,				
						dt_atualizacao = clock_timestamp(),
						dt_fim_filtro_pessoa = clock_timestamp()
				where	nr_sequencia = nr_seq_populacao_p;
			-- data fim geracao

			when	ie_opcao_p = '10' then
				update	mprev_populacao_alvo	
				set		nm_usuario = wheb_usuario_pck.get_nm_usuario,				
						dt_atualizacao = clock_timestamp(),
						dt_fim_geracao = clock_timestamp()
				where	nr_sequencia = nr_seq_populacao_p;			
			end case;
		end if;	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprev_gravar_dados_pessoa_pck.insere_data_geracao ( nr_seq_populacao_p bigint, ie_opcao_p text) FROM PUBLIC;
