-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE importa_cep_access ( nm_usuario_p text, ie_sobrepoe_p text) AS $body$
DECLARE


qt_reg_w bigint;

BEGIN

CALL exec_sql_dinamico('TASY', ' alter table via_aeroporto disable constraint VIAAERO_CEPLOC_FK');

if (coalesce(ie_sobrepoe_p,'S') = 'S') then
	CALL exec_sql_dinamico('TASY', ' truncate table cep_log');
	CALL exec_sql_dinamico('TASY', ' truncate table cep_loc');
	CALL exec_sql_dinamico('TASY', ' truncate table cep_bairro');
end if;

CALL exec_sql_dinamico('TASY', ' insert into cep_log (nr_sequencia, nm_logradouro, nr_seq_loc, dt_atualizacao, nm_usuario, ds_uf, ds_complemento, cd_bairro_inicial, cd_bairro_final, ds_tipo_logradouro, ds_fonetica, cd_cep, ds_patente, ie_log_ativo, ds_preposicao, ie_cep_geral, ie_operacao, cd_cep_aux) select nr_sequencia, nm_logradouro, nr_seq_loc, dt_atualizacao, nm_usuario, ds_uf, ds_complemento, cd_bairro_inicial, cd_bairro_final, ds_tipo_logradouro, ds_fonetica, cd_cep, ds_patente, ie_log_ativo, ds_preposicao, ie_cep_geral, ie_operacao, cd_cep_aux from w_cep_log a where nvl(ie_log_ativo,''S'') = ''S'' AND NOT EXISTS (SELECT 1 FROM cep_log x WHERE a.nr_seq_loc = x.nr_seq_loc and a.nr_sequencia = x.nr_sequencia and a.cd_cep = X.cd_cep) ');
CALL exec_sql_dinamico('TASY', ' insert into cep_log (nr_sequencia, nm_logradouro, nr_seq_loc, dt_atualizacao, nm_usuario, ds_uf, ds_complemento, cd_bairro_inicial, cd_bairro_final, ds_tipo_logradouro, ds_fonetica, cd_cep, ds_patente, ie_log_ativo, ds_preposicao, ie_cep_geral, ie_operacao, cd_cep_aux) select nr_sequencia, nm_logradouro, nr_seq_loc, dt_atualizacao, nm_usuario, ds_uf, ds_complemento, cd_bairro_inicial, cd_bairro_final, ds_tipo_logradouro, ds_fonetica, cd_cep, ds_patente, ie_log_ativo, ds_preposicao, ie_cep_geral, ie_operacao, cd_cep_aux from w_cep_log a where nvl(ie_log_ativo,''S'') = ''G'' AND NOT EXISTS (SELECT 1 FROM cep_log x WHERE a.nr_seq_loc = x.nr_seq_loc and a.nr_sequencia = x.nr_sequencia and a.cd_cep = X.cd_cep) ');--Grandes usuarios
CALL exec_sql_dinamico('TASY', ' insert into cep_log (nr_sequencia, nm_logradouro, nr_seq_loc, dt_atualizacao, nm_usuario, ds_uf, ds_complemento, cd_bairro_inicial, cd_bairro_final, ds_tipo_logradouro, ds_fonetica, cd_cep, ds_patente, ie_log_ativo, ds_preposicao, ie_cep_geral, ie_operacao, cd_cep_aux) select nr_sequencia, nm_logradouro, nr_seq_loc, dt_atualizacao, nm_usuario, ds_uf, ds_complemento, cd_bairro_inicial, cd_bairro_final, ds_tipo_logradouro, ds_fonetica, cd_cep, ds_patente, ie_log_ativo, ds_preposicao, ie_cep_geral, ie_operacao, cd_cep_aux from w_cep_log a where nvl(ie_log_ativo,''S'') = ''C'' AND NOT EXISTS (SELECT 1 FROM cep_log x WHERE a.nr_seq_loc = x.nr_seq_loc and a.nr_sequencia = x.nr_sequencia and a.cd_cep = X.cd_cep) ');--Caixa Postal Comunitaria
CALL exec_sql_dinamico('TASY', ' insert into cep_loc (nr_sequencia, nm_localidade, ds_uf, ie_tipo, nr_seq_superior, dt_atualizacao, nm_usuario, ds_fonetica, nr_seq_pais, ie_operacao, cd_cep) select nr_sequencia, nm_localidade, ds_uf, ie_tipo, nr_seq_superior, dt_atualizacao, nm_usuario, ds_fonetica, nr_seq_pais, ie_operacao, cd_cep from w_cep_loc a where not exists (select 1 from cep_loc x where a.nr_sequencia = x.nr_sequencia) ');
CALL exec_sql_dinamico('TASY', ' insert into cep_bairro (nr_sequencia, ds_bairro, nr_seq_loc, ds_uf, dt_atualizacao, nm_usuario, nr_seq_regiao, cd_municipio_ibge, ie_operacao, cd_tipo_bairro ) select nr_sequencia, ds_bairro, nr_seq_loc, ds_uf, dt_atualizacao, nm_usuario, nr_seq_regiao, cd_municipio_ibge, ie_operacao, cd_tipo_bairro  from w_cep_bairro a where not exists (select 1 from cep_bairro x where a.nr_seq_loc = x.nr_seq_loc and a.nr_sequencia = x.nr_sequencia) ');

CALL exec_sql_dinamico('TASY', ' alter table via_aeroporto enable constraint VIAAERO_CEPLOC_FK');

qt_reg_w := obter_valor_dinamico('select count(*) from w_cep_pais', qt_reg_w);

if (qt_reg_w > 0) then
	CALL exec_sql_dinamico('TASY', ' insert into pais select pais_seq.nextVal as nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, cd_codigo_pais, nm_pais, cd_pais_sib, sg_pais, cd_bacen, cd_pais_siscoserv, cd_ptu, nr_seq_cat_pais, cd_pais_dale_uv, ie_situacao from w_cep_pais b where not exists (select 1 from pais a where b.sg_pais = a.sg_pais) ');
	CALL exec_sql_dinamico('TASY', ' drop table w_cep_pais');
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE importa_cep_access ( nm_usuario_p text, ie_sobrepoe_p text) FROM PUBLIC;

