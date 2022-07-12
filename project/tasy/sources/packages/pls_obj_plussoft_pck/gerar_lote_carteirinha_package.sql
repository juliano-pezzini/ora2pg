-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_obj_plussoft_pck.gerar_lote_carteirinha ( nr_contrato_p pls_lote_carteira.nr_contrato%type, cd_pessoa_usuario_p pessoa_fisica.cd_pessoa_fisica%type, nr_seq_lote_carteira_p INOUT pls_lote_carteira.nr_sequencia%type, nm_usuario_p INOUT usuario.nm_usuario%type, ie_status_p INOUT text, ie_resultado_p INOUT bigint, ds_mensagem_erro_p INOUT text) AS $body$
DECLARE


/*
ie_resultado_p
0 - OK
1 - Erro
*/
nr_seq_lote_w			pls_lote_carteira.nr_sequencia%type;
nr_seq_carteira_w		pls_segurado_carteira.nr_sequencia%type;
current_setting('pls_obj_plussoft_pck.cd_estabelecimento_w')::smallint		pls_contrato.cd_estabelecimento%type;
ie_situacao_w			varchar(1);
ie_controle_carteira_w		varchar(1);
qt_cart_provisorias_w		bigint;
ie_tipo_segurado_w		varchar(10);
nr_seq_tipo_lote_w		bigint;
ie_agrupar_lote_w		varchar(10);
nr_seq_segurado_w		bigint;
current_setting('pls_obj_plussoft_pck.nr_seq_contrato_w')::bigint		bigint;
nr_contrato_w			bigint;
ie_usuario_solic_w		varchar(10);
ie_restringir_tipo_benef_w	varchar(10);
ie_tipo_contrato_w		varchar(10);
ie_emissao_cart_repasse_pre_w	varchar(1);
ie_gerar_emissao_w		varchar(1);
ie_tipo_repasse_w		varchar(1);
nr_seq_cart_emis_w		bigint;
nr_seq_lote_carteira_w		bigint;
current_setting('pls_obj_plussoft_pck.nm_usuario_w')::usuario.nm_usuario%type			usuario.nm_usuario%type;
ie_qt_registro_C01_w		integer;
nm_usuario_solic_w 		pls_segurado_carteira.nm_usuario_solicitante%type;
dt_solicitacao_w			pls_segurado_carteira.dt_solicitacao%type;

current_setting('pls_obj_plussoft_pck.c01')::CURSOR CURSOR FOR  -- Carteiras com status "Provisorio"
	SELECT	a.nr_sequencia,
		a.cd_estabelecimento
	FROM pls_contrato b, pls_segurado a
LEFT OUTER JOIN pls_segurado_carteira c ON (a.nr_sequencia = c.nr_seq_segurado)
WHERE a.nr_seq_contrato = b.nr_sequencia  and c.ie_situacao <> 'D' and b.nr_contrato = nr_contrato_p and coalesce(a.dt_rescisao::text, '') = '' order by 1 desc;

