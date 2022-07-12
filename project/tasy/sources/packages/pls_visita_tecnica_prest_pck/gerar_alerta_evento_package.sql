-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_visita_tecnica_prest_pck.gerar_alerta_evento ( nr_seq_visita_p pls_visita_tecnica.nr_sequencia%type, ie_tipo_processo_p pls_regra_geracao_evento.ie_tipo_processo_visita%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) AS $body$
DECLARE


C01 CURSOR FOR
	SELECT	a.nr_seq_evento_mens,
		b.nr_seq_tipo_evento,
		b.ie_tipo_envio,
		b.ds_titulo,
		b.ds_mensagem,
		b.ds_remetente_email
	from	pls_regra_geracao_evento a,
		pls_alerta_evento_mensagem b
	where	b.nr_sequencia	= a.nr_seq_evento_mens
	and	a.ie_situacao = 'A'
	and	a.ie_evento_disparo = 17
	and	a.ie_tipo_processo_visita = ie_tipo_processo_p;

C02 CURSOR(nr_seq_evento_mens_pc	pls_alerta_evento_mensagem.nr_sequencia%type) FOR
	SELECT	nr_sequencia,
		ie_forma_envio,
		ie_tipo_pessoa_dest
	from	pls_alerta_evento_destino
	where	nr_seq_evento_mens = nr_seq_evento_mens_pc
	and	ie_situacao = 'A';

C03 CURSOR(nr_seq_evento_destino_pc	pls_alerta_evento_destino.nr_sequencia%type) FOR
	SELECT	nm_usuario_destino
	from	pls_alerta_event_dest_fixo
	where	nr_seq_alerta_event_dest	= nr_seq_evento_destino_pc
	and	(nm_usuario_destino IS NOT NULL AND nm_usuario_destino::text <> '');WITH RECURSIVE cte AS (


C04 CURSOR(ds_lista_usuario_pc		pls_alerta_event_dest_fixo.nm_usuario_destino%type) FOR
	SELECT	regexp_substr(ds_lista_usuario_pc,'[^,]+', 1, level) nm_destino
	
	(REGEXP_SUBSTR(ds_lista_usuario_pc, '[^,]+', 1, level) IS NOT NULL AND (REGEXP_SUBSTR(ds_lista_usuario_pc, '[^,]+', 1, level))::text <> '')  UNION ALL


C04 CURSOR(ds_lista_usuario_pc		pls_alerta_event_dest_fixo.nm_usuario_destino%type) FOR
	SELECT	regexp_substr(ds_lista_usuario_pc,'[^,]+', 1, level) nm_destino
	 
	(REGEXP_SUBSTR(ds_lista_usuario_pc, '[^,]+', 1, level) IS NOT NULL AND (REGEXP_SUBSTR(ds_lista_usuario_pc, '[^,]+', 1, level))::text <> '') JOIN cte c ON ()

) SELECT * FROM cte;
;

nr_seq_prestador_w		pls_visita_tecnica.nr_seq_prestador%type;
nr_seq_credenciamento_w		pls_visita_tecnica.nr_seq_credenciamento%type;
cd_estabelecimento_w		pls_visita_tecnica.cd_estabelecimento%type;

nr_seq_evento_controle_w	pls_alerta_evento_controle.nr_sequencia%type;
ds_titulo_w			pls_alerta_evento_mensagem.ds_titulo%type;
ds_mensagem_w			pls_alerta_evento_mensagem.ds_mensagem%type;
nr_seq_wsuite_usuario_w		wsuite_usuario.nr_sequencia%type	:= null;
ds_email_w			wsuite_usuario.ds_email%type;
ie_tipo_solicitante_w		pls_creden_prestador.ie_tipo_solicitante%type;
ie_aplicacao_w			pls_notificacao_tws.ie_aplicacao%type;
cd_prioridade_email_w		pls_email_parametros.cd_prioridade%type;
ie_origem_email_w		pls_email.ie_origem%type;
BEGIN

begin
	select	nr_seq_credenciamento,
		nr_seq_prestador,
		cd_estabelecimento
	into STRICT	nr_seq_credenciamento_w,
		nr_seq_prestador_w,
		cd_estabelecimento_w
	from	pls_visita_tecnica
	where	nr_sequencia	= nr_seq_visita_p;
exception
when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1207549); --Registro invalido
end;

if (nr_seq_credenciamento_w IS NOT NULL AND nr_seq_credenciamento_w::text <> '') then
	begin
		select	a.nr_seq_wsuite_usuario,
			upper(a.ie_tipo_solicitante),
			b.ds_email
		into STRICT	nr_seq_wsuite_usuario_w,
			ie_tipo_solicitante_w,
			ds_email_w
		from	pls_creden_prestador a,
			wsuite_usuario b 
		where	b.nr_sequencia	= a.nr_seq_wsuite_usuario
		and	a.nr_sequencia	= nr_seq_credenciamento_w;
		
		if (ie_tipo_solicitante_w = 'PRO') then --Proponente
			ie_aplicacao_w		:= 8;
		elsif (ie_tipo_solicitante_w = 'PRE') then --Prestador
			ie_aplicacao_w		:= 9;
		end if;
		
		ie_origem_email_w	:= 9;
	exception when no_data_found then
		nr_seq_wsuite_usuario_w := null;
	end;
