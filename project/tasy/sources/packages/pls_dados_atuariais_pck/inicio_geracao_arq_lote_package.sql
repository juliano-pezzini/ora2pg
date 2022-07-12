-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_dados_atuariais_pck.inicio_geracao_arq_lote ( lote_atuarial_p INOUT lote_atuarial, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Inicializa a geracao do arquivo do lote, aqui apenas as informacoes "genericas" devem ser alteradas

-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
		Essa rotina apenas "marca" a geracao do arquivo como inicializado, independente do
		tipo de arquivo do lote, portanto nao deve ser inclusos outras regras
		de negocio aqui
	
Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


BEGIN

-- Registra a data no record

lote_atuarial_p.dt_inicio_arquivo := clock_timestamp();
lote_atuarial_p.dt_fim_arquivo := null;
lote_atuarial_p.ie_status := '6';

-- atualiza as datas no banco

update	pls_atuarial_lote
set	dt_inicio_arquivo	= lote_atuarial_p.dt_inicio_arquivo,
	dt_fim_arquivo		= lote_atuarial_p.dt_fim_arquivo,
	dt_atualizacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p
where	nr_sequencia		= lote_atuarial_p.nr_sequencia;

-- atualiza o status 3 - Geracao de arquivo

CALL CALL pls_dados_atuariais_pck.alterar_status_lote(lote_atuarial_p.nr_sequencia, lote_atuarial_p.ie_status, '', nm_usuario_p);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_dados_atuariais_pck.inicio_geracao_arq_lote ( lote_atuarial_p INOUT lote_atuarial, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;