-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_vincular_glosa_ocorrencia ( nr_seq_glosa_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


cd_ocorrencia_w			varchar(10);
cd_motivo_tiss_w		varchar(10);
ds_motivo_tiss_w		varchar(255);
ie_vincular_auditoria_w		varchar(1);


BEGIN

/* Obter o valor do parâmetro 10*/

/*ie_vincular_auditoria_w	:= nvl(obter_valor_param_usuario(1306, 10, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p), 'N');*/

/* Verificar se a glosa já está vinculada a uma ocorrência do tipo "Glosa interna" */

select	max(cd_ocorrencia)
into STRICT	cd_ocorrencia_w
from	pls_ocorrencia
where	nr_seq_motivo_glosa	= nr_seq_glosa_p
and	ie_glosa		= 'S';

if (coalesce(cd_ocorrencia_w,'X') <> 'X') then
	CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(204362,'CD_OCORRENCIA='||cd_ocorrencia_w);
end if;

/* Obter dados da glosa */

select	cd_motivo_tiss,
	ds_motivo_tiss
into STRICT	cd_motivo_tiss_w,
	ds_motivo_tiss_w
from	tiss_motivo_glosa
where	nr_sequencia	= nr_seq_glosa_p;

begin
insert into pls_ocorrencia(nr_sequencia, ie_situacao, cd_estabelecimento,
	cd_ocorrencia, ds_ocorrencia, dt_atualizacao,
	nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
	ds_documentacao, ie_requisicao, ie_conta_medica,
	ds_mensagem_externa, nr_seq_motivo_glosa, nr_nivel_liberacao,
	ie_auditoria, ie_auditoria_conta, ie_fechar_conta,
	nr_seq_classif, ie_guia_intercambio, nr_seq_motivo_ptu,
	ie_glosa, ie_lib_web_guia)
values (	nextval('pls_ocorrencia_seq'), 'A', cd_estabelecimento_p,
	cd_motivo_tiss_w, ds_motivo_tiss_w, clock_timestamp(),
	nm_usuario_p, clock_timestamp(), nm_usuario_p,
	'Ocorrência vinculada através da glosa ' || cd_motivo_tiss_w, 'N', 'N',
	'', nr_seq_glosa_p, null,
	'S', 'S', 'S',
	null, 'N', null,
	'S', 'N');

exception
when others then

CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(204361);

end;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_vincular_glosa_ocorrencia ( nr_seq_glosa_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

