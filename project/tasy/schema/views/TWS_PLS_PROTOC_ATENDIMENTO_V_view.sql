-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tws_pls_protoc_atendimento_v (nr_sequencia, dt_atualizacao, dt_atualizacao_nrec, nr_protocolo, nr_protocolo_referencia, ie_origem_protocolo, ie_status, nr_seq_segurado, nr_seq_guia, nr_seq_requisicao, nr_seq_atend_pls) AS select 	nr_sequencia,
	dt_atualizacao,
	dt_atualizacao_nrec,
	nr_protocolo,
	nr_protocolo_referencia,
	ie_origem_protocolo,
	ie_status,
	nr_seq_segurado,
	nr_seq_guia,
	nr_seq_requisicao,
	nr_seq_atend_pls
FROM 	pls_protocolo_atendimento;

