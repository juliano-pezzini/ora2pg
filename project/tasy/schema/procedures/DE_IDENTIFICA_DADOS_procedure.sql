-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE de_identifica_dados () AS $body$
DECLARE


c_dados CURSOR FOR
SELECT trigger_name
from user_triggers;

r_dados c_dados%rowtype;
script varchar(1000);


BEGIN
	open c_dados;
		loop
			fetch c_dados into r_dados;
			EXIT WHEN NOT FOUND; /* apply on c_dados */
			script :=  'alter trigger '||r_dados.trigger_name||' disable';
			EXECUTE script;

		end loop;

	close c_dados;

update PESSOA_FISICA set NM_PESSOA_FISICA='XXXXXXXXXX' where NM_PESSOA_FISICA <> 'XXXXXXXXXX';
commit;
update PESSOA_FISICA set NM_ABREVIADO='XXXXXXXXXX' where NM_ABREVIADO <> 'XXXXXXXXXX';
commit;
update PESSOA_FISICA set NM_PESSOA_FISICA_SEM_ACENTO='XXXXXXXXXX' where NM_PESSOA_FISICA_SEM_ACENTO <> 'XXXXXXXXXX';
commit;
update PESSOA_FISICA set NM_PESSOA_PESQUISA='XXXXXXXXXX' where NM_PESSOA_PESQUISA <> 'XXXXXXXXXX';
commit;
update PESSOA_FISICA set NM_PRIMEIRO_NOME='XXXXXXXXXX' where NM_PRIMEIRO_NOME <> 'XXXXXXXXXX';
commit;
update PESSOA_FISICA set NM_SOBRENOME_MAE='XXXXXXXXXX' where NM_SOBRENOME_MAE <> 'XXXXXXXXXX';
commit;
update PESSOA_FISICA set NM_SOBRENOME_PAI='XXXXXXXXXX' where NM_SOBRENOME_PAI <> 'XXXXXXXXXX';
commit;
update PESSOA_FISICA set NM_SOCIAL='XXXXXXXXXX' where NM_SOCIAL <>'XXXXXXXXXX';
commit;
update PESSOA_FISICA set DS_FONETICA='XXXXXXXXXX' where DS_FONETICA <> 'XXXXXXXXXX';
commit;
update PESSOA_FISICA set NR_CPF='XXXXXXXXXX' where NR_CPF <> 'XXXXXXXXXX';
commit;
update PESSOA_FISICA set NR_IDENTIDADE='XXXXXXXXXX' where NR_IDENTIDADE <> 'XXXXXXXXXX';
commit;
update MEDICO set NM_GUERRA='XXXXXXXXXX' where NM_GUERRA <> 'XXXXXXXXXX';
commit;
update COMPL_PESSOA_FISICA set DS_EMAIL='email@email.com' where DS_EMAIL <> 'email@email.com';
commit;
update PESSOA_JURIDICA set DS_EMAIL='email@email.com' where DS_EMAIL <> 'email@email.com';
commit;
update PESSOA_JURIDICA_ESTAB set DS_EMAIL='email@email.com' where DS_EMAIL <> 'email@email.com';
commit;
update USUARIO set DS_EMAIL='email@email.com' where DS_EMAIL <> 'email@email.com';
commit;
update PESSOA_JURIDICA set NM_FANTASIA='XXXXXXXXXX' where NM_FANTASIA <> 'XXXXXXXXXX';
commit;
update PESSOA_JURIDICA set DS_RAZAO_SOCIAL='XXXXXXXXXX' where DS_RAZAO_SOCIAL <> 'XXXXXXXXXX';
commit;
update PESSOA_JURIDICA set NM_PESSOA_CONTATO='XXXXXXXXXX' where NM_PESSOA_CONTATO <> 'XXXXXXXXXX';
commit;
update AGENDA set DS_REMETENTE_EMAIL_CONFIRM='XXXXXXXXXX' where DS_REMETENTE_EMAIL_CONFIRM <> 'XXXXXXXXXX';
commit;
update AGENDA_PAC_CONSIGNADO_HIST set DS_EMAIL_LONG='XXXXXXXXXX';
commit;
update AGENDA_PACIENTE set DS_EMAIL='email@email.com' where DS_EMAIL <> 'email@email.com';
commit;
update AGENDA_PACIENTE set DS_SEQ_REGRA_EMAIL='XXXXXXXXXX' where DS_SEQ_REGRA_EMAIL <> 'XXXXXXXXXX';
commit;
update AGENDA_PACIENTE_ENVIO set DS_EMAIL='email@email.com' where DS_EMAIL <> 'email@email.com';
commit;
update AGENDA_PACIENTE_ENVIO set DS_EMAIL_LONG='XXXXXXXXXX';
commit;
update ALERTA_TASY_REGRA set DS_EMAIL_DESTINO='email@email.com' where DS_EMAIL_DESTINO <> 'email@email.com';
commit;
update ALTERACAO_TASY_SBIS set DS_EMAIL='email@email.com' where DS_EMAIL <> 'email@email.com';
commit;
update BSC_REGRA_COMUNIC_IND set DS_EMAIL_ORIGEM='email@email.com' where DS_EMAIL_ORIGEM <> 'email@email.com';
commit;
update CAN_INCA_ENVIO_LOTE_ITEM set DS_EMAIL='email@email.com' where DS_EMAIL <> 'email@email.com';
commit;
update CIH_LOG_POS_ALTA set DS_EMAIL='email@email.com' where DS_EMAIL <> 'email@email.com';
commit;
update CIH_PARAMETROS set DS_REMETENTE_EMAIL='XXXXXXXXXX' where DS_REMETENTE_EMAIL <> 'XXXXXXXXXX';
commit;
update CIH_REGRA_ENVIO_NOTIF set DS_EMAIL_SECRETARIA='XXXXXXXXXX' where DS_EMAIL_SECRETARIA <> 'XXXXXXXXXX';
commit;
update CLIENTE_TASY_COMPL set DS_EMAIL='email@email.com' where DS_EMAIL <> 'email@email.com';
commit;
update CLIENTE_TASY set DS_EMAIL='email@email.com' where DS_EMAIL <> 'email@email.com';
commit;
update COM_CANAL set DS_EMAIL_CONTATO='email@email.com' where DS_EMAIL_CONTATO <> 'email@email.com';
commit;
update COM_ENVIO_RELAT_OS set DS_EMAIL='email@email.com' where DS_EMAIL <> 'email@email.com';
commit;
update COMERCIAL_COMUNICADO_DEST set DS_EMAIL='email@email.com' where DS_EMAIL <> 'email@email.com';
commit;
update COMPL_AGENCIA_BANCARIA set DS_EMAIL='email@email.com' where DS_EMAIL <> 'email@email.com';
commit;
update COMPL_PESSOA_FISICA set DS_EMAIL='email@email.com' where DS_EMAIL <> 'email@email.com';
commit;
update COMPL_PESSOA_FISICA_HIST set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update COMPL_PF_TEL_ADIC set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update COMPRADOR set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update COM_SOLIC_LEAD set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update COM_SOLIC_SD_PARTIC set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update COMUNIC_EXTERNA_DEST set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update CONTRATO set EMAIL_CONTATO='XXXXXXXXXX' where EMAIL_CONTATO <> 'XXXXXXXXXX';
commit;
update CONTRATO_ESTAB_ADIC set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update CONV_USUARIO_EMPRESA set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update COT_COMPRA_FORN set DS_EMAIL_REGRA_PJ='XXXXXXXXXX' where DS_EMAIL_REGRA_PJ <> 'XXXXXXXXXX';
commit;
update CTA_REGRA_ENVIO_EMAIL set DS_EMAIL_DESTINO='email@email.com' where DS_EMAIL_DESTINO <> 'email@email.com';
commit;
update EMAIL_ENVIO_AUT_AGENDA set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update EMPRESA_INTEGR_DADOS set DS_EMAIL_AVISO='email@email.com' where DS_EMAIL_AVISO <> 'email@email.com';
commit;
update EMPRESA_INTEGR_DADOS set NM_USUARIO_EMAIL_AVISO='XXXXXXXXXX' where NM_USUARIO_EMAIL_AVISO <> 'XXXXXXXXXX';
commit;
update ENVIO_EMAIL_AGENDA set DS_CONTEUDO_EMAIL='XXXXXXXXXX' where DS_CONTEUDO_EMAIL <> 'XXXXXXXXXX';
commit;
update ENVIO_EMAIL_COMPRA_AGRUP set DS_EMAIL_ORIGEM='email@email.com' where DS_EMAIL_ORIGEM <> 'email@email.com';
commit;
update EQUIPAMENTO set DS_EMAIL_COMUNICACAO='XXXXXXXXXX' where DS_EMAIL_COMUNICACAO <> 'XXXXXXXXXX';
commit;
--update ES_NGTB_TELEFONE_COBR set DS_EMAIL='email@email.com' where DS_EMAIL <> 'email@email.com';
--commit;
update EV_EVENTO set DS_REMETENTE_EMAIL='XXXXXXXXXX' where DS_REMETENTE_EMAIL<> 'XXXXXXXXXX';
commit;
update EV_EVENTO_MANUAL set DS_REMETENTE_EMAIL='XXXXXXXXXX' where DS_REMETENTE_EMAIL<> 'XXXXXXXXXX';
commit;
update EV_EVENTO_PAC_DESTINO set DS_EMAIL_FIXO='email@email.com' where DS_EMAIL_FIXO <> 'email@email.com';
commit;
update EV_EVENTO_REGRA_DEST set DS_EMAIL_FIXO='email@email.com' where DS_EMAIL_FIXO <> 'email@email.com';
commit;
update INT_EQUIPE_PAPEL set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update LAB_PARAMETRO set DS_TEXTO_EMAIL_RECOLETA='XXXXXXXXXX' where DS_TEXTO_EMAIL_RECOLETA <> 'XXXXXXXXXX';
commit;
update LAB_PARAMETRO set NM_USUARIO_EMAIL_CONTINGENCIA='XXXXXXXXXX' where NM_USUARIO_EMAIL_CONTINGENCIA <> 'XXXXXXXXXX';
commit;
update LAB_REGRA_USUARIO_INTEGR set DS_EMAIL_CONTINGENCIA='email@email.com' where DS_EMAIL_CONTINGENCIA <> 'email@email.com';
commit;
update LAB_SOLIC_ACESSO_PORTAL set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update LAB_TASYLAB_CLIENTE set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update LAUDO_PACIENTE_ENVIO set DS_EMAIL_ENVIO='email@email.com' where DS_EMAIL_ENVIO <> 'email@email.com';
commit;
update LAUDO_PACIENTE_LOC_ENVIO set DS_EMAIL_DESTINO='XXXXXXXXXX' where DS_EMAIL_DESTINO <> 'XXXXXXXXXX';
commit;
update LAUDO_PACIENTE_LOC_ENVIO set DS_EMAIL_ORIGEM='XXXXXXXXXX' where DS_EMAIL_ORIGEM <> 'XXXXXXXXXX';
commit;
update LOG_ENVIO_EMAIL_CONTA set DS_EMAIL_DESTINO='XXXXXXXXXX' where DS_EMAIL_DESTINO <> 'XXXXXXXXXX';
commit;
update LOG_ENVIO_EMAIL_CONTA set DS_EMAIL_ORIGEM='XXXXXXXXXX' where DS_EMAIL_ORIGEM <> 'XXXXXXXXXX';
commit;
update LOTE_ENT_DRS set DS_EMAIL_DRS='XXXXXXXXXX' where DS_EMAIL_DRS <> 'XXXXXXXXXX';
commit;
update LOTE_ENT_INSTITUICAO set DS_EMAIL_INST='XXXXXXXXXX' where DS_EMAIL_INST <> 'XXXXXXXXXX';
commit;
update MAN_ORDEM_SERVICO_ORC set DS_CONTEUDO_EMAIL_APROV='XXXXXXXXXX' where DS_CONTEUDO_EMAIL_APROV <> 'XXXXXXXXXX';
commit;
update MAN_REGRA_ENVIO_ACOMP set DS_EMAIL_ORIGEM='XXXXXXXXXX' where DS_EMAIL_ORIGEM <> 'XXXXXXXXXX';
commit;
update MAN_REGRA_ENVIO_COMUNIC set DS_EMAIL_ORIGEM='XXXXXXXXXX' where DS_EMAIL_ORIGEM <> 'XXXXXXXXXX';
commit;
update MAN_REGRA_ENVIO_COMUNIC set DS_LISTA_EMAIL_DESTINO='XXXXXXXXXX' where DS_LISTA_EMAIL_DESTINO <> 'XXXXXXXXXX';
commit;
update MPREV_PROG_COORDENADOR set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update NEGOCIACAO_LOTE_AUDIT_ENV set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update NEGOCIACAO_LOTE_AUDIT_ENV set DS_EMAIL_DESTINATARIOS='XXXXXXXXXX' where DS_EMAIL_DESTINATARIOS <> 'XXXXXXXXXX';
commit;
update NEGOCIACAO_LOTE_AUDIT_ENV set DS_EMAIL_REMETENTE='XXXXXXXXXX' where DS_EMAIL_REMETENTE <> 'XXXXXXXXXX';
commit;
update ORCAMENTO_PAC_CONTATO set DS_EMAIL_MEDICO='XXXXXXXXXX' where DS_EMAIL_MEDICO <> 'XXXXXXXXXX';
commit;
update ORCAMENTO_PAC_CONTATO set DS_EMAIL_SOLIC='XXXXXXXXXX' where DS_EMAIL_SOLIC <> 'XXXXXXXXXX';
commit;
update ORDEM_COMPRA set DS_EMAIL_REGRA_PJ='XXXXXXXXXX' where DS_EMAIL_REGRA_PJ <> 'XXXXXXXXXX';
commit;
update ORDEM_COMPRA set DT_ENVIO_EMAIL='01/01/01' where DT_ENVIO_EMAIL <> '01/01/01';
commit;
update PARAMETRO_AGENDA set DS_EMAIL_ATEND_CONS='XXXXXXXXXX' where DS_EMAIL_ATEND_CONS <> 'XXXXXXXXXX';
commit;
update PARAMETRO_AGENDA set DS_EMAIL_ATEND_EXAME='XXXXXXXXXX' where DS_EMAIL_ATEND_EXAME <> 'XXXXXXXXXX';
commit;
update PARAMETRO_AGENDA set DS_REM_EMAIL_ATEND_CONS='XXXXXXXXXX' where DS_REM_EMAIL_ATEND_CONS <> 'XXXXXXXXXX';
commit;
update PARAMETRO_AGENDA set DS_REM_EMAIL_ATEND_EXAME='XXXXXXXXXX' where DS_REM_EMAIL_ATEND_EXAME <> 'XXXXXXXXXX';
commit;
update PARAMETRO_AGENDA set DS_REM_EMAIL_CONFIRM='XXXXXXXXXX' where DS_REM_EMAIL_CONFIRM <> 'XXXXXXXXXX';
commit;
update PARAMETRO_AGENDA set DS_TIT_EMAIL_ATEND_CONS='XXXXXXXXXX' where DS_TIT_EMAIL_ATEND_CONS <> 'XXXXXXXXXX';
commit;
update PARAMETRO_AGENDA set DS_TIT_EMAIL_ATEND_EXAME='XXXXXXXXXX' where DS_TIT_EMAIL_ATEND_EXAME <> 'XXXXXXXXXX';
commit;
update PARAMETRO_AGENDA set DS_TIT_EMAIL_CONFIRM='XXXXXXXXXX' where DS_TIT_EMAIL_CONFIRM <> 'XXXXXXXXXX';
commit;
update PARAMETRO_AGENDA_WEB set DS_EMAIL_SENHA='XXXXXXXXXX' where DS_EMAIL_SENHA <> 'XXXXXXXXXX';
commit;
update PARAMETRO_AGENDA_WEB set DS_TITULO_EMAIL_SENHA='XXXXXXXXXX' where DS_TITULO_EMAIL_SENHA <> 'XXXXXXXXXX';
commit;
update PARAMETRO_AVALIACAO set DS_TEXTO_PADRAO_EMAIL='XXXXXXXXXX' where DS_TEXTO_PADRAO_EMAIL <> 'XXXXXXXXXX';
commit;
update PARAMETRO_COMPRAS set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PAT_REGRA_ENVIO_AVISO set DS_EMAIL_ADICIONAL='XXXXXXXXXX' where DS_EMAIL_ADICIONAL <> 'XXXXXXXXXX';
commit;
update PAT_REGRA_ENVIO_AVISO set DS_EMAIL_REMETENTE='XXXXXXXXXX' where DS_EMAIL_REMETENTE <> 'XXXXXXXXXX';
commit;
update PEP_MED_FATUR_ENVIO set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PEP_MED_FATUR_ENVIO set DS_EMAIL_LONG='XXXXXXXXXX';
commit;
update PESSOA_FISICA set DS_EMAIL_CCIH='XXXXXXXXXX' where DS_EMAIL_CCIH <> 'XXXXXXXXXX';
commit;
update PESSOA_JURIDICA_COMPL set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PESSOA_JURIDICA_CONT_ESTR set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PESSOA_JURIDICA set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PESSOA_JURIDICA_ENVIO set DS_EMAIL_DESTINO='XXXXXXXXXX' where DS_EMAIL_DESTINO <> 'XXXXXXXXXX';
commit;
update PESSOA_JURIDICA_ESTAB set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PJ_REGRA_ENVIO_USUARIO set DS_EMAIL_ADICIONAL='XXXXXXXXXX' where DS_EMAIL_ADICIONAL <> 'XXXXXXXXXX';
commit;
update PLS_ALERTA_EVENT_DEST_FIXO set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_ALERTA_EVENTO_MENSAGEM set DS_REMETENTE_EMAIL='XXXXXXXXXX' where DS_REMETENTE_EMAIL<> 'XXXXXXXXXX';
commit;
update PLS_ANALISE_AUT_EMAIL set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_ANALISE_AUT_EMAIL set DS_REGRA_EMAIL='XXXXXXXXXX' where DS_REGRA_EMAIL <> 'XXXXXXXXXX';
commit;
update PLS_AUDITORIA set DS_EMAIL_BENEFICIARIO='XXXXXXXXXX' where DS_EMAIL_BENEFICIARIO <> 'XXXXXXXXXX';
commit;
update PLS_AUTORIZACAO_EMAIL set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_AUTORIZACAO_EMAIL set DS_EMAIL_REMETENTE='XXXXXXXXXX' where DS_EMAIL_REMETENTE <> 'XXXXXXXXXX';
commit;
update PLS_COMUNICA_INTER_PREST set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_COMUNIC_EXT_HIST_WEB set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_CONG_AUTOR_INTERCAMBIO set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_CONTRATO_CONTATO set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_CONTRATO_PAGADOR set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_CPM_PRESTADOR set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_ESTIPULANTE_WEB set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_FORNEC_MAT_FED_SC set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_INCLUSAO_BENEFICIARIO set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_INCLUSAO_BENEFICIARIO set DS_EMAIL_CORRESP='XXXXXXXXXX' where DS_EMAIL_CORRESP <> 'XXXXXXXXXX';
commit;
update PLS_INCLUSAO_COOPERADO set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_INCLUSAO_PRESTADOR set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_LOTE_ANEXO_GUIAS_AUT set DS_EMAIL_PROF_SOLIC='XXXXXXXXXX' where DS_EMAIL_PROF_SOLIC <> 'XXXXXXXXXX';
commit;
update PLS_LOTE_ANEXO_GUIAS_IMP set DS_EMAIL_PROF_SOLIC='XXXXXXXXXX' where DS_EMAIL_PROF_SOLIC <> 'XXXXXXXXXX';
commit;
update PLS_MALA_DIRETA set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_MENS_PAGADOR_IR set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_MOVIMENTACAO_BENEF set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_OUTORGANTE set DS_EMAIL_ANS='XXXXXXXXXX' where DS_EMAIL_ANS <> 'XXXXXXXXXX';
commit;
update PLS_PARAMETROS set DS_CONTEUDO_EMAIL='XXXXXXXXXX' where DS_CONTEUDO_EMAIL <> 'XXXXXXXXXX';
commit;
update PLS_PESSOA_INCONSISTENTE set DT_ENVIO_EMAIL='123456' where DT_ENVIO_EMAIL <> '123456';
commit;
update PLS_PRESTADOR_EMAIL set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_PROCESSO_PRESTADOR set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_RADAR_PERGUNTA11 set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_REGRA_ADICIONAL_ATEND set DS_ASSINATURA_EMAIL='XXXXXXXXXX' where DS_ASSINATURA_EMAIL <> 'XXXXXXXXXX';
commit;
update PLS_REGRA_COMPL_ANEXO_OPME set DS_EMAIL_ENVIO='XXXXXXXXXX' where DS_EMAIL_ENVIO <> 'XXXXXXXXXX';
commit;
update PLS_REGRA_FAX_ANALISE set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_REGRA_FAX_ANALISE set DS_EMAIL_DESTINO='XXXXXXXXXX' where DS_EMAIL_DESTINO <> 'XXXXXXXXXX';
commit;
update PLS_REGRA_FAX_ANALISE set DS_REGRA_EMAIL='XXXXXXXXXX' where DS_REGRA_EMAIL <> 'XXXXXXXXXX';
commit;
update PLS_REGRA_PREST_ANEXO_OPME set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_SIMULACAO_PRECO set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_SOLICITACAO_CHAT set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_SOLICITACAO_COMERCIAL set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_SOLICITACAO_VEND_HIST set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_SOLIC_LIB_MAT_MED set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_TIPO_POS_ESTABELECIDO set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_USUARIO_WEB set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PLS_W_IMPORT_CAD_UNIMED set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PRESCR_MEDICA_ENTREGA set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PROJ_ATA_PARTICIPANTE set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PROJ_EQUIPE_PAPEL set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PTU_MOV_BENEF_PF_COMPL set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update PTU_PEDIDO_AUT_ANEXO set DS_EMAIL_PROF_SOLIC='XXXXXXXXXX' where DS_EMAIL_PROF_SOLIC <> 'XXXXXXXXXX';
commit;
update PTU_PEDIDO_AUTORIZACAO set DS_EMAIL_PROF_SOLIC='XXXXXXXXXX' where DS_EMAIL_PROF_SOLIC <> 'XXXXXXXXXX';
commit;
update PTU_PEDIDO_COMPL_AUT set DS_EMAIL_PROF_SOLIC='XXXXXXXXXX' where DS_EMAIL_PROF_SOLIC <> 'XXXXXXXXXX';
commit;
update PTU_PRESTADOR_ENDERECO set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update QUA_REGRA_ENVIO_COMUNIC set DS_EMAIL_ORIGEM='XXXXXXXXXX' where DS_EMAIL_ORIGEM <> 'XXXXXXXXXX';
commit;
update RAMAL_INTERNO set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update REGRA_AVISO_PESSOA_CNS set DS_EMAIL_ENVIO='XXXXXXXXXX' where DS_EMAIL_ENVIO <> 'XXXXXXXXXX';
commit;
update REGRA_AVISO_TROCA_CONVENIO set DS_EMAIL_ENVIO='XXXXXXXXXX' where DS_EMAIL_ENVIO <> 'XXXXXXXXXX';
commit;
update REGRA_COM_AUT_CONV_DEST set DS_EMAIL_DESTINO='XXXXXXXXXX' where DS_EMAIL_DESTINO <> 'XXXXXXXXXX';
commit;
update REGRA_COMUNIC_AUTOR_CONV set DS_EMAIL_ORIGEM='XXXXXXXXXX' where DS_EMAIL_ORIGEM <> 'XXXXXXXXXX';
commit;
update REGRA_COMUNIC_NEGOC_AUDIT set DS_EMAIL_REMETENTE='XXXXXXXXXX' where DS_EMAIL_REMETENTE <> 'XXXXXXXXXX';
commit;
update REGRA_COMUNIC_NEGOC_DEST set DS_EMAIL_DESTINARIO='XXXXXXXXXX' where DS_EMAIL_DESTINARIO <> 'XXXXXXXXXX';
commit;
update REGRA_COMUNIC_VENC_DOC_PF set DS_EMAIL_ORIGEM='XXXXXXXXXX' where DS_EMAIL_ORIGEM <> 'XXXXXXXXXX';
commit;
update REGRA_COMUNIC_VENC_DOC_PF set DS_LISTA_EMAIL_DESTINO='XXXXXXXXXX' where DS_LISTA_EMAIL_DESTINO <> 'XXXXXXXXXX';
commit;
update REGRA_EMAIL_AGENDA_CANC set DS_TITULO_EMAIL='XXXXXXXXXX' where DS_TITULO_EMAIL <> 'XXXXXXXXXX';
commit;
update REGRA_EMAIL_ALTA set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update REGRA_EMAIL_EXAME_CANC set DS_TITULO_EMAIL='XXXXXXXXXX' where DS_TITULO_EMAIL <> 'XXXXXXXXXX';
commit;
update REGRA_EMAIL_PARECER set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update REGRA_ENVIO_AUTORIZACAO set DS_EMAIL_REMETENTE='XXXXXXXXXX' where DS_EMAIL_REMETENTE <> 'XXXXXXXXXX';
commit;
update REGRA_ENVIO_COMUN_PROTDOC set DS_EMAIL_ORIGEM='XXXXXXXXXX' where DS_EMAIL_ORIGEM <> 'XXXXXXXXXX';
commit;
update REGRA_ENVIO_COMUN_PROTDOC set DS_LISTA_EMAIL_DESTINO='XXXXXXXXXX' where DS_LISTA_EMAIL_DESTINO <> 'XXXXXXXXXX';
commit;
update REGRA_ENVIO_EMAIL_AGENDA set DS_EMAIL_DESTINO='XXXXXXXXXX' where DS_EMAIL_DESTINO <> 'XXXXXXXXXX';
commit;
update REGRA_ENVIO_EMAIL_AUTO set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update REGRA_ENVIO_EMAIL_COMPRA set DS_EMAIL_ADICIONAL='XXXXXXXXXX' where DS_EMAIL_ADICIONAL <> 'XXXXXXXXXX';
commit;
update REGRA_ENVIO_EMAIL_COMPRA set DS_EMAIL_REMETENTE='XXXXXXXXXX' where DS_EMAIL_REMETENTE <> 'XXXXXXXXXX';
commit;
update REGRA_ENVIO_EMAIL_INT_DEST set DS_EMAIL_DESTINO='XXXXXXXXXX' where DS_EMAIL_DESTINO <> 'XXXXXXXXXX';
commit;
update REGRA_ENVIO_EMAIL_INT set DS_EMAIL_ORIGEM='XXXXXXXXXX' where DS_EMAIL_ORIGEM <> 'XXXXXXXXXX';
commit;
update REGRA_ENVIO_EMAIL_MATERIAL set DS_EMAIL_DESTINO='XXXXXXXXXX' where DS_EMAIL_DESTINO <> 'XXXXXXXXXX';
commit;
update REGRA_ENVIO_LOC_LAUDO set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update REGRA_ENVIO_LOC_LAUDO set DS_EMAIL_ORIGEM='XXXXXXXXXX' where DS_EMAIL_ORIGEM <> 'XXXXXXXXXX';
commit;
update REGRA_ENVIO_NOVO_USU_PF set DS_EMAIL_DESTINO='XXXXXXXXXX' where DS_EMAIL_DESTINO <> 'XXXXXXXXXX';
commit;
update REGRA_LAUDO_LOC_EMAIL set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update REGRA_LAUDO_LOC_EMAIL set NM_USUARIO_ENVIO_EMAIL='XXXXXXXXXX' where NM_USUARIO_ENVIO_EMAIL <> 'XXXXXXXXXX';
commit;
update REGRA_LOC_CAMAREIRA set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update REGRA_STATUS_PAC_EMAIL set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update REL_AUTO_EMAIL_PADRAO set DS_EMAIL_PADRAO='XXXXXXXXXX' where DS_EMAIL_PADRAO <> 'XXXXXXXXXX';
commit;
update SAC_BOL_OCOR_ADIC set DS_EMAIL_PF_REGISTRO='XXXXXXXXXX' where DS_EMAIL_PF_REGISTRO <> 'XXXXXXXXXX';
commit;
update SAC_CARTA_RESPOSTA set DS_EMAIL_DESTINO='XXXXXXXXXX' where DS_EMAIL_DESTINO <> 'XXXXXXXXXX';
commit;
update SAC_CONTATO set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update SAC_REGRA_ENVIO_COMUNIC set DS_EMAIL_ORIGEM='XXXXXXXXXX' where DS_EMAIL_ORIGEM <> 'XXXXXXXXXX';
commit;
update SAC_REGRA_ENVIO_COMUNIC set DS_LISTA_EMAIL_DESTINO='XXXXXXXXXX' where DS_LISTA_EMAIL_DESTINO <> 'XXXXXXXXXX';
commit;
update SAN_DOADOR_ENVIO set DT_ENVIO_EMAIL='01/01/01' where DT_ENVIO_EMAIL <> '01/01/01';
commit;
update SAN_ENVIO_EMAIL set DS_TITULO_EMAIL='XXXXXXXXXX' where DS_TITULO_EMAIL <> 'XXXXXXXXXX';
commit;
update SAN_PARAMETRO set DS_MENSAGEM_EMAIL_APTO='XXXXXXXXXX' where DS_MENSAGEM_EMAIL_APTO<> 'XXXXXXXXXX';
commit;
update SETOR_ATENDIMENTO set DS_EMAIL_PADRAO='XXXXXXXXXX' where DS_EMAIL_PADRAO <> 'XXXXXXXXXX';
commit;
update SPA_HIST_EMAIL_DESTINO set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update SPA_REGRA_EMAIL set DS_EMAIL_ORIGEM='XXXXXXXXXX' where DS_EMAIL_ORIGEM <> 'XXXXXXXXXX';
commit;
update SUP_INT_PF set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update SUP_INT_PJ set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update SUP_LOG_INTEGRACAO set DT_ENVIO_EMAIL='XXXXXXXXXX' where DT_ENVIO_EMAIL <> 'XXXXXXXXXX';
commit;
update SUPORTE_COMUNICADO_DEST set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update SUS_FPO_REGRA_ALERTA set DS_EMAIL_ORIGEM='XXXXXXXXXX' where DS_EMAIL_ORIGEM <> 'XXXXXXXXXX';
commit;
update TASY_REGEDIT set DS_DIR_EMAIL='XXXXXXXXXX' where DS_DIR_EMAIL <> 'XXXXXXXXXX';
commit;
update TASY_REGEDIT set DS_EMAIL_LOGO_FILE='XXXXXXXXXX' where DS_EMAIL_LOGO_FILE <> 'XXXXXXXXXX';
commit;
update TERCEIRO_CONTA_ENVIO set DS_EMAIL_DESTINATARIO='XXXXXXXXXX' where DS_EMAIL_DESTINATARIO <> 'XXXXXXXXXX';
commit;
update TERCEIRO_CONTA_ENVIO set DS_EMAIL_REMETENTE='XXXXXXXXXX' where DS_EMAIL_REMETENTE <> 'XXXXXXXXXX';
commit;
update TERCEIRO set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update TERCEIRO set DS_TEXTO_EMAIL='XXXXXXXXXX' where DS_TEXTO_EMAIL <> 'XXXXXXXXXX';
commit;
update TEXTO_SATISF_ATEND set DS_EMAIL_ORIGEM='XXXXXXXXXX' where DS_EMAIL_ORIGEM <> 'XXXXXXXXXX';
commit;
update TISS_ANEXO_GUIA set DS_EMAIL_CONTRAT='XXXXXXXXXX' where DS_EMAIL_CONTRAT <> 'XXXXXXXXXX';
commit;
update TISS_PARAMETROS_CONVENIO set DS_EMAIL_AUTOR='XXXXXXXXXX' where DS_EMAIL_AUTOR <> 'XXXXXXXXXX';
commit;
update TRE_ENVIO_CERTIFICADO_PJ set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update TRE_EVENTO set DS_EMAIL_CERTIFICADO='XXXXXXXXXX' where DS_EMAIL_CERTIFICADO <> 'XXXXXXXXXX';
commit;
update TRE_LOG_ENVIO_AVAL set DS_EMAIL_DESTINO='XXXXXXXXXX' where DS_EMAIL_DESTINO <> 'XXXXXXXXXX';
commit;
update TRE_LOG_ENVIO_AVAL set DS_EMAIL_ORIGEM='XXXXXXXXXX' where DS_EMAIL_ORIGEM <> 'XXXXXXXXXX';
commit;
update USUARIO_CONTATO set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update USUARIO_CORREIO set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update USUARIO set DS_CONTA_EMAIL='XXXXXXXXXX' where DS_CONTA_EMAIL <> 'XXXXXXXXXX';
commit;
update USUARIO set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update USUARIO set DS_SENHA_EMAIL='XXXXXXXXXX' where DS_SENHA_EMAIL <> 'XXXXXXXXXX';
commit;
update USUARIO set DS_TEXTO_EMAIL='XXXXXXXXXX' where DS_TEXTO_EMAIL <> 'XXXXXXXXXX';
commit;
update W_CONSULTA_BENEFICIARIO set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update W_DIOPS_CAD_EMP_DEPEND set DS_EMAIL_DOIS='XXXXXXXXXX' where DS_EMAIL_DOIS='XXXXXXXXXX';
commit;
update W_DIOPS_CAD_EMP_DEPEND set DS_EMAIL_UM='XXXXXXXXXX' where DS_EMAIL_UM <> 'XXXXXXXXXX';
commit;
update W_DIOPS_CAD_IDENTIF set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update W_DIOPS_CAD_IDENTIF set DS_EMAIL_REPRE_DOIS='XXXXXXXXXX' where DS_EMAIL_REPRE_DOIS <> 'XXXXXXXXXX';
commit;
update W_DIOPS_CAD_IDENTIF set DS_EMAIL_REPRE_RN117='XXXXXXXXXX' where DS_EMAIL_REPRE_RN117 <> 'XXXXXXXXXX';
commit;
update W_DIOPS_CAD_IDENTIF set DS_EMAIL_REPRE_UM='XXXXXXXXXX' where DS_EMAIL_REPRE_UM <> 'XXXXXXXXXX';
commit;
update W_EMAIL_LAUDO set DS_EMAIL='email@email.com';
commit;
update W_ENVIO_DCTF set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update W_ENVIO_DCTF set DS_EMAIL_REPRESENTANTE='XXXXXXXXXX' where DS_EMAIL_REPRESENTANTE <> 'XXXXXXXXXX';
commit;
update W_ENVIO_DCTF set DS_EMAIL_RESP='XXXXXXXXXX' where DS_EMAIL_RESP <> 'XXXXXXXXXX';
commit;
update W_ENVIO_DIRF set DS_EMAIL_RESP='XXXXXXXXXX' where DS_EMAIL_RESP <> 'XXXXXXXXXX';
commit;
update W_EXAME_DIAG_IMAGEM_SUS set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update W_GESTAO_EXAME set DS_EMAIL_MEDICO_PRESCR='XXXXXXXXXX' where DS_EMAIL_MEDICO_PRESCR <>'XXXXXXXXXX';
commit;
update W_GUIA_MEDICO_MALA_DIRETA set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
--update W_HSVP_SEFIP set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
--commit;
update W_IMPORTA_CLIENTES set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update W_INTEGRACAO_PF_ATUALIZA set DS_EMAIL='email@email.com' where DS_EMAIL<> 'email@email.com';
commit;
update W_NEO_PROFISSIONAL set EMAIL='email@email.com' where EMAIL <> 'email@email.com';
commit;
update W_PESSOA_FISICA_LOC set DS_EMAIL='email@email.com' where DS_EMAIL <> 'email@email.com';
commit;
--update W_PF_DW set DS_EMAIL='email@email.com' where DS_EMAIL='email@email.com';
--commit;
update W_PLS_CARGA_COMERCIAL set DS_EMAIL='email@email.com' where DS_EMAIL <> 'email@email.com';
commit;
update W_PLS_GUIA_MEDICO set DS_EMAIL='email@email.com' where DS_EMAIL <> 'email@email.com';
commit;
update W_PROTHEUS_FORNECEDOR set DS_EMAIL='email@email.com' where DS_EMAIL <> 'email@email.com';
commit;
update W_SINTESE_FORNEC set DS_EMAIL='email@email.com' where DS_EMAIL <> 'email@email.com';
commit;
update W_SUSAPAC_INTERF set DS_EMAIL='email@email.com' where DS_EMAIL <> 'email@email.com';
commit;
update W_SUSBPA_INTERF set DS_EMAIL='email@email.com' where DS_EMAIL <> 'email@email.com';
commit;
update W_TISS_CONTRATADO_SOLIC set DS_EMAIL_CONTRAT='XXXXXXXXXX' where DS_EMAIL_CONTRAT <> 'XXXXXXXXXX';
commit;

open c_dados;
	loop
		fetch c_dados into r_dados;
		EXIT WHEN NOT FOUND; /* apply on c_dados */
			script :=  'alter trigger '||r_dados.trigger_name||' enable';
		EXECUTE script;

	end loop;

close c_dados;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE de_identifica_dados () FROM PUBLIC;