current_setting('pls_obj_plussoft_pck.c02')::CURSOR CURSOR FOR
	SELECT	nr_sequencia
	from	pls_lote_carteira
	where	ie_situacao	in ('P','G')
	and	ie_tipo_lote	= 'E'
	and	((ie_restringir_tipo_benef_w	= 'S')
		and	(((ie_tipo_beneficiario IS NOT NULL AND ie_tipo_beneficiario::text <> '') and ie_tipo_beneficiario = ie_tipo_segurado_w) or
			(((ie_tipo_beneficiario IS NOT NULL AND ie_tipo_beneficiario::text <> '') and ie_tipo_beneficiario = 'R' and ie_tipo_segurado_w = 'R') or (coalesce(ie_tipo_beneficiario::text, '') = '')))
			and	((ie_tipo_contrato <> 'I')
			or (coalesce(ie_tipo_contrato::text, '') = '')) or (ie_restringir_tipo_benef_w	= 'N'))
	and	((ie_agrupar_lote_w = 'N' and nr_seq_tipo_lote = nr_seq_tipo_lote_w and (nr_seq_tipo_lote IS NOT NULL AND nr_seq_tipo_lote::text <> '')
		and (nr_contrato = nr_contrato_w and (nr_contrato_w IS NOT NULL AND nr_contrato_w::text <> '')))
		or (ie_agrupar_lote_w = 'S' and coalesce(nr_seq_tipo_lote::text, '') = ''))
	and	coalesce(nr_seq_lote_vencimento::text, '') = ''
	and	((nm_usuario_solicitante = 'plusoft' and (nm_usuario_solicitante IS NOT NULL AND nm_usuario_solicitante::text <> '')) or (coalesce(nm_usuario_solicitante::text, '') = ''))
	and	((coalesce(ie_tipo_pessoa,'A') = ie_tipo_contrato_w) or (coalesce(ie_tipo_pessoa,'A') = 'A'))
	order by CASE WHEN coalesce(ie_tipo_beneficiario::text, '') = '' THEN -1  ELSE 1 END;

C03 CURSOR FOR  -- Carteiras com status "Definitivo"
	SELECT	a.nr_sequencia
	FROM pls_contrato b, pls_segurado a
LEFT OUTER JOIN pls_segurado_carteira c ON (a.nr_sequencia = c.nr_seq_segurado)
WHERE a.nr_seq_contrato = b.nr_sequencia  and c.ie_situacao = 'D' and b.nr_contrato = nr_contrato_p and coalesce(a.dt_rescisao::text, '') = '' order by 1 desc;


BEGIN
-- Erro
ie_resultado_p := 1;

--Encontra o usuario
begin
select	max(nm_usuario)
into STRICT	current_setting('pls_obj_plussoft_pck.nm_usuario_w')::usuario.nm_usuario%type
from	usuario
where	cd_pessoa_fisica = cd_pessoa_usuario_p
and	ie_situacao = 'A';
exception
when others then
	PERFORM set_config('pls_obj_plussoft_pck.nm_usuario_w', null, false);
end;

begin

