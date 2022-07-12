-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_cargas_pck.carregar_dados ( nr_seq_cg_lote_p pls_cg_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type ) AS $body$
DECLARE

					
ie_valido_w	varchar(5);
					

BEGIN
-- 1. Carregar variaveis

CALL pls_cargas_pck.carregar_variaveis( nr_seq_cg_lote_p, null, nm_usuario_p );

-- Verificar se o select da view esta valido

select	coalesce(max(ie_valido),'N')
into STRICT	ie_valido_w
from	pls_cg_view_ref
where	nr_seq_regra	= nr_seq_regra_w;

if (ie_valido_w = 'N') then
	-- O select da view nao foi validado, favor utilizar a opcao de validacao no cadastro da regra.

	CALL wheb_mensagem_pck.exibir_mensagem_abort(685743);
end if;

-- 2. Criar view para carga

CALL pls_cargas_pck.criar_view();

-- Gravar tempo inicio

CALL pls_cargas_pck.gravar_tempo('II');

-- 3. Importar dados

CALL pls_cargas_pck.importar_dados();

-- Gravar tempo final

CALL pls_cargas_pck.gravar_tempo('IF');
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cargas_pck.carregar_dados ( nr_seq_cg_lote_p pls_cg_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type ) FROM PUBLIC;
