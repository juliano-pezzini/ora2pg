-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE des_encaminhar_os_suporte ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_classificacao_w		MAN_ORDEM_SERVICO.IE_CLASSIFICACAO%Type;
nm_usuario_suporte_w	USUARIO.NM_USUARIO%Type;
nr_ordem_servico_w	MAN_ORDEM_SERVICO.NR_SEQUENCIA%Type;
nr_seq_executor_w		bigint;
qt_registro_w		bigint;
ds_observacao_w		varchar(4000);


BEGIN

nr_ordem_servico_w	:= nr_sequencia_p;

select	max(ie_classificacao)
into STRICT	ie_classificacao_w
from	man_ordem_servico
where	nr_sequencia	= nr_ordem_servico_w;

update	man_ordem_servico a
set	dt_atualizacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p,
	nr_seq_estagio		= 231,
	ie_classificacao		= CASE WHEN ie_classificacao='S' THEN 'D'  ELSE ie_classificacao END ,
	nr_seq_classif		= 9,
	nr_seq_nivel_valor		= 2
where	a.nr_sequencia		= nr_ordem_servico_w;

if (ie_classificacao_w = 'S') then
	ds_observacao_w	:= substr(wheb_mensagem_pck.get_texto(358053) || chr(13) || chr(10) ||
			   wheb_mensagem_pck.get_texto(358054),1,4000);

	CALL man_gravar_ordem_serv_classif(nr_ordem_servico_w, 'D', ie_classificacao_w, null, ds_observacao_w, nm_usuario_p);

	CALL man_gravar_historico_ordem(	nr_ordem_servico_w,	clock_timestamp(),
				ds_observacao_w,		'I',
				1,			nm_usuario_p);
end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE des_encaminhar_os_suporte ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

