-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fechar_negociacao_cheque ( nr_seq_caixa_rec_p bigint, ie_troco_p text, nm_usuario_p text, dt_fechamento_p timestamp, vl_troco_p INOUT bigint) AS $body$
DECLARE


dt_fechamento_w		timestamp;
vl_restante_w		double precision;
nr_seq_trans_financ_w	bigint;
vl_transacao_w		double precision;
nr_documento_w		bigint;
ie_tipo_movto_w		varchar(2);
nr_seq_saldo_caixa_w	bigint;
nr_seq_caixa_w		bigint;
qt_sem_trans_financ_w	integer;
dt_fechamento_saldo_w	timestamp;
nr_sequencia_w		bigint;
qt_lote_aberto_w	integer;
nr_seq_lote_w		bigint;
cd_estabelecimento_w	smallint;
nr_seq_trans_troco_w	bigint;
nr_seq_especie_cr_w	bigint;
dt_saldo_caixa_w	timestamp;
nr_recibo_w		bigint;
cd_pessoa_fisica_w	varchar(10);
cd_cgc_w		varchar(14);
dt_recebimento_w	timestamp;
nr_seq_cheque_w		bigint;
vl_saldo_negociado_w	double precision;
ds_mensagem_w		varchar(4000);
ds_lista_cheques_w	varchar(4000);
nr_cheque_w		varchar(20);
nr_seq_trans_acres_neg_w	bigint;
ie_status_w		bigint;
vl_saldo_neg_w		double precision;
nr_seq_cheque_neg_w	bigint;
ie_data_devol_cheque_w	varchar(1);
ds_observacao_w 	varchar(255);
dt_registro_w		timestamp;

nr_sequencia_bx_trib_w		titulo_receber_trib_baixa.nr_sequencia%type;
nr_titulo_w					titulo_receber_liq.nr_titulo%type;
nr_seq_liq_w				titulo_receber_liq.nr_sequencia%type;
nr_seq_cheque_negociado_w	cheque_cr.nr_seq_cheque%type;
ie_neg_cartao_especie_w		varchar(1) := 'N';

nr_seq_trans_fin_acres_neg_w	parametro_tesouraria.nr_seq_trans_fin_acres_neg%type;

C01 CURSOR FOR
	/* Espécie */

	SELECT	'E',
		nr_seq_especie_cr_w,
		vl_especie,
		(null)::numeric
	from	caixa_receb
	where	nr_sequencia	= nr_seq_caixa_rec_p
	and	vl_especie > 0
	
union all

	/* Cheques negociar */

	SELECT	'N',
		nr_seq_trans_financ,
		coalesce(vl_negociado,0) + CASE WHEN coalesce(nr_seq_trans_fin_acres_neg_w::text, '') = '' THEN coalesce(vl_acrescimo,0)  ELSE 0 END  + coalesce(vl_juros,0) + coalesce(vl_multa,0),
		nr_seq_cheque
	from	cheque_cr_negociado
	where	nr_seq_caixa_rec = nr_seq_caixa_rec_p
	and		coalesce(nr_seq_trans_acres_neg_w::text, '') = ''
	
union all

	select	'N',
		nr_seq_trans_financ,
		coalesce(vl_negociado,0) + CASE WHEN coalesce(nr_seq_trans_fin_acres_neg_w::text, '') = '' THEN coalesce(vl_acrescimo,0)  ELSE 0 END ,
		nr_seq_cheque
	from	cheque_cr_negociado
	where	nr_seq_caixa_rec = nr_seq_caixa_rec_p
	and	(nr_seq_trans_acres_neg_w IS NOT NULL AND nr_seq_trans_acres_neg_w::text <> '')
	
union all

	select	'N',
		nr_seq_trans_fin_acres_neg_w,
		coalesce(vl_acrescimo,0),
		nr_seq_cheque
	from	cheque_cr_negociado
	where	nr_seq_caixa_rec = nr_seq_caixa_rec_p
	and	(nr_seq_trans_fin_acres_neg_w IS NOT NULL AND nr_seq_trans_fin_acres_neg_w::text <> '')
	and	coalesce(vl_acrescimo,0) > 0
	
