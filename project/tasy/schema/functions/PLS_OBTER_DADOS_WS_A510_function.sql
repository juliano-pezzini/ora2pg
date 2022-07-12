-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_ws_a510 ( ie_opcao_p text ) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
nr_seq_webservice_w	pls_end_webservice_a510.nr_sequencia%type;

/* OPÇÕES
CP	Comunicação Padrão Interna
IS	IP Servidor Proxy
PS	Porta Servidor Proxy
US	Usuário Servidor Proxy
SS	Senha Servidor Proxy
IU	IP envio Unimed Brasil
CC	Caminho Certificado
SC	Senha Certificado
SV?	Servlet cadastrado ja com o "?" concatenado, caso o mesmo exista
	*/
BEGIN
select	max(nr_sequencia)
into STRICT	nr_seq_webservice_w
from	pls_end_webservice_a510
where	ie_situacao	= 'A'
and	clock_timestamp()		between trunc(coalesce(dt_inicio_vigencia, clock_timestamp()), 'dd') and fim_dia(coalesce(dt_fim_vigencia, clock_timestamp()));

if (ie_opcao_p = 'CP') then
	select	max(ds_webservice_envio)
	into STRICT	ds_retorno_w
	from	pls_end_webservice_a510
	where	nr_sequencia	= nr_seq_webservice_w;

elsif (ie_opcao_p = 'IS') then
	select	max(ds_ip_proxy)
	into STRICT	ds_retorno_w
	from	pls_end_webservice_a510
	where	nr_sequencia	= nr_seq_webservice_w;

elsif (ie_opcao_p = 'PS') then
	select	max(ds_porta_proxy)
	into STRICT	ds_retorno_w
	from	pls_end_webservice_a510
	where	nr_sequencia	= nr_seq_webservice_w;

elsif (ie_opcao_p = 'US') then
	select	max(ds_usuario_proxy)
	into STRICT	ds_retorno_w
	from	pls_end_webservice_a510
	where	nr_sequencia	= nr_seq_webservice_w;

elsif (ie_opcao_p = 'SS') then
	select	max(ds_senha_proxy)
	into STRICT	ds_retorno_w
	from	pls_end_webservice_a510
	where	nr_sequencia	= nr_seq_webservice_w;

elsif (ie_opcao_p = 'IU') then
	select	max(ds_ip_envio_unimed)
	into STRICT	ds_retorno_w
	from	pls_end_webservice_a510
	where	nr_sequencia	= nr_seq_webservice_w;

elsif (ie_opcao_p = 'CC') then
	select	max(ds_caminho_cert_digital)
	into STRICT	ds_retorno_w
	from	pls_end_webservice_a510
	where	nr_sequencia	= nr_seq_webservice_w;

elsif (ie_opcao_p = 'SC') then
	select	max(ds_senha_cert_digital)
	into STRICT	ds_retorno_w
	from	pls_end_webservice_a510
	where	nr_sequencia	= nr_seq_webservice_w;

elsif (ie_opcao_p = 'SV?') then

	select	max(ds_servlet)
	into STRICT	ds_retorno_w
	from	pls_end_webservice_a510
	where	nr_sequencia	= nr_seq_webservice_w;

	if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then

		ds_retorno_w := ds_retorno_w||'?';
	end if;


end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_ws_a510 ( ie_opcao_p text ) FROM PUBLIC;

