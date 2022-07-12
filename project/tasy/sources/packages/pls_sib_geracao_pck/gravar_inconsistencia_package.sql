-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_sib_geracao_pck.gravar_inconsistencia ( nr_seq_sib_movimento_p pls_sib_movimento.nr_sequencia%type, cd_inconsistencia_p pls_sib_inconsistencia.cd_inconsistencia%type, ie_tipo_movimento_p pls_sib_movimento.ie_tipo_movimento%type, ie_titular_p bigint, qt_idade_p bigint, nr_seq_movimento_p pls_sib_movimento.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


nr_seq_inconsistencia_w		pls_sib_inconsistencia.nr_sequencia%type;
qt_sib_consistencia_w		bigint;
nr_seq_mov_consistencia_w	pls_sib_mov_consistencia.nr_sequencia%type;


BEGIN
begin
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_inconsistencia_w
	from	pls_sib_inconsistencia a
	where	a.cd_inconsistencia = cd_inconsistencia_p
	and	((ie_tipo_movimento_p = 1 AND a.ie_inclusao = 'S')
	or	(ie_tipo_movimento_p = 2 AND a.ie_retificacao = 'S')
	or	(ie_tipo_movimento_p = 3 AND a.ie_mudanca_contratual = 'S')
	or	(ie_tipo_movimento_p = 4 AND a.ie_cancelamento = 'S')
	or	(ie_tipo_movimento_p = 5 AND a.ie_reinclusao = 'S'))
	and	((ie_titular_p = 1 and a.ie_titular = 'S')
	or (ie_titular_p = 2 and a.ie_dependente_menor_idade = 'S' and qt_idade_p < 18)
	or (ie_titular_p = 2 and a.ie_dependente_maior_idade = 'S' and qt_idade_p >= 18));
exception
when others then
	nr_seq_inconsistencia_w := null;
end;

if (nr_seq_inconsistencia_w IS NOT NULL AND nr_seq_inconsistencia_w::text <> '') then
	if (coalesce(nr_seq_movimento_p::text, '') = '') then
		current_setting('pls_sib_geracao_pck.tb_nr_seq_movimento_w')::pls_util_cta_pck.t_number_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint)		:= nr_seq_sib_movimento_p;
		current_setting('pls_sib_geracao_pck.tb_nr_seq_consistencia_w')::pls_util_cta_pck.t_number_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint)	:= nr_seq_inconsistencia_w;
		current_setting('pls_sib_geracao_pck.tb_nr_seq_consistencia_conf_w')::pls_util_cta_pck.t_number_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
		CALL CALL CALL pls_sib_geracao_pck.inserir_inconsistencia('N',nm_usuario_p);
	else
		select	count(1)
		into STRICT	qt_sib_consistencia_w
		from	pls_sib_mov_consistencia
		where	nr_seq_consistencia = nr_seq_inconsistencia_w
		and	nr_seq_movimento = nr_seq_movimento_p;

		if (qt_sib_consistencia_w = 0) then
			current_setting('pls_sib_geracao_pck.tb_nr_seq_movimento_w')::pls_util_cta_pck.t_number_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint)		:= nr_seq_sib_movimento_p;
			current_setting('pls_sib_geracao_pck.tb_nr_seq_consistencia_w')::pls_util_cta_pck.t_number_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint)	:= nr_seq_inconsistencia_w;
			current_setting('pls_sib_geracao_pck.tb_nr_seq_consistencia_conf_w')::pls_util_cta_pck.t_number_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := null;
			CALL CALL CALL pls_sib_geracao_pck.inserir_inconsistencia('N',nm_usuario_p);
		else --Verificar se existe inconsistencia corrigida
			select	max(nr_sequencia)
			into STRICT	nr_seq_mov_consistencia_w
			from	pls_sib_mov_consistencia
			where	nr_seq_consistencia = nr_seq_inconsistencia_w
			and	nr_seq_movimento = nr_seq_movimento_p
			and	ie_status = 2;

			if (nr_seq_mov_consistencia_w IS NOT NULL AND nr_seq_mov_consistencia_w::text <> '') then
				update	pls_sib_mov_consistencia
				set	ie_status = 1
				where	nr_sequencia	= nr_seq_mov_consistencia_w;
			end if;
		end if;
	end if;
end if;
end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sib_geracao_pck.gravar_inconsistencia ( nr_seq_sib_movimento_p pls_sib_movimento.nr_sequencia%type, cd_inconsistencia_p pls_sib_inconsistencia.cd_inconsistencia%type, ie_tipo_movimento_p pls_sib_movimento.ie_tipo_movimento%type, ie_titular_p bigint, qt_idade_p bigint, nr_seq_movimento_p pls_sib_movimento.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
