-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_enderec_corresp ( nr_seq_segurado_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
nr_seq_titular_w	bigint;
nr_seq_segurado_w	bigint;
nr_seq_pagador_w	bigint;
nm_pessoa_w		varchar(255);

ds_endereco_w		varchar(30);
nr_endereco_w		varchar(30);
ds_complemento_w	varchar(30);
ds_municipio_w		varchar(50);
sg_estado_w		compl_pessoa_fisica.sg_estado%type;
cd_cep_w		varchar(30);
ds_estado_w		pessoa_endereco_item.ds_valor%type;


BEGIN

select	nr_seq_titular,
	nr_seq_pagador
into STRICT	nr_seq_titular_w,
	nr_seq_pagador_w
from	pls_segurado
where	nr_sequencia = nr_seq_segurado_p;

if (coalesce(nr_seq_titular_w::text, '') = '') then
	nr_seq_segurado_w	:= nr_seq_segurado_p;
else
	nr_seq_segurado_w	:= nr_seq_titular_w;
end if;

ds_endereco_w	:= substr(pls_obter_end_pagador(nr_seq_pagador_w,'E'),1,27);
nr_endereco_w	:= substr(pls_obter_end_pagador(nr_seq_pagador_w,'NR'),1,27);
ds_complemento_w := substr(pls_obter_end_pagador(nr_seq_pagador_w,'CO'),1,12);
ds_municipio_w	:= substr(pls_obter_end_pagador(nr_seq_pagador_w,'CI'),1,50);
ds_estado_w	:= pls_obter_end_pagador(nr_seq_pagador_w,'DS_UF');
cd_cep_w	:= substr(pls_obter_end_pagador(nr_seq_pagador_w,'CEP'),1,27);

nm_pessoa_w	:= substr(pls_obter_dados_segurado(nr_seq_segurado_w,'N'),1,255);

select	ds_etiqueta
into STRICT	ds_retorno_w
from (	SELECT	nm_pessoa_w || chr(13) ||
			substr(ds_endereco_w,1,27) ||', '||nr_endereco_w||'  '||substr(ds_complemento_w,1,12) || chr(13) ||
			ds_municipio_w ||' / '|| ds_estado_w || chr(13) ||
			cd_cep_w ds_etiqueta
		from	pls_segurado			a
		where	a.nr_sequencia		= nr_seq_segurado_w) alias5;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_enderec_corresp ( nr_seq_segurado_p bigint) FROM PUBLIC;

