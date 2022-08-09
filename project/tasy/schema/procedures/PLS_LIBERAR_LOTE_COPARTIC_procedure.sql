-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_liberar_lote_copartic ( nr_seq_lote_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Liberar o lote de coparticipação
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ X ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
-------------------------------------------------------------------------------------------------------------------
Referências:
	OPS - Controle de Coparticipações
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_conta_coparticipacao_w	pls_lib_coparticipacao.nr_seq_conta_coparticipacao%type;
ie_status_coparticipacao_w	pls_conta_coparticipacao.ie_status_coparticipacao%type;
dt_competencia_mens_w		pls_lote_coparticipacao.dt_competencia_mens%type;
nr_seq_regra_w			pls_lote_coparticipacao.nr_seq_regra%type;
ie_permite_glosa_w		pls_regra_copart_item.ie_permite_glosa%type;
qt_critica_pendente_w		bigint;

C01 CURSOR FOR
	SELECT	a.nr_seq_conta_coparticipacao,
		b.ie_status_coparticipacao
	from	pls_lib_coparticipacao	a,
		pls_conta_coparticipacao b
	where	a.nr_seq_conta_coparticipacao	= b.nr_sequencia
	and	a.nr_seq_lote = nr_seq_lote_p
	and	coalesce(a.dt_cancelamento::text, '') = ''
	and	coalesce(a.nm_usuario_cancelamento::text, '') = ''
	and	coalesce(b.ie_status_mensalidade,'P') = 'P';


BEGIN

begin
select	dt_competencia_mens,
	nr_seq_regra
into STRICT	dt_competencia_mens_w,
	nr_seq_regra_w
from	pls_lote_coparticipacao
where	nr_sequencia	= nr_seq_lote_p;
exception
when others then
	dt_competencia_mens_w	:= null;
end;

select	coalesce(ie_permite_glosa,'N')
into STRICT	ie_permite_glosa_w
from	pls_regra_copart_item
where	nr_seq_regra = nr_seq_regra_w;


select	count(1)
into STRICT	qt_critica_pendente_w
from	pls_lib_coparticipacao
where	nr_seq_lote	= nr_seq_lote_p
and	ie_critica_pendente = 'S'
and	coalesce(dt_cancelamento::text, '') = '';

if (qt_critica_pendente_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort( 268950, null ); --Existem críticas pendentes para o lote, favor verificar.
else
	open C01;
	loop
	fetch C01 into
		nr_seq_conta_coparticipacao_w,
		ie_status_coparticipacao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		update	pls_conta_coparticipacao
		set	ie_status_mensalidade	= 'L',
			ie_status_coparticipacao = CASE WHEN ie_permite_glosa_w='S' THEN 'S'  ELSE ie_status_coparticipacao_w END ,
			dt_competencia_mens	= dt_competencia_mens_w
		where	nr_sequencia	= nr_seq_conta_coparticipacao_w;
		end;
	end loop;
	close C01;

	CALL pls_gravar_hist_lote_copartic(	nr_seq_lote_p,
					'Liberado o lote pelo usuário',
					nm_usuario_p,
					cd_estabelecimento_p);

	update	pls_lote_coparticipacao
	set	dt_liberacao		= clock_timestamp(),
		nm_usuario_liberacao	= nm_usuario_p,
		ie_status		= 'D'
	where	nr_sequencia		= nr_seq_lote_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_liberar_lote_copartic ( nr_seq_lote_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
