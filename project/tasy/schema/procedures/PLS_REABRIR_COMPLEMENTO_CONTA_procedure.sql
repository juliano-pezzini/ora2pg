-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_reabrir_complemento_conta ( nr_Seq_conta_p bigint, nm_usuario_p text, cd_estabelecimento_p text, nr_Seq_protocolo_gerado_p INOUT bigint, nr_Seq_conta_gerada_p INOUT bigint) AS $body$
DECLARE


nr_Seq_conta_ww			bigint;
nr_Seq_conta_proc_w		bigint;
nr_Seq_conta_mat_w		bigint;
nr_seq_analise_w		bigint;
nr_Seq_protocolo_w		bigint;
nr_Seq_protocolo_gerado_w	bigint;
ie_status_w			varchar(1);
nr_seq_regra_compl_w		bigint;
nr_Seq_guia_w			bigint;
ie_tipo_complemento_w		varchar(2);
cd_guia_referencia_w		varchar(20);
ie_faturado_w			bigint;
nr_seq_lote_pgto_w		bigint;
cd_guia_w			varchar(20);
nr_seq_segurado_w		bigint;
nr_Seq_prestador_w		bigint;
nr_Seq_conta_gerada_w		bigint;
ds_observacao_w			varchar(255);
ie_tipo_guia_w			smallint;
vl_item_w			double precision;
qt_item_w			double precision;
ie_via_acesso_w			varchar(1);
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
dt_procedimento_w		timestamp;
dt_inicio_proc			timestamp;
nr_seq_setor_atend_w		bigint;
nr_Seq_material_w		bigint;
nr_seq_prest_fornec_w		bigint;
dt_atendimento_w		timestamp;
dt_inicio_proc_w		timestamp;
nr_seq_analise_item_w		bigint;
nr_seq_proc_participante_w	bigint;
ie_mensagem_ret_comp_w		varchar(3);
nr_contador_protocolo_w		bigint;
nr_contador_conta_w		bigint;
nr_seq_lote_w			bigint;
ie_situacao_w			pls_protocolo_conta.ie_situacao%type;
ie_reabre_w			varchar(1) := 'N';

C01 CURSOR FOR
	SELECT	vl_procedimento_imp,
		qt_procedimento_imp,
		ie_via_acesso,
		cd_procedimento, --nr_seq_item
		ie_origem_proced,
		dt_procedimento,
		dt_inicio_proc,
		nr_seq_setor_atend,
		nr_sequencia
	from 	pls_conta_proc
	where	nr_seq_conta = nr_Seq_conta_p;

C02 CURSOR FOR
	SELECT	vl_material_imp,
		qt_material_imp,
		nr_seq_material, --nr_Seq_item
		nr_seq_prest_fornec,
		dt_atendimento,
		nr_seq_setor_atend,
		nr_sequencia
	from 	pls_conta_mat
	where	nr_seq_conta = nr_Seq_conta_p;
C03 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_proc_participante
	where	nr_seq_conta_proc = nr_seq_conta_proc_w;

C04 CURSOR(nr_seq_conta_pc	pls_conta.nr_sequencia%type)FOR
	SELECT	nr_sequencia
	from	pls_conta
	where	nr_seq_conta_referencia	= nr_seq_conta_pc;
/*PROCEDURE CHAMADA NO DELPHI NA FUNÇÃO OPS - CONTROLE DE PRODUÇÃO MÉDICA*/

BEGIN

select	max(ie_situacao_protocolo)
into STRICT	ie_situacao_w
from	pls_conta_v
where	nr_sequencia	= nr_seq_conta_p;

if (coalesce(ie_situacao_w,'I') in ('D','T')) then
	ie_reabre_w := pls_obter_regra_bloq(nr_seq_conta_p, 'R', cd_estabelecimento_p);

	if (ie_reabre_w = 'S') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(688155,'NR_SEQ_CONTA=' ||nr_seq_conta_p);
	end if;
end if;

