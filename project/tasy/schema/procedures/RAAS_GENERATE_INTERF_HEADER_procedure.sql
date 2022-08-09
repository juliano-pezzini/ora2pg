-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE raas_generate_interf_header ( nr_seq_lote_atend_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_folhas_arquivo_w			w_raas_interf_header.qt_folhas_arquivo%type;
nr_controle_w				w_raas_interf_header.nr_controle%type;
dt_competencia_w			w_raas_interf_header.dt_competencia%type;
nm_orgao_responsavel_w		w_raas_interf_header.nm_orgao_responsavel%type;
ds_sigla_org_resp_w			w_raas_interf_header.ds_sigla_org_resp%type;
cd_cnpj_prestador_w			w_raas_interf_header.cd_cgc_prestador%type;
nm_orgao_destino_w			w_raas_interf_header.nm_orgao_destino%type;
ie_indicador_destino_w		w_raas_interf_header.ie_indicador_destino%type;
ds_versao_raas_w			w_raas_interf_header.ds_versao_raas%type;
ds_versao_bdsia_w			w_raas_interf_header.ds_versao_bdsia%type;

c01 CURSOR FOR
SELECT	a.dt_competencia,
		b.nm_orgao_responsavel,
		b.ds_sigla_org_resp,
		b.cd_cnpj_prestador,
		b.nm_orgao_destino,
		b.ie_indicador_destino,
		b.ds_versao_raas,
		b.ds_versao_bdsia
from	raas_lote_atendimentos a,
		sus_parametros_raas b
where	a.nr_sequencia = nr_seq_lote_atend_p
and		a.cd_estabelecimento = b.cd_estabelecimento;


BEGIN
delete	from w_raas_interf_header;
delete	from w_raas_interf_paciente_dom;
delete	from w_raas_interf_acoes_dom;
delete	from w_raas_interf_pac_psico;
delete	from w_raas_interf_acoes_psico;

commit;

open c01;
loop
fetch c01 into
	dt_competencia_w,
	nm_orgao_responsavel_w,
	ds_sigla_org_resp_w,
	cd_cnpj_prestador_w,
	nm_orgao_destino_w,
	ie_indicador_destino_w,
	ds_versao_raas_w,
	ds_versao_bdsia_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	
	CALL raas_generate_interf_pacie_dom(nr_seq_lote_atend_p, nm_usuario_p);
	CALL raas_generate_interf_acoes_dom(nr_seq_lote_atend_p, nm_usuario_p);
	CALL raas_generate_interf_pac_psico(nr_seq_lote_atend_p, nm_usuario_p);
	CALL raas_generate_interf_acoes_psi(nr_seq_lote_atend_p, nm_usuario_p);
	
	select	((select count(distinct nr_atendimento) from raas_atend_atencao_dom where nr_seq_lote_atend = nr_seq_lote_atend_p) +
			(select count(distinct nr_atendimento) from raas_atend_atencao_psico where nr_seq_lote_atend = nr_seq_lote_atend_p)),
			(mod((select coalesce(sum(cd_sigtap_acao),0) + coalesce(sum(qt_realizada),0) from w_raas_interf_acoes_dom) +
				(select coalesce(sum(cd_sigtap_acao),0) + coalesce(sum(qt_realizada),0) from w_raas_interf_acoes_psico) +
				(select coalesce(sum(cd_unidade_prestadora),0) + coalesce(sum(cd_cartao_saude_paciente),0) from w_raas_interf_paciente_dom) +
				(select coalesce(sum(cd_unidade_prestadora),0) + coalesce(sum(cd_cartao_saude_paciente),0) from w_raas_interf_pac_psico), 1111) + 1111)
	into STRICT	qt_folhas_arquivo_w,
			nr_controle_w
	;
	
	insert into w_raas_interf_header(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_lote_atend,
		ds_indicador_cabecalho,
		dt_competencia,
		qt_folhas_arquivo,
		nr_controle,
		nm_orgao_responsavel,
		ds_sigla_org_resp,
		cd_cgc_prestador,
		nm_orgao_destino,
		ie_indicador_destino,
		dt_geracao,
		ds_versao_raas,
		ds_versao_bdsia)
	values (
		nextval('w_raas_interf_header_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_lote_atend_p,
		'#RAS#',
		dt_competencia_w,
		qt_folhas_arquivo_w,
		nr_controle_w,
		nm_orgao_responsavel_w,
		ds_sigla_org_resp_w,
		cd_cnpj_prestador_w,
		nm_orgao_destino_w,
		ie_indicador_destino_w,
		clock_timestamp(),
		ds_versao_raas_w,
		ds_versao_bdsia_w);
		
	commit;
	end;
end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE raas_generate_interf_header ( nr_seq_lote_atend_p bigint, nm_usuario_p text) FROM PUBLIC;
