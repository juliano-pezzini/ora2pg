-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_excluir_solicitacao_lead ( nr_seq_solicitacao_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_simulacao_preco_w	integer;


BEGIN

select	count(1)
into STRICT	qt_simulacao_preco_w
from	pls_simulacao_preco
where	nr_seq_solicitacao	= nr_seq_solicitacao_p;

if (qt_simulacao_preco_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(291448); --O lead não pode ser excluído, pois já foi gerada simulação de preço. Favor verificar.
end if;

delete	from pls_solicitacao_vendedor
where	nr_seq_solicitacao = nr_seq_solicitacao_p;

delete	FROM pls_solic_vendedor_compl
where	nr_seq_solicitacao = nr_seq_solicitacao_p;

delete	from pls_solicitacao_historico
where	nr_seq_solicitacao = nr_seq_solicitacao_p;

delete	from pls_solicitacao_comercial
where	nr_sequencia = nr_seq_solicitacao_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_excluir_solicitacao_lead ( nr_seq_solicitacao_p bigint, nm_usuario_p text) FROM PUBLIC;
