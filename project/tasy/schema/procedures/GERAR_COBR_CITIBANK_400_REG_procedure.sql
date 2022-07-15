-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cobr_citibank_400_reg ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


/*===========================================================
	             =>>>>>	A T E N Ç Ã O        <<<<<<=

Esta procedure é uma cópia da GERAR_COBR_CITIBANK_400,
para atender a OS 1196249, porém não foi validada com o banco

Como se trata de um projeto e não possuímos cliente para validar junto
ao banco, os defeitos devem ser verificados com o analista (Peterson) antes
de serem documentados.
============================================================*/
ds_conteudo_w			varchar(400);
cd_convenio_banco_w		varchar(20);
nm_empresa_w			varchar(30);
dt_geracao_w			varchar(6);
nr_seq_reg_arquivo_w	bigint	:= 0;

ie_tipo_pessoa_w		varchar(2);
nr_inscricao_w			varchar(14);
nr_titulo_w				titulo_receber.nr_titulo%type;
nr_nosso_numero_w		titulo_receber.nr_nosso_numero%type;
dt_pagamento_previsto_w	varchar(6);
vl_titulo_w				titulo_receber.vl_titulo%type;
dt_emissao_w			varchar(6);
dt_limite_desconto_w	varchar(6);
vl_desconto_previsto_w	titulo_receber.vl_desc_previsto%type;
ie_tipo_pessoa_sacado_w	varchar(2);
nr_inscricao_sacado_w	varchar(14);
nm_sacado_w				varchar(40);
ds_endereco_w			varchar(40);
ds_bairro_w				varchar(12);
cd_cep_w				varchar(8);
ds_cidade_w				varchar(15);
sg_estado_w				varchar(2);
cd_moeda_w				moeda.cd_moeda_banco%type;
cd_ocorrencia_w			titulo_receber_cobr.cd_ocorrencia%type;
vl_multa_w 				double precision;
vl_juros_w 				double precision;



C01 CURSOR FOR
	SELECT	'02' ie_tipo_pessoa,
			substr(elimina_caractere_especial((SELECT max(x.cd_cgc) from estabelecimento x where x.cd_estabelecimento = c.cd_estabelecimento)),1,14) nr_inscricao,
			a.nr_titulo,
			coalesce(a.nr_nosso_numero,'0'),
			to_char(a.dt_pagamento_previsto,'ddmmyy'),
			substr(somente_numero(to_char(a.vl_saldo_titulo,'99999999990.00')),1,13) vl_titulo,
			to_char(a.dt_emissao,'ddmmyy'),
			coalesce(to_char(a.dt_limite_desconto,'ddmmyy'),'0'),
			substr(somente_numero(to_char(a.vl_desc_previsto,'99999999990.00')),1,13) vl_desc_previsto,
			CASE WHEN coalesce(a.cd_cgc::text, '') = '' THEN '01'  ELSE '02' END  ie_tipo_pessoa_sacado,
			elimina_caractere_especial(substr(CASE WHEN coalesce(a.cd_cgc::text, '') = '' THEN (select 	coalesce(max(f.nr_cpf),'0')																	from	pessoa_fisica f																	where 	a.cd_pessoa_fisica = f.cd_pessoa_fisica)  ELSE a.cd_cgc END ,1,14)) nr_inscricao_sacado,
			substr(elimina_caractere_especial(elimina_acentuacao(obter_nome_pf_pj(a.cd_pessoa_fisica,a.cd_cgc))),1,40) nm_sacado,
			rpad(elimina_acentuacao(coalesce(substr(obter_dados_pf_pj(a.cd_pessoa_fisica,a.cd_cgc,'EN'),1,29)||' ',' ') ||
				coalesce(substr(obter_dados_pf_pj(a.cd_pessoa_fisica,a.cd_cgc,'NR'),1,5),' ') ||
				coalesce(substr(obter_dados_pf_pj(a.cd_pessoa_fisica,a.cd_cgc,'CO'),1,5),' ')) ,40,' ') ds_endereco,
			elimina_acentuacao(coalesce(substr(obter_dados_pf_pj(a.cd_pessoa_fisica,a.cd_cgc,'B'),1,12),' ')) ds_bairro,
			lpad(coalesce(substr(obter_dados_pf_pj(a.cd_pessoa_fisica,a.cd_cgc,'CEP'),1,8),'0'),8,'0') cd_cep,
			rpad(elimina_acentuacao(coalesce(substr(obter_dados_pf_pj(a.cd_pessoa_fisica,a.cd_cgc,'CI'),1,15),' ')),15,' ') ds_cidade,
			rpad(coalesce(substr(obter_dados_pf_pj(a.cd_pessoa_fisica,a.cd_cgc,'UF'),1,2),' '),2,' ') sg_estado,
			CASE WHEN(select coalesce(max(x.cd_moeda_banco),9) from moeda x where x.cd_moeda = a.cd_moeda)=9 THEN 9  ELSE 5 END  cd_moeda,
			coalesce(obter_juros_multa_prev_tit_rec(a.nr_titulo,'M'),0),
			coalesce(obter_juros_multa_prev_tit_rec(a.nr_titulo,'J'),0),
			substr(coalesce(b.cd_ocorrencia,'01'),1,2) cd_ocorrencia
	from 	titulo_receber a,
			titulo_receber_cobr b,
			cobranca_escritural c
	where 	a.nr_titulo			= b.nr_titulo
	and		b.nr_seq_cobranca 	= c.nr_sequencia
	and 	b.nr_seq_cobranca 	= nr_seq_cobr_escrit_p;


