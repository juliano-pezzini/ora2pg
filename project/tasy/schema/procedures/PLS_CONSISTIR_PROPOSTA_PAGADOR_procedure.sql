-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_proposta_pagador ( nr_seq_proposta_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE


ds_erro_w		varchar(255);
ie_pagador_ativo_w	varchar(1);
qt_pagador_inativo_w	bigint;
qt_pagador_w		bigint;


BEGIN

/* Obter o valor do parâmetro 17 */

ie_pagador_ativo_w	:= coalesce(obter_valor_param_usuario(1232, 57, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p), 'N');

if (ie_pagador_ativo_w = 'S') then
	select	count(*)
	into STRICT	qt_pagador_inativo_w
	from	pls_proposta_pagador
	where	nr_seq_proposta	= nr_seq_proposta_p
	and	(dt_fim_vigencia IS NOT NULL AND dt_fim_vigencia::text <> '');

	select	count(*)
	into STRICT	qt_pagador_w
	from	pls_proposta_pagador
	where	nr_seq_proposta	= nr_seq_proposta_p;

	if (qt_pagador_w	> 1) and
		((qt_pagador_w - qt_pagador_inativo_w) > 1)  then
		ds_erro_w := wheb_mensagem_pck.get_texto(280936);
	end if;
end if;

ds_erro_p	:= ds_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_proposta_pagador ( nr_seq_proposta_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;

