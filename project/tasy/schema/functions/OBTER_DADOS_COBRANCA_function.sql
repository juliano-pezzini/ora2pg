-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_cobranca ( nr_sequencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
/* 
1 - dt_inclusao, qdo a cobrança for de cheque 
2 - paciente da cobrança 
3 - Produto Financeiro 
4 - paciente da cobrança, cd_pessoa_fisica 
5 - Historico 
6 - Estabalecimento 
*/
 
 
dt_inclusao_w		timestamp;
ds_retorno_w		varchar(255) := null;
nm_pessoa_fisica_w	varchar(255) := null;
nr_atendimento_w	bigint;
nr_seq_cheque_w		bigint;
nr_titulo_w		bigint;
cd_pessoa_fisica_w	varchar(10);


BEGIN 
if (ie_opcao_p	= '1') then 
	begin 
	select	max(dt_inclusao) 
	into STRICT	dt_inclusao_w 
	from	cobranca 
	where	nr_seq_cheque	= nr_sequencia_p;
	exception 
		when others then 
			ds_retorno_w	:= null;
	end;
	ds_retorno_w	:= dt_inclusao_w;
elsif (ie_opcao_p	= '2') then		 
	select	max(a.nr_atendimento) 
	into STRICT	nr_atendimento_w 
	from 	titulo_receber a, 
		cobranca b 
	where	b.nr_sequencia	= nr_sequencia_p 
	and	b.nr_titulo	= a.nr_titulo;
	 
    if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then 
		select substr(obter_nome_pf(cd_pessoa_fisica),1,60) 
        into STRICT  nm_pessoa_fisica_w 
        from  atendimento_paciente 
        where  nr_atendimento = nr_atendimento_w;
	end if;
	 
	if (coalesce(nm_pessoa_fisica_w::text, '') = '') then 
		select	max(nr_seq_cheque) 
		into STRICT	nr_seq_cheque_w 
		from	cobranca 
		where 	nr_sequencia	= nr_sequencia_p;	
	 
		nm_pessoa_fisica_w	:= obter_dados_cheque_cr(nr_seq_cheque_w, 'NP');
 
	end if;
	ds_retorno_w	:= nm_pessoa_fisica_w;
elsif (ie_opcao_p	= '3') then 
 
	select	max(nr_titulo), 
		max(nr_seq_cheque) 
	into STRICT	nr_titulo_w, 
		nr_seq_cheque_w 
	from	cobranca 
	where	nr_sequencia	= nr_sequencia_p;
	 
	if (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then 
		ds_retorno_w := OBTER_PROD_FINANC(nr_titulo_w,'TR','P');
	elsif (nr_seq_cheque_w IS NOT NULL AND nr_seq_cheque_w::text <> '') then 
		ds_retorno_w := OBTER_PROD_FINANC(nr_seq_cheque_w,'CH','P');
	end if;
elsif (ie_opcao_p	= '4') then		 
	select	max(a.nr_atendimento) 
	into STRICT	nr_atendimento_w 
	from 	titulo_receber a, 
		cobranca b 
	where	b.nr_sequencia	= nr_sequencia_p 
	and	b.nr_titulo	= a.nr_titulo;
	 
    if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then 
		select cd_pessoa_fisica 
        into STRICT  cd_pessoa_fisica_w 
        from  atendimento_paciente 
        where  nr_atendimento = nr_atendimento_w;
	end if;
	 
	if (coalesce(cd_pessoa_fisica_w::text, '') = '') then 
		select	max(nr_seq_cheque) 
		into STRICT	nr_seq_cheque_w 
		from	cobranca 
		where 	nr_sequencia	= nr_sequencia_p;	
	 
		cd_pessoa_fisica_w	:= obter_dados_cheque_cr(nr_seq_cheque_w, 'CP');
 
	end if;
	ds_retorno_w	:= cd_pessoa_fisica_w;	
elsif (ie_opcao_p	= '5') then 
	select	max(substr(ds_historico,1,255)) 
	into STRICT	ds_retorno_w 
	from	cobranca_historico 
	where	nr_seq_cobranca = nr_sequencia_p;
elsif (ie_opcao_p	= '6') then 
	select	obter_nome_estabelecimento(max(cd_estabelecimento)) 
	into STRICT	ds_retorno_w 
	from	cobranca 
	where	nr_sequencia = nr_sequencia_p;
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_cobranca ( nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;

