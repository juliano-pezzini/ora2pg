-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_cartao_tokenizacao ( nr_sequencia_p bigint, nr_seq_bandeira_p bigint, nm_titular_p text, cd_cartao_p text, dt_mes_validade_p text, dt_ano_validade_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ie_funcao_p bigint) AS $body$
DECLARE


req_w				utl_http.req;
res_w				utl_http.resp;
url_w				varchar(100);
ds_resposta_w			varchar(32647);
ds_parametros_w			varchar(1000);
cd_cartao_w			varchar(255);
ds_retorno_w			varchar(255);
ds_valor_retorno_w		varchar(255);
nm_titular_w			varchar(255);
nm_titular_ww			varchar(255);
ds_retorno_integracao_w		varchar(4000);
ds_callback_w			varchar(255);
ds_bandeira_w			bandeira_cartao_cr.ds_bandeira%type;
ie_tasy_interface_engine_w	pls_cartao_parametro.ie_tasy_interface_engine%type;
json_w				philips_json;
type_w          		varchar(255);
ds_event_w			varchar(255);
data_w				text;

BEGIN

if (length(cd_cartao_p) < 15) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1116171);
end if;

select	coalesce(max(ie_tasy_interface_engine),'N')
into STRICT	ie_tasy_interface_engine_w
from	pls_cartao_parametro
where	cd_estabelecimento	= cd_estabelecimento_p;

if (ie_tasy_interface_engine_w = 'S') then
	
	if (ie_funcao_p = 1) then
		type_w := 'contract';
	elsif (ie_funcao_p = 2) then
		type_w := 'proposal';
	end if;
	
	select	ds_bandeira
	into STRICT	ds_bandeira_w
	from	bandeira_cartao_cr
	where	nr_sequencia = nr_seq_bandeira_p;

	ds_event_w := 'cielo.creditcard.tokenization';
	dbms_lob.createtemporary(data_w, true);
	json_w := philips_json();
	json_w.put('id', nr_sequencia_p);
	json_w.put('name', nm_titular_p);
	json_w.put('cardNumber', cd_cartao_p);
	json_w.put('holder', nm_titular_p);
	json_w.put('expirationDate', dt_mes_validade_p || '/' || dt_ano_validade_p);
	json_w.put('brand', ds_bandeira_w);
	json_w.put('type', type_w);
	json_w.(data_w);
	
	select 	bifrost.send_integration_content(ds_event_w, data_w, nm_usuario_p)
	into STRICT	ds_retorno_integracao_w
	;
else
	begin
		select  ds_servico_url
		into STRICT	url_w
		from    pls_cartao_parametro
		where   cd_estabelecimento = cd_estabelecimento_p
		or      coalesce(cd_estabelecimento::text, '') = '';
	exception
	when others then
		url_w	:= '';
	end;

	nm_titular_w	:= upper(elimina_acentos(nm_titular_p));

	if (nm_titular_w IS NOT NULL AND nm_titular_w::text <> '') then
		begin

		for	i in 1 .. length(nm_titular_w) loop
			begin
			if (substr(nm_titular_w,i,1) in (	'A','B','C','D','E','F','G','H','I','J','K','L','M',
								'N','O','P','Q','R','S','T','U','V','W','X','Y','Z',' ')) then
				nm_titular_ww	:= nm_titular_ww || substr(nm_titular_w,i,1);	
			end if;
			end;
		end loop;
		end;
	end if;

	if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
		begin
			utl_http.set_transfer_timeout(30);

			ds_parametros_w	:= 	'ipServidor='|| url_w || chr(38) ||
						'nrSeqBadeira='|| nr_seq_bandeira_p || chr(38) ||
						'cardNumber='|| cd_cartao_p || chr(38) ||
						'expirationDate='|| dt_mes_validade_p || '/' || dt_ano_validade_p || chr(38) ||
						'holder='|| nm_titular_ww;

			req_w           := utl_http.begin_request( url=> url_w || '/OPSIntegracaoCartao/CieloCard', method => 'POST');
			utl_http.set_header(req_w, 'user-agent', 'mozilla/4.0');
			utl_http.set_header(r => req_w, name => 'Content-Type', value => 'application/x-www-form-urlencoded;charset=utf-8');
			utl_http.set_header(r => req_w, name => 'Content-Length', value => length(ds_parametros_w));
			utl_http.write_text(r => req_w, data => ds_parametros_w);

			res_w := utl_http.get_response(req_w);

			utl_http.read_line(res_w, ds_resposta_w);

			utl_http.end_response(res_w);

			/*-----------------------------------------------------------------------------------------------------------
			IE_FUNCAO_P:	1 - 'OPS - Gestao de Contratos'
					2 - 'OPS - Proposta de Adesao Eletranica'
			*/
			ds_retorno_w		:= substr(ds_resposta_w, 1, position(':' in ds_resposta_w)-1);
			ds_valor_retorno_w	:= substr(ds_resposta_w, position(':' in ds_resposta_w) + 1, length(ds_resposta_w));

			if (ds_retorno_w = 'SUCCESS') then
				cd_cartao_w	:= pls_cartao_integracao_pck.truncar_cartao(cd_cartao_p);

				if (ie_funcao_p = 1) then
					update	pls_contrato_pagador_fin
					set	nr_seq_bandeira		= nr_seq_bandeira_p,
						nm_titular_cartao	= nm_titular_ww,
						nr_cartao_credito	= cd_cartao_w,
						ds_token		= ds_valor_retorno_w,
						dt_atualizacao		= clock_timestamp(),
						nm_usuario		= nm_usuario_p
					where	nr_sequencia		= nr_sequencia_p;
				elsif (ie_funcao_p = 2) then
					update	pls_proposta_pagador
					set	nr_seq_bandeira		= nr_seq_bandeira_p,
						nm_titular_cartao	= nm_titular_ww,
						nr_cartao_credito	= cd_cartao_w,
						ds_token		= ds_valor_retorno_w,
						dt_atualizacao		= clock_timestamp(),
						nm_usuario		= nm_usuario_p
					where	nr_sequencia		= nr_sequencia_p;
				end if;

				commit;
			else
				CALL wheb_mensagem_pck.exibir_mensagem_abort('');
			end if;
		exception
		when others then
			if (ds_retorno_w <> 'SUCCESS') and (ds_valor_retorno_w IS NOT NULL AND ds_valor_retorno_w::text <> '') then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(ds_valor_retorno_w);	
			else
				CALL wheb_mensagem_pck.exibir_mensagem_abort(1031269); -- 'Ocorreu falha ao tentar realizar a comunicacao para obter o token do cartao!'
			end if;
		end;
	end if;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cartao_tokenizacao ( nr_sequencia_p bigint, nr_seq_bandeira_p bigint, nm_titular_p text, cd_cartao_p text, dt_mes_validade_p text, dt_ano_validade_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ie_funcao_p bigint) FROM PUBLIC;

