-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_triagem_senha ( NR_SEQ_PAC_SENHA_FILA_P bigint, CD_PESSOA_FISICA_P text, NR_ATENDIMENTO_P bigint, IE_OPCAO_P text, IE_FUNC text DEFAULT 'N', IE_PLATAFORMA_P text DEFAULT 'A') AS $body$
BEGIN

  IF (NR_SEQ_PAC_SENHA_FILA_P IS NOT NULL AND NR_SEQ_PAC_SENHA_FILA_P::text <> '') THEN

    IF (IE_OPCAO_P = 'I')THEN
    
      UPDATE PACIENTE_SENHA_FILA P SET P.CD_PESSOA_FISICA = CD_PESSOA_FISICA_P WHERE P.NR_SEQUENCIA = NR_SEQ_PAC_SENHA_FILA_P;

	  IF (coalesce(IE_PLATAFORMA_P,'A') = 'J') THEN
		CALL GERAR_ATEND_TRIAGEM(NR_ATENDIMENTO_P, WHEB_USUARIO_PCK.get_nm_usuario,IE_FUNC);
	  ELSE
		IF (OBTER_SE_TRIAGEM_SENHA('T') = 'T' OR OBTER_SE_TRIAGEM_SENHA('T') = 'P' ) THEN
			CALL GERAR_ATEND_TRIAGEM(NR_ATENDIMENTO_P, WHEB_USUARIO_PCK.get_nm_usuario,IE_FUNC);
		END IF;
	  END IF;	

    ELSIF (IE_OPCAO_P = 'C') THEN
    
      IF (NR_ATENDIMENTO_P IS NOT NULL AND NR_ATENDIMENTO_P::text <> '') THEN
	  
		DELETE	FROM ATENDIMENTO_PACIENTE_INF
		WHERE	NR_ATENDIMENTO	= NR_ATENDIMENTO_P;

        DELETE FROM ATENDIMENTO_PACIENTE A WHERE 
          A.NR_ATENDIMENTO = NR_ATENDIMENTO_P;
      END IF;

    END IF;

    COMMIT;

  END IF;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_triagem_senha ( NR_SEQ_PAC_SENHA_FILA_P bigint, CD_PESSOA_FISICA_P text, NR_ATENDIMENTO_P bigint, IE_OPCAO_P text, IE_FUNC text DEFAULT 'N', IE_PLATAFORMA_P text DEFAULT 'A') FROM PUBLIC;

