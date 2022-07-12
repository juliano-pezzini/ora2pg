-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_titulo_rec_cobr ( nr_seq_titulo_cobr_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/* ie_opcao_p
	'DN' = Desconto NC
	'NC' = Nota de crédito
	'SC' = Status título cobrança
	'TOR' = Tipo de ocorrência de retorno
	'CR'	= Existe critica
*/
ds_retorno_w			varchar(255);
ie_remessa_retorno_w		varchar(1);
ie_rejeitado_w			varchar(1);
vl_saldo_inclusao_w		double precision;
vl_cobranca_w			double precision;
vl_liquidacao_w			double precision;
vl_despesa_bancaria_w		double precision;
vl_desconto_w			double precision;
vl_juros_w			double precision;
vl_multa_w			double precision;
vl_acrescimo_w			double precision;
nr_seq_ocorrencia_ret_w		bigint;
nr_seq_cobranca_escrit_w	bigint;
qt_inconsistente_w		bigint;


BEGIN

if (ie_opcao_p = 'CR')	then
	select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ds_retorno_w
	from	inconsistencia_tit_escrit	a
	where	a.nr_seq_titulo_escrit	= nr_seq_titulo_cobr_p
	and		coalesce(a.dt_liberacao::text, '') = '';
elsif (ie_opcao_p = 'DN') then
	select	coalesce(a.vl_desc_previsto,0) + coalesce((obter_valor_nc_titulo_cobr(b.nr_sequencia))::numeric ,0)
	into STRICT	ds_retorno_w
	from	titulo_receber		a,
		titulo_receber_cobr	b
        where	b.nr_sequencia = nr_seq_titulo_cobr_p
	and	b.nr_titulo    = a.nr_titulo;
elsif (ie_opcao_p = 'NC') then
	select	max(nr_sequencia)
	into STRICT	ds_retorno_w
	from	nota_credito
        where	nr_seq_tit_rec_cobr	= nr_seq_titulo_cobr_p
	and	IE_SITUACAO		<> 'C';
elsif (ie_opcao_p = 'SC') then
	select	max(a.vl_saldo_inclusao),		-- Edgar 08/11/2012, não incluir NVL neste campo, pois nem todas as procedures geram esta informação, e quando não gera, não deve consistir
		coalesce(max(a.vl_cobranca),0),
		coalesce(max(a.vl_liquidacao),0),
		coalesce(max(a.vl_despesa_bancaria),0),
		coalesce(max(a.vl_desconto),0),
		coalesce(max(a.vl_juros),0),
		coalesce(max(a.vl_multa),0),
		coalesce(max(a.vl_acrescimo),0),
		max(a.nr_seq_ocorrencia_ret),
		max(b.ie_remessa_retorno),
		max(b.nr_sequencia)
	into STRICT	vl_saldo_inclusao_w,
		vl_cobranca_w,
		vl_liquidacao_w,
		vl_despesa_bancaria_w,
		vl_desconto_w,
		vl_juros_w,
		vl_multa_w,
		vl_acrescimo_w,
		nr_seq_ocorrencia_ret_w,
		ie_remessa_retorno_w,
		nr_seq_cobranca_escrit_w
	from	cobranca_escritural	b,
		titulo_receber_cobr	a
        where	b.nr_sequencia = a.nr_seq_cobranca
	and	a.nr_sequencia = nr_seq_titulo_cobr_p;

	select  count(1)
	into STRICT	qt_inconsistente_w
	from    inconsistencia_rem_escrit a
	where   a.nr_seq_cobr_escrit = nr_seq_cobranca_escrit_w  LIMIT 1;

	if (qt_inconsistente_w > 0) then
		ds_retorno_w := wheb_mensagem_pck.get_texto(302133);
	end if;

	ie_rejeitado_w := substr(obter_dados_bco_ocorr_escr_ret(nr_seq_ocorrencia_ret_w,'I'),1,1);

	if (vl_saldo_inclusao_w = 0) then
		if (ie_rejeitado_w <> 'L') then
			ds_retorno_w := wheb_mensagem_pck.get_texto(302134);
		else
			ds_retorno_w := wheb_mensagem_pck.get_texto(302135);
		end if;
	else
		if ((obter_dados_titulo_rec_cobr(nr_seq_titulo_cobr_p,'NC') IS NOT NULL AND (obter_dados_titulo_rec_cobr(nr_seq_titulo_cobr_p,'NC'))::text <> '')) then
			ds_retorno_w := wheb_mensagem_pck.get_texto(302136);
		elsif (obter_dados_bco_ocorr_escr_ret(nr_seq_ocorrencia_ret_w,'I') = 'L') and
			((vl_saldo_inclusao_w <> vl_cobranca_w) or
			((vl_liquidacao_w <> (vl_cobranca_w - vl_despesa_bancaria_w - vl_desconto_w + vl_juros_w + vl_multa_w + vl_acrescimo_w)))) then
			ds_retorno_w := wheb_mensagem_pck.get_texto(302137);
		elsif (ie_remessa_retorno_w = 'T') then
			if (ie_rejeitado_w = 'L') and ((obter_dados_titulo_rec_cobr(nr_seq_titulo_cobr_p,'DN'))::numeric  <> vl_desconto_w) then
				ds_retorno_w := wheb_mensagem_pck.get_texto(302138);
			elsif (substr(obter_tipo_ocorr_cobr_escrit(nr_seq_titulo_cobr_p),1,1) = 'B') then
				ds_retorno_w := wheb_mensagem_pck.get_texto(302139);
			end if;
		end if;
	end if;
elsif (ie_opcao_p = 'TOR') then
	select	max(a.nr_seq_ocorrencia_ret)
	into STRICT	nr_seq_ocorrencia_ret_w
	from	cobranca_escritural	b,
		titulo_receber_cobr	a
        where	b.nr_sequencia = a.nr_seq_cobranca
	and	a.nr_sequencia = nr_seq_titulo_cobr_p;

	ds_retorno_w := substr(obter_dados_bco_ocorr_escr_ret(nr_seq_ocorrencia_ret_w,'I'),1,1);
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_titulo_rec_cobr ( nr_seq_titulo_cobr_p bigint, ie_opcao_p text) FROM PUBLIC;