union all

	select	'N',
		nr_seq_trans_acres_neg_w,
		coalesce(vl_juros,0),
		nr_seq_cheque
	from	cheque_cr_negociado
	where	nr_seq_caixa_rec = nr_seq_caixa_rec_p
	and	(nr_seq_trans_acres_neg_w IS NOT NULL AND nr_seq_trans_acres_neg_w::text <> '')
	and	vl_juros > 0
	
union all

	select	'N',
		nr_seq_trans_acres_neg_w,
		coalesce(vl_multa,0),
		nr_seq_cheque
	from	cheque_cr_negociado
	where	nr_seq_caixa_rec = nr_seq_caixa_rec_p
	and	(nr_seq_trans_acres_neg_w IS NOT NULL AND nr_seq_trans_acres_neg_w::text <> '')
	and	vl_multa > 0
	
union all

	/* Cheque */

	select	'CH',
		nr_seq_trans_caixa,
		vl_cheque,
		nr_seq_cheque
	from	cheque_cr
	where	nr_seq_caixa_rec = nr_seq_caixa_rec_p
	
union all

	/* Cartão */

	select	'CA',
		nr_seq_trans_caixa,
		vl_transacao,
		nr_sequencia
	from	movto_cartao_cr
	where	nr_seq_caixa_rec = nr_seq_caixa_rec_p
	
union all

	/* Troco */

	select	'T',
		nr_seq_trans_troco_w,
		abs(vl_troco_p),
		(null)::numeric 
	
	where	vl_troco_p < 0;

C02 CURSOR FOR
	SELECT	distinct
		nr_seq_cheque
	from	cheque_cr_negociado
	where	nr_seq_caixa_rec	= nr_seq_caixa_rec_p;



/*Cursor para buscar os tributos gerados nas baixas dos titulos que foram recebidos em caixa com esse cheque que esta sendo negociado em especie ou cartao*/

C03 CURSOR FOR
	SELECT	nr_seq_cheque
	from (WITH RECURSIVE cte AS (
    SELECT	a.nr_seq_cheque
			  FROM cheque_cr a, caixa_receb b
LEFT OUTER JOIN cheque_cr_negociado c ON (b.nr_sequencia = c.nr_seq_caixa_rec) WHERE a.nr_seq_cheque = nr_seq_cheque_w
  UNION ALL
    SELECT	a.nr_seq_cheque
			  FROM cheque_cr a, caixa_receb b
LEFT OUTER JOIN cheque_cr_negociado c ON (b.nr_sequencia = c.nr_seq_caixa_rec) JOIN cte c ON (c.prior nr_seq_cheque = a.nr_seq_cheque)

) SELECT * FROM cte WHERE nr_seq_caixa_rec = nr_sequencia  and exists (select 	1 --Tem que existir um titulo recebido com esse cheque e que tenha gerado baixa de tributo.
						from   	caixa_receb x,
								titulo_receber_liq z,
								titulo_receber_trib_baixa y
						where  	x.nr_sequencia = a.nr_seq_caixa_rec
						and    	x.nr_sequencia = z.nr_seq_caixa_rec
						and    	z.nr_titulo    = y.nr_titulo
						and    	z.nr_sequencia = y.nr_seq_tit_liq) ORDER BY  c.nr_seq_cheque nulls first
		 ;
) alias1;

C04 CURSOR FOR
	SELECT 	d.nr_sequencia,
			c.nr_titulo,
			c.nr_sequencia
	from  	cheque_cr a,
			caixa_receb b,
			titulo_receber_liq c,
			titulo_receber_trib_baixa d
	where 	a.nr_seq_cheque 	= nr_seq_cheque_negociado_w
	and   	a.nr_seq_caixa_rec 	= b.nr_sequencia
	and   	b.nr_sequencia     	= c.nr_seq_caixa_rec
	and   	c.nr_sequencia     	= d.nr_seq_tit_liq
	and   	c.nr_titulo        	= d.nr_titulo;



BEGIN
lock table caixa_receb in exclusive mode;
lock table movto_trans_financ in exclusive mode;

vl_troco_p	:= 0;

select	count(*)
into STRICT	qt_sem_trans_financ_w
from	cheque_cr_negociado
where	nr_seq_caixa_rec = nr_seq_caixa_rec_p
and	coalesce(nr_seq_trans_financ::text, '') = '';

