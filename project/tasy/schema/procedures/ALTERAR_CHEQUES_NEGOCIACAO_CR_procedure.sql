-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_cheques_negociacao_cr (nr_seq_negociacao_p bigint, cd_banco_p bigint, cd_agencia_bancaria_p text, nr_conta_p text, nr_cheque_inicial_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;
nr_cheque_atual_w	varchar(20);

c01 CURSOR FOR
SELECT	a.nr_sequencia
from	negociacao_cr_cheque a
where	a.nr_seq_negociacao	= nr_seq_negociacao_p
order by
	a.dt_vencimento;


BEGIN
nr_cheque_atual_w	:= nr_cheque_inicial_p;
if (nr_seq_negociacao_p IS NOT NULL AND nr_seq_negociacao_p::text <> '') then
	open c01;
	loop
	fetch c01 into
		nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		update	negociacao_cr_cheque
		set	cd_banco		= coalesce(cd_banco,cd_banco_p),
			cd_agencia_bancaria	= coalesce(cd_agencia_bancaria,cd_agencia_bancaria_p),
			nr_conta		= coalesce(nr_conta,nr_conta_p),
			nr_cheque		= coalesce(nr_cheque,lpad(to_char(nr_cheque_atual_w),length(nr_cheque_inicial_p),0))
		where	nr_sequencia		= nr_sequencia_w;

		nr_cheque_atual_w	:= somente_numero(nr_cheque_atual_w) + 1;
		end;
	end loop;
	close c01;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_cheques_negociacao_cr (nr_seq_negociacao_p bigint, cd_banco_p bigint, cd_agencia_bancaria_p text, nr_conta_p text, nr_cheque_inicial_p text, nm_usuario_p text) FROM PUBLIC;