if (nr_contrato_p IS NOT NULL AND nr_contrato_p::text <> '') then
	ie_qt_registro_C01_w := 0;
	
	open current_setting('pls_obj_plussoft_pck.c01')::CURSOR;
	loop
	fetch current_setting('pls_obj_plussoft_pck.c01')::into CURSOR
		nr_seq_segurado_w,
		current_setting('pls_obj_plussoft_pck.cd_estabelecimento_w')::smallint;
	EXIT WHEN NOT FOUND; /* apply on current_setting('pls_obj_plussoft_pck.c01')::CURSOR */
		begin
		ie_qt_registro_C01_w 	:= ie_qt_registro_C01_w + 1;
		ie_gerar_emissao_w	:= 'S';
		
		begin
			nr_seq_tipo_lote_w	:= coalesce(obter_valor_param_usuario(1226, 4, Obter_Perfil_Ativo, current_setting('pls_obj_plussoft_pck.nm_usuario_w')::usuario.nm_usuario%type, current_setting('pls_obj_plussoft_pck.cd_estabelecimento_w')::smallint), null);
		exception
		when others then
			nr_seq_tipo_lote_w	:= null;
		end;
		ie_usuario_solic_w		:= coalesce(obter_valor_param_usuario(1226, 6, Obter_Perfil_Ativo, current_setting('pls_obj_plussoft_pck.nm_usuario_w')::usuario.nm_usuario%type, current_setting('pls_obj_plussoft_pck.cd_estabelecimento_w')::smallint), 'N');
		ie_restringir_tipo_benef_w	:= coalesce(obter_valor_param_usuario(1202, 106, Obter_Perfil_Ativo, current_setting('pls_obj_plussoft_pck.nm_usuario_w')::usuario.nm_usuario%type, current_setting('pls_obj_plussoft_pck.cd_estabelecimento_w')::smallint), 'S');

		select	max(ie_emissao_cart_repasse_pre)
		into STRICT	ie_emissao_cart_repasse_pre_w
		from	pls_parametros
		where	cd_estabelecimento	= current_setting('pls_obj_plussoft_pck.cd_estabelecimento_w')::smallint;
		ie_emissao_cart_repasse_pre_w	:= coalesce(ie_emissao_cart_repasse_pre_w,'N');
		
		select	max(nr_sequencia)
		into STRICT	nr_seq_carteira_w
		from 	pls_segurado_carteira
		where 	nr_seq_segurado = nr_seq_segurado_w;
		
		select	b.ie_tipo_segurado,
			b.nr_sequencia,
			b.nr_seq_contrato
		into STRICT	ie_tipo_segurado_w,
			nr_seq_segurado_w,
			current_setting('pls_obj_plussoft_pck.nr_seq_contrato_w')::bigint
		from	pls_segurado		b,
			pls_segurado_carteira	a
		where	a.nr_seq_segurado	= b.nr_sequencia
		and	a.nr_sequencia		= nr_seq_carteira_w;

			if	(ie_emissao_cart_repasse_pre_w = 'S' AND ie_tipo_segurado_w = 'R') then
				select	max(ie_tipo_repasse)
				into STRICT	ie_tipo_repasse_w
				from	pls_segurado_repasse
				where	nr_seq_segurado	= nr_seq_segurado_w
				and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
				and	coalesce(dt_fim_repasse::text, '') = '';
					
				if (ie_tipo_repasse_w = 'P') then
					ie_gerar_emissao_w	:= 'N';
				end if;
			end if;
			
			if (ie_gerar_emissao_w = 'S') then
				select	max(b.nr_sequencia)
				into STRICT	nr_seq_lote_w
				from	pls_lote_carteira	b,
					pls_carteira_emissao	a
				where	b.ie_situacao		in ('P','G')
				and	b.ie_tipo_lote		= 'E'
				and	a.nr_seq_lote		= b.nr_sequencia
				and	a.nr_seq_seg_carteira	= nr_seq_carteira_w;
					
				if (nr_seq_lote_w > 0) then
					nr_seq_lote_carteira_p	:= nr_seq_lote_w;
					nm_usuario_p		:= current_setting('pls_obj_plussoft_pck.nm_usuario_w')::usuario.nm_usuario%type;
					ie_status_p		:= wheb_mensagem_pck.get_texto(1110479);
					ie_resultado_p		:= 1;
					ds_mensagem_erro_p	:= wheb_mensagem_pck.get_texto(183144,'NR_SEQ_CARTEIRA='||nr_seq_carteira_w||';'||'NR_SEQ_LOTE='||nr_seq_lote_w);
					rollback;
					goto final;
				end if;
				/*	
				select	count(*)
				into	qt_cart_provisorias_w
				from	pls_segurado_carteira
				where	ie_situacao		= 'P'
				and	nr_sequencia		= nr_seq_carteira_w;
				
				if	(qt_cart_provisorias_w = 0) then
					wheb_mensagem_pck.exibir_mensagem_abort(183143,'');
				end if;
				*/
	
				if (nr_seq_tipo_lote_w IS NOT NULL AND nr_seq_tipo_lote_w::text <> '') then
					select	ie_agrupar_lote
					into STRICT	ie_agrupar_lote_w
					from	pls_tipo_lote_carteira
					where	nr_sequencia	= nr_seq_tipo_lote_w
					and	ie_situacao	= 'A';
				else
					ie_agrupar_lote_w	:= 'S';
				end if;
					
				if (current_setting('pls_obj_plussoft_pck.nr_seq_contrato_w')::(bigint IS NOT NULL AND bigint::text <> '')) then
					select	nr_contrato,
						CASE WHEN coalesce(cd_cgc_estipulante::text, '') = '' THEN 'PF'  ELSE 'PJ' END
					into STRICT	nr_contrato_w,
						ie_tipo_contrato_w
					from	pls_contrato
					where	nr_sequencia	= current_setting('pls_obj_plussoft_pck.nr_seq_contrato_w')::bigint;
				end if;
				
				open current_setting('pls_obj_plussoft_pck.c02')::CURSOR;
				loop
				fetch current_setting('pls_obj_plussoft_pck.c02')::into CURSOR
					nr_seq_lote_carteira_w;
				EXIT WHEN NOT FOUND; /* apply on current_setting('pls_obj_plussoft_pck.c02')::CURSOR */
				end loop;
				close current_setting('pls_obj_plussoft_pck.c02')::CURSOR;
				
				if (coalesce(nr_seq_lote_carteira_w::text, '') = '') then
					select	nextval('pls_lote_carteira_seq')
					into STRICT	nr_seq_lote_carteira_w
					;
					
					if (coalesce(nr_seq_tipo_lote_w::text, '') = '') then
						nr_contrato_w		:= null;
					end if;
					
					insert	into	pls_lote_carteira(nr_sequencia, cd_estabelecimento, dt_atualizacao,
						nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
						dt_referencia_venc, ie_situacao, ie_tipo_lote,
						nr_seq_lote_vencimento,ie_tipo_contrato,ie_tipo_beneficiario,
						nr_seq_tipo_lote,nr_contrato,
						ie_tipo_data,ie_situacao_atend,ie_tipo_pessoa,nm_usuario_solicitante)
					values (	nr_seq_lote_carteira_w, current_setting('pls_obj_plussoft_pck.cd_estabelecimento_w')::smallint, clock_timestamp(),
						current_setting('pls_obj_plussoft_pck.nm_usuario_w')::usuario.nm_usuario%type, clock_timestamp(), current_setting('pls_obj_plussoft_pck.nm_usuario_w')::usuario.nm_usuario%type,
						null, 'G', 'E',
						null,'O',CASE WHEN ie_restringir_tipo_benef_w='S' THEN ie_tipo_segurado_w  ELSE '' END ,
						nr_seq_tipo_lote_w,nr_contrato_w,
						'N','T','A',CASE WHEN ie_usuario_solic_w='N' THEN ''  ELSE current_setting('pls_obj_plussoft_pck.nm_usuario_w')::usuario.nm_usuario%type END );
				end if;
				
				select	coalesce(a.ie_controle_carteira,'A')
				into STRICT	ie_controle_carteira_w
				from	pls_contrato 		a,
					pls_segurado 		b,
					pls_segurado_carteira	c
				where	a.nr_sequencia	= b.nr_seq_contrato
				and	b.nr_sequencia	= c.nr_seq_segurado
				and	c.nr_sequencia	= nr_seq_carteira_w;
				
				if (ie_controle_carteira_w in ('A','E')) then

					select  a.dt_solicitacao,
									a.nm_usuario_solicitante
					into STRICT		dt_solicitacao_w,
									nm_usuario_solic_w
					from		pls_segurado_carteira	a
					where		a.nr_sequencia = nr_seq_carteira_w;
					
					select	nextval('pls_carteira_emissao_seq')
					into STRICT	nr_seq_cart_emis_w
					;
					
					insert	into	pls_carteira_emissao(nr_sequencia, dt_atualizacao, nm_usuario,
						dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_lote,
						nr_seq_seg_carteira, dt_recebimento, ie_situacao, dt_solicitacao, nm_usuario_solic)
					values (	nr_seq_cart_emis_w, clock_timestamp(), current_setting('pls_obj_plussoft_pck.nm_usuario_w')::usuario.nm_usuario%type,
						clock_timestamp(), current_setting('pls_obj_plussoft_pck.nm_usuario_w')::usuario.nm_usuario%type, nr_seq_lote_carteira_w,
						nr_seq_carteira_w, null, 'P', dt_solicitacao_w, nm_usuario_solic_w);
					
					update 	pls_segurado_carteira
					set	nr_seq_lote_emissao	= nr_seq_lote_carteira_w,
						nm_usuario = current_setting('pls_obj_plussoft_pck.nm_usuario_w')::usuario.nm_usuario%type,
						dt_atualizacao = clock_timestamp()
					where	nr_sequencia		= nr_seq_carteira_w;
					
					CALL pls_atualizar_campos_cart_emis(nr_seq_cart_emis_w, nr_seq_carteira_w, current_setting('pls_obj_plussoft_pck.nm_usuario_w')::usuario.nm_usuario%type);
					CALL pls_alterar_estagios_cartao(nr_seq_carteira_w, clock_timestamp(), '2', current_setting('pls_obj_plussoft_pck.cd_estabelecimento_w')::smallint, current_setting('pls_obj_plussoft_pck.nm_usuario_w')::usuario.nm_usuario%type);
				end if;
			end if;
	end;
	end loop;
	close current_setting('pls_obj_plussoft_pck.c01')::CURSOR;
	
	if (ie_qt_registro_C01_w = 0) then
		open C03;
		loop
		fetch C03 into
			nr_seq_segurado_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin
			select	max(nr_sequencia)
			into STRICT	nr_seq_carteira_w
			from 	pls_segurado_carteira
			where 	nr_seq_segurado = nr_seq_segurado_w;
			
			select	max(b.nr_sequencia)
			into STRICT	nr_seq_lote_w
			from	pls_lote_carteira	b,
				pls_carteira_emissao	a
			where	b.ie_situacao		= 'D'
			and	b.ie_tipo_lote		= 'E'
			and	a.nr_seq_lote		= b.nr_sequencia
			and	a.nr_seq_seg_carteira	= nr_seq_carteira_w;
			
			if (nr_seq_lote_w > 0) then
				nr_seq_lote_carteira_p	:= nr_seq_lote_w;
				nm_usuario_p		:= current_setting('pls_obj_plussoft_pck.nm_usuario_w')::usuario.nm_usuario%type;
				ie_status_p		:= wheb_mensagem_pck.get_texto(1110480);
				ie_resultado_p		:= 1;
				ds_mensagem_erro_p	:= wheb_mensagem_pck.get_texto(183144,'NR_SEQ_CARTEIRA='||nr_seq_carteira_w||';'||'NR_SEQ_LOTE='||nr_seq_lote_w);
				rollback;
				goto final;
			end if;
			end;
		end loop;
		close C03;
	end if;
