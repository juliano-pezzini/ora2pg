-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_conta_tit_pagar (nr_titulo_p bigint, nr_conta_p text, nm_usuario_p text) AS $body$
DECLARE


ie_atualiza_conta_w		varchar(1) := 'N';
cd_pessoa_fisica_w		titulo_pagar.cd_pessoa_fisica%type;
cd_cgc_w			titulo_pagar.cd_cgc%type;

cd_agencia_bancaria_cgc_w	pessoa_juridica_conta.cd_agencia_bancaria%type;
cd_banco_cgc_w			pessoa_juridica_conta.cd_banco%type;
nr_conta_cgc_w			pessoa_juridica_conta.nr_conta%type;

cd_agencia_bancaria_pf_w	pessoa_fisica_conta.cd_agencia_bancaria%type;
cd_banco_pf_w			pessoa_fisica_conta.cd_banco%type;
nr_conta_pf_w			pessoa_fisica_conta.nr_conta%type;
ds_observacao_pj_w		pessoa_juridica_conta.ds_observacao%type;
ds_observacao_pf_w		pessoa_fisica_conta.ds_observacao%type;

-- Cursor para buscar as contas bancárias ativas e padronizadas para pagamento no cadastro da PJ
C01 CURSOR FOR
SELECT	a.cd_agencia_bancaria,
	a.cd_banco,
	a.nr_conta
from	pessoa_juridica_conta a
where	a.cd_cgc			= cd_cgc_w
and	a.ie_situacao 			= 'A'
and	a.ie_conta_pagamento		= 'S';

-- Cursor para buscar as contas bancárias ativas e padronizadas para pagamento no cadastro da PF
C02 CURSOR FOR
SELECT	b.cd_agencia_bancaria,
	b.cd_banco,
	b.nr_conta
from	pessoa_fisica_conta b
where	b.cd_pessoa_fisica		= cd_pessoa_fisica_w
and	b.ie_situacao 			= 'A'
and	b.ie_conta_pagamento		= 'S';


BEGIN

/*Isso já fazia no delphi*/

if (nr_conta_p IS NOT NULL AND nr_conta_p::text <> '') and (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then
	update	titulo_pagar
	set 	nr_conta 	= nr_conta_p
	where 	nr_titulo 	= nr_titulo_p;
end if;

ie_atualiza_conta_w := Obter_Param_Usuario(851, 224, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, ie_atualiza_conta_w);

if ( coalesce(ie_atualiza_conta_w,'N') = 'S' ) then

	select	max(a.cd_pessoa_fisica), -- Buscar PF e PJ do título.
		max(a.cd_cgc)
	into STRICT	cd_pessoa_fisica_w,
		cd_cgc_w
	from	titulo_pagar a
	where	a.nr_titulo = nr_titulo_p;

	if (cd_cgc_w IS NOT NULL AND cd_cgc_w::text <> '') then
		ds_observacao_pj_w	:= wheb_mensagem_pck.get_texto(303170,'NM_USUARIO=' || nm_usuario_p || ';DATA=' || clock_timestamp());
		/*' - Conta bancária padrão alterada devido a alteração efetuada no Título a pagar. Usuário: '||nm_usuario_p||'. Data: '||sysdate||'.',1,124)*/

		open C01;
		loop
		fetch C01 into
			cd_agencia_bancaria_cgc_w,
			cd_banco_cgc_w,
			nr_conta_cgc_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			        -- Esse cursor seta todas as contas ativas e parametrizadas como padrão para não serem contas padrão
				update	pessoa_juridica_conta
				set	ie_conta_pagamento	= 'N',
					ds_observacao		= substr( substr(ds_observacao,1,125) || ds_observacao_pj_w,1,124),
					dt_atualizacao		= clock_timestamp(),
					nm_usuario		= nm_usuario_p
				where	cd_agencia_bancaria 	= cd_agencia_bancaria_cgc_w
				and	cd_banco		= cd_banco_cgc_w
				and	nr_conta		= nr_conta_cgc_w
				and	cd_cgc			= cd_cgc_w;
			end;
		end loop;
		close C01;

		update	pessoa_juridica_conta
		set	ie_conta_pagamento 	= 'S',
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p
		where	cd_cgc			= cd_cgc_w
		and	nr_conta		= nr_conta_p;


	end if;

	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
		ds_observacao_pf_w	:=  wheb_mensagem_pck.get_texto(303173,'NM_USUARIO=' || nm_usuario_p || ';DATA=' || PKG_DATE_FORMATERS.to_varchar(clock_timestamp(), 'timestamp', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, nm_usuario_p));
		open C02;
		loop
		fetch C02 into
			cd_agencia_bancaria_pf_w,
			cd_banco_pf_w,
			nr_conta_pf_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			        -- Esse cursor seta todas as contas ativas e parametrizadas como padrão para não serem contas padrão
				update	pessoa_fisica_conta
				set	ie_conta_pagamento	= 'N',
					ds_observacao		= substr( substr(ds_observacao,1,2000) || ds_observacao_pf_w,1,4000),
					dt_atualizacao		= clock_timestamp(),
					nm_usuario		= nm_usuario_p
				where	cd_agencia_bancaria 	= cd_agencia_bancaria_pf_w
				and	cd_banco		= cd_banco_pf_w
				and	nr_conta		= nr_conta_pf_w
				and	cd_pessoa_fisica	= cd_pessoa_fisica_w;
			end;
		end loop;
		close C02;

		update	pessoa_fisica_conta
		set	ie_conta_pagamento 	= 'S',
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p
		where	cd_pessoa_fisica	= cd_pessoa_fisica_w
		and	nr_conta		= nr_conta_p;


	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_conta_tit_pagar (nr_titulo_p bigint, nr_conta_p text, nm_usuario_p text) FROM PUBLIC;

