-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


---------------- INICIO DO PROCESSO ----------------------
CREATE OR REPLACE PROCEDURE pls_mov_mens_pck.gerar_lote ( nr_seq_lote_p pls_mov_mens_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

qt_registros_w	integer;

BEGIN
CALL pls_mov_mens_pck.carregar_dados_lote_regra(nr_seq_lote_p);

if (coalesce(current_setting('pls_mov_mens_pck.pls_mov_mens_regra_w')::pls_mov_mens_regra%rowtype.nr_dia_vencimento,0) = 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1076944); --Dia de vencimento não informado na regra utilizada para geração do lote!
end if;

CALL exec_sql_dinamico(nm_usuario_p, 'truncate table pls_mov_mens_temp');

current_setting('pls_mov_mens_pck.pls_mov_mens_lote_w')::pls_mov_mens_lote%rowtype.dt_movimento_inicial	:= trunc(current_setting('pls_mov_mens_pck.pls_mov_mens_lote_w')::pls_mov_mens_lote%rowtype.dt_movimento_inicial,'dd');
current_setting('pls_mov_mens_pck.pls_mov_mens_lote_w')::pls_mov_mens_lote%rowtype.dt_movimento_final		:= fim_dia(current_setting('pls_mov_mens_pck.pls_mov_mens_lote_w')::pls_mov_mens_lote%rowtype.dt_movimento_final);

CALL CALL pls_mov_mens_pck.gerar_dados_temp();

select	count(1)
into STRICT	qt_registros_w
from	pls_mov_mens_temp;

if (qt_registros_w > 0) then
	CALL pls_mov_mens_pck.inserir_mov_operadora(nm_usuario_p,cd_estabelecimento_p);
	CALL pls_mov_mens_pck.inserir_mov_benef(nm_usuario_p,cd_estabelecimento_p);
	CALL pls_mov_mens_pck.inserir_mov_itens(nm_usuario_p,cd_estabelecimento_p);
	
	CALL pls_mov_mens_pck.gerar_vencimentos(nm_usuario_p,cd_estabelecimento_p);
	
	update	pls_mov_mens_lote
	set	dt_geracao_lote	= clock_timestamp(),
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia = nr_seq_lote_p;
else
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1067661); -- 'Não existem informações para gerar o lote.';
end if;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mov_mens_pck.gerar_lote ( nr_seq_lote_p pls_mov_mens_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;