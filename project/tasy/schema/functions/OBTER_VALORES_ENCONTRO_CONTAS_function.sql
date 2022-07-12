-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valores_encontro_contas (nr_titulo_p bigint, nr_seq_pessoa_p bigint, dt_referencia_p timestamp, ie_pagar_receber_p text, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE

 
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Retornar os valores do encontro de contas conforme a regra selecionada 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[X] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: Utilizado na "ENCONTRO_CONTAS_TITULOS_V" 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/ 
 
vl_retorno_w		double precision;
qt_regra_w		bigint;
ie_tipo_pessoa_w	varchar(255) := null;
ie_juros_w		varchar(1);
ie_multa_w		varchar(1);
ie_despesa_desconto_w	varchar(1);
cd_cgc_w		varchar(14);
cd_pessoa_fisica_w	varchar(10);
ie_juros_tot_w		varchar(1) := 'N';
ie_multa_tot_w		varchar(1) := 'N';
ie_despesa_desc_tot_w	varchar(1) := 'N';

C01 CURSOR FOR 
	SELECT	coalesce(a.ie_juros,'N'), 
		coalesce(a.ie_multa,'N'), 
		coalesce(a.ie_despesa_desconto,'N') 
	from	regra_receb_enc_contas	a 
	where	a.ie_tipo_pessoa	= ie_tipo_pessoa_w 
	order by 
		a.nr_sequencia desc;


BEGIN 
select	count(1) 
into STRICT	qt_regra_w 
from	regra_receb_enc_contas LIMIT 1;
 
if (qt_regra_w > 0) then 
	select	max(cd_cgc), 
		max(cd_pessoa_fisica) 
	into STRICT	cd_cgc_w, 
		cd_pessoa_fisica_w 
	from	pessoa_encontro_contas 
	where 	nr_sequencia = nr_seq_pessoa_p;
 
	if (cd_cgc_w IS NOT NULL AND cd_cgc_w::text <> '') then 
		select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'CO' END  
		into STRICT	ie_tipo_pessoa_w 
		from	pls_congenere 
		where	cd_cgc	= cd_cgc_w 
		and	coalesce(dt_exclusao::text, '') = ''  LIMIT 1;
		 
		if (ie_tipo_pessoa_w = 'N') then 
			select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'C' END  
			into STRICT	ie_tipo_pessoa_w 
			from	pls_cooperado 
			where	cd_cgc	= cd_cgc_w 
			and	coalesce(dt_exclusao::text, '') = ''  LIMIT 1;
			 
			if (ie_tipo_pessoa_w = 'N') then 
				ie_tipo_pessoa_w	:= 'CL';
			end if;
		end if;
	else 
		select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'C' END  
		into STRICT	ie_tipo_pessoa_w 
		from	pls_cooperado 
		where	cd_pessoa_fisica	= cd_pessoa_fisica_w 
		and	coalesce(dt_exclusao::text, '') = ''  LIMIT 1;
		 
		if (ie_tipo_pessoa_w = 'N') then 
			ie_tipo_pessoa_w	:= 'CL';
		end if;
	end if;
 
	open C01;
	loop 
	fetch C01 into 
		ie_juros_w, 
		ie_multa_w, 
		ie_despesa_desconto_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	end loop;
	close C01;
end if;
 
--INCLUIR JUROS E MULTA NOS TÍTULOS DO ENCONTRO 
if	((coalesce(ie_juros_w,'S') = 'S') or (ie_juros_w = 'R')) and (ie_pagar_receber_p = 'R') and (ie_opcao_p = 'J') then 
	select	coalesce(a.vl_juros, obter_juros_multa_titulo(b.nr_titulo, clock_timestamp(),'R','J')) 
	into STRICT	vl_retorno_w 
	from	titulo_receber b, 
		encontro_contas_item a 
	where	a.nr_titulo_receber	= b.nr_titulo 
	and	b.nr_titulo		= nr_titulo_p 
	and	a.nr_seq_pessoa		= nr_seq_pessoa_p 
	group by b.nr_titulo,a.vl_juros;
end if;
 
if	((coalesce(ie_multa_w,'S') = 'S') or (ie_multa_w = 'R')) and (ie_pagar_receber_p = 'R') and (ie_opcao_p = 'M') then 
	select	coalesce(a.vl_multa, obter_juros_multa_titulo(b.nr_titulo, clock_timestamp(),'R','M')) 
	into STRICT	vl_retorno_w 
	from	titulo_receber b, 
		encontro_contas_item a 
	where	a.nr_titulo_receber	= b.nr_titulo 
	and	b.nr_titulo		= nr_titulo_p 
	and	a.nr_seq_pessoa		= nr_seq_pessoa_p 
	group by b.nr_titulo,a.vl_multa;
end if;
 
if	((coalesce(ie_juros_w,'S') = 'S') or (ie_juros_w = 'P')) and (ie_pagar_receber_p = 'P') and (ie_opcao_p = 'J') then 
	select	coalesce(a.vl_juros, obter_juros_multa_titulo(b.nr_titulo, clock_timestamp(),'P','J')) 
	into STRICT	vl_retorno_w 
	from	titulo_pagar b, 
		encontro_contas_item a 
	where	a.nr_titulo_pagar	= b.nr_titulo 
	and	b.nr_titulo		= nr_titulo_p 
	and	a.nr_seq_pessoa		= nr_seq_pessoa_p 
	group by b.nr_titulo,a.vl_juros;
end if;
		 
if	((coalesce(ie_multa_w,'S') = 'S') or (ie_multa_w = 'P')) and (ie_pagar_receber_p = 'P') and (ie_opcao_p = 'M') then 
	select	coalesce(a.vl_multa, obter_juros_multa_titulo(b.nr_titulo, clock_timestamp(),'P','M')) 
	into STRICT	vl_retorno_w 
	from	titulo_pagar b, 
		encontro_contas_item a 
	where	a.nr_titulo_pagar	= b.nr_titulo 
	and	b.nr_titulo		= nr_titulo_p 
	and	a.nr_seq_pessoa		= nr_seq_pessoa_p 
	group by b.nr_titulo,a.vl_multa;
end if;
 
-- INCLUIR DESPESA E DESCONTO NOS TÍTULOS DO ENCONTRO 
if	((coalesce(ie_despesa_desconto_w,'S') = 'S') or (ie_despesa_desconto_w = 'R')) and (ie_pagar_receber_p = 'R') then 
	if (ie_opcao_p = 'DC') then 
		select	coalesce(b.vl_desc_previsto,0) 
		into STRICT	vl_retorno_w 
		from	titulo_receber b, 
			encontro_contas_item a 
		where	a.nr_titulo_receber	= b.nr_titulo 
		and	b.nr_titulo		= nr_titulo_p 
		and	a.nr_seq_pessoa		= nr_seq_pessoa_p 
		group by b.nr_titulo, 
			b.vl_desc_previsto;
	end if;
 
elsif	((coalesce(ie_despesa_desconto_w,'S') = 'S') or (ie_despesa_desconto_w = 'P')) and (ie_pagar_receber_p = 'P') then 
	if (ie_opcao_p = 'DC') then 
		select	coalesce(obter_valores_tit_pagar(b.nr_titulo,clock_timestamp(),'D'), b.vl_dia_antecipacao) 
		into STRICT	vl_retorno_w 
		from	titulo_pagar b, 
			encontro_contas_item a 
		where	a.nr_titulo_pagar	= b.nr_titulo 
		and	b.nr_titulo		= nr_titulo_p 
		and	a.nr_seq_pessoa		= nr_seq_pessoa_p 
		group by b.nr_titulo,b.vl_dia_antecipacao;
		 
	elsif (ie_opcao_p = 'DB') then 
		select	b.vl_outras_despesas 
		into STRICT	vl_retorno_w 
		from	titulo_pagar b, 
			encontro_contas_item a 
		where	a.nr_titulo_pagar	= b.nr_titulo 
		and	b.nr_titulo		= nr_titulo_p 
		and	a.nr_seq_pessoa		= nr_seq_pessoa_p 
		group by b.vl_outras_despesas;
	end if;
end if;
 
-- VALOR TOTAL 
if (ie_opcao_p = 'VT') then 
	if (ie_pagar_receber_p = 'R') then 
		if	((coalesce(ie_juros_w,'S') = 'S') or (ie_juros_w = 'R')) then 
			ie_juros_tot_w := 'S';
		end if;
		 
		if	((coalesce(ie_multa_w,'S') = 'S') or (ie_multa_w = 'R')) then 
			ie_multa_tot_w := 'S';
		end if;
		 
		if	((coalesce(ie_despesa_desconto_w,'S') = 'S') or (ie_despesa_desconto_w = 'R')) then 
			ie_despesa_desc_tot_w := 'S';
		end if;
 
		select (CASE WHEN ie_juros_tot_w='S' THEN coalesce(a.vl_juros, obter_juros_multa_titulo(b.nr_titulo, clock_timestamp(),'R','J'))  ELSE 0 END  + 
			CASE WHEN ie_multa_tot_w='S' THEN coalesce(a.vl_multa, obter_juros_multa_titulo(b.nr_titulo, clock_timestamp(),'R','M'))  ELSE 0 END  + 
			b.vl_titulo) - 
			CASE WHEN ie_despesa_desc_tot_w='S' THEN coalesce(b.vl_desc_previsto,0)  ELSE 0 END  - 
			CASE WHEN ie_despesa_desc_tot_w='S' THEN coalesce(obter_valores_tit_rec(b.nr_titulo,'D'),0)  ELSE 0 END  - 
			coalesce(obter_valores_tit_rec(b.nr_titulo,'VG'),0) 
		into STRICT	vl_retorno_w 
		from	titulo_receber b, 
			encontro_contas_item a 
		where	a.nr_titulo_receber	= b.nr_titulo 
		and	b.nr_titulo		= nr_titulo_p 
		and	a.nr_seq_pessoa		= nr_seq_pessoa_p 
		group by b.nr_titulo, 
			a.vl_juros, 
			a.vl_multa, 
			b.vl_saldo_titulo, 
			b.vl_titulo, 
			b.vl_desc_previsto;
			 
	elsif (ie_pagar_receber_p = 'P') then	 
		if	((coalesce(ie_juros_w,'S') = 'S') or (ie_juros_w = 'P')) then 
			ie_juros_tot_w := 'S';
		end if;
		 
		if	((coalesce(ie_multa_w,'S') = 'S') or (ie_multa_w = 'P')) then 
			ie_multa_tot_w := 'S';
		end if;
		 
		if	((coalesce(ie_despesa_desconto_w,'S') = 'S') or (ie_despesa_desconto_w = 'P')) then 
			ie_despesa_desc_tot_w := 'S';
		end if;
	 
		select (CASE WHEN ie_juros_tot_w='S' THEN coalesce(a.vl_juros, obter_juros_multa_titulo(b.nr_titulo, clock_timestamp(),'P','J'))  ELSE 0 END  + 
			CASE WHEN ie_multa_tot_w='S' THEN coalesce(a.vl_multa, obter_juros_multa_titulo(b.nr_titulo, clock_timestamp(),'P','M'))  ELSE 0 END  + 
			coalesce(b.vl_outros_acrescimos,0) + 
			b.vl_titulo) - 
			CASE WHEN ie_despesa_desc_tot_w='S' THEN  coalesce(obter_valores_tit_pagar(b.nr_titulo,clock_timestamp(),'D'), coalesce(b.vl_dia_antecipacao,0))  ELSE 0 END  + 
			CASE WHEN ie_despesa_desc_tot_w='S' THEN coalesce(b.vl_outras_despesas,0)  ELSE 0 END  - 
			coalesce(obter_valores_tit_pagar(b.nr_titulo,clock_timestamp(),'VG'),0) 
		into STRICT	vl_retorno_w 
		from	titulo_pagar b, 
			encontro_contas_item a 
		where	a.nr_titulo_pagar	= b.nr_titulo 
		and	b.nr_titulo		= nr_titulo_p 
		and	a.nr_seq_pessoa		= nr_seq_pessoa_p 
		group by b.nr_titulo, 
			a.vl_juros, 
			a.vl_multa, 
			b.vl_saldo_titulo, 
			b.vl_titulo, 
			b.vl_dia_antecipacao, 
			b.vl_outras_despesas, 
			b.vl_outros_acrescimos;
	end if;
end if;
 
--Valor total a receber / pagar 
if (ie_opcao_p = 'RP') then 
	if (ie_pagar_receber_p = 'R') then 
		if	((coalesce(ie_juros_w,'S') = 'S') or (ie_juros_w = 'R')) then 
			ie_juros_tot_w := 'S';
		end if;
		 
		if	((coalesce(ie_multa_w,'S') = 'S') or (ie_multa_w = 'R')) then 
			ie_multa_tot_w := 'S';
		end if;
		 
		if	((coalesce(ie_despesa_desconto_w,'S') = 'S') or (ie_despesa_desconto_w = 'R')) then 
			ie_despesa_desc_tot_w := 'S';
		end if;
 
		select (CASE WHEN ie_juros_tot_w='S' THEN coalesce(a.vl_juros, obter_juros_multa_titulo(b.nr_titulo, clock_timestamp(),'R','J'))  ELSE 0 END  + 
			CASE WHEN ie_multa_tot_w='S' THEN coalesce(a.vl_multa, obter_juros_multa_titulo(b.nr_titulo, clock_timestamp(),'R','M'))  ELSE 0 END  + 
			b.vl_titulo) - 
			CASE WHEN ie_despesa_desc_tot_w='S' THEN coalesce(b.vl_desc_previsto,0)  ELSE 0 END  - 
			CASE WHEN ie_despesa_desc_tot_w='S' THEN coalesce(obter_valores_tit_rec(b.nr_titulo,'D'),0)  ELSE 0 END  - 
			coalesce(obter_valores_tit_rec(b.nr_titulo,'VG'),0) - 
			coalesce(obter_valores_tit_rec(b.nr_titulo,'R'),0) 
		into STRICT	vl_retorno_w 
		from	titulo_receber b, 
			encontro_contas_item a 
		where	a.nr_titulo_receber	= b.nr_titulo 
		and	b.nr_titulo		= nr_titulo_p 
		and	a.nr_seq_pessoa		= nr_seq_pessoa_p 
		group by b.nr_titulo, 
			a.vl_juros, 
			a.vl_multa, 
			b.vl_saldo_titulo, 
			b.vl_titulo, 
			b.vl_desc_previsto;
			 
	elsif (ie_pagar_receber_p = 'P') then	 
		if	((coalesce(ie_juros_w,'S') = 'S') or (ie_juros_w = 'P')) then 
			ie_juros_tot_w := 'S';
		end if;
		 
		if	((coalesce(ie_multa_w,'S') = 'S') or (ie_multa_w = 'P')) then 
			ie_multa_tot_w := 'S';
		end if;
		 
		if	((coalesce(ie_despesa_desconto_w,'S') = 'S') or (ie_despesa_desconto_w = 'P')) then 
			ie_despesa_desc_tot_w := 'S';
		end if;
	 
		select (CASE WHEN ie_juros_tot_w='S' THEN coalesce(a.vl_juros, obter_juros_multa_titulo(b.nr_titulo, clock_timestamp(),'P','J'))  ELSE 0 END  + 
			CASE WHEN ie_multa_tot_w='S' THEN coalesce(a.vl_multa, obter_juros_multa_titulo(b.nr_titulo, clock_timestamp(),'P','M'))  ELSE 0 END  + 
			coalesce(b.vl_outros_acrescimos,0) + 
			b.vl_titulo) - 
			CASE WHEN ie_despesa_desc_tot_w='S' THEN  coalesce(obter_valores_tit_pagar(b.nr_titulo,clock_timestamp(),'D'), coalesce(b.vl_dia_antecipacao,0))  ELSE 0 END  + 
			CASE WHEN ie_despesa_desc_tot_w='S' THEN coalesce(b.vl_outras_despesas,0)  ELSE 0 END  - 
			coalesce(obter_valores_tit_pagar(b.nr_titulo,clock_timestamp(),'VG'),0) - 
			coalesce(obter_valores_tit_pagar(b.nr_titulo,clock_timestamp(),'B'),0) 
		into STRICT	vl_retorno_w 
		from	titulo_pagar b, 
			encontro_contas_item a 
		where	a.nr_titulo_pagar	= b.nr_titulo 
		and	b.nr_titulo		= nr_titulo_p 
		and	a.nr_seq_pessoa		= nr_seq_pessoa_p 
		group by b.nr_titulo, 
			a.vl_juros, 
			a.vl_multa, 
			b.vl_saldo_titulo, 
			b.vl_titulo, 
			b.vl_dia_antecipacao, 
			b.vl_outras_despesas, 
			b.vl_outros_acrescimos;
	end if;
end if;
 
return	coalesce(vl_retorno_w,0);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valores_encontro_contas (nr_titulo_p bigint, nr_seq_pessoa_p bigint, dt_referencia_p timestamp, ie_pagar_receber_p text, ie_opcao_p text) FROM PUBLIC;
