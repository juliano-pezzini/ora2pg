-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_valida_formulario_benef ( nr_carteira_p text, dt_nasc_p text, nr_cpf_p text, nr_rg_p text, ds_email_p text, ds_retorno_p INOUT text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Validar os campos, comparando os que estao cadastrados na base, com os dados informados pelo beneficiario, no cadastro do login.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [ x ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w			varchar(255) := 'S';
nr_seq_segurado_w		bigint;
dt_nascimento_w			timestamp;
nr_cpf_w			varchar(11);
nr_rg_w				varchar(15);
nr_rg_estrang_w			varchar(30);
ds_email_w			varchar(60);
ie_brasileiro_w			varchar(1);
nm_pessoa_fisica_w		varchar(60);
cd_nacionalidade_w		varchar(8);
cd_pessoa_fisica_w		varchar(10);
nr_seq_compl_pf_w		smallint;
nr_sequencia_w			smallint;
qt_idade_w			smallint;
nm_segurado_w			varchar(15);

/* Retorna a mensagem com o erro ocorrido ou S quando esta tudo ok.
Na mensagem de erro contem a mensagem e um codigo para definir o campo que deve receber o focus.
1 - Carteira
2 - Email
3 - Data de nascimento
4 - CPF
5 - RG

Obs: Nome nao sera mais utilizado no portal.
*/
BEGIN

nr_seq_segurado_w := pls_obter_dados_carteira(null, nr_carteira_p, 'S');

if (coalesce(nr_seq_segurado_w::text, '') = '') then
	ds_retorno_w := wheb_mensagem_pck.get_texto(1206647) || '#1';
else
	select	a.dt_nascimento,
		obter_idade_pf(a.cd_pessoa_fisica,clock_timestamp(),'A') qt_idade,
		a.nr_cpf,
		a.nr_identidade,
		a.nr_reg_geral_estrang,
		obter_compl_pf(a.cd_pessoa_fisica, 1, 'M'),
		a.nm_pessoa_pesquisa,
		a.cd_pessoa_fisica,
		a.cd_nacionalidade,
		substr(tws_get_name_person(b.cd_pessoa_fisica, b.cd_estabelecimento),1,15) nm_segurado
	into STRICT	dt_nascimento_w,
		qt_idade_w,
		nr_cpf_w,
		nr_rg_w,
		nr_rg_estrang_w,
		ds_email_w,
		nm_pessoa_fisica_w,
		cd_pessoa_fisica_w,
		cd_nacionalidade_w,
		nm_segurado_w
	from	pessoa_fisica	a,
		pls_segurado	b
	where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
	and	b.nr_sequencia		= nr_seq_segurado_w;
	
	if (coalesce(dt_nascimento_w::text, '') = '' and (dt_nasc_p IS NOT NULL AND dt_nasc_p::text <> '')) then
		ds_retorno_w	:= wheb_mensagem_pck.get_texto(1206651) || '#3';
	elsif (trunc(dt_nascimento_w) <> to_date(dt_nasc_p, 'dd/mm/yyyy')) then
		ds_retorno_w	:= wheb_mensagem_pck.get_texto(128686) || '#3';
	end if;
	
	if (nr_cpf_p IS NOT NULL AND nr_cpf_p::text <> '') then
		
		if (coalesce(nr_cpf_w::text, '') = '') then
			ds_retorno_w	:= wheb_mensagem_pck.get_texto(1206652) || '#4';
		elsif (nr_cpf_p <> nr_cpf_w) then
			ds_retorno_w	:= wheb_mensagem_pck.get_texto(1206648) || '#4';
		end if;
	else
		select	max(ie_brasileiro)
		into STRICT	ie_brasileiro_w
		from	nacionalidade
		where	cd_nacionalidade = cd_nacionalidade_w;
		
		if (ie_brasileiro_w = 'N') then
			if (coalesce(nr_rg_estrang_w::text, '') = '') then
				ds_retorno_w 	:= wheb_mensagem_pck.get_texto(1206653) || '#5';
			elsif (nr_rg_estrang_w != nr_rg_p) then
				ds_retorno_w 	:= wheb_mensagem_pck.get_texto(1206650) || '#5';
			end if;
		elsif (ie_brasileiro_w = 'S') then
			if (coalesce(nr_rg_w::text, '') = '' and qt_idade_w >=18) then
				ds_retorno_w 	:= wheb_mensagem_pck.get_texto(1206654) || '#5';
			elsif (nr_rg_w != nr_rg_p) then
				ds_retorno_w 	:= wheb_mensagem_pck.get_texto(1206649) || '#5';
			end if;
		elsif (nr_rg_w IS NOT NULL AND nr_rg_w::text <> '') and (nr_rg_w != nr_rg_p) then
			ds_retorno_w 	:= wheb_mensagem_pck.get_texto(1206649) || '#5';
		elsif (nr_rg_estrang_w IS NOT NULL AND nr_rg_estrang_w::text <> '') and (nr_rg_estrang_w != nr_rg_p) then
			ds_retorno_w 	:= wheb_mensagem_pck.get_texto(1206650) || '#5';
		end if;
	end if;
	
	if (ds_retorno_w = 'S') then
		select	max(nr_sequencia)
		into STRICT	nr_seq_compl_pf_w
		from	compl_pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_w
		and	ie_tipo_complemento	= 1;
		
		if	(((nr_seq_compl_pf_w IS NOT NULL AND nr_seq_compl_pf_w::text <> '') and nr_seq_compl_pf_w > 0) and (ds_email_w != ds_email_p or coalesce(ds_email_w::text, '') = '')) then
			update	compl_pessoa_fisica
			set	ds_email 		= ds_email_p,
				dt_atualizacao 		= clock_timestamp(),
				nm_usuario		= nm_segurado_w
			where	cd_pessoa_fisica 	= cd_pessoa_fisica_w
			and	ie_tipo_complemento	= 1;
			commit;
		elsif (coalesce(nr_seq_compl_pf_w::text, '') = '') then
			select	max(nr_sequencia)
			into STRICT	nr_sequencia_w
			from	compl_pessoa_fisica;
			nr_sequencia_w := nr_sequencia_w + 1;
			insert	into	compl_pessoa_fisica(nr_sequencia, cd_pessoa_fisica, ie_tipo_complemento,
					ds_email, dt_atualizacao, nm_usuario)
			values (nr_sequencia_w, cd_pessoa_fisica_w, 1,
					ds_email_p, clock_timestamp(), nm_segurado_w);
			commit;
		end if;
	end if;
end if;

ds_retorno_p := ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_valida_formulario_benef ( nr_carteira_p text, dt_nasc_p text, nr_cpf_p text, nr_rg_p text, ds_email_p text, ds_retorno_p INOUT text) FROM PUBLIC;
