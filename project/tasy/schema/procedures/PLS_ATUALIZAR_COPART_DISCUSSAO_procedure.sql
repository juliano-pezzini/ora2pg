-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_copart_discussao ( nr_seq_lote_disc_p pls_lote_discussao.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	OS 824259 (Dt fechamento) e OS 824256 (Status coparticipação)
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_tipo_arquivo_w		pls_lote_discussao.ie_tipo_arquivo%type;
dt_fechamento_w			pls_lote_discussao.dt_fechamento%type;
nr_seq_lote_contest_w		pls_lote_contestacao.nr_sequencia%type;
qt_regitros_w			integer := 0;
qt_discussao_w			integer := 0;
qt_negociacao_w			integer := 0;
dt_fechamento_discussao_w	pls_conta_coparticipacao.dt_fechamento_discussao%type;
ie_status_coparticipacao_w	pls_conta_coparticipacao.ie_status_coparticipacao%type;

C01 CURSOR(nr_seq_lote_contest_pc	pls_lote_contestacao.nr_sequencia%type) FOR
	SELECT	x.nr_sequencia nr_seq_conta_copart,
		x.ie_status_coparticipacao,
		a.ie_tipo_acordo,
		b.nr_sequencia nr_seq_discussao
	from	pls_conta_coparticipacao	x,
		pls_discussao_proc		a,
		pls_contestacao_discussao	b
	where	a.nr_sequencia	= x.nr_seq_disc_proc
	and	b.nr_sequencia	= a.nr_seq_discussao
	and	b.nr_seq_lote	in (SELECT	w.nr_sequencia
					from	pls_lote_discussao	w
					where	w.nr_seq_lote_contest	= nr_seq_lote_contest_pc)
	
union

	select	x.nr_sequencia nr_seq_conta_copart,
		x.ie_status_coparticipacao,
		a.ie_tipo_acordo,
		b.nr_sequencia nr_seq_discussao
	from	pls_conta_coparticipacao	x,
		pls_discussao_mat		a,
		pls_contestacao_discussao	b
	where	a.nr_sequencia	= x.nr_seq_disc_mat
	and	b.nr_sequencia	= a.nr_seq_discussao
	and	b.nr_seq_lote	in (select	w.nr_sequencia
					from	pls_lote_discussao	w
					where	w.nr_seq_lote_contest	= nr_seq_lote_contest_pc);

BEGIN
select	max(ie_tipo_arquivo),
	max(dt_fechamento),
	max(nr_seq_lote_contest)
into STRICT	ie_tipo_arquivo_w,
	dt_fechamento_w,
	nr_seq_lote_contest_w
from	pls_lote_discussao
where	nr_sequencia	= nr_seq_lote_disc_p;

select	count(1)
into STRICT	qt_regitros_w
from	ptu_camara_contestacao
where	nr_seq_lote_contest	= nr_seq_lote_contest_w;

for r_C01_w in C01(nr_seq_lote_contest_w) loop
	dt_fechamento_discussao_w	:= null;
	ie_status_coparticipacao_w	:= null;

	--Atualizar a data de fechamento da discussão na coparticipação
	if (ie_tipo_arquivo_w in (5,6,7,8,9)) or
		((coalesce(ie_tipo_arquivo_w::text, '') = '') and (qt_regitros_w = 0)) then
		dt_fechamento_discussao_w	:= dt_fechamento_w;

		-- D - Coparticipação em discussão / F - Coparticipação liberada de conta em discussão / P - Pendente fechamento da conta
		if (r_C01_w.ie_status_coparticipacao in ('D','F','P')) then
			ie_status_coparticipacao_w := 'S';
		end if;
	end if;

	-- Se a coparticipação foi ou não liberada para mensalidade
	if (r_C01_w.ie_status_coparticipacao <> 'S') and (coalesce(ie_status_coparticipacao_w::text, '') = '') then

		if (r_C01_w.ie_tipo_acordo = '00') then -- 00 Questionamento em negociação
			ie_status_coparticipacao_w := 'D'; -- Coparticipação em discussão
		else
			select	count(1)
			into STRICT	qt_negociacao_w
			from (SELECT	count(1)
				from	pls_discussao_proc
				where	nr_seq_discussao	= r_C01_w.nr_seq_discussao
				and	ie_tipo_acordo		= '00' -- 00 Questionamento em negociação
				
union

				SELECT	count(1)
				from	pls_discussao_mat
				where	nr_seq_discussao	= r_C01_w.nr_seq_discussao
				and	ie_tipo_acordo		= '00') alias3; -- 00 Questionamento em negociação
			if (qt_negociacao_w > 0) then
				ie_status_coparticipacao_w := 'F'; -- Coparticipação liberada de conta em discussão
			end if;
		end if;
	end if;

	update	pls_conta_coparticipacao
	set	dt_fechamento_discussao		= coalesce(dt_fechamento_discussao_w,dt_fechamento_discussao),
		ie_status_coparticipacao	= coalesce(ie_status_coparticipacao_w,ie_status_coparticipacao)
	where	nr_sequencia			= r_C01_w.nr_seq_conta_copart;
end loop;

if (coalesce(ie_commit_p,'N') = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_copart_discussao ( nr_seq_lote_disc_p pls_lote_discussao.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) FROM PUBLIC;