end if;

if (nr_seq_wsuite_usuario_w IS NOT NULL AND nr_seq_wsuite_usuario_w::text <> '') then
	for c01_w in C01 loop
		begin
		ds_titulo_w	:= replace(c01_w.ds_titulo,'@NR_VISITA',nr_seq_visita_p);
		ds_mensagem_w	:= replace(c01_w.ds_mensagem,'@NR_VISITA',nr_seq_visita_p);
		
		nr_seq_evento_controle_w := pls_visita_tecnica_prest_pck.gerar_evento_controle(c01_w.nr_seq_tipo_evento, ds_titulo_w, ds_mensagem_w, nm_usuario_p, nr_seq_evento_controle_w);
		
		for c02_w in C02(c01_w.nr_seq_evento_mens ) loop
			begin
			
			if (c02_w.ie_forma_envio = 'NTF') then
				CALL tws_notificacao_hpms_pck.tws_gerar_notificacao_web(
								ie_tipo_processo_p => 'CR',
								ie_aplicacao_p => ie_aplicacao_w,
								ds_titulo_p => ds_titulo_w,
								ds_texto_p => ds_mensagem_w,
								nr_seq_conta_p => null,
								nr_seq_prestador_p => nr_seq_prestador_w,
								nr_seq_segurado_p => null,
								nr_seq_wsuite_usuario_p => nr_seq_wsuite_usuario_w,
								nm_usuario_p => nm_usuario_p
								);
				
				CALL CALL pls_visita_tecnica_prest_pck.gerar_evento_controle_dest(nr_seq_evento_controle_w, c02_w.ie_forma_envio, c02_w.ie_tipo_pessoa_dest, null, ds_mensagem_w, nm_usuario_p);
			elsif (c02_w.ie_forma_envio = 'EM') then
				if (ds_email_w IS NOT NULL AND ds_email_w::text <> '') then
					select	coalesce(max(cd_prioridade),5)
					into STRICT	cd_prioridade_email_w
					from	pls_email_parametros
					where	ie_origem		= ie_origem_email_w
					and	cd_estabelecimento	= cd_estabelecimento_w
					and	ie_situacao		= 'A';
					
					insert	into	pls_email(	nr_sequencia, cd_estabelecimento, nm_usuario_nrec,
							dt_atualizacao_nrec, nm_usuario, dt_atualizacao,
							ie_tipo_mensagem, ie_status, ie_origem,
							ds_remetente, cd_prioridade, ds_destinatario,
							nr_seq_visita, ds_assunto, ds_mensagem )
						values (nextval('pls_email_seq'), cd_estabelecimento_w, nm_usuario_p,
							clock_timestamp(), nm_usuario_p, clock_timestamp(),
							'10', 'P', ie_origem_email_w,
							c01_w.ds_remetente_email, cd_prioridade_email_w, ds_email_w,
							nr_seq_visita_p, ds_titulo_w, ds_mensagem_w );
					
					CALL CALL pls_visita_tecnica_prest_pck.gerar_evento_controle_dest(nr_seq_evento_controle_w, c02_w.ie_forma_envio, c02_w.ie_tipo_pessoa_dest, null, ds_mensagem_w, nm_usuario_p);
				end if;
			elsif (c02_w.ie_forma_envio = 'CI') then
				for c03_w in C03(c02_w.nr_sequencia) loop
					begin
					
					CALL gerar_comunic_padrao(	clock_timestamp(), ds_titulo_w, ds_mensagem_w,
								nm_usuario_p, 'N', c03_w.nm_usuario_destino,
								'N', null, null,
								cd_estabelecimento_w, null, clock_timestamp(),
								null, null);
					
					for c04_w in C04(c03_w.nm_usuario_destino) loop
						begin
						CALL CALL pls_visita_tecnica_prest_pck.gerar_evento_controle_dest(nr_seq_evento_controle_w, c02_w.ie_forma_envio, c02_w.ie_tipo_pessoa_dest, c04_w.nm_destino, ds_mensagem_w, nm_usuario_p);
						end;
					end loop; --C04
					
					end;
				end loop; --C03
			end if;
			
			end;
		end loop; --C02
		
		end;
	end loop; --C01
end if;

if (ie_commit_p = 'S') then
	commit;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_visita_tecnica_prest_pck.gerar_alerta_evento ( nr_seq_visita_p pls_visita_tecnica.nr_sequencia%type, ie_tipo_processo_p pls_regra_geracao_evento.ie_tipo_processo_visita%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) FROM PUBLIC;