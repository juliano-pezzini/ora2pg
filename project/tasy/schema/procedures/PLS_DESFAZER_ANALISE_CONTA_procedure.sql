-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_analise_conta ( nr_seq_conta_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_conta_w			varchar(255);
ds_conta_pas_w			varchar(255);
ds_conta_www			varchar(255);
ds_conta_ww			varchar(255);
cd_guia_w			varchar(20);
ds_seq_conta_w			varchar(20);
ie_existe_grupo_analise_w	bigint;
nr_lote_w			bigint;		
nr_seq_analise_w		bigint;
nr_posicao_w			bigint;
nr_seq_analise_conta_item_w	bigint;
qt_grupos_analise_w		bigint;
qt_contas_analise_w		bigint;
nr_seq_analise_item_w		bigint;
nr_seq_aud_conta_grupo_w	bigint;
qt_cta_monitor_w		integer;
	
C02 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_auditoria_conta_grupo
	where	nr_seq_analise	= nr_seq_analise_w;


BEGIN
select	max(nr_seq_analise)
into STRICT	nr_seq_analise_w
from	pls_conta
where	nr_sequencia	= nr_seq_conta_p;

CALL pls_desfazer_grupo_aud_conta(nr_seq_conta_p, cd_estabelecimento_p, nm_usuario_p);

select	count(nr_sequencia)
into STRICT	qt_grupos_analise_w
from	pls_auditoria_conta_grupo
where	nr_seq_analise	= nr_seq_analise_w;

/*Diego 08/04/2011 - Caso não haja mais grupos de análise mais ainda existir contas o status é atualizado para atendimento sem auditoria.*/

if (qt_grupos_analise_w = 0) then
	CALL pls_alterar_status_analise_cta(nr_seq_analise_w, 'S', 'PLS_DESFAZER_ANALISE_CONTA', nm_usuario_p, cd_estabelecimento_p);
end if;

select	count(1)
into STRICT	qt_cta_monitor_w
from	pls_monitor_tiss_alt_guia a,
	pls_monitor_tiss_alt b
where	b.nr_sequencia = a.nr_seq_cta_alt
and	b.nr_seq_conta = nr_seq_conta_p;
--Tratamento para evitar desfazer o fechamento de uma conta já enviada no monitoramento
if (qt_cta_monitor_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(451120);
end if;

-- Caso não tenha sido enviada no monitoramento exclui os registros de log
delete	FROM pls_monitor_tiss_alt
where	nr_seq_conta	= nr_seq_conta_p
and	ie_tipo_evento	= 'FC'
and	ie_status	= 'P';

/* Desvincular a conta da análise */
	
update	pls_conta
set	nr_seq_analise	 = NULL,
	ie_status 	= 'P'
where	nr_sequencia	= nr_seq_conta_p
and	ie_status	!= 'C';

select	count(nr_sequencia)
into STRICT	qt_contas_analise_w
from	pls_conta
where	nr_seq_analise	= nr_seq_analise_w;

/*Apagar os parecers das glosas e ocorrências */

delete  FROM pls_analise_parecer_item x
where	exists (SELECT	1
		from	pls_analise_conta_item a
		where	a.nr_seq_analise = nr_seq_analise_w
		and	a.nr_seq_conta	 = nr_seq_conta_p
		and	a.nr_sequencia	 = x.nr_seq_item);

/* Apagar os fluxos gerados durante a análise */

delete  FROM pls_analise_fluxo_item x
where	exists (SELECT	1
		from	pls_analise_conta_item a
		where	a.nr_seq_analise = nr_seq_analise_w
		and	a.nr_seq_conta	 = nr_seq_conta_p
		and	a.nr_sequencia	 = x.nr_seq_glosa_item);

delete	FROM pls_analise_conta_item
where	nr_seq_analise	= nr_seq_analise_w
and	nr_seq_conta	= nr_seq_conta_p;

delete	FROM pls_analise_conta_item
where	nr_seq_w_resumo_conta in (SELECT	nr_sequencia
					from	w_pls_resumo_conta
					where	nr_seq_conta 	= nr_seq_conta_p
					and	nr_seq_analise 	= nr_seq_analise_w);

/*Apagar os registros de resumo*/

delete	FROM w_pls_resumo_conta
where	nr_seq_conta 	= nr_seq_conta_p
and	nr_seq_analise 	= nr_seq_analise_w;

--Limpa referências a pós-estab(vinculará novamente ao fechar as contas e gerar pós). Atualiza

--todas as tabelas, da velha e nova geração de pós, pois o campo nr_seq_conta é único e não terá problema nesse caso
update	pls_conta_pos_estabelecido
set	nr_seq_analise	 = NULL,
	dt_atualizacao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p
where 	nr_seq_conta = nr_seq_conta_p
and	((ie_situacao		= 'A') or (coalesce(ie_situacao::text, '') = ''));

update	pls_conta_pos_proc
set	nr_seq_analise  = NULL,
	nm_usuario = nm_usuario_p,
	dt_atualizacao = clock_timestamp()
where 	nr_seq_conta = nr_seq_conta_p;

update	pls_conta_pos_mat
set	nr_seq_analise  = NULL,
	nm_usuario = nm_usuario_p,
	dt_atualizacao = clock_timestamp()
where 	nr_seq_conta = nr_seq_conta_p;
	

if (qt_contas_analise_w = 0) then
	delete	from pls_hist_analise_conta
	where	nr_seq_analise	= nr_seq_analise_w;

	delete	from w_pls_analise_selecao_item
	where	nr_seq_analise	= nr_seq_analise_w;
	
	open C02;
	loop
	fetch C02 into
		nr_seq_aud_conta_grupo_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		delete	from pls_tempo_conta_grupo
		where	nr_seq_auditoria	= nr_seq_aud_conta_grupo_w;
		end;
	end loop;
	close C02;
	
	/*Diego 07/02/2011 - Tratamento realizado para os casos de todas as contas terem sido desfeitras mais existir grupos de análise criados atarvés do inserir grupo*/

	delete  from pls_auditoria_conta_grupo
	where	nr_seq_analise	= nr_seq_analise_w;

	delete	from pls_analise_pedido_parecer
	where	nr_seq_analise	= nr_seq_analise_w;
	
	delete	from pls_analise_conta_parecer
	where	nr_seq_analise	= nr_seq_analise_w;

	delete 	FROM pls_analise_fluxo_ocor
	where	nr_seq_analise = nr_seq_analise_w;
	
	delete	from pls_analise_fluxo_item
	where	nr_seq_analise	= nr_seq_analise_w;
	
	delete	from pls_analise_glo_ocor_grupo
	where	nr_seq_analise	= nr_seq_analise_w;
	
	delete	from pls_analise_log_acesso
	where	nr_seq_analise	= nr_seq_analise_w;
	
	delete	from pls_analise_observacao
	where	nr_seq_analise	= nr_seq_analise_w;
	
	
	delete from pls_analise_conta_anexo
	where	nr_seq_analise	= nr_seq_analise_w;
	
	Update 	Ptu_Consulta_Beneficiario
	Set 	Nr_Seq_Inf_Conta_Interc	 = NULL 
	Where 	nr_seq_inf_conta_interc in ( SELECT 	nr_sequencia
						  from 		pls_analise_inf_conta_int
						  where 	nr_seq_analise 	= nr_seq_analise_w);
	
	delete	from pls_analise_inf_conta_int
	where 	nr_seq_analise 	= nr_seq_analise_w;
	
	delete	from pls_cta_analise_cons
	where	nr_seq_analise	= nr_seq_analise_w;

	delete from pls_conta_auditor
	where nr_seq_analise = nr_seq_analise_w;
	
	delete	from pls_analise_conta
	where	nr_sequencia	= nr_seq_analise_w;
	
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_analise_conta ( nr_seq_conta_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

