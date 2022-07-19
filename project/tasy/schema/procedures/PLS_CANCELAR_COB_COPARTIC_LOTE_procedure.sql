-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_cancelar_cob_copartic_lote ( nr_seq_lote_p bigint, nr_seq_copartic_p bigint, nr_seq_motivo_bloqueio_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ds_justificativa_p text, ie_funcao_p text default null) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Cancelar a coparticipação do lote 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ X ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
------------------------------------------------------------------------------------------------------------------- 
Referências: 
	OPS - Controle de Coparticipações 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
nr_seq_conta_coparticipacao_w		pls_lib_coparticipacao.nr_seq_conta_coparticipacao%type;
nr_seq_conta_proc_w			pls_conta_proc.nr_sequencia%type;
nr_seq_conta_mat_w			pls_conta_mat.nr_sequencia%type;
vl_coparticipacao_w			pls_conta_coparticipacao.vl_coparticipacao%type;
nr_seq_conta_w				pls_conta.nr_sequencia%type;
nr_seq_analise_w			pls_analise_conta.nr_sequencia%type;
nr_seq_segurado_w			pls_segurado.nr_sequencia%type;
nm_beneficiario_w			varchar(255);
ds_funcionalidade_w			varchar(255);


BEGIN 
select	max(a.nr_seq_conta_coparticipacao) 
into STRICT	nr_seq_conta_coparticipacao_w 
from	pls_lib_coparticipacao	a 
where	a.nr_sequencia	= nr_seq_copartic_p;
 
select	a.nr_seq_conta_proc, 
	a.nr_seq_conta_mat, 
	a.vl_coparticipacao, 
	b.nr_sequencia, 
	b.nr_seq_analise, 
	b.nr_seq_segurado 
into STRICT	nr_seq_conta_proc_w, 
	nr_seq_conta_mat_w, 
	vl_coparticipacao_w, 
	nr_seq_conta_w, 
	nr_seq_analise_w, 
	nr_seq_segurado_w 
from	pls_conta_coparticipacao a, 
	pls_conta b 
where	a.nr_seq_conta	= b.nr_sequencia 
and	a.nr_sequencia	= nr_seq_conta_coparticipacao_w;
 
nm_beneficiario_w	:= substr(pls_obter_dados_segurado(nr_seq_segurado_w, 'N'),1,255);
 
if (ie_funcao_p = 'S') then 
	ds_funcionalidade_w := 'BD - Cancelar cobrança da coparticipação guia';
elsif (ie_funcao_p = 'N') then 
	ds_funcionalidade_w := 'BD - Cancelar cobrança da coparticipação';
end if;
 
CALL pls_gravar_hist_lote_copartic(	nr_seq_lote_p, 
				substr('Cancelada a cobrança da coparticipação ' || nr_seq_conta_coparticipacao_w || chr(13) || chr(10) || 
				'Conta: ' || nr_seq_conta_w || chr(13) || chr(10) || 
				'Beneficiário: ' ||nr_seq_segurado_w || ' - ' || nm_beneficiario_w || chr(13) || chr(10) || 
				'Valor: ' || campo_mascara_virgula(vl_coparticipacao_w) || chr(13) || chr(10) || 
				'Análise = '||coalesce(nr_seq_analise_w,0)|| chr(13) || chr(10)|| 
				'nr_seq_conta_proc = '||coalesce(nr_seq_conta_proc_w,0) || chr(13) || chr(10)|| 
				'nr_seq_conta_mat = '||coalesce(nr_seq_conta_mat_w,0) || chr(13) || chr(10)|| 
				'Cancelada através da funcionalidade: ' || ds_funcionalidade_w,1,4000), 
				nm_usuario_p, 
				cd_estabelecimento_p);
 
update	pls_lib_coparticipacao 
set	dt_cancelamento			= clock_timestamp(), 
	nm_usuario_cancelamento		= nm_usuario_p, 
	nr_seq_cancelamento		= nr_seq_motivo_bloqueio_p 
where	nr_sequencia			= nr_seq_copartic_p;
 
update	pls_conta_coparticipacao 
set	ie_status_mensalidade	= 'C', 
	ds_justificativa_canc	= substr(ds_justificativa_p,1,4000), 
	nr_seq_motivo_cancel	= nr_seq_motivo_bloqueio_p 
where	nr_sequencia	= nr_seq_conta_coparticipacao_w;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cancelar_cob_copartic_lote ( nr_seq_lote_p bigint, nr_seq_copartic_p bigint, nr_seq_motivo_bloqueio_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ds_justificativa_p text, ie_funcao_p text default null) FROM PUBLIC;

