-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cm_gerar_conj_retorno_atend ( nr_seq_conjunto_p bigint, nm_usuario_p text) AS $body$
DECLARE



nr_seq_conjunto_w		bigint;
nr_seq_embalagem_w		bigint;
cd_local_estoque_w		bigint;
cd_setor_atend_orig_w		integer;
cd_pessoa_fisica_w		varchar(10);
cd_cgc_w			varchar(14);
nr_seq_cliente_w			bigint;
cd_setor_atendimento_w		integer;
cd_pessoa_resp_w			varchar(10);
ie_tipo_esterilizacao_w		varchar(2);
vl_esterilizacao_w			double precision;
qt_ponto_w			double precision;
nr_seq_controle_w			bigint;
nr_sequencia_w			bigint;
cd_estabelecimento_w		smallint;
dt_validade_w			timestamp;
cd_local_estoque_param_w	bigint;


BEGIN

select	cd_estabelecimento,
	nr_seq_conjunto,
	nr_seq_embalagem,
	cd_local_estoque,
	cd_setor_atend_orig,
	cd_pessoa_fisica,
	cd_cgc,
	nr_seq_cliente,
	cd_setor_atendimento,
	cd_pessoa_resp,
	ie_tipo_esterilizacao,
	vl_esterilizacao,
	qt_ponto,
	dt_validade
into STRICT	cd_estabelecimento_w,
	nr_seq_conjunto_w,
	nr_seq_embalagem_w,
	cd_local_estoque_w,
	cd_setor_atend_orig_w,
	cd_pessoa_fisica_w,
	cd_cgc_w,
	nr_seq_cliente_w,
	cd_setor_atendimento_w,
	cd_pessoa_resp_w,
	ie_tipo_esterilizacao_w,
	vl_esterilizacao_w,
	qt_ponto_w,
	dt_validade_w
from	cm_conjunto_cont
where	nr_sequencia = nr_seq_conjunto_p
and	coalesce(ie_situacao,'A') = 'A';

cd_local_estoque_param_w := obter_param_usuario(410, 62, wheb_usuario_pck.get_cd_perfil, nm_usuario_p, cd_estabelecimento_w, cd_local_estoque_param_w);

select 	coalesce(max(nr_seq_controle),0) + 1
into STRICT	nr_seq_controle_w
from 	cm_conjunto_cont;

select	nextval('cm_conjunto_cont_seq')
into STRICT	nr_sequencia_w
;

insert into cm_conjunto_cont(
	nr_sequencia,
	nr_seq_controle,
	nr_seq_conjunto,
	nr_seq_embalagem,
	cd_local_estoque,
	cd_setor_atend_orig,
	cd_pessoa_fisica,
	cd_cgc,
	nr_seq_cliente,
	cd_setor_atendimento,
	cd_pessoa_resp,
	ie_tipo_esterilizacao,
	vl_esterilizacao,
	qt_ponto,
	dt_origem,
	nm_usuario_origem,
	dt_receb_ester,
	nm_usuario_ester,
	cd_estabelecimento,
	dt_atualizacao,
	nm_usuario,
	ie_status_conjunto,
	ie_situacao,
	dt_validade)
values (nr_sequencia_w,
	nr_seq_controle_w,
	nr_seq_conjunto_w,
	nr_seq_embalagem_w,
	cd_local_estoque_w,
	cd_setor_atend_orig_w,
	cd_pessoa_fisica_w,
	cd_cgc_w,
	nr_seq_cliente_w,
	cd_setor_atendimento_w,
	cd_pessoa_resp_w,
	ie_tipo_esterilizacao_w,
	vl_esterilizacao_w,
	qt_ponto_w,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	cd_estabelecimento_w,
	clock_timestamp(),
	nm_usuario_p,
	'1',
	'A',
	dt_validade_w);

update	cm_conjunto_cont
set		cd_local_estoque 	= coalesce(cd_local_estoque_param_w, cd_local_estoque)
where	nr_sequencia		= nr_seq_conjunto_p;

CALL cme_incluir_itens_controle(nr_sequencia_w,nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cm_gerar_conj_retorno_atend ( nr_seq_conjunto_p bigint, nm_usuario_p text) FROM PUBLIC;

