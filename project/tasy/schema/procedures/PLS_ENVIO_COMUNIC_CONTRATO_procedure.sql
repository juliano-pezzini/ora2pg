-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_envio_comunic_contrato ( nm_usuario_p text, ie_evento_p text, nr_seq_contrato_p pls_contrato.nr_sequencia%type) AS $body$
DECLARE


qt_regra_w		integer;
ds_data_w		varchar(255);
ds_mes_w		varchar(2);
cd_prioridade_w		pls_email_parametros.cd_prioridade%type;
ds_mensagem_w		pls_email.ds_mensagem%type;
ds_assunto_w		pls_email.ds_assunto%type;
ds_comunicado_w		text;
ds_rtf_inicio_w		varchar(255);
ds_rtf_fim_w		varchar(255);
nm_usuario_web_lista_w	pls_comunic_externa_web.nm_usuario_prestador%type;

nr_indice_comunicado_w	integer;
tb_nm_usuario_web_lista_w pls_util_cta_pck.t_varchar2_table_4000;
tb_nr_seq_contrato_w	pls_util_cta_pck.t_number_table;
tb_ds_mensagem_comun_w	pls_util_cta_pck.t_varchar2_table_4000;
tb_ds_assunto_comun_w	pls_util_cta_pck.t_varchar2_table_255;
tb_nr_seq_regra_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_regra_wr	pls_util_cta_pck.t_number_table;
tb_nr_seq_comunicado_wr	pls_util_cta_pck.t_number_table;

c01 CURSOR FOR
	SELECT	ie_tipo_estipulante,
		ie_data_base_aniversario,
		ie_comunicado_web,
		ie_destino,
		nr_seq_perfil_web,
		ds_assunto,
		ds_mensagem,
		cd_estabelecimento,
		nr_sequencia nr_seq_regra
	from	pls_regra_comunic_contrato
	where	ie_evento = ie_evento_p;

c02 CURSOR FOR
	SELECT	CASE WHEN coalesce(cd_pf_estipulante::text, '') = '' THEN  'PJ'  ELSE 'PF' END  ie_tipo_estipulante,
		to_char(lpad(nr_mes_reajuste,2,0)) nr_mes_reajuste,
		dt_contrato,
		cd_pf_estipulante,
		cd_cgc_estipulante,
		cd_estabelecimento,
		obter_dados_pf_pj_estab(cd_estabelecimento,cd_pf_estipulante,cd_cgc_estipulante,'M') ds_email,
		nr_sequencia nr_seq_contrato,
		nr_contrato,
		obter_dados_pf_pj(cd_pf_estipulante,cd_cgc_estipulante,'F') nm_fantasia,
		obter_dados_pf_pj(cd_pf_estipulante,cd_cgc_estipulante,'N') nm_estipulante
	from	pls_contrato
	where	coalesce(nr_seq_contrato_p::text, '') = ''
	
union

	SELECT	CASE WHEN coalesce(cd_pf_estipulante::text, '') = '' THEN  'PJ'  ELSE 'PF' END  ie_tipo_estipulante,
		to_char(lpad(nr_mes_reajuste,2,0)) nr_mes_reajuste,
		dt_contrato,
		cd_pf_estipulante,
		cd_cgc_estipulante,
		cd_estabelecimento,
		obter_dados_pf_pj_estab(cd_estabelecimento,cd_pf_estipulante,cd_cgc_estipulante,'M') ds_email,
		nr_sequencia nr_seq_contrato,
		nr_contrato,
		obter_dados_pf_pj(cd_pf_estipulante,cd_cgc_estipulante,'F') nm_fantasia,
		obter_dados_pf_pj(cd_pf_estipulante,cd_cgc_estipulante,'N') nm_estipulante
	from	pls_contrato
	where	nr_sequencia = nr_seq_contrato_p;

c03 CURSOR(	nr_seq_contrato_pc	pls_contrato.nr_sequencia%type,
		nr_seq_perfil_web_pc	pls_regra_comunic_contrato.nr_seq_perfil_web%type) FOR
	SELECT	coalesce(ds_email, obter_dados_pf_pj(cd_pessoa_fisica,null,'M')) ds_email,
		nm_usuario_web
	from	pls_estipulante_web
	where	nr_seq_contrato = nr_seq_contrato_pc
	and	((coalesce(nr_seq_perfil_web_pc::text, '') = '') or (nr_seq_perfil_web_pc = nr_seq_perfil_web))
	and	ie_situacao = 'A'
	
