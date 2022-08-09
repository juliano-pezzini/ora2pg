-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_incosistencia_escritural (ie_opcao_p text, nr_seq_documento_p bigint, nr_seq_banco_interf_p bigint, nm_usuario_p text, ie_acao_p text) AS $body$
DECLARE


/* ie_opcao_p

C	Cobranca Escritural
P	Pagamento Escritural

ie_acao_p

B	Baixa
T	Retorno
R	Remessa

*/
ie_reimportar_arquivo_w		varchar(1);
cd_estabelecimento_w		smallint;
ie_remessa_retorno_w		varchar(1);
ds_arquivo_w			varchar(255);
qt_instrucao_w			bigint;
nr_seq_conta_banco_w		bigint;
cd_banco_w			banco.cd_banco%type;
cd_interface_w			bigint;
nm_obj_cobr_escrit_ret_w	varchar(50);
nm_tab_cobr_escrit_ret_w	varchar(255);
qt_tabela_w			bigint;
qt_procedure_w			bigint;
qt_usuario_lib_w		bigint;
qt_min_usuario_lib_w		bigint;
nm_objeto_retorno_w		varchar(255);
nm_tabela_retorno_w		varchar(255);
qt_titulo_w			bigint;
nr_titulo_w			bigint;
nr_seq_arquivo_w		cobranca_escritural.nr_seq_arquivo%type;

c01 CURSOR FOR
SELECT	b.nr_titulo
from	titulo_receber_cobr b,
	cobranca_escritural a
where	a.nr_sequencia	= b.nr_seq_cobranca
and	a.nr_sequencia	= nr_seq_documento_p;


BEGIN

if (ie_opcao_p	= 'C') then

	delete	from w_inconsistencia_escrit;

	select	max(a.cd_estabelecimento),
		max(a.ie_remessa_retorno),
		max(a.ds_arquivo),
		max(a.nr_seq_conta_banco),
		max(a.nr_seq_arquivo)
	into STRICT	cd_estabelecimento_w,
		ie_remessa_retorno_w,
		ds_arquivo_w,
		nr_seq_conta_banco_w,
		nr_seq_arquivo_w
	from	cobranca_escritural a
	where	a.nr_sequencia	= nr_seq_documento_p;

	select	max(a.cd_banco)
	into STRICT	cd_banco_w
	from	banco_estabelecimento a
	where	a.nr_sequencia	= nr_seq_conta_banco_w;

	if (coalesce(nr_seq_banco_interf_p,0) = 0) then

		select	max(a.cd_interface_cobr_retorno),
			max(a.nm_obj_cobr_escrit_ret),
			max(a.nm_tab_cobr_escrit_ret)
		into STRICT	cd_interface_w,
			nm_obj_cobr_escrit_ret_w,
			nm_tab_cobr_escrit_ret_w
		from	banco a
		where	a.cd_banco	= cd_banco_w;

	else

		select	max(a.cd_interface),
			max(a.ds_objeto),
			coalesce(max(a.nm_tabela),max(c.nm_tab_cobr_escrit_ret))
		into STRICT	cd_interface_w,
			nm_obj_cobr_escrit_ret_w,
			nm_tab_cobr_escrit_ret_w
		from	banco c,
			banco_estabelecimento b,
			banco_estab_interf a
		where	b.cd_banco		= c.cd_banco
		and	a.nr_seq_conta_banco	= b.nr_sequencia
		and	a.nr_seq_conta_banco	= nr_seq_conta_banco_w
		and	a.nr_sequencia		= nr_seq_banco_interf_p;

	end if;

	if (ie_remessa_retorno_w	= 'T') and (coalesce(ie_acao_p,'T')	= 'T') then

		if (nm_obj_cobr_escrit_ret_w IS NOT NULL AND nm_obj_cobr_escrit_ret_w::text <> '') then

			select	count(*)
			into STRICT	qt_procedure_w
			from	user_objects a
			where	upper(object_name)	= upper(nm_obj_cobr_escrit_ret_w);

			if (qt_procedure_w	= 0) then

				CALL gerar_w_inconsistencia_escrit(ie_opcao_p,nr_seq_documento_p,6,nm_usuario_p);

			end if;

		end if;

		if (nm_tab_cobr_escrit_ret_w IS NOT NULL AND nm_tab_cobr_escrit_ret_w::text <> '') then

			select	count(*)
			into STRICT	qt_tabela_w
			from	user_tables a
			where	upper(a.table_name)	= upper(nm_tab_cobr_escrit_ret_w);

			if (qt_tabela_w	= 0) then

				CALL gerar_w_inconsistencia_escrit(ie_opcao_p,nr_seq_documento_p,7,nm_usuario_p);

			end if;

		end if;

		if (coalesce(cd_interface_w,0) = 0) then

			CALL gerar_w_inconsistencia_escrit(ie_opcao_p,nr_seq_documento_p,4,nm_usuario_p);

		else

			select	count(*)
			into STRICT	qt_instrucao_w
			from	interface_instrucao a
			where	a.cd_interface		= cd_interface_w;

			if (qt_instrucao_w	> 0) then

				select	count(*)
				into STRICT	qt_instrucao_w
				from	interface_instrucao a
				where	upper(a.nm_tabela)	= upper(nm_tab_cobr_escrit_ret_w)
				and	upper(a.nm_objeto)	= upper(nm_obj_cobr_escrit_ret_w)
				and	a.cd_interface		= cd_interface_w;

				if (qt_instrucao_w	= 0) then

					CALL gerar_w_inconsistencia_escrit(ie_opcao_p,nr_seq_documento_p,5,nm_usuario_p);

				end if;

			end if;

		end if;

		ie_reimportar_arquivo_w := obter_param_usuario(815, 12, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_reimportar_arquivo_w);

		if (ie_reimportar_arquivo_w = 'N') and ((ds_arquivo_w IS NOT NULL AND ds_arquivo_w::text <> '') or (nr_seq_arquivo_w IS NOT NULL AND nr_seq_arquivo_w::text <> '')) then

			CALL gerar_w_inconsistencia_escrit(ie_opcao_p,nr_seq_documento_p,3,nm_usuario_p);

		end if;

	end if;

	if (coalesce(ie_acao_p,'T')	= 'R') or (coalesce(ie_acao_p,'T')	= 'B') then

		open	c01;
		loop
		fetch	c01 into
			nr_titulo_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */

			CALL consistir_regra_escritural(ie_opcao_p,nr_seq_documento_p,nr_titulo_w,nm_usuario_p);

		end	loop;
		close	c01;

	end if;