if (coalesce(nr_Seq_conta_p,0)>0) then

	begin
		select 	a.nr_seq_analise,
			a.nr_Seq_protocolo,
			a.ie_status,
			a.cd_guia,
			a.cd_guia_referencia,
			a.nr_seq_segurado,
			b.nr_seq_prestador,
			a.nr_seq_guia,
			b.nr_seq_lote_conta
		into STRICT	nr_seq_analise_w,
			nr_Seq_protocolo_w,
			ie_status_w,
			cd_guia_w,
			cd_guia_referencia_w,
			nr_seq_segurado_w,
			nr_Seq_prestador_w,
			nr_seq_guia_w,
			nr_seq_lote_w
		from 	pls_protocolo_conta 	b,
			pls_conta 	a
		where	a.nr_seq_protocolo	= b.nr_Sequencia
		and	a.nr_Sequencia 		= nr_Seq_conta_p;
	exception
	when others then
		nr_Seq_protocolo_w	:= null;
		cd_guia_referencia_w	:= null;
		cd_guia_w		:= null;
		nr_seq_segurado_w	:= null;
		nr_Seq_prestador_w	:= null;
	end;

	cd_guia_referencia_w	:= coalesce(cd_guia_referencia_w,cd_guia_w);

	if (coalesce(nr_seq_guia_w::text, '') = '') then
		select	max(nr_sequencia),
			max(ie_tipo_guia)
		into STRICT	nr_Seq_guia_w,
			ie_tipo_guia_w
		from 	pls_guia_plano
		where	nr_Seq_segurado = nr_seq_segurado_w
		and	cd_guia		= cd_guia_referencia_w;
	else
		select	max(ie_tipo_guia)
		into STRICT	ie_tipo_guia_w
		from 	pls_guia_plano
		where	nr_sequencia	= nr_seq_guia_w;
	end if;

	/*--------------------------------------------------------------------------------------------------------VERIFICACAO ----------------------------------------------------------------------------------------------------------------*/

	select	count(1)
	into STRICT	ie_faturado_w
	from 	pls_prot_conta_titulo 	a
	where	nr_seq_protocolo   	= nr_Seq_protocolo_w;

	/*SOMENTE VAI REABRIR COMPLEMENTO DESTA GUIA QUANDO  NÃO EXISTIR FATURAMENTO PARA ESTA CONTA*/

	if (ie_faturado_w > 0) then
		/*'Este Protocolo já possui demonstrativo de pagamento. A conta '||nr_Seq_conta_p||' não pode ser reaberta.' */

		CALL wheb_mensagem_pck.exibir_mensagem_abort(180476,'NR_SEQ_CONTA=' ||nr_seq_conta_p);
	end if;

	select 	max(nr_seq_lote_pgto)
	into STRICT	nr_seq_lote_pgto_w
	from 	pls_conta_medica_resumo
	where	nr_Seq_conta = nr_Seq_conta_p
	and	((ie_situacao != 'I') or (coalesce(ie_situacao::text, '') = ''));

	if (coalesce(nr_Seq_lote_pgto_w,0) > 0) then
		/*'Não é possível reabrir o complemento da conta. A conta '||nr_Seq_conta_p||' já está vinculada ao lote de pagamento '||nr_Seq_lote_pgto_w*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(180487,'NR_SEQ_CONTA=' ||nr_seq_conta_p);
	end if;
	--tratamento necessário para cancelar as contas de honorário que haviam sido geradas
	for r_c04_w in C04(nr_seq_conta_p) loop
		begin
		ds_observacao_w := pls_cancelar_conta( 	r_c04_w.nr_sequencia, null, nm_usuario_p, cd_estabelecimento_p, 1, ds_observacao_w, 'S');
		ds_observacao_w := pls_cancelar_conta( 	r_c04_w.nr_sequencia, null, nm_usuario_p, cd_estabelecimento_p, 2, ds_observacao_w, 'S');

		end;
	end loop;

	update	pls_conta_proc a
	set	ie_status	= 'C'
	where	nr_seq_conta	= nr_seq_conta_p
	and	exists (SELECT	1
			from	pls_proc_participante b
			where	a.nr_sequencia			= b.nr_seq_conta_proc
			and	b.ie_gerada_cta_honorario	= 'S');

	update	pls_proc_participante	b
	set	ie_status		= 'U',
		ie_gerada_cta_honorario	 = NULL
	where	ie_gerada_cta_honorario	= 'S'
	and	nr_seq_conta_proc in (	SELECT	nr_sequencia
					from	pls_conta_proc
					where	nr_seq_conta	= nr_seq_conta_p);
	/*--------------------------------------------------------------------------------------------------------VERIFICACAO ----------------------------------------------------------------------------------------------------------------*/

	/*VOLTA ESTAGIO COMPLEMENTO DA CONTA DE ACORDO COM REGRA DE COMPLEMENTO*/

	/*vai gerar um novo protocolo de complemento com a conta gerada, ou vai inserir a conta gerada em um protocolo existente */

	SELECT * FROM pls_gerar_protocolo_compl(nr_seq_prestador_w, nr_seq_guia_w, ie_tipo_guia_w, nr_seq_conta_p, nm_usuario_p, cd_estabelecimento_p, null, nr_seq_conta_gerada_w, nr_seq_protocolo_gerado_w, ie_mensagem_ret_comp_w) INTO STRICT nr_seq_conta_gerada_w, nr_seq_protocolo_gerado_w, ie_mensagem_ret_comp_w;

	nr_Seq_conta_gerada_p		:= nr_Seq_conta_gerada_w;

	/*VAI GARANTIR QUE O STATUS DO ESTAGIO COMPLEMENTO SEJA NECESSITA COMPLEMENTO*/

	if (coalesce( nr_Seq_conta_gerada_w,0) > 0) then

		update	pls_conta
		set	ie_estagio_complemento  = '1',
			ie_origem_conta		= 'C',
			dt_lib_complemento	 = NULL,
			nr_seq_protocolo_origem = nr_Seq_protocolo_w,
			ie_reabertura_compl	= 'S',
			ie_status		= 'U',
			nr_seq_analise		 = NULL
		where 	nr_sequencia 		= nr_Seq_conta_gerada_w;

		update 	pls_conta
		set	dt_lib_complemento 	 = NULL
		where 	nr_Sequencia 		= nr_Seq_conta_p;

		update	pls_conta_proc	a
		set	ie_status	= 'U'
		where	nr_seq_conta	= nr_Seq_conta_gerada_w
		and	exists (SELECT	1
				from	pls_guia_plano_proc b
				where	nr_seq_guia		= nr_seq_guia_w
				and	b.cd_procedimento	= a.cd_procedimento
				and	b.ie_origem_proced	= a.ie_origem_proced)
		and	not exists (select	1
					 from 	pls_proc_participante	c
					 where	c.nr_seq_conta_proc	  = a.nr_sequencia
					 and	c.ie_gerada_cta_honorario = 'S');

		update	pls_conta_mat	a
		set	ie_status	= 'U'
		where	nr_seq_conta	= nr_Seq_conta_gerada_w
		and	exists (SELECT	1
				from	pls_guia_plano_mat b
				where	nr_seq_guia		= nr_seq_guia_w
				and	b.nr_seq_material	= a.nr_seq_material);
	end if;

	nr_Seq_protocolo_gerado_p	:= nr_Seq_protocolo_gerado_w;

	open C01;
	loop
	fetch C01 into
		vl_item_w,
		qt_item_w,
		ie_via_acesso_w,
		cd_procedimento_w, --nr_seq_item
		ie_origem_proced_w,
		dt_procedimento_w,
		dt_inicio_proc_w,
		nr_seq_setor_atend_w,
		nr_seq_conta_proc_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (coalesce(nr_seq_analise_w,0) > 0) then
			delete  FROM pls_analise_parecer_item
			where  nr_seq_item in ( SELECT	x.nr_sequencia
						  from		pls_analise_conta_item	x
						  where		x.nr_seq_conta_proc = nr_seq_conta_proc_w);
			delete  FROM pls_analise_conta_item_log
			where  nr_seq_analise_item in ( SELECT	x.nr_sequencia
						  from		pls_analise_conta_item	x
						  where		x.nr_seq_conta_proc = nr_seq_conta_proc_w);
			delete  FROM pls_analise_conta_item
			where   nr_seq_conta_proc = nr_seq_conta_proc_w;

			open C03;
			loop
			fetch C03 into
				nr_seq_proc_participante_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
				begin
				delete  FROM pls_analise_parecer_item
				where  nr_seq_item in ( SELECT	x.nr_sequencia
							  from		pls_analise_conta_item	x
							  where		x.nr_seq_proc_partic = nr_seq_proc_participante_w);
				delete  FROM pls_analise_conta_item_log
				where  nr_seq_analise_item in ( SELECT	x.nr_sequencia
							  from		pls_analise_conta_item	x
							  where		x.nr_seq_proc_partic = nr_seq_proc_participante_w);
				delete  FROM pls_analise_conta_item
				where   nr_seq_proc_partic = nr_seq_proc_participante_w;
				end;
			end loop;
			close C03;
		end if;
		end;
	end loop;
	close C01;

	open C02;
	loop
	fetch C02 into
		vl_item_w,
		qt_item_w,
		nr_seq_material_w, --nr_Seq_item
		nr_seq_prest_fornec_w,
		dt_atendimento_w,
		nr_seq_setor_atend_w,
		nr_seq_conta_mat_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		if (coalesce(nr_seq_analise_w,0) > 0) then
			delete  FROM pls_analise_parecer_item
			where  nr_seq_item = 1;

			delete  FROM pls_analise_conta_item_log
			where  nr_seq_analise_item in ( SELECT	x.nr_sequencia
						  from		pls_analise_conta_item	x
						  where		x.nr_seq_conta_mat = nr_seq_conta_mat_w);
			delete  FROM pls_analise_conta_item
			where   nr_seq_conta_mat = nr_seq_conta_mat_w;
		end if;
		end;
	end loop;
	close C02;

	/* Aqui trata para glosar a conta e seus itens, trata a valorização, atualiza os valores do protocolo , fecha a conta */

	if (coalesce(nr_seq_conta_p,0) <> coalesce(nr_Seq_conta_gerada_w,0))	then
		if ( coalesce(nr_seq_conta_p,0) > 0) then
			CALL pls_glosar_item_conta( nr_seq_conta_p, 0, 0,
						nm_usuario_p, cd_estabelecimento_p );
		end if;

	end if;

	/*CANCELA A ANALISE DA CONTA QUE ESTÁ SENDO REABERTA  O COMPLEMENTO DA GUIA*/

	if (coalesce( nr_seq_analise_w ,0) > 0) then

		update	pls_analise_conta
		set	ie_status 	= 'C'/* Atualizar Análise com Status cancelado , ao inves de deixar com status ecerrado. OS 372914 - askono*/
		where	nr_sequencia 	= nr_seq_analise_w;

		ds_observacao_w	:= 'Análise cancelada através da opção "Reabrir complemento da conta" na função OPS-Controle de Produção Médica. ';
		CALL pls_inserir_hist_analise(	nr_Seq_conta_p, nr_seq_analise_w, 31,
					null, null, null,
					null, ds_observacao_w, null,
					nm_usuario_p, cd_estabelecimento_p );
	end if;

	-- "Converte"
	update	pls_conta
	set	ie_tipo_faturamento	= pls_obter_tipo_fat_tiss(ie_tipo_faturamento)
	where	nr_sequencia		= nr_seq_conta_p;
