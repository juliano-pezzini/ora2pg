-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_fechar_conta_sem_aud (nr_seq_analise_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_recurso_p text default 'N', ds_retorno_p INOUT text DEFAULT NULL) AS $body$
DECLARE


nr_seq_conta_w		bigint;
ie_auditoria_w		varchar(1);
ds_retorno_w		varchar(4000);
ie_consistir_penden_w	varchar(1);
ie_origem_analise_w	smallint;
nr_seq_fatura_w		bigint;
nr_seq_conta_mat_w	bigint;
nr_seq_conta_proc_w	bigint;
nr_seq_partic_proc_w	bigint;
ie_status_ww		varchar(2);
nr_seq_item_analise_w	bigint;
vl_total_w		double precision;
vl_pag_medico_conta_w	double precision;
vl_calculado_w		double precision;
qt_item_pos_estab_w	bigint;
ie_geracao_pos_estabelecido_w	varchar(1);
ie_pos_estab_w		varchar(1);
ie_status_w		pls_analise_conta.ie_status%type;
ie_libera_prot_w	varchar(5);
ie_novo_pos_estab_w	pls_visible_false.ie_novo_pos_estab%type;

/*Cursor que obtem as contas da análise para ser realizado o fechamento*/

C01 CURSOR FOR
	SELECT	b.nr_sequencia
	from	pls_analise_conta a,
		pls_conta b
	where	a.nr_sequencia		= nr_seq_analise_p
	and	a.ie_status		in ('L','S')
	and	b.nr_seq_analise	= a.nr_sequencia
	and	ie_pos_estab_w		= 'N'
	
union all

	SELECT	b.nr_sequencia
	from	pls_analise_conta a,
		pls_conta b
	where	a.nr_sequencia		= nr_seq_analise_p
	and	b.nr_seq_analise	= a.nr_sequencia
	and	ie_pos_estab_w		= 'S';

C02 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.ie_status,
		a.vl_total,
		a.nr_seq_conta_proc,
		a.nr_seq_Conta_mat,
		a.nr_seq_partic_proc
	from	w_pls_resumo_conta a
	where	a.nr_seq_analise  = nr_seq_analise_p
	and	a.nr_seq_conta 	  = nr_seq_conta_w
	and	a.ie_status 	 <> 'I';

C04 CURSOR FOR
	SELECT	x.nr_seq_analise
	from	pls_conta a,
		pls_conta_pos_estabelecido x
	where	x.nr_seq_conta		= a.nr_sequencia
	and	a.nr_seq_analise 	= nr_seq_analise_p
	and	(x.nr_seq_analise IS NOT NULL AND x.nr_seq_analise::text <> '')
	and	((x.ie_situacao	= 'A') or (coalesce(x.ie_situacao::text, '') = ''))
	group by x.nr_seq_analise
	order by 1;

