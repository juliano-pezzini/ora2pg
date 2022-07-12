-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_atualizar_mes_reaj_pck.excluir_contrato_grupo_relac ( nr_seq_contrato_grupo_p pls_contrato_grupo.nr_sequencia%type, nr_seq_contrato_p pls_contrato.nr_sequencia%type, nr_seq_intercambio_p pls_intercambio.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


dt_reajuste_w			pls_grupo_contrato.dt_reajuste%type;
ie_tipo_relacionamento_w	pls_grupo_contrato.ie_tipo_relacionamento%type;
ie_atualizar_mes_reajuste_w	varchar(1);
nr_seq_grupo_contrato_w		pls_grupo_contrato.nr_sequencia%type;


BEGIN

select	max(b.dt_reajuste),
	max(b.ie_tipo_relacionamento),
	max(b.nr_sequencia)
into STRICT	dt_reajuste_w,
	ie_tipo_relacionamento_w,
	nr_seq_grupo_contrato_w
from	pls_contrato_grupo a,
	pls_grupo_contrato b
where	b.nr_sequencia = a.nr_seq_grupo
and	a.nr_sequencia = nr_seq_contrato_grupo_p;

if	((ie_tipo_relacionamento_w not in ('4')) and (dt_reajuste_w IS NOT NULL AND dt_reajuste_w::text <> '')) then
	ie_atualizar_mes_reajuste_w	:= 'S';
else
	ie_atualizar_mes_reajuste_w	:= 'N';
end if;

delete from pls_contrato_grupo
where	nr_sequencia = nr_seq_contrato_grupo_p;

if (ie_atualizar_mes_reajuste_w = 'S') then
	CALL pls_atualizar_mes_reaj_pck.alterar_mes_reaj_contr_grupo(nr_seq_contrato_p, nr_seq_intercambio_p, nm_usuario_p, cd_estabelecimento_p);
end if;

CALL pls_atualizar_mes_reaj_pck.inserir_historico_grupo(nr_seq_grupo_contrato_w, 'Excluído do grupo o contrato: ' || coalesce(nr_seq_contrato_p,nr_seq_intercambio_p), 'Exclusão de contrato.',
			'N', cd_estabelecimento_p, nm_usuario_p);

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_mes_reaj_pck.excluir_contrato_grupo_relac ( nr_seq_contrato_grupo_p pls_contrato_grupo.nr_sequencia%type, nr_seq_contrato_p pls_contrato.nr_sequencia%type, nr_seq_intercambio_p pls_intercambio.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;