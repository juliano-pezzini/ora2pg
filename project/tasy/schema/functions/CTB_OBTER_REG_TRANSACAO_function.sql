-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_reg_transacao ( nr_seq_regra_p bigint, nr_seq_trans_financ_p bigint, ie_debito_credito_p text, ie_origem_titulo_p text, nm_atributo_p text, vl_comparacao_p text, ie_tipo_valor_p text) RETURNS varchar AS $body$
DECLARE


/*
Essa function é utilizada na gerar_contab_trans_financ para obter a quantidade de regras específicas para um tipo de recebimento, origem de título, etc...
*/
ds_retorno_w				varchar(1);
qt_regra_tipo_rec_w			bigint;


BEGIN
ds_retorno_w := 'S';

if (coalesce(nr_seq_regra_p,0) <> 0) then

	if (ie_tipo_valor_p = 'OTR') and (coalesce(vl_comparacao_p,'X') <> 'X') then

		select	count(*)
		into STRICT	qt_regra_tipo_rec_w
		from	trans_financ_contab a
		where	a.nr_seq_trans_financ	= nr_seq_trans_financ_p
		and		a.nm_atributo			= nm_atributo_p
		and		a.ie_origem_tit_receber	= vl_comparacao_p
		and 	a.ie_debito_credito		= ie_debito_credito_p
		and		a.ie_situacao			= 'A';

		if (qt_regra_tipo_rec_w > 0) then

			if (coalesce(ie_origem_titulo_p,'X') <> vl_comparacao_p) then
				ds_retorno_w := 'N';
			end if;

		else

			if (coalesce(ie_origem_titulo_p,'X') <> 'X') then
				ds_retorno_w := 'N';
			end if;

		end if;

	elsif (ie_tipo_valor_p = 'OTP') and (coalesce(vl_comparacao_p,'X') <> 'X') then

		select	count(*)
		into STRICT	qt_regra_tipo_rec_w
		from	trans_financ_contab a
		where	a.nr_seq_trans_financ	= nr_seq_trans_financ_p
		and		a.nm_atributo			= nm_atributo_p
		and		a.ie_origem_tit_pagar	= vl_comparacao_p
		and 	a.ie_debito_credito		= ie_debito_credito_p
		and		a.ie_situacao			= 'A';

		if (qt_regra_tipo_rec_w > 0) then

			if (coalesce(ie_origem_titulo_p,'X') <> vl_comparacao_p) then
				ds_retorno_w := 'N';
			end if;

		else

			if (coalesce(ie_origem_titulo_p,'X') <> 'X') then
				ds_retorno_w := 'N';
			end if;

		end if;

	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_reg_transacao ( nr_seq_regra_p bigint, nr_seq_trans_financ_p bigint, ie_debito_credito_p text, ie_origem_titulo_p text, nm_atributo_p text, vl_comparacao_p text, ie_tipo_valor_p text) FROM PUBLIC;

