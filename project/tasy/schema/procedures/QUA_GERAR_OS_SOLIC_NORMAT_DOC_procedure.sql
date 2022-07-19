-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qua_gerar_os_solic_normat_doc ( ds_dano_breve_p text, ds_dano_p text, nm_usuario_p text, nr_ordem_servico_p INOUT bigint, nr_seq_tipo_p bigint, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
nr_sequencia_w			bigint;
cd_pessoa_solic_w		varchar(10);
ds_dano_breve_w			varchar(80);
ds_dano_w			varchar(4000);
nr_seq_regra_w			bigint;
nr_seq_estagio_w		bigint;
nm_usuario_exec_w		varchar(15);
ie_usuario_exec_w		smallint;
nr_seq_funcao_w			bigint;
nr_seq_tipo_exec_w		bigint;
qt_minuto_w			bigint;
nr_grupo_trab_w			bigint;
nr_grupo_planej_w		bigint;
nm_user_w			varchar(60);
cd_documento_w			varchar(20);
nr_seq_publico_alvo_w		bigint;
nr_seq_documento_w		bigint;
qt_minuto_sum_w			double precision;
dt_fim_previsto_w		timestamp;
qt_dia_w			integer;

C01 CURSOR FOR 
	SELECT	nm_usuario_exec, 
		nr_seq_funcao, 
		nr_seq_tipo_exec, 
		qt_minuto 
	from	qua_regra_define_os_exec 
	where	nr_seq_regra = nr_seq_regra_w;		
	 
C02 CURSOR FOR 
	SELECT	nr_sequencia 
	from	qua_publico_alvo 
	where	nm_usuario_nrec = nm_usuario_p 
	and	nr_seq_ordem = nr_sequencia_w;


BEGIN 
 
select	nextval('man_ordem_servico_seq') 
into STRICT	nr_sequencia_w
;
 
select	substr(obter_pessoa_fisica_usuario(nm_usuario_p,'C'),1,10) cd_pf_abertura 
into STRICT	cd_pessoa_solic_w
;
 
select	substr(user,1,4) 
into STRICT	nm_user_w
;
 
ds_dano_breve_w := substr(ds_dano_breve_p,1,80);
ds_dano_w := substr(ds_dano_p,1,4000);
 
if (nm_user_w = 'CORP') then 
	begin 
	nr_grupo_trab_w		:= 12;
	nr_grupo_planej_w 	:= 21;
	nr_seq_estagio_w 	:= 1272;
	end;
end if;
		 
select	coalesce(max(nr_sequencia),0), 
	coalesce(max(qt_dia),1) 
into STRICT	nr_seq_regra_w, 
	qt_dia_w 
from	qua_regra_define_os 
where	clock_timestamp() between coalesce(dt_inicio_vigencia,clock_timestamp()) and coalesce(fim_dia(dt_fim_vigencia),clock_timestamp()) 
and	((coalesce(ie_tipo_os_qualidade::text, '') = '') or (ie_tipo_os_qualidade = '11'));
 
select	coalesce(sum(a.qt_minuto),0) 
into STRICT	qt_minuto_sum_w 
from	qua_regra_define_os_exec a 
where	a.nr_seq_regra = nr_seq_regra_w;
 
dt_fim_previsto_w := (clock_timestamp() + coalesce(qt_dia_w,1));
 
insert	into man_ordem_servico( 
	cd_pessoa_solicitante, 
	ds_dano_breve, 
	ds_dano, 
	dt_atualizacao, 
	dt_ordem_servico, 
	ie_origem_os, 
	ie_parado, 
	ie_prioridade, 
	ie_status_ordem, 
	ie_tipo_ordem, 
	nr_grupo_trabalho, 
	nr_grupo_planej, 
	nm_usuario, 
	nr_sequencia, 
	nr_seq_estagio, 
	dt_inicio_previsto, 
	dt_fim_previsto) 
values (	cd_pessoa_solic_w, 
	ds_dano_breve_w, 
	ds_dano_w,	 
	clock_timestamp(), 
	clock_timestamp(), 
	'6', 
	'N', 
	'M', 
	'1', 
	11, 
	nr_grupo_trab_w, 
	nr_grupo_planej_w, 
	nm_usuario_p, 
	nr_sequencia_w, 
	nr_seq_estagio_w, 
	clock_timestamp(), 
	dt_fim_previsto_w);
	 
open C01;
loop 
fetch C01 into 
	nm_usuario_exec_w, 
	nr_seq_funcao_w, 
	nr_seq_tipo_exec_w, 
	qt_minuto_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	ie_usuario_exec_w := 0;	
	 
	select	count(*) 
	into STRICT	ie_usuario_exec_w	 
	from	man_ordem_servico_exec 
	where	nr_seq_ordem = nr_sequencia_w 
	and 	nm_usuario_exec = nm_usuario_exec_w;
	 
	if (nm_usuario_exec_w IS NOT NULL AND nm_usuario_exec_w::text <> '') and (ie_usuario_exec_w = 0) then 
		begin 
		insert	into man_ordem_servico_exec( 
			nr_sequencia, 
			nr_seq_ordem, 
			dt_atualizacao, 
			nm_usuario, 
			nm_usuario_exec, 
			nr_seq_funcao, 
			nr_seq_tipo_exec, 
			qt_min_prev) 
		values (	nextval('man_ordem_servico_exec_seq'), 
			nr_sequencia_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			nm_usuario_exec_w, 
			nr_seq_funcao_w, 
			nr_seq_tipo_exec_w, 
			qt_minuto_w);
		end;
	end if;
	end;
end loop;
close C01;
	 
update	qua_publico_alvo 
set	nr_seq_ordem = nr_sequencia_w 
where	nm_usuario_nrec = nm_usuario_p 
and	coalesce(nr_seq_ordem::text, '') = '';
 
 
select 	max(campo_numerico(cd_documento)) + 1 
into STRICT	cd_documento_w 
from	qua_documento;
 
select	nextval('qua_documento_seq') 
into STRICT	nr_seq_documento_w
;
 
insert into qua_documento(	 
	CD_DOCUMENTO, 
	NR_SEQUENCIA, 
	IE_STATUS, 
	IE_SITUACAO, 
	NM_DOCUMENTO, 
	NR_SEQ_TIPO, 
	CD_ESTABELECIMENTO, 
	DT_ATUALIZACAO, 
	NM_USUARIO, 
	DT_EMISSAO, 
	NM_USUARIO_NREC, 
	DT_ATUALIZACAO_NREC) 
values (	cd_documento_w, 
	nr_seq_documento_w, 
	'P', 
	'A', 
	ds_dano_breve_p, 
	nr_seq_tipo_p, 
	cd_estabelecimento_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	clock_timestamp());
	 
update	man_ordem_servico 
set	nr_seq_documento = nr_seq_documento_w 
where	nr_sequencia = nr_sequencia_w;	
 
insert into qua_doc_lib(	ie_atualizacao, 
				nr_sequencia, 
				nr_seq_doc, 
				dt_atualizacao, 
				nm_usuario, 
				nm_usuario_nrec, 
				dt_atualizacao_nrec, 
				cd_perfil,		 
				cd_setor_atendimento,		 
				nr_seq_grupo_cargo, 
				nr_seq_grupo_usuario) 
		values (	'S', 
				nextval('qua_doc_lib_seq'), 
				nr_seq_documento_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				nm_usuario_p, 
				clock_timestamp(), 
				null, 
				3, 
				null, 
				null);
 
open C02;
loop 
fetch C02 into	 
	nr_seq_publico_alvo_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin 
	insert into qua_doc_lib(	 
		IE_ATUALIZACAO, 
		NR_SEQUENCIA, 
		NR_SEQ_DOC, 
		DT_ATUALIZACAO, 
		NM_USUARIO, 
		NM_USUARIO_NREC, 
		DT_ATUALIZACAO_NREC, 
		CD_PERFIL,		 
		CD_SETOR_ATENDIMENTO,		 
		NR_SEQ_GRUPO_CARGO, 
		NR_SEQ_GRUPO_USUARIO 
		) 
	SELECT	'N', 
		nextval('qua_doc_lib_seq'), 
		nr_seq_documento_w, 
		clock_timestamp(), 
		nm_usuario_p, 
		nm_usuario_p, 
		clock_timestamp(), 
		cd_perfil, 
		cd_setor_atendimento, 
		nr_seq_grupo_cargo, 
		nr_seq_grupo_usuario 
	from	qua_publico_alvo 
	where	nr_sequencia = nr_seq_publico_alvo_w;
	end;
end loop;
close C02;
	 
	 
commit;
 
nr_ordem_servico_p := nr_sequencia_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qua_gerar_os_solic_normat_doc ( ds_dano_breve_p text, ds_dano_p text, nm_usuario_p text, nr_ordem_servico_p INOUT bigint, nr_seq_tipo_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

