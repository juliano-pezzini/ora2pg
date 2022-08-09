-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cobr_daycoval_utl_400 ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

ds_conteudo_w			varchar(400) := null;
nr_seq_reg_arquivo_w		bigint := 1;
cd_conta_cobr_w			varchar(6);
cd_agencia_cobr_w		varchar(4);
nm_empresa_w			varchar(30);
dt_geracao_w			varchar(6);
ie_digito_conta_cobr_w		varchar(1);
ds_banco_w				varchar(15);

/* detalhe */

ie_tipo_inscricao_w		varchar(2);
nr_inscricao_empresa_w		varchar(14);
cd_agencia_bancaria_w		varchar(4);
cd_conta_w			varchar(7);
nr_nosso_numero_w		varchar(9);
vl_multa_w			double precision;
nr_titulo_w			bigint;
dt_vencimento_w			timestamp;
vl_titulo_w			double precision;
dt_emissao_w			timestamp;
vl_juros_w			double precision;
vl_desconto_w			double precision;
nm_pessoa_w			varchar(40);
ds_endereco_w			varchar(40);
ds_bairro_w			varchar(12);
cd_cep_w			varchar(8);
ds_cidade_w			varchar(15);
sg_estado_w			varchar(15);
tx_juros_w			double precision;
tx_multa_w			double precision;
ds_tipo_juros_w			varchar(255);
ds_tipo_multa_w			varchar(255);
qt_titulo_w		        bigint;
vl_total_titulo_w	    	double precision;
cd_cgc_w			estabelecimento.cd_cgc%type;
dt_desconto_w			varchar(8);
cd_ocorrencia_w			titulo_receber_cobr.cd_ocorrencia%type;
vl_abatimento_w			varchar(13);


/*UTL File*/

arq_texto_w			utl_file.file_type;
ds_erro_w			varchar(255);
ds_local_w			varchar(255);
nm_arquivo_w			varchar(255);


c01 CURSOR FOR

SELECT	CASE WHEN coalesce(b.cd_pessoa_fisica::text, '') = '' THEN '02'  ELSE '01' END  ie_tipo_inscricao,
	coalesce(c.nr_cpf, b.cd_cgc) nr_inscricao_empresa,
	lpad(a.cd_agencia_bancaria,4,'0') cd_agencia_bancaria,
	lpad(a.nr_conta || a.ie_digito_conta,7,'0') cd_conta,
  -- 	lpad(somente_numero(nvl(substr(nvl(b.nr_nosso_numero, obter_nosso_numero_banco(a.cd_banco,a.nr_titulo)),1,12),'0')),12,'0') nr_nosso_numero,
	lpad(coalesce(CASE WHEN b.ie_tipo_titulo='1' THEN substr(b.nr_nosso_numero,1,9)  ELSE '0' END ,'0'),9,'0') nr_nosso_numero,
	CASE WHEN coalesce(a.vl_multa,0)=0 THEN obter_juros_multa_titulo(b.nr_titulo,clock_timestamp(),'R','M')  ELSE a.vl_multa END ,
	a.nr_titulo,
	b.dt_pagamento_previsto,
	b.vl_saldo_titulo,
	b.dt_emissao,
	CASE WHEN coalesce(a.vl_juros,0)=0 THEN obter_juros_multa_titulo(b.nr_titulo,clock_timestamp(),'R','J')  ELSE a.vl_juros END ,
	a.vl_desconto,
	substr(obter_nome_pf_pj(b.cd_pessoa_fisica,b.cd_cgc),1,40) nm_pessoa,
	rpad(substr(obter_dados_pf_pj(b.cd_pessoa_fisica,b.cd_cgc,'R'),1,40),40,' ') ds_endereco,
	rpad(substr(obter_dados_pf_pj(b.cd_pessoa_fisica,b.cd_cgc,'B'),1,12),12,' ') ds_bairro,
	lpad(substr(obter_dados_pf_pj(b.cd_pessoa_fisica,b.cd_cgc,'CEP'),1,8),8,'0') cd_cep,
	rpad(substr(obter_dados_pf_pj(b.cd_pessoa_fisica,b.cd_cgc,'CI'),1,15),15,' ') ds_cidade,
	rpad(substr(obter_dados_pf_pj(b.cd_pessoa_fisica,b.cd_cgc,'UF'),1,2),2,' ') sg_estado,
	b.tx_juros,
	b.tx_multa,

	substr(obter_valor_dominio(707,b.cd_tipo_taxa_juro),1,255) ds_tipo_juros,
	substr(obter_valor_dominio(707,b.cd_tipo_taxa_multa),1,255) ds_tipo_multa,
	a.cd_ocorrencia
