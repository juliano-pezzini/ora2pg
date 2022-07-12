-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_faturamento_pck.verifica_lote_sem_session ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


--Finalidade:Busca por lotes de faturamento, que foram iniciada a sua geracao, mas por algum 
--	motivo a session da geracao foi interrompida, e os tratamentos de exception nao foram executados.	
--	Quando possuir uma situacao destas, nao sera permitido a geracao de nenhum outro lote, ate a situacao
--	do lote invalido ser resolvida.
nr_seq_lote_w	pls_lote_faturamento.nr_sequencia%type;


BEGIN
-- carrega o sequencial mais recente do lote que foi considerado invalido
nr_seq_lote_w := pls_faturamento_pck.retorna_lote_sem_session(cd_estabelecimento_p);

-- se encontrou algum lote invalido
if (nr_seq_lote_w IS NOT NULL AND nr_seq_lote_w::text <> '') then

	CALL wheb_mensagem_pck.exibir_mensagem_abort(997489, 'LOTE='|| to_char(nr_seq_lote_w));
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_faturamento_pck.verifica_lote_sem_session ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;