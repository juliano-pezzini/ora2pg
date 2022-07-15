-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_titulo_receber_mens_ops ( nr_titulo_p bigint, ie_tipo_mensagem_p text, ds_mensagem_p text, dt_mensagem_p timestamp, cd_usuario_plano_p text, nm_beneficiario_p text, ds_referencia_p text, dt_contratacao_p timestamp, vl_mensagem_p bigint, ds_servico_p text, vl_fator_moderador_p bigint, ds_prestador_p text, ie_tipo_origem_p text, nm_usuario_p text, ie_fator_moderador_p text) AS $body$
DECLARE


nr_seq_origem_mensagem_w	origem_mensagem_tit_pls.nr_sequencia%type;


BEGIN

select	max(a.nr_sequencia)
into STRICT	nr_seq_origem_mensagem_w
from	origem_mensagem_tit_pls a
where	a.ie_tipo_origem	= ie_tipo_origem_p;

insert	into titulo_receber_mens_ops(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	nr_titulo,
	ie_tipo_mensagem,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_origem_mensagem,
	dt_mensagem,
	ds_mensagem,
	cd_usuario_plano,
	nm_beneficiario,
	ds_referencia,
	dt_contratacao,
	ds_servico,
	vl_fator_moderador,
	ds_prestador,
	vl_mensagem,
	ie_fator_moderador)
values (nextval('titulo_receber_mens_ops_seq'),
	clock_timestamp(),
	nm_usuario_p,
	nr_titulo_p,
	ie_tipo_mensagem_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_origem_mensagem_w,
	dt_mensagem_p,
	ds_mensagem_p,
	cd_usuario_plano_p,
	nm_beneficiario_p,
	ds_referencia_p,
	dt_contratacao_p,
	ds_servico_p,
	vl_fator_moderador_p,
	ds_prestador_p,
	vl_mensagem_p,
	ie_fator_moderador_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_titulo_receber_mens_ops ( nr_titulo_p bigint, ie_tipo_mensagem_p text, ds_mensagem_p text, dt_mensagem_p timestamp, cd_usuario_plano_p text, nm_beneficiario_p text, ds_referencia_p text, dt_contratacao_p timestamp, vl_mensagem_p bigint, ds_servico_p text, vl_fator_moderador_p bigint, ds_prestador_p text, ie_tipo_origem_p text, nm_usuario_p text, ie_fator_moderador_p text) FROM PUBLIC;

