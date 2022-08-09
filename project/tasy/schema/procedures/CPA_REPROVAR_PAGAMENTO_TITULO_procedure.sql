-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpa_reprovar_pagamento_titulo ( nm_usuario_p text, nr_titulo_p bigint) AS $body$
DECLARE


ie_reprovacao_w		regra_lib_cp.ie_reprovacao%type;		
		

BEGIN

select	coalesce(max(a.ie_reprovacao),'U')
into STRICT 	ie_reprovacao_w
from 	regra_lib_cp a
where 	a.cd_estabelecimento = obter_estabelecimento_ativo
and 	a.ie_origem = 'TP';

if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then
	begin
	if (ie_reprovacao_w = 'U') then
		update	conta_pagar_lib
		set		dt_reprovacao 	= clock_timestamp()
		where	nr_titulo 		= nr_titulo_p
		and (
			nm_usuario_lib	= nm_usuario_p
			or (cd_perfil 	= obter_perfil_ativo)
		)
		and		coalesce(nr_bordero::text, '') = ''
		and		coalesce(nr_seq_banco_escrit::text, '') = '';
	else
		update	conta_pagar_lib
		set	dt_reprovacao 	= clock_timestamp()
		where	nr_titulo 	= nr_titulo_p
		and	coalesce(nr_bordero::text, '') = ''
		and	coalesce(nr_seq_banco_escrit::text, '') = '';
	end if;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpa_reprovar_pagamento_titulo ( nm_usuario_p text, nr_titulo_p bigint) FROM PUBLIC;
