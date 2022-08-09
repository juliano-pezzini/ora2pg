-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_exec_processo_guia_imp ( nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_guia_plano_imp_p pls_guia_plano_imp.nr_sequencia%type, nr_seq_guia_plano_p INOUT pls_guia_plano.nr_sequencia%type) AS $body$
DECLARE

					
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Executar o processo de geracao de geracao da guia e consistencia
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_guia_auditoria_w	pls_auditoria.nr_sequencia%type;
nr_seq_guia_plano_w	pls_guia_plano.nr_sequencia%type;


BEGIN

if (nr_seq_guia_plano_imp_p IS NOT NULL AND nr_seq_guia_plano_imp_p::text <> '') then
	--Rotina utilizada para gerar a guia
	nr_seq_guia_plano_w  := pls_gerar_guia_importacao( nm_usuario_p, cd_estabelecimento_p, nr_seq_guia_plano_imp_p, nr_seq_guia_plano_w );
	
	--Atualizar dados do anexo da guia
	CALL pls_atualizar_anexo_guia_imp( nr_seq_guia_plano_imp_p, nr_seq_guia_plano_w,nm_usuario_p);
	
	/*Rotina utilizada para validar se os procedimentos enviados exigem anexo conforme regra criada na funcao
	OPS - Cadastro de Regras / OPS - Atendimento / Regra lancamento anexo guia tiss */
	CALL pls_gerar_regra_anexo_ws(nr_seq_guia_plano_w, null, nm_usuario_p);
	
	/* Realiza a confirmacao do Token */

	CALL pls_confirma_token(null, 'L', nr_seq_guia_plano_w, null, nm_usuario_p, cd_estabelecimento_p);
	
	/* Rotina utilizada para consistir a autorizacao apos confirmar os dados dos campos imp */

	CALL pls_consistir_guia( nr_seq_guia_plano_w, cd_estabelecimento_p, nm_usuario_p);	
	
	/* Rotina utlizada para deixar a Guia em analise com o status 'Aguardando anexo guia TISS'
	deve ser chamada depois de consistir a guia, assim ira atualizar o status da analise e da autorizacao */
	CALL pls_gerar_analise_anexo_ws( nr_seq_guia_plano_w, null, nm_usuario_p);	
	
	nr_guia_auditoria_w	:= pls_obter_se_guia_auditoria( nr_seq_guia_plano_w );
	
	if	((nr_guia_auditoria_w = 0) and (pls_obter_dados_guia_plano(nr_seq_guia_plano_w, null, 'TP') <> 'I')) then
		CALL pls_liberar_guia( nr_seq_guia_plano_w, null, null, 'S', cd_estabelecimento_p, nm_usuario_p, null, null);	
	end if;
end if;

nr_seq_guia_plano_p := nr_seq_guia_plano_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_exec_processo_guia_imp ( nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_guia_plano_imp_p pls_guia_plano_imp.nr_sequencia%type, nr_seq_guia_plano_p INOUT pls_guia_plano.nr_sequencia%type) FROM PUBLIC;
