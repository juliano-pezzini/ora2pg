-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_duplicar_os ( nr_sequencia_p bigint, nm_usuario_p text, ie_copia_status_p text, ie_copia_estagio_p text, nr_seq_copia_p INOUT bigint) AS $body$
DECLARE




nr_seq_copia_w			bigint;
nr_seq_localizacao_w		bigint;
nr_seq_equipamento_w		bigint;
cd_pessoa_solicitante_w		varchar(10);
ie_prioridade_w			varchar(1);
ie_parado_w			varchar(1);
ie_tipo_ordem_w			integer;
ie_status_ordem_w		varchar(1);
nr_grupo_planej_w		bigint;
nr_grupo_trabalho_w		bigint;
nr_seq_estagio_w		bigint;
ie_classificacao_w		varchar(1);
ie_copia_descricao_w		varchar(1)	:= 'N';
ds_dano_breve_w			varchar(80)	:= ' ';
ds_dano_w			varchar(4000)	:= ' ';
ie_origem_os_w			varchar(15);
ie_forma_receb_w		varchar(01);
nr_seq_origem_dano_w		bigint;
nr_seq_tipo_ordem_w		bigint;
nr_seq_causa_dano_w		bigint;
nr_seq_complex_w		bigint;
cd_funcao_w			integer;
ds_contato_solicitante_w	varchar(255);
ds_relat_tecnico_w		varchar(255);
dt_conclusao_desej_w		timestamp;
nr_seq_severidade_wheb_w	bigint;
nr_seq_severidade_w		bigint;
nr_seq_cliente_w		bigint;
ie_plataforma_w			man_ordem_servico.ie_plataforma%type;


BEGIN
select	nextval('man_ordem_servico_seq')
into STRICT	nr_seq_copia_w
;

nr_seq_copia_p		:= nr_seq_copia_w;
ds_relat_tecnico_w	:= substr(wheb_mensagem_pck.get_texto(305775, 'NR_SEQUENCIA_P=' || NR_SEQUENCIA_P),1,255);

select	nr_seq_localizacao,
	nr_seq_equipamento,
	cd_pessoa_solicitante,
	ie_prioridade,
	ie_parado,
	ie_tipo_ordem,
	CASE WHEN ie_copia_status_p='S' THEN		CASE WHEN ie_status_ordem='3' THEN '1'  ELSE ie_status_ordem END   ELSE '1' END ,
	nr_grupo_planej,
	nr_grupo_trabalho,
	nr_seq_estagio,
	ie_classificacao,
	coalesce(ie_origem_os,'1'),
	ie_forma_receb,
	nr_seq_origem_dano,
	nr_seq_tipo_ordem,
	nr_seq_causa_dano,
	nr_seq_complex,
	cd_funcao,
	ds_contato_solicitante,
	dt_conclusao_desejada,
	nr_seq_severidade_wheb,
	nr_seq_severidade,
	nr_seq_cliente,
	ie_plataforma
into STRICT	nr_seq_localizacao_w,
	nr_seq_equipamento_w,
	cd_pessoa_solicitante_w,
	ie_prioridade_w,
	ie_parado_w,
	ie_tipo_ordem_w,
	ie_status_ordem_w,
	nr_grupo_planej_w,
	nr_grupo_trabalho_w,
	nr_seq_estagio_w,
	ie_classificacao_w,
	ie_origem_os_w,
	ie_forma_receb_w,
	nr_seq_origem_dano_w,
	nr_seq_tipo_ordem_w,
	nr_seq_causa_dano_w,
	nr_seq_complex_w,
	cd_funcao_w,
	ds_contato_solicitante_w,
	dt_conclusao_desej_w,
	nr_seq_severidade_wheb_w,
	nr_seq_severidade_w,
	nr_seq_cliente_w,
	ie_plataforma_w
from	man_ordem_servico
where	nr_sequencia	= nr_sequencia_p;

ds_dano_breve_w		:= ' ';
ds_dano_w		:= ' ';

ie_copia_descricao_w	:= coalesce(obter_valor_param_usuario(299, 172, obter_perfil_ativo, nm_usuario_p, 0),'N');

