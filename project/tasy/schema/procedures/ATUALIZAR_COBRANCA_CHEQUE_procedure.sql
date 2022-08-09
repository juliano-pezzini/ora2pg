-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_cobranca_cheque ( nr_seq_cheque_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
/* edgar 25/09/2008, nÃo dar commit */
 
 
ie_status_cheque_w	integer;
qt_registro_w		integer;
ds_historico_w		varchar(2000)	:= null;
ie_status_cobranca_w	varchar(2);/* e - encerrada, p - pendente, n - negociada */
nr_seq_cobranca_w	bigint;
cd_estabelecimento_w	smallint;
vl_cheque_w		double precision;
cd_tipo_portador_w		portador.cd_tipo_portador%type;
cd_portador_w		portador.cd_portador%type;
nr_seq_hist_cob_liq_w	bigint;
nr_seq_hist_cob_pend_w	bigint;
ie_atual_cob_cheque_w	varchar(1)	:= 'N';
vl_saldo_negociado_w	double precision;
qt_negociado_w		bigint;
ie_status_atual_w		varchar(2);
qt_perda_w		integer;
ie_tipo_perda_w		varchar(1);
ie_controle_perdas_w	varchar(1);
nr_seq_etapa_w		tipo_hist_cob.nr_seq_etapa%type;
nr_seq_orgao_w		tipo_hist_cob.nr_seq_orgao%type;
qt_reg_cobranca_w	bigint;
ie_cheque_cobranca_w	portador.ie_cheque_cobranca%type;
cd_moeda_w		cheque_cr.cd_moeda%type;
ie_forma_pagto_w		cheque_cr.ie_forma_pagto%type;
dt_vencimento_w			cheque_cr.dt_vencimento%type;

c01 CURSOR FOR 
	SELECT	nr_sequencia 
	from	cobranca 
	where	nr_seq_cheque	= nr_seq_cheque_p;


BEGIN 
 
ie_status_cheque_w	:= obter_status_cheque(nr_seq_cheque_p);
 
select	coalesce(max(a.vl_cheque),0), 
	max(a.cd_estabelecimento), 
	coalesce(max(b.ie_cheque_cobranca),'N'), 
	max(cd_moeda), 
	max(a.ie_forma_pagto), 
	max(a.dt_vencimento), 
	max(a.cd_tipo_portador), 
	max(a.cd_portador) 
into STRICT	vl_cheque_w, 
	cd_estabelecimento_w, 
	ie_cheque_cobranca_w, 
	cd_moeda_w, 
	ie_forma_pagto_w, 
	dt_vencimento_w, 
	cd_tipo_portador_w, 
	cd_portador_w 
FROM cheque_cr a
LEFT OUTER JOIN portador b ON (a.cd_portador = b.cd_portador)
WHERE nr_seq_cheque	= nr_seq_cheque_p;
 
select	max(nr_seq_hist_cob), 
	max(nr_seq_hist_cob_pend), 
	coalesce(max(ie_atual_cob_cheque),'N'), 
	max(ie_controle_perdas) 
into STRICT	nr_seq_hist_cob_liq_w, 
	nr_seq_hist_cob_pend_w, 
	ie_atual_cob_cheque_w, 
	ie_controle_perdas_w 
from	parametro_contas_receber 
where	cd_estabelecimento	= cd_estabelecimento_w;
 
select	count(*), 
	max(ie_status) 
into STRICT	qt_registro_w, 
	ie_status_atual_w 
from	cobranca 
where	nr_seq_cheque	= nr_seq_cheque_p;
 
select	max(a.nr_seq_etapa), 
	max(a.nr_seq_orgao) 
into STRICT	nr_seq_etapa_w, 
	nr_seq_orgao_w 
from	tipo_hist_cob a 
where	a.nr_sequencia	= nr_seq_hist_cob_pend_w;
 
if (qt_registro_w	= 0) and 
	((coalesce(ie_cheque_cobranca_w,'N') = 'S') or (ie_atual_cob_cheque_w = 'S' and ie_status_cheque_w = 3) or (ie_atual_cob_cheque_w = 'T' and ie_status_cheque_w = 10)) then 
 
	/*OS 1173707 - Se tiver NAO tiver tipo de portador do cheque, faz isso que sempre fez. 
	Mas se tiver tipo de portador no cheque, nao vai entrar nesse if, e vai gerar a cobrança com o tipo de portador e portador do cheque*/
 
	if (coalesce(cd_tipo_portador_w::text, '') = '') then 
	 
		cd_tipo_portador_w	:= 0;
		cd_portador_w := null;
 
		select	min(cd_portador) 
		into STRICT	cd_portador_w 
		from	portador 
		where	cd_tipo_portador	= cd_tipo_portador_w;
 
	end if;
	 
	select	nextval('cobranca_seq') 
	into STRICT	nr_seq_cobranca_w 
	;
 
	insert	into	cobranca(nr_sequencia, 
		nm_usuario, 
		dt_atualizacao, 
		nm_usuario_nrec, 
		dt_atualizacao_nrec, 
		cd_estabelecimento, 
		nr_seq_cheque, 
		ie_status, 
		vl_original, 
		vl_acobrar, 
		dt_previsao_cobranca, 
		dt_inclusao, 
		cd_tipo_portador, 
		cd_portador) 
	values (nr_seq_cobranca_w, 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		cd_estabelecimento_w, 
		nr_seq_cheque_p, 
		'P', 
		vl_cheque_w, 
		vl_cheque_w, 
		CASE WHEN ie_forma_pagto_w='PD' THEN coalesce(PKG_DATE_UTILS.start_of(dt_vencimento_w, 'dd', 0),PKG_DATE_UTILS.start_of(clock_timestamp(), 'dd', 0))  ELSE PKG_DATE_UTILS.start_of(clock_timestamp(), 'dd', 0) END , --Coloquei o decode pq se for cheque pre datado, a data de previsao cobranca deve ser a data pre do cheque 
		clock_timestamp(), 
		cd_tipo_portador_w, 
		cd_portador_w);
 
	if (coalesce(nr_seq_hist_cob_pend_w::text, '') = '') then 
		/* falta cadastrar o histórico de cobrança para pendente nos parâmetros do contas a receber! */
 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(183351);
	end if;
 
	if (coalesce(ie_cheque_cobranca_w,'N')	= 'S') then 
 
		ds_historico_w	:= Wheb_mensagem_pck.get_texto(303589);
 
	else 
 
		ds_historico_w	:= Wheb_mensagem_pck.get_texto(303590);
 
	end if;
 
	insert into cobranca_historico(nr_sequencia, 
		nm_usuario, 
		dt_atualizacao, 
		nm_usuario_nrec, 
		dt_atualizacao_nrec, 
		nr_seq_cobranca, 
		nr_seq_historico, 
		dt_historico, 
		ds_historico) 
	values (nextval('cobranca_historico_seq'), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nr_seq_cobranca_w, 
		nr_seq_hist_cob_pend_w, 
		clock_timestamp(), 
		ds_historico_w);
 
	if (nr_seq_etapa_w IS NOT NULL AND nr_seq_etapa_w::text <> '') then 
 
		insert	into cobranca_etapa(ds_observacao, 
			dt_atualizacao, 
			dt_etapa, 
			nm_usuario, 
			nr_seq_cobranca, 
			nr_seq_etapa, 
			nr_sequencia) 
		values (Wheb_mensagem_pck.get_texto(303592), 
			clock_timestamp(), 
			clock_timestamp(), 
			nm_usuario_p, 
			nr_seq_cobranca_w, 
			nr_seq_etapa_w, 
			nextval('cobranca_etapa_seq'));
 
	end if;
 
	if (nr_seq_orgao_w IS NOT NULL AND nr_seq_orgao_w::text <> '') then 
 
		insert	into cobranca_orgao(ds_observacao, 
			dt_atualizacao, 
			dt_inclusao, 
			nm_usuario, 
			nr_seq_cobranca, 
			nr_seq_orgao, 
			nr_sequencia) 
		values (Wheb_mensagem_pck.get_texto(303593), 
			clock_timestamp(), 
			clock_timestamp(), 
			nm_usuario_p, 
			nr_seq_cobranca_w, 
			nr_seq_orgao_w, 
			nextval('cobranca_orgao_seq'));
 
	end if;
 
end if;
 
if (ie_atual_cob_cheque_w in ('S','T','E','D')) and (qt_registro_w > 0) then 
	/* negociaÇÃo - ahoffelder - os 180469 - 24/11/2009 */
 
	select	coalesce(max(a.vl_saldo_negociado),0) 
	into STRICT	vl_saldo_negociado_w 
	from	cheque_cr a 
	where	a.nr_seq_cheque	= nr_seq_cheque_p;
 
	select	count(*) 
	into STRICT	qt_negociado_w 
	from	cheque_cr_negociado a 
	where	a.nr_seq_cheque	= nr_seq_cheque_p;
 
	if (qt_negociado_w	= 0) then 
		select	count(*) 
		into STRICT	qt_negociado_w 
		from	transacao_financeira	b, 
			movto_trans_financ	a 
		where	b.ie_acao		= 30 
		and	a.nr_seq_trans_financ	= b.nr_sequencia 
		and	a.nr_seq_cheque		= nr_seq_cheque_p;
	end if;
	 
	qt_perda_w := 0;
	 
	if (ie_controle_perdas_w = 'S') then 
		select	count(*) 
		into STRICT	qt_perda_w 
		from	cheque_cr_perda 
		where	nr_seq_cheque = nr_seq_cheque_p;
	end if;
	 
	if (qt_perda_w > 0) then 
		begin 
		select	coalesce(max(ie_tipo_perda),'R') 
		into STRICT	ie_tipo_perda_w 
		from	cheque_cr_perda 
		where	nr_seq_cheque = nr_seq_cheque_p;
		 
		if (ie_tipo_perda_w = 'R') then 
			ie_status_cobranca_w	:= 'R';
			ds_historico_w		:= Wheb_mensagem_pck.get_texto(303597);
		else 
			ie_status_cobranca_w	:= 'E';
			ds_historico_w		:= Wheb_mensagem_pck.get_texto(303599);
		end if;
		end;
	elsif (qt_negociado_w > 0) and (vl_saldo_negociado_w = 0) then 
		begin 
		if (ie_status_atual_w <> 'N') then /* se já estiver com status negociada, não precisa gerar histórico novo */
 
			ie_status_cobranca_w	:= 'N';
			ds_historico_w		:= Wheb_mensagem_pck.get_texto(303600);
		end if;
		end;
	elsif (qt_negociado_w > 0) and (vl_saldo_negociado_w <> 0) then 
		ie_status_cobranca_w	:= 'P';
		ds_historico_w		:= Wheb_mensagem_pck.get_texto(303613) || ' ' || substr(obter_desc_sigla_moeda(cd_moeda_w),1,30) || ' ' || limpa_espacos_entre(to_char(vl_cheque_w - vl_saldo_negociado_w,'999,999,999.99'));
		vl_cheque_w		:= vl_saldo_negociado_w;
	elsif (ie_status_cheque_w	= 3) then /* devolvido */
 
		ie_status_cobranca_w	:= 'P';
		ds_historico_w		:= Wheb_mensagem_pck.get_texto(303601);
	elsif (ie_status_cheque_w	= 2) then /* a depositar */
 
		ie_status_cobranca_w	:= 'E';
		ds_historico_w		:= Wheb_mensagem_pck.get_texto(303602);
	elsif (ie_status_cheque_w	= 4) then /* reapresentado */
 
		ie_status_cobranca_w	:= 'E';
		ds_historico_w		:= Wheb_mensagem_pck.get_texto(303603);
	elsif (ie_status_cheque_w	= 5) then /* segunda devolucao */
 
		ie_status_cobranca_w	:= 'P';
		ds_historico_w		:= Wheb_mensagem_pck.get_texto(303604);
	elsif (ie_status_cheque_w	= 9) then /* segunda reapresentaÇÃo */
 
		ie_status_cobranca_w	:= 'E';
		ds_historico_w		:= Wheb_mensagem_pck.get_texto(303605);
	elsif (ie_status_cheque_w	= 10) then /* terceira_devoluÇÂo */
 
		ie_status_cobranca_w	:= 'P';
		ds_historico_w		:= Wheb_mensagem_pck.get_texto(303607);
	elsif (ie_status_cheque_w	= 6) then /* devoluçÂo paciente */
 
		ie_status_cobranca_w	:= 'E';
		ds_historico_w		:= Wheb_mensagem_pck.get_texto(303608);
	end if;
 
	if (ds_historico_w IS NOT NULL AND ds_historico_w::text <> '') and (ie_status_cobranca_w IS NOT NULL AND ie_status_cobranca_w::text <> '') then 
		open c01;
		loop 
		fetch c01 into 
			nr_seq_cobranca_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
 
			if (ie_status_cobranca_w = 'P') and (coalesce(nr_seq_hist_cob_pend_w::text, '') = '') then 
				/* falta cadastrar o histórico de cobrança para pendente nos parâmetros do contas a receber! */
 
				CALL wheb_mensagem_pck.exibir_mensagem_abort(183352);
			elsif (ie_status_cobranca_w = 'E') and (coalesce(nr_seq_hist_cob_liq_w::text, '') = '') and (ie_atual_cob_cheque_w = 'E') then 
				/* falta cadastrar o histórico de cobrança para liquidado nos parâmetros do contas a receber! */
 
				CALL wheb_mensagem_pck.exibir_mensagem_abort(183356);
			end if;
			 
			if (coalesce(nr_seq_hist_cob_pend_w::text, '') = '') or (coalesce(nr_seq_hist_cob_liq_w::text, '') = '') then 
				CALL wheb_mensagem_pck.exibir_mensagem_abort(247226);
			end if;
 
			if (ie_atual_cob_cheque_w <> 'E') or (ie_status_cobranca_w <> 'E') or (qt_negociado_w > 0) then 
				update	cobranca 
				set	ie_status	= ie_status_cobranca_w, 
					nm_usuario	= nm_usuario_p, 
					dt_atualizacao	= clock_timestamp(), 
					vl_acobrar	= CASE WHEN ie_status_cobranca_w='E' THEN 0  ELSE CASE WHEN ie_status_cobranca_w='N' THEN 0  ELSE vl_cheque_w END  END  
				where	nr_sequencia	= nr_seq_cobranca_w;
 
				insert into cobranca_historico(nr_sequencia, 
					nm_usuario, 
					dt_atualizacao, 
					nm_usuario_nrec, 
					dt_atualizacao_nrec, 
					nr_seq_cobranca, 
					nr_seq_historico, 
					dt_historico, 
					ds_historico) 
				values (nextval('cobranca_historico_seq'), 
					nm_usuario_p, 
					clock_timestamp(), 
					nm_usuario_p, 
					clock_timestamp(), 
					nr_seq_cobranca_w, 
					CASE WHEN ie_status_cobranca_w='P' THEN nr_seq_hist_cob_pend_w  ELSE nr_seq_hist_cob_liq_w END , 
					clock_timestamp(), 
					ds_historico_w);
 
				if (ie_status_cobranca_w	= 'P') then 
 
					if (nr_seq_etapa_w IS NOT NULL AND nr_seq_etapa_w::text <> '') then 
 
						select	count(*) 
						into STRICT	qt_reg_cobranca_w 
						from	cobranca_etapa a 
						where	a.nr_seq_cobranca	= nr_seq_cobranca_w 
						and	a.nr_seq_etapa		= nr_seq_etapa_w;
 
						if (coalesce(qt_reg_cobranca_w,0) = 0) then 
 
							insert	into cobranca_etapa(ds_observacao, 
								dt_atualizacao, 
								dt_etapa, 
								nm_usuario, 
								nr_seq_cobranca, 
								nr_seq_etapa, 
								nr_sequencia) 
							values (Wheb_mensagem_pck.get_texto(303592), 
								clock_timestamp(), 
								clock_timestamp(), 
								nm_usuario_p, 
								nr_seq_cobranca_w, 
								nr_seq_etapa_w, 
								nextval('cobranca_etapa_seq'));
 
						end if;
 
					end if;
 
					if (nr_seq_orgao_w IS NOT NULL AND nr_seq_orgao_w::text <> '') then 
 
						select	count(*) 
						into STRICT	qt_reg_cobranca_w 
						from	cobranca_orgao a 
						where	a.nr_seq_cobranca	= nr_seq_cobranca_w 
						and	a.nr_seq_orgao		= nr_seq_orgao_w;
 
						if (coalesce(qt_reg_cobranca_w,0) = 0) then 
 
							insert	into cobranca_orgao(ds_observacao, 
								dt_atualizacao, 
								dt_inclusao, 
								nm_usuario, 
								nr_seq_cobranca, 
								nr_seq_orgao, 
								nr_sequencia) 
							values (Wheb_mensagem_pck.get_texto(303593), 
								clock_timestamp(), 
								clock_timestamp(), 
								nm_usuario_p, 
								nr_seq_cobranca_w, 
								nr_seq_orgao_w, 
								nextval('cobranca_orgao_seq'));
 
						end if;
 
					end if;
 
				end if;
 
			end if;
		end loop;
		close c01;
	end if;
end if;
 
-- commit; 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_cobranca_cheque ( nr_seq_cheque_p bigint, nm_usuario_p text) FROM PUBLIC;