BEGIN

delete	FROM w_envio_banco
where	nm_usuario = nm_usuario_p;

select	substr(coalesce(max(c.cd_convenio_banco),' '),1,20),
		max(substr(elimina_acentuacao(CASE WHEN coalesce(b.cd_cgc::text, '') = '' THEN  obter_nome_pf(	select	x.cd_pessoa_fisica																			from	titulo_receber x,																					titulo_receber_cobr y																			where	x.nr_titulo = x.nr_titulo																			and		y.nr_seq_cobranca = a.nr_sequencia)  ELSE obter_nome_pf_pj(null,b.cd_cgc) END ),1,30)) nm_empresa,
		to_char(clock_timestamp(),'ddmmyy') dt_geracao
into STRICT	cd_convenio_banco_w,
		nm_empresa_w,
		dt_geracao_w
FROM agencia_bancaria e, banco_estabelecimento c, estabelecimento b, cobranca_escritural a
LEFT OUTER JOIN banco_carteira d ON (a.nr_seq_carteira_cobr = d.nr_sequencia)
WHERE a.cd_estabelecimento	= b.cd_estabelecimento and a.nr_seq_conta_banco	= c.nr_sequencia  and c.cd_agencia_bancaria	= e.cd_agencia_bancaria and a.nr_sequencia			= nr_seq_cobr_escrit_p;

/*=== INICIO HEADER ARQUIVO ===*/

nr_seq_reg_arquivo_w := coalesce(nr_seq_reg_arquivo_w,0) + 1;