end if;
commit;
--Sucesso
ie_resultado_p := 0;
nr_seq_lote_carteira_p := nr_seq_lote_carteira_w;
nm_usuario_p := current_setting('pls_obj_plussoft_pck.nm_usuario_w')::usuario.nm_usuario%type;
ie_status_p := wheb_mensagem_pck.get_texto(1110479);

<<FINAL>>
if (current_setting('pls_obj_plussoft_pck.c01')::CURSOR%isopen) then
	close current_setting('pls_obj_plussoft_pck.c01')::CURSOR;
end if;
if (c03%isopen) then
	close c03;
end if;

exception
when others then
	rollback;
	--Erro
	ie_resultado_p := 1;
	ds_mensagem_erro_p := sqlerrm(SQLSTATE);
end;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obj_plussoft_pck.gerar_lote_carteirinha ( nr_contrato_p pls_lote_carteira.nr_contrato%type, cd_pessoa_usuario_p pessoa_fisica.cd_pessoa_fisica%type, nr_seq_lote_carteira_p INOUT pls_lote_carteira.nr_sequencia%type, nm_usuario_p INOUT usuario.nm_usuario%type, ie_status_p INOUT text, ie_resultado_p INOUT bigint, ds_mensagem_erro_p INOUT text) FROM PUBLIC;