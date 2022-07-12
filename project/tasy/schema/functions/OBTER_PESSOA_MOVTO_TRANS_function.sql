-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pessoa_movto_trans ( nr_seq_trans_fin_p bigint, ie_tipo_dado_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
/*	ie_tipo_dado_p 
 
'C'	- Código 
'N'	- Nome 
'CF'	- Código pessoa física 
'CJ'	- Código pessoa jurídica 
 
	ie_opcao_p 
 
'GE'	- Geral 
 
'TP'	- Título a pagar 
'TR'	- Título a receber 
'AD'	- Adiantamento 
'NF'	- Nota fiscal 
'AP'	- Adiantamento pago 
'CH'	- Cheque (contas a receber) 
'CA'	- Cartão 
'CP'	- Cheque (contas a pagar) 
*/
 
 
cd_pessoa_fisica_w		varchar(10);
cd_cgc_w			varchar(14);
nr_titulo_pagar_w		bigint;
nr_titulo_receber_w		bigint;
nr_adiantamento_w		bigint;
nr_adiant_pago_w		bigint;
nr_seq_nota_fiscal_w		bigint;
nr_seq_cheque_w			bigint;
nr_seq_movto_cartao_w		bigint;
nr_seq_cheque_cp_w		bigint;

ds_retorno_w			varchar(60);


BEGIN 
 
select	a.cd_pessoa_fisica, 
	a.cd_cgc, 
	a.nr_seq_titulo_pagar, 
	a.nr_seq_titulo_receber, 
	a.nr_adiantamento, 
	a.nr_adiant_pago, 
	a.nr_seq_nota_fiscal, 
	a.nr_seq_cheque, 
	a.nr_seq_movto_cartao, 
	a.nr_seq_cheque_cp 
into STRICT	cd_pessoa_fisica_w, 
	cd_cgc_w, 
	nr_titulo_pagar_w, 
	nr_titulo_receber_w, 
	nr_adiantamento_w, 
	nr_adiant_pago_w, 
	nr_seq_nota_fiscal_w, 
	nr_seq_cheque_w, 
	nr_seq_movto_cartao_w, 
	nr_seq_cheque_cp_w 
from	movto_trans_financ a 
where	a.nr_sequencia	= nr_seq_trans_fin_p;
 
if (ie_opcao_p = 'TP') or ((coalesce(ie_opcao_p,'GE') = 'GE') and (coalesce(cd_pessoa_fisica_w,0) = 0) and (coalesce(cd_cgc_w,0) = 0)) then 
	select	max(a.cd_pessoa_fisica), 
		max(a.cd_cgc) 
	into STRICT	cd_pessoa_fisica_w, 
		cd_cgc_w 
	from	titulo_pagar a 
	where	a.nr_titulo	= nr_titulo_pagar_w;
end if;
 
if (ie_opcao_p = 'TR') or ((coalesce(ie_opcao_p,'GE') = 'GE') and (coalesce(cd_pessoa_fisica_w,0) = 0) and (coalesce(cd_cgc_w,0) = 0)) then 
	select	max(a.cd_pessoa_fisica), 
		max(a.cd_cgc) 
	into STRICT	cd_pessoa_fisica_w, 
		cd_cgc_w 
	from	titulo_receber a 
	where	a.nr_titulo	= nr_titulo_receber_w;
end if;
 
if (ie_opcao_p = 'AD') or ((coalesce(ie_opcao_p,'GE') = 'GE') and (coalesce(cd_pessoa_fisica_w,0) = 0) and (coalesce(cd_cgc_w,0) = 0)) then 
	select	max(a.cd_pessoa_fisica), 
		max(a.cd_cgc) 
	into STRICT	cd_pessoa_fisica_w, 
		cd_cgc_w 
	from	adiantamento a 
	where	a.nr_adiantamento	= nr_adiantamento_w;
end if;
 
if (ie_opcao_p = 'AP') or ((coalesce(ie_opcao_p,'GE') = 'GE') and (coalesce(cd_pessoa_fisica_w,0) = 0) and (coalesce(cd_cgc_w,0) = 0)) then 
	select	max(a.cd_pessoa_fisica), 
		max(a.cd_cgc) 
	into STRICT	cd_pessoa_fisica_w, 
		cd_cgc_w 
	from	adiantamento_pago a 
	where	a.nr_adiantamento	= nr_adiant_pago_w;
end if;
 
if (ie_opcao_p = 'NF') or ((coalesce(ie_opcao_p,'GE') = 'GE') and (coalesce(cd_pessoa_fisica_w,0) = 0) and (coalesce(cd_cgc_w,0) = 0)) then 
	select	max(a.cd_pessoa_fisica), 
		max(a.cd_cgc) 
	into STRICT	cd_pessoa_fisica_w, 
		cd_cgc_w 
	from	nota_fiscal a 
	where	a.nr_sequencia	= nr_seq_nota_fiscal_w;
end if;
 
if (ie_opcao_p = 'CH') or ((coalesce(ie_opcao_p,'GE') = 'GE') and (coalesce(cd_pessoa_fisica_w,0) = 0) and (coalesce(cd_cgc_w,0) = 0)) then 
	select	max(a.cd_pessoa_fisica), 
		max(a.cd_cgc) 
	into STRICT	cd_pessoa_fisica_w, 
		cd_cgc_w 
	from	cheque_cr a 
	where	a.nr_seq_cheque	= nr_seq_cheque_w;
end if;
 
if (ie_opcao_p = 'CA') or ((coalesce(ie_opcao_p,'GE') = 'GE') and (coalesce(cd_pessoa_fisica_w,0) = 0) and (coalesce(cd_cgc_w,0) = 0)) then 
	select	max(a.cd_pessoa_fisica), 
		max(a.cd_cgc) 
	into STRICT	cd_pessoa_fisica_w, 
		cd_cgc_w 
	from	movto_cartao_cr a 
	where	a.nr_sequencia	= nr_seq_movto_cartao_w;
end if;
 
if (ie_opcao_p = 'CP') or ((coalesce(ie_opcao_p,'GE') = 'GE') and (coalesce(cd_pessoa_fisica_w,0) = 0) and (coalesce(cd_cgc_w,0) = 0)) then 
	select	max(a.cd_pessoa_destinatario), 
		max(a.cd_cgc_destinatario) 
	into STRICT	cd_pessoa_fisica_w, 
		cd_cgc_w 
	from	cheque a 
	where	a.nr_sequencia	= nr_seq_cheque_cp_w;
end if;
 
if (ie_tipo_dado_p = 'C') then 
	ds_retorno_w	:= coalesce(cd_pessoa_fisica_w, cd_cgc_w);
elsif (ie_tipo_dado_p = 'CF') then 
	ds_retorno_w	:= cd_pessoa_fisica_w;
elsif (ie_tipo_dado_p = 'CJ') then 
	ds_retorno_w	:= cd_cgc_w;
elsif (ie_tipo_dado_p = 'N') then 
	ds_retorno_w	:= substr(obter_nome_pf_pj(cd_pessoa_fisica_w, cd_cgc_w),1,60);
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pessoa_movto_trans ( nr_seq_trans_fin_p bigint, ie_tipo_dado_p text, ie_opcao_p text) FROM PUBLIC;

