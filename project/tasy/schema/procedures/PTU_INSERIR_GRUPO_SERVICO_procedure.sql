-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_inserir_grupo_servico ( cd_grupo_servico_p ptu_grupo_servico.cd_grupo_servico%type, ds_grupo_servico_p ptu_grupo_servico.ds_grupo_servico%type, nr_seq_versao_p ptu_versao_tabela.nr_seq_versao%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_item_criado_p INOUT ptu_versao_tabela.nr_sequencia%type) AS $body$
DECLARE


qt_registro_w		integer;


BEGIN
select	count(1)
into STRICT	qt_registro_w
from	ptu_grupo_servico
where	cd_grupo_servico = cd_grupo_servico_p;

if (qt_registro_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1023584);
end if;

insert into ptu_grupo_servico(cd_estabelecimento, cd_grupo_servico, ds_grupo_servico,
	dt_atualizacao, dt_atualizacao_nrec, dt_fim_vigencia,
	dt_inicio_vigencia, ie_situacao, nm_usuario,
	nm_usuario_nrec )
values ( cd_estabelecimento_p, cd_grupo_servico_p, ds_grupo_servico_p,
	clock_timestamp(), clock_timestamp(), null,
	null, 'S', nm_usuario_p,
	nm_usuario_p );

select	nextval('ptu_versao_tabela_seq')
into STRICT	nr_seq_item_criado_p
;

insert into ptu_versao_tabela(dt_atualizacao, dt_atualizacao_nrec, ie_situacao,
	nm_usuario, nm_usuario_nrec, nr_seq_grupo_servico,
	nr_sequencia, nr_seq_versao)
SELECT	clock_timestamp(), clock_timestamp(), ie_situacao,
	nm_usuario_p, nm_usuario_p, cd_grupo_servico,
	nr_seq_item_criado_p, nr_seq_versao_p
from	ptu_grupo_servico
where	cd_estabelecimento = cd_estabelecimento_p
and	cd_grupo_servico = cd_grupo_servico_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_inserir_grupo_servico ( cd_grupo_servico_p ptu_grupo_servico.cd_grupo_servico%type, ds_grupo_servico_p ptu_grupo_servico.ds_grupo_servico%type, nr_seq_versao_p ptu_versao_tabela.nr_seq_versao%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_item_criado_p INOUT ptu_versao_tabela.nr_sequencia%type) FROM PUBLIC;

