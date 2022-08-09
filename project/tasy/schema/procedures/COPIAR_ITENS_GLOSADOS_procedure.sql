-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_itens_glosados ( nr_interno_conta_p bigint, cd_autorizacao_p text, nr_seq_ret_item_origem_p bigint, nr_seq_ret_item_destino_p bigint, ie_reapresentacao_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;

c01 CURSOR FOR
SELECT	a.nr_sequencia
from	convenio_retorno_glosa a,
	convenio_retorno_item b
where	a.nr_seq_ret_item	= b.nr_sequencia
and	b.nr_sequencia		= nr_seq_ret_item_origem_p;


BEGIN

open c01;
loop
fetch c01 into
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	insert	into convenio_retorno_glosa(cd_autorizacao_compl,
		cd_item_convenio,
		cd_material,
		cd_motivo_glosa,
		cd_pessoa_fisica,
		cd_procedimento,
		cd_resposta,
		cd_setor_atendimento,
		cd_setor_responsavel,
		ds_complemento,
		ds_observacao,
		dt_atualizacao,
		dt_execucao,
		ie_atualizacao,
		ie_emite_conta,
		ie_origem_proced,
		nm_usuario,
		nr_seq_matpaci,
		nr_seq_matpaci_partic,
		nr_seq_partic,
		nr_seq_propaci,
		nr_seq_propaci_partic,
		nr_seq_ret_item,
		nr_sequencia,
		qt_cobrada,
		qt_glosa,
		vl_amaior,
		vl_cobrado,
		vl_glosa,
		vl_pago_digitado)
	SELECT	a.cd_autorizacao_compl,
		a.cd_item_convenio,
		a.cd_material,
		a.cd_motivo_glosa,
		a.cd_pessoa_fisica,
		a.cd_procedimento,
		a.cd_resposta,
		a.cd_setor_atendimento,
		a.cd_setor_responsavel,
		a.ds_complemento,
		a.ds_observacao,
		a.dt_atualizacao,
		a.dt_execucao,
		a.ie_atualizacao,
		a.ie_emite_conta,
		a.ie_origem_proced,
		nm_usuario_p,
		a.nr_seq_matpaci,
		a.nr_seq_matpaci_partic,
		a.nr_seq_partic,
		a.nr_seq_propaci,
		a.nr_seq_propaci_partic,
		nr_seq_ret_item_destino_p,
	        nextval('convenio_retorno_glosa_seq'),
		a.qt_cobrada,
		a.qt_glosa,
		a.vl_amaior,
		a.vl_cobrado,
		a.vl_glosa,
		a.vl_pago_digitado
	from	convenio_retorno_glosa a
	where	nr_sequencia	= nr_sequencia_w
	and	((ie_reapresentacao_p = 'N') or (exists (SELECT	1
							from	motivo_glosa x
							where	x.cd_motivo_glosa	= a.cd_motivo_glosa
							and	x.ie_acao_glosa		= 'R')) or (a.ie_acao_glosa = 'R'));

end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_itens_glosados ( nr_interno_conta_p bigint, cd_autorizacao_p text, nr_seq_ret_item_origem_p bigint, nr_seq_ret_item_destino_p bigint, ie_reapresentacao_p text, nm_usuario_p text) FROM PUBLIC;
