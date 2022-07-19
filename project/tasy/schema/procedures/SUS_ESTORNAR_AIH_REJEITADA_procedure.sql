-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_estornar_aih_rejeitada ( nr_seq_protocolo_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_protocolo_w		varchar(40);
nr_aih_w		bigint;
nr_seq_aih_w		bigint;
nr_interno_conta_w	bigint;
nr_seq_prot_reje_w	bigint;
nr_seq_prot_novo_w	bigint;

c01 CURSOR FOR 
	SELECT	a.nr_aih, 
		a.nr_seq_aih, 
		b.nr_interno_conta 
	from	sus_aih b, 
		sus_aih_rejeitada a 
	where a.nr_aih		= b.nr_aih	 
	 and a.nr_seq_aih	= b.nr_sequencia 
	 and a.nr_seq_protocolo = nr_seq_protocolo_p;

BEGIN
 
select	nr_protocolo 
into STRICT	nr_protocolo_w 
from	protocolo_convenio 
where	nr_seq_protocolo = nr_seq_protocolo_p;
 
select	nextval('protocolo_convenio_seq') 
into STRICT	nr_seq_prot_reje_w
;
 
insert into protocolo_convenio(CD_CONVENIO, NR_PROTOCOLO, IE_STATUS_PROTOCOLO, 
				DT_PERIODO_INICIAL, DT_PERIODO_FINAL, DT_ATUALIZACAO, 
				NM_USUARIO, IE_TIPO_PROTOCOLO, NR_SEQ_PROTOCOLO, 
				DT_ENVIO, NM_USUARIO_ENVIO, DS_ARQUIVO_ENVIO, 
				DT_RETORNO, NM_USUARIO_RETORNO, DS_ARQUIVO_RETORNO, 
				CD_SETOR_ATENDIMENTO, CD_ESPECIALIDADE, IE_PERIODO_FINAL, 
				DS_PARAMETRO_ATEND, DT_GERACAO,NM_USUARIO_GERACAO, 
				DT_MESANO_REFERENCIA, CD_CLASSIF_SETOR, IE_TIPO_ATEND_BPA, 
				DT_CONSISTENCIA, NR_SEQ_ENVIO_CONVENIO, DT_MESANO_REF_PAR, 
				DS_INCONSISTENCIA, DT_VENCIMENTO, DT_INTEGRACAO_CR, 
				DT_ENTREGA_CONVENIO, CD_INTERFACE_ENVIO, CD_ESTABELECIMENTO, 
				NR_SEQ_LOTE_RECEITA, NR_SEQ_LOTE_REPASSE, NR_SEQ_LOTE_GRAT, 
				NR_SEQ_DOC_CONVENIO, DT_DEFINITIVO) 
SELECT	cd_convenio, Wheb_mensagem_pck.get_Texto(301930, 'NR_PROTOCOLO_W='|| nr_protocolo ), /*'Estornadas - ' || nr_protocolo*/ 1, 
	DT_PERIODO_INICIAL, DT_PERIODO_FINAL, clock_timestamp(), 
	nm_usuario_p, IE_TIPO_PROTOCOLO, nr_seq_prot_reje_w, 
	DT_ENVIO, NM_USUARIO_ENVIO, DS_ARQUIVO_ENVIO, 
	DT_RETORNO, NM_USUARIO_RETORNO, DS_ARQUIVO_RETORNO, 
	CD_SETOR_ATENDIMENTO, CD_ESPECIALIDADE, IE_PERIODO_FINAL, 
	DS_PARAMETRO_ATEND, DT_GERACAO, NM_USUARIO_GERACAO, 
	DT_MESANO_REFERENCIA, CD_CLASSIF_SETOR, IE_TIPO_ATEND_BPA, 
	DT_CONSISTENCIA, NR_SEQ_ENVIO_CONVENIO, DT_MESANO_REF_PAR, 
	DS_INCONSISTENCIA, DT_VENCIMENTO, DT_INTEGRACAO_CR, 
	DT_ENTREGA_CONVENIO, CD_INTERFACE_ENVIO, CD_ESTABELECIMENTO, 
	0, 0, 0, 
	NR_SEQ_DOC_CONVENIO, DT_DEFINITIVO 
from protocolo_convenio 
where nr_seq_protocolo = nr_seq_protocolo_p;
	 
 
select	nextval('protocolo_convenio_seq') 
into STRICT	nr_seq_prot_novo_w
;
 
insert into protocolo_convenio(CD_CONVENIO, NR_PROTOCOLO, IE_STATUS_PROTOCOLO, 
				DT_PERIODO_INICIAL, DT_PERIODO_FINAL, DT_ATUALIZACAO, 
				NM_USUARIO, IE_TIPO_PROTOCOLO, NR_SEQ_PROTOCOLO, 
				DT_ENVIO, NM_USUARIO_ENVIO, DS_ARQUIVO_ENVIO, 
				DT_RETORNO, NM_USUARIO_RETORNO, DS_ARQUIVO_RETORNO, 
				CD_SETOR_ATENDIMENTO, CD_ESPECIALIDADE, IE_PERIODO_FINAL, 
				DS_PARAMETRO_ATEND, DT_GERACAO,NM_USUARIO_GERACAO, 
				DT_MESANO_REFERENCIA, CD_CLASSIF_SETOR, IE_TIPO_ATEND_BPA, 
				DT_CONSISTENCIA, NR_SEQ_ENVIO_CONVENIO, DT_MESANO_REF_PAR, 
				DS_INCONSISTENCIA, DT_VENCIMENTO, DT_INTEGRACAO_CR, 
				DT_ENTREGA_CONVENIO, CD_INTERFACE_ENVIO, CD_ESTABELECIMENTO, 
				NR_SEQ_LOTE_RECEITA, NR_SEQ_LOTE_REPASSE, NR_SEQ_LOTE_GRAT, 
				NR_SEQ_DOC_CONVENIO, DT_DEFINITIVO) 
SELECT	cd_convenio, Wheb_mensagem_pck.get_Texto(301931, 'NR_PROTOCOLO_W='|| nr_protocolo ), /*'Novas - ' || nr_protocolo*/ 1, 
	DT_PERIODO_INICIAL, DT_PERIODO_FINAL, clock_timestamp(), 
	nm_usuario_p, IE_TIPO_PROTOCOLO, nr_seq_prot_novo_w, 
	DT_ENVIO, NM_USUARIO_ENVIO, DS_ARQUIVO_ENVIO, 
	DT_RETORNO, NM_USUARIO_RETORNO, DS_ARQUIVO_RETORNO, 
	CD_SETOR_ATENDIMENTO, CD_ESPECIALIDADE, IE_PERIODO_FINAL, 
	DS_PARAMETRO_ATEND, DT_GERACAO, NM_USUARIO_GERACAO, 
	DT_MESANO_REFERENCIA, CD_CLASSIF_SETOR, IE_TIPO_ATEND_BPA, 
	DT_CONSISTENCIA, NR_SEQ_ENVIO_CONVENIO, DT_MESANO_REF_PAR, 
	DS_INCONSISTENCIA, DT_VENCIMENTO, DT_INTEGRACAO_CR, 
	DT_ENTREGA_CONVENIO, CD_INTERFACE_ENVIO, CD_ESTABELECIMENTO, 
	0, 0, 0, 
	NR_SEQ_DOC_CONVENIO, DT_DEFINITIVO 
from protocolo_convenio 
where nr_seq_protocolo = nr_seq_protocolo_p;
 
open c01;
loop 
	fetch c01 into	nr_aih_w, 
			nr_seq_aih_w, 
			nr_interno_conta_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
 
	CALL cancelar_conta_paciente(nr_interno_conta_w, nm_usuario_p, 'N');
 
	update	conta_paciente 
	set	nr_seq_protocolo	= nr_seq_prot_reje_w, 
		nr_protocolo		= Wheb_mensagem_pck.get_Texto(301930, 'NR_PROTOCOLO_W='|| nr_protocolo_w), /*'Estornadas - ' || nr_protocolo_w,*/ 
		ie_status_acerto	= 2 
	where	nr_seq_conta_origem	= nr_interno_conta_w 
	 and	ie_cancelamento		= 'E';
 
	update	conta_paciente 
	set	nr_seq_protocolo	= nr_seq_prot_novo_w, 
		nr_protocolo		= Wheb_mensagem_pck.get_Texto(301931, 'NR_PROTOCOLO_W='|| nr_protocolo_w ), /*'Novas - ' || nr_protocolo_w,*/ 
		ie_status_acerto	= 2 
	where	nr_seq_conta_origem	= nr_interno_conta_w 
	 and	coalesce(ie_cancelamento::text, '') = '';
end loop;
close c01;
 
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_estornar_aih_rejeitada ( nr_seq_protocolo_p bigint, nm_usuario_p text) FROM PUBLIC;

