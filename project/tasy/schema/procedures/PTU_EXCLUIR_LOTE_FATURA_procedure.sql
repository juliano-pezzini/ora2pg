-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_excluir_lote_fatura ( nr_seq_lote_p bigint, nm_usuario_p text) AS $body$
DECLARE



nr_seq_lote_w                   bigint;
nr_seq_fatura_w                 bigint;
nr_seq_cobranca_w               bigint;
nr_seq_hospital_w               bigint;

C02 CURSOR FOR
        SELECT  nr_sequencia
        from    ptu_fatura
        where   nr_seq_lote = nr_seq_lote_w;

C03 CURSOR FOR
        SELECT  nr_sequencia
        from    ptu_nota_cobranca
        where   nr_seq_fatura = nr_seq_fatura_w;

C04 CURSOR FOR
        SELECT  nr_sequencia
        from    ptu_nota_hospitalar
        where   nr_seq_nota_cobr = nr_seq_cobranca_w;


BEGIN
select  nr_sequencia
into STRICT    nr_seq_lote_w
from    ptu_lote_fatura_envio
where   nr_sequencia = nr_seq_lote_p;

open C02;
loop
fetch C02 into
	nr_seq_fatura_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	delete from ptu_fatura_historico
	where	nr_seq_fatura = nr_seq_fatura_w;

	update	pls_conta_medica_resumo
	set     nr_seq_fatura  = NULL
	where   nr_seq_fatura = nr_seq_fatura_w
	and	ie_situacao = 'A';

	update	pls_conta
	set     nr_seq_fatura  = NULL
	where   nr_seq_fatura = nr_seq_fatura_w;
	open C03;
	loop
	fetch C03 into
		nr_seq_cobranca_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		delete from ptu_nota_servico where nr_seq_nota_cobr = nr_seq_cobranca_w;

		delete from ptu_nota_complemento where nr_seq_nota_cobr = nr_seq_cobranca_w;

		delete from ptu_nota_fiscal where nr_seq_nota_cobr = nr_seq_cobranca_w;

		open C04;
		loop
		fetch C04 into
			nr_seq_hospital_w;
		EXIT WHEN NOT FOUND; /* apply on C04 */
			begin
			delete from ptu_nota_hosp_compl where nr_seq_nota_hosp = nr_seq_hospital_w;
			end;
		end loop;
		close C04;
		end;
		delete from ptu_nota_hospitalar where nr_seq_nota_cobr = nr_seq_cobranca_w;
	end loop;
	close C03;
	delete from ptu_nota_cobranca where nr_seq_fatura = nr_seq_fatura_w;

	delete from ptu_fatura_boleto where nr_seq_fatura = nr_seq_fatura_w;

	delete from ptu_fatura_boleto where nr_seq_fatura = nr_seq_fatura_w;

	delete from ptu_fatura_corpo where nr_seq_fatura = nr_seq_fatura_w;

	delete from ptu_fatura_cedente where nr_seq_fatura = nr_seq_fatura_w;

	delete from ptu_fatura_conta_exc where nr_seq_fatura = nr_seq_fatura_w;

	update  pls_conta
	set     cd_cooperativa  = NULL
	where   cd_cooperativa = '0';
	end;
end loop;
close C02;

delete from ptu_a500_historico where nr_seq_lote = nr_seq_lote_w;

delete from ptu_fatura where nr_seq_lote = nr_seq_lote_w;

update	ptu_lote_fatura_envio
set	dt_geracao_lote		 = NULL,
	dt_geracao_titulo	 = NULL,
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp()
where	nr_sequencia		= nr_seq_lote_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_excluir_lote_fatura ( nr_seq_lote_p bigint, nm_usuario_p text) FROM PUBLIC;

