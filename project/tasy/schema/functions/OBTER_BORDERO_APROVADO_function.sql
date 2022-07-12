-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_bordero_aprovado (nr_bordero_p bigint) RETURNS varchar AS $body$
DECLARE


ie_liberado_w		varchar(1) := 'S';
qt_usuario_lib_w	smallint;
ie_lib_bordero_w	varchar(1);
qt_usuario_dt_lib_w	smallint;

ie_bordero_lib_w	timestamp;


BEGIN

-- Obter se é apra utilizar a liberação de bordero no estabelecimento
select	coalesce(IE_LIB_BORDERO,'N')
into STRICT	ie_lib_bordero_w
from 	PARAMETROS_CONTAS_PAGAR
where 	cd_estabelecimento = OBTER_ESTABELECIMENTO_ATIVO;

if ( ie_lib_bordero_w = 'S')  then
	--Verificar se o bordero em questao possui data de liberacao para receber as aprovacoes
	select 	coalesce(a.dt_liberacao,null)
	into STRICT	ie_bordero_lib_w
	from	bordero_pagamento a
	where 	a.nr_bordero = nr_bordero_p;

	if (ie_bordero_lib_w IS NOT NULL AND ie_bordero_lib_w::text <> '') then
		--obter quantidade de usuarios que precisam efetuar a liberação do bordero
		/*select	count(*)
		into	qt_usuario_lib_w
		from	CONTA_PAGAR_LIB a
		where 	a.nr_bordero = nr_bordero_p;*/
		/*OS 1398434 - Troquei pelo select abaixo. Quando libera o borderô, é atualizado no bordero a quantidade min de usuario necessário cfme a regra no momento*/

		select	max(qt_min_usuario_lib)
		into STRICT	qt_usuario_lib_w
		from	bordero_pagamento
		where	nr_bordero = nr_bordero_p;

		--obter  quantidade de usuarios que ja liberaram (aprovaram) o bordero
		select	count(*)
		into STRICT	qt_usuario_dt_lib_w
		from	CONTA_PAGAR_LIB a
		where	a.nr_bordero = nr_bordero_p
		and 	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '');

		if (coalesce(qt_usuario_dt_lib_w,0) >= coalesce(qt_usuario_lib_w,0)) then
			ie_liberado_w := 'S';
		else
			ie_liberado_w := 'N';
		end if;
	else
		ie_liberado_w := 'N';
	end if;
else
	ie_liberado_w := 'S';
end if;

return	ie_liberado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_bordero_aprovado (nr_bordero_p bigint) FROM PUBLIC;

