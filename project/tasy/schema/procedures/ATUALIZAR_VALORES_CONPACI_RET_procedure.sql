-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_valores_conpaci_ret ( nr_sequencia_p bigint, vl_pendente_p bigint, vl_glosa_devida_p bigint, vl_glosa_indevida_p bigint, vl_reapresentacao_p bigint, vl_nao_auditado_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_interno_conta_w	bigint;
cd_autorizacao_w		varchar(20);
vl_inicial_w		double precision;
vl_pendente_w		double precision;
vl_glosa_devida_w		double precision;
vl_glosa_indevida_w	double precision;
vl_reapresentacao_w	double precision;
vl_nao_auditado_w		double precision;

nr_seq_ret_item_w		bigint;
nr_seq_retorno_w		bigint;

nr_seq_hist_audit_w	bigint;


BEGIN

select	nr_interno_conta,
		cd_autorizacao,
		vl_inicial,
		vl_pendente,
		vl_glosa_devida,
		vl_glosa_indevida,
		vl_reapresentacao,
		vl_nao_auditado
into STRICT		nr_interno_conta_w,
		cd_autorizacao_w,
		vl_inicial_w,
		vl_pendente_w,
		vl_glosa_devida_w,
		vl_glosa_indevida_w,
		vl_reapresentacao_w,
		vl_nao_auditado_w
from	conta_paciente_retorno a
where a.nr_sequencia = nr_sequencia_p;

select max(a.nr_sequencia),
	max(a.nr_seq_retorno)
into STRICT	nr_seq_ret_item_w,
	nr_seq_retorno_w
from	convenio_retorno b,
	convenio_retorno_item a
where b.nr_sequencia = a.nr_seq_retorno
  and b.ie_status_retorno = 'F'
  and a.nr_interno_conta = nr_interno_conta_w
  and a.cd_autorizacao = cd_autorizacao_w
  and b.dt_fechamento <= (SELECT coalesce(max(dt_historico), max(dt_inicial))
				FROM conta_paciente_ret_hist y
LEFT OUTER JOIN conta_paciente_retorno x ON (y.nr_seq_conpaci_ret = x.nr_sequencia)
WHERE x.nr_sequencia = nr_sequencia_p );

if (vl_pendente_w > 0) and
	((vl_pendente_p + vl_glosa_devida_p + vl_glosa_indevida_p + vl_reapresentacao_p + vl_nao_auditado_p) <> vl_pendente_w) then
	CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(277610);
end if;

if (vl_pendente_w = 0) and (vl_glosa_indevida_w > 0) and
	((vl_glosa_devida_p + vl_reapresentacao_p + vl_glosa_indevida_p) <> vl_glosa_indevida_w) then
	CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(277611);
end if;

if (vl_pendente_w = 0) and (vl_glosa_indevida_w = 0) and (vl_reapresentacao_w > 0) and
	((vl_glosa_devida_p + vl_reapresentacao_p) <> vl_reapresentacao_w) then
	CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(277612);
end if;

if (vl_glosa_devida_p < 0) then
	CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(277613);
end if;

if (vl_nao_auditado_p < 0) then
	CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(277614);
end if;

if (vl_nao_auditado_p <> 0) then
	select coalesce(max(nr_sequencia),0)
	into STRICT nr_seq_hist_audit_w
	from hist_audit_conta_paciente
	where ie_acao = 0;

	insert into conta_paciente_ret_hist(	nr_sequencia, nr_seq_conpaci_ret, dt_historico,
		vl_historico, nr_seq_hist_audit, dt_atualizacao,
		nm_usuario, nr_seq_ret_item, ds_observacao, nm_usuario_resp)
	values (	nextval('conta_paciente_ret_hist_seq'), nr_sequencia_p, clock_timestamp(),
		vl_nao_auditado_p, nr_seq_hist_audit_w, clock_timestamp(),
		nm_usuario_p, nr_seq_ret_item_w, null,nm_usuario_p);
end if;

if (vl_reapresentacao_p <> 0) and
	((vl_pendente_w <> 0) or (vl_glosa_indevida_w <> 0)) then
	select coalesce(max(nr_sequencia),0)
	into STRICT nr_seq_hist_audit_w
	from hist_audit_conta_paciente
	where ie_acao = 2;

	insert into conta_paciente_ret_hist(	nr_sequencia, nr_seq_conpaci_ret, dt_historico,
		vl_historico, nr_seq_hist_audit, dt_atualizacao,
		nm_usuario, nr_seq_ret_item, ds_observacao, nm_usuario_resp)
	values (	nextval('conta_paciente_ret_hist_seq'), nr_sequencia_p, clock_timestamp(),
		vl_reapresentacao_p, nr_seq_hist_audit_w, clock_timestamp(),
		nm_usuario_p, nr_seq_ret_item_w, null,nm_usuario_p);

end if;

if (vl_glosa_devida_p <> 0) then
	select coalesce(max(nr_sequencia),0)
	into STRICT nr_seq_hist_audit_w
	from hist_audit_conta_paciente
	where ie_acao = 3;

	insert into conta_paciente_ret_hist(	nr_sequencia, nr_seq_conpaci_ret, dt_historico,
		vl_historico, nr_seq_hist_audit, dt_atualizacao,
		nm_usuario, nr_seq_ret_item, ds_observacao, nm_usuario_resp)
	values (	nextval('conta_paciente_ret_hist_seq'), nr_sequencia_p, clock_timestamp(),
		vl_glosa_devida_p, nr_seq_hist_audit_w, clock_timestamp(),
		nm_usuario_p, nr_seq_ret_item_w, null,nm_usuario_p);
end if;

if (vl_glosa_indevida_p <> 0) and (vl_pendente_w <> 0) then
	select coalesce(max(nr_sequencia),0)
	into STRICT nr_seq_hist_audit_w
	from hist_audit_conta_paciente
	where ie_acao = 4;

	insert into conta_paciente_ret_hist(	nr_sequencia, nr_seq_conpaci_ret, dt_historico,
		vl_historico, nr_seq_hist_audit, dt_atualizacao,
		nm_usuario, nr_seq_ret_item, ds_observacao, nm_usuario_resp)
	values (	nextval('conta_paciente_ret_hist_seq'), nr_sequencia_p, clock_timestamp(),
		vl_glosa_indevida_p, nr_seq_hist_audit_w, clock_timestamp(),
		nm_usuario_p, nr_seq_ret_item_w, null,nm_usuario_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_valores_conpaci_ret ( nr_sequencia_p bigint, vl_pendente_p bigint, vl_glosa_devida_p bigint, vl_glosa_indevida_p bigint, vl_reapresentacao_p bigint, vl_nao_auditado_p bigint, nm_usuario_p text) FROM PUBLIC;
