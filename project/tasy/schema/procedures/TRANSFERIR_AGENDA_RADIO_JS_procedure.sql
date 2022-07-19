-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE transferir_agenda_radio_js (nr_seq_origem_p bigint, nr_seq_destino_p bigint, ie_acao_p text, cd_estabelecimento_p bigint, nm_usuario_p text ) AS $body$
DECLARE


ds_erro_w 	varchar(2000) := '';


BEGIN

ds_erro_w := Rxt_Consistir_transf_agenda(nr_seq_origem_p, nr_seq_destino_p, ie_acao_p, cd_estabelecimento_p, nm_usuario_p, 0, ds_erro_w);

if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(261436, 'ERRO='|| ds_erro_w);
end if;

CALL rxt_copiar_transferir_agenda(cd_estabelecimento_p, nr_seq_origem_p, nr_seq_destino_p, ie_acao_p, nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE transferir_agenda_radio_js (nr_seq_origem_p bigint, nr_seq_destino_p bigint, ie_acao_p text, cd_estabelecimento_p bigint, nm_usuario_p text ) FROM PUBLIC;

