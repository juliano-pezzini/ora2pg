-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_imp_xml_cta_pck.pls_imp_nv_log_erro ( nr_seq_protocolo_p pls_protocolo_conta_imp.nr_sequencia%type, nr_seq_mensagem_p pls_mensagem_importacao.nr_seq_mensagem%type, nm_usuario_p usuario.nm_usuario%type, ds_erro_p pls_mensagem_importacao.ds_erro%type) AS $body$
DECLARE

				
	
qt_mensagem_bloqueio_w		bigint;
qt_contas_w 			bigint;
nr_seq_mensagem_import_w	pls_mensagem_importacao.nr_sequencia%type;


BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_mensagem_import_w
from 	pls_mensagem_importacao
where	nr_seq_protocolo_imp = nr_seq_protocolo_p;

if ( coalesce(nr_seq_mensagem_import_w::text, '') = '') then

	/* Salvar a mensagem de erro gerada na importacao de XML */


	insert into pls_mensagem_importacao(
		nr_sequencia, dt_atualizacao,
		nm_usuario, nr_seq_mensagem, ds_erro, nr_seq_protocolo_imp)
	values (nextval('pls_mensagem_importacao_seq'), clock_timestamp(),
		nm_usuario_p, nr_seq_mensagem_p, substr(ds_erro_p,0,2000), nr_seq_protocolo_p);
	
	/* Gerar resumo importacao do XML */


	select	count(1)
	into STRICT	qt_contas_w
	from	pls_conta_imp
	where	nr_seq_protocolo = nr_seq_protocolo_p;

	select	count(1)
	into STRICT	qt_mensagem_bloqueio_w
	from	pls_mensagem_importacao
	where	nr_seq_protocolo_imp = nr_seq_protocolo_p
	and	nr_seq_mensagem in (5014, 5001, 5002, 5012, 5010, 5007);

	insert into pls_resumo_importacao(
		nr_sequencia,nm_usuario, nr_seq_protocolo_imp,
		qt_contas, qt_contas_criticadas, qt_itens_protocolo,
		qt_itens_criticados, qt_mensagens_aviso, qt_mensagens_bloqueio,
		dt_atualizacao, qt_valor_total,	qt_valor_tot_crit)
	values (nextval('pls_resumo_importacao_seq'), nm_usuario_p, nr_seq_protocolo_p,
		qt_contas_w, 0, 0,
		0, 0, qt_mensagem_bloqueio_w,
		clock_timestamp(), 0, 0
	);

else
	/* Atualiza a mensagem de erro gerada na importacao de XML */


	update	pls_mensagem_importacao
	set	dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p,
		nr_seq_mensagem = nr_seq_mensagem_p,
		ds_erro = substr(ds_erro_p,0,2000)
	where	nr_sequencia = nr_seq_mensagem_import_w;

end if;

/* Atualizar estagio do protocolo para Rejeitado devido ao erro gerado */


update	pls_protocolo_conta_imp
set    	ie_situacao = 'RE'
where  	nr_sequencia = nr_seq_protocolo_p;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_xml_cta_pck.pls_imp_nv_log_erro ( nr_seq_protocolo_p pls_protocolo_conta_imp.nr_sequencia%type, nr_seq_mensagem_p pls_mensagem_importacao.nr_seq_mensagem%type, nm_usuario_p usuario.nm_usuario%type, ds_erro_p pls_mensagem_importacao.ds_erro%type) FROM PUBLIC;
