-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_ajustar_pagador_fin () AS $body$
DECLARE


nr_seq_pagador_w			bigint;
nr_seq_forma_cobranca_w			varchar(2);
nr_seq_conta_banco_w			bigint;
cd_banco_w				integer;
cd_agencia_bancaria_w			varchar(8);
ie_digito_agencia_w			varchar(1);
cd_conta_w				varchar(20);
ie_digito_conta_w			varchar(2);
nm_usuario_w				varchar(30);
dt_dia_vencimento_w			smallint;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		coalesce(nr_seq_forma_cobranca,'1'),
		nr_seq_conta_banco,
		cd_banco,
		cd_agencia_bancaria,
		ie_digito_agencia,
		cd_conta,
		ie_digito_conta,
		nm_usuario,
		coalesce(dt_dia_vencimento,10)
	from	pls_contrato_pagador;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_pagador_w,
	nr_seq_forma_cobranca_w,
	nr_seq_conta_banco_w,
	cd_banco_w,
	cd_agencia_bancaria_w,
	ie_digito_agencia_w,
	cd_conta_w,
	ie_digito_conta_w,
	nm_usuario_w,
	dt_dia_vencimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	insert into pls_contrato_pagador_fin(	nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
						nm_usuario_nrec, nr_seq_pagador, nr_seq_forma_cobranca, dt_inicio_vigencia,
						dt_fim_vigencia, cd_banco, nr_seq_conta_banco, cd_agencia_bancaria,
						ie_digito_agencia, cd_conta, ie_digito_conta, dt_dia_vencimento)
					values (	nextval('pls_contrato_pagador_fin_seq'), clock_timestamp(), nm_usuario_w, clock_timestamp(),
						nm_usuario_w, nr_seq_pagador_w, nr_seq_forma_cobranca_w, to_date('01/01/1999'),
						null, cd_banco_w, nr_seq_conta_banco_w, cd_agencia_bancaria_w,
						ie_digito_agencia_w, cd_conta_w, ie_digito_conta_w, dt_dia_vencimento_w);
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ajustar_pagador_fin () FROM PUBLIC;
