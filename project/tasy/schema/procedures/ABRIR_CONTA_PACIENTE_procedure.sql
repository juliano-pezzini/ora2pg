-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE abrir_conta_paciente ( nr_interno_conta_p bigint, nm_usuario_p text, ie_retira_protocolo_p text default 'N', nr_seq_protocolo_p INOUT bigint  DEFAULT NULL) AS $body$
DECLARE


ie_fim_conta_w		varchar(1);
dt_fim_conta_w		timestamp;				
ie_cancelamento_w	varchar(1);
nr_seq_protocolo_w	bigint;
ie_status_acerto_w	smallint;
ds_titulo_w		varchar(255);
ie_status_protocolo_w	bigint;
ds_erro_w		varchar(255):= null;
ie_auditoria_w		bigint:=0;
ie_abre_atend_w		varchar(1);
nr_atendimento_w	bigint;
	

BEGIN

nr_seq_protocolo_p:= 0;

select	a.ie_fim_conta,
	a.dt_fim_conta,
	b.ie_cancelamento,
	b.nr_seq_protocolo,
	b.ie_status_acerto,
	substr(obter_titulo_conta_protocolo(0, nr_interno_conta),1,100),
	a.nr_atendimento
into STRICT	ie_fim_conta_w,
	dt_fim_conta_w,
	ie_cancelamento_w,
	nr_seq_protocolo_w,
	ie_status_acerto_w,
	ds_titulo_w,
	nr_atendimento_w
from 	conta_paciente b,
	atendimento_paciente a
where 	b.nr_atendimento = a.nr_atendimento
and 	b.nr_interno_conta = nr_interno_conta_p;

if (ie_status_acerto_w = 2) then

	if (ie_cancelamento_w = 'C') then
		--R.aise_application_error(-20011,'A conta não pode ser aberta pois está cancelada!'||'#@#@');
		CALL wheb_mensagem_pck.exibir_mensagem_abort(263272);
	elsif (ie_cancelamento_w = 'E') then
		--R.aise_application_error(-20011,'A conta não pode ser aberta pois está estornada!'||'#@#@');
		CALL wheb_mensagem_pck.exibir_mensagem_abort(263273);
	end if;
	
	ie_abre_atend_w	:= obter_valor_param_usuario(1116, 64, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento);
	
	if (dt_fim_conta_w IS NOT NULL AND dt_fim_conta_w::text <> '') then
		
		if (coalesce(ie_abre_atend_w,'N') = 'A')	then
			CALL abrir_atendimento(nr_atendimento_w, nm_usuario_p);
		else
			--R.aise_application_error(-20011,'A conta não pode ser aberta pois o atendimento já está fechado!'||'#@#@');
			CALL wheb_mensagem_pck.exibir_mensagem_abort(263274);
		end if;
	end if;	
	
	if (coalesce(ds_titulo_w,0) > 0) then
		--R.aise_application_error(-20011,'A conta não pode ser aberta pois já possuí títulos gerados!'||'#@#@');
		CALL wheb_mensagem_pck.exibir_mensagem_abort(263275);
	end if;	

	ds_erro_w := Consiste_Abrir_Conta_Paciente(nr_interno_conta_p, nm_usuario_p, ds_erro_w);

	if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
		--R.aise_application_error(-20011,ds_erro_w || '#@#@');
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(196119,'DS_ERRO=' || ds_erro_w);
	end if;	
			
	if	((coalesce(nr_seq_protocolo_w,0) > 0) and (coalesce(ie_retira_protocolo_p,'N') = 'N')) then
		--R.aise_application_error(-20011,'A conta não pode ser aberta pois a mesma está em protocolo!'||'#@#@');
		CALL wheb_mensagem_pck.exibir_mensagem_abort(263276);
	elsif	((coalesce(nr_seq_protocolo_w,0) > 0) and (coalesce(ie_retira_protocolo_p,'N') = 'S')) then
		
		select 	ie_status_protocolo
		into STRICT	ie_status_protocolo_w
		from	protocolo_convenio
		where	nr_seq_protocolo = nr_seq_protocolo_w;
	
		if (ie_status_protocolo_w = 3) then
			update  conta_paciente
			set     nr_seq_protocolo  = NULL
			where   nr_interno_conta  = nr_interno_conta_p;
			
			nr_seq_protocolo_p :=  nr_seq_protocolo_w;
			
		else
			--R.aise_application_error(-20011,'A conta não pode ser retirada do protocolo pois o mesmo não está em auditoria!'||'#@#@');
			CALL wheb_mensagem_pck.exibir_mensagem_abort(263277);
		end if;
		


	end if;	

	update  conta_paciente
	set     ie_status_acerto  = 1,
		dt_atualizacao    = clock_timestamp(),
		nm_usuario        = nm_usuario_p
	where   nr_interno_conta  = nr_interno_conta_p;
	
	commit;
	
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE abrir_conta_paciente ( nr_interno_conta_p bigint, nm_usuario_p text, ie_retira_protocolo_p text default 'N', nr_seq_protocolo_p INOUT bigint  DEFAULT NULL) FROM PUBLIC;

