-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_cancelar_protocolo_conta ( nr_seq_protocolo_p bigint, ie_comitar_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ds_motivo_canc_p text default null, nr_seq_motivo_canc_p bigint default null) AS $body$
DECLARE

 
ie_verificou_w			varchar(1):= 'N';
nr_seq_conta_w			bigint;
ie_motivo_canc_w		bigint;
nr_seq_analise_w		bigint;
nr_Seq_lote_pgto_w		bigint	:= 0;
ie_faturado_w			bigint;
qt_conta_analise_w		bigint;
ds_observacao_w			varchar(255);
ie_tipo_protocolo_w		pls_protocolo_conta.ie_tipo_protocolo%type;
nr_lote_reembolso_w		lote_contabil.nr_lote_contabil%type;
ie_analise_cm_nova_w		pls_parametros.ie_analise_cm_nova%type;
ds_motivo_canc_w		pls_protocolo_conta.ds_motivo_canc%type;
/*Chamado no fonte da função OPS - Gestão de contas médicas*/
 
/* Esta rotina serve para cancelar um protocolo a partir da gestão de contas médicas.*/
 
/* Há dois tipos de tratamento: quando o protocolo for de intercâmbio e quando não for de intercâmbio*/
 
/* Não pode cancelar o protocolo caso uma das contas deste já tenha gerado títulos a pagar. */
 
/* Caso este protocolo esteja na função OPS - Pagamentos de Produção Médica , não pode ser cancelado*/
 
C01 CURSOR FOR 
	SELECT	nr_sequencia 
	from	pls_conta 
	where	nr_seq_protocolo	= nr_seq_protocolo_p 
	order by 1;
	

BEGIN 
/* --------------------------------------------------------------------------------------------Verificação se protocolo esta faturado ou se está em um lote-----------------------------------------------------------------*/
 
/* pasta Demonstrativo do protocolo\ Contas Médicas */
 
select	count(1) 
into STRICT	ie_faturado_w 
from 	pls_prot_conta_titulo 	a 
where	nr_seq_protocolo  	= nr_seq_protocolo_p;	
 
/*Se possuir demonstrativo do protocolo, então não deve cancelar o protocolo*/
 
if ( ie_faturado_w > 0) then 
	/* O protocolo já possui um demonstrativo. */
 
	--wheb_mensagem_pck.exibir_mensagem_abort(180476,'NR_SEQ_CONTA=' ||nr_seq_conta_p); 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(186270);
end if;
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
 
 
/*VAI OBTER UM MOTIVO PADRAO CADASTRADO*/
 
ie_motivo_canc_w := obter_valor_param_usuario(1208,53, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p);
if (coalesce(ie_motivo_canc_w,0) = 0) and (coalesce(nr_seq_motivo_canc_p::text, '') = '') then 
	--'Não existe motivo padrão de cancelamento do protocolo informado! (Parâmetro[53] - Motivo padrão para o cancelamento de protocolos.) 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(181331);
end if;
 
select	max(CASE WHEN coalesce(nr_lote_contabil,0)=0 THEN nr_lote_prov_copartic  ELSE nr_lote_contabil END ), 
		max(ie_tipo_protocolo) 
into STRICT	nr_lote_reembolso_w, 
		ie_tipo_protocolo_w 
from	pls_protocolo_conta 
where	nr_sequencia	= nr_seq_protocolo_p;
	 
if (coalesce(nr_lote_reembolso_w,0) <> 0) then 
	--O reembolso não pode ser cancelado, pois está contabilizado no lote #@NR_LOTE_CONTABIL#@! do tipo #@DS_TIPO_LOTE_CONTABIL#@!	 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(455022, 'NR_LOTE_CONTABIL=' || nr_lote_reembolso_w || 
							';DS_TIPO_LOTE_CONTABIL=' || ctb_obter_tipo_lote_contabil(nr_lote_reembolso_w,'D'));
end if;
 
ds_motivo_canc_w := ds_motivo_canc_p;
 
if (ds_motivo_canc_p IS NOT NULL AND ds_motivo_canc_p::text <> '') then 
	select 	max(ds_motivo_canc) 
	into STRICT	ds_motivo_canc_w 
	from 	pls_protocolo_conta 
	where 	nr_sequencia 	= nr_seq_protocolo_p;
 
	if (ds_motivo_canc_w IS NOT NULL AND ds_motivo_canc_w::text <> '') then 
		ds_motivo_canc_w := ds_motivo_canc_p || chr(10) || ds_motivo_canc_w;
	else 
		ds_motivo_canc_w := ds_motivo_canc_p;
	end if;	
