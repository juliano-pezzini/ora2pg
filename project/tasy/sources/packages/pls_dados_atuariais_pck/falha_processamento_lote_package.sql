-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_dados_atuariais_pck.falha_processamento_lote ( lote_atuarial_p INOUT lote_atuarial, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Marca o lote como falha no processamento, buscando as exceptions gerada pelo pl

-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

	
Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


BEGIN
-- Marca o lote como falha

lote_atuarial_p.ie_status := 5;

CALL CALL pls_dados_atuariais_pck.alterar_status_lote(lote_atuarial_p.nr_sequencia, lote_atuarial_p.ie_status, substr(obter_texto_dic_objeto(881900,null,null)||': '|| sqlerrm ||' CallStack: '||dbms_utility.format_error_backtrace,1,4000) , nm_usuario_p);

CALL pls_dados_atuariais_pck.gravar_log(	lote_atuarial_p.nr_sequencia,
					null, 
					lote_atuarial_p.ie_tipo_arquivo, 
					null, 
					null, 
					sqlerrm ||' '||dbms_utility.format_error_backtrace,
					nm_usuario_p);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_dados_atuariais_pck.falha_processamento_lote ( lote_atuarial_p INOUT lote_atuarial, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;