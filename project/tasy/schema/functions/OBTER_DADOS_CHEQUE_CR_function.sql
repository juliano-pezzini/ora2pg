-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_cheque_cr (nr_seq_cheque_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE



/*	n - n° do cheque
	cp - código da pessoa do atendimento do cheque
	np - nome da pessoa do atendimento do cheque
	dp - data de devolução paciente
	db - Última data de devolução do banco
	em - emitente do cheque
	dv - data de vencimento
	nb - nome do banco
	vl - valor do cheque
	na - numero atendimento
	naa - numero atendimento adiantamento
	nc - número da conta paciente
	sn - saldo do cheque a negociar
	pfc - codigo pessoa fisica
	pjc - codigo pessoa juridica
	cob - status da cobrança do cheque
	nf  - número da nota fiscal
	dc - data contábil
	dr - data de registro
	csc - código do status da cobrança do cheque
	dtp - data de perda
*/
nr_cheque_w			varchar(20);
ds_retorno_w			varchar(255);
nr_atendimento_w			bigint	:= null;
cd_pf_atend_w			varchar(10);
cd_pessoa_fisica_w		varchar(10);
nm_pessoa_fisica_w		varchar(60);
dt_devolucao_pac_w		timestamp;
dt_devolucao_banco_w		timestamp;
dt_vencimento_w			timestamp;
vl_cheque_w			double precision;
nr_interno_conta_w			bigint	:= null;
vl_saldo_negociado_w		double precision;
cd_cgc_w			varchar(14);
nr_titulo_w			bigint;
nr_seq_baixa_w			integer;
cd_banco_w			integer;
nr_nota_fiscal_w			double precision;
dt_perda_w			timestamp;
ie_cheque_perda_w		varchar(1);


BEGIN

/*select	a.nr_cheque,
	a.dt_devolucao,
	nvl(nvl(dt_terc_devolucao,dt_seg_devolucao),dt_devolucao_banco),
	a.cd_pessoa_fisica,
	a.cd_cgc,
	nvl(a.dt_vencimento_atual,a.dt_vencimento),
	a.cd_banco,
	a.vl_cheque,
	a.nr_titulo,
	nvl(a.vl_saldo_negociado,a.vl_cheque)
into	nr_cheque_w,
	dt_devolucao_pac_w,
	dt_devolucao_banco_w,
	cd_pessoa_fisica_w,
	cd_cgc_w,
	dt_vencimento_w,
	cd_banco_w,
	vl_cheque_w,
	nr_titulo_w,
	vl_saldo_negociado_w,
from	cheque_cr a
where	a.nr_seq_cheque	= nr_seq_cheque_p;

francisco - os 170843 - 07/10/2009 - mudei para fazer o select de cada campo conforme opcao*/
if (nr_seq_cheque_p IS NOT NULL AND nr_seq_cheque_p::text <> '') then

	if (ie_opcao_p	= 'N') then
		select	a.nr_cheque
		into STRICT	nr_cheque_w
		from	cheque_cr a
		where	a.nr_seq_cheque	= nr_seq_cheque_p;

		ds_retorno_w	:= nr_cheque_w;
	elsif (ie_opcao_p	= 'CP') then
		select	a.nr_titulo
		into STRICT	nr_titulo_w
		from	cheque_cr a
		where	a.nr_seq_cheque	= nr_seq_cheque_p;

		select	max(nr_atendimento)
		into STRICT	nr_atendimento_w
		from	titulo_receber
		where	nr_titulo	= nr_titulo_w;

		if (coalesce(nr_atendimento_w::text, '') = '') then
			select	max(b.nr_atendimento)
			into STRICT	nr_atendimento_w
			from	titulo_receber b,
					movto_trans_financ a
			where	a.nr_seq_titulo_receber	= b.nr_titulo
			and	exists (SELECT	1
					from	movto_trans_financ x
					where	x.nr_seq_caixa	= a.nr_seq_caixa
					and	x.nr_seq_lote	= a.nr_seq_lote
					and	x.nr_seq_cheque	= nr_seq_cheque_p);
		end if;

		if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then /* francisco - os 47863 rastreabilidade */
			select	cd_pessoa_fisica
			into STRICT	cd_pf_atend_w
			from	atendimento_paciente
			where	nr_atendimento	= nr_atendimento_w;
		end if;
		ds_retorno_w	:= cd_pf_atend_w;
	elsif (ie_opcao_p	= 'NP') then
		select	max(nr_titulo)
		into STRICT	nr_titulo_w
		from	cheque_cr a
		where	a.nr_seq_cheque	= nr_seq_cheque_p;

		select	max(nr_atendimento)
		into STRICT	nr_atendimento_w
		from	titulo_receber
		where	nr_titulo	= nr_titulo_w;

		if (coalesce(nr_atendimento_w::text, '') = '') then
			select	max(b.nr_atendimento)
			into STRICT	nr_atendimento_w
			from	titulo_receber b,
					movto_trans_financ a
			where	a.nr_seq_titulo_receber	= b.nr_titulo
			and	exists (SELECT	1
					from	movto_trans_financ x
					where	x.nr_seq_caixa	= a.nr_seq_caixa
					and	x.nr_seq_lote	= a.nr_seq_lote
					and	x.nr_seq_cheque	= nr_seq_cheque_p);
		end if;

		if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then /* francisco - os 47863 rastreabilidade */
			select	substr(obter_nome_pf(cd_pessoa_fisica),1,60)
			into STRICT	nm_pessoa_fisica_w
			from	atendimento_paciente
			where	nr_atendimento	= nr_atendimento_w;
		end if;
		ds_retorno_w	:= nm_pessoa_fisica_w;
	elsif (ie_opcao_p	= 'DP') then
		select	a.dt_devolucao
		into STRICT	dt_devolucao_pac_w
		from	cheque_cr a
		where	a.nr_seq_cheque	= nr_seq_cheque_p;

		ds_retorno_w	:= to_char(dt_devolucao_pac_w,'dd/mm/yyyy');
	elsif (ie_opcao_p	= 'DB') then
		select	coalesce(coalesce(dt_terc_devolucao,dt_seg_devolucao),dt_devolucao_banco)
		into STRICT	dt_devolucao_banco_w
		from	cheque_cr a
		where	a.nr_seq_cheque	= nr_seq_cheque_p;

		ds_retorno_w	:= to_char(dt_devolucao_banco_w,'dd/mm/yyyy');
	elsif (ie_opcao_p	= 'EM') then
		--ds_retorno_w	:= ds_emitente_w;
		select	a.cd_pessoa_fisica,
			a.cd_cgc
		into STRICT	cd_pessoa_fisica_w,
			cd_cgc_w
		from	cheque_cr a
		where	a.nr_seq_cheque	= nr_seq_cheque_p;

		ds_retorno_w := substr(obter_nome_pf_pj(cd_pessoa_fisica_w,cd_cgc_w),1,80);
	elsif (ie_opcao_p	= 'DV') then
		select	coalesce(a.dt_vencimento_atual,a.dt_vencimento)
		into STRICT	dt_vencimento_w
		from	cheque_cr a
		where	a.nr_seq_cheque	= nr_seq_cheque_p;

		ds_retorno_w	:= dt_vencimento_w;
	elsif (ie_opcao_p	= 'NB') then
		select	a.cd_banco
		into STRICT	cd_banco_w
		from	cheque_cr a
		where	a.nr_seq_cheque	= nr_seq_cheque_p;

		ds_retorno_w	:= substr(obter_nome_banco(cd_banco_w),1,100);
	elsif (ie_opcao_p	= 'VL') then
		select	a.vl_cheque
		into STRICT	vl_cheque_w
		from	cheque_cr a
		where	a.nr_seq_cheque	= nr_seq_cheque_p;

		ds_retorno_w	:= vl_cheque_w;
	elsif (ie_opcao_p	= 'NA') then
		select	a.nr_titulo
		into STRICT	nr_titulo_w
		from	cheque_cr a
		where	a.nr_seq_cheque	= nr_seq_cheque_p;

		select	max(nr_atendimento)
		into STRICT	nr_atendimento_w
		from	titulo_receber
		where	nr_titulo	= nr_titulo_w;

		if (coalesce(nr_atendimento_w::text, '') = '') then
			select	max(b.nr_atendimento)
			into STRICT	nr_atendimento_w
			from	titulo_receber b,
					movto_trans_financ a
			where	a.nr_seq_titulo_receber	= b.nr_titulo
			and	exists (SELECT	1
					from	movto_trans_financ x
					where	x.nr_seq_caixa	= a.nr_seq_caixa
					and	x.nr_seq_lote	= a.nr_seq_lote
					and	x.nr_seq_cheque	= nr_seq_cheque_p);
		end if;
		ds_retorno_w	:= nr_atendimento_w;

	elsif (ie_opcao_p = 'NAA') then
		select	a.nr_seq_atend_adiant
		into STRICT	nr_atendimento_w
		from	cheque_cr a
		where	a.nr_seq_cheque	= nr_seq_cheque_p;

		ds_retorno_w	:= nr_atendimento_w;

	elsif (ie_opcao_p	= 'NC') then
		select	nr_titulo
		into STRICT	nr_titulo_w
		from	cheque_cr a
		where	a.nr_seq_cheque	= nr_seq_cheque_p;

		if (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then
			select	nr_interno_conta
			into STRICT	nr_interno_conta_w
			from	titulo_receber
			where	nr_titulo	= nr_titulo_w;
		end if;

		ds_retorno_w	:= nr_interno_conta_w;

		/*ds_retorno_w	:= substr(obter_descricao_padrao('TITULO_RECEBER','NR_INTERNO_CONTA',nr_titulo_w),1,10);*/

	elsif (ie_opcao_p	= 'SN') then
		select	coalesce(a.vl_saldo_negociado,a.vl_cheque)
		into STRICT	vl_saldo_negociado_w
		from	cheque_cr a
		where	a.nr_seq_cheque	= nr_seq_cheque_p;

		ds_retorno_w	:= vl_saldo_negociado_w;
	elsif (ie_opcao_p 	= 'PFC') then
		select	a.cd_pessoa_fisica
		into STRICT	cd_pessoa_fisica_w
		from	cheque_cr a
		where	a.nr_seq_cheque	= nr_seq_cheque_p;

		ds_retorno_w	:= cd_pessoa_fisica_w;
	elsif (ie_opcao_p 	= 'PJC') then
		select	a.cd_cgc
		into STRICT	cd_cgc_w
		from	cheque_cr a
		where	a.nr_seq_cheque	= nr_seq_cheque_p;

		ds_retorno_w	:= cd_cgc_w;
	elsif (ie_opcao_p	= 'COB') then
		select	max(obter_valor_dominio(1162, ie_status))
		into STRICT	ds_retorno_w
		from	cobranca
		where	nr_seq_cheque	= nr_seq_cheque_p;

	elsif (ie_opcao_p	= 'NF') then
		select  max(a.nr_nota_fiscal)
		into STRICT	ds_retorno_w
		from	titulo_receber a,
			cheque_cr b
		where	a.nr_titulo	=	b.nr_titulo
		and	b.nr_seq_cheque	= 	nr_seq_cheque_p;
	elsif (ie_opcao_p	= 'DR') then
		select  	max(b.dt_registro)
		into STRICT	ds_retorno_w
		from	cheque_cr b
		where	b.nr_seq_cheque	= 	nr_seq_cheque_p;
	elsif (ie_opcao_p	= 'DC') then
		select  	max(b.dt_contabil)
		into STRICT	ds_retorno_w
		from	cheque_cr b
		where	b.nr_seq_cheque	= 	nr_seq_cheque_p;
	elsif (ie_opcao_p	= 'CSC') then
		select	max(a.ie_status)
		into STRICT	ds_retorno_w
		from	cobranca a
		where	a.nr_seq_cheque	= nr_seq_cheque_p;
	elsif (ie_opcao_p	= 'DTP') then
		begin
		nr_seq_baixa_w	:= null;
		dt_perda_w	:= null;

		select	max(dt_perda)
		into STRICT	dt_perda_w
		from	perda_contas_receber a
		where	nr_seq_cheque = nr_seq_cheque_p
		and	not exists (	SELECT	1
				from	perda_contas_receb_baixa b,
					fin_tipo_baixa_perda c
				where	a.nr_sequencia = b.nr_seq_perda
				and	b.nr_seq_tipo_baixa = c.nr_sequencia
				and	c.ie_tipo_consistencia = '4');

		if (coalesce(dt_perda_w::text, '') = '') then
			begin
			ie_cheque_perda_w := substr(coalesce(obter_valor_param_usuario(810, 65, somente_numero(wheb_usuario_pck.get_cd_perfil), wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento),'S'),1,1);

			if (ie_cheque_perda_w = 'S') then
				begin
				select  max(b.nr_titulo)
				into STRICT	nr_titulo_w
				from	cheque_cr b
				where	b.nr_seq_cheque	= 	nr_seq_cheque_p;

				if (nr_titulo_w > 0) then
					begin
					select	max(x.nr_sequencia)
					into STRICT	nr_seq_baixa_w
					from	titulo_receber_liq x
					where	coalesce(x.nr_seq_liq_origem::text, '') = ''
					and	x.nr_titulo		= nr_titulo_w;

					if (nr_seq_baixa_w > 0) then
						select	max(y.dt_recebimento)
						into STRICT	dt_perda_w
						from	tipo_recebimento x,
							titulo_receber_liq y
						where	not exists (SELECT	1
							from	titulo_receber_liq w
							where	w.nr_seq_liq_origem 	= y.nr_sequencia
							and	w.nr_titulo		= nr_titulo_w)
						and	x.ie_tipo_consistencia	= 9
						and	x.cd_tipo_recebimento	= y.cd_tipo_recebimento
						and	y.nr_titulo			= nr_titulo_w
						and	y.nr_sequencia		= nr_seq_baixa_w;
					end if;
					end;
				end if;
				end;
			end if;
			end;
		end if;

		ds_retorno_w	:= to_char(dt_perda_w,'dd/mm/yyyy hh24:mi:ss');
		end;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_cheque_cr (nr_seq_cheque_p bigint, ie_opcao_p text) FROM PUBLIC;