ds_conteudo_w :=	'0'										|| /*001/001 -  0 (zero) deve ser fixo neste campo, por ser o identificador do */
					'1'										|| /*002/002 - O número 01 deve ser fixo neste campo, por ser o identificador do arquivo REMESSA*/
					'REMESSA'								|| /*003/009 - A palavra REMESSA deve ser fixa neste campo.*/
					'01'									|| /*010/011  - O  01  deve ser fixo neste campo por identificar o produto cobrança. */
					rpad('COBRANCA',15,' ')					|| /*012/026 - A palavra COBRANCA deve ser fixa neste campo. */
					rpad(cd_convenio_banco_w,20,' ')		|| /*027/046  X(20) Identificação do portfolio. Necessário consultar o  Citibank para informações referentes à conta cobrança e carteira do cliente. */
					rpad(nm_empresa_w,30,' ')				|| /*047/076 X(30) Preencher com o nome da empresa. */
					'745'									|| /*077/079  9(03)  Campo preenchido obrigatoriamente com o código: 745 */
					rpad('CITIBANK',15,' ')					|| /*080/094 X(15) Campo preenchido obrigatoriamente com: CITIBANK */
					lpad(dt_geracao_w,6,' ')				|| /*095/100  9(06)  Preencher com a DATA DE ENVIO do arquivo - DDMMAA */
					'01600'									|| /*101/105 X(05)  01600 ¿ Campo Fixo */
					'BPI'									|| /*106/108  X(03)  BPI ¿ Campo Fixo */
					lpad(' ',6,' ')							|| /*109/114 X(06) Branco */
					lpad(' ',280,' ')						|| /*115/394  X(280)  Branco */
					lpad(nr_seq_reg_arquivo_w,6,'0');		   /*395/400 9(06) Seqüência do registro do arquivo remessa */
insert into w_envio_banco( 	nr_sequencia,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							cd_estabelecimento,
							ds_conteudo,
							nr_seq_apres)
				values (	nextval('w_envio_banco_seq'),
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							cd_estabelecimento_p,
							ds_conteudo_w,
							nr_seq_reg_arquivo_w);
/*=== FIM HEADER ARQUIVO ===*/

/*=== INICIO REGISTRO REMESSA ¿ DETALHE ¿ DADOS DO TÍTULO  ===*/

