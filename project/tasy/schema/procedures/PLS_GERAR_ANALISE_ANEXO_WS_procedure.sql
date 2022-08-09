-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_analise_anexo_ws ( nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type ) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Rotina utilizada para deixar a autorização como Aguardando anexo guia TISS, esta
rotina é utilizada somente para as Solicitações de procedimentos via Webservice
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [   ] Portal [  ]  Relatórios [  x ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
Esta rotina atualiza a análise da guia, deve ser usada somente no WebService
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
C01 CURSOR(	nr_seq_guia_pc	pls_guia_plano.nr_sequencia%type )	FOR
	SELECT	a.nr_sequencia
	from	pls_auditoria a,
		pls_guia_plano b
	where	a.nr_seq_guia 		= b.nr_sequencia
	and	a.nr_seq_guia		= nr_seq_guia_pc
	and	a.ie_status		= 'A'
	and	b.ie_aguarda_anexo_guia = 'S';


C02 CURSOR(	nr_seq_requisicao_pc	pls_requisicao.nr_sequencia%type )	FOR
	SELECT	a.nr_sequencia
	from	pls_auditoria a,
		pls_requisicao b
	where	a.nr_seq_requisicao	= b.nr_sequencia
	and	a.nr_seq_requisicao	= nr_seq_requisicao_pc
	and	a.ie_status		= 'A'
	and	b.ie_aguarda_anexo_guia = 'S';

BEGIN

--Verifica se a análise é da requisição primeiramente
if (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then

	/* Setar o status da análise para 'Aguardando anexo guia TISS' */

	for r_C02_w in C02( nr_seq_requisicao_p ) loop
		update	pls_auditoria
		set	ie_status 	= 'AAG',
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= r_C02_w.nr_sequencia;

		/* Gerar histórico na autorização e na análise */

		CALL pls_requisicao_gravar_hist( 	nr_seq_requisicao_p, 'L', 'Alterado status para Aguardando anexo guia TISS, foi enviado itens sem informar o anexo',
						null, nm_usuario_p );
	end loop;

else
	/* Setar o status da análise para 'Aguardando anexo guia TISS' */

	for r_C01_w in C01( nr_seq_guia_p ) loop
		update	pls_auditoria
		set	ie_status 	= 'AAG',
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= r_C01_w.nr_sequencia;

		/* Gerar histórico na autorização e na análise */

		CALL pls_guia_gravar_historico( 	nr_seq_guia_p, null, 'Alterado status para Aguardando anexo guia TISS, foi enviado itens sem informar o anexo',
						null, nm_usuario_p );
	end loop;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_analise_anexo_ws ( nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type ) FROM PUBLIC;