end if;

commit;
-- Verifica se a conta é a única do protocolo
select 	count(1)
into STRICT 	nr_contador_conta_w
from 	pls_conta
where 	nr_seq_protocolo = nr_Seq_protocolo_w;

select max(ie_situacao)
into STRICT	ie_situacao_w
from	pls_protocolo_conta
where	nr_sequencia = nr_Seq_protocolo_w;

if (nr_contador_conta_w = 0)  and (ie_situacao_w <> 'I') then
	--Se a conta reaberta for a única, cancela o protocolo
	CALL pls_cancelar_protocolo(	nr_Seq_protocolo_w,'S',cd_estabelecimento_p,
				nm_usuario_p,'Reaberto complemento de conta');

	--Verifica se o cancelado é o único do lote
	select 	count(1)
	into STRICT 	nr_contador_protocolo_w
	from 	pls_protocolo_conta
	where 	nr_sequencia <> nr_Seq_protocolo_w
	and 	nr_seq_lote_conta = nr_seq_lote_w;


	if (nr_contador_protocolo_w = 0) then
	--Se o protocolo cancelado for o único, cancela o lote.
		CALL pls_rejeitar_protocolo(	nr_seq_lote_w,null,'Reaberto complemento de conta',
					cd_estabelecimento_p,nm_usuario_p);
	end if;
end if;

commit;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_reabrir_complemento_conta ( nr_Seq_conta_p bigint, nm_usuario_p text, cd_estabelecimento_p text, nr_Seq_protocolo_gerado_p INOUT bigint, nr_Seq_conta_gerada_p INOUT bigint) FROM PUBLIC;

