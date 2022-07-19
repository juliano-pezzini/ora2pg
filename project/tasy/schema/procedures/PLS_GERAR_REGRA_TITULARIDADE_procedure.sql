-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_regra_titularidade ( nr_seq_segurado_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_parentesco_w		bigint;
nr_seq_titular_w		bigint;
qt_registros_w			bigint;
nr_seq_regra_titular_w		bigint;
qt_valor_inicial_w		bigint;
qt_valor_final_w		bigint;
nr_identificacao_titular_w	smallint	:= 00;
nr_identificacao_titular_ww	smallint	:= 00;
ie_titularidade_benef_w		varchar(2)	:= '00';
nr_seq_segurado_ww		bigint;
ie_gerar_cod_tit_w		pls_parametros.ie_gerar_cod_tit%type;
ie_titularidade_w		pls_segurado.ie_titularidade%type;
cd_matricula_familia_w		pls_segurado.cd_matricula_familia%type;
nr_seq_contrato_w		pls_segurado.nr_seq_contrato%type;
ie_consistir_w			varchar(1);

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_segurado
	where	nr_seq_titular		= nr_seq_titular_w
	and	nr_seq_parentesco	in (	SELECT	nr_seq_parentesco
						from	pls_regra_tit_parentesco
						where	nr_seq_regra_titular	= nr_seq_regra_titular_w);


BEGIN

select	max(ie_gerar_cod_tit)
into STRICT	ie_gerar_cod_tit_w
from	pls_parametros
where	cd_estabelecimento	= cd_estabelecimento_p;

ie_gerar_cod_tit_w	:= coalesce(ie_gerar_cod_tit_w,'S');

/*Obter os dados do beneficiários*/

select	nr_seq_parentesco,
	nr_seq_titular,
	pls_obter_identifica_titular(nr_seq_titular,nr_sequencia),
	ie_titularidade
into STRICT	nr_seq_parentesco_w,
	nr_seq_titular_w,
	nr_identificacao_titular_w,
	ie_titularidade_w
from	pls_segurado
where	nr_sequencia	= nr_seq_segurado_p;

/*aaschlote 04/08/2014 OS 684754 - Tratamento para os códigos de titularidde informado pelo usuário*/

if (ie_titularidade_w IS NOT NULL AND ie_titularidade_w::text <> '') and (ie_gerar_cod_tit_w = 'N') then
	goto final;
end if;

/*Veirifcar se o beneficiário é dependente*/

if (nr_seq_titular_w IS NOT NULL AND nr_seq_titular_w::text <> '') then
	select	count(*)
	into STRICT	qt_registros_w
	from	pls_regra_tit_parentesco
	where	nr_seq_parentesco	= nr_seq_parentesco_w
	and	cd_estabelecimento	= cd_estabelecimento_p;

	/*Verifcar se existe regra de titularidade para o grau de dependencia do beneficiário*/

	if (qt_registros_w	> 0) then
		select	max(a.nr_sequencia)
		into STRICT	nr_seq_regra_titular_w
		from	pls_regra_titularidade		a,
			pls_regra_tit_parentesco	b
		where	b.nr_seq_regra_titular	= a.nr_sequencia
		and	b.nr_seq_parentesco	= nr_seq_parentesco_w
		and	b.cd_estabelecimento	= cd_estabelecimento_p;

		/*Veirifcar novamente se existe regra de titularidade para o grau de dependencia do beneficiário*/

		if (nr_seq_regra_titular_w IS NOT NULL AND nr_seq_regra_titular_w::text <> '') then
			/*Busca a numero de sua identificção de acorodo com o seu grau de parentesco*/

			open C01;
			loop
			fetch C01 into
				nr_seq_segurado_ww;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin

				if (nr_seq_segurado_ww <= nr_seq_segurado_p) then
					nr_identificacao_titular_ww := nr_identificacao_titular_ww + 1;
				end if;

				end;
			end loop;
			close C01;

			/*Obter os dados da regra da titularidade*/

			select	qt_valor_inicial,
				qt_valor_final
			into STRICT	qt_valor_inicial_w,
				qt_valor_final_w
			from	pls_regra_titularidade
			where	nr_sequencia	= nr_seq_regra_titular_w;

			/*Monta a regra da titularidade*/

			ie_titularidade_benef_w	:= qt_valor_inicial_w + nr_identificacao_titular_ww -1;

			/* Lepinski - OS 445401 - Verificar se o titular possui o código de titularidade do dependente. Essa titular pode ter sido dependente, e quando for transformado em titular, não ter sido gerada nova carteira, ou seja continua com código titularidade de dependente */

			select	count(1)
			into STRICT	qt_registros_w
			from	pls_segurado
			where	nr_sequencia	= nr_seq_titular_w
			and	ie_titularidade	= ie_titularidade_benef_w;
			if (qt_registros_w > 0) then
				ie_titularidade_benef_w	:= ie_titularidade_benef_w+1;
			end if;

			select	count(*)
			into STRICT	qt_registros_w
			from	pls_segurado
			where	nr_seq_titular	= nr_seq_titular_w
			and	ie_titularidade	= ie_titularidade_benef_w;

			while(qt_registros_w	> 0) loop
				ie_titularidade_benef_w	:= ie_titularidade_benef_w+1;

				select	count(*)
				into STRICT	qt_registros_w
				from	pls_segurado
				where	nr_seq_titular	= nr_seq_titular_w
				and	ie_titularidade	= ie_titularidade_benef_w;
			end loop;

			/*Verificar se a titularidade montade para o beneficiário é maior do que o valor final*/

			if (ie_titularidade_benef_w <= coalesce(qt_valor_final_w,ie_titularidade_benef_w)) then
				/*Concatena o 0 a esquerda para a titularidade do beneficiário*/

				ie_titularidade_benef_w	:= lpad(ie_titularidade_benef_w, 2, '0');
			else
				/*Caso a titularidade montada for maior que a regra, então realiza a titularidade como atualemte*/

				ie_titularidade_benef_w	:= lpad(nr_identificacao_titular_w, 2, '0');
			end if;
		else
			/*Caso não exitir a regra então faz o tratamento como atualmente*/

			ie_titularidade_benef_w	:= lpad(nr_identificacao_titular_w, 2, '0');
		end if;
	else
		select	count(*)
		into STRICT	qt_registros_w
		from	pls_segurado
		where	nr_seq_titular	= nr_seq_titular_w
		and	ie_titularidade	= nr_identificacao_titular_w;

		while(qt_registros_w	> 0) loop
			nr_identificacao_titular_w	:= nr_identificacao_titular_w+1;
			select	count(*)
			into STRICT	qt_registros_w
			from	pls_segurado
			where	nr_seq_titular	= nr_seq_titular_w
			and	ie_titularidade	= nr_identificacao_titular_w;
		end loop;

		/*Caso não exitir a regra então faz o tratamento como atualmente*/

		ie_titularidade_benef_w	:= lpad(nr_identificacao_titular_w, 2, '0');
	end if;
else
	/*Caso o beneficiário for titular coloca 00 em sua titularidade*/

	ie_titularidade_benef_w	:= '00';
end if;

select	count(1)
into STRICT	qt_registros_w
from	pls_segurado
where	nr_sequencia	= nr_seq_titular_w
and	ie_titularidade	= ie_titularidade_benef_w;
if (qt_registros_w > 0) then
	ie_titularidade_benef_w	:= ie_titularidade_benef_w+1;
end if;

select	count(*)
into STRICT	qt_registros_w
from	pls_segurado
where	nr_seq_titular	= nr_seq_titular_w
and	ie_titularidade	= ie_titularidade_benef_w;
while(qt_registros_w	> 0) loop
	ie_titularidade_benef_w	:= ie_titularidade_benef_w+1;

	select	count(*)
	into STRICT	qt_registros_w
	from	pls_segurado
	where	nr_seq_titular	= nr_seq_titular_w
	and	ie_titularidade	= lpad(ie_titularidade_benef_w, 2, '0');
end loop;

ie_titularidade_benef_w	:= lpad(ie_titularidade_benef_w, 2, '0');

ie_consistir_w := coalesce(obter_valor_param_usuario(1220, 160, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p),'N');

if (ie_consistir_w = 'S') then
	select	count(1)
	into STRICT	qt_registros_w
	from	pls_segurado
	where	cd_matricula_familia = cd_matricula_familia_w
	and	nr_seq_contrato = nr_seq_contrato_w
	and	nr_sequencia <> nr_seq_segurado_p
	and	ie_titularidade = ie_titularidade_benef_w;

	if (qt_registros_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort('Não é permitido código de titularidade duplicado para beneficiários que tenham o mesmo código de matrícula familiar.');
	end if;
end if;

update	pls_segurado
set	ie_titularidade	= ie_titularidade_benef_w,
	dt_atualizacao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p
where	nr_sequencia	= nr_seq_segurado_p;

<<final>>
ie_titularidade_benef_w	:= lpad(ie_titularidade_benef_w, 2, '0');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_regra_titularidade ( nr_seq_segurado_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

