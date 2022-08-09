-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_inativar_acolhimento ( nr_seq_escuta_p bigint, nm_usuario_p text, ie_opcao_p text, ds_justificativa_p text) AS $body$
DECLARE

 
 
/*	IE_OPCAO_P 
	L			Liberar 
	I			Inativar 
*/
 
 
ie_score_flex_w		varchar(10);
nr_seq_classif_w	escuta_inicial_classif.nr_seq_classif%type;
nr_seq_trig_prio_w	escuta_inicial_classif.nr_seq_triagem_prioridade%type;
nr_atendimento_w	escuta_inicial_classif.nr_atendimento%type;

nr_seq_flexII_w		escala_eif_ii.nr_sequencia%type;


BEGIN 
 
if ( nr_seq_escuta_p > 0) then 
 
	if (ie_opcao_p = 'L') then 
		-- Sintomas  
		 
		update	CIAP_ATENDIMENTO 
		set		nm_usuario		= nm_usuario_p, 
				dt_liberacao	= clock_timestamp(), 
				dt_atualizacao	= clock_timestamp() 
		where	nr_seq_escuta	= nr_seq_escuta_p;
 
		-- Exames físico 
		 
		update	ATENDIMENTO_SINAL_VITAL 
		set		nm_usuario		= nm_usuario_p, 
				dt_liberacao	= clock_timestamp(), 
				dt_atualizacao	= clock_timestamp() 
		where	nr_seq_escuta	= nr_seq_escuta_p;
		 
		update	HISTORICO_SAUDE_MULHER 
		set		nm_usuario		= nm_usuario_p, 
				dt_liberacao	= clock_timestamp(), 
				dt_atualizacao	= clock_timestamp() 
		where	nr_seq_escuta	= nr_seq_escuta_p;
		 
		-- Classificação de risco 
		 
		update	ESCUTA_INICIAL_CLASSIF 
		set		nm_usuario		= nm_usuario_p, 
				dt_liberacao	= clock_timestamp(), 
				dt_atualizacao	= clock_timestamp() 
		where	nr_seq_escuta	= nr_seq_escuta_p;
		 
		update	ESCALA_EIF_II 
		set		nm_usuario		= nm_usuario_p, 
				dt_liberacao	= clock_timestamp(), 
				dt_atualizacao	= clock_timestamp() 
		where	nr_seq_escuta	= nr_seq_escuta_p;
		 
		-- Encaminhamento 
		 
		update	ATEND_ENCAMINHAMENTO 
		set		nm_usuario		= nm_usuario_p, 
				dt_liberacao	= clock_timestamp(), 
				dt_atualizacao	= clock_timestamp() 
		where	nr_seq_escuta	= nr_seq_escuta_p;
		 
		update	ATEND_PROGRAMA_SAUDE 
		set		nm_usuario		= nm_usuario_p, 
				dt_liberacao	= clock_timestamp(), 
				dt_atualizacao	= clock_timestamp() 
		where	nr_seq_escuta	= nr_seq_escuta_p;	
		 
		commit;		
		 
		ie_score_flex_w := obter_param_usuario(281, 1500, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, ie_score_flex_w);	
		if (ie_score_flex_w = 'S') then -- Escore Flex 
			select	max(nr_sequencia) 
			into STRICT	nr_seq_flexII_w 
			from ( 
					SELECT	nr_sequencia 
					from	escala_eif_ii 
					where	nr_seq_escuta = nr_seq_escuta_p 
					order	by dt_atualizacao desc) alias2 LIMIT 1;
		 
			if (nr_seq_flexII_w IS NOT NULL AND nr_seq_flexII_w::text <> '') then 
				CALL atualiza_classif_risco_escala(nr_seq_flexII_w,nm_usuario_p);	
				 
				commit;
			end if;
		else 	-- Classificação de Risco 
			select	max(nr_atendimento), 
					max(nr_seq_classif), 
					max(nr_seq_triagem_prioridade) 
			into STRICT	nr_atendimento_w, 
					nr_seq_classif_w, 
					nr_seq_trig_prio_w		 
			from ( 
					SELECT	nr_atendimento, 
							nr_seq_classif, 
							nr_seq_triagem_prioridade 
					from	escuta_inicial_classif 
					where	nr_seq_escuta	= nr_seq_escuta_p 
					order	by dt_atualizacao desc) alias3 LIMIT 1;
			 
			if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then 
				update	atendimento_paciente 
				set		nr_seq_triagem	= nr_seq_classif_w, 
						nr_seq_triagem_prioridade	= nr_seq_trig_prio_w 
				where	nr_atendimento	= nr_atendimento_w;
				 
				commit;
			end if;
		end if;
		 
		CALL gerar_pendencias_internas_pc(nr_seq_escuta_p, nm_usuario_p);
		 
	elsif (ie_opcao_p = 'I') then	 
		-- Sintomas  
		 
		update	CIAP_ATENDIMENTO 
		set		ie_situacao				=	'I', 
				dt_inativacao			=	clock_timestamp(), 
				ds_justificativa		=	ds_justificativa_p, 
				nm_usuario_inativacao	=	nm_usuario_p				 
		where	nr_seq_escuta			=	nr_seq_escuta_p;
 
		-- Exames físico 
		 
		update	ATENDIMENTO_SINAL_VITAL 
		set		ie_situacao				=	'I', 
				dt_inativacao			=	clock_timestamp(), 
				ds_justificativa		=	ds_justificativa_p, 
				nm_usuario_inativacao	=	nm_usuario_p				 
		where	nr_seq_escuta			=	nr_seq_escuta_p;
		 
		update	HISTORICO_SAUDE_MULHER 
		set		ie_situacao				=	'I', 
				dt_inativacao			=	clock_timestamp(), 
				ds_justificativa		=	ds_justificativa_p, 
				nm_usuario_inativacao	=	nm_usuario_p				 
		where	nr_seq_escuta			=	nr_seq_escuta_p;
		 
		-- Classificação de risco 
		 
		update	ESCUTA_INICIAL_CLASSIF 
		set		ie_situacao				=	'I', 
				dt_inativacao			=	clock_timestamp(), 
				ds_justificativa		=	ds_justificativa_p, 
				nm_usuario_inativacao	=	nm_usuario_p				 
		where	nr_seq_escuta			=	nr_seq_escuta_p;
		 
		update	ESCALA_EIF_II 
		set		ie_situacao				=	'I', 
				dt_inativacao			=	clock_timestamp(), 
				ds_justificativa		=	ds_justificativa_p, 
				nm_usuario_inativacao	=	nm_usuario_p				 
		where	nr_seq_escuta			=	nr_seq_escuta_p;
		 
		-- Encaminhamento 
		 
		update	ATEND_ENCAMINHAMENTO 
		set		ie_situacao				=	'I', 
				dt_inativacao			=	clock_timestamp(), 
				ds_justificativa		=	ds_justificativa_p, 
				nm_usuario_inativacao	=	nm_usuario_p				 
		where	nr_seq_escuta			=	nr_seq_escuta_p;
 
		 
		update	ATEND_PROGRAMA_SAUDE 
		set		ie_situacao				=	'I', 
				dt_inativacao			=	clock_timestamp(), 
				ds_justificativa		=	ds_justificativa_p, 
				nm_usuario_inativacao	=	nm_usuario_p				 
		where	nr_seq_escuta			=	nr_seq_escuta_p;	
		 
		commit;		
	 
	end if;
	 
end if;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_inativar_acolhimento ( nr_seq_escuta_p bigint, nm_usuario_p text, ie_opcao_p text, ds_justificativa_p text) FROM PUBLIC;
