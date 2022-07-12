-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_cartao_integracao_pck.solic_reenvio_pacto_cartao (nr_seq_pagamento_p pls_solic_pagto_cartao_cr.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


        nr_seq_pagador_fin_w pls_solic_pagto_cartao_cr.nr_seq_pagador_fin%type;
        nr_titulo_w          pls_solic_pagto_cartao_cr.nr_titulo%type;
        ds_curta_fatura_w    pls_solic_pagto_cartao_cr.ds_curta_fatura%type;
        nr_seq_solic_atual_w pls_solic_pagto_cartao_cr.nr_sequencia%type;

BEGIN
    
        select nr_seq_pagador_fin,
               nr_titulo,
               ds_curta_fatura
          into STRICT nr_seq_pagador_fin_w,
               nr_titulo_w,
               ds_curta_fatura_w
          from pls_solic_pagto_cartao_cr
         where nr_sequencia = nr_seq_pagamento_p;

        select max(nr_sequencia) into STRICT nr_seq_solic_atual_w from pls_solic_pagto_cartao_cr where nr_titulo = nr_titulo_w;

        if (nr_seq_solic_atual_w <> nr_seq_pagamento_p) then
            CALL wheb_mensagem_pck.exibir_mensagem_abort(1119190, 'NR_TITULO=' || nr_titulo_w);
        end if;

        update pls_solic_pagto_cartao_cr
           set ie_reenviado   = 'S',
               dt_atualizacao = clock_timestamp(),
               nm_usuario     = nm_usuario_p
         where nr_sequencia = nr_seq_pagamento_p;

        CALL pls_cartao_integracao_pck.solic_pacto_cartao(nr_seq_pagador_fin_p => nr_seq_pagador_fin_w,
                           nr_titulo_p          => nr_titulo_w,
                           qt_parcela_p         => 1,
                           ds_curta_fatura_p    => ds_curta_fatura_w,
                           nm_usuario_p         => nm_usuario_p);
    end;

    /*
      Procedimento para definir o ambiente de Homologacao,
      utizado no script de pos clonagem de base
    */


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cartao_integracao_pck.solic_reenvio_pacto_cartao (nr_seq_pagamento_p pls_solic_pagto_cartao_cr.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;