-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_apac_laudo ( nr_apac_p bigint, nr_atendimento_p bigint, cd_motivo_cobranca_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
 
cd_estabelecimento_w	smallint;
dt_competencia_apac_w	timestamp;
nr_sequencia_w		bigint;
cd_unidade_w		varchar(7);
cd_medico_resp_w		varchar(10);
cd_varia_atrib_w		varchar(2);
cd_tratamento_w		varchar(2);
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
cd_motivo_cobranca_w	smallint;
dt_inicio_val_apac_w	timestamp;
dt_fim_val_apac_w		timestamp;
dt_pri_tratamento_w	timestamp;
dt_seg_tratamento_w	timestamp;
dt_ter_tratamento_w	timestamp;
cd_cid_principal_w		varchar(4);
cd_cid_secundario_w	varchar(4);
ie_finalidade_w		varchar(3);
dt_inicio_trat_solic_w	timestamp;
qt_meses_prev_w		smallint;
qt_total_campo_prev_w	integer;
dt_diagnostico_w		timestamp;
nr_seq_interno_w		bigint;
cd_doenca_cid_w		varchar(10);
cd_cid_pri_radiacao_w	varchar(4);
cd_cid_seg_radiacao_w	varchar(4);
cd_cid_ter_radiacao_w	varchar(4);
qt_cursor_w		bigint := 1;
cd_pessoa_fisica_w	varchar(10);
nr_cartao_nac_sus_w	varchar(20);
cd_estadio_w		smallint;
ie_metastase_w		varchar(1);
cd_cid_morfologia_w	varchar(6);
cd_setor_atendimento_w	integer;
dt_emissao_w		timestamp;
cd_nacionalidade_w	varchar(8);

c01 CURSOR FOR 
	SELECT	cd_doenca_cid 
	from	sus_laudo_area_irradiada 
	where	nr_seq_laudo	= nr_seq_interno_w  LIMIT 3;


BEGIN 
 
begin 
select	cd_procedimento_solic, 
	ie_origem_proced, 
	coalesce(dt_inicio_val_apac,clock_timestamp()), 
	coalesce(dt_fim_val_apac,clock_timestamp()), 
	dt_pri_tratamento, 
	dt_seg_tratamento, 
	dt_ter_tratamento, 
	cd_cid_principal, 
	cd_cid_secundario, 
	ie_finalidade, 
	qt_meses_prev, 
	dt_inicio_trat_solic, 
	qt_meses_prev, 
	qt_total_campo_prev, 
	dt_diag_cito_hist, 
	nr_seq_interno, 
	coalesce(ie_metastase,'N'), 
	cd_cid_morfologia, 
	dt_emissao 
into STRICT	cd_procedimento_w, 
	ie_origem_proced_w, 
	dt_inicio_val_apac_w, 
	dt_fim_val_apac_w, 
	dt_pri_tratamento_w, 
	dt_seg_tratamento_w, 
	dt_ter_tratamento_w, 
	cd_cid_principal_w, 
	cd_cid_secundario_w, 
	ie_finalidade_w, 
	qt_meses_prev_w, 
	dt_inicio_trat_solic_w, 
	qt_meses_prev_w, 
	qt_total_campo_prev_w, 
	dt_diagnostico_w, 
	nr_seq_interno_w, 
	ie_metastase_w, 
	cd_cid_morfologia_w, 
	dt_emissao_w 
from	sus_laudo_paciente 
where	nr_apac	= nr_apac_p;
exception 
	when others then 
	--r.aise_application_error(-20011,'Número de APAC inválido pois não existe nenhum laudo vinculado à esta APAC!'); 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(263323);
end;
 
begin 
select	max((ds_estadio_uicc)::numeric ) 
into STRICT	cd_estadio_w 
from	sus_laudo_paciente 
where	nr_apac	= nr_apac_p;
exception 
when others then 
	select	Max(CASE WHEN upper(ds_estadio_uicc)='I' THEN 1 WHEN upper(ds_estadio_uicc)='II' THEN 2 WHEN upper(ds_estadio_uicc)='III' THEN 3 WHEN upper(ds_estadio_uicc)='IV' THEN 4 END ) 
	into STRICT	cd_estadio_w 
	from	sus_laudo_paciente 
	where	nr_apac	= nr_apac_p;
end;
 
select	cd_estabelecimento, 
	cd_medico_resp, 
	cd_pessoa_fisica 
into STRICT	cd_estabelecimento_w, 
	cd_medico_resp_w, 
	cd_pessoa_fisica_w 
from	atendimento_paciente 
where	nr_atendimento	= nr_atendimento_p;
 
select	nr_cartao_nac_sus, 
	cd_nacionalidade 
into STRICT	nr_cartao_nac_sus_w, 
	cd_nacionalidade_w 
from	pessoa_fisica 
where	cd_pessoa_fisica	= cd_pessoa_fisica_w;
 
select	dt_competencia_apac, 
	cd_unidade_apac 
into STRICT	dt_competencia_apac_w, 
	cd_unidade_w 
from	sus_parametros 
where	cd_estabelecimento	= cd_estabelecimento_w;
 
select	nextval('sus_apac_movto_seq') 
into STRICT	nr_sequencia_w
;
 
begin 
select	cd_varia_atrib, 
	cd_tratamento 
into STRICT	cd_varia_atrib_w, 
	cd_tratamento_w 
from 	sus_apac_regra_tela 
where 	cd_proc_principal 	= cd_procedimento_w 
and 	cd_proc_secundario 	= cd_procedimento_w 
and	ie_origem_proc_princ	= 3 
and 	ie_origem_proc_secun	= 3;
exception 
	when others then 
	--r.aise_application_error(-20011,'Procedimento do laudo incompatível com APAC!'); 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(263324);
end;
 
begin 
select	obter_setor_atendimento(nr_atendimento_p) 
into STRICT	cd_setor_atendimento_w
;
exception 
	when others then 
	--r.aise_application_error(-20011,'Atendimento sem registro de unidade/setor'); 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(263325);
end;
 
cd_motivo_cobranca_w	:= cd_motivo_cobranca_p;
if (coalesce(cd_motivo_cobranca_w::text, '') = '') then 
	select	max(a.cd_item_seg_tabela) 
	into STRICT	cd_motivo_cobranca_w 
	from	sus_s_cdx		a, 
	    sus_motivo_cobr_apac	b 
	where	a.cd_pri_tabela		= '20' 
	and	a.cd_seg_tabela 	= '30' 
	and 	a.cd_item_pri_tabela 	= cd_procedimento_w 
	and 	b.cd_motivo_cobranca 	= a.cd_item_seg_tabela;
end if;
 
if (cd_varia_atrib_w	= '27') then 
	insert into sus_apac_movto( 
		nr_sequencia, 
		nr_apac, 
		nr_atendimento, 
		dt_competencia, 
		cd_unidade, 
		cd_proc_principal, 
		ie_origem_proc_princ, 
		dt_inicio_validade, 
		dt_fim_validade, 
		dt_emissao, 
		ie_tipo_apac, 
		cd_motivo_cobranca, 
		cd_medico_resp, 
		cd_tratamento, 
		cd_varia_atrib, 
		nr_cartao_nac_sus, 
		dt_atualizacao, 
		nm_usuario, 
		dt_inicio_tratamento, 
		cd_cid_principal, 
		cd_cid_secundario, 
		cd_estagio, 
		ie_metastase, 
		cd_setor_atendimento, 
		cd_nacionalidade) 
	values (	nr_sequencia_w, 
		nr_apac_p, 
		nr_atendimento_p, 
		dt_competencia_apac_w, 
		cd_unidade_w, 
		cd_procedimento_w, 
		ie_origem_proced_w, 
		dt_inicio_val_apac_w, 
		dt_fim_val_apac_w, 
		dt_emissao_w, 
		1, 
		cd_motivo_cobranca_w, 
		cd_medico_resp_w, 
		cd_tratamento_w, 
		cd_varia_atrib_w, 
		substr(nr_cartao_nac_sus_w,1,15), 
		clock_timestamp(), 
		nm_usuario_p, 
		dt_inicio_trat_solic_w, 
		cd_cid_principal_w, 
		cd_cid_secundario_w, 
		cd_estadio_w, 
		ie_metastase_w, 
		cd_setor_atendimento_w, 
		cd_nacionalidade_w);
 
elsif (cd_varia_atrib_w	= '28') then 
	open c01;
	loop 
	fetch c01 into 
		cd_doenca_cid_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin 
		if (qt_cursor_w	= 1) then 
			cd_cid_pri_radiacao_w	:= cd_doenca_cid_w;
		elsif (qt_cursor_w	= 2) then 
			cd_cid_seg_radiacao_w	:= cd_doenca_cid_w;
		elsif (qt_cursor_w	= 3) then 
			cd_cid_ter_radiacao_w	:= cd_doenca_cid_w;
		end if;
		qt_cursor_w	:= qt_cursor_w + 1;
		end;
	end loop;
	close c01;
 
	insert into sus_apac_movto( 
		nr_sequencia, 
		nr_apac, 
		nr_atendimento, 
		dt_competencia, 
		cd_unidade, 
		cd_proc_principal, 
		ie_origem_proc_princ, 
		dt_inicio_validade, 
		dt_fim_validade, 
		dt_emissao, 
		ie_tipo_apac, 
		cd_motivo_cobranca, 
		cd_medico_resp, 
		cd_tratamento, 
		cd_varia_atrib, 
		nr_cartao_nac_sus, 
		dt_atualizacao, 
		nm_usuario, 
		dt_inicio_tratamento, 
		cd_cid_topografia, 
		ie_finalidade, 
		dt_diagnostico, 
		dt_pri_tratamento, 
		dt_seg_tratamento, 
		dt_ter_tratamento, 
		cd_cid_pri_radiacao, 
		cd_cid_seg_radiacao, 
		cd_cid_ter_radiacao, 
		qt_campo_planejado, 
		cd_estagio, 
		ie_metastase, 
		cd_cid_morfologia, 
		cd_setor_atendimento, 
		cd_nacionalidade) 
	values (	nr_sequencia_w, 
		nr_apac_p, 
		nr_atendimento_p, 
		dt_competencia_apac_w, 
		cd_unidade_w, 
		cd_procedimento_w, 
		ie_origem_proced_w, 
		dt_inicio_val_apac_w, 
		dt_fim_val_apac_w, 
		dt_emissao_w, 
		1, 
		cd_motivo_cobranca_w, 
		cd_medico_resp_w, 
		cd_tratamento_w, 
		cd_varia_atrib_w, 
		substr(nr_cartao_nac_sus_w,1,15), 
		clock_timestamp(), 
		nm_usuario_p, 
		dt_inicio_trat_solic_w, 
		cd_cid_principal_w, 
		ie_finalidade_w, 
		dt_diagnostico_w, 
		dt_pri_tratamento_w, 
		dt_seg_tratamento_w, 
		dt_ter_tratamento_w, 
		cd_cid_pri_radiacao_w, 
		cd_cid_seg_radiacao_w, 
		cd_cid_ter_radiacao_w, 
		qt_total_campo_prev_w, 
		cd_estadio_w, 
		ie_metastase_w, 
		cd_cid_morfologia_w, 
		cd_setor_atendimento_w, 
		cd_nacionalidade_w);
 
elsif (cd_varia_atrib_w	= '29') then 
	insert into sus_apac_movto( 
		nr_sequencia, 
		nr_apac, 
		nr_atendimento, 
		dt_competencia, 
		cd_unidade, 
		cd_proc_principal, 
		ie_origem_proc_princ, 
		dt_inicio_validade, 
		dt_fim_validade, 
		dt_emissao, 
		ie_tipo_apac, 
		cd_motivo_cobranca, 
		cd_medico_resp, 
		cd_tratamento, 
		cd_varia_atrib, 
		nr_cartao_nac_sus, 
		dt_atualizacao, 
		nm_usuario, 
		dt_inicio_tratamento, 
		cd_cid_topografia, 
		dt_diagnostico, 
		dt_pri_tratamento, 
		dt_seg_tratamento, 
		dt_ter_tratamento, 
		qt_meses_prev, 
		cd_estagio, 
		ie_metastase, 
		cd_cid_morfologia, 
		cd_setor_atendimento, 
		cd_nacionalidade) 
	values (	nr_sequencia_w, 
		nr_apac_p, 
		nr_atendimento_p, 
		dt_competencia_apac_w, 
		cd_unidade_w, 
		cd_procedimento_w, 
		ie_origem_proced_w, 
		dt_inicio_val_apac_w, 
		dt_fim_val_apac_w, 
		dt_emissao_w, 
		1, 
		cd_motivo_cobranca_w, 
		cd_medico_resp_w, 
		cd_tratamento_w, 
		cd_varia_atrib_w, 
		substr(nr_cartao_nac_sus_w,1,15), 
		clock_timestamp(), 
		nm_usuario_p, 
		dt_inicio_trat_solic_w, 
		cd_cid_principal_w, 
		dt_diagnostico_w, 
		dt_pri_tratamento_w, 
		dt_seg_tratamento_w, 
		dt_ter_tratamento_w, 
		qt_meses_prev_w, 
		cd_estadio_w, 
		ie_metastase_w, 
		cd_cid_morfologia_w, 
		cd_setor_atendimento_w, 
		cd_nacionalidade_w);
 
elsif (cd_varia_atrib_w	= '36') then 
	insert into sus_apac_movto( 
		nr_sequencia, 
		nr_apac, 
		nr_atendimento, 
		dt_competencia, 
		cd_unidade, 
		cd_proc_principal, 
		ie_origem_proc_princ, 
		dt_inicio_validade, 
		dt_fim_validade, 
		dt_emissao, 
		ie_tipo_apac, 
		cd_motivo_cobranca, 
		cd_medico_resp, 
		cd_tratamento, 
		cd_varia_atrib, 
		nr_cartao_nac_sus, 
		dt_atualizacao, 
		nm_usuario, 
		dt_inicio_tratamento, 
		cd_cid_principal, 
		cd_cid_secundario, 
		cd_estagio, 
		ie_metastase, 
		cd_setor_atendimento, 
		cd_nacionalidade) 
	values (	nr_sequencia_w, 
		nr_apac_p, 
		nr_atendimento_p, 
		dt_competencia_apac_w, 
		cd_unidade_w, 
		cd_procedimento_w, 
		ie_origem_proced_w, 
		dt_inicio_val_apac_w, 
		dt_fim_val_apac_w, 
		dt_emissao_w, 
		1, 
		cd_motivo_cobranca_w, 
		cd_medico_resp_w, 
		cd_tratamento_w, 
		cd_varia_atrib_w, 
		substr(nr_cartao_nac_sus_w,1,15), 
		clock_timestamp(), 
		nm_usuario_p, 
		dt_inicio_trat_solic_w, 
		cd_cid_principal_w, 
		cd_cid_secundario_w, 
		cd_estadio_w, 
		ie_metastase_w, 
		cd_setor_atendimento_w, 
		cd_nacionalidade_w);
 
elsif (cd_varia_atrib_w	= '11') then 
	insert into sus_apac_movto( 
		nr_sequencia, 
		nr_apac, 
		nr_atendimento, 
		dt_competencia, 
		cd_unidade, 
		cd_proc_principal, 
		ie_origem_proc_princ, 
		dt_inicio_validade, 
		dt_fim_validade, 
		dt_emissao, 
		ie_tipo_apac, 
		cd_motivo_cobranca, 
		cd_medico_resp, 
		cd_tratamento, 
		cd_varia_atrib, 
		nr_cartao_nac_sus, 
		dt_atualizacao, 
		nm_usuario, 
		cd_cid_principal, 
		cd_estagio, 
		ie_metastase, 
		cd_setor_atendimento, 
		cd_nacionalidade) 
	values (	nr_sequencia_w, 
		nr_apac_p, 
		nr_atendimento_p, 
		dt_competencia_apac_w, 
		cd_unidade_w, 
		cd_procedimento_w, 
		ie_origem_proced_w, 
		dt_inicio_val_apac_w, 
		dt_fim_val_apac_w, 
		dt_emissao_w, 
		1, 
		cd_motivo_cobranca_w, 
		cd_medico_resp_w, 
		cd_tratamento_w, 
		cd_varia_atrib_w, 
		substr(nr_cartao_nac_sus_w,1,15), 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_cid_principal_w, 
		cd_estadio_w, 
		ie_metastase_w, 
		cd_setor_atendimento_w, 
		cd_nacionalidade_w);
 
elsif (cd_varia_atrib_w	= 'A1') then 
	insert into sus_apac_movto( 
		nr_sequencia, 
		nr_apac, 
		nr_atendimento, 
		dt_competencia, 
		cd_unidade, 
		cd_proc_principal, 
		ie_origem_proc_princ, 
		dt_inicio_validade, 
		dt_fim_validade, 
		dt_emissao, 
		ie_tipo_apac, 
		cd_motivo_cobranca, 
		cd_medico_resp, 
		cd_tratamento, 
		cd_varia_atrib, 
		nr_cartao_nac_sus, 
		dt_atualizacao, 
		nm_usuario, 
		cd_cid_principal, 
		cd_estagio, 
		ie_metastase, 
		cd_setor_atendimento, 
		cd_nacionalidade) 
	values (	nr_sequencia_w, 
		nr_apac_p, 
		nr_atendimento_p, 
		dt_competencia_apac_w, 
		cd_unidade_w, 
		cd_procedimento_w, 
		ie_origem_proced_w, 
		dt_inicio_val_apac_w, 
		dt_fim_val_apac_w, 
		dt_emissao_w, 
		1, 
		cd_motivo_cobranca_w, 
		cd_medico_resp_w, 
		cd_tratamento_w, 
		cd_varia_atrib_w, 
		substr(nr_cartao_nac_sus_w,1,15), 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_cid_principal_w, 
		cd_estadio_w, 
		ie_metastase_w, 
		cd_setor_atendimento_w, 
		cd_nacionalidade_w);
 
elsif (cd_varia_atrib_w	= 'A2') then 
	insert into sus_apac_movto( 
		nr_sequencia, 
		nr_apac, 
		nr_atendimento, 
		dt_competencia, 
		cd_unidade, 
		cd_proc_principal, 
		ie_origem_proc_princ, 
		dt_inicio_validade, 
		dt_fim_validade, 
		dt_emissao, 
		ie_tipo_apac, 
		cd_motivo_cobranca, 
		cd_medico_resp, 
		cd_tratamento, 
		cd_varia_atrib, 
		nr_cartao_nac_sus, 
		dt_atualizacao, 
		nm_usuario, 
		cd_cid_principal, 
		cd_estagio, 
		ie_metastase, 
		cd_setor_atendimento, 
		cd_nacionalidade) 
	values (	nr_sequencia_w, 
		nr_apac_p, 
		nr_atendimento_p, 
		dt_competencia_apac_w, 
		cd_unidade_w, 
		cd_procedimento_w, 
		ie_origem_proced_w, 
		dt_inicio_val_apac_w, 
		dt_fim_val_apac_w, 
		dt_emissao_w, 
		1, 
		cd_motivo_cobranca_w, 
		cd_medico_resp_w, 
		cd_tratamento_w, 
		cd_varia_atrib_w, 
		substr(nr_cartao_nac_sus_w,1,15), 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_cid_principal_w, 
		cd_estadio_w, 
		ie_metastase_w, 
		cd_setor_atendimento_w, 
		cd_nacionalidade_w);
 
elsif (cd_varia_atrib_w	= '08') then 
	insert into sus_apac_movto( 
		nr_sequencia, 
		nr_apac, 
		nr_atendimento, 
		dt_competencia, 
		cd_unidade, 
		cd_proc_principal, 
		ie_origem_proc_princ, 
		dt_inicio_validade, 
		dt_fim_validade, 
		dt_emissao, 
		ie_tipo_apac, 
		cd_motivo_cobranca, 
		cd_medico_resp, 
		cd_tratamento, 
		cd_varia_atrib, 
		nr_cartao_nac_sus, 
		dt_atualizacao, 
		nm_usuario, 
		cd_cid_principal, 
		cd_estagio, 
		ie_metastase, 
		cd_setor_atendimento, 
		cd_nacionalidade) 
	values (	nr_sequencia_w, 
		nr_apac_p, 
		nr_atendimento_p, 
		dt_competencia_apac_w, 
		cd_unidade_w, 
		cd_procedimento_w, 
		ie_origem_proced_w, 
		dt_inicio_val_apac_w, 
		dt_fim_val_apac_w, 
		dt_emissao_w, 
		1, 
		cd_motivo_cobranca_w, 
		cd_medico_resp_w, 
		cd_tratamento_w, 
		cd_varia_atrib_w, 
		substr(nr_cartao_nac_sus_w,1,15), 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_cid_principal_w, 
		cd_estadio_w, 
		ie_metastase_w, 
		cd_setor_atendimento_w, 
		cd_nacionalidade_w);
 
elsif (cd_varia_atrib_w	= '10') then 
	insert into sus_apac_movto( 
		nr_sequencia, 
		nr_apac, 
		nr_atendimento, 
		dt_competencia, 
		cd_unidade, 
		cd_proc_principal, 
		ie_origem_proc_princ, 
		dt_inicio_validade, 
		dt_fim_validade, 
		dt_emissao, 
		ie_tipo_apac, 
		cd_motivo_cobranca, 
		cd_medico_resp, 
		cd_tratamento, 
		cd_varia_atrib, 
		nr_cartao_nac_sus, 
		dt_atualizacao, 
		nm_usuario, 
		cd_cid_principal, 
		cd_estagio, 
		ie_metastase, 
		cd_setor_atendimento, 
		cd_nacionalidade) 
	values (	nr_sequencia_w, 
		nr_apac_p, 
		nr_atendimento_p, 
		dt_competencia_apac_w, 
		cd_unidade_w, 
		cd_procedimento_w, 
		ie_origem_proced_w, 
		dt_inicio_val_apac_w, 
		dt_fim_val_apac_w, 
		dt_emissao_w, 
		1, 
		cd_motivo_cobranca_w, 
		cd_medico_resp_w, 
		cd_tratamento_w, 
		cd_varia_atrib_w, 
		substr(nr_cartao_nac_sus_w,1,15), 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_cid_principal_w, 
		cd_estadio_w, 
		ie_metastase_w, 
		cd_setor_atendimento_w, 
		cd_nacionalidade_w);
 
elsif (cd_varia_atrib_w	= '21') then 
	insert into sus_apac_movto( 
		nr_sequencia, 
		nr_apac, 
		nr_atendimento, 
		dt_competencia, 
		cd_unidade, 
		cd_proc_principal, 
		ie_origem_proc_princ, 
		dt_inicio_validade, 
		dt_fim_validade, 
		dt_emissao, 
		ie_tipo_apac, 
		cd_motivo_cobranca, 
		cd_medico_resp, 
		cd_tratamento, 
		cd_varia_atrib, 
		nr_cartao_nac_sus, 
		dt_atualizacao, 
		nm_usuario, 
		cd_cid_principal, 
		cd_estagio, 
		ie_metastase, 
		cd_setor_atendimento, 
		cd_nacionalidade) 
	values (	nr_sequencia_w, 
		nr_apac_p, 
		nr_atendimento_p, 
		dt_competencia_apac_w, 
		cd_unidade_w, 
		cd_procedimento_w, 
		ie_origem_proced_w, 
		dt_inicio_val_apac_w, 
		dt_fim_val_apac_w, 
		dt_emissao_w, 
		1, 
		cd_motivo_cobranca_w, 
		cd_medico_resp_w, 
		cd_tratamento_w, 
		cd_varia_atrib_w, 
		substr(nr_cartao_nac_sus_w,1,15), 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_cid_principal_w, 
		cd_estadio_w, 
		ie_metastase_w, 
		cd_setor_atendimento_w, 
		cd_nacionalidade_w);
end if;
 
commit;
 
CALL adicionar_sus_apac_proc(nr_sequencia_w, nm_usuario_p);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_apac_laudo ( nr_apac_p bigint, nr_atendimento_p bigint, cd_motivo_cobranca_p bigint, nm_usuario_p text) FROM PUBLIC;

