-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_odonto_pck.cancelar_requisicao (nr_seq_requisicao_p pls_requisicao_proc.nr_seq_requisicao%type, nr_seq_motivo_cancel_p pls_requisicao.nr_seq_motivo_cancel%type, ds_observacao_p text, nm_usuario_p pls_requisicao.nm_usuario%type, cd_estabelecimento_p pls_requisicao.cd_estabelecimento%type) AS $body$
DECLARE


	nr_requisicao_proc_w		bigint;
	ie_cancela_trat_w		varchar(1) := 'N';
	qt_reg_w			bigint;
	ds_motivo_cancel_w		varchar(255);
	qt_reg_aud_w			bigint;
	qt_reg_proc_aud_w		bigint;
	ds_estagio_w			varchar(255);
	ds_historico_w			varchar(255);
	dt_fim_evento_w			pls_atendimento_evento.dt_fim_evento%type;
	nr_seq_atend_pls_w		pls_requisicao.nr_seq_atend_pls%type;
	nr_seq_evento_atend_w		pls_requisicao.nr_seq_evento_atend%type;
	nr_seq_auditoria_w		pls_auditoria.nr_sequencia%type;
	nr_seq_notificacao_w		pls_notificacao_atend_neg.nr_sequencia%type;

	C01 CURSOR FOR
		SELECT	nr_sequencia
		from	pls_requisicao_proc
		where	nr_seq_requisicao = nr_seq_requisicao_p;

	C02 CURSOR FOR
		SELECT	nr_sequencia
		from	pls_execucao_requisicao
		where	nr_seq_requisicao	= nr_seq_requisicao_p;

BEGIN
	begin
		select	substr(obter_valor_dominio(3431, ie_estagio),1,255)
		into STRICT	ds_estagio_w
		from	pls_requisicao
		where	nr_sequencia	= nr_seq_requisicao_p;
exception
when others then
	ds_estagio_w	:= '';
end;
begin
	select	max(nr_sequencia)
	into STRICT	nr_seq_notificacao_w 
	from	pls_notificacao_atend_neg
	where	nr_seq_requisicao = nr_seq_requisicao_p
	and	ie_status = 'AG';
exception
when no_data_found then
    nr_seq_notificacao_w := 0;
end;

update	pls_requisicao
set	ie_status		= 'C',
	ie_estagio		= 3,
	dt_atualizacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p,
	dt_fim_processo_req	= clock_timestamp(),
	nr_seq_motivo_cancel	= nr_seq_motivo_cancel_p
where	nr_sequencia		= nr_seq_requisicao_p;

open C01;
loop
fetch C01 into
	nr_requisicao_proc_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	update	pls_requisicao_proc
	set	ie_status	= 'C',
		ie_estagio	= 'N',
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_requisicao_proc_w;

	select	count(1)
	into STRICT	qt_reg_proc_aud_w
	from	pls_auditoria		b,
		pls_auditoria_item	a
	where	a.nr_seq_proc_origem	= nr_requisicao_proc_w
	and	a.nr_seq_auditoria	= b.nr_sequencia
	and	b.ie_status		not in ('F', 'C');

	if (qt_reg_proc_aud_w	> 0) then
		update	pls_auditoria_item
		set	ie_status		= 'C',
			ie_status_solicitacao	= 'C',
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p
		where	nr_seq_proc_origem	= nr_requisicao_proc_w;
	end if;
	end;
end loop;
close C01;

begin
select	substr(ds_motivo_cancelamento,1,255)
into STRICT	ds_motivo_cancel_w
from	pls_guia_motivo_cancel
where	ie_situacao 		= 'A'
and	cd_estabelecimento 	= cd_estabelecimento_p
and	nr_sequencia		= nr_seq_motivo_cancel_p;
exception
when others then
	ds_motivo_cancel_w	:= '';
end;

CALL pls_requisicao_gravar_hist(	nr_seq_requisicao_p, 'L',
				wheb_mensagem_pck.GET_TEXTO(1195583,'DATA='|| to_char(clock_timestamp(), 'dd/mm/yyyy hh24:mi:ss') || ';NM_USUARIO=' || nm_usuario_p
				|| ';DS_MOTIVO=' || ds_motivo_cancel_w || ';DS_ESTAGIO=' || ds_estagio_w || ';DS_OBSERVACAO=' || ds_observacao_p),
				'',nm_usuario_p);

