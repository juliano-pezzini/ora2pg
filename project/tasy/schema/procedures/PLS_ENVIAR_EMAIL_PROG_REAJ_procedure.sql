-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_enviar_email_prog_reaj ( nr_seq_lote_prog_p pls_prog_reaj_colet_lote.nr_sequencia%type, nr_seq_regra_email_p pls_regra_reaj_email.nr_sequencia%type, ds_assunto_p text, ds_mensagem_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


nr_seq_email_w		pls_email.nr_sequencia%type;
ds_mensagem_w		pls_email.ds_mensagem%type;
cd_prioridade_w		pls_email.cd_prioridade%type;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.dt_reajuste,
		obter_nome_pf_pj(b.cd_pf_estipulante,b.cd_cgc_estipulante) nm_estipulante,
		b.cd_operadora_empresa,
		b.nr_contrato,
		b.dt_contrato,
		pls_obter_email_pessoa(cd_estabelecimento_p,b.cd_pf_estipulante,b.cd_cgc_estipulante,nm_usuario_p) ds_email,
		b.cd_pf_estipulante,
		b.cd_cgc_estipulante
	from	pls_prog_reaj_coletivo a,
		pls_contrato b
	where	b.nr_sequencia	= a.nr_seq_contrato
	and	a.nr_seq_lote	= nr_seq_lote_prog_p
	and	exists (	SELECT	1
				from	pls_contrato_inf_reajuste x
				where	x.nr_seq_contrato	= b.nr_sequencia
				and	x.ie_comunicado_email	= 'S');

C02 CURSOR FOR
	SELECT	ds_arquivo
	from	pls_regra_reaj_email_anexo
	where	nr_seq_regra	= nr_seq_regra_email_p;

BEGIN

--Origem : 4 - OPS - Programação de Reajuste Coletivo
select	coalesce(max(cd_prioridade),5)
into STRICT	cd_prioridade_w
from	pls_email_parametros
where	ie_origem 		= 4
and	cd_estabelecimento 	= cd_estabelecimento_p
and	ie_situacao 		= 'A';

for r_c01_w in C01 loop
	begin
	if (r_c01_w.ds_email IS NOT NULL AND r_c01_w.ds_email::text <> '') then
		ds_mensagem_w	:= ds_mensagem_p;
		ds_mensagem_w	:= replace(ds_mensagem_w,'@MES_REAJUSTE',to_char(r_c01_w.dt_reajuste,'mm/yyyy'));
		ds_mensagem_w	:= replace(ds_mensagem_w,'@NM_ESTIPULANTE',r_c01_w.nm_estipulante);
		ds_mensagem_w	:= replace(ds_mensagem_w,'@CD_OPERADORA_EMPRESA',r_c01_w.cd_operadora_empresa);
		ds_mensagem_w	:= replace(ds_mensagem_w,'@NR_CONTRATO',r_c01_w.nr_contrato);
		ds_mensagem_w	:= replace(ds_mensagem_w,'@DT_CONTRATO',to_char(r_c01_w.dt_contrato,'dd/mm/yyyy'));
		
		insert	into	pls_email(	nr_sequencia, cd_prioridade, cd_estabelecimento,
				ie_origem, ie_status, ie_tipo_mensagem,
				ds_assunto, ds_mensagem, dt_atualizacao,
				dt_atualizacao_nrec, nm_usuario, nm_usuario_nrec,
				ds_destinatario, ds_remetente, nr_seq_prog_reaj_col,
				cd_pessoa_fisica, cd_cgc)
			values (	nextval('pls_email_seq'), cd_prioridade_w, cd_estabelecimento_p,
				'4', 'P', '4',
				ds_assunto_p, ds_mensagem_w, clock_timestamp(),
				clock_timestamp(), nm_usuario_p, nm_usuario_p,
				r_c01_w.ds_email, null, r_c01_w.nr_sequencia,
				r_c01_w.cd_pf_estipulante , r_c01_w.cd_cgc_estipulante)
			returning nr_sequencia into nr_seq_email_w;
		
		for r_c02_w in C02 loop
			begin
			insert	into	pls_email_anexo(	nr_sequencia, nr_seq_email, nm_usuario,
					nm_usuario_nrec, dt_atualizacao, dt_atualizacao_nrec,
					ie_tipo_anexo, ds_arquivo)
				values (	nextval('pls_email_anexo_seq'), nr_seq_email_w, nm_usuario_p,
					nm_usuario_p, clock_timestamp(), clock_timestamp(),
					'A', pls_converte_path_storage_web(r_c02_w.ds_arquivo));
			end;
		end loop; --C02
	end if;
	end;
end loop; --C01
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_enviar_email_prog_reaj ( nr_seq_lote_prog_p pls_prog_reaj_colet_lote.nr_sequencia%type, nr_seq_regra_email_p pls_regra_reaj_email.nr_sequencia%type, ds_assunto_p text, ds_mensagem_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;

