-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_prest_cadastro ( cd_pessoa_fisica_p text, cd_cgc_p text, nr_seq_contrato_p text, ie_opcao_p text, ie_tipo_relacao_p text, ie_abrange_p text, ie_prest_duplica_p text, nr_sequencia_p text, nm_usuario_p text, qt_prestador_p INOUT bigint, cd_prest_a400_p text) AS $body$
DECLARE

/*ie_opcao
PF =Pessoa fisica
PJ = Pessoa Jurídica
*/
ie_pessoa_cadastrada_w	varchar(1);
ie_prestador_duplic_w	varchar(1);
qt_existe_w		integer;


BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (ie_tipo_relacao_p IS NOT NULL AND ie_tipo_relacao_p::text <> '') and (ie_abrange_p IS NOT NULL AND ie_abrange_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	if (ie_opcao_p = 'PF') then
		begin
		select	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
		into STRICT	ie_pessoa_cadastrada_w
		from	contrato
		where 	cd_pessoa_contratada 	= cd_pessoa_fisica_p
		and 	nr_sequencia 		= nr_seq_contrato_p;
		end;

		if (ie_pessoa_cadastrada_w = 'S') then
			-- Este contrato não pertence a esta pessoa física. Verifique!
			CALL wheb_mensagem_pck.exibir_mensagem_abort(50155);
		end if;
	elsif (ie_opcao_p = 'PJ') then
		begin
		select	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
		into STRICT	ie_pessoa_cadastrada_w
		from	contrato
		where 	cd_cgc_contratado 	= cd_cgc_p
		and 	nr_sequencia 		= nr_seq_contrato_p;
		end;

		if (ie_pessoa_cadastrada_w = 'S') then
			-- Este contrato não pertence a esta pessoa jurídica. Verifique!
			CALL wheb_mensagem_pck.exibir_mensagem_abort(50165);
		end if;
	end if;

	if (ie_tipo_relacao_p = 'NC') and (ie_abrange_p = 'S') then
		-- Somente participam da rede abrangente prestadores da rede conveniada e da rede própria. Verifique!
		CALL wheb_mensagem_pck.exibir_mensagem_abort(50167);
	end if;

	if (ie_prest_duplica_p = 'N') then
		begin
		ie_prestador_duplic_w	:= pls_obter_se_prestador_duplic(cd_pessoa_fisica_p,cd_cgc_p,nr_sequencia_p);

		if (ie_prestador_duplic_w = 'S') then
			-- Já existe um prestador cadastrado com esta pessoa!
			CALL wheb_mensagem_pck.exibir_mensagem_abort(50168);
		end if;
		end;
	end if;
	end;
end if;

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin

	select	count(*)
	into STRICT	qt_prestador_p
	from	pls_prestador
	where	nr_sequencia	= nr_sequencia_p;
	end;

	if (coalesce(cd_prest_a400_p,'') <> '') then

		select	count(*)
		into STRICT	qt_existe_w
		from	pls_prestador
		where	nr_sequencia <> nr_sequencia_p
		and	cd_prest_a400 = cd_prest_a400_p;

		if (qt_existe_w > 0) then
			-- Já existe prestador com este código prestador A400 informado!
			CALL wheb_mensagem_pck.exibir_mensagem_abort(99692);
		end if;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_prest_cadastro ( cd_pessoa_fisica_p text, cd_cgc_p text, nr_seq_contrato_p text, ie_opcao_p text, ie_tipo_relacao_p text, ie_abrange_p text, ie_prest_duplica_p text, nr_sequencia_p text, nm_usuario_p text, qt_prestador_p INOUT bigint, cd_prest_a400_p text) FROM PUBLIC;