union

	SELECT	obter_dados_pf_pj_estab(c.cd_estabelecimento,c.cd_pf_estipulante,c.cd_cgc_estipulante,'M') ds_email,
		a.nm_usuario_web
	from	pls_grupo_contrato_web a,
		pls_contrato_web b,
		pls_contrato c
	where	a.nr_sequencia	= b.nr_seq_usuario_grupo
	and	b.nr_seq_contrato = nr_seq_contrato_pc
	and	c.nr_sequencia	= b.nr_seq_contrato
	and	a.ie_situacao	= 'A'
	and	b.ie_situacao	= 'A'
	and	((coalesce(nr_seq_perfil_web_pc::text, '') = '') or (nr_seq_perfil_web_pc = a.nr_seq_perfil_web))
	
union

	select	obter_dados_pf_pj_estab(c.cd_estabelecimento,c.cd_pf_estipulante,c.cd_cgc_estipulante,'M') ds_email,
		a.nm_usuario_web
	from	pls_grupo_contrato_web a,
		pls_contrato_grupo b,
		pls_contrato c
	where	a.nr_seq_grupo_contrato = b.nr_seq_grupo
	and	b.nr_seq_contrato = nr_seq_contrato_pc
	and	c.nr_sequencia = b.nr_seq_contrato
	and	a.ie_situacao	= 'A'
	and	((coalesce(nr_seq_perfil_web_pc::text, '') = '') or (nr_seq_perfil_web_pc = a.nr_seq_perfil_web))
	and	not exists (	select	1
				from	pls_contrato_web x 
				where	x.nr_seq_usuario_grupo = a.nr_sequencia);

procedure limpar_vetor_comunicado is;
BEGIN
nr_indice_comunicado_w	:= 0;
tb_nr_seq_contrato_w.delete;
tb_ds_mensagem_comun_w.delete;
tb_ds_assunto_comun_w.delete;
tb_nr_seq_regra_w.delete;
tb_nm_usuario_web_lista_w.delete;
tb_nr_seq_regra_wr.delete;
tb_nr_seq_comunicado_wr.delete;
end;

procedure inserir_comunicado is

begin

if (tb_nr_seq_contrato_w.count > 0) then
	forall i in tb_nr_seq_contrato_w.first..tb_nr_seq_contrato_w.last
		insert into pls_comunic_externa_web(nr_sequencia, ie_situacao, ie_tipo_login,
			nm_usuario_nrec, dt_atualizacao_nrec, nm_usuario,
			dt_atualizacao, dt_criacao, ds_texto,
			dt_liberacao, ie_tipo_comunicado_web, nm_usuario_prestador,
			ds_titulo)
		values (nextval('pls_comunic_externa_web_seq'), 'A', 'E',
			nm_usuario_p, clock_timestamp(), nm_usuario_p,
			clock_timestamp(), clock_timestamp(), tb_ds_mensagem_comun_w(i),
			clock_timestamp(), 'M', tb_nm_usuario_web_lista_w(i),
			tb_ds_assunto_comun_w(i))
		RETURNING tb_nr_seq_regra_w(i), nr_sequencia
		BULK COLLECT INTO tb_nr_seq_regra_wr, tb_nr_seq_comunicado_wr;
	commit;
	
	forall i in tb_nr_seq_comunicado_wr.first..tb_nr_seq_comunicado_wr.last
		insert into pls_comunic_ext_anexo_web(nr_sequencia, dt_atualizacao, dt_atualizacao_nrec,
			nm_usuario, nm_usuario_nrec, nr_seq_comunicado,
			ds_arquivo, nm_arquivo)
		SELECT	nextval('pls_comunic_ext_anexo_web_seq'), clock_timestamp(), clock_timestamp(),
			nm_usuario_p, nm_usuario_p, tb_nr_seq_comunicado_wr(i),
			ds_arquivo, wheb_mensagem_pck.get_texto(1127709)
		from	pls_regra_comunic_cont_doc
		where	nr_seq_regra = tb_nr_seq_regra_wr(i)
		and	(ds_arquivo IS NOT NULL AND ds_arquivo::text <> '');
	commit;
end if;

limpar_vetor_comunicado;

end;

procedure enviar_email(	ds_email_p		varchar2,
				cd_estabelecimento_p	estabelecimento.cd_estabelecimento%type,
				cd_pf_estipulante_p	pls_contrato.cd_pf_estipulante%type,
				cd_cgc_estipulante_p	pls_contrato.cd_cgc_estipulante%type,
				nr_seq_contrato_p	pls_contrato.nr_sequencia%type,
				nr_seq_regra_p		pls_regra_comunic_contrato.nr_sequencia%type) is
