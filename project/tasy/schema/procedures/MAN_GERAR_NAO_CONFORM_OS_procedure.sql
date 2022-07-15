-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_gerar_nao_conform_os ( nr_sequencia_p bigint, nr_seq_tipo_nc_p bigint, cd_setor_atendimento_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, cd_setor_resp_p bigint, cd_pf_resp_ocorrencia_p text, nr_seq_nc_gerada_p INOUT bigint) AS $body$
DECLARE

 
cd_pf_abertura_w		varchar(10);
ds_nao_conformidade_w	varchar(4000);
dt_esperada_w		timestamp;
dt_prevista_w		timestamp;
nr_seq_nao_conform_w	bigint;


BEGIN 
 
select	substr(obter_pessoa_fisica_usuario(nm_usuario_p,'C'),1,10) cd_pf_abertura, 
	ds_dano, 
	dt_conclusao_desejada dt_esperada, 
	dt_fim_previsto dt_prevista 
into STRICT	cd_pf_abertura_w, 
	ds_nao_conformidade_w, 
	dt_esperada_w, 
	dt_prevista_w 
from	man_ordem_servico 
where	nr_sequencia	= nr_sequencia_p;
 
select	nextval('qua_nao_conformidade_seq') 
into STRICT	nr_seq_nao_conform_w
;
 
insert into qua_nao_conformidade( 
		nr_sequencia, 
		cd_estabelecimento, 
		dt_atualizacao, 
		nm_usuario, 
		dt_abertura, 
		cd_pf_abertura, 
		ds_nao_conformidade, 
		cd_setor_atendimento, 
		dt_esperada, 
		dt_prevista, 
		nm_usuario_origem, 
		ie_status, 
		nr_seq_tipo, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		cd_setor_resp, 
		cd_pf_resp_ocorrencia) 
	values (	nr_seq_nao_conform_w, 
		cd_estabelecimento_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		cd_pf_abertura_w, 
		ds_nao_conformidade_w, 
		cd_setor_atendimento_p, 
		dt_esperada_w, 
		dt_prevista_w, 
		nm_usuario_p, 
		'Aberta', 
		nr_seq_tipo_nc_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_setor_resp_p, 
		cd_pf_resp_ocorrencia_p);
 
commit;
 
nr_seq_nc_gerada_p := nr_seq_nao_conform_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_gerar_nao_conform_os ( nr_sequencia_p bigint, nr_seq_tipo_nc_p bigint, cd_setor_atendimento_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, cd_setor_resp_p bigint, cd_pf_resp_ocorrencia_p text, nr_seq_nc_gerada_p INOUT bigint) FROM PUBLIC;

