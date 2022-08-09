-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_lote_orgao_cobr ( nr_seq_lote_p text, nm_usuario_p text) AS $body$
DECLARE


ds_historico_w		varchar(255);
dt_fechamento_w		timestamp;
qtd_w				bigint;
nr_sequencia_w		bigint;
ie_tipo_lote_w		varchar(1);
ie_origem_w			varchar(1);

c01 CURSOR FOR
	SELECT	nr_sequencia
	from	cheque_cr_orgao_cobr a
	where (a.nr_seq_lote = nr_seq_lote_p
	or 	a.nr_seq_lote_exc = nr_seq_lote_p)
	
union

	SELECT	nr_sequencia
	from 	titulo_receber_orgao_cobr b
	where (b.nr_seq_lote = nr_seq_lote_p
	or 	b.nr_seq_lote_exc = nr_seq_lote_p)
	
union

	select	nr_sequencia
	from	outros_orgao_cobr c
	where (c.nr_seq_lote = nr_seq_lote_p
	or 	c.nr_seq_lote_exc = nr_seq_lote_p)
	order by 1;


BEGIN

if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '')then

	select	dt_fechamento,
			ie_origem,
			ie_tipo_lote
	into STRICT	dt_fechamento_w,
			ie_origem_w,
			ie_tipo_lote_w
	from	lote_orgao_cobranca
	where	nr_sequencia = nr_seq_lote_p;

	if (dt_fechamento_w IS NOT NULL AND dt_fechamento_w::text <> '') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(683443);
	end if;

	open c01;
	loop
	fetch c01 into
		nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		CALL excluir_cobranca_lote(nr_sequencia_w,ie_origem_w,wheb_usuario_pck.get_nm_usuario,ie_tipo_lote_w);
		end;
	end loop;
	close c01;

	delete from lote_orgao_cobr_aprovacao
	where nr_seq_lote = nr_seq_lote_p;

	delete from lote_orgao_cobr_hist
	where nr_seq_lote = nr_seq_lote_p;

	delete from lote_orgao_cobranca
	where nr_sequencia = nr_seq_lote_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_lote_orgao_cobr ( nr_seq_lote_p text, nm_usuario_p text) FROM PUBLIC;
