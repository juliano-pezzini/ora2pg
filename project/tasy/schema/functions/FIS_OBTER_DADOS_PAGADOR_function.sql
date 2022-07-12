-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fis_obter_dados_pagador ( nr_seq_nota_p nota_fiscal.nr_sequencia%type, ie_tipo_retorno_p text, cd_estabelecimento_p pessoa_juridica_estab.cd_estabelecimento%type) RETURNS varchar AS $body$
DECLARE


/*
IE_TIPO_RETORNO_P
EM - E-mail
*/
ds_email_w pls_contrato_pagador.ds_email%type;
retorno_w varchar(500);							


BEGIN

select	max(substr(coalesce(pls_obter_email_pagador_mens(b.cd_pessoa_fisica, b.cd_cgc, b.ie_endereco_boleto, cd_estabelecimento_p), b.ds_email), 1, 255)) ds_email
into STRICT	ds_email_w
from  	pls_mensalidade a,
	pls_contrato_pagador b,
	titulo_receber c
where 	a.nr_seq_pagador = b.nr_sequencia
and 	c.nr_seq_mensalidade = a.nr_sequencia
and 	c.nr_seq_nf_saida = nr_seq_nota_p
and 	coalesce(b.ie_envia_cobranca,'A') in ('A','E')
order by a.nr_sequencia;

if (ie_tipo_retorno_p = 'EM') then
	retorno_w := ds_email_w;
end if;

return retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fis_obter_dados_pagador ( nr_seq_nota_p nota_fiscal.nr_sequencia%type, ie_tipo_retorno_p text, cd_estabelecimento_p pessoa_juridica_estab.cd_estabelecimento%type) FROM PUBLIC;
