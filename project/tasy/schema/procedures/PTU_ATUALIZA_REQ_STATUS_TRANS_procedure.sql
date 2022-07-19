-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_atualiza_req_status_trans ( nr_seq_pedido_p bigint, nr_seq_requisicao_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_autorizado_w			smallint;
ie_estagio_requisicao_w		smallint;
ie_tipo_tabela_w		varchar(3);
qt_analise_proc_w		bigint;
qt_analise_mat_w		bigint;
qt_anali_proc_nega_w		bigint;
qt_anali_proc_apro_w		bigint;
qt_anali_proc_canc_w		bigint;
qt_anali_mat_nega_w		bigint;
qt_anali_mat_apro_w		bigint;
qt_anali_mat_canc_w		bigint;
ie_resultado_w			bigint;
qt_analise_negada_w		bigint;
qt_analise_aprovada_w		bigint;
qt_analise_cancelada_w		bigint;
nr_seq_req_mat_w		bigint;
nr_seq_req_proc_w		bigint;
dt_validade_w			timestamp;
nr_seq_origem_w			bigint;
qt_autorizado_w			ptu_resp_servico_status.qt_autorizado%type;
qt_autorizado_ww		ptu_resp_servico_status.qt_autorizado%type;
qt_registros_aud_w		integer;
ie_origem_solic_w		pls_requisicao.ie_origem_solic%type;
nr_seq_guia_w			pls_guia_plano.nr_sequencia%type;
nr_seq_mat_w			pls_requisicao_mat.nr_seq_material%type;
cd_procedimento_w		procedimento.cd_procedimento%type;
ie_origem_proc_w		procedimento.ie_origem_proced%type;
nr_seq_guia_proc_w		pls_guia_plano_proc.nr_sequencia%type;
nr_seq_guia_mat_w		pls_guia_plano_mat.nr_sequencia%type;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
ie_tipo_intercambio_w		pls_requisicao.ie_tipo_intercambio%type;
cd_senha_w			pls_guia_plano.cd_senha%type;
dt_validade_req_w		pls_guia_plano.dt_validade_senha%type;
ie_estagio_w			pls_requisicao.ie_estagio%type;
cd_senha_externa_w		pls_guia_plano.cd_senha_externa%type;
dt_validade_senha_w		pls_guia_plano.dt_validade_senha%type;
nr_seq_segurado_w		pls_requisicao.nr_seq_segurado%type;
dt_requisicao_w			pls_requisicao.dt_requisicao%type;
ie_tipo_guia_w			pls_requisicao.ie_tipo_guia%type;

C01 CURSOR FOR
	SELECT	nr_seq_req_mat,
		nr_seq_req_proc,
		ie_autorizado,
		ie_tipo_tabela,
		qt_autorizado
	from	ptu_resp_servico_status
	where	ie_autorizado in (1,2,3,4,5)
	and	nr_seq_resp_ped_status	= nr_seq_pedido_p;


BEGIN

cd_estabelecimento_w := ptu_obter_estab_padrao;

select	coalesce(ie_estagio, 0),
	coalesce(ie_origem_solic, 'M'),
	ie_tipo_intercambio
into STRICT	ie_estagio_requisicao_w,
	ie_origem_solic_w,
	ie_tipo_intercambio_w
from	pls_requisicao
where	nr_sequencia	= nr_seq_requisicao_p;

if (ie_origem_solic_w = 'E') then
	select	max(a.nr_seq_guia)
	into STRICT	nr_seq_guia_w
	from	pls_requisicao c,
		pls_execucao_requisicao a
	where	a.nr_seq_requisicao	= c.nr_sequencia
	and	c.nr_sequencia		= nr_seq_requisicao_p;
end if;

begin
	select	dt_validade,
		nr_seq_origem
	into STRICT	dt_validade_w,
		nr_seq_origem_w
	from	ptu_resp_pedido_status
	where	nr_sequencia	= nr_seq_pedido_p;
exception
when others then
	dt_validade_w	:= null;
	nr_seq_origem_w	:= null;
end;

/* Atualiza apenas se o estagio da requisicao e igual a 'AUDITORIA INTERCAMBIO' */

if (ie_estagio_requisicao_w = 5) then
	open C01;
	loop
	fetch C01 into
		nr_seq_req_mat_w,
		nr_seq_req_proc_w,
		ie_autorizado_w,
		ie_tipo_tabela_w,
		qt_autorizado_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		qt_autorizado_ww   :=   substr(to_char(qt_autorizado_w),1,4);

		/* Atualiza o estagio dos procedimentos e materiais apenas se os status forem igual a 1 (Negado), 2 (Autorizado) o 3 (Pendente para autorizacao da empresa), 4 (Pendente para auditoria), 5 (Cancelado)*/

		if (ie_autorizado_w in (1,2,3,4,5)) then
			if (ie_tipo_tabela_w in ('0', '1', '4')) and (nr_seq_req_proc_w IS NOT NULL AND nr_seq_req_proc_w::text <> '') then

				update	pls_requisicao_proc
				set	ie_status	= CASE WHEN ie_autorizado_w=1 THEN 'N' WHEN ie_autorizado_w=2 THEN 'S' WHEN ie_autorizado_w=3 THEN 'A' WHEN ie_autorizado_w=4 THEN 'A' WHEN ie_autorizado_w=5 THEN 'C' END ,
					qt_procedimento	= CASE WHEN ie_autorizado_w=2 THEN qt_autorizado_ww  ELSE 0 END
				where	nr_sequencia	= nr_seq_req_proc_w;

				if (ie_origem_solic_w = 'E') and (ie_autorizado_w in (1,2)) and (nr_seq_guia_w IS NOT NULL AND nr_seq_guia_w::text <> '') then
					update	pls_requisicao_proc
					set	qt_proc_executado	= CASE WHEN ie_autorizado_w=2 THEN qt_autorizado_ww  ELSE 0 END
					where	nr_sequencia		= nr_seq_req_proc_w;
					
					select	cd_procedimento,
						ie_origem_proced
					into STRICT	cd_procedimento_w,
						ie_origem_proc_w
					from	pls_requisicao_proc
					where	nr_sequencia		= nr_seq_req_proc_w;

					update	pls_itens_lote_execucao
					set	qt_item_exec = CASE WHEN ie_autorizado_w=2 THEN qt_autorizado_ww  ELSE 0 END ,
						qt_aprovado = CASE WHEN ie_autorizado_w=2 THEN qt_autorizado_ww  ELSE 0 END ,
						qt_executado = CASE WHEN ie_autorizado_w=2 THEN qt_autorizado_ww  ELSE 0 END
					where	nr_seq_req_proc = nr_seq_req_proc_w;

					update	pls_execucao_req_item
					set	qt_item = CASE WHEN ie_autorizado_w=2 THEN qt_autorizado_ww  ELSE 0 END
					where	nr_seq_req_proc = nr_seq_req_proc_w;

					select	max(nr_sequencia)
					into STRICT	nr_seq_guia_proc_w
					from	pls_guia_plano_proc
					where	cd_procedimento		= cd_procedimento_w
					and	ie_origem_proced	= ie_origem_proc_w
					and	ie_status		in ('I', 'A')
					and	nr_seq_guia		= nr_seq_guia_w;

					update	pls_guia_plano_proc
					set	ie_status		= CASE WHEN ie_autorizado_w=1 THEN 'N' WHEN ie_autorizado_w=2 THEN 'S' WHEN ie_autorizado_w=3 THEN 'A' WHEN ie_autorizado_w=4 THEN 'A' WHEN ie_autorizado_w=5 THEN 'C' END ,
						qt_autorizada		= CASE WHEN ie_autorizado_w=2 THEN qt_autorizado_ww  ELSE 0 END
					where	nr_sequencia		= nr_seq_guia_proc_w;
				end if;
			elsif (ie_tipo_tabela_w in ('2', '3')) and (nr_seq_req_mat_w IS NOT NULL AND nr_seq_req_mat_w::text <> '') then

				update	pls_requisicao_mat
				set	ie_status	= CASE WHEN ie_autorizado_w=1 THEN 'N' WHEN ie_autorizado_w=2 THEN 'S' WHEN ie_autorizado_w=3 THEN 'A' WHEN ie_autorizado_w=4 THEN 'A' WHEN ie_autorizado_w=5 THEN 'C' END ,
					qt_material	= CASE WHEN ie_autorizado_w=2 THEN qt_autorizado_ww  ELSE 0 END
				where	nr_sequencia	= nr_seq_req_mat_w;

				if (ie_origem_solic_w = 'E') and (ie_autorizado_w in (1,2)) and (nr_seq_guia_w IS NOT NULL AND nr_seq_guia_w::text <> '') then
					update	pls_requisicao_mat
					set	qt_mat_executado	= CASE WHEN ie_autorizado_w=2 THEN qt_autorizado_ww  ELSE 0 END
					where	nr_sequencia		= nr_seq_req_mat_w;
				
					select	nr_seq_material
					into STRICT	nr_seq_mat_w
					from	pls_requisicao_mat
					where	nr_sequencia		= nr_seq_req_mat_w;

					update	pls_itens_lote_execucao
					set	qt_item_exec = CASE WHEN ie_autorizado_w=2 THEN qt_autorizado_ww  ELSE 0 END ,
						qt_aprovado = CASE WHEN ie_autorizado_w=2 THEN qt_autorizado_ww  ELSE 0 END ,
						qt_executado = CASE WHEN ie_autorizado_w=2 THEN qt_autorizado_ww  ELSE 0 END
					where	nr_seq_req_mat = nr_seq_req_mat_w;

					update	pls_execucao_req_item
					set	qt_item = CASE WHEN ie_autorizado_w=2 THEN qt_autorizado_ww  ELSE 0 END
					where	nr_seq_req_mat = nr_seq_req_mat_w;

					select	max(nr_sequencia)
					into STRICT	nr_seq_guia_mat_w
					from	pls_guia_plano_mat
					where	nr_seq_material		= nr_seq_mat_w
					and	ie_status		in ('I', 'A')
					and	nr_seq_guia		= nr_seq_guia_w;

					update	pls_guia_plano_mat
					set	ie_status		= CASE WHEN ie_autorizado_w=1 THEN 'N' WHEN ie_autorizado_w=2 THEN 'S' WHEN ie_autorizado_w=3 THEN 'A' WHEN ie_autorizado_w=4 THEN 'A' WHEN ie_autorizado_w=5 THEN 'C' END ,
						qt_autorizada		= CASE WHEN ie_autorizado_w=2 THEN qt_autorizado_ww  ELSE 0 END
					where	nr_sequencia		= nr_seq_guia_mat_w;
				end if;
			end if;
		end if;
		end;
	end loop;
	close C01;

	select	count(1)
	into STRICT	qt_analise_proc_w
	from	pls_requisicao_proc
	where	ie_status		= 'A'
	and	nr_seq_requisicao	= nr_seq_requisicao_p;

	select	count(1)
	into STRICT	qt_analise_mat_w
	from	pls_requisicao_mat
	where	ie_status		= 'A'
	and	nr_seq_requisicao	= nr_seq_requisicao_p;

	if	(qt_analise_proc_w = 0 AND qt_analise_mat_w = 0) then
		/* Quantidade de procedimentos 'Negados' */

		select	count(1)
		into STRICT	qt_anali_proc_nega_w
		from	pls_requisicao_proc
		where	ie_status		= 'N'
		and	nr_seq_requisicao	= nr_seq_requisicao_p;

		/* Quantidade de procedimentos 'Aprovados' */

		select	count(1)
		into STRICT	qt_anali_proc_apro_w
		from	pls_requisicao_proc
		where	ie_status		= 'S'
		and	nr_seq_requisicao	= nr_seq_requisicao_p;

		/* Quantidade de procedimentos 'Cancelados' */

		select	count(1)
		into STRICT	qt_anali_proc_canc_w
		from	pls_requisicao_proc
		where	ie_status		= 'C'
		and	nr_seq_requisicao	= nr_seq_requisicao_p;

		/* Quantidade de materiais 'Negados' */

		select	count(1)
		into STRICT	qt_anali_mat_nega_w
		from	pls_requisicao_mat
		where	ie_status		= 'N'
		and	nr_seq_requisicao	= nr_seq_requisicao_p;

		/* Quantidade de materiais 'Aprovados' */

		select	count(1)
		into STRICT	qt_anali_mat_apro_w
		from	pls_requisicao_mat
		where	ie_status		= 'S'
		and	nr_seq_requisicao	= nr_seq_requisicao_p;

		/* Quantidade de materiais 'Cancelados' */

		select	count(1)
		into STRICT	qt_anali_mat_canc_w
		from	pls_requisicao_mat
		where	ie_status		= 'C'
		and	nr_seq_requisicao	= nr_seq_requisicao_p;

		qt_analise_negada_w	:= qt_anali_proc_nega_w + qt_anali_mat_nega_w;
		qt_analise_aprovada_w	:= qt_anali_proc_apro_w + qt_anali_mat_apro_w;
		qt_analise_cancelada_w	:= qt_anali_proc_canc_w + qt_anali_mat_canc_w;

		if	((qt_analise_cancelada_w > 0) and (qt_analise_negada_w = 0) and (qt_analise_aprovada_w = 0)) then
			ie_resultado_w	:= 3; -- Cancelada
		elsif	(qt_analise_aprovada_w > 0 AND qt_analise_negada_w = 0) then
			ie_resultado_w	:= 2; -- Aprovada
		elsif	(qt_analise_negada_w > 0 AND qt_analise_aprovada_w = 0) then
			ie_resultado_w	:= 7; -- Reprovada
		elsif	(qt_analise_negada_w > 0 AND qt_analise_aprovada_w > 0) then
			ie_resultado_w	:= 6; -- Parcialmente aprovada
		end if;

		if (ie_resultado_w IS NOT NULL AND ie_resultado_w::text <> '') then

			if (ie_estagio_w in (6,2)) then
				select	nr_seq_segurado,
					dt_requisicao,
					ie_tipo_guia
				into STRICT 	nr_seq_segurado_w,
					dt_requisicao_w,
					ie_tipo_guia_w
				from 	pls_requisicao
				where 	nr_sequencia = nr_seq_requisicao_p;

				CALL pls_gerar_validade_senha_req(nr_seq_requisicao_p, nr_seq_segurado_w, dt_requisicao_w, ie_tipo_guia_w, nm_usuario_p);
			end if;

			update	pls_requisicao
			set	ie_estagio		= ie_resultado_w,
				dt_fim_processo_req	= clock_timestamp(),
				dt_valid_senha_ext	= CASE WHEN ie_resultado_w=3 THEN null WHEN ie_resultado_w=7 THEN null  ELSE dt_validade_w END ,
				dt_validade_senha	= CASE WHEN ie_resultado_w=3 THEN null WHEN ie_resultado_w=7 THEN null  ELSE dt_validade_w END ,
				cd_senha_externa	= CASE WHEN ie_resultado_w=3 THEN null WHEN ie_resultado_w=7 THEN null  ELSE nr_seq_origem_w END
			where	nr_sequencia		= nr_seq_requisicao_p;

			select	coalesce(ie_origem_solic, 'M'),
				ie_estagio,
				dt_valid_senha_ext,
				cd_senha_externa,
				cd_senha,
				dt_validade_senha
			into STRICT	ie_origem_solic_w,
				ie_estagio_w,
				dt_validade_senha_w,
				cd_senha_externa_w,
				cd_senha_w,
				dt_validade_req_w
			from	pls_requisicao
			where	nr_sequencia	= nr_seq_requisicao_p;

			if (ie_origem_solic_w = 'E') then
				update	pls_guia_plano
				set	ie_estagio		= CASE WHEN ie_estagio_w=2 THEN  6 WHEN ie_estagio_w=6 THEN  10 WHEN ie_estagio_w=7 THEN  4  ELSE ie_estagio END ,
					ie_status		= CASE WHEN ie_estagio_w=2 THEN  1 WHEN ie_estagio_w=6 THEN  1 WHEN ie_estagio_w=7 THEN  3  ELSE ie_status END ,
					dt_autorizacao		= CASE WHEN ie_estagio_w=2 THEN  clock_timestamp() WHEN ie_estagio_w=6 THEN  clock_timestamp()  ELSE null END ,
					dt_valid_senha_ext	= coalesce(dt_validade_senha_w, dt_valid_senha_ext),
					cd_senha_externa	= coalesce(cd_senha_externa_w,cd_senha_externa),
					dt_validade_senha	= dt_validade_req_w,
					cd_senha		= cd_senha_w,
					nm_usuario_liberacao	= nm_usuario_p
				where	nr_sequencia		= nr_seq_guia_w;
			end if;

			select	count(1)
			into STRICT	qt_registros_aud_w
			from	pls_auditoria
			where	nr_seq_requisicao	= nr_seq_requisicao_p
			and	coalesce(dt_liberacao::text, '') = '';

			if (qt_registros_aud_w > 0) then
				update	pls_auditoria
				set	ie_status		= CASE WHEN ie_resultado_w=8 THEN 'C'  ELSE 'F' END ,
					dt_liberacao		= clock_timestamp(),
					nr_seq_proc_interno	 = NULL,
					dt_atualizacao		= clock_timestamp(),
					nm_usuario		= nm_usuario_p
				where	nr_seq_requisicao	= nr_seq_requisicao_p;

				CALL pls_requisicao_gravar_hist(	nr_seq_requisicao_p,'L',obter_expressao_idioma(1077847),
								null,nm_usuario_p);

				update	pls_auditoria_grupo
				set	dt_liberacao		= clock_timestamp(),
					ie_status		= 'S',
					nm_usuario		= nm_usuario_p,
					dt_atualizacao		= clock_timestamp()
				where	coalesce(dt_liberacao::text, '') = ''
				and	exists (	SELECT	1
						from 	pls_auditoria x
						where 	x.nr_seq_requisicao	= nr_seq_requisicao_p
						and 	x.nr_sequencia 		= nr_seq_auditoria);
			end if;

			if (ie_resultado_w in (2,6)) and (ie_tipo_intercambio_w = 'E') then
				CALL pls_executar_req_interc_aprov(nr_seq_requisicao_p, cd_estabelecimento_w, nm_usuario_p);
			end if;

		end if;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_atualiza_req_status_trans ( nr_seq_pedido_p bigint, nr_seq_requisicao_p bigint, nm_usuario_p text) FROM PUBLIC;

