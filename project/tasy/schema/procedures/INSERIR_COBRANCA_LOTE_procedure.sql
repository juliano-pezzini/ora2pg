-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_cobranca_lote ( nr_seq_lote_p bigint, ie_tipo_p text, ie_tipo_lote_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_regra_w 		bigint;
nr_sequencia_w 		bigint;
nr_tit_cheque_w		bigint;
ds_historico_w		varchar(255);
vl_acobrar_w		cobranca.vl_acobrar%type;
qtd_w			bigint;
qtd_2_w			bigint;
nr_seq_orgao_cobr_w	bigint;
dt_liberacao_exclusao_w	timestamp;
dt_liberacao_envio_w	timestamp;

c01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_titulo,
		dt_liberacao_exclusao,
		dt_liberacao_envio
	from	titulo_receber_orgao_cobr
	where	ie_selecionado = 'S';

c02 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_cheque,
		dt_liberacao_exclusao,
		dt_liberacao_envio
	from	cheque_cr_orgao_cobr
	where	ie_selecionado = 'S';

c03 CURSOR FOR
	SELECT	nr_sequencia,
		dt_liberacao_exclusao,
		dt_liberacao_envio
	from	outros_orgao_cobr
	where	ie_selecionado = 'S';


BEGIN

select	max(nr_seq_orgao_cobr)
into STRICT	nr_seq_orgao_cobr_w
from	lote_orgao_cobranca
where	nr_sequencia = nr_seq_lote_p;

if (ie_tipo_p = 'T')then

	select	count(*)
	into STRICT	qtd_w
	from 	titulo_receber_orgao_cobr
	where	ie_selecionado = 'S';

	if (qtd_w = 0)then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(682121);
	end if;

	select	count(*)
	into STRICT	qtd_2_w
	from 	titulo_receber_orgao_cobr
	where	ie_selecionado = 'S'
	and 	nr_seq_orgao_cobr = nr_seq_orgao_cobr_w;

	if (qtd_w <> qtd_2_w) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(338313);
	end if;

	select	max(nr_seq_regra)
	into STRICT	nr_seq_regra_w
	from	titulo_receber_orgao_cobr
	where	nr_seq_lote = nr_seq_lote_p;

	open c01;
	loop
	fetch c01 into
		nr_sequencia_w,
		nr_tit_cheque_w,
		dt_liberacao_exclusao_w,
		dt_liberacao_envio_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin

		if (ie_tipo_lote_p = 'I') then

			if (dt_liberacao_exclusao_w IS NOT NULL AND dt_liberacao_exclusao_w::text <> '') then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(339206);
			end if;

			if (coalesce(dt_liberacao_envio_w::text, '') = '') then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(674394);
			end if;

		end if;

		if (ie_tipo_lote_p = 'E') and (coalesce(dt_liberacao_exclusao_w::text, '') = '') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(339207);
		end if;

		update	titulo_receber_orgao_cobr
		set	nr_seq_regra = nr_seq_regra_w,
			nr_Seq_lote = nr_seq_lote_p,
			ie_selecionado = 'N'
		where	nr_sequencia = nr_sequencia_w;

		ds_historico_w := wheb_mensagem_pck.get_texto(337808, 'NM_USUARIO=' || nm_usuario_p || ';NR_TITULO=' || nr_tit_cheque_w || ';NR_SEQ_LOTE=' || nr_seq_lote_p || ';DT_ATUALIZACAO=' || to_char(clock_timestamp(),'dd/MM/yyyy hh24:mi:ss'));
		CALL gerar_historico_cobr_orgao(nr_tit_cheque_w,null,null,ds_historico_w,nm_usuario_p,'P');

		end;
	end loop;
	close c01;

elsif (ie_tipo_p = 'C') then

	select	count(*)
	into STRICT	qtd_w
	from 	cheque_cr_orgao_cobr
	where	ie_selecionado = 'S';

	if (qtd_w = 0)then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(682121);
	end if;

	select	count(*)
	into STRICT	qtd_2_w
	from 	cheque_cr_orgao_cobr
	where	ie_selecionado = 'S'
	and 	nr_seq_orgao_cobr = nr_seq_orgao_cobr_w;

	if (qtd_w <> qtd_2_w) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(338313);
	end if;

	select	max(nr_seq_regra)
	into STRICT	nr_seq_regra_w
	from	cheque_cr_orgao_cobr
	where	nr_seq_lote = nr_seq_lote_p;

	open c02;
	loop
	fetch c02 into
		nr_sequencia_w,
		nr_tit_cheque_w,
		dt_liberacao_exclusao_w,
		dt_liberacao_envio_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin

		if (ie_tipo_lote_p = 'I') then

			if (dt_liberacao_exclusao_w IS NOT NULL AND dt_liberacao_exclusao_w::text <> '') then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(339206);
			end if;

			if (coalesce(dt_liberacao_envio_w::text, '') = '') then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(674394);
			end if;

		end if;

		if (ie_tipo_lote_p = 'E') and (coalesce(dt_liberacao_exclusao_w::text, '') = '') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(339207);
		end if;

		update	cheque_cr_orgao_cobr
		set	nr_seq_regra = nr_seq_regra_w,
			nr_seq_lote = nr_seq_lote_p,
			ie_selecionado = 'N'
		where	nr_sequencia = nr_sequencia_w;

		ds_historico_w := wheb_mensagem_pck.get_texto(337809, 'NM_USUARIO=' || nm_usuario_p || ';NR_SEQ_CHEQUE=' || nr_tit_cheque_w || ';NR_SEQ_LOTE=' || nr_seq_lote_p || ';DT_ATUALIZACAO=' || to_char(clock_timestamp(),'dd/MM/yyyy hh24:mi:ss'));
		CALL gerar_historico_cobr_orgao(null,nr_tit_cheque_w,null,ds_historico_w,nm_usuario_p,'P');

		end;
	end loop;
	close c02;

elsif (ie_tipo_p = 'O') then

	select	count(*)
	into STRICT	qtd_w
	from 	outros_orgao_cobr
	where	ie_selecionado = 'S';

	if (qtd_w = 0)then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(682121);
	end if;

	select	count(*)
	into STRICT	qtd_2_w
	from 	outros_orgao_cobr
	where	ie_selecionado = 'S'
	and 	nr_seq_orgao_cobr = nr_seq_orgao_cobr_w;

	if (qtd_w <> qtd_2_w) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(338313);
	end if;

	select	max(nr_seq_regra)
	into STRICT	nr_seq_regra_w
	from	outros_orgao_cobr
	where	nr_seq_lote = nr_seq_lote_p;

	open c03;
	loop
	fetch c03 into
		nr_sequencia_w,
		dt_liberacao_exclusao_w,
		dt_liberacao_envio_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
		begin

		if (ie_tipo_lote_p = 'I') then

			if (dt_liberacao_exclusao_w IS NOT NULL AND dt_liberacao_exclusao_w::text <> '') then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(339206);
			end if;

			if (coalesce(dt_liberacao_envio_w::text, '') = '') then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(674394);
			end if;

		end if;

		if (ie_tipo_lote_p = 'E') and (coalesce(dt_liberacao_exclusao_w::text, '') = '') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(339207);
		end if;

		select	b.vl_acobrar
		into STRICT	vl_acobrar_w
		from	outros_orgao_cobr a,
			cobranca b
		where	a.nr_seq_cobranca = b.nr_sequencia
		and 	a.nr_sequencia = nr_sequencia_w;

		update	outros_orgao_cobr
		set	nr_seq_regra = nr_seq_regra_w,
			nr_Seq_lote = nr_seq_lote_p,
			ie_selecionado = 'N'
		where	nr_sequencia = nr_sequencia_w;

		ds_historico_w := wheb_mensagem_pck.get_texto(337834, 'NM_USUARIO=' || nm_usuario_p || ';VL_TOTAL=' || vl_acobrar_w || ';NR_SEQ_LOTE=' || nr_seq_lote_p || ';DT_ATUALIZACAO=' || to_char(clock_timestamp(),'dd/MM/yyyy hh24:mi:ss'));
		CALL gerar_historico_cobr_orgao(null,null,null,ds_historico_w,nm_usuario_p,'P');

		end;
	end loop;
	close c03;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_cobranca_lote ( nr_seq_lote_p bigint, ie_tipo_p text, ie_tipo_lote_p text, nm_usuario_p text) FROM PUBLIC;
