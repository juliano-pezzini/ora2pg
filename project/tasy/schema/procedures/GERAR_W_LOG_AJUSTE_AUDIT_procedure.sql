-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_log_ajuste_audit ( nr_seq_atepacu_p bigint, nr_atend_atepacu_p bigint, nr_atendimento_p bigint, nr_interno_conta_p bigint, nr_seq_auditoria_p bigint, ie_observacao_p text, nm_usuario_p text) AS $body$
DECLARE


ds_observacao_w		varchar(255);
ie_observacao_w		varchar(10);


BEGIN

ie_observacao_w	:= coalesce(ie_observacao_p,'0');

if (ie_observacao_p = 'DIA1') then
	ds_observacao_w	:= substr(wheb_mensagem_pck.get_texto(311233),1,255);
elsif (ie_observacao_p = 'SETOR1') then
	ds_observacao_w	:= substr(wheb_mensagem_pck.get_texto(311234),1,255);
elsif (ie_observacao_p = 'DIA2') then
	ds_observacao_w	:= substr(wheb_mensagem_pck.get_texto(311235),1,255);
elsif (ie_observacao_p = 'SETOR2') then
	ds_observacao_w	:= substr(wheb_mensagem_pck.get_texto(311236),1,255);
elsif (ie_observacao_p = 'AGRUP1') then
	ds_observacao_w	:= substr(wheb_mensagem_pck.get_texto(311238),1,255);
elsif (ie_observacao_p = 'AGRUP2') then
	ds_observacao_w	:= substr(wheb_mensagem_pck.get_texto(311239),1,255);
end if;

insert into w_log_ajuste_audit(
	nr_sequencia,
	nr_interno_conta,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nr_atendimento,
	nm_usuario_nrec,
	nr_atend_atepacu,
	ds_observacao,
	nr_seq_atepacu,
	nr_seq_auditoria
) values (
	nextval('w_log_ajuste_audit_seq'),
	nr_interno_conta_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nr_atendimento_p,
	nm_usuario_p,
	nr_atend_atepacu_p,
	ds_observacao_w,
	nr_seq_atepacu_p,
	nr_seq_auditoria_p
);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_log_ajuste_audit ( nr_seq_atepacu_p bigint, nr_atend_atepacu_p bigint, nr_atendimento_p bigint, nr_interno_conta_p bigint, nr_seq_auditoria_p bigint, ie_observacao_p text, nm_usuario_p text) FROM PUBLIC;