elsif (ie_opcao_p	= 'P') then

	delete	from w_inconsistencia_escrit;

	select	count(*)
	into STRICT	qt_usuario_lib_w
	from	conta_pagar_lib a
	where	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and	a.nr_seq_banco_escrit	= nr_seq_documento_p;

	select	max(a.nr_seq_conta_banco),
		max(a.ie_remessa_retorno),
		max(a.qt_min_usuario_lib),
		max(a.cd_estabelecimento)
	into STRICT	nr_seq_conta_banco_w,
		ie_remessa_retorno_w,
		qt_min_usuario_lib_w,
		cd_estabelecimento_w
	from	banco_escritural a
	where	a.nr_sequencia		= nr_seq_documento_p;

	if (qt_usuario_lib_w	< qt_min_usuario_lib_w) then

		CALL gerar_w_inconsistencia_escrit(ie_opcao_p,nr_seq_documento_p,8,nm_usuario_p);

	end if;

	select	max(a.cd_banco)
	into STRICT	cd_banco_w
	from	banco_estabelecimento a
	where	a.nr_sequencia	= nr_seq_conta_banco_w;

	if (coalesce(nr_seq_banco_interf_p,0) = 0) then

		select	max(a.cd_interface_retorno),
			max(a.nm_objeto_retorno),
			max(a.nm_tabela_retorno)
		into STRICT	cd_interface_w,
			nm_objeto_retorno_w,
			nm_tabela_retorno_w
		from	banco a
		where	a.cd_banco	= cd_banco_w;

	else

		select	max(a.cd_interface),
			max(a.ds_objeto),
			coalesce(max(a.nm_tabela),max(c.nm_tabela_retorno))
		into STRICT	cd_interface_w,
			nm_objeto_retorno_w,
			nm_tabela_retorno_w
		from	banco c,
			banco_estabelecimento b,
			banco_estab_interf a
		where	b.cd_banco		= c.cd_banco
		and	a.nr_seq_conta_banco	= b.nr_sequencia
		and	a.nr_seq_conta_banco	= nr_seq_conta_banco_w
		and	a.nr_sequencia		= nr_seq_banco_interf_p;

	end if;

	if (ie_remessa_retorno_w	= 'T') then

		if (nm_objeto_retorno_w IS NOT NULL AND nm_objeto_retorno_w::text <> '') then

			select	count(*)
			into STRICT	qt_procedure_w
			from	user_objects a
			where	upper(object_name)	= upper(nm_objeto_retorno_w);

			if (qt_procedure_w	= 0) then

				CALL gerar_w_inconsistencia_escrit(ie_opcao_p,nr_seq_documento_p,6,nm_usuario_p);

			end if;

		end if;

		if (nm_tabela_retorno_w IS NOT NULL AND nm_tabela_retorno_w::text <> '') then

			select	count(*)
			into STRICT	qt_tabela_w
			from	user_tables a
			where	upper(a.table_name)	= upper(nm_tabela_retorno_w);

			if (qt_tabela_w	= 0) then

				CALL gerar_w_inconsistencia_escrit(ie_opcao_p,nr_seq_documento_p,7,nm_usuario_p);

			end if;

		end if;

		if (coalesce(cd_interface_w,0) = 0) then

			CALL gerar_w_inconsistencia_escrit(ie_opcao_p,nr_seq_documento_p,9,nm_usuario_p);

		else

			select	count(*)
			into STRICT	qt_instrucao_w
			from	interface_instrucao a
			where	a.cd_interface		= cd_interface_w;

			if (qt_instrucao_w	> 0) then

				select	count(*)
				into STRICT	qt_instrucao_w
				from	interface_instrucao a
				where	upper(a.nm_tabela)	= upper(nm_tabela_retorno_w)
				and	upper(a.nm_objeto)	= upper(nm_objeto_retorno_w)
				and	a.cd_interface		= cd_interface_w;

				if (qt_instrucao_w	= 0) then

					CALL gerar_w_inconsistencia_escrit(ie_opcao_p,nr_seq_documento_p,5,nm_usuario_p);

				end if;

			end if;

		end if;

	elsif (ie_remessa_retorno_w	= 'R') then

		select	count(*)
		into STRICT	qt_titulo_w
		from	titulo_pagar_escrit a
		where	a.nr_seq_escrit	= nr_seq_documento_p;

		if (qt_titulo_w	= 0) then

			CALL gerar_w_inconsistencia_escrit(ie_opcao_p,nr_seq_documento_p,10,nm_usuario_p);

		end if;

	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_incosistencia_escritural (ie_opcao_p text, nr_seq_documento_p bigint, nr_seq_banco_interf_p bigint, nm_usuario_p text, ie_acao_p text) FROM PUBLIC;