if (ie_copia_descricao_w = 'S') then
	select	ds_dano_breve,
		ds_dano
	into STRICT	ds_dano_breve_w,
		ds_dano_w
	from	man_ordem_servico
	where	nr_sequencia	= nr_sequencia_p;
end if;

insert into man_ordem_servico(nr_sequencia,
	nr_seq_localizacao,
	nr_seq_equipamento,
	cd_pessoa_solicitante,
	dt_ordem_servico,
	ie_prioridade,
	ie_parado,
	ds_dano_breve,
	dt_atualizacao,
	nm_usuario,
	dt_inicio_desejado,
	ie_tipo_ordem,
	ie_status_ordem,
	nr_grupo_planej,
	nr_grupo_trabalho,
	nr_seq_estagio,
	ie_classificacao,
	ds_dano,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	ie_origem_os,
	ie_forma_receb,
	nr_seq_origem_dano,
	nr_seq_tipo_ordem,
	nr_seq_causa_dano,
	nr_seq_complex,
	cd_funcao,
	ds_contato_solicitante,
	dt_conclusao_desejada,
	nr_seq_severidade_wheb,
	nr_seq_severidade,
	nr_seq_cliente,
	ie_plataforma)
values (nr_seq_copia_w,
	nr_seq_localizacao_w,
	nr_seq_equipamento_w,
	cd_pessoa_solicitante_w,
	clock_timestamp(),
	ie_prioridade_w,
	ie_parado_w,
	ds_dano_breve_w,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	ie_tipo_ordem_w,
	ie_status_ordem_w,
	nr_grupo_planej_w,
	nr_grupo_trabalho_w,
	CASE WHEN ie_copia_estagio_p='S' THEN  nr_seq_estagio_w  ELSE '' END ,
	ie_classificacao_w,
	ds_dano_w,
	clock_timestamp(),
	nm_usuario_p,
	ie_origem_os_w,
	ie_forma_receb_w,
	nr_seq_origem_dano_w,
	nr_seq_tipo_ordem_w,
	nr_seq_causa_dano_w,
	nr_seq_complex_w,
	cd_funcao_w,
	ds_contato_solicitante_w,
	dt_conclusao_desej_w,
	nr_seq_severidade_wheb_w,
	nr_seq_severidade_w,
	nr_seq_cliente_w,
	ie_plataforma_w);
	
insert into man_ordem_servico_exec(nr_sequencia,
	nr_seq_ordem,
	dt_atualizacao,
	nm_usuario,
	nm_usuario_exec,
	qt_min_prev,
	dt_ult_visao,
	nr_seq_funcao,
	dt_recebimento,
	nr_seq_tipo_exec)
SELECT	nextval('man_ordem_servico_exec_seq'),
	nr_seq_copia_w,
	clock_timestamp(),
	nm_usuario_p,
	nm_usuario_exec,
	qt_min_prev,
	null,
	nr_seq_funcao,
	dt_recebimento,
	nr_seq_tipo_exec
from	man_ordem_servico_exec	a
where	nr_seq_ordem = nr_sequencia_p
and	not exists (SELECT	1
			from	man_ordem_servico_exec	x
			where	x.nm_usuario_exec	= a.nm_usuario_exec
			and	x.nr_seq_ordem		= nr_seq_copia_w);

insert into man_ordem_serv_tecnico(nr_sequencia,
	nr_seq_ordem_serv,
	dt_atualizacao,
	nm_usuario,
	ds_relat_tecnico,
	dt_historico,
	dt_liberacao,
	nm_usuario_lib,
	ie_origem)
values (nextval('man_ordem_serv_tecnico_seq'),
	nr_seq_copia_p,
	clock_timestamp(),
	nm_usuario_p,
	ds_relat_tecnico_w,
	clock_timestamp(),
	clock_timestamp(),
	nm_usuario_p,
	'I');

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_duplicar_os ( nr_sequencia_p bigint, nm_usuario_p text, ie_copia_status_p text, ie_copia_estagio_p text, nr_seq_copia_p INOUT bigint) FROM PUBLIC;
