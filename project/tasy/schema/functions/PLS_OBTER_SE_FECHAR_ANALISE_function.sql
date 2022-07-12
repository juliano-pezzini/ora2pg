-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_fechar_analise (nr_seq_analise_p bigint, nr_seq_grupo_atual_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_mensagem_p text) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_permite_fechar_w		varchar(1)	:= 'S';
qt_registro_w			bigint;
ie_analises_encerradas_w	varchar(1)	:= 'N';
ie_grupo_perm_finalizar_w	varchar(1)	:= 'N';
ie_permissao_w			varchar(3)	:= null;
ds_mensagem_w			varchar(255)	:= null;
ie_origem_analise_w		pls_analise_conta.ie_origem_analise%type;


BEGIN

if (nr_seq_analise_p IS NOT NULL AND nr_seq_analise_p::text <> '') and (nr_seq_grupo_atual_p IS NOT NULL AND nr_seq_grupo_atual_p::text <> '') then

	select	max(ie_origem_analise)
	into STRICT	ie_origem_analise_w
	from	pls_analise_conta
	where	nr_sequencia = nr_seq_analise_p;

	if (coalesce(ie_origem_analise_w,1) not in (2,7,8)) then
		/* Verificar se já tem contas fechadas */

		select	count(1)
		into STRICT	qt_registro_w
		from	pls_conta b
		where	b.nr_seq_analise	= nr_seq_analise_p
		and	b.ie_status <> 'F';

		if (qt_registro_w = 0) then
			ie_permite_fechar_w	:= 'N';
			ds_mensagem_w	:= 'Todas as contas desta análise já estão fechadas, não é permitido fechá-las novamente.';
		end if;
	end if;
	/* Verificar se todas as análises foram finalizadas */

	if (ie_permite_fechar_w = 'S') then
		ie_analises_encerradas_w	:= pls_obter_se_analises_enc(nr_seq_analise_p);

		if (ie_analises_encerradas_w = 'N') then
			ie_permite_fechar_w	:= 'N';
			ds_mensagem_w	:= 'Não é permitido fechar as contas pois o fluxo de auditoria desta análise ainda não está concluído.';
		end if;
	end if;

	/* Verificar se o grupo tem permissão para fechar */

	if (ie_permite_fechar_w = 'S') then
		ie_grupo_perm_finalizar_w	:= pls_obter_se_grupo_final(nr_seq_analise_p,nm_usuario_p,cd_estabelecimento_p);

		if (ie_grupo_perm_finalizar_w = 'N') then
			ie_permite_fechar_w	:= 'N';
			ds_mensagem_w	:= 'O seu grupo de auditoria não possui permissão para fechamento de contas.';
		end if;
	end if;

end if;

if (ie_mensagem_p = 'S') and (ds_mensagem_w IS NOT NULL AND ds_mensagem_w::text <> '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(206634,'DS_MENSAGEM=' || ds_mensagem_w);
end if;

return	ie_permite_fechar_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_fechar_analise (nr_seq_analise_p bigint, nr_seq_grupo_atual_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_mensagem_p text) FROM PUBLIC;