open C01;
loop
fetch C01 into
	ie_tipo_pessoa_w,
	nr_inscricao_w,
	nr_titulo_w,
	nr_nosso_numero_w,
	dt_pagamento_previsto_w,
	vl_titulo_w,
	dt_emissao_w,
	dt_limite_desconto_w,
	vl_desconto_previsto_w,
	ie_tipo_pessoa_sacado_w,
	nr_inscricao_sacado_w,
	nm_sacado_w,
	ds_endereco_w,
	ds_bairro_w,
	cd_cep_w,
	ds_cidade_w,
	sg_estado_w,
	cd_moeda_w,
	vl_multa_w,
	vl_juros_w,
	cd_ocorrencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

		nr_seq_reg_arquivo_w := coalesce(nr_seq_reg_arquivo_w,0) + 1;

		ds_conteudo_w :=	'1'										|| /*001/001 9 (01) Campo obrigatoriamente preenchido com:  código: 1 (código de identificação do arquivo detalhe) */
							lpad(ie_tipo_pessoa_w,2,'0')			|| /*002/003  9 (02) Código 01 = CPF Código 02 = CNPJ */
							lpad(coalesce(nr_inscricao_w,0),14,'0')		|| /*004/017 9(14) Número de inscrição da empresa, de acordo com o preenchido naposição 002/003 */
							rpad(coalesce(cd_convenio_banco_w,' '),20,' ')|| /*018/037  X(20) Identificação do portfolio. Necessário consultar o  Citibank para informações referentes à conta cobrança e carteira do cliente. */
							lpad(nr_titulo_w,25,0)					|| /*038/062 X(25) Campo de livre preenchimento. Poderá ser usado pela empresa como chave interna para seus sistemas. Quando preenchido, o Speed Collect não utilizará este campo nem validará, apenas guardará a informação e quando gerado o arquivo retorno, a informação voltará para empresa, associada ao título. Quando enviado um caracter especial diferente de ¿/¿, ¿-¿  ou ¿;¿ , devolveremos em branco. */
							'00'									|| /*063/064  9(02) 00 = DMI ¿ Duplicata Mercantil por Indicação 02 = DM ¿ Duplicata Mercantil */
							lpad(nr_nosso_numero_w,12,0)			|| /*065/076 9(12) Número do banco (conforme manual do Boleto de Cobrança). Se no cadastro do cliente houver a condição de: Numeração atribuída pelo banco, o cliente deverá preencher com  ZEROS  na entrada dos títulos e, em caso de alterações, deverá conter exatamente o número informado pelo banco no arquivo retorno.*/
							rpad(' ',5,' ')							|| /*077/081  X(06)  Brancos */
							'0'										|| /*082 X(01)  0 - Padrão Citi com troca de barra (CAMPO NOVO)*/
							lpad('0',6,'0')							|| /*Data do segundo desconto  083/088 9(06) Formato DDMMAA, sendo que esta data será maior do que a data do primeiro desconto. Caso não haja este desconto,  o campo deverá ser completado com ZEROS.  Quando informado desconto por antecipação, 999999 ou 888888 nas posições 174/179, este campo deve obrigatoriamente estar preenchido com zeros */
							lpad('0',13,'0')						|| /*Valor do segundo desconto  089/101  9(11)v99 Valor do segundo desconto. Caso não haja este desconto, o campo deverá ser completado com ZEROS. Quando informado desconto por antecipação,  999999  ou 888888 nas posições 174/179, este campos deve obrigatoriamente estar preenchido com zeros*/
							'000'									|| /*102/104 9(03) Número de seqüência de um determinado carnê. Caso o título não pertença a um carnê, deverá ser completado com ZEROS. Válido apenas quando o campo 148/149 for igual a 03*/
							'000'									|| /*105/107  9(03) Número de seqüência de uma parcela pertencente a um determinado carnê. Caso o título não pertença a um carnê, deverá ser completado com ZEROS. */
							'1'										|| /*108/108 9(01) Campo preenchido conforme carteira utilizada sendo: Código 1 = Cobrança Simples Código 2 = Cobrança Caucionada*/
							lpad(coalesce(cd_ocorrencia_w,'0'), 2, '0')	|| /*109/110  9(02) Campo preenchido com o código de ocorrência enviada ao título*/
							lpad(nr_titulo_w,10,0)					|| /*111/120 X(10) Campo preenchido com a referência do cliente (fatura, nota fiscal, etc). Este número é composto por 10 posições alfanuméricas, e tem a função de chave de acesso dentro do sistema, em que o cliente poderá consultar o título usando o Home Banking. Poderá ser reutilizado após a baixa do título, porém com quantidade de repetições estipuladas pelo Citibank.  Observação: Cliente nunca deve repetir o "seu número" entre títulos registrados na carteira de cobrança flexível e cobrança tradicional. */
							dt_pagamento_previsto_w					|| /*121/126  9(06)  Data de vencimento do título - DDMMAA*/
							lpad(vl_titulo_w,13,0)					|| /*127/139 9(11)v99 Valor do título sem descontos ou acréscimos. */
							'745'									|| /*140/142  9(03)  Preenchido obrigatoriamente com : 745 */
							lpad('0',5,'0')							|| /*143/147 9(05) Campo fixo: preencher com ZEROS. */
							'07'									|| /*148/149  9(02)*/
							'N'										|| /*150/150 X(01) Campo fixo ¿ N */
							dt_emissao_w							|| /*151/156  9(06)  Data de emissão do título - DDMMAA */
							'00'									|| /*Instrucao para o título 157/158 9(02) */
							'00'									|| /*159/160  9(02) Quando posição 157/158 (Instrução para título) conter instrução 06 ou 09, este campo deverá conter a quantidade de dias válidos para execução da instrução.*/
							lpad(vl_juros_w,13,'0')					|| /*161/173 9(11)v99 Valor de juros de mora diário a ser cobrado (não com a taxa). Se preenchido com ZEROS, será utilizada a taxa definida no parâmetro cadastral do cliente; Se informado qualquer valor maior que zero, esta informação irá sobrepor à informação do cadastro.*/
							lpad(dt_limite_desconto_w,6,'0')		|| /*174/179  9(06) Data limite para desconto ¿ DDMMAA Esta data não pode ser posterior à data de vencimento. Em caso de prorrogação, poderá ser removida a critério da empresa. Esta data também não pode ser alterada para menor que a anterior e não poderá ser maior que a data de vencimento*/
							lpad(coalesce(vl_desconto_previsto_w,0),13,0)|| /*180/192 9(11)v99  Ou  9(07)v04 (para %) Valor concedido para desconto*/
							lpad(' ',4,' ')							|| /*193 a 196 X(04) Brancos (CAMPO NOVO) Filler NEW*/
							lpad('0',9,'0')							|| /*197 a 205 Somente para prêmio de seguros (CAMPO NOVO) Valor do IOF*/
							lpad('0',13,'0')						|| /*206/218 9(11)v99 Valor concedido para abatimento desde que a posição 109/110 contenha a opção 04 (Concessão de Abatimento), quando título já registrado*/
							lpad(ie_tipo_pessoa_sacado_w,2,0)		|| /*219/220  9(02) Código 01 = CPF Código 02 = CNPJ*/
							lpad(nr_inscricao_sacado_w,14,0)		|| /*21/234 9(14) Número de inscrição da empresa, de acordo com o preenchido na posição 219/220*/
							rpad(nm_sacado_w,40,' ')				|| /*235/274  X(40)  Nome do sacado ou empresa sacadora.*/
							rpad(ds_endereco_w,40,' ')				|| /*275/314 X(40) Endereço do sacado (logradouro e número) */
							rpad(ds_bairro_w,12,' ')				|| /*315/326  X(12)  Bairro do endereço do sacado*/
							lpad(cd_cep_w,8,0)						|| /*327/334 9(08) CEP do endereço do sacado */
							rpad(ds_cidade_w,15,' ')				|| /*335/349  X(15)  Nome da cidade do sacado */
							rpad(sg_estado_w,2,' ')					|| /*350/351 X(02) Sigla do estado (UF) */
							rpad(' ',40,' ')						|| /*352/391  X(40)  Este campo tem 3 finalidades*/
							rpad(' ',2,' ')							|| /*392/393 X(02) Campo Fixo ¿ Brancos */
							coalesce(cd_moeda_w,'9')						|| /*394/394  9(01) Código 9 = REAIS Código 5 = Dólar*/
							lpad(nr_seq_reg_arquivo_w,6,'0');		   /*395/400 9(06) Seqüência do registro do arquivo remessa */
		insert into w_envio_banco( 	nr_sequencia,
									dt_atualizacao,
									nm_usuario,
									dt_atualizacao_nrec,
									nm_usuario_nrec,
									cd_estabelecimento,
									ds_conteudo,
									nr_seq_apres)
						values (	nextval('w_envio_banco_seq'),
									clock_timestamp(),
									nm_usuario_p,
									clock_timestamp(),
									nm_usuario_p,
									cd_estabelecimento_p,
									ds_conteudo_w,
									nr_seq_reg_arquivo_w);


    if coalesce(cd_ocorrencia_w,'0') in ('12', '13', '14') then

      nr_seq_reg_arquivo_w := coalesce(nr_seq_reg_arquivo_w,0) + 1;

      ds_conteudo_w :=	'3'										||            /*001/001 9 (01) Campo obrigatoriamente preenchido com:  código: 1 (código de identificação do arquivo detalhe) */
                lpad(ie_tipo_pessoa_w,2,'0')			||        /*002/003  9 (02) Código 01 = CPF Código 02 = CNPJ */
                lpad(coalesce(nr_inscricao_w,0),14,'0')		||    /*004/017 9(14) Número de inscrição da empresa, de acordo com o preenchido naposição 002/003 */
                rpad(coalesce(cd_convenio_banco_w,' '),20,' ')|| /*018/037  X(20) Identificação do portfolio. Necessário consultar o  Citibank para informações referentes à conta cobrança e carteira do cliente. */
                lpad(nr_titulo_w,25,0)					||          /*038/062 X(25) Campo de livre preenchimento. Poderá ser usado pela empresa como chave interna para seus sistemas. Quando preenchido, o Speed Collect não utilizará este campo nem validará, apenas guardará a informação e quando gerado o arquivo retorno, a informação voltará para empresa, associada ao título. Quando enviado um caracter especial diferente de ¿/¿, ¿-¿  ou ¿;¿ , devolveremos em branco. */
                '00'									||                    /*063/064  9(02) 00 = DMI ¿ Duplicata Mercantil por Indicação 02 = DM ¿ Duplicata Mercantil */
                lpad(nr_nosso_numero_w,12,0)			|| /*065/076 9(12) Número do banco (conforme manual do Boleto de Cobrança). Se no cadastro do cliente houver a condição de: Numeração atribuída pelo banco, o cliente deverá preencher com  ZEROS  na entrada dos títulos e, em caso de alterações, deverá conter exatamente o número informado pelo banco no arquivo retorno.*/
                '1'										|| /*108/108 9(01) Campo preenchido conforme carteira utilizada sendo: Código 1 = Cobrança Simples Código 2 = Cobrança Caucionada*/
                lpad(nr_titulo_w,10,0)					||
                lpad(' ',4,' ')							|| /*193 a 196 X(04) Brancos (CAMPO NOVO) Filler NEW*/
                lpad(coalesce(cd_ocorrencia_w,'0'), 2, '0')	|| /*109/110  9(02) Campo preenchido com o código de ocorrência enviada ao título*/
                '0000000000000' || --Mínimo para Pagamento 94/106 9(09)v9(04)
                '0000000000000' || --Máximo para Pagamento 107/119 9(09)v9(04)
                '3' || --Aceite Pagamento divergente 120/120 9(01)
                '1' || --Código da Multa 121/121 X(001)
                '00000000' || --Data da Multa 122/129 9(08)
                lpad(vl_multa_w, 13, '0') || --Multa 130/142 9(11)v99
                '00000000' || --Data do Juros de Mora 143/150 9(08)
                '1' || --Periodicidade do Juros 151/151 X(01)
                lpad(' ',165,' ') || --Uso exclusivo do banco 152/316
                '2' || --Apresentação de Minimo 317/317
                lpad(' ',77,' ') || --Brancos 318/394 X(77)
                lpad(nr_seq_reg_arquivo_w,6,'0');		   /*395/400 9(06) Seqüência do registro do arquivo remessa */
      insert into w_envio_banco( 	nr_sequencia,
                    dt_atualizacao,
                    nm_usuario,
                    dt_atualizacao_nrec,
                    nm_usuario_nrec,
                    cd_estabelecimento,
                    ds_conteudo,
                    nr_seq_apres)
              values (	nextval('w_envio_banco_seq'),
                    clock_timestamp(),
                    nm_usuario_p,
                    clock_timestamp(),
                    nm_usuario_p,
                    cd_estabelecimento_p,
                    ds_conteudo_w,
                    nr_seq_reg_arquivo_w);
    end if;
	end;
end loop;
close C01;
/*=== FIM REGISTRO REMESSA ¿ DETALHE ¿ DADOS DO TÍTULO  ===*/

/*=== INICIO REGISTRO REMESSA - TRAILLER  ===*/

nr_seq_reg_arquivo_w := coalesce(nr_seq_reg_arquivo_w,0) + 1;

ds_conteudo_w :=	'9'									||	/*001/001 9 (01) Obrigatoriamente deverá conter o número 9, que identificará o início do registro.*/
					lpad(' ',393,' ')					||	/*002/394  X(393)  Campo Fixo ¿ Brancos */
					lpad(nr_seq_reg_arquivo_w,6,'0');		/*395/400 9(06) Seqüência do registro do arquivo remessa */
insert into w_envio_banco( 	nr_sequencia,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							cd_estabelecimento,
							ds_conteudo,
							nr_seq_apres)
				values (	nextval('w_envio_banco_seq'),
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							cd_estabelecimento_p,
							ds_conteudo_w,
							nr_seq_reg_arquivo_w);


/*=== FIM REGISTRO REMESSA - TRAILLER  ===*/

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cobr_citibank_400_reg ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