FROM titulo_receber_cobr a, titulo_receber b
LEFT OUTER JOIN pessoa_fisica c ON (b.cd_pessoa_fisica = c.cd_pessoa_fisica)
WHERE a.nr_titulo		        = b.nr_titulo and a.nr_seq_cobranca	    = nr_seq_cobr_escrit_p;

cd_banco_w		smallint;
nr_linha_w		bigint;
cd_convenio_banco_w 	banco_estabelecimento.cd_convenio_banco%type;
cd_cedente_w  bigint;

BEGIN

nm_arquivo_w	:= to_char(clock_timestamp(),'ddmmyyyyhh24miss') || nm_usuario_p || '.rem';

SELECT * FROM obter_evento_utl_file(1, null, ds_local_w, ds_erro_w) INTO STRICT ds_local_w, ds_erro_w;

if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(186768, 'DS_ERRO_W=' || ds_erro_w);
end if;

arq_texto_w := utl_file.fopen(ds_local_w,nm_arquivo_w,'W');


/* header */

select	lpad(coalesce(substr(b.cd_conta,1,6),'0'),6,'0'),
	lpad(coalesce(substr(b.cd_agencia_bancaria,1,4),'0'),4,'0'),
	substr(coalesce(b.ie_digito_conta,'0'),1,1),
	rpad(substr(obter_nome_estabelecimento(cd_estabelecimento_p),1,30),30,' ') nm_empresa,
	to_char(clock_timestamp(),'DDMMYY'),
	substr(b.cd_banco,1,3),
	substr(b.cd_convenio_banco,1,12), 
	substr(b.cd_cedente,1,12),
	upper(SUBSTR(ds_banco, 1,15)) ds_banco,
	substr(d.cd_cgc,1,14)
into STRICT	cd_conta_cobr_w,
        cd_agencia_cobr_w,
        ie_digito_conta_cobr_w,
        nm_empresa_w,
        dt_geracao_w,
        cd_banco_w,
        cd_convenio_banco_w,
        cd_cedente_w,
        ds_banco_w,
	cd_cgc_w
from	estabelecimento d,
	banco c,
        banco_estabelecimento b,
        cobranca_escritural a
where	b.cd_banco		 = c.cd_banco
and	a.nr_seq_conta_banco = b.nr_sequencia
and	a.nr_sequencia		 = nr_seq_cobr_escrit_p
and	a.cd_estabelecimento = d.cd_estabelecimento;

ds_conteudo_w	:= 	'01REMESSA01COBRANCA       ' ||
            lpad(coalesce(cd_convenio_banco_w, '0'), 12, '0') ||                                   --Nota1 *******
            '        ' ||
			rpad(coalesce(nm_empresa_w, ' '), 30, ' ') ||
			lpad(coalesce(cd_banco_w, '0'),3,'0') ||
			rpad(coalesce(ds_banco_w, ' '),15,' ') ||
			dt_geracao_w ||
			rpad(' ',294,' ') ||
			lpad(coalesce(nr_seq_reg_arquivo_w,'0'),6,'0');
	
utl_file.put_line(arq_texto_w,ds_conteudo_w || chr(13));
utl_file.fflush(arq_texto_w);

/* detalhe */

