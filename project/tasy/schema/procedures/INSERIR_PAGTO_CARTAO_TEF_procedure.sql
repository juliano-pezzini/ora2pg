-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_pagto_cartao_tef ( nr_seq_caixa_rec_p bigint, nr_seq_movto_cartao_p bigint, nr_seq_bandeira_p bigint, ie_tipo_cartao_p text, vl_transacao_p bigint, vl_desconto_operadora_p bigint, qt_parcela_p bigint, nr_autorizacao_p text, ds_comprovante_p text, nr_seq_trans_caixa_p bigint, nr_seq_forma_pagto_p bigint, dt_integracao_tef_p timestamp, cd_estabelecimento_p bigint, ds_arq_recibo_tef_p text, nm_usuario_p text, nr_nsu_tef_p text default null, numero_cartao_p text default null) AS $body$
DECLARE


nr_seq_movto_w	bigint;


BEGIN

begin
insert into movto_cartao_cr(
	nr_sequencia,
	nm_usuario,
	dt_atualizacao,
	nm_usuario_nrec,
	dt_atualizacao_nrec,
	cd_estabelecimento,
	dt_transacao,
	nr_seq_caixa_rec,
	nr_seq_bandeira,
	ie_tipo_cartao,
	vl_transacao,
	qt_parcela,
	nr_autorizacao,
	ds_comprovante,
	nr_seq_trans_caixa,
	nr_seq_forma_pagto,
	dt_integracao_tef,
	dt_confirmacao_tef,
	ie_situacao,
	ie_lib_caixa,
	dt_liberacao,
	ds_arq_recibo_tef,
	vl_desconto_operadora,
	nr_nsu_tef,
	nr_cartao)
values (nr_seq_movto_cartao_p,
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	cd_estabelecimento_p,
	clock_timestamp(),
	nr_seq_caixa_rec_p,
	nr_seq_bandeira_p,
	ie_tipo_cartao_p,
	vl_transacao_p,
	CASE WHEN qt_parcela_p=0 THEN  1  ELSE qt_parcela_p END ,
	nr_autorizacao_p,
	ds_comprovante_p,
	nr_seq_trans_caixa_p,
	CASE WHEN nr_seq_forma_pagto_p=0 THEN  null  ELSE nr_seq_forma_pagto_p END ,
	clock_timestamp(),
	clock_timestamp(),
	'A',
	'N',
	clock_timestamp(),
	ds_arq_recibo_tef_p,
	coalesce(vl_desconto_operadora_p,0),
	nr_nsu_tef_p,
	numero_cartao_p);

CALL gerar_cartao_cr_parcela(nr_seq_movto_cartao_p,nm_usuario_p,null);

gerar_classif_cartao_cr(nr_seq_movto_cartao_p,nm_usuario_p);

exception
	when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(265712,'chr(13)='||chr(13)||' sqlerrm= '||sqlerrm);
end;

commit;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_pagto_cartao_tef ( nr_seq_caixa_rec_p bigint, nr_seq_movto_cartao_p bigint, nr_seq_bandeira_p bigint, ie_tipo_cartao_p text, vl_transacao_p bigint, vl_desconto_operadora_p bigint, qt_parcela_p bigint, nr_autorizacao_p text, ds_comprovante_p text, nr_seq_trans_caixa_p bigint, nr_seq_forma_pagto_p bigint, dt_integracao_tef_p timestamp, cd_estabelecimento_p bigint, ds_arq_recibo_tef_p text, nm_usuario_p text, nr_nsu_tef_p text default null, numero_cartao_p text default null) FROM PUBLIC;
