-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_conta_intercambio_v (nr_sequencia, ie_tipo_conta_interc, nr_seq_congenere, ie_tipo_intercambio, sg_estado_congenere, ie_tipo_contrato, nr_seq_intercambio) AS select	a.nr_sequencia,
	a.ie_tipo_conta ie_tipo_conta_interc, 
	-- Functions 
	coalesce(a.nr_seq_congenere, b.nr_seq_congenere) nr_seq_congenere, 
	pls_obter_tipo_intercambio(coalesce(a.nr_seq_congenere, b.nr_seq_congenere), a.cd_estabelecimento) ie_tipo_intercambio, 
	pls_obter_estado_congenere(coalesce(a.nr_seq_congenere, b.nr_seq_congenere), a.cd_estabelecimento) sg_estado_congenere, 
	pls_obter_dados_segurado(a.nr_seq_segurado,'TCI') ie_tipo_contrato, 
	pls_obter_dados_segurado(a.nr_seq_segurado,'NRCI') nr_seq_intercambio 
FROM	pls_conta		a, 
	pls_protocolo_conta	b 
where	a.ie_tipo_conta <> 'O' 
and	b.nr_sequencia = a.nr_seq_protocolo;

