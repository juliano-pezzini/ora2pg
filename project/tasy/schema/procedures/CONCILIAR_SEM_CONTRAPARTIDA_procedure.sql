-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE conciliar_sem_contrapartida (ds_lista_movto_p text, ds_lista_extrato_p text, nr_seq_conta_p bigint, dt_referencia_p timestamp, nm_usuario_p text) AS $body$
DECLARE


ds_retorno_w			varchar(4000);
ds_lista_extrato_w		varchar(4000);
ds_lista_movto_w		varchar(4000);


BEGIN

ds_lista_extrato_w	:= ',' || replace(replace(trim(both ds_lista_extrato_p), '  ', ' '), ' ', ',') || ',';
ds_lista_movto_w	:= ',' || replace(replace(trim(both ds_lista_movto_p), '  ', ' '), ' ', ',') || ',';

if (coalesce(nr_seq_conta_p,0) > 0) and (dt_referencia_p IS NOT NULL AND dt_referencia_p::text <> '') then

	if (trunc(dt_referencia_p, 'dd') > trunc(clock_timestamp(), 'dd') - 30) then
		/* A data de referência não pode ser maior que 30 dias atrás! */

		CALL wheb_mensagem_pck.exibir_mensagem_abort(262111);
	end if;

	update	movto_trans_financ
	set	ie_conciliacao		= 'S',
		nm_usuario		= nm_usuario_p
	where	trunc(dt_transacao, 'dd')	<= trunc(dt_referencia_p, 'dd')
	and	nr_seq_saldo_banco in (SELECT	nr_sequencia
			from	banco_saldo
			where	nr_seq_conta	= nr_seq_conta_p);

else

	update	movto_trans_financ
	set	ie_conciliacao		= 'S',
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	ds_lista_movto_w	like '%,' || nr_sequencia || ',%';

	delete from concil_banc_pend_tasy
	where  ds_lista_movto_w		like '%,' || nr_seq_movto_trans || ',%';

	update	banco_extrato_lanc
	set	ie_conciliacao		= 'S',
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	ds_lista_extrato_w	like '%,' || nr_sequencia || ',%';

	delete	from concil_banc_pend_bco
	where	ds_lista_extrato_w	like '%,' || nr_seq_lanc_extrato || ',%';

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE conciliar_sem_contrapartida (ds_lista_movto_p text, ds_lista_extrato_p text, nr_seq_conta_p bigint, dt_referencia_p timestamp, nm_usuario_p text) FROM PUBLIC;
