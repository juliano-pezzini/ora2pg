-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_movto_banco_pend (nr_seq_movto_pend_p bigint, nr_seq_trans_financ_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w	bigint;


BEGIN

select	nextval('movto_trans_financ_seq')
into STRICT	nr_sequencia_w
;

insert	into movto_trans_financ(dt_atualizacao,
	dt_transacao,
	ie_conciliacao,
	nm_usuario,
	nr_lote_contabil,
	nr_seq_banco,
	nr_seq_trans_financ,
	nr_sequencia,
	vl_transacao,
	vl_transacao_estrang,
	vl_complemento,
	vl_cotacao,
	cd_moeda)
SELECT	clock_timestamp(),
	a.dt_credito,
	'N',
	nm_usuario_p,
	0,
	a.nr_seq_conta_banco,
	nr_seq_trans_financ_p,
	nr_sequencia_w,
	a.vl_credito,
	CASE WHEN coalesce(a.vl_credito_estrang::text, '') = '' THEN null  ELSE a.vl_credito_estrang END ,
	CASE WHEN coalesce(a.vl_credito_estrang::text, '') = '' THEN null  ELSE (a.vl_credito - a.vl_credito_estrang) END ,
	CASE WHEN coalesce(a.vl_credito_estrang::text, '') = '' THEN null  ELSE a.vl_cotacao END ,
	CASE WHEN coalesce(a.vl_credito_estrang::text, '') = '' THEN null  ELSE a.cd_moeda END
from	movto_banco_pend a
where	a.nr_sequencia	= nr_seq_movto_pend_p;

update	movto_banco_pend
set	nr_seq_movto_trans_fin	= nr_sequencia_w
where	nr_sequencia	= nr_seq_movto_pend_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_movto_banco_pend (nr_seq_movto_pend_p bigint, nr_seq_trans_financ_p bigint, nm_usuario_p text) FROM PUBLIC;
