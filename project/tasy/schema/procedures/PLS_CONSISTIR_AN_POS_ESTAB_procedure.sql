-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_an_pos_estab ( nr_seq_analise_p bigint, nr_seq_grupo_atual_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_commit_p text, ie_processo_cta_p text, ie_gravar_log_p text default null) AS $body$
DECLARE



/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

OBS : ROTINA DERIVADA DA PLS_CONSISTIR_ANALISE_POS, DESENVOLVIDA PARA ATENDER A REESTRUTURAÇÃO
DA GERAÇÃO DE PÓS-ESTABELECIDO. ALTERAÇÕES NESSA ROTINA DEVEM SER REFLETIDAS NAQUELA, ENQUANDO
A GERAÇÃO ANTIGA NÃO FOR DESCONTINUADA


Finalidade: Reconsistir a análise de pós estabelecido
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

IE_PROCESSO_CTA_P - Parâmetro utilizado para verificar se é chamada pela rotina PLS_CTA_PROCESSAR_LOTE

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
qt_auditoria_w			bigint;
nr_seq_discussao_w		bigint;
ie_opcao_w			varchar(1);
qt_registro_w			integer;
ie_ajuste_fat_w			varchar(1) := 'N';

C01 CURSOR FOR
	SELECT	c.nr_sequencia nr_seq_conta,
		c.nr_seq_segurado
	from	pls_analise_conta	pos,
		pls_analise_conta	pag,
		pls_conta		c
	where	pos.nr_sequencia 	= nr_seq_analise_p
	and	pos.nr_seq_analise_ref 	= pag.nr_sequencia
	and	pag.nr_sequencia	= c.nr_seq_analise
	and	ie_ajuste_fat_w		= 'N'
	
union all

	SELECT  c.nr_sequencia nr_seq_conta,
	        c.nr_seq_segurado
	from    pls_conta c
	where   nr_seq_conta_princ in (   select c.nr_sequencia
		    from   pls_analise_conta pos,
			   pls_analise_conta pag,
			   pls_conta   c
		    where  pos.nr_sequencia  = nr_seq_analise_p
		    and    pos.nr_seq_analise_ref  = pag.nr_sequencia
		    and    pag.nr_sequencia  = c.nr_seq_analise)
	and    	(nr_seq_ajuste_fat IS NOT NULL AND nr_seq_ajuste_fat::text <> '')
	and	ie_ajuste_fat_w = 'S'
	group by
		c.nr_sequencia,
		c.nr_seq_segurado
	order by
		1;
BEGIN

select  CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_ajuste_fat_w
from (SELECT  1
	from	pls_conta_pos_proc a,
		pls_conta b
	where	a.nr_seq_conta = b.nr_sequencia
	and	a.nr_seq_analise = nr_seq_analise_p
	and	(b.nr_seq_ajuste_fat IS NOT NULL AND b.nr_seq_ajuste_fat::text <> '')
	and	a.ie_status_faturamento != 'A'
	
union all

	SELECT  1
	from	pls_conta_pos_mat a,
		pls_conta b
	where	a.nr_seq_conta = b.nr_sequencia
	and	a.nr_seq_analise = nr_seq_analise_p
	and	(b.nr_seq_ajuste_fat IS NOT NULL AND b.nr_seq_ajuste_fat::text <> '')
	and	a.ie_status_faturamento != 'A') alias3;


