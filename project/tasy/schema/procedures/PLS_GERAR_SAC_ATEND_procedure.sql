-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_sac_atend ( cd_pessoa_fisica_p text, cd_cgc_p text, ds_ocorrencia_p text, nr_Seq_atendimento_p bigint, nr_seq_evento_atend_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_forma_reg_w		bigint;


BEGIN

select	max(vl_default)
into STRICT	nr_seq_forma_reg_w
from	tabela_atrib_regra
where	nm_tabela = 'SAC_BOLETIM_OCORRENCIA'
and	nm_atributo = 'NR_SEQ_FORMA_REG';

insert into sac_boletim_ocorrencia(nr_sequencia, dt_atualizacao , nm_usuario,
	dt_ocorrencia, cd_cgc, cd_pessoa_fisica,
	ds_ocorrencia, nr_atend_pls, ie_origem,
	cd_estabelecimento, nr_seq_evento_atend, nm_usuario_nrec,
	nr_seq_forma_reg)
values (nextval('sac_boletim_ocorrencia_seq'), clock_timestamp(), nm_usuario_p,
	clock_timestamp(), cd_cgc_p, cd_pessoa_fisica_p,
	ds_ocorrencia_p, nr_seq_atendimento_p, 'E',
	cd_estabelecimento_p, nr_seq_evento_atend_p, nm_usuario_p,
	nr_seq_forma_reg_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_sac_atend ( cd_pessoa_fisica_p text, cd_cgc_p text, ds_ocorrencia_p text, nr_Seq_atendimento_p bigint, nr_seq_evento_atend_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
