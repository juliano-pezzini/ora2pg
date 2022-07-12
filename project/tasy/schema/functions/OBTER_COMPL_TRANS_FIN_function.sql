-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_compl_trans_fin ( nr_sequencia_p bigint, ie_resultado_p text) RETURNS varchar AS $body$
DECLARE

/* ie_resultado 
	N	- Nome 
	PF	- Codigo da pessoa fisica 
	PJ	- Codigo da pessoa juridica */
 
 
ds_compl_hist_w		varchar(255);
cd_pessoa_fisica_w	varchar(010);
cd_cgc_w		varchar(014);
nr_seq_titulo_pagar_w	bigint;
nr_seq_titulo_receber_w	bigint;
nr_adiantamento_w		bigint;
nr_seq_banco_od_w	bigint;
nr_seq_nota_fiscal_w	bigint;
nr_interno_conta_w		bigint;
nr_adiant_pago_w		bigint;
nr_nf_w			numeric(20);


BEGIN 
 
ds_compl_hist_w		:= '';
select cd_pessoa_fisica, 
	cd_cgc, 
	nr_seq_titulo_pagar, 
	nr_seq_titulo_receber, 
	nr_adiantamento, 
	nr_seq_banco_od, 
	nr_seq_nota_fiscal, 
	nr_interno_conta, 
	nr_adiant_pago 
into STRICT		 
	cd_pessoa_fisica_w, 
	cd_cgc_w, 
	nr_seq_titulo_pagar_w, 
	nr_seq_titulo_receber_w, 
	nr_adiantamento_w, 
	nr_seq_banco_od_w, 
	nr_seq_nota_fiscal_w, 
	nr_interno_conta_w, 
	nr_adiant_pago_w 
from	movto_trans_financ 
where	nr_sequencia		= nr_sequencia_p;
 
if (ie_resultado_p = 'N') then 
	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') or (cd_cgc_w IS NOT NULL AND cd_cgc_w::text <> '') then 
		select substr(obter_nome_pf_pj(cd_pessoa_fisica_w, cd_cgc_w),1,255) 
		into STRICT ds_compl_hist_w 
		;
	elsif (nr_seq_titulo_pagar_w IS NOT NULL AND nr_seq_titulo_pagar_w::text <> '') then 
		select Obter_Pessoa_Titulo_Pagar(nr_seq_titulo_pagar_w), 
			nr_documento 
		into STRICT 	ds_compl_hist_w, 
			nr_nf_w 
		from titulo_pagar 
		where	nr_titulo	= nr_seq_titulo_pagar_w;
		ds_compl_hist_w	:= substr(nr_nf_w || ' (' || 
					nr_seq_titulo_pagar_w || ') ' || ds_compl_hist_w || ' ',1,255);
	elsif (nr_seq_titulo_receber_w IS NOT NULL AND nr_seq_titulo_receber_w::text <> '') then 
		select Obter_Pessoa_Titulo_receber(nr_seq_titulo_receber_w) 
		into STRICT ds_compl_hist_w 
		;
		ds_compl_hist_w	:= substr(ds_compl_hist_w || ' (' || nr_seq_titulo_receber_w || ')',1,255);
	elsif (nr_adiantamento_w IS NOT NULL AND nr_adiantamento_w::text <> '') then 
		select obter_nome_pf_pj(cd_pessoa_fisica,cd_cgc) 
		into STRICT ds_compl_hist_w 
		from adiantamento 
		where nr_adiantamento	= nr_adiantamento_w;
	elsif (nr_adiant_pago_w IS NOT NULL AND nr_adiant_pago_w::text <> '') then 
		select Obter_Pessoa_Adiant_pago(nr_adiant_pago_w) 
		into STRICT ds_compl_hist_w 
		;
	elsif (nr_interno_conta_w IS NOT NULL AND nr_interno_conta_w::text <> '') then 
		select Obter_Pessoa_Conta(nr_interno_conta_w,'D') 
		into STRICT ds_compl_hist_w 
		;
	end if;
elsif (ie_resultado_p = 'PF') then 
	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then 
		ds_compl_hist_w		:= cd_pessoa_fisica_w;
	elsif (nr_seq_titulo_pagar_w IS NOT NULL AND nr_seq_titulo_pagar_w::text <> '') then 
		select max(cd_pessoa_fisica) 
		into STRICT 	ds_compl_hist_w 
		from	titulo_pagar 
		where	nr_titulo	= nr_seq_titulo_pagar_w;
	elsif (nr_seq_titulo_receber_w IS NOT NULL AND nr_seq_titulo_receber_w::text <> '') then 
		select max(cd_pessoa_fisica) 
		into STRICT 	ds_compl_hist_w 
		from	titulo_receber 
		where	nr_titulo	= nr_seq_titulo_receber_w;
	elsif (nr_adiantamento_w IS NOT NULL AND nr_adiantamento_w::text <> '') then 
		select max(cd_pessoa_fisica) 
		into STRICT 	ds_compl_hist_w 
		from	adiantamento 
		where	nr_adiantamento	= nr_adiantamento_w;
	elsif (nr_adiant_pago_w IS NOT NULL AND nr_adiant_pago_w::text <> '') then 
		select max(cd_pessoa_fisica) 
		into STRICT 	ds_compl_hist_w 
		from	adiantamento_pago 
		where	nr_adiantamento	= nr_adiant_pago_w;
	elsif (nr_interno_conta_w IS NOT NULL AND nr_interno_conta_w::text <> '') then 
		select Obter_Pessoa_Conta(nr_interno_conta_w,'C') 
		into STRICT ds_compl_hist_w 
		;
	end if;
elsif (ie_resultado_p = 'PJ') then 
	if (cd_cgc_w IS NOT NULL AND cd_cgc_w::text <> '') then 
		ds_compl_hist_w		:= cd_cgc_w;
	elsif (nr_seq_titulo_pagar_w IS NOT NULL AND nr_seq_titulo_pagar_w::text <> '') then 
		select max(cd_cgc) 
		into STRICT 	ds_compl_hist_w 
		from	titulo_pagar 
		where	nr_titulo	= nr_seq_titulo_pagar_w;
	elsif (nr_seq_titulo_receber_w IS NOT NULL AND nr_seq_titulo_receber_w::text <> '') then 
		select max(cd_cgc) 
		into STRICT 	ds_compl_hist_w 
		from	titulo_receber 
		where	nr_titulo	= nr_seq_titulo_receber_w;
	elsif (nr_adiantamento_w IS NOT NULL AND nr_adiantamento_w::text <> '') then 
		select max(cd_cgc) 
		into STRICT 	ds_compl_hist_w 
		from	adiantamento 
		where	nr_adiantamento	= nr_adiantamento_w;
	elsif (nr_adiant_pago_w IS NOT NULL AND nr_adiant_pago_w::text <> '') then 
		select max(cd_cgc) 
		into STRICT 	ds_compl_hist_w 
		from	adiantamento_pago 
		where	nr_adiantamento	= nr_adiant_pago_w;
	end if;
end if;
 
return	ds_compl_hist_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_compl_trans_fin ( nr_sequencia_p bigint, ie_resultado_p text) FROM PUBLIC;