open	C01;
loop
fetch	C01 into	
	ie_tipo_inscricao_w,
	nr_inscricao_empresa_w,
	cd_agencia_bancaria_w,
	cd_conta_w,
	nr_nosso_numero_w,
	vl_multa_w,
	nr_titulo_w,
	dt_vencimento_w,
	vl_titulo_w,
	dt_emissao_w,
	vl_juros_w,
	vl_desconto_w,
	nm_pessoa_w,
	ds_endereco_w,
	ds_bairro_w,
	cd_cep_w,
	ds_cidade_w,
	sg_estado_w,
	tx_juros_w,
	tx_multa_w,
	ds_tipo_juros_w,
	ds_tipo_multa_w,
	cd_ocorrencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	nr_seq_reg_arquivo_w	:= nr_seq_reg_arquivo_w + 1;
	
		if (coalesce(vl_desconto_w,0) = 0) then
			dt_desconto_w := '000000';
		else
			dt_desconto_w := to_char(dt_vencimento_w,'ddmmyy');
		end if;
		
		if (cd_ocorrencia_w = '04') then
			vl_abatimento_w := lpad(somente_numero(to_char(coalesce(vl_desconto_w,0),'99999999990.00')),13,'0');
		else
			vl_abatimento_w := '0000000000000';
		end if;

	ds_conteudo_w	:=	'1' ||                                                                                     --Codigo do Registro      001  001 
		'02' ||                                                                                 --Codigo de Inscricao     002  003    Identificacao do tipo de inscricao da empresa 01-CPF do cedente 02-CNPJ do cedente 03-CPF do Sacador 04-CNPJ Sacador 
		lpad(cd_cgc_w, 14, '0') ||                                                               --Numero de Inscricao     004  017 
		lpad(coalesce(cd_convenio_banco_w, '0'), 12, '0')  ||                                                              --NOTA1 *************     018  029
                rpad(' ',33,' ') ||                                                                                    --25 Brancos  --8 Brancos 030  062
		substr(nr_nosso_numero_w,1,length(nr_nosso_numero_w)-1)||                                              --NOTA2 ***********       063  070
                rpad(' ',37,' ') ||                                                                                    --soma 13 + 24 Brancos -> 071  107 24 Brancos Uso do Banco
		'6' ||                                                                                                 --Nota3                   108  108          
                lpad(coalesce(cd_ocorrencia_w,'01'), 2, '0') ||                                                         --Nota4 ***************** 109  110
		lpad(nr_titulo_w,10,'0') ||                                                                            --OBRIGAToRIO INFORMAR    121  126  PARCELA, QUANDO HOUVER. NaO ENVIAR DUPLICIDADES
                to_char(dt_vencimento_w,'ddmmyy') ||                                                                   --Vencimento
                lpad(somente_numero(to_char(coalesce(vl_titulo_w,0), '99999999999.00')), 13, '0') ||
                lpad(coalesce(cd_banco_w, '0'),3,'0') ||                                                                    --Codigo do Banco         140  142 
                '00000' ||                                                                                             --Agencia Cobradora,      143  147 Dac da Ag. Cobradora '0'
                '12'||                                                                                                 --Especie                 148  149
                'N' ||                                                                                                 --Aceite                  150  150
                to_char(dt_emissao_w,'ddmmyy') ||                                                                      --Data de Emissao         151  156
                '00000000000000000' ||                                                                                 --                        157->173
                lpad(coalesce(dt_desconto_w,'0'),6,'0') ||--Desconto ate            174  179
                lpad(somente_numero(to_char(coalesce(vl_desconto_w,'0'),'99999999990.00')),13,'0') ||                         --                        180  192
                '0000000000000' ||                                                                                     --Uso do Banco            193  205
		vl_abatimento_w 	||                                                                              --                        206  218
                ie_tipo_inscricao_w ||                                                                                 --Codigo de Inscricao     219  220
                lpad(nr_inscricao_empresa_w,14,'0') ||                                                                 --Numero Inscricao        221  234
		rpad(nm_pessoa_w,30,' ') ||                                                                            --nome                    235  264
                '          ' ||                                                                                        --Branco                  265  274
               	rpad(ds_endereco_w, 40, ' ') ||                                                                        --Logradouro              275  314
		ds_bairro_w ||                                                                                         --bairro                  315  326
                cd_cep_w ||                                                                                            --cep                     327  326
                ds_cidade_w ||                                                                                         --cidade                  335  349
                substr(sg_estado_w,1,2)||                                                                              --estado                  350  351
                rpad(coalesce(nm_empresa_w, ' '), 30, ' ') ||                                                              --Sacador ou Avalista     352  381
                '          ' ||                                                                                        --branco                  382  391
                '00'||                                                                                                 --Prazo                   392  393
                '0'||                                                                                                  --Moeda                   394  394
                lpad(nr_seq_reg_arquivo_w,6,'0');                                                                      --                        395  400
		
	utl_file.put_line(arq_texto_w,ds_conteudo_w || chr(13));
	utl_file.fflush(arq_texto_w);		
	
end	loop;
close	C01;

/* trailer */

nr_seq_reg_arquivo_w	:= nr_seq_reg_arquivo_w + 1;

select	count(*),
    sum(b.vl_saldo_titulo)
into STRICT	qt_titulo_w,
        vl_total_titulo_w
from	titulo_receber b,
        titulo_receber_cobr a
where	a.nr_titulo		= b.nr_titulo
and	a.nr_seq_cobranca	= nr_seq_cobr_escrit_p;

ds_conteudo_w	:= 	'9' ||
			rpad(' ',393,' ') ||
			lpad(nr_seq_reg_arquivo_w,6,'0');
	
	utl_file.put_line(arq_texto_w,ds_conteudo_w || chr(13));
	utl_file.fflush(arq_texto_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cobr_daycoval_utl_400 ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
