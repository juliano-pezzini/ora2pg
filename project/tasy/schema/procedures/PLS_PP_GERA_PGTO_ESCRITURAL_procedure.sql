-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_pp_gera_pgto_escritural ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


qt_registros_w		integer;


BEGIN

-- faz as verificações necessárias
CALL pls_pp_gerar_titulo_pck.valida_se_pode_gerar_escrit(	nr_seq_lote_p);

-- carrega os parâmetros
CALL pls_pp_lote_pagamento_pck.carrega_parametros(	nr_seq_lote_p, cd_estabelecimento_p);

-- alimenta a tabela dos prestadores
CALL pls_pp_lote_pagamento_pck.alimenta_prestadores_tab_temp(pls_pp_lote_pagamento_pck.dt_referencia_lote_fim_w);

-- gera o pagamento escritural
CALL pls_pp_gerar_titulo_pck.gerar_pgto_escritural_lote(	nr_seq_lote_p, cd_estabelecimento_p, nm_usuario_p);

select 	count(1)
into STRICT	qt_registros_w
from	banco_escritural
where	nr_seq_pp_lote = nr_seq_lote_p;

-- se não gerou nenhum registro escritural apresenta mensagem ao usuário
if (qt_registros_w = 0) then
	-- Não foi gerado nenhuma informação no pagamento escritural, por favor verifique as regras de pagamento por prestador na pasta Regras > Pagamento prestador.
	CALL wheb_mensagem_pck.exibir_mensagem_abort(496841);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_gera_pgto_escritural ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

