-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_via_acesso_manual ( nr_sequencia_p bigint, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_grupo_p bigint, ie_via_acesso_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p text) AS $body$
DECLARE



ie_via_acesso_w			pls_conta_proc.ie_via_acesso_manual%type;
ie_origem_proced_w		procedimento.ie_origem_proced%type;
tx_item_w				pls_conta_proc.tx_item%type;
tx_item_via_acesso_w	pls_conta_proc.tx_item%type;
nr_seq_conta_w			pls_conta_proc.nr_seq_conta%type;
cd_procedimento_w		procedimento.cd_procedimento%type;
ds_observacao_w			varchar(4000);


BEGIN

select	a.tx_item,
	a.ie_via_acesso,
	a.nr_seq_conta,
	cd_procedimento,
	ie_origem_proced
into STRICT	tx_item_w,
	ie_via_acesso_w,
	nr_seq_conta_w,
	cd_procedimento_w,
	ie_origem_proced_w
from	pls_conta_proc	a
where	a.nr_sequencia	= nr_sequencia_p;

if (coalesce(ie_via_acesso_p,'X') <> coalesce(ie_via_acesso_w,'X')) then
	select 	obter_tx_proc_via_acesso(ie_via_acesso_p)
	into STRICT	tx_item_via_acesso_w
	;
end if;

if (coalesce(ie_via_acesso_p,'X') <> coalesce(ie_via_acesso_w,'X')) then
	ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
				'Via acesso: '||chr(13)||chr(10)||
				chr(9)||'Anterior: '||obter_valor_dominio(1268, ie_via_acesso_w)||' - Modificada: '||obter_valor_dominio(1268, ie_via_acesso_p)||chr(13)||chr(10);

	update	pls_conta_proc
	set	tx_item						= 	tx_item_via_acesso_w,
		ie_via_acesso				=	ie_via_acesso_p,
		ie_via_acesso_manual		=	'S',
		nm_usuario					=	nm_usuario_p,
		dt_atualizacao				= clock_timestamp()
	where	nr_sequencia 		= 	nr_sequencia_p;
end if;


if (coalesce(ds_observacao_w,'X') <> 'X') then
	CALL pls_inserir_hist_analise(nr_seq_conta_w, nr_seq_analise_p, 15,
				 nr_sequencia_p, 'P', null,
				 null, 'Modificado pelo auditor ' || obter_nome_usuario(nm_usuario_p) || '.' || chr(13) || chr(10) ||
				'Item ' || pls_obter_desc_procedimento(cd_procedimento_w, ie_origem_proced_w) || '.' || chr(13) || chr(10) ||
				 ds_observacao_w, nr_seq_grupo_p, nm_usuario_p, cd_estabelecimento_p);
end if;

CALL pls_atualiza_valor_conta(nr_seq_conta_w, nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_via_acesso_manual ( nr_sequencia_p bigint, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_grupo_p bigint, ie_via_acesso_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p text) FROM PUBLIC;