if (qt_sem_trans_financ_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(184703);
else
	select	count(*)
	into STRICT	qt_sem_trans_financ_w
	from	cheque_cr
	where	nr_seq_caixa_rec = nr_seq_caixa_rec_p
	and	coalesce(nr_seq_trans_caixa::text, '') = '';

	if (qt_sem_trans_financ_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(184704);
	else
		select	count(*)
		into STRICT	qt_sem_trans_financ_w
		from	movto_cartao_cr
		where	nr_seq_caixa_rec = nr_seq_caixa_rec_p
		and	coalesce(nr_seq_trans_caixa::text, '') = '';

		if (qt_sem_trans_financ_w > 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(184705);
		end if;
	end if;
end if;

select	obter_valores_caixa_rec(nr_seq_caixa_rec_p,'VR')
into STRICT	vl_restante_w
;

if (vl_restante_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(184706);
elsif (vl_restante_w < 0) then
	vl_troco_p	:= vl_restante_w;
end if;

select	max(a.dt_fechamento),
	max(a.dt_recebimento),
	max(b.nr_sequencia),
	max(b.nr_seq_caixa),
	max(a.cd_pessoa_fisica),
	max(a.cd_cgc)
into STRICT	dt_fechamento_w,
	dt_recebimento_w,
	nr_seq_saldo_caixa_w,
	nr_seq_caixa_w,
	cd_pessoa_fisica_w,
	cd_cgc_w
from	caixa_saldo_diario b,
	caixa_receb a
where	a.nr_seq_saldo_caixa	= b.nr_sequencia
and	a.nr_sequencia		= nr_seq_caixa_rec_p;

select	max(a.dt_fechamento),
	max(a.dt_saldo),
	max(b.cd_estabelecimento)
into STRICT	dt_fechamento_saldo_w,
	dt_saldo_caixa_w,
	cd_estabelecimento_w
from	caixa b,
	caixa_saldo_diario a
where	a.nr_seq_caixa	= b.nr_sequencia
and	a.nr_sequencia	= nr_seq_saldo_caixa_w;

select	max(nr_seq_trans_troco),
		max(nr_seq_especie_cr),
		max(nr_seq_trans_acres_neg),
		max(ie_data_devol_cheque),
		max(nr_seq_trans_fin_acres_neg)
into STRICT	nr_seq_trans_troco_w,
		nr_seq_especie_cr_w,
		nr_seq_trans_acres_neg_w,
		ie_data_devol_cheque_w,
		nr_seq_trans_fin_acres_neg_w
from	parametro_tesouraria
where	cd_estabelecimento	= cd_estabelecimento_w;

if (coalesce(nr_seq_especie_cr_w::text, '') = '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(184707);
end if;

select	count(*)
into STRICT	qt_lote_aberto_w
from	movto_trans_financ
where	nr_seq_caixa	= nr_seq_caixa_w
and	coalesce(dt_fechamento_lote::text, '') = '';

if (qt_lote_aberto_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(184708);
elsif (dt_fechamento_saldo_w IS NOT NULL AND dt_fechamento_saldo_w::text <> '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(184709);
elsif (trunc(dt_saldo_caixa_w,'dd') <> trunc(dt_recebimento_w,'dd')) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(184710);
elsif (dt_fechamento_w IS NOT NULL AND dt_fechamento_w::text <> '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(184711);
end if;

if	((ie_troco_p = 'N' and vl_troco_p = 0) or ie_troco_p = 'S') then
	select	coalesce(max(nr_seq_lote),0) + 1
	into STRICT	nr_seq_lote_w
	from	movto_trans_financ
	where	nr_seq_caixa	= nr_seq_caixa_w;

	open c01;
	loop
	fetch c01 into	ie_tipo_movto_w,
			nr_seq_trans_financ_w,
			vl_transacao_w,
			nr_documento_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */

		if (ie_tipo_movto_w = 'N') then
			select	max(nr_cheque),
				max(vl_saldo_negociado)
			into STRICT	nr_cheque_w,
				vl_saldo_neg_w
			from	cheque_cr
			where	nr_seq_cheque	= nr_documento_w;

			if (nr_cheque_w IS NOT NULL AND nr_cheque_w::text <> '') then

				ie_status_w := OBTER_STATUS_CHEQUE(nr_documento_w);

				if (vl_saldo_neg_w = 0) and (ie_status_w <> 6) then

					ds_mensagem_w	:= wheb_mensagem_pck.get_texto(302108);
					update	cheque_cr
					set	ds_observacao	= substr(CASE WHEN ds_observacao = NULL THEN ds_mensagem_w  ELSE ds_observacao || chr(13) || ds_mensagem_w END ,1,4000)
					where	nr_seq_cheque	= nr_documento_w;

				elsif (vl_saldo_neg_w <> 0) and (ie_status_w <> 6) then

					ds_mensagem_w	:= wheb_mensagem_pck.get_texto(302104);
					update	cheque_cr
					set	ds_observacao	= substr(CASE WHEN ds_observacao = NULL THEN ds_mensagem_w  ELSE ds_observacao || chr(13) || ds_mensagem_w END ,1,4000)
					where	nr_seq_cheque	= nr_documento_w;
				else
					ds_mensagem_w	:= wheb_mensagem_pck.get_texto(302105);
					update	cheque_cr
					set	ds_observacao	= substr(CASE WHEN ds_observacao = NULL THEN ds_mensagem_w  ELSE ds_observacao || chr(13) || ds_mensagem_w END ,1,4000)
					where	nr_seq_cheque	= nr_documento_w;
				end if;

			end if;

			if (ds_lista_cheques_w IS NOT NULL AND ds_lista_cheques_w::text <> '') and (length(ds_lista_cheques_w) < 3950) then
				ds_lista_cheques_w	:= ds_lista_cheques_w || ',' || nr_cheque_w;
			else
				ds_lista_cheques_w	:= nr_cheque_w;
			end if;

		end if;
		ds_observacao_w := wheb_mensagem_pck.get_texto(302686, 'nr_seq_caixa_rec_p=' || nr_seq_caixa_rec_p);
		if (ie_tipo_movto_w	= 'N') or (ie_tipo_movto_w	= 'CH') then

			CALL gerar_cheque_cr_hist(nr_documento_w, ds_observacao_w,'N',nm_usuario_p);

		end if;

		if (ie_tipo_movto_w = 'CH') then
			select	dt_registro
			into STRICT 	dt_registro_w
			from 	cheque_cr
			where 	nr_seq_cheque = nr_documento_w;

			if (coalesce(dt_registro_w::text, '') = '') then
				update cheque_cr
				set dt_registro =  clock_timestamp()
				where nr_seq_cheque = nr_documento_w;
			end if;
		end if;

		select	nextval('movto_trans_financ_seq')
		into STRICT	nr_sequencia_w
		;

		insert	into movto_trans_financ(nr_sequencia,
			dt_transacao,
			nr_seq_trans_financ,
			vl_transacao,
			dt_atualizacao,
			nm_usuario,
			nr_lote_contabil,
			ie_conciliacao,
			nr_seq_caixa_rec,
			nr_seq_caixa,
			nr_seq_saldo_caixa,
			dt_referencia_saldo,
			nr_seq_lote,
			nr_seq_cheque,
			nr_seq_movto_cartao,
			cd_pessoa_fisica,
			cd_cgc)
		values (nr_sequencia_w,
			dt_recebimento_w,
			nr_seq_trans_financ_w,
			vl_transacao_w,
			clock_timestamp(),
			nm_usuario_p,
			0,
			'N',
			nr_seq_caixa_rec_p,
			nr_seq_caixa_w,
			nr_seq_saldo_caixa_w,
			dt_saldo_caixa_w,
			nr_seq_lote_w,
			CASE WHEN ie_tipo_movto_w='CH' THEN nr_documento_w WHEN ie_tipo_movto_w='N' THEN nr_documento_w  ELSE null END ,
			CASE WHEN ie_tipo_movto_w='CA' THEN nr_documento_w  ELSE null END ,
			cd_pessoa_fisica_w,
			cd_cgc_w);

		if (ie_tipo_movto_w in ('E','CA')) and (ie_neg_cartao_especie_w <> 'S')  then
			ie_neg_cartao_especie_w := 'S';
		end if;

	end loop;
	close c01;

	update	movto_trans_financ
	set	nr_seq_caixa		= nr_seq_caixa_w,
		nr_seq_saldo_caixa	= nr_seq_saldo_caixa_w,
		dt_referencia_saldo	= dt_saldo_caixa_w,
		nr_seq_lote		= nr_seq_lote_w,
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p
	where	nr_seq_caixa_rec	= nr_seq_caixa_rec_p
	and	coalesce(nr_seq_lote::text, '') = '';

	CALL atualizar_saldo_caixa(cd_estabelecimento_w,
				nr_seq_lote_w,
				nr_seq_caixa_w,
				nm_usuario_p,
				'N');

	open c02;
	loop
	fetch c02 into
		nr_seq_cheque_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		CALL atualizar_saldo_neg_cheque_cr(nr_seq_cheque_w,nm_usuario_p);

		select	vl_saldo_negociado
		into STRICT	vl_saldo_negociado_w
		from	cheque_cr
		where	nr_seq_cheque	= nr_seq_cheque_w;

		if (vl_saldo_negociado_w = 0) then
			update	cheque_cr
			set	dt_devolucao		= CASE WHEN ie_data_devol_cheque_w='R' THEN dt_recebimento_w WHEN ie_data_devol_cheque_w='S' THEN clock_timestamp() END
			where	nr_seq_cheque		= nr_seq_cheque_w;
		end if;
		if (vl_saldo_negociado_w = 0) and (ie_status_w <> 6) then
			ds_mensagem_w	:= wheb_mensagem_pck.get_texto(302108);
			update	cheque_cr
			set	ds_observacao	= substr(CASE WHEN ds_observacao = NULL THEN ds_mensagem_w  ELSE ds_observacao || chr(13) || ds_mensagem_w END ,1,4000)
			where	nr_seq_cheque	= nr_documento_w;
		end if;
		CALL atualizar_cobranca_cheque(nr_seq_cheque_w,nm_usuario_p);

		CALL liberar_cheque_orgao_cobr(nr_seq_cheque_w,nm_usuario_p);

		/*OS 1713025  - Se negociou o cheque em espécie ou cartão, atualizar dt_contabil da baixa do tributo do titulo desse cheque, para contabilizar*/

		if (ie_neg_cartao_especie_w = 'S') then
			open C03;
			loop
			fetch C03 into
				nr_seq_cheque_negociado_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
				begin

				open C04;
				loop
				fetch C04 into
					nr_sequencia_bx_trib_w,
					nr_titulo_w,
					nr_seq_liq_w;
				EXIT WHEN NOT FOUND; /* apply on C04 */
					begin

						update	titulo_receber_trib_baixa
						set		dt_contabil 	= clock_timestamp()
						where	nr_titulo		= nr_titulo_w
						and		nr_sequencia 	= nr_sequencia_bx_trib_w
						and		nr_seq_tit_liq	= nr_seq_liq_w;

					end;
				end loop;
				close C04;

				end;
			end loop;
			close C03;
		end if;

	end loop;
	close c02;

	ds_mensagem_w	:= substr(wheb_mensagem_pck.get_texto(302109) || ' ' || ds_lista_cheques_w,1,3950);

	update	cheque_cr
	set	ie_lib_caixa	= 'S',
		ds_observacao	= substr(CASE WHEN ds_observacao = NULL THEN ds_mensagem_w  ELSE ds_observacao || chr(13) || ds_mensagem_w END ,1,4000)
	where	nr_seq_caixa_rec = nr_seq_caixa_rec_p;

	update	movto_cartao_cr
	set	ie_lib_caixa	= 'S'
	where	nr_seq_caixa_rec = nr_seq_caixa_rec_p;

	update	caixa_receb
	set	dt_fechamento	= coalesce(dt_fechamento_p,clock_timestamp()),
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_seq_caixa_rec_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fechar_negociacao_cheque ( nr_seq_caixa_rec_p bigint, ie_troco_p text, nm_usuario_p text, dt_fechamento_p timestamp, vl_troco_p INOUT bigint) FROM PUBLIC;
