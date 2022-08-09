-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gravar_anexo_nota_cobr ( nr_seq_nota_cobr_p ptu_nota_cobranca.nr_sequencia%type, ds_arquivo_p ptu_nota_cobranca_anexo.ds_arquivo%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gravar o caminho do anexo da nota de cobrança
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
qt_anexo	integer;

BEGIN

if (nr_seq_nota_cobr_p IS NOT NULL AND nr_seq_nota_cobr_p::text <> '') and (ds_arquivo_p IS NOT NULL AND ds_arquivo_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

	-- verifica se ja existe algum anexo identico para a nota de cobrança
	select	count(1)
	into STRICT	qt_anexo
	from	ptu_nota_cobranca_anexo
	where	nr_seq_nota_cobr	= nr_seq_nota_cobr_p
	and	ds_arquivo		= ds_arquivo_p;

	-- apenas insere o anexo se a nota não possuir nenhum outro igual
	if (qt_anexo = 0) then

		insert into ptu_nota_cobranca_anexo(	nr_sequencia,
							nr_seq_nota_cobr,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							ds_arquivo)
		SELECT	nextval('ptu_nota_cobranca_anexo_seq'),
			nr_seq_nota_cobr_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			ds_arquivo_p
		;

		commit;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gravar_anexo_nota_cobr ( nr_seq_nota_cobr_p ptu_nota_cobranca.nr_sequencia%type, ds_arquivo_p ptu_nota_cobranca_anexo.ds_arquivo%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