for r_c01_w in C01 loop

	select	max(b.nr_sequencia)
	into STRICT	nr_seq_discussao_w
	from	pls_contestacao		a,
		pls_contestacao_discussao b
	where	b.nr_seq_contestacao	= a.nr_sequencia
	and	a.nr_seq_conta		= r_c01_w.nr_seq_conta;

	if (nr_seq_discussao_w IS NOT NULL AND nr_seq_discussao_w::text <> '') then
		ie_opcao_w := 'F';
	else
		ie_opcao_w := 'R';
	end if;

	-- Se for processo de conta médica, verifica se a conta esta em discussão,
	-- caso esteja, mas não foi gerado pós-estabelecido de discussão, processa o pós da conta médica
	if (coalesce(ie_processo_cta_p,'N') = 'S') and (nr_seq_discussao_w IS NOT NULL AND nr_seq_discussao_w::text <> '') then

		select	count(1)
		into STRICT	qt_registro_w
		from (	SELECT	1
			from	pls_conta_pos_proc
			where	nr_seq_conta	= r_c01_w.nr_seq_conta
			and	(nr_seq_disc_proc IS NOT NULL AND nr_seq_disc_proc::text <> '')
			and	ie_status_faturamento != 'A'
			
union all

			SELECT	1
			from	pls_conta_pos_mat
			where	nr_seq_conta	= r_c01_w.nr_seq_conta
			and	(nr_seq_disc_mat IS NOT NULL AND nr_seq_disc_mat::text <> '')
			and	ie_status_faturamento != 'A') alias6;

		if (qt_registro_w = 0) then
			ie_opcao_w := 'R';
		end if;
	end if;

	--Inativar as glosas e ocorrências antes de consistir
	update	pls_ocorrencia_benef a
	set	ie_situacao		= 'I',
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp(),
		ie_forma_inativacao	= CASE WHEN ie_forma_inativacao='U' THEN 'US' WHEN ie_forma_inativacao='US' THEN 'US'  ELSE 'S' END
	where	nr_seq_conta_pos_proc 	in (	SELECT	pos.nr_sequencia
						from	pls_conta_pos_proc	pos
						where	pos.nr_seq_conta	= r_c01_w.nr_seq_conta
						and	pos.nr_seq_analise	= nr_seq_analise_p)
	and (ie_lib_manual	= 'N' or coalesce(ie_lib_manual::text, '') = '');

	update	pls_ocorrencia_benef a
	set	ie_situacao		= 'I',
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp(),
		ie_forma_inativacao	= CASE WHEN ie_forma_inativacao='U' THEN 'US' WHEN ie_forma_inativacao='US' THEN 'US'  ELSE 'S' END
	where	nr_seq_conta_pos_mat 	in (	SELECT	pos.nr_sequencia
						from	pls_conta_pos_mat	pos
						where	pos.nr_seq_conta	= r_c01_w.nr_seq_conta
						and	pos.nr_seq_analise	= nr_seq_analise_p
					)
	and (ie_lib_manual	= 'N' or coalesce(ie_lib_manual::text, '') = '');

	--Recalcular novamente o pos estab
	if (coalesce(ie_commit_p,'S') = 'S') then
		CALL pls_pos_estabelecido_pck.gerencia_pos_estabelecido(	null, null, null,
									null, r_c01_w.nr_seq_conta, null,
									null, null, null,
									nm_usuario_p, cd_estabelecimento_p);

	else

		CALL pls_pos_estabelecido_pck.processar_ocor_e_lib_automatic( null, null, null,
									null, r_c01_w.nr_seq_conta, null,
									null, nm_usuario_p, cd_estabelecimento_p);
	end if;

end loop;


/* Atualizar os pareceres das ocorrências que foram inativas automaticamente */

update	pls_analise_glo_ocor_grupo a
set	a.ie_status	= 'L',
	a.dt_analise	= clock_timestamp(),
	a.nm_usuario_analise = nm_usuario_p
where	a.nr_seq_analise	= nr_seq_analise_p
and	a.ie_status		= 'P'
and	exists (SELECT	1
		from	pls_ocorrencia_benef x
		where	x.nr_sequencia	= a.nr_seq_ocor_benef
		and	x.ie_situacao	= 'I'
		and	x.ie_forma_inativacao in ('S','US'));

CALL pls_gera_fluxo_audit_novo_pos(nr_seq_analise_p, null, nm_usuario_p, cd_estabelecimento_p);

for r_c01_w in C01() loop
	begin

	CALL pls_atual_status_fat_pos_estab(r_c01_w.nr_seq_conta, null, null, nr_seq_analise_p, cd_estabelecimento_p, nm_usuario_p);
	select	count(1)
	into STRICT	qt_auditoria_w
	from	pls_auditoria_conta_grupo
	where	nr_seq_analise	= nr_seq_analise_p
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');

	if (qt_auditoria_w = 0) then

		CALL pls_gerar_grupo_auditoria_pos(r_c01_w.nr_seq_conta, nr_seq_analise_p, nm_usuario_p, cd_estabelecimento_p);
	end if;
	if (coalesce(nr_seq_discussao_w::text, '') = '') then

		CALL pls_pos_estabelecido_pck.gerar_valores_adicionais( 	null, null, null,
									nr_seq_analise_p, null, null,
									null, 'N', nm_usuario_p,
									cd_estabelecimento_p);

	end if;
	end;
end loop;

if (coalesce(ie_commit_p,'S') = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_an_pos_estab ( nr_seq_analise_p bigint, nr_seq_grupo_atual_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_commit_p text, ie_processo_cta_p text, ie_gravar_log_p text default null) FROM PUBLIC;