nr_seq_email_w		pls_email.nr_sequencia%type;
nr_seq_email_anexo_w	pls_email_anexo.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	cd_classif_relat,
		cd_relatorio,
		ds_arquivo
	from	pls_regra_comunic_cont_doc
	where	nr_seq_regra	= nr_seq_regra_p;

begin

if (ds_email_p IS NOT NULL AND ds_email_p::text <> '') then
	insert	into	pls_email(	nr_sequencia, cd_estabelecimento, nm_usuario_nrec,
			dt_atualizacao_nrec, nm_usuario, dt_atualizacao,
			ie_tipo_mensagem, ie_status, ie_origem,
			ds_remetente, ds_mensagem, ds_destinatario,
			ds_assunto, cd_prioridade, cd_pessoa_fisica, 
			cd_cgc)
		values (	nextval('pls_email_seq'), cd_estabelecimento_p, nm_usuario_p,
			clock_timestamp(), nm_usuario_p, clock_timestamp(),
			'7', 'P', '7', 
			null, ds_mensagem_w, ds_email_p,
			ds_assunto_w, cd_prioridade_w, cd_pf_estipulante_p,
			cd_cgc_estipulante_p)
		returning nr_sequencia into nr_seq_email_w;
	
	for c01_w in C01 loop
		begin
		insert	into	pls_email_anexo(	nr_sequencia, dt_atualizacao, nm_usuario,
				dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_email,
				ie_tipo_anexo, cd_classif_relat, cd_relatorio,
				ds_arquivo)
			values (	nextval('pls_email_anexo_seq'), clock_timestamp(), nm_usuario_p,
				clock_timestamp(), nm_usuario_p, nr_seq_email_w,
				CASE WHEN coalesce(c01_w.ds_arquivo::text, '') = '' THEN 'R'  ELSE 'A' END , c01_w.cd_classif_relat, c01_w.cd_relatorio,
				c01_w.ds_arquivo)
			returning nr_sequencia into nr_seq_email_anexo_w;
		
		if (c01_w.cd_relatorio IS NOT NULL AND c01_w.cd_relatorio::text <> '') then
			insert	into	pls_email_anexo_param(	nr_sequencia, dt_atualizacao, nm_usuario,
					dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_anexo,
					nm_parametro, ds_valor_parametro, ie_tipo_parametro)
				values (	nextval('pls_email_anexo_param_seq'), clock_timestamp(), nm_usuario_p,
					clock_timestamp(), nm_usuario_p, nr_seq_email_anexo_w,
					'NR_SEQ_CONTRATO', nr_seq_contrato_p, 'C');
		end if;
		end;
	end loop;
end if;

end;

begin

select	count(1)
into STRICT	qt_regra_w
from	pls_regra_comunic_contrato
where	ie_evento = ie_evento_p;