select	count(1)
into STRICT	qt_reg_w
from	pls_tratamento_benef
where	nr_seq_requisicao	= nr_seq_requisicao_p;

ie_cancela_trat_w	:= obter_valor_param_usuario(1333, 1, Obter_Perfil_Ativo, nm_usuario_p, 0);

if (qt_reg_w > 0) and (ie_cancela_trat_w = 'S') then
	CALL pls_cancelar_tratamento_benef(nr_seq_requisicao_p,nm_usuario_p);
end if;

select	count(1)
into STRICT	qt_reg_aud_w
from	pls_auditoria
where	nr_seq_requisicao	= nr_seq_requisicao_p
and	ie_status		not in ('F', 'C');

if (qt_reg_aud_w	> 0) then
	update	pls_auditoria
	set	ie_status		= 'C',
		dt_liberacao		= clock_timestamp(),
		nr_seq_proc_interno	 = NULL,
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p
	where	nr_seq_requisicao	= nr_seq_requisicao_p;
end if;

--OS 1308565, cancela a analise da execucao
for C02_w in C02 loop
	begin
	update	pls_execucao_requisicao
	set	ie_situacao	= 5,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= C02_w.nr_sequencia
	and	ie_situacao	= 2;

	update	pls_execucao_req_item
	set	ie_situacao	= 'C',
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_seq_execucao	= C02_w.nr_sequencia
	and	ie_situacao	= 'A';

	begin
		select 	nr_sequencia
		into STRICT	nr_seq_auditoria_w
		from 	pls_auditoria
		where	nr_seq_execucao	= C02_w.nr_sequencia;
	exception
	when others then
		nr_seq_auditoria_w	:= null;
	end;

	if (nr_seq_auditoria_w IS NOT NULL AND nr_seq_auditoria_w::text <> '') then
		update	pls_auditoria
		set	ie_status		= 'C',
			dt_liberacao		= clock_timestamp(),
			nr_seq_proc_interno	 = NULL,
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p
		where	nr_sequencia		= nr_seq_auditoria_w;

		update	pls_auditoria_item
		set	ie_status		= 'C',
			ie_status_solicitacao	= 'C',
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p
		where	nr_seq_auditoria	= nr_seq_auditoria_w;
	end if;
	end;
end loop;

begin
	select	nr_seq_atend_pls,
		nr_seq_evento_atend
	into STRICT	nr_seq_atend_pls_w,
		nr_seq_evento_atend_w
	from	pls_requisicao
	where	nr_sequencia = nr_seq_requisicao_p;
exception
when others then
	nr_seq_atend_pls_w := null;
	nr_seq_evento_atend_w := null;
end;

begin
	select	dt_fim_evento
	into STRICT	dt_fim_evento_w
	from	pls_atendimento_evento
	where	nr_sequencia = nr_seq_evento_atend_w;
exception
when others then
	dt_fim_evento_w := null;
end;

if (nr_seq_atend_pls_w IS NOT NULL AND nr_seq_atend_pls_w::text <> '') and (dt_fim_evento_w IS NOT NULL AND dt_fim_evento_w::text <> '') then
	CALL pls_finalizar_atendimento(	nr_seq_atend_pls_w,
					nr_seq_evento_atend_w,
					null,
					null,
					nm_usuario_p);
end if;

ds_historico_w := wheb_mensagem_pck.GET_TEXTO(1195561,'NR_SEQ_REQUISICAO=' || nr_seq_requisicao_p);

CALL pls_processa_resp_notif_neg(nr_seq_notificacao_w, ds_historico_w, 'NA', nm_usuario_p);


END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_odonto_pck.cancelar_requisicao (nr_seq_requisicao_p pls_requisicao_proc.nr_seq_requisicao%type, nr_seq_motivo_cancel_p pls_requisicao.nr_seq_motivo_cancel%type, ds_observacao_p text, nm_usuario_p pls_requisicao.nm_usuario%type, cd_estabelecimento_p pls_requisicao.cd_estabelecimento%type) FROM PUBLIC;
