-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- Gerar dados em producao



CREATE OR REPLACE PROCEDURE pls_cargas_pck.gerar_producao ( nr_seq_cg_lote_p pls_cg_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type ) AS $body$
BEGIN
-- 1. Carregar variaveis

CALL pls_cargas_pck.carregar_variaveis( nr_seq_cg_lote_p, null, nm_usuario_p );

-- Gravar tempo inicio

CALL pls_cargas_pck.gravar_tempo('PI');

-- 3. Gerar dados em producao

if (ie_tipo_carga_w = 'CTA') then -- Contas medicas
	CALL pls_cargas_pck.gerar_prod_cta();
end if;

-- Gravar tempo final

CALL pls_cargas_pck.gravar_tempo('PF');
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cargas_pck.gerar_producao ( nr_seq_cg_lote_p pls_cg_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type ) FROM PUBLIC;