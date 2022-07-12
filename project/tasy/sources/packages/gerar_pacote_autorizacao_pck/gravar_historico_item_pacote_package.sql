-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--###################################################################
CREATE OR REPLACE PROCEDURE gerar_pacote_autorizacao_pck.gravar_historico_item_pacote ( cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_pacote_p bigint) AS $body$
DECLARE


ds_titulo_w		varchar(255);
ds_historico_w		varchar(4000);
ds_procedimento_w	varchar(255);


BEGIN

select	substr(obter_desc_procedimento(cd_procedimento_p, ie_origem_proced_p),1,255)
into STRICT	ds_procedimento_w
;

 --Item excluído da autorização pela regra de pacotes de autorização
ds_titulo_w	:= wheb_mensagem_pck.get_texto(346798);
/*O item #@ds_item_w#@ foi excluído devido as regras de geração de pacotes de autorização.
Pacote: #@nr_seq_pacote_p#@*/
ds_historico_w	:= wheb_mensagem_pck.get_texto(346803,'ds_item_w='||cd_procedimento_p||' - '||ds_procedimento_w||';nr_seq_pacote_p='||nr_seq_pacote_p);

CALL gravar_autor_conv_log_alter(current_setting('gerar_pacote_autorizacao_pck.nr_sequencia_autor_w')::bigint,ds_titulo_w,substr(ds_historico_w,1,2000),current_setting('gerar_pacote_autorizacao_pck.nm_usuario_w')::varchar(15));

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_pacote_autorizacao_pck.gravar_historico_item_pacote ( cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_pacote_p bigint) FROM PUBLIC;