end if;
 
/*Obtem se é análise nova ou antiga*/
 
select	max(ie_analise_cm_nova) 
into STRICT	ie_analise_cm_nova_w 
from	pls_parametros 
where	cd_estabelecimento	= cd_estabelecimento_p;
 
open C01;
loop 
fetch C01 into	 
	nr_seq_conta_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	/* --------------------------------------------------------------------------------------------Verificação se pagamento da conta está em um lote de pagamento-----------------------------------------------------------*/
	 
	/*Tratamento se na conta, na pasta "Pagamento" , se existem pagamentos desta conta com lote gerado "Lote pgto" */
 
	select	max(nr_Seq_lote_pgto) 
	into STRICT	nr_Seq_lote_pgto_w 
	from 	pls_conta_medica_resumo 
	where  nr_seq_conta = nr_seq_conta_w 
	and	((ie_situacao != 'I') or (coalesce(ie_situacao::text, '') = ''));
	 
	/*Caso exista lote de pagamento para um pagamento da conta*/
 
	if ( coalesce(nr_Seq_lote_pgto_w,0) > 0) then 
		/* Não foi possível cancelar o protocolo. */
 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(186271,'NR_SEQ_LOTE=' ||nr_Seq_lote_pgto_w||';NR_SEQ_CONTA='||nr_seq_conta_w);
	end if;		
	/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
	 
	 
	select	max(nr_seq_analise) 
	into STRICT	nr_seq_analise_w 
	from	pls_conta 
	where	nr_sequencia = nr_seq_conta_w;
	 
	/*cancelar a analise correspondente a conta*/
 
	if (coalesce(nr_seq_analise_w,0) > 0) then 
		select	count(1) 
		into STRICT	qt_conta_analise_w 
		from	pls_conta 
		where	nr_seq_analise = nr_seq_analise_w;
		 
		if (qt_conta_analise_w > 1) and (coalesce(ie_analise_cm_nova_w,'N') = 'N')then 
			CALL pls_desfazer_analise_conta(nr_seq_conta_w,cd_estabelecimento_p,nm_usuario_p );
		else 
			CALL pls_alterar_status_analise_cta(nr_seq_analise_w, 'C', 'PLS_CANCELAR_PROTOCOLO_CONTA', nm_usuario_p, cd_estabelecimento_p);
		end if;
	end if;
	 
	/*Conforme tratado com Paulo Rosa 27/08/2013 alteramos a rotina para que ao invés de glosar a conta a mesma seja cancelada OS 615605 dgkorz*/
	 
	ds_observacao_w := pls_cancelar_conta(	nr_seq_conta_w, NULL, nm_usuario_p, cd_estabelecimento_p, '1', ds_observacao_w, 'N');
	 
	ds_observacao_w := pls_cancelar_conta(	nr_seq_conta_w, NULL, nm_usuario_p, cd_estabelecimento_p, '2', ds_observacao_w, 'N');
	 
	end;
end loop;
close C01;
 
/*vai atualizar o status do protocolo para fechado.*/
 
update	pls_protocolo_conta 
set	ie_status 		= 4, 
	nr_seq_motivo_cancel 	= coalesce(nr_seq_motivo_canc_p,ie_motivo_canc_w), 
	ds_motivo_canc		= substr(ds_motivo_canc_w,1,4000) 
where	nr_sequencia 		= nr_seq_protocolo_p;
 
 
if (ie_tipo_protocolo_w = 'R') then 
	CALL pls_gerar_comunic_reemb(1,'O protocolo de reembolso ' || nr_seq_protocolo_p || ' foi cancelado.', nr_seq_protocolo_p, nm_usuario_p, cd_estabelecimento_p);
	pls_gerar_alerta_rembolso_lib(6, nr_seq_protocolo_p, '4', nm_usuario_p);
end if;
 
if (ie_comitar_p = 'S') then 
	commit;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cancelar_protocolo_conta ( nr_seq_protocolo_p bigint, ie_comitar_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ds_motivo_canc_p text default null, nr_seq_motivo_canc_p bigint default null) FROM PUBLIC;

