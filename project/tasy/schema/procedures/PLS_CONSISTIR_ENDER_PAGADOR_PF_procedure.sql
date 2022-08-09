-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_ender_pagador_pf ( cd_pessoa_fisica_p text, ie_tipo_complemento_p text, ds_erro_p INOUT text) AS $body$
DECLARE


ds_erro_w		varchar(4000);
nr_seq_pagador_w	bigint;
ie_endereco_boleto_w	varchar(10);


BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_pagador_w
from	pls_contrato_pagador
where	cd_pessoa_fisica	= cd_pessoa_fisica_p
and	coalesce(dt_rescisao::text, '') = '';

if (nr_seq_pagador_w IS NOT NULL AND nr_seq_pagador_w::text <> '') and (ie_tipo_complemento_p in ('1','2')) then
	select	ie_endereco_boleto
	into STRICT	ie_endereco_boleto_w
	from	pls_contrato_pagador
	where	nr_sequencia	= nr_seq_pagador_w;

	if (ie_endereco_boleto_w = 'PFR') and (ie_tipo_complemento_p = 1) then
		ds_erro_w	:= wheb_mensagem_pck.get_texto(280866);
	elsif (ie_endereco_boleto_w = 'PFC') and (ie_tipo_complemento_p = 2) then
		ds_erro_w	:= wheb_mensagem_pck.get_texto(280867);
	end if;
end if;

ds_erro_p	:= ds_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_ender_pagador_pf ( cd_pessoa_fisica_p text, ie_tipo_complemento_p text, ds_erro_p INOUT text) FROM PUBLIC;