-- Atualmente, é gerado uma análise para cada conta, logo, não é possível duas contas estarem na mesma análise
-- criado o cursor para quando for alterado esse processo, e permita mais de uma conta para cada análise
-- não gerar problemas.
C05 CURSOR(nr_seq_analise_pc		pls_analise_conta.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia nr_seq_conta_rec
	from	pls_rec_glosa_conta a
	where	a.nr_seq_analise = nr_seq_analise_pc;
BEGIN

select	coalesce(max(ie_novo_pos_estab),'N')
into STRICT	ie_novo_pos_estab_w
from	pls_visible_false;

begin
select	CASE WHEN ie_atende_glosado='S' THEN 'N'  ELSE 'S' END ,
	coalesce(ie_origem_analise,1)
into STRICT	ie_consistir_penden_w,
	ie_origem_analise_w
from	pls_analise_conta
where	nr_sequencia = nr_seq_analise_p;
exception
when others then
	ie_consistir_penden_w 	:= 'S';
	ie_origem_analise_w	:= 1;
end;

select	coalesce(max(a.ie_geracao_pos_estabelecido),'F')
into STRICT	ie_geracao_pos_estabelecido_w
from	pls_parametros	a
where	a.cd_estabelecimento	= cd_estabelecimento_p;

if (ie_origem_analise_w in (1,3))	then
	select	pls_obter_se_analise_aud(a.nr_sequencia)
	into STRICT	ie_auditoria_w
	from	pls_analise_conta	a
	where	nr_sequencia	= nr_seq_analise_p;

	ie_pos_estab_w	:= 'N';

	if (ie_auditoria_w	= 'N') then

		for r_c01_w in c01 loop

			if (ie_novo_pos_estab_w = 'N') then
					CALL pls_lancar_item_proc_pos( r_c01_w.nr_sequencia, nm_usuario_p);
				else
					CALL pls_conversao_itens_pck.conversao_itens_pos(	null,  null, null,
											null, null, r_c01_w.nr_sequencia,
											nm_usuario_p, cd_estabelecimento_p);

					CALL pls_conversao_itens_pck.abrir_proc_pacote_cta(	null,  null, null,
											null, null, r_c01_w.nr_sequencia,
											nm_usuario_p, cd_estabelecimento_p);

				end if;

		end loop;

		open C01;
		loop
		fetch C01 into
			nr_seq_conta_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin

			begin
				open C02;
				loop
				fetch C02 into
					nr_seq_item_analise_w,
					ie_status_ww,
					vl_total_w,
					nr_seq_conta_proc_w,
					nr_seq_conta_mat_w,
					nr_seq_partic_proc_w;
				EXIT WHEN NOT FOUND; /* apply on C02 */
					begin

					if (ie_status_ww = 'C') then
						ie_status_ww :=  'D';
					end if;

					if (ie_status_ww = 'P') then
						ie_status_ww := 'L';
						/*Diego OS 429962
						Para poder fechar as contas. De outro modo ao fechar a conta existindo glosas e ocorrências pendentes o sistema não liberava o item impedindo a conta de ser fechada.*/
					end if;

					/*Se existe origem de procedimento é procedimento*/

					if (coalesce(nr_seq_conta_proc_w,0) > 0) then
						select	vl_medico_original,
							vl_procedimento
						into STRICT	vl_pag_medico_conta_w,
							vl_calculado_w
						from	pls_conta_proc
						where 	nr_sequencia = nr_seq_conta_proc_w;

						vl_pag_medico_conta_w := dividir((vl_pag_medico_conta_w*vl_total_w),vl_calculado_w);
						commit;
						update	pls_conta_proc
						set	ie_status	= ie_status_ww,
							vl_liberado	= vl_total_w,
							vl_prestador	= vl_total_w,
							vl_pag_medico_conta 	= vl_pag_medico_conta_w
						where	nr_sequencia 	= nr_seq_conta_proc_w;
					elsif (coalesce(nr_seq_conta_mat_w,0) > 0) then
						update	pls_conta_mat
						set	ie_status	= ie_status_ww,
							vl_liberado	= vl_total_w
						where	nr_sequencia 	= nr_seq_conta_mat_w;
					elsif (coalesce(nr_seq_partic_proc_w,0) > 0) then
						update	pls_proc_participante
						set	ie_status	= ie_status_ww,
							vl_participante	= vl_total_w
						where	nr_sequencia 	= nr_seq_partic_proc_w;
					end if;

					end;
				end loop;
				close C02;

				CALL pls_fechar_conta(nr_seq_conta_w, 'S', null,
							 'N', cd_estabelecimento_p, nm_usuario_p, null, null);
			exception
			when others then
				ds_retorno_w := substr(ds_retorno_w||'Conta :'||nr_seq_conta_w||chr(13)||chr(10)||replace(replace(sqlerrm,'#@#@',''),'ORA-20011: ','')||chr(13)||chr(10),1,255);
			end;

			end;
		end loop;
		close C01;
	else
		begin
			CALL pls_fechar_conta_analise('N', nr_seq_analise_p, null,
						ie_consistir_penden_w, cd_estabelecimento_p, nm_usuario_p);
		exception
		when others then
			ds_retorno_w := substr(ds_retorno_w||'Conta :'||nr_seq_conta_w||chr(13)||chr(10)||replace(replace(sqlerrm,'#@#@',''),'ORA-20011: ','')||chr(13)||chr(10),1,255);
		end;
	end if;

	ie_pos_estab_w	:= 'S';

	for r_c01_w in C01() loop
		begin

		if (ie_novo_pos_estab_w = 'S') then

			select	sum(qt_pos)
			into STRICT	qt_item_pos_estab_w
			from (
				SELECT	count(1) qt_pos
				from	pls_conta_pos_proc
				where	nr_seq_conta = r_c01_w.nr_sequencia
				
union all

				SELECT	count(1) qt_pos
				from	pls_conta_pos_mat
				where	nr_seq_conta = r_c01_w.nr_sequencia) alias5;
		else
			select	count(1)
			into STRICT	qt_item_pos_estab_w
			from	pls_conta_pos_estabelecido a
			where	a.nr_seq_conta	= r_c01_w.nr_sequencia
			and	((a.nr_seq_conta_proc IS NOT NULL AND a.nr_seq_conta_proc::text <> '') or (a.nr_seq_conta_mat IS NOT NULL AND a.nr_seq_conta_mat::text <> ''))
			and	((ie_situacao	= 'A') or (coalesce(ie_situacao::text, '') = ''));
		end if;

		if (qt_item_pos_estab_w > 0) and (ie_geracao_pos_estabelecido_w = 'F') then
			CALL pls_gerar_analise_pos_estab(r_c01_w.nr_sequencia, nm_usuario_p, cd_estabelecimento_p,'F');
		end if;

		end;
	end loop;
elsif (ie_origem_analise_w in (2,7,8))	then -- tratamento realizado para as analises de  pós  - estabelecido Demitrius OS - 393448
	begin
	CALL pls_fechar_conta_pos_estab(nr_seq_analise_p , nm_usuario_p, cd_estabelecimento_p,'N');
	exception
	when others then
		ds_retorno_w	:= substr(ds_retorno_w||'Conta :'||nr_seq_conta_w||chr(13)||chr(10)||replace(replace(sqlerrm,'#@#@',''),'ORA-20011: ','')||chr(13)||chr(10),1,255);
	end;
end if;
commit;
for r_c04_w in C04() loop
	begin
	CALL pls_consistir_analise_pos(r_c04_w.nr_seq_analise, null, cd_estabelecimento_p, nm_usuario_p, 'N', 'N', 'N');
	end;
end loop;
commit;
/*deve gerar análise de pós quando da não existência de auditores na análise principal*/

CALL pls_gerar_auditoria_pos(nr_seq_analise_p, null, 'N', cd_estabelecimento_p, nm_usuario_p);

CALL pls_atualizar_grupo_penden(nr_seq_analise_p, cd_estabelecimento_p, nm_usuario_p);

select	max(nr_seq_fatura)
into STRICT	nr_seq_fatura_w
from	pls_conta
where	nr_sequencia	= nr_seq_conta_w;

/* Atualizar valores PTU Fatura*/

CALL pls_atualizar_valor_ptu_fatura(nr_seq_fatura_w,'N');

if (ie_recurso_p = 'S') then
	ie_libera_prot_w := obter_param_usuario(1349, 2, null, nm_usuario_p, cd_estabelecimento_p, ie_libera_prot_w);

	CALL pls_alterar_status_analise_cta(nr_seq_analise_p, 'T', 'PLS_FINALIZAR_ANALISE_RECURSO', nm_usuario_p, cd_estabelecimento_p);

	select	ie_status
	into STRICT	ie_status_w
	from	pls_analise_conta
	where	nr_sequencia = nr_seq_analise_p;

	if (ie_status_w = 'T') then
		for r_C05_w in C05(nr_seq_analise_p) loop
			CALL pls_fechar_rec_glosa_conta(r_C05_w.nr_seq_conta_rec, null, nm_usuario_p, cd_estabelecimento_p, ie_libera_prot_w);
		end loop;
	end if;
end if;

if (ie_origem_analise_w = 5) then
	CALL pls_alterar_status_analise_cta(nr_seq_analise_p, 'T', 'PLS_FINALIZAR_ANALISE_RECURSO', nm_usuario_p, cd_estabelecimento_p);
end if;

ds_retorno_p := substr(ds_retorno_w,1,255);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_fechar_conta_sem_aud (nr_seq_analise_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_recurso_p text default 'N', ds_retorno_p INOUT text DEFAULT NULL) FROM PUBLIC;

