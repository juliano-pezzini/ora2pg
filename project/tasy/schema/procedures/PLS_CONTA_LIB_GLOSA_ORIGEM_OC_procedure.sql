-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_conta_lib_glosa_origem_oc ( nr_seq_analise_conta_item_p bigint, nr_seq_proc_p bigint, nr_seq_mat_p bigint, nr_seq_conta_p bigint, nr_seq_analise_p bigint, nr_seq_glosa_oc_p bigint, nr_seq_mot_liberacao_p bigint, ds_observacao_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


ie_tipo_motivo_w		varchar(3);
nr_seq_item_w			bigint;
ie_tipo_item_w			varchar(1);
nr_seq_ocorrencia_w		bigint;
nr_seq_glosa_w			bigint;
nr_nivel_liberacao_w		bigint;
nr_nivel_liberacao_auditor_w	bigint;
nr_seq_oc_benef_w		bigint;


BEGIN

/*Verificar se foi uma liberação favoravel ou desfavoravel*/

select	ie_tipo_motivo
into STRICT	ie_tipo_motivo_w
from	pls_mot_lib_analise_conta
where	nr_sequencia = nr_seq_mot_liberacao_p;

if (coalesce(nr_seq_proc_p,0) > 0) then
	nr_seq_item_w	:= nr_seq_proc_p;
	ie_tipo_item_w	:= 'P';
else
	nr_seq_item_w	:= nr_seq_mat_p;
	ie_tipo_item_w	:= 'M';
end if;

nr_seq_glosa_w		:= nr_seq_glosa_oc_p;

/*Atualizado a glosa*/

update	pls_analise_conta_item
set	ie_status 	= ie_tipo_motivo_w,
	nm_usuario	= nm_usuario_p,
	dt_atualizacao 	= clock_timestamp(),
	ie_situacao	= CASE WHEN ie_tipo_motivo_w='N' THEN  'A' WHEN ie_tipo_motivo_w='L' THEN  'I' WHEN ie_tipo_motivo_w='A' THEN  'I' END
where	nr_sequencia	= nr_seq_analise_conta_item_p
and	ie_status	<> 'I';

/*Criado o parecer*/

insert into pls_analise_parecer_item(nr_sequencia, nr_seq_item, nr_seq_motivo,
	 dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
	 nm_usuario_nrec, ds_parecer, ie_tipo_motivo)
values (nextval('pls_analise_parecer_item_seq'), nr_seq_analise_conta_item_p, nr_seq_mot_liberacao_p,
	 clock_timestamp(), nm_usuario_p, clock_timestamp(),
	 nm_usuario_p, ds_observacao_p, ie_tipo_motivo_w);

/*Adicionado o histórico da ação*/

insert into pls_hist_analise_conta(nr_sequencia, nr_seq_conta, nr_seq_analise,
	 ie_tipo_historico, dt_atualizacao, nm_usuario,
	 dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_item,
	 ie_tipo_item, nr_seq_ocorrencia, ds_observacao,
	 nr_seq_glosa, ds_call_stack)
values (nextval('pls_hist_analise_conta_seq'), nr_seq_conta_p, nr_seq_analise_p,
	 5, clock_timestamp(), nm_usuario_p,
	 clock_timestamp(), nm_usuario_p, nr_seq_item_w,
	 ie_tipo_item_w, nr_seq_ocorrencia_w, ds_observacao_p,
	 nr_seq_glosa_w, substr(dbms_utility.format_call_stack,1,4000));

CALL pls_analise_status_pgto(nr_seq_conta_p, nr_seq_mat_p, nr_seq_proc_p,
			nr_seq_analise_p, cd_estabelecimento_p, nm_usuario_p,
			null, null, null,
			null	);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_conta_lib_glosa_origem_oc ( nr_seq_analise_conta_item_p bigint, nr_seq_proc_p bigint, nr_seq_mat_p bigint, nr_seq_conta_p bigint, nr_seq_analise_p bigint, nr_seq_glosa_oc_p bigint, nr_seq_mot_liberacao_p bigint, ds_observacao_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