if (qt_regra_w > 0) then
	
	ds_data_w	:= to_char(trunc(clock_timestamp(),'dd'), 'dd/mm');
	ds_mes_w	:= to_char(trunc(clock_timestamp(),'dd'), 'mm');
	
	ds_rtf_inicio_w	:= '{\rtf1\ansi\deff0{\fonttbl{\f0\fswiss\fcharset0 Arial;}}{\colortbl ;\red0\green0\blue128;}\viewkind4\uc1\pard\cf1\lang1046\f0\fs24 ';
	ds_rtf_fim_w	:= ' \fs20 \par }';
	
	limpar_vetor_comunicado;
	
	for r_c01_w in c01 loop
		begin
		select	coalesce(max(cd_prioridade),5)
		into STRICT	cd_prioridade_w
		from	pls_email_parametros
		where	ie_origem		= 7
		and	cd_estabelecimento	= r_c01_w.cd_estabelecimento
		and	ie_situacao		= 'A';
		
		ds_mensagem_w	:= r_c01_w.ds_mensagem;
		ds_assunto_w	:= r_c01_w.ds_assunto;
		
		for r_c02_w in c02 loop
			begin
			if	((r_c01_w.cd_estabelecimento = r_c02_w.cd_estabelecimento) and
				((r_c01_w.ie_tipo_estipulante = 'A') or (r_c01_w.ie_tipo_estipulante = r_c02_w.ie_tipo_estipulante)) and
				((ie_evento_p = '2') or
				((ie_evento_p = '1') and
				((r_c01_w.ie_data_base_aniversario = 'R') and (ds_mes_w = r_c02_w.nr_mes_reajuste) and (to_char(clock_timestamp(),'dd') = '01')) or 
				((r_c01_w.ie_data_base_aniversario = 'C') and (ds_data_w = to_char(r_c02_w.dt_contrato, 'dd/mm')))))) then
				
				ds_mensagem_w := replace(ds_mensagem_w,'@NR_CONTRATO',r_c02_w.nr_contrato);
				ds_mensagem_w := replace(ds_mensagem_w,'@NM_ESTIPULANTE',r_c02_w.nm_estipulante);
				ds_mensagem_w := replace(ds_mensagem_w,'@NM_FANTASIA',r_c02_w.nm_fantasia);
				ds_mensagem_w := replace(ds_mensagem_w,'@DT_CONTRATO',to_char(r_c02_w.dt_contrato,'DD/MM/YYYY'));
				
				ds_assunto_w := replace(ds_assunto_w,'@NR_CONTRATO',r_c02_w.nr_contrato);
				ds_assunto_w := replace(ds_assunto_w,'@NM_ESTIPULANTE',r_c02_w.nm_estipulante);
				ds_assunto_w := replace(ds_assunto_w,'@NM_FANTASIA',r_c02_w.nm_fantasia);
				ds_assunto_w := replace(ds_assunto_w,'@DT_CONTRATO',to_char(r_c02_w.dt_contrato,'DD/MM/YYYY'));
				
				if (r_c01_w.ie_destino = '1') then
					CALL enviar_email(	r_c02_w.ds_email, r_c01_w.cd_estabelecimento, r_c02_w.cd_pf_estipulante,
							r_c02_w.cd_cgc_estipulante, r_c02_w.nr_seq_contrato, r_c01_w.nr_seq_regra);
				elsif (r_c01_w.ie_destino = '2') then
					for r_c03_w in c03(	r_c02_w.nr_seq_contrato,
								r_c01_w.nr_seq_perfil_web) loop
						begin
						CALL enviar_email(	r_c03_w.ds_email, r_c01_w.cd_estabelecimento, r_c02_w.cd_pf_estipulante,
								r_c02_w.cd_cgc_estipulante, r_c02_w.nr_seq_contrato, r_c01_w.nr_seq_regra);
						end;
					end loop;
				end if;
				
				if (r_c01_w.ie_comunicado_web = 'S') then
					nm_usuario_web_lista_w	:= null;
					
					for r_c03_w in c03(	r_c02_w.nr_seq_contrato,
								r_c01_w.nr_seq_perfil_web) loop
						begin
						if (r_c03_w.nm_usuario_web IS NOT NULL AND r_c03_w.nm_usuario_web::text <> '') then
							if (coalesce(nm_usuario_web_lista_w::text, '') = '') then
								nm_usuario_web_lista_w	:= r_c03_w.nm_usuario_web;
							else
								nm_usuario_web_lista_w	:= nm_usuario_web_lista_w || ',' || r_c03_w.nm_usuario_web;
							end if;
						end if;
						end;
					end loop;
					
					if (nm_usuario_web_lista_w IS NOT NULL AND nm_usuario_web_lista_w::text <> '') then
						ds_comunicado_w	:=	ds_rtf_inicio_w || chr(13) || chr(10)||
									ds_mensagem_w || chr(13) || chr(10)||
									ds_rtf_fim_w;
						
						tb_nr_seq_contrato_w(nr_indice_comunicado_w)	:= r_c02_w.nr_seq_contrato;
						tb_ds_mensagem_comun_w(nr_indice_comunicado_w)	:= ds_comunicado_w;
						tb_ds_assunto_comun_w(nr_indice_comunicado_w)	:= ds_assunto_w;
						tb_nr_seq_regra_w(nr_indice_comunicado_w)	:= r_c01_w.nr_seq_regra;
						tb_nm_usuario_web_lista_w(nr_indice_comunicado_w) := nm_usuario_web_lista_w;
						
						if (nr_indice_comunicado_w >= pls_util_pck.qt_registro_transacao_w) then
							inserir_comunicado;
						else
							nr_indice_comunicado_w	:= nr_indice_comunicado_w + 1;
						end if;
					end if;
				end if;
			end if;
			end;
		end loop;
		end;
	end loop;
	
	inserir_comunicado;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_envio_comunic_contrato ( nm_usuario_p text, ie_evento_p text, nr_seq_contrato_p pls_contrato.nr_sequencia%type) FROM PUBLIC;
