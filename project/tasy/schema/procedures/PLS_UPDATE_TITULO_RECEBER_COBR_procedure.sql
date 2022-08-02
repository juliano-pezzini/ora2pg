-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_update_titulo_receber_cobr ( nr_sequencia_p bigint, nr_seq_conta_banco_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_banco_w 		bigint;
cd_agencia_bancaria_w	varchar(8);
cd_conta_w 		varchar(20);
ie_digito_conta_w 		varchar(2);


BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (nr_seq_conta_banco_p IS NOT NULL AND nr_seq_conta_banco_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin

	select	cd_banco,
		cd_agencia_bancaria,
		cd_conta,
		coalesce(ie_digito_conta, '0')
	into STRICT	cd_banco_w,
		cd_agencia_bancaria_w,
		cd_conta_w,
		ie_digito_conta_w
	from	banco_estabelecimento_v
	where	nr_sequencia = nr_seq_conta_banco_p;

	update	titulo_receber_cobr
	set	cd_banco 		= cd_banco_w,
		cd_agencia_bancaria 	= cd_agencia_bancaria_w,
		nr_conta		= cd_conta_w,
		ie_digito_conta 	= ie_digito_conta_w,
		nm_usuario		= nm_usuario_p
	where (coalesce(cd_banco::text, '') = '' or coalesce(nr_conta::text, '') = '' or coalesce(cd_agencia_bancaria::text, '') = '')
	and	nr_seq_cobranca = nr_sequencia_p;
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_update_titulo_receber_cobr ( nr_sequencia_p bigint, nr_seq_conta_banco_p bigint, nm_usuario_p text) FROM PUBLIC;

